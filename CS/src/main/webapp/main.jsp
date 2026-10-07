<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园超市管理系统</title>
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
                linear-gradient(180deg, rgba(255, 255, 255, 0.68), rgba(246, 248, 251, 0.96)),
                radial-gradient(circle at 15% 8%, rgba(15, 118, 110, 0.14), transparent 26%),
                radial-gradient(circle at 86% 10%, rgba(37, 99, 235, 0.12), transparent 24%),
                #f4f7f8;
        }

        header {
            position: sticky;
            top: 0;
            z-index: 10;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 18px 32px;
            border-bottom: 1px solid rgba(31, 41, 55, 0.1);
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(18px);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .brand-icon {
            width: 42px;
            height: 42px;
            display: grid;
            place-items: center;
            border-radius: 8px;
            background: linear-gradient(135deg, #0f766e, #2563eb);
            color: #ffffff;
            font-weight: 800;
            box-shadow: 0 12px 28px rgba(15, 118, 110, 0.25);
        }

        h1 {
            margin: 0;
            font-size: 24px;
            line-height: 1.1;
        }

        .subtitle {
            margin: 4px 0 0;
            color: #667085;
            font-size: 13px;
        }

        .user {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #344054;
            font-size: 14px;
        }

        .user a {
            color: #0f766e;
            font-weight: 700;
            text-decoration: none;
        }

        .wrap {
            width: min(1260px, calc(100vw - 32px));
            margin: 26px auto 42px;
            display: grid;
            grid-template-columns: 360px 1fr;
            gap: 22px;
        }

        .panel {
            border: 1px solid rgba(31, 41, 55, 0.1);
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.92);
            box-shadow: 0 18px 48px rgba(24, 33, 47, 0.08);
        }

        .panel-head {
            padding: 18px 20px;
            border-bottom: 1px solid #e6ebf0;
        }

        .panel-head h2 {
            margin: 0;
            font-size: 18px;
        }

        .panel-head p {
            margin: 6px 0 0;
            color: #667085;
            font-size: 13px;
        }

        .form-body {
            padding: 20px;
        }

        label {
            display: block;
            margin: 14px 0 8px;
            color: #344054;
            font-size: 13px;
            font-weight: 700;
        }

        input {
            width: 100%;
            height: 42px;
            padding: 0 12px;
            border: 1px solid #c9d4df;
            border-radius: 8px;
            background: #fbfcfd;
            color: #111827;
            font-size: 14px;
            outline: none;
            transition: border-color 0.18s ease, box-shadow 0.18s ease, background 0.18s ease;
        }

        input:focus {
            border-color: #0f766e;
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(15, 118, 110, 0.12);
        }

        input:disabled {
            color: #64748b;
            background: #eef2f6;
        }

        .row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .actions,
        .search {
            display: flex;
            gap: 10px;
            margin-top: 18px;
        }

        button {
            height: 40px;
            padding: 0 16px;
            border: 0;
            border-radius: 8px;
            background: #2563eb;
            color: #ffffff;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            white-space: nowrap;
            transition: transform 0.18s ease, box-shadow 0.18s ease, background 0.18s ease;
        }

        button:hover {
            transform: translateY(-1px);
            box-shadow: 0 12px 24px rgba(37, 99, 235, 0.2);
        }

        button.secondary {
            background: #475569;
        }

        button.danger {
            background: #dc2626;
        }

        #save {
            flex: 1;
            background: linear-gradient(135deg, #0f766e, #2563eb);
        }

        .list-panel {
            min-width: 0;
        }

        .toolbar {
            padding: 18px 20px;
            border-bottom: 1px solid #e6ebf0;
        }

        .search {
            margin-top: 0;
        }

        .search input {
            flex: 1;
        }

        .table-box {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        th,
        td {
            padding: 14px 16px;
            border-bottom: 1px solid #e8edf2;
            text-align: left;
            vertical-align: middle;
        }

        th {
            color: #475467;
            background: #f8fafc;
            font-size: 12px;
            font-weight: 800;
        }

        tbody tr {
            transition: background 0.18s ease;
        }

        tbody tr:hover {
            background: #f8fbff;
        }

        td:first-child {
            color: #0f766e;
            font-weight: 800;
        }

        img {
            width: 78px;
            height: 58px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #d8e0ea;
            background: #f1f5f9;
        }

        .table-actions {
            display: flex;
            gap: 8px;
        }

        .table-actions button {
            height: 34px;
            padding: 0 12px;
            font-size: 13px;
        }

        .empty {
            padding: 42px 20px;
            color: #667085;
            text-align: center;
        }

        @media (max-width: 920px) {
            header {
                align-items: flex-start;
                flex-direction: column;
                gap: 14px;
                padding: 18px;
            }

            .wrap {
                grid-template-columns: 1fr;
            }

            table {
                min-width: 800px;
            }
        }

        @media (max-width: 560px) {
            .actions,
            .search,
            .user {
                align-items: stretch;
                flex-direction: column;
            }

            .row {
                grid-template-columns: 1fr;
            }

            button {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<header>
    <div class="brand">
        <div class="brand-icon">CS</div>
        <div>
            <h1>校园超市管理系统</h1>
            <p class="subtitle">商品信息、价格、图片与库存统一维护</p>
        </div>
    </div>
    <div class="user">
        <span id="welcome"></span>
        <a href="order.jsp">订单</a>
        <a href="payment.jsp">支付</a>
        <a href="review.jsp">评价</a>
        <a href="ai.jsp">AI 中心</a>
        <button class="secondary" id="logout">退出系统</button>
    </div>
</header>

<main class="wrap">
    <section class="panel">
        <div class="panel-head">
            <h2>商品信息</h2>
            <p>新增或编辑商品资料</p>
        </div>
        <div class="form-body">
            <input id="oldSid" type="hidden">
            <label for="sid">商品编号</label>
            <input id="sid" maxlength="8" placeholder="如：s004">
            <label for="sname">名称</label>
            <input id="sname" maxlength="16" placeholder="请输入商品名称">
            <div class="row">
                <div>
                    <label for="price">价格</label>
                    <input id="price" type="number" min="0" step="0.01" placeholder="0.00">
                </div>
                <div>
                    <label for="stock">库存</label>
                    <input id="stock" type="number" min="0" step="1" placeholder="0">
                </div>
            </div>
            <label for="image">图片文件名</label>
            <input id="image" maxlength="64" placeholder="如：ldb.png">
            <div class="actions">
                <button id="save">新增商品</button>
                <button class="secondary" id="clear">清空</button>
            </div>
        </div>
    </section>

    <section class="panel list-panel">
        <div class="toolbar">
            <div class="search">
                <input id="keyword" placeholder="按商品编号或名称搜索">
                <button id="search">搜索</button>
                <button class="secondary" id="refresh">查询全部</button>
            </div>
        </div>
        <div class="table-box">
            <table>
                <thead>
                <tr>
                    <th>商品编号</th>
                    <th>名称</th>
                    <th>价格</th>
                    <th>库存</th>
                    <th>图片</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody id="tbody"></tbody>
            </table>
        </div>
    </section>
</main>

<script src="axios.js"></script>
<script>
    const API_BASE = "<%= request.getContextPath() %>";
    const fields = {
        oldSid: document.querySelector("#oldSid"),
        sid: document.querySelector("#sid"),
        sname: document.querySelector("#sname"),
        price: document.querySelector("#price"),
        image: document.querySelector("#image"),
        stock: document.querySelector("#stock")
    };
    const tbody = document.querySelector("#tbody");
    const account = sessionStorage.getItem("cs_account");

    if (!account) {
        location.href = "login.jsp";
    }
    document.querySelector("#welcome").textContent = "当前用户：" + account;

    function params(op) {
        return {
            op,
            sid: fields.sid.value.trim(),
            sname: fields.sname.value.trim(),
            price: fields.price.value,
            image: fields.image.value.trim() || "placeholder.png",
            stock: fields.stock.value
        };
    }

    function validateForm() {
        if (!fields.sid.value.trim() || !fields.sname.value.trim() || !fields.price.value || fields.stock.value === "") {
            alert("请填写完整商品信息");
            return false;
        }
        if (Number(fields.price.value) < 0 || Number(fields.stock.value) < 0) {
            alert("价格和库存不能小于 0");
            return false;
        }
        return true;
    }

    function clearForm() {
        fields.oldSid.value = "";
        fields.sid.value = "";
        fields.sname.value = "";
        fields.price.value = "";
        fields.image.value = "";
        fields.stock.value = "";
        document.querySelector("#save").textContent = "新增商品";
        fields.sid.disabled = false;
    }

    function edit(item) {
        fields.oldSid.value = item.sid;
        fields.sid.value = item.sid;
        fields.sname.value = item.sname;
        fields.price.value = item.price;
        fields.image.value = item.image;
        fields.stock.value = item.stock;
        fields.sid.disabled = true;
        document.querySelector("#save").textContent = "修改商品";
    }

    async function remove(sid) {
        if (!confirm("确定删除商品 " + sid + " 吗？")) {
            return;
        }
        const resp = await axios.get(API_BASE + "/shopping", {params: {op: "delete", sid}});
        if (Number(resp.data) === 1) {
            await loadAll();
        } else {
            alert("删除失败");
        }
    }

    function render(list) {
        tbody.innerHTML = "";
        if (!list || list.length === 0) {
            const tr = document.createElement("tr");
            tr.innerHTML = `<td colspan="6" class="empty">暂无商品数据</td>`;
            tbody.appendChild(tr);
            return;
        }
        list.forEach(function (item) {
            const tr = document.createElement("tr");
            tr.innerHTML = `
                <td>${item.sid}</td>
                <td>${item.sname}</td>
                <td>${Number(item.price).toFixed(2)}</td>
                <td>${item.stock}</td>
                <td><img src="image/${item.image || "placeholder.png"}" alt="${item.sname}"></td>
                <td>
                    <div class="table-actions">
                        <button type="button">修改</button>
                        <button type="button" class="danger">删除</button>
                    </div>
                </td>
            `;
            tr.querySelector("button").onclick = function () {
                edit(item);
            };
            tr.querySelector(".danger").onclick = function () {
                remove(item.sid);
            };
            tbody.appendChild(tr);
        });
    }

    async function loadAll() {
        const resp = await axios.get(API_BASE + "/shopping", {params: {op: "getAll"}});
        render(resp.data);
    }

    document.querySelector("#save").onclick = async function () {
        if (!validateForm()) {
            return;
        }
        const op = fields.oldSid.value ? "update" : "add";
        const resp = await axios.get(API_BASE + "/shopping", {params: params(op)});
        if (Number(resp.data) === 1) {
            clearForm();
            await loadAll();
        } else {
            alert("保存失败，请检查商品编号是否重复");
        }
    };

    document.querySelector("#clear").onclick = clearForm;
    document.querySelector("#refresh").onclick = loadAll;
    document.querySelector("#search").onclick = async function () {
        const resp = await axios.get(API_BASE + "/shopping", {
            params: {
                op: "search",
                keyword: document.querySelector("#keyword").value.trim()
            }
        });
        render(resp.data);
    };
    document.querySelector("#logout").onclick = function () {
        sessionStorage.removeItem("cs_account");
        location.href = "login.jsp";
    };

    loadAll();
</script>
<footer class="project-footer" style="padding: 16px; text-align: center; color: #667085; font-size: 13px;">刘建平 · 校园超市管理系统</footer>
</body>
</html>
