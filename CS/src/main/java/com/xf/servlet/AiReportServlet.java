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

@WebServlet("/aiReport")
public class AiReportServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=utf-8");
        AiQueryDao dao = new AiQueryDao();
        AiService aiService = new AiService(getServletContext());
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("summary", dao.getSummary());
        result.put("report", aiService.generateReport(dao.getSummary()));
        result.put("aiEnabled", aiService.isConfigured());
        resp.getWriter().print(JSON.toJSONString(result));
    }
}
