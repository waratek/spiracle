package com.waratek.spiracle.misc;

import com.waratek.spiracle.sql.util.SelectUtil;
import com.waratek.spiracle.sql.util.UpdateUtil;
import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.beans.ExceptionListener;
import java.beans.XMLDecoder;
import java.beans.XMLEncoder;
import java.io.*;
import java.sql.SQLException;
import java.util.ArrayList;

public class DataSourceUtil
{
    private DataSourceUtil()
    {
    }

    protected static final Logger logger = Logger.getLogger(DataSourceUtil.class);
    private static final File TEMP_WRITE_FILE = new File("spiracleTmpWriteFile");
    private static final String JAVA_SERIALIZED_FILE = "javaObjectSerialized";
    private static final String XML_SERIALIZED_FILE = "xmlObjectSerialized.xml";

    public static String makeStringUntainted(String taintedString) throws IOException
    {
        FileWriter fileWriter = new FileWriter(TEMP_WRITE_FILE);
        fileWriter.write(taintedString);
        fileWriter.close();
        return FileUtils.readFileToString(TEMP_WRITE_FILE);
    }

    /**
     * Takes a string (which is assumed to come from http by default), and if the requested source is not http, stores it in a database
     *  or serialized format, and then retrieves and returns the same value from that format.
     */
    public static String forceStringInputSource(String input, String source, HttpServletRequest request) throws IOException
    {
        String taintedString;
        if (source.equals("http")) {
            taintedString = input;
        } else if (source.equals("deserialJava")) {
            taintedString = (String) javaSerializeAndDeserializeObject(input);
        } else if (source.equals("deserialXml")) {
            taintedString = (String) xmlSerializeAndDeserializeObject(input);
        } else if (source.equals("database")) {
            putStringInDatabase(input, request);
            taintedString = retrieveStringFromDatabase(request);
        } else {
            throw new RuntimeException("Unknown source type: " + source);
        }
        return taintedString;
    }

    public static void putStringInDatabase(String input, HttpServletRequest request)
    {
        logger.info("String to put into database: " + input);
        final ServletContext application = request.getServletContext();
        logger.info("Dropping Tmp table if it exists already");
        dropTmpTableIfExists(application, request);

        final String sqlCreateTable = getSqlCreateTmpCommand(input);
        final String sqlInsert = getSqlInsertStringCommand(input);

        try {
            logger.info("Creating Tmp table");
            UpdateUtil.executeUpdateWithoutNewPage(sqlCreateTable, application, request);
            logger.info("Adding '" + input + "' to Tmp table");
            UpdateUtil.executeUpdateWithoutNewPage(sqlInsert, application, request);
        }
        catch (SQLException e)
        {
            logger.error(e.getMessage());
            throw new RuntimeException(e);
        }
    }

    public static String retrieveStringFromDatabase(HttpServletRequest request) throws IOException
    {
        final ServletContext application = request.getServletContext();
        final String sqlSelect = "SELECT * FROM Tmp";
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

        final String retrievedString = resultList.get(0).get(0).toString();
        logger.info("String retrieved from database: " + retrievedString);

        return retrievedString;
    }

    private static String getSqlInsertStringCommand(String input)
    {
        if (input.contains("\\"))
        {
            throw new RuntimeException("");
        }
        final String escapedString = input.replace("\\", "\\\\") // Escape backslash, so it's inserted literally, not as an escape character
                .replace("'", "\\'"); // Escape quote characters so they are inserted literally
        return "INSERT INTO Tmp VALUES('" + escapedString + "')";
    }

    private static String getSqlCreateTmpCommand(String input)
    {
        return "CREATE TABLE Tmp (inputString varchar(" + input.length() + "))";
    }

    private static void dropTmpTableIfExists(ServletContext application, HttpServletRequest request)
    {
        final String sqlDropTable = "DROP TABLE Tmp";
        try {
            UpdateUtil.executeUpdateWithoutNewPage(sqlDropTable, application, request);
        }
        catch (SQLException e)
        {
            logger.info("'" + sqlDropTable + "' failed, probably the table doesn't exist. Error msg = " + e.getMessage());
        }
    }

    /**
     * Serialize object to file and then deserialize it back out
     * If nothing interrupts the process, the input will be the same as the output
     */
    public static Object javaSerializeAndDeserializeObject(Object objectToSerialize) throws IOException
    {
        serializeToJava(objectToSerialize);
        return deserializeFromJava();
    }

    private static void serializeToJava(Object objectToSerialize) throws IOException {
        logger.info("Serializing(java): " + objectToSerialize);
        FileOutputStream fos = new FileOutputStream(JAVA_SERIALIZED_FILE);
        ObjectOutputStream oos = new ObjectOutputStream(fos);
        oos.writeObject(objectToSerialize);
        oos.close();
        fos.close();
    }

    private static Object deserializeFromJava() throws IOException {
        FileInputStream fis = new FileInputStream(JAVA_SERIALIZED_FILE);
        ObjectInputStream ois = new ObjectInputStream(fis);
        Object deserializedObject;
        try
        {
            deserializedObject = ois.readObject();
        }
        catch (ClassNotFoundException e)
        {
            throw new RuntimeException(e);
        }
        ois.close();
        fis.close();

        logger.info("Deserialized(java): " + deserializedObject);
        return deserializedObject;
    }

    /**
     * Serialize object to XML file and then deserialize it back out
     * If nothing interrupts the process, the input will be the same as the output
     */
    public static Object xmlSerializeAndDeserializeObject(Object objectToSerialize) throws IOException {
        serializeToXml(objectToSerialize);
        return deserializeFromXml();
    }

    private static void serializeToXml(Object objectToSerialize) throws IOException {
        logger.info("Serializing(xml): " + objectToSerialize);
        FileOutputStream fos = new FileOutputStream(XML_SERIALIZED_FILE);
        XMLEncoder encoder = new XMLEncoder(fos);
        encoder.setExceptionListener(new ExceptionListener() {
            public void exceptionThrown(Exception e) {
                logger.error("Exception! :"+e.toString());
            }
        });
        encoder.writeObject(objectToSerialize);
        encoder.close();
        fos.close();
    }

    private static Object deserializeFromXml() throws IOException {
        FileInputStream fis = new FileInputStream(XML_SERIALIZED_FILE);
        XMLDecoder decoder = new XMLDecoder(fis);
        Object deserializedObject = decoder.readObject();
        decoder.close();
        fis.close();
        logger.info("Deserialized(xml): " + deserializedObject);
        return deserializedObject;
    }
}
