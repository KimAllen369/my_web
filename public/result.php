<?php
require_once '../includes/functions.php';

// 获取表单数据
$year = $_POST['year'];
$month = $_POST['month'];
$day = $_POST['day'];
$hour = $_POST['hour'];
$event_desc = $_POST['event_desc'];
$environment = $_POST['environment'];

// 提取关键词并映射五行
$keywords = extract_keywords($event_desc . $environment);
$event_elements = map_to_elements($keywords);

// 计算基础五行
$base_elements = calculate_birth_elements($year, $month, $day, $hour);

// 动态调整五行能量
$adjusted_elements = adjust_elements($base_elements, $event_elements);

// 生成卦象
$hexagram = generate_hexagram($adjusted_elements);

// 保存记录（游客模式，user_id为NULL）
$five_elements_json = json_encode($adjusted_elements);
$stmt = $pdo->prepare("INSERT INTO divination_record (birth_year, birth_month, birth_day, birth_hour, event_desc, environment, five_elements, hexagram) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
$stmt->execute([$year, $month, $day, $hour, $event_desc, $environment, $five_elements_json, $hexagram]);
$record_id = $pdo->lastInsertId();  // 获取记录ID
?>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>解卦结果</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-center">解卦结果</h2>
        <div class="card">
            <div class="card-body">
                <p>您当前的卦象为：<strong><?= htmlspecialchars($hexagram) ?></strong></p>
                <p>事件描述：<?= htmlspecialchars($event_desc) ?></p>
                <?php if (isset($_SESSION['user_id'])): ?>  <!-- 假设用户已登录 -->
                    <a href="detailed.php?record_id=<?= $record_id ?>" class="btn btn-primary mt-3">查看详细解析</a>
                <?php else: ?>
                    <a href="login.php" class="btn btn-primary mt-3">登录/注册查看详细解析</a>
                <?php endif; ?>
            </div>
        </div>
    </div>
</body>
</html>