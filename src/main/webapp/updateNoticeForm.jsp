<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//유효성 코드 noticeNo값이 null 또는 공백일경우 ./noticeList.jsp로 리다이렉션
	if(request.getParameter("noticeNo") == null
		|| request.getParameter("noticeNo").equals("")) {
		response.sendRedirect("./noticeList.jsp");
	} 
	// 메소드 이용해서 정수형으로 받기
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	// 1) 드라이버 구동(외부 라이브러리에서 가져온다.)
	Class.forName("org.mariadb.jdbc.Driver");
	// 2) db 접속, 3가지 매개변수값 전달받는다.(url, 계정id, 계정pw)
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	/* 
		사용할 sql문 미리 작성
		select notice_no, notice_title, notice_content, 
		notice_writer, createdate, updatedate from notice 
		where notice_no = ?
	*/
	
	// sql문을 받아서 prepareStatement 사용하여 적용한다. AS 사용해서 DB와 자바 변수명 일치시킨다.
	String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, notice_pw noticePw, createdate, updatedate FROM notice WHERE notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// stmt의 첫번째 ?를 해당 값으로 바꾼다.
	stmt.setInt(1, noticeNo);
	// stmt 값 전달받아서 확인
	System.out.println(stmt + "<-- stmt");
	// 데이터베이스에서 select 쿼리를 실행하고 결과를 ResultSet에 반환한다.
	ResultSet rs = stmt.executeQuery();
	// 자료구조 ResultSet타입을 일반적인 자료구조 타입(자바 배열 or 기본API 자료구조타입 List, Set, Map)
	// Set 타입은 순서가없어서 for-each문 사용이 힘듬. (SELECT, SET)의 값은 절대로 중복될수 없다.
	// ResultSet -> ArrayList<Notice> // 모델(모델값)
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()) {
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.noticeContent = rs.getString("noticeContent");
		n.noticeWriter = rs.getString("noticeWriter");
		n.noticePw = rs.getString("noticePw");
		n.createdate = rs.getString("createdate");
		n.updatedate = rs.getString("updatedate");
		noticeList.add(n);
	}
%>   

<!doctype html>
<html>
<head>
	<meta charset="utf-8" />
	<link rel="apple-touch-icon" sizes="76x76" href="./resources/assets/img/apple-icon.png">
	<link rel="icon" type="image/png" sizes="96x96" href="./resources/assets/img/favicon.png">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />

	<title>updateNoticeForm</title>

	<meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0' name='viewport' />
    <meta name="viewport" content="width=device-width" />


    <!-- Bootstrap core CSS     -->
    <link href="./resources/assets/css/bootstrap.min.css" rel="stylesheet" />

    <!-- Animation library for notifications   -->
    <link href="./resources/assets/css/animate.min.css" rel="stylesheet"/>

    <!--  Paper Dashboard core CSS    -->
    <link href="./resources/assets/css/paper-dashboard.css" rel="stylesheet"/>


    <!--  CSS for Demo Purpose, don't include it in your project     -->
    <link href="./resources/assets/css/demo.css" rel="stylesheet" />


    <!--  Fonts and icons     -->
    <link href="http://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css" rel="stylesheet">
    <link href='https://fonts.googleapis.com/css?family=Muli:400,300' rel='stylesheet' type='text/css'>
    <link href="./resources/assets/css/themify-icons.css" rel="stylesheet">

</head>
<body>


