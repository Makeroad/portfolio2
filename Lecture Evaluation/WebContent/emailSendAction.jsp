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
		script.println("alert('ログインしてください。')");
		script.println("location.href='userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}

		boolean emailChecked = userDAO.getUserEmailChecked(userID);
		if(emailChecked==true){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert(既に認証された会員です。);");
			script.println("location.href='index.jsp'");
			script.println("</script>");
			script.close();		
		}
		
		//사용자에게 보낼 메세지 기입
		String host="http://localhost:8080/Lecture_Evaluation/";
		String from="pledudrb@gmail.com";
		String to=userDAO.getUserEmail(userID);
		String subject="Email Check";
		String content = "次の URLをクリックしてください" +
		"<a href='" + host + "emailCheckAction.jsp?code=" + new SHA256().getSHA256(to) + "'>Email認証</a>";
		
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
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('エラーが発生しました');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			e.printStackTrace();
			return;
		}
%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>講義評価ウェブサイト</title>
</head>
<body>
   <nav class="navbar navbar-expand-lg navbar-light bg-light">
      <a class="navbar-brand" href="index.jsp">講義評価ウェブサイト</a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbar">
        <ul class="navbar-nav mr-auto">
          <li class="nav-item active">
            <a class="nav-link" href="index.jsp">メイン</a>
          </li>
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">
              会員管理
            </a>
            <div class="dropdown-menu" aria-labelledby="dropdown">
<%
	if(userID==null){
%>            
              <a class="dropdown-item" href="userLogin.jsp">ログイン</a>
              <a class="dropdown-item" href="userJoin.jsp">会員登録</a>
<%
	}else{
%>              
             <a class="dropdown-item" href="userLogout.jsp">ログアウト</a>
<%
	}
%>           
            </div>
          </li>
        </ul>
        <form action="./index.jsp" method="get" class="form-inline my-2 my-lg-0">
          <input type="text" name="search" class="form-control mr-sm-2" placeholder="내용을 입력하세요.">
          <button class="btn btn-outline-success my-2 my-sm-0" type="submit">検索</button>
        </form>
      </div>
    </nav>
    <section class="container mt-3" style="max-width:560px;">
		<div class="alert alert-success mt-4" role="alert">
			メールアドレス認証メールが送信されました。 入力したメールアドレスにアクセスして認証してください。
		</div>
    </section>
    

    <footer class="bg-dark mt-4 p-5 text-center" style="color: #FFFFFF;">
      Copyright YG PARK ⓒAll Rights Reserved.
    </footer>
    <!-- 제이쿼리 자바스크립트 추가하기 -->
    <script src="./js/jquery.min.js"></script>
    <!-- 파퍼 자바스크립트 추가하기 -->
    <script src="./js/popper.min.js"></script>
    <!-- 부트스트랩 자바스크립트 추가하기 -->
    <script src="./js/bootstrap.min.js"></script>
  </body>

</html>