-- 用户表（存储用户信息）
CREATE TABLE IF NOT EXISTS `user` (
    `user_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(50) UNIQUE NOT NULL,
    `password` VARCHAR(255) NOT NULL,  -- 存储密码哈希
    `is_member` TINYINT(1) DEFAULT 0,  -- 0=非会员，1=会员
    `member_expire` DATE DEFAULT NULL
);

-- 卦象记录表（存储测算记录）
CREATE TABLE IF NOT EXISTS `divination_record` (
    `record_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT UNSIGNED,  -- 外键关联user表（可为NULL表示游客）
    `birth_year` INT NOT NULL,
    `birth_month` INT NOT NULL,
    `birth_day` INT NOT NULL,
    `birth_hour` INT NOT NULL,
    `event_desc` TEXT NOT NULL,
    `environment` TEXT NOT NULL,
    `five_elements` TEXT NOT NULL,  -- JSON格式存储五行能量
    `hexagram` VARCHAR(100) NOT NULL,
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 关键词-五行映射表（预定义规则）
CREATE TABLE IF NOT EXISTS `keyword_five_elements` (
    `keyword` VARCHAR(50) PRIMARY KEY,
    `element` VARCHAR(10) NOT NULL  -- 木、火、土、金、水
);

-- 插入示例关键词（可扩展）
INSERT INTO `keyword_five_elements` (`keyword`, `element`) VALUES
-- 一、单字五行（基础汉字）
('木', '木'), ('火', '火'), ('土', '土'), ('金', '金'), ('水', '水'),
('林', '木'), ('森', '木'), ('炎', '火'), ('焱', '火'), ('垚', '土'),
('鑫', '金'), ('淼', '水'), ('柳', '木'), ('柏', '木'), ('枫', '木'),
('灯', '火'), ('灶', '火'), ('城', '土'), ('坤', '土'), ('铁', '金'),
('银', '金'), ('河', '水'), ('江', '水'), ('雨', '水'), ('雷', '火'),
('山', '土'), ('石', '土'), ('草', '木'), ('花', '木'), ('果', '木'),
('日', '火'), ('月', '水'), ('星', '火'), ('光', '火'), ('风', '木'),

-- 二、日常物品（家居/工具/用品）
('筷子', '木'), ('碗', '土'), ('盘子', '土'), ('杯子', '金'), ('茶壶', '土'),
('勺子', '金'), ('叉子', '金'), ('菜刀', '金'), ('菜板', '木'), ('锅', '金'),
('碗柜', '木'), ('桌子', '木'), ('椅子', '木'), ('沙发', '木'), ('床', '木'),
('被子', '木'), ('枕头', '木'), ('毛巾', '木'), ('牙刷', '木'), ('牙膏', '水'),
('镜子', '金'), ('梳子', '木'), ('剪刀', '金'), ('指甲刀', '金'), ('钥匙', '金'),
('门锁', '金'), ('灯泡', '火'), ('插座', '火'), ('电线', '金'), ('手机', '金'), ('手机壳', '金'),
('电脑', '金'), ('书本', '木'), ('笔', '木'), ('纸', '木'), ('橡皮', '土'),
('胶水', '水'), ('胶带', '土'), ('书包', '木'), ('钱包', '土'), ('雨伞', '水'),
('雨衣', '水'), ('拖鞋', '木'), ('鞋子', '土'), ('袜子', '木'), ('帽子', '木'),

-- 三、饰品/珠宝（材质/象征）
('玉镯', '土'), ('金项链', '金'), ('银戒指', '金'), ('珍珠', '水'),
('翡翠', '木'), ('玛瑙', '土'), ('琥珀', '土'), ('钻石', '金'),
('珊瑚', '火'), ('水晶', '水'), ('绿松石', '水'),
('红绳', '火'), ('木手串', '木'), ('檀木珠', '木'), ('铜钱串', '金'),
('银锁', '金'), ('金镯子', '金'), ('珍珠耳环', '水'), ('玉坠', '土'),
('红宝石', '火'), ('蓝宝石', '水'), ('黄水晶', '土'), ('绿宝石', '木'),

-- 四、食物/饮品（性质/来源）
('米饭', '土'), ('面条', '土'), ('馒头', '土'), ('面包', '土'), ('包子', '土'),
('粥', '水'), ('汤', '水'), ('茶', '木'), ('咖啡', '火'), ('牛奶', '水'),
('豆浆', '木'), ('果汁', '木'), ('酒', '水'), ('醋', '木'), ('酱油', '水'),
('盐', '土'), ('糖', '土'), ('辣椒', '火'), ('姜', '火'), ('蒜', '火'),
('葱', '木'), ('香菜', '木'), ('白菜', '木'), ('菠菜', '木'), ('萝卜', '土'),
('土豆', '土'), ('红薯', '土'), ('南瓜', '土'), ('西瓜', '水'), ('哈密瓜', '水'),
('苹果', '木'), ('香蕉', '木'), ('橘子', '木'), ('葡萄', '水'), ('草莓', '火'),
('荔枝', '火'), ('龙眼', '火'), ('桃子', '木'), ('梨', '水'), ('芒果', '土'),
('牛肉', '土'), ('羊肉', '火'), ('猪肉', '水'), ('鸡肉', '火'), ('鱼肉', '水'),
('虾', '水'), ('蟹', '水'), ('鸡蛋', '土'), ('鸭蛋', '土'), ('豆腐', '土'),

-- 五、行为/动作（动态特征）
('走', '木'), ('跑', '火'), ('跳', '火'), ('坐', '土'), ('站', '土'),
('躺', '水'), ('爬', '木'), ('骑', '火'), ('飞', '火'), ('游泳', '水'),
('划船', '水'), ('开车', '金'), ('走路', '木'), ('跑步', '火'), ('跳跃', '火'),
('登山', '土'), ('钓鱼', '水'), ('种花', '木'), ('浇水', '水'), ('施肥', '土'),
('读书', '木'), ('写字', '木'), ('画画', '土'), ('唱歌', '火'), ('跳舞', '火'),
('烹饪', '火'), ('打扫', '土'), ('整理', '土'), ('修理', '金'), ('裁剪', '金'),
('编织', '木'), ('雕刻', '土'), ('焊接', '火'), ('搬运', '土'), ('推拉', '金'),
('拥抱', '木'), ('握手', '土'), ('鼓掌', '火'), ('哭泣', '水'), ('大笑', '火'),

-- 六、情感/状态（情绪/抽象）
('喜悦', '火'), ('愤怒', '火'), ('悲伤', '水'), ('平静', '土'), ('焦虑', '火'),
('开心', '火'), ('难过', '水'), ('兴奋', '火'), ('失落', '水'), ('满足', '土'),('伤心', '水') ,
('孤独', '水'), ('温暖', '火'), ('寒冷', '水'), ('疲惫', '水'), ('精神', '木'),
('急躁', '火'), ('耐心', '土'), ('坚强', '金'), ('脆弱', '水'), ('乐观', '火'),
('悲观', '水'), ('热情', '火'), ('冷漠', '水'), ('温柔', '木'), ('严厉', '金'),
('豁达', '土'), ('狭隘', '金'), ('自信', '火'), ('自卑', '水'), ('勇敢', '火'),
('胆小', '水'), ('果断', '金'), ('犹豫', '水'), ('慷慨', '火'), ('吝啬', '金'),

-- 七、人体/器官（中医五行）
('肝', '木'), ('胆', '木'), ('心', '火'), ('小肠', '火'), ('脾', '土'),
('胃', '土'), ('肺', '金'), ('大肠', '金'), ('肾', '水'), ('膀胱', '水'),
('眼', '木'), ('舌', '火'), ('口', '土'), ('鼻', '金'), ('耳', '水'),
('头发', '木'), ('皮肤', '金'), ('肌肉', '土'), ('骨骼', '水'), ('血液', '火'),
('手', '木'), ('脚', '土'), ('指甲', '金'), ('牙齿', '金'), ('眉毛', '木'),

-- 八、自然/环境（天气/地理）
('春', '木'), ('夏', '火'), ('长夏', '土'), ('秋', '金'), ('冬', '水'),
('东', '木'), ('南', '火'), ('中', '土'), ('西', '金'), ('北', '水'),
('风', '木'), ('云', '水'), ('雨', '水'), ('雪', '水'), ('霜', '水'),
('雷', '火'), ('电', '火'), ('虹', '水'), ('雾', '水'), ('霾', '土'),
('山', '土'), ('河', '水'), ('湖', '水'), ('海', '水'), ('溪', '水'),
('泉', '水'), ('石', '土'), ('沙', '土'), ('泥', '土'), ('岩', '土'),
('树', '木'), ('草', '木'), ('花', '木'), ('果', '木'), ('藤', '木'),
('竹', '木'), ('松', '木'), ('柏', '木'), ('柳', '木'), ('杨', '木');

-- 直系亲属（血缘核心）
('爸爸', '土'), ('妈妈', '土'), ('爷爷', '土'), ('奶奶', '土'), ('外公', '土'), ('外婆', '土'),
('儿子', '木'), ('女儿', '木'), ('孙子', '木'), ('孙女', '木'), ('外孙', '木'), ('外孙女', '木'),
('丈夫', '火'), ('妻子', '火'), 

-- 同辈亲属（年龄相近）
('哥哥', '木'), ('弟弟', '木'), ('姐姐', '木'), ('妹妹', '木'), ('堂哥', '木'), ('堂弟', '木'),
('堂姐', '木'), ('堂妹', '木'), ('表哥', '木'), ('表弟', '木'), ('表姐', '木'), ('表妹', '木'),

-- 旁系亲属（血缘延伸）
('伯父', '土'), ('伯母', '土'), ('叔父', '土'), ('叔母', '土'), ('姑父', '土'), ('姑母', '土'),
('舅父', '金'), ('舅母', '金'), ('姨父', '金'), ('姨母', '金'),

-- 姻亲关系（婚姻联结）
('公公', '土'), ('婆婆', '土'), ('岳父', '土'), ('岳母', '土'), ('儿媳', '水'), ('女婿', '水'),
('嫂子', '水'), ('弟媳', '水'), ('姐夫', '水'), ('妹夫', '水'),

-- 隔代/特殊称谓
('太爷爷', '土'), ('太奶奶', '土'), ('太外公', '土'), ('太外婆', '土'), ('干爸', '土'), ('干妈', '土'),
('义兄', '木'), ('义妹', '木'), ('继子', '木'), ('继女', '木');

-- 行业五行
('金融', '金'), ('银行', '金'), ('保险', '金'), ('会计', '金'), ('法律', '金'),
('珠宝', '金'), ('科技', '金'), ('机械', '金'), ('电子', '金'), ('汽车', '金'),
('IT', '金'), ('金属加工', '金'), ('医疗器械', '金'), ('物流设备', '金'),
('钟表 ', '金'), ('证券', '金'), ('投资', '金'), ('审计', '金'), ('税务', '金'),
('刀具制造', '金'), ('航空航天', '金'), ('乐器', '金'), ('精密仪器 ', '金'),
('贵金属冶炼', '金'), ('金融科技', '金'), ('区块链', '金'), ('资产评估', '金'),

-- 木行（教育 / 文化 / 环保 / 生长类）
(' 教育 ', ' 木 '), (' 出版 ', ' 木 '), (' 图书 ', ' 木 '), (' 文化 ', ' 木 '), (' 广告 ', ' 木 '),
(' 园林 ', ' 木 '), (' 环保 ', ' 木 '), (' 农业 ', ' 木 '), (' 林业 ', ' 木 '), (' 服装 ', ' 木 '),
(' 纺织 ', ' 木 '), (' 家具 ', ' 木 '), (' 造纸 ', ' 木 '), (' 香料 ', ' 木 '), (' 中药材 ', ' 木 '),
(' 心理咨询 ', ' 木 '), (' 培训 ', ' 木 '), (' 媒体 ', ' 木 '), (' 演艺 ', ' 木 '), (' 策划 ', ' 木 '),
(' 花卉种植 ', ' 木 '), (' 素食餐饮 ', ' 木 '), (' 竹制品 ', ' 木 '), (' 毛笔制作 ', ' 木 '),
(' 室内设计 ', ' 木 '), (' 植物科研 ', ' 木 '), (' 茶叶 ', ' 木 '), (' 瑜伽 ', ' 木 '), (' 翻译 ', ' 木 '),

-- 水行（物流 / 旅游 / 科技 / 流动类）
(' 物流 ', ' 水 '), (' 运输 ', ' 水 '), (' 旅游 ', ' 水 '), (' 航运 ', ' 水 '), (' 贸易 ', ' 水 '),
(' 水产 ', ' 水 '), (' 电商 ', ' 水 '), (' 互联网 ', ' 水 '), (' 咨询 ', ' 水 '), (' 航海 ', ' 水 '),
(' 广告传媒 ', ' 水 '), (' 饮品 ', ' 水 '), (' 化妆品 ', ' 水 '), (' 卫浴 ', ' 水 '), (' 冷冻 ', ' 水 '),
(' 消防 ', ' 水 '), (' 侦探 ', ' 水 '), (' 心理咨询 ', ' 水 '), (' 物流科技 ', ' 水 '), (' 跨境电商 ', ' 水 '),
(' 潜水 ', ' 水 '), (' 洗车 ', ' 水 '), (' 水处理 ', ' 水 '), (' 游泳培训 ', ' 水 '), (' 海鲜加工 ', ' 水 '),
(' 酒店管理 ', ' 水 '), (' 航海仪器 ', ' 水 '), (' 冷链物流 ', ' 水 '), (' 水疗 ', ' 水 '), (' 占卜 ', ' 水 '),
-- 火行（能源 / 互联网 / 娱乐 / 热能类）
(' 能源 ', ' 火 '), (' 电力 ', ' 火 '), (' 互联网 ', ' 火 '), (' 电商 ', ' 火 '), (' 游戏 ', ' 火 '),
(' 影视 ', ' 火 '), (' 娱乐 ', ' 火 '), (' 美容 ', ' 火 '), (' 照明 ', ' 火 '), (' 餐饮（烧烤）', ' 火 '),
(' 医疗 ', ' 火 '), (' 心理咨询 ', ' 火 '), (' 广告 ', ' 火 '), (' 新媒体 ', ' 火 '), (' 电子竞技 ', ' 火 '),
(' 太阳能 ', ' 火 '), (' 人工智能 ', ' 火 '), (' 大数据 ', ' 火 '), (' 虚拟技术 ', ' 火 '), (' 婚庆 ', ' 火 '),
(' 冶炼 ', ' 火 '), (' 烘焙 ', ' 火 '), (' 热处理 ', ' 火 '), (' 照明设备 ', ' 火 '), (' 舞台灯光 ', ' 火 '),
(' 化学制药 ', ' 火 '), (' 摄影 ', ' 火 '), (' 演说培训 ', ' 火 '), (' 占卜（卦象）', ' 火 '), (' 消防 ', ' 火 '),
--土行（建筑 / 地产 / 餐饮 / 稳定类）
(' 建筑 ', ' 土 '), (' 地产 ', ' 土 '), (' 工程 ', ' 土 '), (' 陶瓷 ', ' 土 '), (' 石材 ', ' 土 '),
(' 餐饮 ', ' 土 '), (' 食品 ', ' 土 '), (' 养殖 ', ' 土 '), (' 矿产 ', ' 土 '), (' 仓储 ', ' 土 '),
(' 殡葬 ', ' 土 '), (' 园林绿化 ', ' 土 '), (' 畜牧业 ', ' 土 '), (' 化肥 ', ' 土 '), (' 古董 ', ' 土 '),
(' 玉石 ', ' 土 '), (' 水泥 ', ' 土 '), (' 安保 ', ' 土 '), (' 物业管理 ', ' 土 '), (' 典当行 ', ' 土 '),
(' 房地产中介 ', ' 土 '), (' 土壤研究 ', ' 土 '), (' 考古 ', ' 土 '), (' 制陶 ', ' 土 '), (' 粮食加工 ', ' 土 '),
(' 混凝土 ', ' 土 '), (' 钟表维修 ', ' 土 '), (' 矿山机械 ', ' 土 '), (' 垃圾处理 ', ' 土 '), (' 托儿所 ', ' 土 '),