<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Address"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Session"%>
<%@page import="javax.mail.Authenticator"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="user.UserDAO"%>
<%@page import="util.SHA256"%>
<%@page import="util.Gmail"%>
<%
	UserDAO userDAO= new UserDAO();
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
		String reportTitle=null;
		String reportContent=null;
		if(request.getParameter("reportTitle")!=null){
			reportTitle=request.getParameter("reportTitle");
		}
		if(request.getParameter("reportContent")!=null){
			reportContent=request.getParameter("reportContent");
		}
		if(reportTitle==null||reportTitle.trim().equals("")||reportContent==null||reportContent.trim().equals("")){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('入力されてない項目があります');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
			
		}
		//사용자에게 보낼 메세지 기입
		String host="http://localhost:8080/Lecture_Evaluation/";
		String from="pledudrb@gmail.com";
		String to="pledudrb@gmail.com";
		String subject="Report Email";
		String content = "신고자:" +userID+
						"<br>제목:" + reportTitle +
						"<br>내용:" + reportContent;
		
		 Properties props = new Properties();
		 props.put("mail.smtp.host", "smtp.gmail.com");
		 props.put("mail.smtp.socketFactory.port", "587");
		 props.put("mail.smtp.socketFactory.class", "javax.net.SocketFactory");
		 props.put("mail.smtp.auth", "true");
		 props.put("mail.smtp.port", "587");
		 props.put("mail.smtp.ssl.enable", "false");
		 props.put("mail.smtp.starttls.enable", "true");
		 props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
		 
/* 		Properties p = new Properties();
		p.put("mail.smtp.user", from);
		p.put("mail.smtp.host", "smtp.googlemail.com");
		p.put("mail.smtp.port", "465");
		p.put("mail.smtp.starttls.enable", "true");
		p.put("mail.smtp.auth", "true");
		p.put("mail.smtp.debug", "true");
		p.put("mail.smtp.socketFactory.port", "465");
		p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		p.put("mail.smtp.socketFactory.fallback", "false"); */

		try{
		    Authenticator auth = new Gmail();
		    Session ses = Session.getInstance(props, auth);
		    ses.setDebug(true);
		    MimeMessage msg = new MimeMessage(ses); 
		    msg.setSubject(subject);
		    Address fromAddr = new InternetAddress(from);
		    msg.setFrom(fromAddr);
		    Address toAddr = new InternetAddress(to);
		    msg.addRecipient(Message.RecipientType.TO, toAddr);
		    msg.setContent(content, "text/html;charset=UTF-8");
		    Transport.send(msg);
					
		}	catch(Exception e){
			e.printStackTrace();
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('エラー発生');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
		}
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('受付完了しました');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
	
		return;
%>