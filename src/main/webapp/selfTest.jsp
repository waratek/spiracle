<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

  <jsp:include page="header.jsp" >
    <jsp:param name="pageName" value="Misc" />
  </jsp:include>

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

  <script language="javascript">
        $(document).ready(function(){
        $.ajax({ url: "FileServlet",
                type: 'POST',
                data: { filePath: '/etc/passwd', fileArg: 'read'  },
                context: document.body,
                success: function(){
                   $('#fileReadCheck').html("<b>Done</b>");
                }});
        });

        $(document).ready(function(){
        $.ajax({ url: "FileServlet",
                type: 'POST',
                data: { filePath: '/tmp/dummy', fileArg: 'write', fileText: ''  },
                context: document.body,
                success: function(){
                   $('#fileWriteCheck').html("<b>Done</b>");
                }});
        });

        $(document).ready(function(){
        $.ajax({ url: "FileExecServlet",
                type: 'POST',
                data: { cmd: 'ping'  },
                context: document.body,
                success: function(){
                   $('#processForkingCheck').html("<b>Done</b>");
                }});
        });

        $(document).ready(function(){
        $.ajax({ url: "SocketServlet",
                type: 'POST',
                data: { bindHost: '', bindPort: '', remoteHost: 'localhost', remotePort: '<% out.print(request.getLocalPort()); %>'  },
                context: document.body,
                success: function(){
                   $('#networkAcceptCheck').html("<b>Done</b>");
                }});
        });

        $(document).ready(function(){
        $.ajax({ url: "xssContextMatrix.jsp",
                type: 'POST',
                data: { testcase: '1', payload: '<script>alert(1);<\/script>', singlePrint: 'on'  },
                context: document.body,
                success: function(){
                   $('#xssCheck').html("<b>Done</b>");
                }});
        });

        $(document).ready(function(){
        $.ajax({ url: 'FileServlet03',
                type: 'POST',
                data: { File03: '/etc/hosts'  },
                context: document.body,
                success: function(){
                   $('#pathTraversalAbsoluteCheck').html("<b>Done</b>");
                }});
        });

        $(document).ready(function(){
        $.ajax({ url: 'FileServlet01',
                type: 'POST',
                data: { File01: '../../'  },
                context: document.body,
                success: function(){
                   $('#pathTraversalRelativeCheck').html("<b>Done</b>");
                }});
        });


  </script>

  <style type="text/css">
      #block_container {
        display: flex;
    }
  </style>

    <div class="container">
        <h1>Diagnostic Self-tests</h1>
        <p>&nbsp;</p>

        <div id="block_container"><p>File Read Test (/etc/passwd): &nbsp;<div id="fileReadCheck" style="display:inline;"></div></p></div>
        <div id="block_container"><p>File Write Test (/tmp/dummy): &nbsp;<div id="fileWriteCheck" style="display:inline;"></div></p></div>
        <div id="block_container"><p>Process Forking (ping): &nbsp;<div id="processForkingCheck" style="display:inline;"></div></p></div>
        <div id="block_container"><p>Path Traversal Relative Test (../../): &nbsp;<div id="pathTraversalRelativeCheck" style="display:inline;"></div></p></div>
        <div id="block_container"><p>Path Traversal Absolute Test (/etc/hosts): &nbsp;<div id="pathTraversalAbsoluteCheck" style="display:inline;"></div></p></div>
        <div id="block_container"><p>Network Accept Test (localhost:<% out.print(request.getLocalPort()); %>): &nbsp;<div id="networkAcceptCheck" style="display:inline;"></div></p></div>
        <div id="block_container"><p>XSS Test: &nbsp;<div id="xssCheck" style="display:inline;"></div></p></div>
    
        <p>&nbsp;</p>
        <div class="panel panel-default">
            <div class="panel-body">
                Please check the logs and events of your RASP/IAST/WAF solution to confirm the attacks were detected or protected.
            </div>
        </div>

        </div>

    <%@ include file="footer.jsp" %>