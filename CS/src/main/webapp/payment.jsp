<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园超市管理系统 - 支付</title>
    <style>
        body { margin: 0; font-family: "Microsoft YaHei", Arial, sans-serif; color: #18212f; background: #f4f7f8; } header { display:flex; justify-content:space-between; align-items:center; padding:18px 32px; background:#fff; border-bottom:1px solid #e6ebf0; } h1 { margin:0; font-size:22px; } nav a { margin-left:16px; color:#0f766e; font-weight:700; text-decoration:none; } main { width:min(1160px,calc(100vw - 32px)); margin:26px auto; display:grid; grid-template-columns:330px 1fr; gap:22px; } section { padding:20px; background:#fff; border:1px solid #e6ebf0; border-radius:8px; } h2 { margin-top:0; font-size:18px; } label { display:block; margin:14px 0 7px; font-size:13px; font-weight:700; } select,input { width:100%; height:40px; padding:0 10px; box-sizing:border-box; border:1px solid #c9d4df; border-radius:6px; } button { margin-top:18px; height:40px; padding:0 16px; border:0; border-radius:6px; color:#fff; background:#2563eb; font-weight:700; cursor:pointer; } table { width:100%; border-collapse:collapse; font-size:14px; } th,td { padding:12px 8px; border-bottom:1px solid #e8edf2; text-align:left; } th { background:#f8fafc; color:#475467; } .empty { color:#667085; text-align:center; } @media(max-width:800px){main{grid-template-columns:1fr;}}
    </style>
</head>
<body>
<header><h1>校园超市管理系统 · 支付管理</h1><nav><a href="main.jsp">商品</a><a href="order.jsp">订单</a><a href="payment.jsp">支付</a><a href="review.jsp">评价</a><a href="ai.jsp">AI 中心</a><a href="login.jsp">退出</a></nav></header>
<main>
    <section><h2>订单支付</h2><label for="oid">待支付订单</label><select id="oid"></select><label for="payMethod">支付方式</label><select id="payMethod"><option value="微信支付">微信支付</option><option value="支付宝">支付宝</option><option value="现金支付">现金支付</option></select><button id="pay">确认支付</button></section>
    <section><h2>支付记录</h2><table><thead><tr><th>支付单号</th><th>订单号</th><th>用户</th><th>金额</th><th>方式</th><th>状态</th><th>时间</th></tr></thead><tbody id="tbody"></tbody></table></section>
</main>
<script src="axios.js"></script>
<script>
    const API_BASE = "<%= request.getContextPath() %>";
    const account = sessionStorage.getItem("cs_account");
    const oid = document.querySelector("#oid");
    const tbody = document.querySelector("#tbody");
    if (!account) { location.href = "login.jsp"; }

    function queryValue(name) { return new URLSearchParams(location.search).get(name); }
    async function loadOrders() { const resp = await axios.get(API_BASE + "/order", {params:{op:"getMine",account}}); const current=queryValue("oid"); const list=resp.data.filter(item => item.status === "待支付"); oid.innerHTML=list.map(item => `<option value="${item.oid}" ${item.oid===current?"selected":""}>${item.oid} · ${item.sname || item.sid} · ${Number(item.totalAmount).toFixed(2)} 元</option>`).join(""); }
    async function loadPayments() { const resp=await axios.get(API_BASE + "/payment",{params:{op:"getMine",account}}); tbody.innerHTML=resp.data.length?resp.data.map(item=>`<tr><td>${item.pid}</td><td>${item.oid}</td><td>${item.account}</td><td>${Number(item.payAmount).toFixed(2)}</td><td>${item.payMethod}</td><td>${item.payStatus}</td><td>${item.payTime || ""}</td></tr>`).join(""):'<tr><td colspan="7" class="empty">暂无支付记录</td></tr>'; }
    document.querySelector("#pay").onclick=async function(){ if(!oid.value){alert("暂无待支付订单");return;} const resp=await axios.get(API_BASE+"/payment",{params:{op:"add",oid:oid.value,payMethod:document.querySelector("#payMethod").value}}); if(Number(resp.data)===1){alert("支付成功");await loadOrders();await loadPayments();}else{alert("支付失败，订单可能已支付");} };
    loadOrders(); loadPayments();
</script>
<footer class="project-footer" style="padding: 16px; text-align: center; color: #667085; font-size: 13px;">刘煜平 · 校园超市管理系统</footer>
</body>
</html>
