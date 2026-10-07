package com.xf.servlet;

import com.alibaba.fastjson2.JSON;
import com.xf.dao.UserDao;
import com.xf.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/user")
public class UserServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=utf-8");
        resp.setHeader("Access-Control-Allow-Origin", "*");

        String op = req.getParameter("op");
        switch (op) {
            case "login":
                login(req, resp);
                break;
            case "getAll":
                getAll(resp);
                break;
            case "register":
                register(req, resp);
                break;
            case "delete":
                delete(req, resp);
                break;
            default:
                resp.getWriter().print(false);
        }
    }

    public void register(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String account = getAccount(req);
        String password = req.getParameter("password");
        String tel = req.getParameter("tel");
        User user = new User();
        user.setAccount(account);
        user.setPassword(password);
        user.setTel(tel);
        UserDao dao = new UserDao();
        int n = dao.register(user);
        PrintWriter pw = resp.getWriter();
        pw.println(n);
        pw.flush();
    }

    public void login(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String account = getAccount(req);
        String password = req.getParameter("password");
        UserDao dao = new UserDao();
        boolean flag = dao.login(account, password);
        PrintWriter pw = resp.getWriter();
        pw.println(flag);
        pw.flush();
    }

    public void getAll(HttpServletResponse resp) throws IOException {
        UserDao dao = new UserDao();
        resp.getWriter().println(JSON.toJSONString(dao.getAll()));
    }

    public void delete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String tel = req.getParameter("tel");
        UserDao dao = new UserDao();
        int n = dao.delete(tel);
        PrintWriter pw = resp.getWriter();
        pw.println(n);
        pw.flush();
    }

    private String getAccount(HttpServletRequest req) {
        String account = req.getParameter("account");
        if (account == null || account.isEmpty()) {
            account = req.getParameter("username");
        }
        return account;
    }
}
