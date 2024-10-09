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
package com.waratek.spiracle.sql.servlet.oracle;

import com.waratek.spiracle.misc.DataSourceUtil;
import com.waratek.spiracle.sql.servlet.util.ParameterNullFix;
import com.waratek.spiracle.sql.util.SelectUtil;
import org.apache.log4j.Logger;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Servlet implementation class Run_Any_Sql
 */
@WebServlet("/Run_Any_Sql")
public class Run_Any_Sql extends HttpServlet
{
    private static final Logger logger = Logger.getLogger(Run_Any_Sql.class);
    private static final long serialVersionUID = 1L;
    private static final String SQL = "sql";
    private static final String ARGS = "args";
    private static final String ARRAY_SPLITTER = "~";
    private static final String ARG_SOURCES = "argSources";

    /**
     * @see HttpServlet#HttpServlet()
     */
    public Run_Any_Sql()
    {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        executeRequest(request, response);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        executeRequest(request, response);
    }

    private String[] setArgDataSource(String[] sqlArgs, String argSources, HttpServletRequest request) throws IOException
    {
        if (argSources.equals(""))
        {
            return sqlArgs; // No change needed
        }
        String[] argSourcesArray = argSources.split(ARRAY_SPLITTER);
        if (sqlArgs.length != argSourcesArray.length)
        {
            throw new RuntimeException("Different number of args and argSources not allowed");
        }
        String[] newArgArray = new String[sqlArgs.length];
        for (int i = 0; i < sqlArgs.length; i++)
        {
            newArgArray[i] = DataSourceUtil.forceStringInputSource(sqlArgs[i], argSourcesArray[i], request);
        }
        return newArgArray;
    }

    private void executeRequest(HttpServletRequest request, HttpServletResponse response) throws IOException
    {
        ServletContext application = this.getServletConfig().getServletContext();
        List<String> queryStringList = new ArrayList<>();
        queryStringList.add(SQL);
        queryStringList.add(ARGS);
        queryStringList.add(ARG_SOURCES);

        Map<String, String> nullSanitizedMap = ParameterNullFix.sanitizeNull(queryStringList, request);

        String unformattedSql = nullSanitizedMap.get(SQL);
        unformattedSql = DataSourceUtil.makeStringUntainted(unformattedSql);

        final String sqlArgs = nullSanitizedMap.get(ARGS);
        final String argSources = nullSanitizedMap.get(ARG_SOURCES);
        String[] sqlArgsArray = sqlArgs.split(ARRAY_SPLITTER);
        sqlArgsArray = setArgDataSource(sqlArgsArray, argSources, request);
        final String sql = String.format(unformattedSql, (Object[]) sqlArgsArray);

        SelectUtil.executeQuery(sql, application, request, response);
    }
}
