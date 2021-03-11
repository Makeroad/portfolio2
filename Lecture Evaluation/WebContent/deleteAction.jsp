<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@	page import="user.UserDAO"%>
<%@	page import="evaluation.EvaluationDAO"%>
<%@	page import="likey.LikeyDTO"%>
<%@	page import="java.io.PrintWriter" %>
<%

	String userID=null;
	if(session.getAttribute("userID")!=null){
		userID=(String)session.getAttribute("userID");
	}
	if(userID==null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('ログインしてください')");
		script.println("location.href='userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
		request.setCharacterEncoding("UTF-8");
		String evaluationID=null;
		if(request.getParameter("evaluationID")!=null){
			evaluationID=request.getParameter("evaluationID");
		}
		EvaluationDAO evaluationDAO= new EvaluationDAO();
		if(userID.equals(evaluationDAO.getUserID(evaluationID))){
			int result = new EvaluationDAO().delete(evaluationID);
		if(result==0) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('削除されました');");
				script.println("location.href='index.jsp'");
				script.println("</script>");
				script.close();
				return;			
		}else{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('データベースエラー発生');");
				script.println("history.back();");
				script.println("</script>");
				script.close();
				return;
			}
			}else{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('権限がないです');");
				script.println("history.back();");
				script.println("</script>");
				script.close();
				return;
		}
%>