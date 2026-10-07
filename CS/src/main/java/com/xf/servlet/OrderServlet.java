package com.xf.servlet;

import com.alibaba.fastjson2.JSON;
import com.xf.dao.OrderDao;
import com.xf.entity.MallOrder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=utf-8");
        resp.setHeader("Access-Control-Allow-Origin", "*");

        String op = req.getParameter("op");
        OrderDao dao = new OrderDao();
        if ("getAll".equals(op)) {
            resp.getWriter().print(JSON.toJSONString(dao.getAll()));
        } else if ("getMine".equals(op)) {
            resp.getWriter().print(JSON.toJSONString(dao.getByAccount(req.getParameter("account"))));
        } else if ("add".equals(op)) {
            MallOrder order = new MallOrder();
            order.setOid("O" + System.currentTimeMillis());
            order.setAccount(req.getParameter("account"));
            order.setSid(req.getParameter("sid"));
            order.setQuantity(Integer.parseInt(req.getParameter("quantity")));
            resp.getWriter().print(dao.add(order));
        } else if ("finish".equals(op)) {
            resp.getWriter().print(dao.updateStatus(req.getParameter("oid"), "已完成"));
        } else {
            resp.getWriter().print(0);
        }
    }
}
