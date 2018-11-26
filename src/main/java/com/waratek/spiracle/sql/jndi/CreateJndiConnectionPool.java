package com.waratek.spiracle.sql.jndi;

import org.apache.log4j.Logger;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;


public class CreateJndiConnectionPool implements ServletContextListener {
	private static final Logger logger = Logger.getLogger(CreateJndiConnectionPool.class);

	public void contextDestroyed(ServletContextEvent arg0) {

	}

	public void contextInitialized(ServletContextEvent arg0) {
		// java4
		/*
		try {
			Context ctx = new InitialContext();
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/oracle");
			ServletContext application = arg0.getServletContext();
			application.setAttribute("jndiConnectionPool", ds);
			logger.info("Added jndi connection pool " + ds + " to application context.");
		} catch (NamingException e) {
			logger.error("JNDI reference not found.");
			e.printStackTrace();
		}
		*/
	}
}
