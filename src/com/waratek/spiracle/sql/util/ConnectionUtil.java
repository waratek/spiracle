package com.waratek.spiracle.sql.util;

import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.ServletContext;

import org.apache.log4j.Logger;
import org.springframework.context.support.FileSystemXmlApplicationContext;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import com.mchange.v2.c3p0.ComboPooledDataSource;
import com.waratek.spiracle.sql.servlet.util.ParameterNullFix;

public class ConnectionUtil {
	private static final Logger logger = Logger.getLogger(ParameterNullFix.class);

    public static Connection getConnection(ServletContext application, String connectionType) throws SQLException {
        Connection con = null;      
        logger.info("Connection Type: " + connectionType);
        if(connectionType.equals("c3p0")) {
            ComboPooledDataSource ds = (ComboPooledDataSource)application.getAttribute("connectionPool");
            con = ds.getConnection();
        } else if(connectionType.equals("java")) {
            con = (Connection)application.getAttribute("connection");
        } else if(connectionType.equals("spring")) {
            FileSystemXmlApplicationContext context = (FileSystemXmlApplicationContext)application.getAttribute("springContext");
            DriverManagerDataSource dmds = (DriverManagerDataSource)context.getBean("dataSource");
            con = dmds.getConnection();
        }
        
        logger.info("Returning connection: " + con.toString());
        return con;
    }
}
