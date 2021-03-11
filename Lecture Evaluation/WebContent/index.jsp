<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.UserDAO" %>
<%@ page import='evaluation.EvaluationDTO' %>
<%@ page import='evaluation.EvaluationDAO' %>
<%@ page import='java.util.ArrayList' %>
<%@ page import='java.net.URLEncoder' %>
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
	request.setCharacterEncoding("UTF-8");
	String lectureDivide="全体";
	String searchType="最新順";
	String search="";
	int pageNumber=0;
	if(request.getParameter("lectureDivide")!=null){
		lectureDivide=request.getParameter("lectureDivide");
	}
	if(request.getParameter("searchType")!=null){
		searchType=request.getParameter("searchType");
	}
	if(request.getParameter("search")!=null){
		search=request.getParameter("search");
	}	
	if(request.getParameter("pageNumber")!=null){
		try{
			pageNumber=Integer.parseInt(request.getParameter("pageNumber"));
		}catch(Exception e){
			System.out.println("検索ページ番号エラー発生");
		}
	}
	String userID=null;
	if(session.getAttribute("userID")!=null){
		userID=(String)session.getAttribute("userID");
	}
	if(userID==null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('ログインしてください');");
		script.println("location.href='userLogin.jsp';");
		script.println("</script>");
		script.close();
	}
 	boolean emailChecked = new UserDAO().getUserEmailChecked(userID);
	if(emailChecked==false){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('ログインしてください');");
		script.println("location.href='emailSendConfirm.jsp';");
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
    <div class="container">
      <form method="get" action="./index.jsp" class="form-inline mt-3">
        <select name="lectureDivide" class="form-control mx-1 mt-2">
          <option value="全体">全体</option>
          <option value="専攻" <%if(lectureDivide.equals("専攻")) out.println("selected");%>>専攻</option>
          <option value="教養"<%	if(lectureDivide.equals("教養")) out.println("selected");%>>教養</option>
          <option value="その他" <%	if(lectureDivide.equals("その他")) out.println("selected");%>>その他</option>
        </select>
        <select name="searchType" class="form-control mx-1 mt-2">
          <option value="最新順">最新順</option>
          <option value="いいね順"><%if(searchType.equals("いいね順")) out.println("selected");%>いいね順</option>
        </select>
        <input type="text" name="search" class="form-control mx-1 mt-2" placeholder="内容を入力してください">
        <button type="submit" class="btn btn-primary mx-1 mt-2">検索</button>
        <a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#registerModal">登録</a>
        <a class="btn btn-danger ml-1 mt-2" data-toggle="modal" href="#reportModal">Report</a>
      </form>
 <%
 	ArrayList<EvaluationDTO>evaluationList=new ArrayList<EvaluationDTO>();
	evaluationList=new EvaluationDAO().getList(lectureDivide,searchType,search,pageNumber);
	if(evaluationList!=null)
		for(int i=0; i<evaluationList.size();i++){
			if(i==5)break;
			EvaluationDTO evaluation=evaluationList.get(i);
 %>     
      <div class="card bg-light mt-3">
        <div class="card-header bg-light">
          <div class="row">
            <div class="col-8 text-left"><%=evaluation.getLectureName() %>&nbsp;<small><%=evaluation.getProfessorName() %></small></div>
            <div class="col-4 text-right">
              総合 <span style="color: red;"><%=evaluation.getTotalScore() %></span>
            </div>
          </div>
        </div>
        <div class="card-body">
          <h5 class="card-title">
           <%=evaluation.getEvaluationTitle() %>&nbsp;<small><%=evaluation.getLectureYear() %>年<%=evaluation.getSemesterDivide() %></small>
          </h5>
          <p class="card-text"><%=evaluation.getEvaluationContent() %></p>
          <div class="row">
            <div class="col-9 text-left">
              成績 <span style="color: red;"><%=evaluation.getCreditScore() %></span>
              キツイ <span style="color: red;"><%=evaluation.getComfortableScore() %></span>
              講義 <span style="color: red;"><%=evaluation.getLectureScore() %></span>
              <span style="color: green;">(いいね！:<%=evaluation.getLikeCount()%>)</span>
            </div>
            <div class="col-3 text-right">
              <a onclick="return confirm('いいねしますか?')" href="./likeAction.jsp?evaluationID=<%=evaluation.getEvaluationID()%>">いいね！</a>
              <a onclick="return confirm('削除しますか?')" href="./deleteAction.jsp?evaluationID=<%=evaluation.getEvaluationID()%>">削除</a>
            </div>
          </div>
        </div>
      </div>
<%

	}

%>

    </div>

    <ul class="pagination justify-content-center mt-3">

      <li class="page-item">

<%
	if(pageNumber <= 0) {
%>     
        <a class="page-link disabled">以前</a>
<%
	} else {
%>
		<a class="page-link" href="./index.jsp?lectureDivide=<%=URLEncoder.encode(lectureDivide, "UTF-8")%>&searchType=<%=URLEncoder.encode(searchType, "UTF-8")%>&search=<%=URLEncoder.encode(search, "UTF-8")%>&pageNumber=<%=pageNumber - 1%>">이전</a>
<%
	}
%>
      </li>
      <li class="page-item">
<%
	if(evaluationList.size() < 6) {
%>     
        <a class="page-link disabled">次</a>
<%
	} else{
%>
		<a class="page-link" href="./index.jsp?lectureDivide=<%=URLEncoder.encode(lectureDivide, "UTF-8")%>&searchType=
		<%=URLEncoder.encode(searchType, "UTF-8")%>&search=<%=URLEncoder.encode(search, "UTF-8")%>&pageNumber=
		<%=pageNumber + 1%>">次</a>
<%
	}
 %>       
      </li> 
    </ul>
    <div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="modal">評価登録</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <form action="./evaluationRegisterAction.jsp" method="post">
              <div class="form-row">
                <div class="form-group col-sm-6">
                  <label>講義名</label>
                  <input type="text" name="lectureName" class="form-control" maxlength="20">
                </div>
                <div class="form-group col-sm-6">
                  <label>先生名</label>
                  <input type="text" name="professorName" class="form-control" maxlength="20">
                </div>
              </div>
              <div class="form-row">
                <div class="form-group col-sm-4">
                  <label>年度</label>
                  <select name="lectureYear" class="form-control">
                    <option value="2018">2018</option>
                    <option value="2019">2019</option>
                    <option value="2020">2020</option>
                    <option value="2021" selected>2021</option>
                  </select>
                </div>
                <div class="form-group col-sm-4">
                  <label>学期</label>
                  <select name="semesterDivide" class="form-control">
                    <option name="春学期" selected>春学期</option>
                    <option name="秋学期">秋学期</option>
                  </select>
                </div>
                <div class="form-group col-sm-4">
                  <label>講義</label>
                  <select name="lectureDivide" class="form-control">
                    <option name="専攻" selected>専攻</option>
                    <option name="教養">教養</option>
                    <option name="その他">その他</option>
                  </select>
                </div>
              </div>
              <div class="form-group">
                <label>タイトル</label>
                <input type="text" name="evaluationTitle" class="form-control" maxlength="20">
              </div>
              <div class="form-group">
                <label>内容</label>
                <textarea  name="evaluationContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
              </div>
              <div class="form-row">
                <div class="form-group col-sm-3">
                  <label>総合</label>
                  <select name="totalScore" class="form-control">
                    <option value="A" selected>A</option>
                    <option value="B">B</option>
                    <option value="C">C</option>
                    <option value="D">D</option>
                    <option value="F">F</option>
                  </select>
                </div>
                <div class="form-group col-sm-3">
                  <label>成績</label>
                  <select name="creditScore" class="form-control">
                    <option value="A" selected>A</option>
                    <option value="B">B</option>
                    <option value="C">C</option>
                    <option value="D">D</option>
                    <option value="F">F</option>
                  </select>
                </div>
                <div class="form-group col-sm-3">
                  <label>キツイ</label>
                  <select name="comfortableScore" class="form-control">
                    <option value="A" selected>A</option>
                    <option value="B">B</option>
                    <option value="C">C</option>
                    <option value="D">D</option>
                    <option value="F">F</option>
                  </select>
                </div>
                <div class="form-group col-sm-3">
                  <label>講義</label>
                  <select name="lectureScore" class="form-control">
                    <option value="A" selected>A</option>
                    <option value="B">B</option>
                    <option value="C">C</option>
                    <option value="D">D</option>
                    <option value="F">F</option>
                  </select>
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">キャンセル</button>
                <button type="submit" class="btn btn-primary">登録</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    <div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="modal">Report</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <form method="post" action="./reportAction.jsp">
              <div class="form-group">
                <label>タイトル</label>
                <input type="text" name="reportTitle" class="form-control" maxlength="20">
              </div>
              <div class="form-group">
                <label>内容</label>
                <textarea type="text" name="reportContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
              </div>

              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">キャンセル</button>
                <button type="submit" class="btn btn-danger">登録</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
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