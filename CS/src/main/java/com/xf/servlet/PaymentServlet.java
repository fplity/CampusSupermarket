package com.xf.servlet;

import com.alibaba.fastjson2.JSON;
import com.xf.dao.PaymentDao;
import com.xf.entity.Payment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=utf-8");
        resp.setHeader("Access-Control-Allow-Origin", "*");

        String op = req.getParameter("op");
        PaymentDao dao = new PaymentDao();
        if ("getAll".equals(op)) {
            resp.getWriter().print(JSON.toJSONString(dao.getAll()));
        } else if ("getMine".equals(op)) {
            resp.getWriter().print(JSON.toJSONString(dao.getByAccount(req.getParameter("account"))));
        } else if ("add".equals(op)) {
            Payment payment = new Payment();
            payment.setPid("P" + System.currentTimeMillis());
            payment.setOid(req.getParameter("oid"));
            payment.setPayMethod(req.getParameter("payMethod"));
            resp.getWriter().print(dao.add(payment));
        } else {
            resp.getWriter().print(0);
        }
    }
}
