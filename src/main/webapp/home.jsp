<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>

<!doctype html>
<html>
<head>
	<meta charset="utf-8" />
	<link rel="apple-touch-icon" sizes="76x76" href="./resources/assets/img/apple-icon.png">
	<link rel="icon" type="image/png" sizes="96x96" href="./resources/assets/img/favicon.png">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />

	<title>home</title>

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

		<!-- 날짜순 최근 공지 5개 -->
		<% 
			//스태틱 메서드, 드라이브 로딩, 메모리에 올린다, 변수에 저장할 필요없음.
			Class.forName("org.mariadb.jdbc.Driver");
			// 마리아db 접속을 유지해야 함 
			Connection conn = DriverManager.getConnection("jdbc:mariadb://52.78.47.161:3306/diary", "root", "java1234");
			String sql1 = "SELECT notice_no noticeNo, notice_title noticeTitle, createdate FROM notice ORDER BY createdate DESC LIMIT 0, 5";
			PreparedStatement stmt1 = conn.prepareStatement(sql1);
			System.out.println(stmt1 + "<-- stmt1");
			ResultSet rs = stmt1.executeQuery();
			// ResultSet -> ArrayList<Notice>
			ArrayList<Notice> noticeList = new ArrayList<Notice>();
			while(rs.next()) {
				Notice n = new Notice();
				n.noticeNo = rs.getInt("noticeNo");
				n.noticeTitle = rs.getString("noticeTitle"); 
				n.createdate = rs.getString("createdate"); 
				noticeList.add(n);
			}
			// 내용을 10자리로 잘라서 표현, 일정날자를 (yyyy-mm-dd) 형식으로 표현, 일정시간을 오름차순으로(1,2,3...)
			String sql2 = "SELECT schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, substr(schedule_memo, 1, 10) scheduleMemo From schedule WHERE schedule_date = CURDATE() ORDER BY schedule_time ASC";
			PreparedStatement stmt2 = conn.prepareStatement(sql2);
			System.out.println(stmt2 + "<-- stmt2");
			ResultSet rs2 = stmt2.executeQuery();
			// ResultSet -> ArrayList<Schedule>
			ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
			while(rs2.next()) {
				Schedule s = new Schedule();
				s.scheduleNo = rs2.getInt("scheduleNo");
				s.scheduleDate = rs2.getString("scheduleDate"); // 현재 날짜를 yyyy-mm-dd 형식으로 반환
				s.scheduleMemo = rs2.getString("scheduleMemo"); // 10글자만 출력
				s.scheduleTime = rs2.getString("scheduleTime");
				// while문 밖에 있는 변수에 관련 내용을 추가한다.
				scheduleList.add(s);
			}
		%>

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

        <div class="content" style="margin-bottom: -300px;">
            <div class="container-fluid">
                <div class="row">
					<div class="col-md-8 col-md-offset-2">
                        <div class="card">
                            <div class="header text-center">
                                <h3 class="title">공지사항</h3>
								<br>
                            </div>
                            <div class="content table-responsive table-full-width table-upgrade">
                                <table class="table">
                                    <thead>
                                    	<tr>
	                                    	<td>공지사항제목</td>
	                                    	<td>생성날짜</td>
                                    	</tr>
                                    </thead>
                                    <tbody>
                                    <%
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
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="content">
            <div class="container-fluid">
                <div class="row">
					<div class="col-md-8 col-md-offset-2">
                        <div class="card">
                            <div class="header text-center">
                                <h3 class="title">오늘일정</h3>
								<br>
                            </div>
                            <div class="content table-responsive table-full-width table-upgrade">
                                <table class="table">
                                    <thead>
                                    	<tr>
	                                    	<td>일정년월</td>
	                                    	<td>일정시간</td>
	                                    	<td>일정내용</td>
                                    	</tr>
                                    </thead>
                                    <tbody>
                                    <%
										for(Schedule s : scheduleList) {
									%>
                                        <tr>
                                        	<td>
												<!-- 현재 날짜를 yyyy-mm-dd 형식으로 반환 -->
												<%=s.scheduleDate%>
											</td>
											<td><%=s.scheduleTime%></td>
											<td>
												<%=s.scheduleMemo%>
											</td>
                                        </tr>
                                    <% 	
										}
									%>
                                    </tbody>
                                </table>
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