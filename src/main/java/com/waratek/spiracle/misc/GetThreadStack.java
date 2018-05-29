package com.waratek.spiracle.misc;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author skenny
 */
@WebServlet("/GetThreadStack")
public class GetThreadStack extends HttpServlet {

    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(GetThreadStack.class);
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeRequest(request, response);
    }

    private void executeRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            HttpSession session = request.getSession();
            String threadName = request.getParameter("threadName");

            Map<Thread, StackTraceElement[]> stacktraceMap = Thread.getAllStackTraces();
            Set<Thread> threadSet = stacktraceMap.keySet();

            List<StackTraceElement> stackTrace = null;
            for (Thread thread : threadSet.toArray(new Thread[threadSet.size()])) {
                if (thread.getName().equals(threadName)) {
                    logger.info("Found thread: " + threadName + ". Getting Stack Trace.");
                    stackTrace = new ArrayList<StackTraceElement>(Arrays.asList(stacktraceMap.get(thread)));
                }
            }

            session.setAttribute("stackTrace", stackTrace);
            session.setAttribute("threadName", threadName);
            response.sendRedirect("misc.jsp");

        } catch (SecurityException ex) {
            Logger.getLogger(GetThreadStack.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IllegalArgumentException ex) {
            Logger.getLogger(GetThreadStack.class.getName()).log(Level.SEVERE, null, ex);
        }

    }
}
