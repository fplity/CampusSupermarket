-- 校园超市管理系统 MySQL 8.0 数据库初始化脚本
-- 对应 JDBC 地址：jdbc:mysql://localhost:3306/cs
-- 对应当前 DBUtil 配置：root / 123456
-- 导入命令：mysql -uroot -p123456 < "sql/initialize.sql"
-- 注意：执行后会重建 cs 数据库并清除原有数据。

DROP DATABASE IF EXISTS `cs`;
CREATE DATABASE `cs`
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE `cs`;

-- 用户表：注册、登录、评价和订单归属使用。
CREATE TABLE `user` (
    `account` VARCHAR(8) NOT NULL COMMENT '登录账号',
    `password` VARCHAR(8) NOT NULL COMMENT '当前项目按明文密码校验',
    `tel` VARCHAR(11) NOT NULL COMMENT '联系电话',
    PRIMARY KEY (`account`),
    UNIQUE KEY `uk_user_tel` (`tel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统用户表';

-- 商品表：商品 CRUD、订单和评价使用。
CREATE TABLE `shopping` (
    `sid` VARCHAR(8) NOT NULL COMMENT '商品编号',
    `sname` VARCHAR(16) NOT NULL COMMENT '商品名称',
    `price` DECIMAL(10,2) NOT NULL COMMENT '商品单价',
    `image` VARCHAR(255) NOT NULL DEFAULT 'placeholder.png' COMMENT 'webapp/image 中的图片名',
    `stock` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '库存数量',
    PRIMARY KEY (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- 订单表：创建订单时自动扣减商品库存。
CREATE TABLE `mall_order` (
    `oid` VARCHAR(32) NOT NULL COMMENT '订单编号',
    `account` VARCHAR(8) NOT NULL COMMENT '下单用户',
    `sid` VARCHAR(8) NOT NULL COMMENT '商品编号',
    `quantity` INT UNSIGNED NOT NULL COMMENT '购买数量',
    `total_amount` DECIMAL(10,2) NOT NULL COMMENT '订单总金额',
    `status` VARCHAR(16) NOT NULL DEFAULT '待支付' COMMENT '待支付、已支付、已完成',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`oid`),
    KEY `idx_order_account` (`account`),
    KEY `idx_order_sid` (`sid`),
    CONSTRAINT `fk_order_user` FOREIGN KEY (`account`) REFERENCES `user` (`account`),
    CONSTRAINT `fk_order_shopping` FOREIGN KEY (`sid`) REFERENCES `shopping` (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- 支付表：每个订单只能有一条成功支付记录。
CREATE TABLE `payment` (
    `pid` VARCHAR(32) NOT NULL COMMENT '支付编号',
    `oid` VARCHAR(32) NOT NULL COMMENT '订单编号',
    `pay_amount` DECIMAL(10,2) NOT NULL COMMENT '支付金额',
    `pay_method` VARCHAR(16) NOT NULL COMMENT '微信支付、支付宝、现金支付',
    `pay_status` VARCHAR(16) NOT NULL DEFAULT '支付成功' COMMENT '支付状态',
    `pay_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '支付时间',
    PRIMARY KEY (`pid`),
    UNIQUE KEY `uk_payment_order` (`oid`),
    CONSTRAINT `fk_payment_order` FOREIGN KEY (`oid`) REFERENCES `mall_order` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='支付表';

-- 评价表：用户可对商品发布、修改和删除自己的评价。
CREATE TABLE `review` (
    `rid` VARCHAR(32) NOT NULL COMMENT '评价编号',
    `sid` VARCHAR(8) NOT NULL COMMENT '商品编号',
    `account` VARCHAR(8) NOT NULL COMMENT '评价用户',
    `score` TINYINT UNSIGNED NOT NULL COMMENT '1 至 5 分',
    `content` VARCHAR(200) NOT NULL COMMENT '评价内容',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评价时间',
    PRIMARY KEY (`rid`),
    KEY `idx_review_sid` (`sid`),
    CONSTRAINT `fk_review_shopping` FOREIGN KEY (`sid`) REFERENCES `shopping` (`sid`),
    CONSTRAINT `fk_review_user` FOREIGN KEY (`account`) REFERENCES `user` (`account`),
    CONSTRAINT `ck_review_score` CHECK (`score` BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品评价表';

-- 演示用户。登录账号：admin，密码：123456。
INSERT INTO `user` (`account`, `password`, `tel`) VALUES
    ('admin', '123456', '13800138000'),
    ('demo', '123456', '13900139000');

-- 前端图片均位于 src/main/webapp/image 目录。
INSERT INTO `shopping` (`sid`, `sname`, `price`, `image`, `stock`) VALUES
    ('s001', '绿豆饼', 8.50, 'ldb.png', 78),
    ('s002', '广味香肠', 15.00, 'xc.png', 60),
    ('s003', '月饼', 12.80, 'yb.png', 45),
    ('s004', '纯牛奶', 5.50, 'milk.png', 100),
    ('s005', '矿泉水', 2.00, 'water.png', 200),
    ('s006', '曲奇饼干', 9.90, 'cookies.png', 36);

-- 订单、支付和评价不写预置演示数据。
-- 用户注册、提交订单、完成支付和发布评价后，系统会实时写入对应表。

-- 导入后核验。
SELECT `account`, `tel` FROM `user`;
SELECT `sid`, `sname`, `price`, `stock` FROM `shopping` ORDER BY `sid`;
SELECT `oid`, `account`, `sid`, `quantity`, `total_amount`, `status` FROM `mall_order` ORDER BY `created_at` DESC;
SELECT `pid`, `oid`, `pay_amount`, `pay_method`, `pay_status` FROM `payment`;
SELECT `rid`, `sid`, `account`, `score`, `content` FROM `review`;
