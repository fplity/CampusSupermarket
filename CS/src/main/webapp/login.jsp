<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园超市管理系统 - 登录</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: "Microsoft YaHei", Arial, sans-serif;
            color: #18212f;
            background:
                radial-gradient(circle at 16% 14%, rgba(46, 125, 93, 0.18), transparent 30%),
                radial-gradient(circle at 88% 18%, rgba(245, 158, 11, 0.18), transparent 28%),
                linear-gradient(135deg, #eef4f1 0%, #f7f1e8 48%, #eef2f8 100%);
        }

        .auth-page {
            min-height: 100vh;
            display: grid;
            place-items: center;
            padding: 32px 18px;
        }

        .auth-shell {
            width: min(1040px, 100%);
            min-height: 620px;
            display: grid;
            grid-template-columns: 1.18fr 0.82fr;
            overflow: hidden;
            border: 1px solid rgba(31, 41, 55, 0.12);
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.78);
            box-shadow: 0 28px 80px rgba(24, 33, 47, 0.18);
        }

        .brand {
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 44px;
            background:
                linear-gradient(135deg, rgba(12, 73, 78, 0.94), rgba(30, 64, 98, 0.9)),
                url("image/auth-hero.png") center / cover;
            color: #ffffff;
        }

        .brand::after {
            content: "";
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, rgba(5, 16, 28, 0.18), rgba(5, 16, 28, 0.54));
        }

        .brand > * {
            position: relative;
            z-index: 1;
        }

        .brand-mark {
            width: 52px;
            height: 52px;
            display: grid;
            place-items: center;
            border: 1px solid rgba(255, 255, 255, 0.34);
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.14);
            font-size: 24px;
            font-weight: 800;
        }

        .brand h1 {
            max-width: 520px;
            margin: 26px 0 16px;
            font-size: clamp(32px, 5vw, 54px);
            line-height: 1.08;
            font-weight: 800;
        }

        .brand p {
            max-width: 520px;
            margin: 0;
            color: rgba(255, 255, 255, 0.82);
            font-size: 16px;
            line-height: 1.8;
        }

        .product-strip {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            margin-top: 42px;
        }

        .product-strip img {
            width: 100%;
            aspect-ratio: 4 / 3;
            object-fit: cover;
            border: 1px solid rgba(255, 255, 255, 0.24);
            border-radius: 8px;
        }

        .panel {
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 44px;
            background: rgba(255, 255, 255, 0.94);
        }

        .panel h2 {
            margin: 0;
            font-size: 30px;
            line-height: 1.2;
        }

        .hint {
            margin: 10px 0 30px;
            color: #667085;
            font-size: 14px;
        }

        label {
            display: block;
            margin: 16px 0 8px;
            color: #344054;
            font-size: 14px;
            font-weight: 700;
        }

        input {
            width: 100%;
            height: 46px;
            padding: 0 14px;
            border: 1px solid #c9d4df;
            border-radius: 8px;
            background: #fbfcfd;
            color: #111827;
            font-size: 15px;
            outline: none;
            transition: border-color 0.18s ease, box-shadow 0.18s ease, background 0.18s ease;
        }

        input:focus {
            border-color: #0f766e;
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(15, 118, 110, 0.12);
        }

        button {
            width: 100%;
            height: 46px;
            margin-top: 26px;
            border: 0;
            border-radius: 8px;
            background: linear-gradient(135deg, #0f766e, #2563eb);
            color: #ffffff;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 14px 28px rgba(37, 99, 235, 0.24);
            transition: transform 0.18s ease, box-shadow 0.18s ease;
        }

        button:hover {
            transform: translateY(-1px);
            box-shadow: 0 18px 34px rgba(37, 99, 235, 0.28);
        }

        .link {
            margin-top: 22px;
            text-align: center;
            color: #667085;
            font-size: 14px;
        }

        a {
            color: #0f766e;
            font-weight: 700;
            text-decoration: none;
        }

        @media (max-width: 820px) {
            .auth-shell {
                grid-template-columns: 1fr;
            }

            .brand {
                min-height: 300px;
                padding: 30px;
            }

            .panel {
                padding: 30px;
            }
        }
    </style>
</head>
<body>
<main class="auth-page">
    <section class="auth-shell">
        <div class="brand">
            <div>
                <div class="brand-mark">CS</div>
                <h1>校园超市管理系统</h1>
                <p>统一管理商品信息、库存和用户入口，让日常实训项目看起来也像一个认真交付的应用。</p>
            </div>
            <div class="product-strip">
                <img src="image/ldb.png" alt="绿豆饼">
                <img src="image/xc.png" alt="广味香肠">
                <img src="image/yb.png" alt="月饼">
            </div>
        </div>

        <div class="panel">
            <h2>欢迎登录</h2>
            <p class="hint">请输入校园超市账号和密码</p>
            <label for="account">账号</label>
            <input id="account" maxlength="8" autocomplete="username" placeholder="请输入账号">
            <label for="password">密码</label>
            <input id="password" maxlength="8" type="password" autocomplete="current-password" placeholder="请输入密码">
            <button id="login">登录</button>
            <div class="link">没有账号？<a href="register.jsp">立即注册</a></div>
        </div>
    </section>
</main>

<script src="axios.js"></script>
<script>
    const API_BASE = "<%= request.getContextPath() %>";
    const account = document.querySelector("#account");
    const password = document.querySelector("#password");

    document.querySelector("#login").onclick = async function () {
        if (!account.value.trim() || !password.value.trim()) {
            alert("请输入账号和密码");
            return;
        }

        try {
            const resp = await axios.get(API_BASE + "/user", {
                params: {
                    op: "login",
                    account: account.value.trim(),
                    password: password.value.trim()
                }
            });

            if (resp.data === true || resp.data === "true") {
                sessionStorage.setItem("cs_account", account.value.trim());
                location.href = "main.jsp";
            } else {
                alert("账号或密码错误");
            }
        } catch (e) {
            alert("连接服务器失败，请确认 Tomcat 已启动");
        }
    };
</script>
<footer class="project-footer" style="padding: 16px; text-align: center; color: #667085; font-size: 13px;">刘建平 · 校园超市管理系统</footer>
</body>
</html>
