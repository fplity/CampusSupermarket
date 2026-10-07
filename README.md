# 校园超市管理系统

校园超市管理系统是一套以校园零售为场景的 Java Web 项目，使用 **JSP、Jakarta Servlet、JDBC 和 MySQL** 实现商品维护、库存管理、订单创建、支付记录及商品评价，并提供可选的 **DeepSeek 自然语言数据查询与经营报告**。

系统围绕“商品 → 库存 → 订单 → 支付 → 评价 → 经营分析”组织业务。页面与后端一起部署到 Tomcat，通过 Axios 调用 Servlet 接口，适合学习 Java Web 分层开发、数据库关联、事务处理和 AI 服务接入。

**项目维护者：刘煜平。** 所有页面底部统一显示维护者姓名。

## 功能介绍

| 模块 | 具体功能 | 页面 |
| --- | --- | --- |
| 用户入口 | 账号注册、登录校验、联系电话登记、页面登录状态记录 | `login.jsp`、`register.jsp` |
| 商品与库存 | 商品列表、编号/名称搜索、新增、修改、删除，维护价格、图片和库存 | `main.jsp` |
| 订单管理 | 选择商品与数量、创建订单、查看当前账号订单、标记完成 | `order.jsp` |
| 支付记录 | 查看待支付订单、选择支付方式、生成支付记录、同步订单状态 | `payment.jsp` |
| 商品评价 | 选择商品、填写 1—5 分及评价内容、查看评价、删除本人评价；后端另提供修改接口 | `review.jsp` |
| 智能查询 | 输入自然语言问题，生成并校验 SELECT 查询，展示 SQL 和最多 100 条结果 | `ai.jsp` |
| 经营报告 | 汇总商品数、订单数、成功支付数、销售金额和低库存商品数，生成并导出文本报告 | `ai.jsp` |

创建订单时，DAO 使用数据库事务与 `SELECT ... FOR UPDATE` 锁定商品记录，检查数量和库存，再写入订单、扣减库存。支付模块锁定订单，读取订单金额，写入支付记录并修改订单状态；数据库通过唯一键约束一个订单只能对应一条支付记录。

支付页面中的微信、支付宝和现金是**支付方式记录与业务流程演示**，未接入真实支付网关。

## 技术组成

| 层次 | 技术与职责 |
| --- | --- |
| 页面 | JSP、HTML、CSS、JavaScript；包括登录、商品、订单、支付、评价和 AI 中心 |
| 浏览器请求 | 项目内附带的 `axios.js`，按应用 context path 请求后端 |
| 控制层 | Jakarta Servlet，通过路径及 `op` 参数分发操作，使用 Fastjson2 返回 JSON |
| 数据访问 | DAO + JDBC + PreparedStatement，订单和支付使用事务 |
| 数据库 | MySQL 8，五张关联业务表、索引、外键及评分约束 |
| AI 服务 | Java HTTP 请求、兼容 chat completions 的接口、可选 DeepSeek 配置、本地规则回退 |
| 构建和部署 | JDK 工具、PowerShell 构建脚本、IntelliJ IDEA Web 配置、Tomcat |

源码库保留运行所需图片与依赖 JAR：Fastjson2 `2.0.62`、MySQL Connector/J `8.4.0` 和 Servlet API。构建 WAR 时会移除 Servlet API JAR，由 Tomcat 提供运行时接口。

## 目录结构

```text
CampusSupermarket/
├── CS/src/main/
│   ├── java/com/xf/
│   │   ├── dao/              # 商品、用户、订单、支付、评价、AI 数据访问
│   │   ├── entity/           # Shopping、User、MallOrder、Payment、Review
│   │   ├── servlet/          # 七个业务 Servlet
│   │   └── util/             # DBUtil 和 AiService
│   └── webapp/
│       ├── login.jsp、register.jsp
│       ├── main.jsp、order.jsp、payment.jsp、review.jsp、ai.jsp
│       ├── axios.js
│       ├── image/            # 商品图片和登录页素材
│       └── WEB-INF/
│           ├── web.xml       # 默认进入 login.jsp
│           ├── ai.properties.example
│           └── lib/          # 编译与运行依赖
├── sql/initialize.sql        # 表结构及演示商品、账号
├── .idea/                    # 可共享的 IDEA 项目和 Web Artifact 配置
├── CampusSupermarket.iml
├── build.ps1                 # 编译 Java、组装 Web 目录、生成 WAR
└── README.md
```

仓库交付项目源码、页面、图片、依赖和数据库脚本。课程 PPT、Word/PDF 报告、原始压缩包、编译结果和个人 IDE 状态不在版本库中。

