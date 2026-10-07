package com.xf.servlet;

import com.alibaba.fastjson2.JSON;
import com.xf.dao.ShoppingDao;
import com.xf.entity.Shopping;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/shopping")
public class ShoppingServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=utf-8");
        resp.setHeader("Access-Control-Allow-Origin", "*");

        String op = req.getParameter("op");
        switch (op) {
            case "getAll":
                getAll(req, resp);
                break;
            case "search":
                search(req, resp);
                break;
            case "add":
                add(req, resp);
                break;
            case "update":
                update(req, resp);
                break;
            case "delete":
                delete(req, resp);
                break;
            default:
                resp.getWriter().print(0);
        }
    }

    public void getAll(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        ShoppingDao dao = new ShoppingDao();
        List<Shopping> list = dao.getAll();
        PrintWriter pw = resp.getWriter();
        pw.println(JSON.toJSONString(list));
        pw.flush();
    }

    public void search(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        ShoppingDao dao = new ShoppingDao();
        List<Shopping> list = dao.search(req.getParameter("keyword"));
        PrintWriter pw = resp.getWriter();
        pw.println(JSON.toJSONString(list));
        pw.flush();
    }

    public void add(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        ShoppingDao dao = new ShoppingDao();
        int n = dao.add(readShopping(req));
        PrintWriter pw = resp.getWriter();
        pw.println(n);
        pw.flush();
    }

    public void update(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        ShoppingDao dao = new ShoppingDao();
        int n = dao.update(readShopping(req));
        PrintWriter pw = resp.getWriter();
        pw.println(n);
        pw.flush();
    }

    public void delete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String sid = req.getParameter("sid");
        ShoppingDao dao = new ShoppingDao();
        int n = dao.delete(sid);
        PrintWriter pw = resp.getWriter();
        pw.println(n);
        pw.flush();
    }

    private Shopping readShopping(HttpServletRequest req) {
        Shopping shopping = new Shopping();
        shopping.setSid(req.getParameter("sid"));
        shopping.setSname(req.getParameter("sname"));
        shopping.setPrice(Double.parseDouble(req.getParameter("price")));
        shopping.setImage(req.getParameter("image"));
        shopping.setStock(Integer.parseInt(req.getParameter("stock")));
        return shopping;
    }
}
