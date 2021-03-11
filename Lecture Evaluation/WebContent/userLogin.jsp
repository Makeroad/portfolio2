<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.UserDAO" %>
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
<%
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
%>
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
          <input type="text" name="search" class="form-control mr-sm-2" placeholder="内容を入力してください">
          <button class="btn btn-outline-success my-2 my-sm-0" type="submit">検索</button>
        </form>
      </div>
    </nav>
    <section class="container mt-3" style="max-width:560px;">
		<form method="post" action="./userLoginAction.jsp">
			<div class="form-group">
				<label>ID</label>
				<input type="text" name="userID" class="form-control">
			</div>
			<div class="form-group">
				<label>パスワード</label>
				<input type="password" name="userPassword" class="form-control">
			</div>
			<button type="submit" class="btn btn-primary">ログイン</button>
		</form>
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