## 运行环境

- **JDK 17 或更高版本**，安装目录包含 `java`、`javac`、`jar`；脚本将代码编译为 Java 17 目标版本。
- **Tomcat 11**，使用 Jakarta Servlet 命名空间。
- **MySQL 8**。
- Windows PowerShell 5.1 或 PowerShell 7，可运行附带构建脚本。
- 使用 IDEA 部署时，需要支持 Java Web/Tomcat 集成的 IntelliJ IDEA；首次打开后在 Project Structure 中选择本机 JDK。

不需要额外安装 Node.js、前端包管理器或 Maven。

## 快速启动

### 1. 获取源码

```powershell
git clone https://github.com/fplity/CampusSupermarket.git
Set-Location CampusSupermarket
```

### 2. 初始化数据库

`sql/initialize.sql` **会删除并重建名为 `cs` 的数据库**，导入前请确认该数据库没有需要保留的数据。

在 MySQL 客户端、Workbench 或数据库管理工具中执行全部 SQL，也可以打开命令行客户端：

```text
mysql -u root -p
```

随后在 MySQL 客户端输入实际文件路径，例如：

```sql
SOURCE D:/projects/CampusSupermarket/sql/initialize.sql;
```

脚本创建五张表，插入六种演示商品和两个演示账号。订单、支付和评价表初始为空，由页面操作写入。

当前连接配置位于 `CS/src/main/java/com/xf/util/DBUtil.java`：

| 配置项 | 演示默认值 |
| --- | --- |
| JDBC URL | `jdbc:mysql://localhost:3306/cs` |
| MySQL 用户 | `root` |
| MySQL 密码 | `123456` |

请按本机 MySQL 设置修改连接配置，然后重新编译。以上是演示默认值，不是托管数据库凭据。

### 3. 编译和打包

在项目根目录执行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\build.ps1
```

脚本优先读取 `JAVA_HOME`，未设置时根据当前 `java` 命令解析安装目录。也可以显式指定 JDK：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\build.ps1 -JdkHome "C:\Program Files\Java\jdk-17"
```

脚本会重建本项目的 `build/` 目录，编译全部 Java 源码，复制页面、图片及依赖，并生成：

- `build/webapp/`：可直接部署的 Web exploded 目录。
- `build/webapp.war`：可部署到 Tomcat 的 WAR 文件。

### 4. 部署到 Tomcat

将 `build/webapp.war` 复制到 Tomcat 的 `webapps/` 目录，运行 Tomcat 的 `bin/startup.bat`，然后访问：

```text
http://localhost:8080/webapp/
```

Tomcat 会默认打开登录页面。演示登录账号为 **`admin`**，密码为 **`123456`**。也可以使用注册页面创建测试账号。

### 5. 使用 IntelliJ IDEA 部署

1. 打开仓库根目录，选择本机 JDK，确认 `CS/src/main/java` 是源码目录。
2. 在 Run → Edit Configurations 新增 Tomcat Server → Local，并选择 Tomcat 安装目录。
3. 在 Deployment 添加 `CampusSupermarket:Web exploded`。
4. 将 Application context 设置为 `/webapp`，HTTP port 设置为 `8080`。
5. 启动后访问 `http://localhost:8080/webapp/`。

项目内附带 Web Facet、依赖库和 Artifact 的共享配置；本机 Tomcat 路径与运行配置由使用者自行选择。

## 数据库设计

| 表 | 主要字段 | 作用 |
| --- | --- | --- |
| `user` | `account`、`password`、`tel` | 用户注册和登录，账号为主键、电话唯一 |
| `shopping` | `sid`、`sname`、`price`、`image`、`stock` | 商品信息、图片文件名与库存 |
| `mall_order` | `oid`、`account`、`sid`、`quantity`、`total_amount`、`status`、`created_at` | 商品与用户关联的订单 |
| `payment` | `pid`、`oid`、`pay_amount`、`pay_method`、`pay_status`、`pay_time` | 订单对应的支付记录 |
| `review` | `rid`、`sid`、`account`、`score`、`content`、`created_at` | 商品评分和文字评价 |

商品编号与登录账号上限为 8 个字符，商品名称上限为 16 个字符，评价内容上限为 200 个字符；评分限定为 1—5 分。图片字段填写 `image/` 下的文件名。

## AI 配置与本地回退

未配置外部模型时，系统可使用本地关键词规则生成商品、库存、订单聚合或评价统计查询，经营报告使用本地统计模板。

需要接入 DeepSeek 时，将：

