package com.xf.servlet;

import com.alibaba.fastjson2.JSON;
import com.xf.dao.AiQueryDao;
import com.xf.util.AiService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/aiQuery")
public class AiQueryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=utf-8");
        AiService aiService = new AiService(getServletContext());
        AiQueryDao dao = new AiQueryDao();
        String question = req.getParameter("question");
        String sql = aiService.generateSql(question);
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("question", question);
        result.put("sql", sql);
        result.put("aiEnabled", aiService.isConfigured());
        result.put("rows", dao.query(sql));
        resp.getWriter().print(JSON.toJSONString(result));
    }
}
