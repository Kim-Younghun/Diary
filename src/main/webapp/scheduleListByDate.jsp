<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>

<%
	
	// 1. `y`, `m`, `d` 변수의 초기값을 0으로 설정합니다.
	// 2. `getParameter()` 메소드를 이용하여 `yParam`, `mParam`, `dParam` 변수에 파라미터 값을 가져옵니다.
	// 3. `yParam`, `mParam`, `dParam` 변수가 `null`이 아니고, 숫자 값인 경우에만 `parseInt()` 메소드를 호출하여 `y`, `m`, `d` 변수에 값을 할당합니다.
	// 4. `matches()` 메소드를 이용하여 파라미터 값이 숫자 값인지 확인합니다. 파라미터 값이 숫자 값이 아닌 경우 `parseInt()` 메소드를 호출할 수 없으므로, 이 과정이 필요합니다.
	int y = 0;
	int m = 0;
	int d = 0;

	String yParam = request.getParameter("y");
	if (yParam != null && yParam.matches("\\d+")) {
	    y = Integer.parseInt(yParam);
	}

	String mParam = request.getParameter("m");
	if (mParam != null && mParam.matches("\\d+")) {
	    m = Integer.parseInt(mParam) + 1;
	}

	String dParam = request.getParameter("d");
	if (dParam != null && dParam.matches("\\d+")) {
	    d = Integer.parseInt(dParam);
	}

	// 디버깅 확인
	System.out.println(y +"<-- scheduleListByDate param y");
	System.out.println(m +"<-- scheduleListByDate param m");
	System.out.println(d +"<-- scheduleListByDate param d");
	
	// 숫자+문자 = 문자
	// 이 코드는 `m`과 `d` 변수에 저장된 월과 일 정보를 이용하여, 
	// "yyyy-MM-dd" 형식의 문자열을 만들어주는 코드
	String strM = m+"";
	if(m<10) {
		strM = "0"+strM;
	}
	String strD = d+"";
	if(d<10) {
		strD = "0"+strD;
	}
	
	// 일별 스케쥴 리스트
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://52.78.47.161:3306/diary", "root", "java1234");
	// 일정날짜를 일정시간의 오름차순으로 SELECT
	String sql = "SELECT schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_color scheduleColor, schedule_memo scheduleMemo, createdate, updatedate, schedule_pw schedulePw FROM schedule WHERE schedule_date = ? ORDER BY schedule_time ASC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ?에 들어갈 값("yyyy-MM-dd" 형식)
	stmt.setString(1, y+"-"+strM+"-"+strD);
	// stmt값 확인
	System.out.println(stmt + "<-- scheduleListByDate param stmt");
	// 호환성을 생각하면 ResultSet대신 ArrayList를 사용하는 것이 좋다.
	ResultSet rs = stmt.executeQuery();
	// ResultSet -> ArrayList<Schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()) {
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleTime = rs.getString("scheduleTime"); 
		s.scheduleMemo = rs.getString("scheduleMemo");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		// while문 밖에 있는 변수에 관련 내용을 추가한다.
		scheduleList.add(s);
	}
%>    
<!doctype html>
<html>
<head>
	<meta charset="utf-8" />
	<link rel="apple-touch-icon" sizes="76x76" href="./resources/assets/img/apple-icon.png">
	<link rel="icon" type="image/png" sizes="96x96" href="./resources/assets/img/favicon.png">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />

	<title>scheduleListByDate</title>

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

        <div class="content" style="margin-bottom: -300px;">
            <div class="container-fluid">
                <div class="row">
					<div class="col-md-8 col-md-offset-2">
                        <div class="card">
                            <div class="header text-center">
                                <h3 class="title">일정입력</h3>
								<br>
                            </div>
                            <div class="content table-responsive table-full-width table-upgrade">
	                            <form action="./insertScheduleAction.jsp" method="post">
	                                <table class="table">
	                                    <tr>
											<th>날짜</th>
											<td>
												<!-- 수정할수 없게 표현 -->
												<input type="date" name="scheduleDate" value="<%=y%>-<%=strM%>-<%=strD%>" readonly="readonly">
											</td>
										</tr>
										<tr>
											<th>시간</th>
											<td>
												<input type="time" name="scheduleTime">
											</td>
										</tr>
										<tr>
											<th>색상</th>
											<td>
												<input type="color" name="scheduleColor" value="#000000">
											</td>
										</tr>
										<tr>
											<th>메모</th>
											<td>
												<textarea rows="3" cols="80" name="scheduleMemo"></textarea>
											</td>
										</tr>
										<tr>
											<th>비밀번호</th>
											<td>
												<input type="text" name="noticePw">
											</td>
										</tr>
	                                </table>
	                                <button type="submit" class="btn btn-dark">스케쥴 입력</button>
	                            </form>
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
                            	<!-- 상세페이지 -->
                                <h3 class="title"><%=y%>년 <%=m%>월 <%=d%>일 스케쥴 목록</h3>
								<br>
                            </div>
                            <div class="content table-responsive table-full-width table-upgrade">
                                <table class="table">
                                    <tr>
										<th>일정시간</th>
										<th>일정메모</th>
										<th>생성시간</th>
										<th>수정시간</th>
										<th>수정</th>
										<th>삭제</th>
									</tr>
									<%
										for(Schedule s : scheduleList) {
									%>
										<tr>
											<td><%=s.scheduleTime%></td>
											<td><%=s.scheduleMemo%></td>
											<td><%=s.createdate%></td>
											<td><%=s.updatedate%></td>
											<td><a href="./updateScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">수정</a></td>
											<td><a href="./deleteScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">삭제</a></td>
										</tr>
									<%
										}
									%>
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