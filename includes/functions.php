<?php
require_once '../config/db.php';

// 1. 中文分词函数（使用SCWS）
function extract_keywords($text) {
    $stopwords = ['的', '了', '有', '在'];
    $scws = scws_new();
    $scws->set_charset('utf8');
    $scws->set_dict('C:\xampp\php\ext\scws\etc\dict.utf8.xdb');  // SCWS词典路径（需下载）
    $scws->send_text($text);
    $words = [];
    while ($res = $scws->get_result()) {
        foreach ($res as $word) {
            if (!in_array($word['word'], $stopwords)) {
                $words[] = $word['word'];
            }
        }
    }
    $scws->close();
    return array_unique($words);  // 去重
}

// 2. 关键词映射五行函数
function map_to_elements($keywords) {
    global $pdo;
    $elements = [];
    foreach ($keywords as $word) {
        $stmt = $pdo->prepare("SELECT element FROM keyword_five_elements WHERE keyword=?");
        $stmt->execute([$word]);
        if ($elem = $stmt->fetchColumn()) {
            $elements[] = $elem;
        }
    }
    return $elements;
}

// 3. 生辰八字基础五行计算（简化示例）
function calculate_birth_elements($year, $month, $day, $hour) {
    // 实际需结合天干地支，此处为示例
    return [
        '木' => 0.2,
        '火' => 0.1,
        '土' => 0.15,
        '金' => 0.1,
        '水' => 0.45
    ];
}

// 4. 动态事件权重调整
function adjust_elements($base_elements, $event_elements) {
    $adjusted = $base_elements;
    foreach ($event_elements as $elem) {
        $adjusted[$elem] = min($adjusted[$elem] + 0.1, 0.9);  // 上限0.9
        // 负面事件额外调整（如“争吵”属火）
        if ($elem === '火' && in_array('争吵', $event_elements)) {
            $adjusted[$elem] = min($adjusted[$elem] + 0.2, 0.9);
        }
    }
    return $adjusted;
}

// 5. 卦象生成函数
function generate_hexagram($adjusted_elements) {
    arsort($adjusted_elements);  // 按值降序排序
    $ti_element = key($adjusted_elements);
    next($adjusted_elements);
    $yong_element = key($adjusted_elements);

    $hexagram_map = [
        '木火' => '木火通明（吉）',
        '火土' => '火土相生（平）',
        '土金' => '土金吐秀（吉）',
        '金水' => '金水相涵（吉）',
        '水木' => '水木清华（吉）',
        '木金' => '金木相战（凶）',
        '火水' => '水火不容（凶）',
        '土水' => '土水相困（平）'
    ];
    $key = $ti_element . $yong_element;
    return $hexagram_map[$key] ?? '未明之象（需详细解析）';
}
?>