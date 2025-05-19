<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>AI动态解卦</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../static/style.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="text-center">AI动态解卦</h1>
        <form action="result.php" method="POST">
            <div class="mb-3">
                <label class="form-label">生辰八字（阳历）</label>
                <div class="row">
                    <div class="col-3"><input type="number" name="year" placeholder="年份" class="form-control" required></div>
                    <div class="col-3"><input type="number" name="month" placeholder="月份" class="form-control" required></div>
                    <div class="col-3"><input type="number" name="day" placeholder="日期" class="form-control" required></div>
                    <div class="col-3"><input type="number" name="hour" placeholder="小时（0-23）" class="form-control" required></div>
                </div>
            </div>
            <div class="mb-3">
                <label class="form-label">当前事件描述（如“湿了鞋”）</label>
                <textarea name="event_desc" class="form-control" rows="3" required></textarea>
            </div>
            <div class="mb-3">
                <label class="form-label">环境描述（如“雨天，有绿植”）</label>
                <textarea name="environment" class="form-control" rows="3" required></textarea>
            </div>
            <button type="submit" class="btn btn-primary w-100">立即测算</button>
        </form>
    </div>
</body>
</html>