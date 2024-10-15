package com.waratek.spiracle.misc;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import java.util.NoSuchElementException;

public class CookieUtil
{
    private CookieUtil() {}

    public static boolean containsCookie(HttpServletRequest request, String cookieName)
    {
        Cookie[] cookies = request.getCookies();
        if (cookies == null)
        {
            return false;
        }
        for (Cookie cookie : cookies)
        {
            if (cookie.getName().equals(cookieName))
            {
                return true;
            }
        }
        return false;
    }

    public static String getCookieValue(String cookieName, HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        for (Cookie cookie : cookies){
            if (cookie.getName().equals(cookieName)){
                return cookie.getValue();
            }
        }
        throw new NoSuchElementException("Could not find cookie with name: " + cookieName);
    }
}
