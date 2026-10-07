<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园超市管理系统 - AI 中心</title>
    <style>
        body { margin:0; font-family:"Microsoft YaHei",Arial,sans-serif; color:#18212f; background:#f4f7f8; } header { display:flex; justify-content:space-between; align-items:center; padding:18px 32px; background:#fff; border-bottom:1px solid #e6ebf0; } h1 { margin:0; font-size:22px; } nav a { margin-left:16px; color:#0f766e; font-weight:700; text-decoration:none; } main { width:min(1100px,calc(100vw - 32px)); margin:26px auto; display:grid; gap:22px; } section { padding:22px; background:#fff; border:1px solid #e6ebf0; border-radius:8px; } h2 { margin:0 0 12px; font-size:18px; } p { color:#667085; line-height:1.7; } .query { display:flex; gap:10px; } input { flex:1; height:42px; padding:0 12px; border:1px solid #c9d4df; border-radius:6px; font-size:14px; } button { height:42px; padding:0 18px; border:0; border-radius:6px; color:#fff; background:#2563eb; font-weight:700; cursor:pointer; } button.report { background:#0f766e; } pre { white-space:pre-wrap; word-break:break-word; padding:14px; border-radius:6px; background:#f8fafc; border:1px solid #e6ebf0; } table { width:100%; border-collapse:collapse; font-size:14px; } th,td { padding:10px 8px; border-bottom:1px solid #e8edf2; text-align:left; } th { background:#f8fafc; color:#475467; } .tips { display:flex; flex-wrap:wrap; gap:8px; } .tips button { height:32px; background:#475569; font-size:12px; } @media(max-width:800px){header{align-items:flex-start;flex-direction:column;gap:12px}.query{flex-direction:column;}}
    </style>
</head>
<body>
<header><h1>校园超市管理系统 · AI 中心</h1><nav><a href="main.jsp">商品</a><a href="order.jsp">订单</a><a href="payment.jsp">支付</a><a href="review.jsp">评价</a><a href="ai.jsp">AI 中心</a><a href="login.jsp">退出</a></nav></header>
<main>
    <section><h2>AI 智能查询</h2><p>支持商品库存查询、订单关联查询、销售聚合统计和评价统计。系统会生成并校验只读 SQL，再返回查询结果。</p><div class="query"><input id="question" placeholder="例如：查询库存最低的商品，或统计各订单状态的销售金额"><button id="query">AI 查询</button></div><div class="tips"><button onclick="fillQuestion('查询库存最低的商品')">库存查询</button><button onclick="fillQuestion('统计各订单状态的销售金额')">订单聚合</button><button onclick="fillQuestion('查询商品平均评分')">评价统计</button></div><pre id="sql">等待查询</pre><div id="result"></div></section>
    <section><h2>AI 智能经营报告</h2><p>从商品、订单、支付和库存数据中提取统计指标，生成包含经营概况、库存风险和建议的报告。</p><button class="report" id="report">生成报告</button><button id="download">导出报告</button><pre id="reportText">等待生成</pre></section>
</main>
<script src="axios.js"></script>
<script>
    const API_BASE = "<%= request.getContextPath() %>";
    if (!sessionStorage.getItem("cs_account")) { location.href = "login.jsp"; }
    const question = document.querySelector("#question");
    function fillQuestion(value){question.value=value;}
    function renderRows(rows){if(!rows||!rows.length){return '<p>没有查询到数据</p>';}const columns=Object.keys(rows[0]);return `<table><thead><tr>${columns.map(key=>`<th>${key}</th>`).join("")}</tr></thead><tbody>${rows.map(row=>`<tr>${columns.map(key=>`<td>${row[key] == null ? "" : row[key]}</td>`).join("")}</tr>`).join("")}</tbody></table>`;}
    document.querySelector("#query").onclick=async function(){if(!question.value.trim()){alert("请输入查询问题");return;}const resp=await axios.get(API_BASE+"/aiQuery",{params:{question:question.value.trim()}});document.querySelector("#sql").textContent=(resp.data.aiEnabled?"AI 已调用\n":"当前为本地演示规则，配置 AI_API_URL 和 AI_API_KEY 后将调用模型\n")+resp.data.sql;document.querySelector("#result").innerHTML=renderRows(resp.data.rows);};
    document.querySelector("#report").onclick=async function(){const resp=await axios.get(API_BASE+"/aiReport");document.querySelector("#reportText").textContent=(resp.data.aiEnabled?"AI 已调用\n\n":"当前为本地报告模板，配置 AI_API_URL 和 AI_API_KEY 后将调用模型\n\n")+resp.data.report;};
    document.querySelector("#download").onclick=function(){const text=document.querySelector("#reportText").textContent;if(text==="等待生成"){alert("请先生成报告");return;}const blob=new Blob([text],{type:"text/plain;charset=utf-8"});const link=document.createElement("a");link.href=URL.createObjectURL(blob);link.download="校园超市AI经营报告.txt";link.click();URL.revokeObjectURL(link.href);};
</script>
<footer class="project-footer" style="padding: 16px; text-align: center; color: #667085; font-size: 13px;">刘煜平 · 校园超市管理系统</footer>
</body>
</html>
