<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
	String userID=null;
	if(session.getAttribute("userID")!=null){
	userID=(String)session.getAttribute("userID");
	}
	if(userID!=null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('既にログインしました');");
		script.println("location.href='index.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	String userPassword = null;
	String userEmail = null;
	if(request.getParameter("userID") != null) {
		userID = (String) request.getParameter("userID");
	}
	if(request.getParameter("userPassword") != null) {
		userPassword = (String) request.getParameter("userPassword");
	}
	if(request.getParameter("userEmail") != null) {
		userEmail = (String) request.getParameter("userEmail");
	}
	
    if(userID==null||userID.trim().equals("")||userPassword==null||userPassword.trim().equals("")||userEmail==null||userEmail.trim().equals("")){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('入力されてない項目があります')");
			script.println("history.back()");
			script.println("</script>");
		
	} 
    else {
		UserDAO userDAO = new UserDAO();
		int result = userDAO.join(new UserDTO(userID, userPassword, userEmail, SHA256.getSHA256(userEmail), false));
		if (result == -1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('既に存在するIDです');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
		} else {
			session.setAttribute("userID", userID);
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'emailSendAction.jsp';");
			script.println("</script>");
			script.close();
		}
	}
%>