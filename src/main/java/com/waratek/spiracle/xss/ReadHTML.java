package com.waratek.spiracle.xss;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletOutputStream;
import javax.servlet.ServletRequest;

public class ReadHTML {

    static void readHTML(Object out, String taintedInput, ServletRequest req)
            throws IOException {
        String line = "";
        String XSS = "XSS";
        String htmlFile = req.getRealPath("/") + "xss.html";

        BufferedReader in = new BufferedReader(new FileReader(htmlFile));
        while ((line = in.readLine()) != null) {
            if (line.indexOf(XSS) != -1) {
                System.out.println("Transforming:");
                System.out.println(line);
                line = line.replace(XSS, taintedInput);
                System.out.println(line);
            }

            if (out instanceof ServletOutputStream) {
                ((ServletOutputStream) out).println(line);
            } else if (out instanceof PrintWriter) {
                ((PrintWriter) out).println(line);
            }
        }
        in.close();
    }
}
