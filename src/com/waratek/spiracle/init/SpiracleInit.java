/*
*  Copyright 2014 Waratek Ltd.
*
*  Licensed under the Apache License, Version 2.0 (the "License");
*  you may not use this file except in compliance with the License.
*  You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
*  Unless required by applicable law or agreed to in writing, software
*  distributed under the License is distributed on an "AS IS" BASIS,
*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*  See the License for the specific language governing permissions and
*  limitations under the License.
*/
package com.waratek.spiracle.init;

import java.beans.PropertyVetoException;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

import com.mchange.v2.c3p0.ComboPooledDataSource;

@WebListener
public class SpiracleInit implements ServletContextListener {
	private static final Logger logger = Logger.getLogger(SpiracleInit.class);

	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		// TODO Auto-generated method stub

	}

	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		ServletContext application = arg0.getServletContext();
		Properties props = loadProperties(application);
		loadLog4jConfig(props);
		ComboPooledDataSource ds = getConnectionPool(props);
		setConnectionPool(application, ds);
	}

	private Properties loadProperties(ServletContext application) {
		Properties props = new Properties();
		File propsFile = new File(application.getRealPath("conf/Spiracle.properties"));
		InputStream propStream;
		try {
			propStream = new FileInputStream(propsFile);
			props.load(propStream);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return props;
	}

	private void loadLog4jConfig(Properties props) {
		Boolean loggingEnabled = Boolean.parseBoolean(((String) props.get("application.loggingEnabled")));
		if(loggingEnabled) {
			PropertyConfigurator.configure(props);
			logger.info("Sucessfully loaded Spiracle log4j configuration.");
		}
	}

	private void setConnectionPool(ServletContext application, ComboPooledDataSource ds) {
		application.setAttribute("connectionPool", ds);
		application.setAttribute("connectionData", ds.toString());
		logger.info("Added connection pool " + ds.getDataSourceName() + "to application context");
	}

	private ComboPooledDataSource getConnectionPool(Properties props) {
		ComboPooledDataSource ds = new ComboPooledDataSource();
		String jdbcDriver = props.getProperty("c3p0.classname");
		String url = props.getProperty("c3p0.url");
		String username = props.getProperty("c3p0.username");
		String password = props.getProperty("c3p0.password");
		int maxPoolSize = 0;
		try {
			maxPoolSize = Integer.parseInt(props.getProperty("c3p0.maxPoolSize"));
		} catch (NumberFormatException e) {
			logger.error("c3p0.maxPoolSize not specified, default value set(25).");
			maxPoolSize = 25;
		}

		try {
			ds.setDriverClass(jdbcDriver);
		} catch (PropertyVetoException e) {
			if(logger.isDebugEnabled()) {
				logger.debug(e.getMessage(), e);
			} else {
				logger.error(e);
			}
		}
		ds.setJdbcUrl(url);
		ds.setUser(username);
		ds.setPassword(password);
		ds.setMinPoolSize(5);
		ds.setAcquireIncrement(5);
		ds.setMaxPoolSize(maxPoolSize);
		return ds;
	}
}
