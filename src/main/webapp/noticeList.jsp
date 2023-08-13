<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>

<%
	// 요청 분석(currentPage, ...)
	// 현재페이지
	int currentPage = 1;
	// 현재페이지에 공백이 아닐경우 현재페이지를 참조형 정수로 
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage + "<-- currentPage");
	// 페이지당 출력할 행의 수
	int rowPerPage = 10;
	
	// 시작 행번호
	int startRow = (currentPage-1)*rowPerPage;
	/*
		 currentPage	startRow(rowPerPage = 10일 경우)
		 1				0
		 2				10
		 3				20
		 4				30     패턴찾기, (currentPage-1)*rowPerPage
	*/
	
	// DB연결 설정
	// select notice_title, createdate from notice 
		// order by createdate desc
		// limit ?, ?
		//스태틱 메서드, 드라이브 로딩, 메모리에 올린다, 변수에 저장할 필요없음.
		Class.forName("org.mariadb.jdbc.Driver");
		// 마리아db 접속을 유지해야 함 
		Connection conn = DriverManager.getConnection("jdbc:mariadb://52.78.47.161:3306/diary", "root", "java1234");
		// 문자열로 sql문을 받아서 sql로 적용
		// AS 사용하여 DB컬럼명과 자바 변수명과 일치시킨다.
		PreparedStatement stmt = conn.prepareStatement(
				"SELECT notice_no noticeNo, notice_title noticeTitle, createdate FROM notice ORDER BY createdate DESC LIMIT ?, ?");
		stmt.setInt(1, startRow);
		stmt.setInt(2, 10);
		// 디버깅 코드
		System.out.println(stmt + "<-- stmt");
		// 출력할 공지 데이터, select시에만 ResultSet 필요함, 전체 행
		ResultSet rs = stmt.executeQuery();
		// 자료구조 ResultSet타입을 일반적인 자료구조 타입(자바 배열 or 기본API 자료구조타입 List, Set, Map)
		// Set 타입은 순서가없어서 for-each문 사용이 힘듬. (SELECT, SET)의 값은 절대로 중복될수 없다.
		// ResultSet -> ArrayList<Notice> // 모델(모델값)
		ArrayList<Notice> noticeList = new ArrayList<Notice>();
		while(rs.next()) {
			Notice n = new Notice();
			n.noticeNo = rs.getInt("noticeNo");
			n.noticeTitle = rs.getString("noticeTitle");
			n.createdate = rs.getString("createdate");
			noticeList.add(n);
		}
		
		// select count(*) from notice;
		// 데이터베이스에서 `notice` 테이블의 총 행(row) 수를 구하여, 
		// 한 페이지당 보여줄 행의 수(`rowPerPage`)를 나누어 페이지 수(`lastPage`)를 계산하는 코드
		PreparedStatement stmt2 = conn.prepareStatement("select count(*) from notice");
		ResultSet rs2 = stmt2.executeQuery();
		int totalRow = 0; 
		if(rs2.next()) {
			totalRow = rs2.getInt("count(*)");
			System.out.println(totalRow + "<-- totalRow"); 
		}
		int lastPage = totalRow / rowPerPage;
		if(totalRow % rowPerPage != 0 ) {
			lastPage = lastPage+1;
		}
%>

<!doctype html>
<html>
<head>
	<meta charset="utf-8" />
	<link rel="apple-touch-icon" sizes="76x76" href="./resources/assets/img/apple-icon.png">
	<link rel="icon" type="image/png" sizes="96x96" href="./resources/assets/img/favicon.png">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />

	<title>noticeList</title>

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
                                <h3 class="title">공지사항리스트</h3>
								<br>
                            </div>
                            <div class="content table-responsive table-full-width table-upgrade">
                                <table class="table">
                                  	<tr>
										<td>공지사항제목</td>
										<td>생성날짜</td>
									</tr>
									<!-- 출력코드 -->
									<% 	
										// ArrayList<Notice> noticeList를 이용한 반복문
										for(Notice n : noticeList) {
									%>
									<tr>
										<td>
											<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>">
												<%=n.noticeTitle%>
											</a>
										</td>
										<!-- 뒤의 시간 정보를 자른다. -->
										<td><%=n.createdate.substring(0, 10) %></td>
									</tr>
									<% 	
										}
									%>
                                </table>
                                <div class="text-center">
									<%
										// 현재페이지가 1보다 클때 이전링크가 나타나도록
										if(currentPage > 1) {
									%>
											<a href="./noticeList.jsp?currentPage=<%=currentPage-1%>">이전</a>
									<%
										}
									%>
											<%=currentPage%>
									<% 
										// 현재페이지가 마지막페이지보다 작을때 다음링크가 나타나도록
										if(currentPage < lastPage) {
									
									%>
											<a href="./noticeList.jsp?currentPage=<%=currentPage+1%>">다음</a>
									<%
										}
									%>
								</div>
								<form action="./insertNoticeForm.jsp" method="post">
									&nbsp; <button class="btn btn-success" type="submit" name="currentPage" value="<%=currentPage%>">공지 입력</button>
								</form>
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