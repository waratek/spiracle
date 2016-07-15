package com.waratek.spiracle.misc;

import java.io.IOException;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ThreadKill")
public class ThreadKill extends HttpServlet {

    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(ThreadKill.class);
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeRequest(request, response);
    }

    private void executeRequest(HttpServletRequest request, HttpServletResponse response) {
        try {
            String[] threadNames = request.getParameterValues("threadNames");

            Set<Thread> threadSet = Thread.getAllStackTraces().keySet();
            Thread[] threadArray = threadSet.toArray(new Thread[threadSet.size()]);

            for (String threadName : threadNames) {
                for (Thread thread : threadArray) {
                    if (thread.getName().equals(threadName)) {
                        logger.info(thread);
                        thread.stop();
                    }
                }
            }
            response.sendRedirect("misc.jsp");
        } catch (SecurityException ex) {
            Logger.getLogger(ThreadKill.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IllegalArgumentException ex) {
            Logger.getLogger(ThreadKill.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(ThreadKill.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
