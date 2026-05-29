package com.waratek.spiracle.filepaths;

import com.waratek.spiracle.misc.DataSourceUtil;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

public class FilePathUtil
{
    private FilePathUtil() {}
    protected static final Logger logger = Logger.getLogger(FilePathUtil.class);

    /**
     * Serialize filepath to file and then deserialize it back out
     * If nothing interrupts the process, the input will be the same as the output
     */
    public static String javaSerializeAndDeserializePath(String path) throws IOException
    {
        FilePath filePath = new FilePath(path);
        FilePath deserialFilePath = (FilePath) DataSourceUtil.javaSerializeAndDeserializeObject(filePath);
        return deserialFilePath.getPath();
    }

    /**
     * Write path to an XML file, and then deserialize the same path from that file.
     * If nothing interrupts the process, the input will be the same as the output
     */
    public static String xmlSerializeAndDeserializePath(String path) throws IOException {
        FilePath filePath = new FilePath(path);
        FilePath deserialFilePath = (FilePath) DataSourceUtil.xmlSerializeAndDeserializeObject(filePath);
        return deserialFilePath.getPath();
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
            DataSourceUtil.putStringInDatabase(path, request);
            taintedPath = DataSourceUtil.retrieveStringFromDatabase(request);
        } else {
            throw new RuntimeException("Unknown source type: " + pathSource);
        }
        return taintedPath;
    }
}
