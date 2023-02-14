package com.waratek.spiracle.xss;

import com.waratek.spiracle.file.FileResourceStreamServlet;
import okhttp3.Call;
import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import org.apache.log4j.Logger;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/XSSWebAppHSRPW")
public class XSSWebAppHSRPW extends HttpServlet {
    private static final Logger logger = Logger.getLogger(FileResourceStreamServlet.class);

    public void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        logger.info("DEBUG: Making HTTP GET request at start of XSSWebAppHSRPW request handling");
        okHttpGet("http://www.google.com/");
        logger.info("DEBUG: Making HTTPS GET request at start of XSSWebAppHSRPW request handling");
        okHttpGet("https://www.google.com/");
        logger.info("DEBUG: Making HTTP POST request at start of XSSWebAppHSRPW request handling");
        okHttpPost("http://www.google.com/");
        logger.info("DEBUG: Making HTTPS POST request at start of XSSWebAppHSRPW request handling");
        okHttpPost("https://www.google.com/");
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();
        ReadHTML.readHTML(out, req.getParameter("taintedtext"), req);
    }

    private void okHttpGet(String url) throws IOException
    {
        logger.info("DEBUG: GET URL: " + url);
        OkHttpClient client = new OkHttpClient.Builder().build();
        Request okhttpRequest = new Request.Builder()
                .url(url)
                .build();

        Call call = client.newCall(okhttpRequest);
        Response okHttpResponse = call.execute();
        logger.info("DEBUG: Response code: " + okHttpResponse.code());
    }

    private void okHttpPost(String url) throws IOException
    {
        logger.info("DEBUG: POST URL: " + url);
        OkHttpClient client = new OkHttpClient.Builder().build();
        RequestBody formBody = new FormBody.Builder()
                .add("username", "test")
                .add("password", "test")
                .build();

        Request okhttpRequest = new Request.Builder()
                .url(url)
                .post(formBody)
                .build();

        Call call = client.newCall(okhttpRequest);
        Response okHttpResponse = call.execute();
        logger.info("DEBUG: Response code: " + okHttpResponse.code());
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
