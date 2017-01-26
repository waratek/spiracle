<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

  <jsp:include page="header.jsp" >
    <jsp:param name="pageName" value="Path Traversal" />
  </jsp:include>

    <div class="container">
        <h1>Path Traversal</h1>

        <div class="panel panel-default">
        <%
            String outputFile = (String) session.getAttribute("outputFile");
            if (outputFile == null) {
                outputFile = "";
            }
        %>
            <div class="panel-heading">File</div>
            <div class="panel-body">
                <form id="FormFile01" action="FileServlet01" method="post">
                    <div>
                        <label>Operation01:</label>
                        <input type="text" id="File01" name="File01" value="FileName"</input>
                        <input type="submit" value="Get File" />
                    </div>
                </form>

                <form id="FormFile02" action="FileServlet02" method="post" >
                    <div>
                        <label>Operation02:</label>
                        <input type="text" id="File02" name="File02" value="FileName"</input>
                        <input type="submit" value="Get File" />
                    </div>
                </form>

                <form id="FormFile03 "action="FileServlet03" method="post">
                    <div>
                        <label>Operation03:</label>
                        <input type="text" id="File03" name="File03" value="FileName"</input>
                        <input type="submit" value="Get File" />
                    </div>
                </form>
            </div>
            <div class="panel-footer">
                <%=outputFile%>
            </div>
        </div>


        <div class="panel panel-default">
        <%
            String outputFileInputStream = (String) session.getAttribute("outputFileInputStream");
            if (outputFileInputStream == null) {
                outputFileInputStream = "";
            }
        %>
            <div class="panel-heading">FileInputStream</div>
            <div class="panel-body">
                <form id="FormFileInputStream01" action="FileInputStreamServlet01" method="post">
                    <div>
                        <label>Operation01:</label>
                        <input type="text" id="FileInputStream01" name="FileInputStream01" value="FileName"</input>
                        <input type="submit" value="Get File" />
                    </div>
                </form>

                <form id="FormFileInputStream02" action="FileInputStreamServlet02" method="post" >
                    <div>
                        <label>Operation02:</label>
                        <input type="text" id="FileInputStream02" name="FileInputStream02" value="FileName"</input>
                        <input type="submit" value="Get File" />
                    </div>
                </form>

                <form id="FormFileInputStream03 "action="FileInputStreamServlet03" method="post">
                    <div>
                        <label>Operation03:</label>
                        <input type="text" id="FileInputStream03" name="FileInputStream03" value="FileName"</input>
                        <input type="submit" value="Get File" />
                    </div>
                </form>
            </div>
            <div class="panel-footer">
                <%=outputFileInputStream%>
            </div>
        </div>


        <div class="panel panel-default">
        <%
            String outputFileOutputStream = (String) session.getAttribute("outputFileOutputStream");
            if (outputFileOutputStream == null) {
                outputFileOutputStream = "";
            }
        %>
            <div class="panel-heading">FileOutputStream</div>
            <div class="panel-body">
                <form id="FormFileOutputStream01" action="FileOutputStreamServlet01" method="post">
                    <div>
                        <label>Operation01:</label>
                        <input type="text" id="FileOutputStream01" name="FileOutputStream01" value="FileName"</input>
                        <input type="submit" value="Get File" />
                    </div>
                </form>

                <form id="FormFileOutputStream02" action="FileOutputStreamServlet02" method="post" >
                    <div>
                        <label>Operation02:</label>
                        <input type="text" id="FileOutputStream02" name="FileOutputStream02" value="FileName"</input>
                        <input type="submit" value="Get File" />
                    </div>
                </form>

                <form id="FormFileOutputStream03 "action="FileOutputStreamServlet03" method="post">
                    <div>
                        <label>Operation03:</label>
                        <input type="text" id="FileOutputStream03" name="FileOutputStream03" value="FileName"</input>
                        <input type="submit" value="Get File" />
                    </div>
                </form>
            </div>
            <div class="panel-footer">
                <%=outputFileOutputStream%>
            </div>
        </div>


        <div class="panel panel-default">
        <%
            String outputRandomAccessFile = (String) session.getAttribute("outputRandomAccessFile");
            if (outputRandomAccessFile == null) {
                outputRandomAccessFile = "";
            }
        %>
            <div class="panel-heading">RandomAccessFile</div>
            <div class="panel-body">
                <form id="FormRandomAccessFile01" action="RandomAccessFileServlet01" method="post">
                    <div>
                        <label>Operation01:</label>
                        <input type="text" id="RandomAccessFile01" name="RandomAccessFile01" value="FileName"</input>
                        <input type="submit" value="Get File" />
                    </div>
                </form>

                <form id="FormRandomAccessFile02" action="RandomAccessFileServlet02" method="post" >
                    <div>
                        <label>Operation02:</label>
                        <input type="text" id="RandomAccessFile02" name="RandomAccessFile02" value="FileName"</input>
                        <input type="submit" value="Get File" />
                    </div>
                </form>

                <form id="FormRandomAccessFile03 "action="RandomAccessFileServlet03" method="post">
                    <div>
                        <label>Operation03:</label>
                        <input type="text" id="RandomAccessFile03" name="RandomAccessFile03" value="FileName"</input>
                        <input type="submit" value="Get File" />
                    </div>
                </form>
            </div>
            <div class="panel-footer">
                <%=outputRandomAccessFile%>
            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
