package com.waratek.spiracle.sql.jndi;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

@WebListener
public class CreateJndiConnectionPool implements ServletContextListener {
	private static final Logger logger = Logger.getLogger(CreateJndiConnectionPool.class);

	@Resource(name = "jdbc/oracle")
	DataSource ds;

	@Override
	public void contextDestroyed(ServletContextEvent arg0) {

	}

	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		ServletContext application = arg0.getServletContext();
		application.setAttribute("jndiConnectionPool", ds);
			logger.info("Added jndi connection pool " + ds + " to application context.");
	}
}
