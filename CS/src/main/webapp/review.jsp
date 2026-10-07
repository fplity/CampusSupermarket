<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园超市管理系统 - 评价</title>
    <style>
        body { margin:0; font-family:"Microsoft YaHei",Arial,sans-serif; color:#18212f; background:#f4f7f8; } header { display:flex; justify-content:space-between; align-items:center; padding:18px 32px; background:#fff; border-bottom:1px solid #e6ebf0; } h1 { margin:0; font-size:22px; } nav a { margin-left:16px; color:#0f766e; font-weight:700; text-decoration:none; } main { width:min(1160px,calc(100vw - 32px)); margin:26px auto; display:grid; grid-template-columns:330px 1fr; gap:22px; } section { padding:20px; background:#fff; border:1px solid #e6ebf0; border-radius:8px; } h2 { margin-top:0; font-size:18px; } label { display:block; margin:14px 0 7px; font-size:13px; font-weight:700; } select,textarea { width:100%; padding:10px; box-sizing:border-box; border:1px solid #c9d4df; border-radius:6px; } textarea { min-height:94px; resize:vertical; } button { margin-top:18px; height:40px; padding:0 16px; border:0; border-radius:6px; color:#fff; background:#0f766e; font-weight:700; cursor:pointer; } button.danger { margin:0; background:#dc2626; } table { width:100%; border-collapse:collapse; font-size:14px; } th,td { padding:12px 8px; border-bottom:1px solid #e8edf2; text-align:left; } th { color:#475467; background:#f8fafc; } .empty { color:#667085; text-align:center; } @media(max-width:800px){main{grid-template-columns:1fr;}}
    </style>
</head>
<body>
<header><h1>校园超市管理系统 · 商品评价</h1><nav><a href="main.jsp">商品</a><a href="order.jsp">订单</a><a href="payment.jsp">支付</a><a href="review.jsp">评价</a><a href="ai.jsp">AI 中心</a><a href="login.jsp">退出</a></nav></header>
<main>
    <section><h2>发布评价</h2><input id="rid" type="hidden"><label for="sid">商品</label><select id="sid"></select><label for="score">评分</label><select id="score"><option value="5">5 分</option><option value="4">4 分</option><option value="3">3 分</option><option value="2">2 分</option><option value="1">1 分</option></select><label for="content">评价内容</label><textarea id="content" maxlength="200" placeholder="请输入商品评价"></textarea><button id="save">提交评价</button></section>
    <section><h2>评价列表</h2><table><thead><tr><th>商品</th><th>用户</th><th>评分</th><th>内容</th><th>时间</th><th>操作</th></tr></thead><tbody id="tbody"></tbody></table></section>
</main>
<script src="axios.js"></script>
<script>
    const API_BASE = "<%= request.getContextPath() %>";
    const account = sessionStorage.getItem("cs_account");
    const sid = document.querySelector("#sid");
    const tbody = document.querySelector("#tbody");
    if (!account) { location.href = "login.jsp"; }
    async function loadProducts(){const resp=await axios.get(API_BASE+"/shopping",{params:{op:"getAll"}});sid.innerHTML=resp.data.map(item=>`<option value="${item.sid}">${item.sname}</option>`).join("");}
    async function loadReviews(){const resp=await axios.get(API_BASE+"/review",{params:{op:"getAll"}});tbody.innerHTML=resp.data.length?resp.data.map(item=>`<tr><td>${item.sname || item.sid}</td><td>${item.account}</td><td>${item.score} 分</td><td>${item.content}</td><td>${item.createdAt || ""}</td><td>${item.account===account?`<button class="danger" onclick="removeReview('${item.rid}')">删除</button>`:""}</td></tr>`).join(""):'<tr><td colspan="6" class="empty">暂无评价</td></tr>';}
    document.querySelector("#save").onclick=async function(){if(!sid.value||!document.querySelector("#content").value.trim()){alert("请选择商品并填写评价");return;}const resp=await axios.get(API_BASE+"/review",{params:{op:"add",sid:sid.value,account,score:document.querySelector("#score").value,content:document.querySelector("#content").value.trim()}});if(Number(resp.data)===1){document.querySelector("#content").value="";await loadReviews();}else{alert("提交失败");}};
    async function removeReview(rid){if(!confirm("确定删除该评价吗？")){return;}const resp=await axios.get(API_BASE+"/review",{params:{op:"delete",rid,account}});if(Number(resp.data)===1){await loadReviews();}else{alert("删除失败");}}
    loadProducts();loadReviews();
</script>
<footer class="project-footer" style="padding: 16px; text-align: center; color: #667085; font-size: 13px;">刘建平 · 校园超市管理系统</footer>
</body>
</html>
