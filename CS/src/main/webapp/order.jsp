<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园超市管理系统 - 订单</title>
    <style>
        body { margin: 0; font-family: "Microsoft YaHei", Arial, sans-serif; color: #18212f; background: #f4f7f8; }
        header { display: flex; justify-content: space-between; align-items: center; padding: 18px 32px; background: #fff; border-bottom: 1px solid #e6ebf0; }
        h1 { margin: 0; font-size: 22px; } nav a { margin-left: 16px; color: #0f766e; font-weight: 700; text-decoration: none; }
        main { width: min(1160px, calc(100vw - 32px)); margin: 26px auto; display: grid; grid-template-columns: 330px 1fr; gap: 22px; }
        section { padding: 20px; background: #fff; border: 1px solid #e6ebf0; border-radius: 8px; box-shadow: 0 8px 24px rgba(24,33,47,.06); }
        h2 { margin-top: 0; font-size: 18px; } label { display: block; margin: 14px 0 7px; font-weight: 700; font-size: 13px; }
        input, select { width: 100%; height: 40px; padding: 0 10px; box-sizing: border-box; border: 1px solid #c9d4df; border-radius: 6px; }
        button { margin-top: 18px; height: 40px; padding: 0 16px; border: 0; border-radius: 6px; color: #fff; background: #0f766e; font-weight: 700; cursor: pointer; }
        button.secondary { margin: 0; background: #2563eb; } table { width: 100%; border-collapse: collapse; font-size: 14px; }
        th, td { padding: 12px 8px; border-bottom: 1px solid #e8edf2; text-align: left; } th { color: #475467; background: #f8fafc; }
        .empty { color: #667085; text-align: center; } @media (max-width: 800px) { main { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<header>
    <h1>校园超市管理系统 · 订单管理</h1>
    <nav><a href="main.jsp">商品</a><a href="order.jsp">订单</a><a href="payment.jsp">支付</a><a href="review.jsp">评价</a><a href="ai.jsp">AI 中心</a><a href="login.jsp">退出</a></nav>
</header>
<main>
    <section>
        <h2>创建订单</h2>
        <label for="product">商品</label><select id="product"></select>
        <label for="quantity">购买数量</label><input id="quantity" type="number" min="1" value="1">
        <button id="create">提交订单</button>
    </section>
    <section>
        <h2>订单列表</h2>
        <table><thead><tr><th>订单号</th><th>用户</th><th>商品</th><th>数量</th><th>金额</th><th>状态</th><th>时间</th><th>操作</th></tr></thead><tbody id="tbody"></tbody></table>
    </section>
</main>
<script src="axios.js"></script>
<script>
    const API_BASE = "<%= request.getContextPath() %>";
    const account = sessionStorage.getItem("cs_account");
    const product = document.querySelector("#product");
    const tbody = document.querySelector("#tbody");
    if (!account) { location.href = "login.jsp"; }

    async function loadProducts() {
        const resp = await axios.get(API_BASE + "/shopping", {params: {op: "getAll"}});
        product.innerHTML = resp.data.map(item => `<option value="${item.sid}">${item.sname}（库存 ${item.stock}）</option>`).join("");
    }

    async function loadOrders() {
        const resp = await axios.get(API_BASE + "/order", {params: {op: "getMine", account}});
        if (!resp.data.length) { tbody.innerHTML = '<tr><td colspan="8" class="empty">暂无订单</td></tr>'; return; }
        tbody.innerHTML = resp.data.map(item => `<tr><td>${item.oid}</td><td>${item.account}</td><td>${item.sname || item.sid}</td><td>${item.quantity}</td><td>${Number(item.totalAmount).toFixed(2)}</td><td>${item.status}</td><td>${item.createdAt || ""}</td><td>${item.status === "待支付" ? `<button class="secondary" onclick="pay('${item.oid}')">去支付</button>` : ""}</td></tr>`).join("");
    }

    document.querySelector("#create").onclick = async function () {
        const quantity = Number(document.querySelector("#quantity").value);
        if (!product.value || quantity < 1) { alert("请选择商品并填写正确数量"); return; }
        const resp = await axios.get(API_BASE + "/order", {params: {op: "add", account, sid: product.value, quantity}});
        if (Number(resp.data) === 1) { alert("订单创建成功，请前往支付"); await loadProducts(); await loadOrders(); } else { alert("创建失败，库存可能不足"); }
    };

    function pay(oid) { location.href = "payment.jsp?oid=" + encodeURIComponent(oid); }
    loadProducts();
    loadOrders();
</script>
<footer class="project-footer" style="padding: 16px; text-align: center; color: #667085; font-size: 13px;">刘建平 · 校园超市管理系统</footer>
</body>
</html>
