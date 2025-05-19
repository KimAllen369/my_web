<?php
require_once '../includes/functions.php';
session_start();

// 检查用户是否为会员（简化逻辑）
$user_id = $_SESSION['user_id'] ?? null;
if (!$user_id) {
    die("请登录后查看详细解析");
}

// 查询用户会员状态
$stmt = $pdo->prepare("SELECT is_member, member_expire FROM user WHERE user_id=?");
$stmt->execute([$user_id]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);
if (!$user['is_member'] || $user['member_expire'] < date('Y-m-d')) {
    die("您不是会员或会员已过期");
}

// 获取记录ID
$record_id = $_GET['record_id'];
$stmt = $pdo->prepare("SELECT * FROM divination_record WHERE record_id=?");
$stmt->execute([$record_id]);
$record = $stmt->fetch(PDO::FETCH_ASSOC);
$five_elements = json_decode($record['five_elements'], true);

// 解析体卦和用卦
arsort($five_elements);
$ti_element = key($five_elements);
next($five_elements);
$yong_element = key($five_elements);

// 生成详细建议
$interaction = get_interaction($ti_element, $yong_element);
$advice = get_advice($yong_element);
$fortune_advice = get_fortune_advice($ti_element, $yong_element);

function get_interaction($ti, $yong) {
    $sheng = [['木','火'], ['火','土'], ['土','金'], ['金','水'], ['水','木']];
    $ke = [['木','金'], ['金','木'], ['火','水'], ['水','火'], ['土','木']];
    if (in_array([$ti, $yong], $sheng)) return '相生';
    if (in_array([$ti, $yong], $ke)) return '相克';
    return '平衡';
}

function get_advice($element) {
    $advice = [
        '木' => '近期可多接触绿植，提升木属性平衡',
        '火' => '避免争吵，注意情绪管理',
        '土' => '可参与户外活动，增强土属性稳定',
        '金' => '佩戴金属饰品，平衡金属性能量',
        '水' => '注意防水，避免湿滑环境'
    ];
    return $advice[$element] ?? '保持当前状态即可';
}

function get_fortune_advice($ti, $yong) {
    $advice = [
        '木火' => '近期运势上升，适合主动出击',
        '火土' => '运势平稳，宜稳中求进',
        '土金' => '财运向好，可关注投资机会',
        '金水' => '人际关系和谐，多与朋友交流',
        '水木' => '事业有新机遇，抓住时机',
        '木金' => '注意冲突，避免冲动决策',
        '火水' => '运势波动，需谨慎行事',
        '土水' => '近期宜保守，避免风险'
    ];
    return $advice[$ti.$yong] ?? '建议保持观察，静待时机';
}
?>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>详细解析</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-center">详细解析</h2>
        <div class="card">
            <div class="card-body">
                <p>体卦（自身能量）：<?= $ti_element ?></p>
                <p>用卦（外部影响）：<?= $yong_element ?></p>
                <p>五行关系：<?= $interaction ?></p>
                <p>事件影响：您描述的“<?= htmlspecialchars($record['event_desc']) ?>”增加了<?= $yong_element ?>属性能量，<?= $advice ?></p>
                <p>吉凶建议：<?= $fortune_advice ?></p>
            </div>
        </div>
    </div>
</body>
</html>