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
import com.waratek.spiracle.sql.util.Constants;
import java.text.MessageFormat;

@WebListener
public class SpiracleInit implements ServletContextListener {

    private static final Logger logger = Logger.getLogger(SpiracleInit.class);

    public void contextDestroyed(ServletContextEvent arg0) {
        ServletContext application = arg0.getServletContext();
        ((ComboPooledDataSource) application.getAttribute(Constants.ORACLE_CONNECTION_POOL)).close();
        ((ComboPooledDataSource) application.getAttribute(Constants.MYSQL_CONNECTION_POOL)).close();
        ((ComboPooledDataSource) application.getAttribute(Constants.MSSQL_CONNECTION_POOL)).close();
        ((ComboPooledDataSource) application.getAttribute(Constants.DB2_CONNECTION_POOL)).close();
        ((ComboPooledDataSource) application.getAttribute(Constants.SYBASE_CONNECTION_POOL)).close();
        ((ComboPooledDataSource) application.getAttribute(Constants.POSTGRES_CONNECTION_POOL)).close();
    }

    public void contextInitialized(ServletContextEvent arg0) {
        ServletContext application = arg0.getServletContext();
        Properties props = loadProperties(application);
        loadLog4jConfig(props);
        logServerInfo(application);
        setDefaultErrorCode(application, props);

        ComboPooledDataSource oracleDs = getConnectionPool(props, Constants.ORACLE);
        setNamedConnectionPool(application, oracleDs, Constants.ORACLE_CONNECTION_POOL, Constants.ORACLE_CONNECTION_DATA);

        ComboPooledDataSource mySqlDs = getConnectionPool(props, Constants.MYSQL);
        setNamedConnectionPool(application, mySqlDs, Constants.MYSQL_CONNECTION_POOL, Constants.MYSQL_CONNECTION_DATA);

        ComboPooledDataSource msSqlDs = getConnectionPool(props, Constants.MSSQL);
        setNamedConnectionPool(application, msSqlDs, Constants.MSSQL_CONNECTION_POOL, Constants.MSSQL_CONNECTION_DATA);

        ComboPooledDataSource db2SqlDs = getConnectionPool(props, Constants.DB2);
        setNamedConnectionPool(application, db2SqlDs, Constants.DB2_CONNECTION_POOL, Constants.DB2_CONNECTION_DATA);

        ComboPooledDataSource sybaseSqlDs = getConnectionPool(props, Constants.SYBASE);
        setNamedConnectionPool(application, sybaseSqlDs, Constants.SYBASE_CONNECTION_POOL, Constants.SYBASE_CONNECTION_DATA);

        ComboPooledDataSource postgresSqlDs = getConnectionPool(props, Constants.POSTGRES);
        setNamedConnectionPool(application, postgresSqlDs, Constants.POSTGRES_CONNECTION_POOL, Constants.POSTGRES_CONNECTION_DATA);

        setDefaultConnection(application, props);
        setFetchSize(application, props);
        try {
            Class.forName(props.getProperty(Constants.C3P0_ORACLE_CLASSNAME));
            Class.forName(props.getProperty(Constants.C3P0_MYSQL_CLASSNAME));
            Class.forName(props.getProperty(Constants.C3P0_MSSQL_CLASSNAME));
            Class.forName(props.getProperty(Constants.C3P0_DB2_CLASSNAME));
            Class.forName(props.getProperty(Constants.C3P0_SYBASE_CLASSNAME));
            Class.forName(props.getProperty(Constants.C3P0_POSTGRES_CLASSNAME));
        } catch (ClassNotFoundException e) {
            logger.error("Unable to load JDBC connector classes from config.");
            e.printStackTrace();
        }
    }

    private Properties loadProperties(ServletContext application) {
        Properties props = new Properties();
        try {
            String filePath = application.getRealPath("conf/Spiracle.properties");
            File propsFile;
            InputStream propStream;
            if (filePath != null) {
                propsFile = new File(application.getRealPath("conf/Spiracle.properties"));
                propStream = new FileInputStream(propsFile);
            } else {
                propStream = application.getResourceAsStream("conf/Spiracle.properties");
            }
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
        if (loggingEnabled) {
            PropertyConfigurator.configure(props);
            logger.info("Sucessfully loaded Spiracle log4j configuration.");
        }
    }

    private void setNamedConnectionPool(ServletContext application, ComboPooledDataSource ds, String connectionName, String connectionData) {
        application.setAttribute(connectionName, ds);
        application.setAttribute(connectionData, ds.toString());
        logger.info("Added connection pool " + ds.getDataSourceName() + "to application context");
    }

    private ComboPooledDataSource getConnectionPool(Properties props, String dbmsName) {
        ComboPooledDataSource ds = new ComboPooledDataSource();
        String jdbcDriver = props.getProperty(MessageFormat.format("c3p0.{0}.classname", dbmsName));
        String url = props.getProperty(MessageFormat.format("c3p0.{0}.url", dbmsName));
        String username = props.getProperty(MessageFormat.format("c3p0.{0}.username", dbmsName));
        String password = props.getProperty(MessageFormat.format("c3p0.{0}.password", dbmsName));
        int maxPoolSize = 0;
        try {
            maxPoolSize = Integer.parseInt(props.getProperty(Constants.C3P0_POOL_SIZE));
        } catch (NumberFormatException e) {
            logger.error("c3p0.maxPoolSize not specified, default value set(25).");
            maxPoolSize = 25;
        }

        try {
            ds.setDriverClass(jdbcDriver);
        } catch (PropertyVetoException e) {
            if (logger.isDebugEnabled()) {
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

    private void setFetchSize(ServletContext application, Properties props) {
        int fetchSize = 0;
        try {
            fetchSize = Integer.parseInt(props.getProperty(Constants.JDBC_FETCH_SIZE));
            application.setAttribute(Constants.JDBC_FETCH_SIZE, fetchSize);
            logger.info("Set jdbc.fetchsize to (" + fetchSize + ")");
        } catch (NumberFormatException e) {
            logger.error("jdbc.fetchsize not specified, default value set(10).");
        }
    }

    private void setDefaultConnection(ServletContext application, Properties props) {
        String defaultConnection = (String) props.get(Constants.DEFAULT_CONNECTION);
        application.setAttribute(Constants.DEFAULT_CONNECTION, defaultConnection);
    }

    void logServerInfo(ServletContext application) {
        logger.info("Application Server Name: " + application.getServerInfo());
        logger.info("Application Context Path:" + application.getRealPath(""));
    }

    void setDefaultErrorCode(ServletContext application, Properties props) {
        application.setAttribute("defaultError", props.getProperty("waratek.error"));
    }
}
