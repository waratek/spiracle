package com.waratek.spiracle.sql.servlet.mssql;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.waratek.spiracle.sql.servlet.util.ParameterNullFix;
import com.waratek.spiracle.sql.util.SelectUtil;

/**
 * Servlet implementation class Implicit_Join_Namespace
 */
@WebServlet("/MsSql_Implicit_Join_Namespace")
public class MsSql_Implicit_Join_Namespace extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public MsSql_Implicit_Join_Namespace() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeRequest(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeRequest(request, response);
	}

    private void executeRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        ServletContext application = this.getServletConfig().getServletContext();
        List<String> queryStringList = new ArrayList<String>();
        queryStringList.add("id");

        Map<String, String> nullSanitizedMap = ParameterNullFix.sanitizeNull(queryStringList, request);

        String id = nullSanitizedMap.get("id");

        String sql = "SELECT * FROM dbo.users, dbo.address WHERE dbo.users.id = " + id + " AND dbo.users.id = dbo.address.id";

        Boolean showErrors = true;
        Boolean allResults = true;
        Boolean showOutput = true;

        SelectUtil.executeQuery(sql, application, request, response, showErrors, allResults, showOutput);
    }
}
