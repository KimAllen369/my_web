<?php
// 数据库连接配置
$host = 'localhost';
$dbname = 'divination_db';
$username = 'root';  // XAMPP默认root无密码
$password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("数据库连接失败: " . $e->getMessage());
}
?>