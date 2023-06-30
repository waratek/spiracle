package com.waratek.spiracle.cookie;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/CookieServlet")
public class CookieServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String name = req.getParameter("cookieName");
        String value = req.getParameter("cookieValue");
        String secure = req.getParameter("secure");
        String path = req.getParameter("cookiePath");

        Cookie cookie = new Cookie(name, value);
        if (secure.equals("yes")) {
            cookie.setSecure(true);
        }

        if (path != null) {
            cookie.setPath(path);
        }

        res.addCookie(cookie);

        RequestDispatcher requestDispatcher = req
                .getRequestDispatcher("/cookie.jsp");
        requestDispatcher.forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