```text
CS/src/main/webapp/WEB-INF/ai.properties.example
```

复制为同目录下的 `ai.properties`，填写自己的配置：

```properties
AI_API_URL=https://api.deepseek.com/chat/completions
AI_API_KEY=YOUR_DEEPSEEK_API_KEY
AI_MODEL=deepseek-chat
```

配置优先级为 **环境变量 → JVM 系统属性 → `WEB-INF/ai.properties`**。修改文件配置后，重新打包/部署并重启 Tomcat。

AI 生成的 SQL 会经过 SELECT、分号、注释和部分写操作关键词检查。不符合校验的 SQL、未配置接口或接口调用失败时，服务使用本地规则回退。报告服务无法取得模型结果时也会返回本地模板。

`ai.properties` 已被 Git 忽略；仓库只提供示例模板。

## Servlet 接口概览

下列路径均以部署上下文 `/webapp` 为前缀，当前实现通过 GET 请求及参数调用：

| 路径 | 操作/参数 | 功能 |
| --- | --- | --- |
| `/user` | `op=login/register/getAll/delete` | 账号登录、注册及用户操作 |
| `/shopping` | `op=getAll/search/add/update/delete` | 商品列表、搜索和维护 |
| `/order` | `op=getAll/getMine/add/finish` | 订单查询、创建与完成 |
| `/payment` | `op=getAll/getMine/add` | 支付记录查询和创建 |
| `/review` | `op=getAll/add/update/delete` | 商品评价维护 |
| `/aiQuery` | `question` | 自然语言查询、SQL 与结果返回 |
| `/aiReport` | 无必填参数 | 统计汇总及经营报告 |

创建订单主要传入 `account`、`sid`、`quantity`；创建支付记录主要传入 `oid`、`payMethod`；商品评价传入 `sid`、`account`、`score`、`content`。

## 建议演示顺序

1. 使用演示账号登录，查看商品、搜索结果和库存。
2. 在订单页选取商品与数量创建订单，核对库存变化。
3. 在支付页选择订单及支付方式，生成支付记录。
4. 返回订单页查看状态，在评价页发布评分与评价。
5. 在 AI 中心查询“查询库存最低的商品”“统计各订单状态的销售金额”或“查询商品平均评分”。
6. 生成经营报告并导出文本。

## 常见问题

| 现象 | 检查方法 |
| --- | --- |
| `/webapp/` 返回 404 | 确认 WAR 名为 `webapp.war`，或 IDEA 的 Application context 是 `/webapp` |
| 数据库连接失败 | 检查 MySQL 是否运行，`cs` 是否已初始化，以及 DBUtil 的地址、用户和密码 |
| 页面无法加载商品图片 | 确认部署目录包含 `image/`，商品图片字段与实际文件名一致 |
| 页面请求接口失败 | 通过 Tomcat 地址访问 JSP，并检查后端日志；直接用文件方式打开页面不能运行 JSP |
| AI 显示本地规则或模板 | 检查接口地址、密钥、模型和配置优先级，修改后重新部署并重启 |
| IDEA 找不到 JDK 或 Tomcat | 在本机重新选择 SDK 和 Tomcat 安装目录；共享配置不绑定个人安装路径 |

## 当前实现范围

这是课程实践和本地演示项目。当前账号密码以明文存储和校验，浏览器使用 `sessionStorage` 记录登录账号，后端尚未建立完整的会话鉴权与管理员/普通用户权限隔离；写操作沿用 GET 接口。AI SQL 校验也是基础过滤，不等于完整的数据库权限隔离。

运行在真实公开服务前，需要补充密码哈希、服务端鉴权、操作授权、POST/CSRF 保护、输出转义和独立数据库权限等工程措施。仓库公开上传不代表应用已部署到公网，也不代表已完成真实支付或外部 AI 服务验收。

## 本次归档检查

- 使用本机 JDK 25 编译全部 **20 个 Java 源文件**，生成 Java 17 目标字节码及 WAR。
- 在隔离的 **Tomcat 11.0.22** 中部署 WAR，默认入口及 **7 个 JSP 页面**均返回 HTTP 200，页脚显示“刘煜平”；Axios 和登录背景图片也可正常访问。
- 检查源码、IDEA 配置、WAR 内容及 Git 忽略规则；课程材料、旧身份信息、实际 AI 配置和编译结果均未进入提交。

这次检查覆盖编译、打包、JSP 服务端渲染和静态资源；没有重置本机数据库，没有进行完整浏览器业务流程测试，也没有调用真实支付或外部 AI 服务。
