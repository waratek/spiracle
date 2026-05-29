package com.waratek.spiracle.misc;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author skenny
 */
public class GetThreadStack extends HttpServlet {

    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(GetThreadStack.class);
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeRequest(request, response);
    }

    private void executeRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            HttpSession session = request.getSession();
            String threadName = request.getParameter("threadName");

            Map stacktraceMap = Thread.getAllStackTraces();
            Set threadSet = stacktraceMap.keySet();

            List stackTrace = null;
            Thread[] threadArray = (Thread[]) threadSet.toArray(new Thread[threadSet.size()]);
            for (int i = 0; i < threadArray.length; i++) {
                Thread thread = threadArray[i];
                if (thread.getName().equals(threadName)) {
                    logger.info("Found thread: " + threadName + ". Getting Stack Trace.");
                    stackTrace = new ArrayList(Arrays.asList((StackTraceElement[]) stacktraceMap.get(thread)));
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
