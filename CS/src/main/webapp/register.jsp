<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园超市管理系统 - 注册</title>
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
                radial-gradient(circle at 18% 18%, rgba(15, 118, 110, 0.18), transparent 30%),
                radial-gradient(circle at 82% 22%, rgba(190, 92, 38, 0.18), transparent 28%),
                linear-gradient(135deg, #f2f7f4 0%, #f7efe7 48%, #edf2f8 100%);
        }

        .auth-page {
            min-height: 100vh;
            display: grid;
            place-items: center;
            padding: 32px 18px;
        }

        .auth-shell {
            width: min(1040px, 100%);
            min-height: 650px;
            display: grid;
            grid-template-columns: 0.86fr 1.14fr;
            overflow: hidden;
            border: 1px solid rgba(31, 41, 55, 0.12);
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.82);
            box-shadow: 0 28px 80px rgba(24, 33, 47, 0.18);
        }

        .panel {
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 44px;
            background: rgba(255, 255, 255, 0.96);
        }

        .panel h1 {
            margin: 0;
            font-size: 30px;
            line-height: 1.2;
        }

        .hint {
            margin: 10px 0 28px;
            color: #667085;
            font-size: 14px;
        }

        label {
            display: block;
            margin: 15px 0 8px;
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

        .showcase {
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 44px;
            background: #0f2f3c;
            color: #ffffff;
            overflow: hidden;
        }

        .showcase::before {
            content: "";
            position: absolute;
            inset: 0;
            background:
                linear-gradient(180deg, rgba(8, 20, 30, 0.1), rgba(8, 20, 30, 0.72)),
                url("image/auth-hero.png") center / cover;
            opacity: 0.9;
        }

        .showcase > * {
            position: relative;
            z-index: 1;
        }

        .showcase h2 {
            margin: 0;
            max-width: 420px;
            font-size: clamp(28px, 4vw, 46px);
            line-height: 1.1;
        }

        .showcase p {
            max-width: 440px;
            margin: 16px 0 0;
            color: rgba(255, 255, 255, 0.82);
            line-height: 1.8;
        }

        .metrics {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
        }

        .metric {
            padding: 14px;
            border: 1px solid rgba(255, 255, 255, 0.22);
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.12);
        }

        .metric strong {
            display: block;
            font-size: 22px;
        }

        .metric span {
            display: block;
            margin-top: 4px;
            color: rgba(255, 255, 255, 0.76);
            font-size: 12px;
        }

        @media (max-width: 820px) {
            .auth-shell {
                grid-template-columns: 1fr;
            }

            .showcase {
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
        <div class="panel">
            <h1>创建账号</h1>
            <p class="hint">注册后可进入商品管理后台</p>
            <label for="account">账号</label>
            <input id="account" maxlength="8" autocomplete="username" placeholder="最多 8 位">
            <label for="password">密码</label>
            <input id="password" maxlength="8" type="password" autocomplete="new-password" placeholder="最多 8 位">
            <label for="tel">电话</label>
            <input id="tel" maxlength="11" placeholder="请输入电话">
            <button id="register">注册</button>
            <div class="link">已有账号？<a href="login.jsp">返回登录</a></div>
        </div>

        <div class="showcase">
            <div>
                <h2>让商品、库存、图片展示更清楚</h2>
                <p>页面保留原来的接口与数据结构，只把使用体验做得更像一个完整的校园超市后台。</p>
            </div>
            <div class="metrics">
                <div class="metric"><strong>7</strong><span>核心功能</span></div>
                <div class="metric"><strong>3</strong><span>默认商品</span></div>
                <div class="metric"><strong>1</strong><span>管理入口</span></div>
            </div>
        </div>
    </section>
</main>

<script src="axios.js"></script>
<script>
    const API_BASE = "<%= request.getContextPath() %>";
    const account = document.querySelector("#account");
    const password = document.querySelector("#password");
    const tel = document.querySelector("#tel");

    document.querySelector("#register").onclick = async function () {
        if (!account.value.trim() || !password.value.trim() || !tel.value.trim()) {
            alert("请填写完整注册信息");
            return;
        }

        try {
            const resp = await axios.get(API_BASE + "/user", {
                params: {
                    op: "register",
                    account: account.value.trim(),
                    password: password.value.trim(),
                    tel: tel.value.trim()
                }
            });

            if (Number(resp.data) === 1) {
                alert("注册成功");
                location.href = "login.jsp";
            } else {
                alert("注册失败，请检查账号是否已存在");
            }
        } catch (e) {
            alert("连接服务器失败，请确认 Tomcat 已启动");
        }
    };
</script>
<footer class="project-footer" style="padding: 16px; text-align: center; color: #667085; font-size: 13px;">刘建平 · 校园超市管理系统</footer>
</body>
</html>
