package com.waratek.spiracle.sql.c3p0;

import java.beans.PropertyVetoException;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import com.mchange.v2.c3p0.ComboPooledDataSource;

@WebListener
public class C3p0Init implements ServletContextListener{
    Properties props = new Properties();

    @Override
    public void contextDestroyed(ServletContextEvent arg) {
        // TODO Auto-generated method stub
        
    }

    @Override
    public void contextInitialized(ServletContextEvent arg) {
        ComboPooledDataSource ds = null;
        ServletContext application = arg.getServletContext();
        loadProperties(arg);
        try {
            ds = getConnectionPool(arg);
        } catch (PropertyVetoException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        application.setAttribute("connectionPool", ds);     
        application.setAttribute("connectionData", ds.toString());
    }
    
    private void loadProperties(ServletContextEvent arg) {
        ServletContext application = arg.getServletContext();
        InputStream propStream = application.getResourceAsStream("conf/Spiracle.properties");       
        try {
            props.load(propStream);
        } catch (FileNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
    
    private ComboPooledDataSource getConnectionPool(ServletContextEvent arg) throws PropertyVetoException {
        ComboPooledDataSource ds = new ComboPooledDataSource();
        String jdbcDriver = props.getProperty("c3p0.classname");
        String url = props.getProperty("c3p0.url");
        String username = props.getProperty("c3p0.username");
        String password = props.getProperty("c3p0.password");
        int maxPoolSize = 0;
        try {
            maxPoolSize = Integer.parseInt(props.getProperty("c3p0.maxPoolSize"));
        } catch (NumberFormatException e) {
            maxPoolSize = 25;
        }
        
        ds.setDriverClass(jdbcDriver);
        ds.setJdbcUrl(url);
        ds.setUser(username);
        ds.setPassword(password);
        ds.setMinPoolSize(5);
        ds.setAcquireIncrement(5);
        ds.setMaxPoolSize(maxPoolSize);
        return ds;
    }   
}
