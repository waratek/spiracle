package com.waratek.spiracle.filepaths;

import com.waratek.spiracle.sql.util.SelectUtil;
import com.waratek.spiracle.sql.util.UpdateUtil;
import org.apache.log4j.Logger;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.beans.ExceptionListener;
import java.beans.XMLDecoder;
import java.beans.XMLEncoder;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.sql.SQLException;
import java.util.ArrayList;

public class FilePathUtil
{
    private FilePathUtil() {}
    protected static final Logger logger = Logger.getLogger(FilePathUtil.class);
    private static final String JAVA_SERIALIZED_FILE = "javaObjectSerialized";
    private static final String XML_SERIALIZED_FILE = "filePath.xml";

    /**
     * Serialize filepath to file and then deserialize it back out
     * If nothing interrupts the process, the input will be the same as the output
     */
    public static String javaSerializeAndDeserializePath(String path) throws IOException
    {
        FilePath filePath = new FilePath(path);
        serializeFilePathToJava(filePath);
        return deserializeFilePathFromJava().getPath();
    }

    private static void serializeFilePathToJava (FilePath filePath) throws IOException {
        logger.info("Serializing(java): " + filePath);
        FileOutputStream fos = new FileOutputStream(JAVA_SERIALIZED_FILE);
        ObjectOutputStream oos = new ObjectOutputStream(fos);
        oos.writeObject(filePath);
        oos.close();
        fos.close();
    }

    private static FilePath deserializeFilePathFromJava() throws IOException {
        FileInputStream fis = new FileInputStream(JAVA_SERIALIZED_FILE);
        ObjectInputStream ois = new ObjectInputStream(fis);
        FilePath deserializedFilePath;
        try
        {
            deserializedFilePath = (FilePath) ois.readObject();
        }
        catch (ClassNotFoundException e)
        {
            throw new RuntimeException(e);
        }
        ois.close();
        fis.close();

        logger.info("Deserialized(java): " + deserializedFilePath);
        return deserializedFilePath;
    }

    /**
     * Write path to an XML file, and then deserialize the same path from that file.
     * If nothing interrupts the process, the input will be the same as the output
     */
    public static String xmlSerializeAndDeserializePath(String path) throws IOException {
        FilePath filePath = new FilePath(path);
        serializeFilePathToXml(filePath);
        return deserializeFilePathFromXml().getPath();
    }

    private static void serializeFilePathToXml (FilePath filePath) throws IOException {
        logger.info("Serializing(xml): " + filePath);
        FileOutputStream fos = new FileOutputStream(XML_SERIALIZED_FILE);
        XMLEncoder encoder = new XMLEncoder(fos);
        encoder.setExceptionListener(new ExceptionListener() {
            public void exceptionThrown(Exception e) {
                logger.error("Exception! :"+e.toString());
            }
        });
        encoder.writeObject(filePath);
        encoder.close();
        fos.close();
    }

    private static FilePath deserializeFilePathFromXml() throws IOException {
        FileInputStream fis = new FileInputStream(XML_SERIALIZED_FILE);
        XMLDecoder decoder = new XMLDecoder(fis);
        FilePath deserializedFilePath = (FilePath) decoder.readObject();
        decoder.close();
        fis.close();
        logger.info("Deserialized(xml): " + deserializedFilePath);
        return deserializedFilePath;
    }

    public static void putFilePathInDatabase(String filePath, HttpServletRequest request)
    {
        logger.info("Filepath to put into database: " + filePath);
        final ServletContext application = request.getServletContext();
        final String sqlCreateTable = "CREATE TABLE FilePath (path varchar(255))";
        final String sqlInsertPath = getSqlInsertPathCommand(filePath);

        logger.info("Dropping FilePath table if it exists already");
        dropFilePathTableIfExists(application, request);

        try {
            logger.info("Creating FilePath table");
            UpdateUtil.executeUpdateWithoutNewPage(sqlCreateTable, application, request);
            logger.info("Adding '" + filePath + "' to FilePath table");
            UpdateUtil.executeUpdateWithoutNewPage(sqlInsertPath, application, request);
        }
        catch (SQLException e)
        {
            logger.error(e.getMessage());
            throw new RuntimeException(e);
        }
    }

    public static String retrieveFilePathFromDatabase(HttpServletRequest request) throws IOException
    {
        final ServletContext application = request.getServletContext();
        final String sqlSelect = "SELECT * FROM FilePath";
        ArrayList<ArrayList<Object>> resultList;
        try
        {
            resultList = SelectUtil.executeQueryWithoutNewPage(sqlSelect, application, request);
        }
        catch (SQLException e)
        {
            logger.error(e.getMessage());
            throw new RuntimeException(e);
        }

        final String filePath = resultList.get(0).get(0).toString();
        logger.info("Filepath retrieved from database: " + filePath);
        return filePath;
    }

    /**
     * Takes a path string (which is assumed to come from http by default), and if the requested source is not http, stores it in a database
     *  or serialized format, and then retrieves and returns the same value from that format.
     */
    public static String forcePathSource(String path, String pathSource, HttpServletRequest request) throws IOException
    {
        String taintedPath;
        if (pathSource.equals("http")) {
            taintedPath = path;
        } else if (pathSource.equals("deserialJava")) {
            taintedPath = javaSerializeAndDeserializePath(path);
        } else if (pathSource.equals("deserialXml")) {
            taintedPath = xmlSerializeAndDeserializePath(path);
        } else if (pathSource.equals("database")) {
            putFilePathInDatabase(path, request);
            taintedPath = retrieveFilePathFromDatabase(request);
        } else {
            throw new RuntimeException("Unknown source type: " + pathSource);
        }
        return taintedPath;
    }

    private static String getSqlInsertPathCommand(String filePath)
    {
        final String escapedPath = filePath.replace("\\", "\\\\"); // Double backslashes required for windows paths
        return "INSERT INTO FilePath VALUES('" + escapedPath + "')";
    }

    private static void dropFilePathTableIfExists(ServletContext application, HttpServletRequest request)
    {
        final String sqlDropTable = "DROP TABLE FilePath";
        try {
            UpdateUtil.executeUpdateWithoutNewPage(sqlDropTable, application, request);
        }
        catch (SQLException e)
        {
            logger.info("'" + sqlDropTable + "' failed, probably the table doesn't exist. Error msg = " + e.getMessage());
        }
    }
}
