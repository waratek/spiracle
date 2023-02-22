package com.waratek.spiracle.filepaths;

import java.io.Serializable;

public class FilePath implements Serializable
{
    private String path;

    /**
     * Needed for Java/XML deserialization.
     */
    public FilePath() {}

    public FilePath(String path) {
        this.path = path;
    }
    
    public String getPath() {
        return path;
    }
    public void setPath(String path) {
        this.path = path;
    }
    
    @Override
    public String toString() {
        return "File [path=" + path + "]";
    }
}
