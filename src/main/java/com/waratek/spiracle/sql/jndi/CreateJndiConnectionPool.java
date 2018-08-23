package com.waratek.spiracle.sql.jndi;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

@WebListener
public class CreateJndiConnectionPool implements ServletContextListener {
	private static final Logger logger = Logger.getLogger(CreateJndiConnectionPool.class);

	public void contextDestroyed(ServletContextEvent arg0) {

	}

	public void contextInitialized(ServletContextEvent arg0) {
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
	}
}