<div class="wrapper">
    <div class="sidebar" data-background-color="white" data-active-color="danger">

    <!--
		Tip 1: you can change the color of the sidebar's background using: data-background-color="white | black"
		Tip 2: you can change the color of the active button using the data-active-color="primary | info | success | warning | danger"
	-->

    	<div class="sidebar-wrapper">
            <div class="logo">
                <a href="https://github.com/Kim-Younghun/Diary" class="simple-text">
                    Dairy Project
                </a>
            </div>

            <ul class="nav">
                <li>
                    <a href="./home.jsp">
                        <i class="ti-home"></i>
                        <p>home</p>
                    </a>
                </li>
                <li>
                    <a href="./noticeList.jsp">
                        <i class="ti-bell"></i>
                        <p>noticeList</p>
                    </a>
                </li>
                <li>
                    <a href="./scheduleList.jsp">
                        <i class="ti-view-list-alt"></i>
                        <p>scheduleList</p>
                    </a>
                </li>
            </ul>
    	</div>
    </div>

    <div class="main-panel">
        <nav class="navbar navbar-default">
            <div class="container-fluid">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar bar1"></span>
                        <span class="icon-bar bar2"></span>
                        <span class="icon-bar bar3"></span>
                    </button>
                   	<table class="table">
                   		<tr>
							<td>
								개발 환경 및 라이브러리
							</td>
						</tr>
						<tr>
							<td>
								JDK 17(Calendar API 사용), HTML, CSS, HeidiSQL, Maria DB(10.5), Eclipse(22-12), Bootstrap5, JSP, JDBC
							</td>
						</tr>
						<tr>
							<td>
							[구현기능] <br> 1. 공지사항 및 스케쥴 UPDATE, DELETE, INSERT 기능 <br> 2. 달력에 일정내용 출력 <br> 3. 공지사항 목록 페이징 기능 
							</td>
						</tr>
                   	</table>
                </div>
            </div>
        </nav>

        <div class="content">
            <div class="container-fluid">
                <div class="row">
					<div class="col-md-8 col-md-offset-2">
                        <div class="card">
                            <div class="header text-center">
                                <h3 class="title">공지수정</h3>
								<br>
                            </div>
                            <div class="content table-responsive table-full-width table-upgrade">
                            <%
								// ArrayList<Notice> noticeList를 이용한 반복문
								for(Notice n : noticeList) {
							%>
							<div class="text-danger">
								<%
									// 메세지의 값이 존재하는 경우 메세지 출력
									if(request.getParameter("msg") != null) {
								%>
									<%=request.getParameter("msg")%>
								<%	
									}
								%>
							</div>
								<!-- 액션페이지로 연동되도록 함-->
                            	<form action="./updateNoticeAction.jsp" method="post">
	                                <table class="table">
	                                  	<tr>
											<td>
												번호
											</td>
											<td>
												<!-- 프로그램 내에서는 camel 표기법 사용, db에서는 _형식 사용, 수정할 수 없도록 readonly 속성 사용 -->
												<input type="text" name="noticeNo" value="<%=n.noticeNo%>" readonly="readonly">
											</td>
										</tr>
										<tr>
											<td>
												비밀번호
											</td>
											<td>
												<!-- 프로그램 내에서는 camel 표기법 사용, db에서는 _형식 사용 -->
												<input type="password" name="noticePw"">
											</td>
										</tr>
										<tr>
											<td>
												제목
											</td>
											<td>
												<!-- 프로그램 내에서는 camel 표기법 사용, db에서는 _형식 사용 -->
												<input type="text" name="noticeTitle" value="<%=n.noticeTitle%>">
											</td>
										</tr>
										<tr>
											<td>
												내용
											</td>
											<td>
												<!-- 프로그램 내에서는 camel 표기법 사용, db에서는 _형식 사용 -->
												<textarea rows="5" cols="80" name="noticeContent"><%=n.noticeContent%></textarea>
											</td>
										</tr>
										<tr>
											<td>
												작성자
											</td>
											<td>
												<!-- 수정이 필요없는 부분, 내용 받아서 표시 -->
												<%=n.noticeWriter%>
											</td>
										</tr>
										<tr>
											<td>
												생성날짜
											</td>
											<td>
												<!-- 수정이 필요없는 부분, 내용 받아서 표시 -->
												<%=n.createdate%>
											</td>
										</tr>
										<tr>
											<td>
												수정날짜
											</td>
											<td>
												<!-- 수정이 필요없는 부분, 내용 받아서 표시 -->
												<%=n.updatedate%>
											</td>
										</tr>
	                                </table>
	                                <div>
										<button type="submit" class="btn btn-warning">수정</button>
									</div>
                                </form>
                                <%
									}
								%>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <footer class="footer">
            <div class="container-fluid">
                <div class="copyright pull-right">
                    &copy; <script>document.write(new Date().getFullYear())</script>, made with <i class="fa fa-heart heart"></i> by Creative Tim
                </div>
            </div>
        </footer>

    </div>
</div>


</body>

    <!--   Core JS Files   -->
    <script src="./resources/assets/js/jquery-1.10.2.js" type="text/javascript"></script>
	<script src="./resources/assets/js/bootstrap.min.js" type="text/javascript"></script>

	<!--  Checkbox, Radio & Switch Plugins -->
	<script src="./resources/assets/js/bootstrap-checkbox-radio.js"></script>

	<!--  Charts Plugin -->
	<script src="./resources/assets/js/chartist.min.js"></script>

    <!--  Notifications Plugin    -->
    <script src="./resources/assets/js/bootstrap-notify.js"></script>

    <!--  Google Maps Plugin    -->
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js"></script>

    <!-- Paper Dashboard Core javascript and methods for Demo purpose -->
	<script src="./resources/assets/js/paper-dashboard.js"></script>

	<!-- Paper Dashboard DEMO methods, don't include it in your project! -->
	<script src="./resources/assets/js/demo.js"></script>
</html>