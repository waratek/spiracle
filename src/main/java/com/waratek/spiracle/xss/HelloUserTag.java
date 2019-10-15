package com.waratek.spiracle.xss;

import javax.servlet.jsp.tagext.*;
import javax.servlet.jsp.*;
import java.io.*;

public class HelloUserTag extends SimpleTagSupport {

   private String username;
   private StringWriter sw = new StringWriter();

   public void setUsername(String name) {
        this.username = name;
   }

   public void doTag() throws JspException, IOException {
        JspWriter out = getJspContext().getOut();
        getJspBody().invoke(sw);

        out.println("Hello Spiracle user: <b>" + username + "</b>!");
        out.println("<br/>");

        JspWriter oldout;
        do {
            oldout = getJspContext().getOut();
            out = getJspContext().popBody();
        } while (oldout != out);

        out.print("Welcome to Spiracle");
        out.write(", an insecure web application used to test system security controls.".toCharArray());
        out.println("<br/>");

        getJspContext().getOut().println(sw.toString());
   }
}