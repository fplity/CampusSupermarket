package com.xf.util;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import jakarta.servlet.ServletContext;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.Properties;

public class AiService {
    private final Properties fileProperties = new Properties();

    public AiService() {
    }

    public AiService(ServletContext servletContext) {
        if (servletContext == null) {
            return;
        }
        try (InputStream input = servletContext.getResourceAsStream("/WEB-INF/ai.properties")) {
            if (input != null) {
                fileProperties.load(input);
            }
        } catch (IOException ignored) {
        }
    }

    private static final String SCHEMA = "数据库结构：shopping(sid,sname,price,image,stock)，" +
            "mall_order(oid,account,sid,quantity,total_amount,status,created_at)，" +
            "payment(pid,oid,pay_amount,pay_method,pay_status,pay_time)，" +
            "review(rid,sid,account,score,content,created_at)。";

    public String generateSql(String question) {
        String prompt = "你是校园超市数据库助手。" + SCHEMA +
                "只返回一条 MySQL SELECT 查询，不要解释，不要使用分号。" +
                "示例：查询库存不足商品 -> select sid,sname,stock from shopping where stock<10 order by stock；" +
                "示例：统计已支付订单金额 -> select sum(total_amount) as sales_amount from mall_order where status in ('已支付','已完成')。" +
                "用户问题：" + question;
        String result = call(prompt);
        if (isSafeSelect(result)) {
            return cleanSql(result);
        }
        return localSql(question);
    }

    public String generateReport(Map<String, Object> summary) {
        String prompt = "你是校园超市经营分析助手。请根据统计数据生成简洁的中文经营报告，" +
                "包含概况、库存风险和建议三部分。统计数据：" + JSON.toJSONString(summary);
        String result = call(prompt);
        if (result != null && !result.trim().isEmpty()) {
            return result.trim();
        }
        return "经营概况：当前商品 " + summary.get("product_count") + " 件，订单 " + summary.get("order_count") +
                " 笔，已支付 " + summary.get("paid_count") + " 笔，累计销售额 " + summary.get("sales_amount") + " 元。\n" +
                "库存风险：库存不足 10 件的商品有 " + summary.get("low_stock_count") + " 件。\n" +
                "建议：优先补充低库存商品，并持续跟踪待支付订单的转化情况。";
    }

    public boolean isConfigured() {
        return getValue("AI_API_URL") != null && getValue("AI_API_KEY") != null;
    }

    private String call(String prompt) {
        String apiUrl = getValue("AI_API_URL");
        String apiKey = getValue("AI_API_KEY");
        if (apiUrl == null || apiKey == null) {
            return "";
        }
        try {
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(30000);
            conn.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
            conn.setRequestProperty("Authorization", "Bearer " + apiKey);
            conn.setDoOutput(true);

            JSONObject body = new JSONObject();
            body.put("model", getValue("AI_MODEL") == null ? "gpt-4o-mini" : getValue("AI_MODEL"));
            JSONArray messages = new JSONArray();
            JSONObject message = new JSONObject();
            message.put("role", "user");
            message.put("content", prompt);
            messages.add(message);
            body.put("messages", messages);
            body.put("temperature", 0.2);
            try (OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream(), StandardCharsets.UTF_8)) {
                writer.write(body.toJSONString());
            }
            if (conn.getResponseCode() < 200 || conn.getResponseCode() >= 300) {
                return "";
            }
            StringBuilder text = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    text.append(line);
                }
            }
            JSONObject response = JSON.parseObject(text.toString());
            return response.getJSONArray("choices").getJSONObject(0).getJSONObject("message").getString("content");
        } catch (Exception e) {
            return "";
        }
    }

    private String getValue(String key) {
        String value = System.getenv(key);
        if (value == null || value.trim().isEmpty()) {
            value = System.getProperty(key);
        }
        if (value == null || value.trim().isEmpty()) {
            value = fileProperties.getProperty(key);
        }
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }

    private boolean isSafeSelect(String sql) {
        if (sql == null) {
            return false;
        }
        String value = cleanSql(sql).toLowerCase();
        return value.startsWith("select ") && !value.contains(";") && !value.contains("--") &&
                !value.contains("/*") && !value.contains("insert ") && !value.contains("update ") &&
                !value.contains("delete ") && !value.contains("drop ") && !value.contains("alter ");
    }

    private String cleanSql(String sql) {
        return sql.replace("```sql", "").replace("```", "").trim();
    }

    private String localSql(String question) {
        String value = question == null ? "" : question;
        if (value.contains("库存") || value.contains("缺货")) {
            return "select sid,sname,stock,price from shopping order by stock asc";
        }
        if (value.contains("销售") || value.contains("金额") || value.contains("订单统计")) {
            return "select status,count(*) as order_count,sum(total_amount) as sales_amount from mall_order group by status";
        }
        if (value.contains("评价")) {
            return "select s.sname,avg(r.score) as avg_score,count(*) as review_count from review r left join shopping s on r.sid=s.sid group by r.sid,s.sname";
        }
        return "select sid,sname,price,stock from shopping order by sid";
    }
}
