package com.xf.servlet;

import com.alibaba.fastjson2.JSON;
import com.xf.dao.ReviewDao;
import com.xf.entity.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=utf-8");
        resp.setHeader("Access-Control-Allow-Origin", "*");

        String op = req.getParameter("op");
        ReviewDao dao = new ReviewDao();
        if ("getAll".equals(op)) {
            resp.getWriter().print(JSON.toJSONString(dao.getAll()));
        } else if ("add".equals(op)) {
            resp.getWriter().print(dao.add(readReview(req)));
        } else if ("update".equals(op)) {
            resp.getWriter().print(dao.update(readReview(req)));
        } else if ("delete".equals(op)) {
            resp.getWriter().print(dao.delete(req.getParameter("rid"), req.getParameter("account")));
        } else {
            resp.getWriter().print(0);
        }
    }

    private Review readReview(HttpServletRequest req) {
        Review review = new Review();
        review.setRid(req.getParameter("rid") == null || req.getParameter("rid").isEmpty() ?
                "R" + System.currentTimeMillis() : req.getParameter("rid"));
        review.setSid(req.getParameter("sid"));
        review.setAccount(req.getParameter("account"));
        review.setScore(Integer.parseInt(req.getParameter("score")));
        review.setContent(req.getParameter("content"));
        return review;
    }
}
