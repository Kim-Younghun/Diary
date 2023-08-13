<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>

<%
	// 년월 변수 선언
	int targetYear = 0;
	int targetMonth = 0;
	
	// 년 or 월이 null일경우 오늘 년, 월을 넣는다.
	// -1, 12 의 값이 Month값이 들어가도 Calendar가 내부적으로 전년, 다음년으로 처리된다.
	if(request.getParameter("targetYear") == null 
			|| (request.getParameter("targetMonth") == null)) {
		Calendar c = Calendar.getInstance();
		targetYear = c.get(Calendar.YEAR);
		targetMonth = c.get(Calendar.MONTH);
	} else { // 정수형으로 값 넣기
		targetYear = Integer.parseInt(request.getParameter("targetYear"));
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
	// 변수값 제대로 입력됬는지 확인
	System.out.println(targetYear + " <-- scheduleList param targetYear");
	System.out.println(targetMonth + " <-- scheduleList param targetMonth");
	
	// 오늘 날짜
	Calendar today = Calendar.getInstance();
	int todayDate = today.get(Calendar.DATE);
	
	// targetMonth 1일 요일 확인
	Calendar firstDay = Calendar.getInstance(); //  2023 4 24
	firstDay.set(Calendar.YEAR, targetYear); // 
	firstDay.set(Calendar.MONTH, targetMonth);
	firstDay.set(Calendar.DATE, 1); // 2023 4 1
	// targetMonth에 -1, 12의 값이 들어갈 경우 내부에서 처리했으므로 다시 내부의 값을 저장한다.
	// ex) 년23월12 입력 Calendar API 년24월1로 변경함.
	// ex) 년23월-1 입력 Calendar API 년22월12로 변경함.
	targetYear = firstDay.get(Calendar.YEAR);
	targetMonth = firstDay.get(Calendar.MONTH);
	// 디버깅 확인
	System.out.println(targetYear + " <-- api실행 후 targetYear");
	System.out.println(targetMonth + " <-- api실행 후 targetMonth");
	
	// 2023 4 1이 몇 요일인지(일-1, 토-7)
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK); 
	// 1일앞의 공백칸의 수 (요일수 -1로 공백수를 구한다.)
	int startBlank = firstYoil - 1;
	// startTdBlank 확인
	System.out.println(startBlank + " <-- startBlank");
	
	
	// targetMonth 마지막일
	int lastDate = firstDay.getActualMaximum(Calendar.DATE);
	// lastDate 확인
	System.out.println(lastDate + " <-- lastDate");
	
	// lastDate 날짜 뒤 공백칸의 개수
	int endBlank = 0;
	if((startBlank+lastDate) % 7 != 0) {
		endBlank = 7-((startBlank+lastDate)%7);
	}
	// 전체 TD이 개수는 앞 빈칸 + 마지막날짜(1~마지막날짜) + 뒤 빈칸
	int totalTD = startBlank + lastDate + endBlank;
	// 전체 Td 개수확인
	System.out.println(totalTD + " <-- totalTD");
	
	// DB date를 가져오는 알고리즘
	//스태틱 메서드, 드라이브 로딩, 메모리에 올린다, 변수에 저장할 필요없음.
	Class.forName("org.mariadb.jdbc.Driver");
	// 마리아db 접속을 유지해야 함 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://52.78.47.161:3306/diary", "root", "java1234");
	
	/* 
		SELECT schedule_no scheduleNo, 
		day(schedule_date) scheduleDate,
		substr(schedule_memo, 1, 5) scheduleMemo, schedule_color scheduleColor 
		FROM schedule
		WHERE year(schedule_date) = ? AND month(schedule_date) = ?
		ORDER BY month(schedule_date) ASC;
	*/
	
	// AS 사용하여 DB컬럼명과 자바 변수명과 일치시킨다.
	// `schedule` 테이블에서 특정 년도와 월에 해당하는 일정 정보를 조회하고, 
	// 해당 월의 일 정보와 일정 내용, 색상 정보를 가져와 정렬한 결과를 출력하는 SQL문
	PreparedStatement stmt = conn.prepareStatement(
			 "SELECT schedule_no scheduleNo, day(schedule_date) scheduleDate, substr(schedule_memo, 1, 5) scheduleMemo, schedule_color scheduleColor FROM schedule WHERE year(schedule_date) = ? AND month(schedule_date) = ? ORDER BY schedule_date ASC");
	stmt.setInt(1, targetYear);
	stmt.setInt(2, targetMonth+1); // 자바 API(0~11) -> 마리아DB 형식(1~12)
	// 디버깅 코드
	System.out.println(stmt + "<-- stmt");
	ResultSet rs = stmt.executeQuery();
	// ResultSet -> ArrayList<Schedule>
	// 데이터베이스에서 조회한 일정 정보를 `Schedule` 객체로 변환하여 `ArrayList`에 추가하는 코드
	// `Schedule` 객체를 저장하기 위한 `ArrayList`를 생성
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	// 데이터베이스에서 조회한 결과가 있을 때까지 반복 
	while(rs.next()) {
		// `Schedule` 객체를 생성하고, 조회 결과를 이용하여 `Schedule` 객체의 필드 값을 설정
		Schedule s = new Schedule();
		// `rs` 객체에서 `scheduleNo` 필드 값을 읽어와서 `s` 객체의 `scheduleNo` 필드에 저장
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate"); // 일(day) 데이터만 저장되어 있음
		s.scheduleMemo = rs.getString("scheduleMemo"); // 5글자만 출력
		s.scheduleColor = rs.getString("scheduleColor");
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

	<title>scheduleList</title>

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
    
<style>
    .arrow {
        font-size: 2em; /* 2배 크기 설정 */
    }
</style>

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
                            	<!-- 출력할때는 +1를 더해서 보여질때 Month값이 일치되도록 -->
                                <h3 class="title"><%=targetYear%>년 <%=targetMonth+1%>월</h3>
								<br>
                            </div>
                            <div>
								<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>"><span class="arrow">&lt;</span></a>
								<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>"><span class="arrow">&gt;</span></a>
							</div>
                            <div class="content table-responsive table-full-width table-upgrade">
                                <table class="table">
                                    <thead>
										<tr>
											<td>일</td>
											<td>월</td>
											<td>화</td>
											<td>수</td>
											<td>목</td>
											<td>금</td>
											<td>토</td>
										</tr>
									</thead>
									<tbody>
									<tr>
										<%
											for(int i=0; i<totalTD; i+=1) {
												// 지난달 날짜부터 이번달 달력의 첫째 날짜까지 일자를 출력할 변수
												int num = i-startBlank+1;
												
												if(i != 0 && i%7==0) {
										%>
													</tr><tr>
										<%			
												}
												String tdStyle = "";
												if(num>0 && num<=lastDate) {	
													// 현재 날짜와 달력에서 출력하고자 하는 날짜가 일치할경우
													if(today.get(Calendar.YEAR) == targetYear 
														&& today.get(Calendar.MONTH) == targetMonth
														&& today.get(Calendar.DATE) == num) {
														tdStyle = "background-color:orange;";
													}
										%>
														<td style=<%=tdStyle%>>
															<div><!-- 날짜 숫자 -->
																<a href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>"><%=num%></a>
															</div>
															<div><!-- 일정 memo(5글자) -->
																<%
																	for(Schedule s : scheduleList) {
																		// DB의 날짜 정보와 자바의 num 변수의 날짜 정보가 일치하면
																		if(num == Integer.parseInt(s.scheduleDate)) { 
																%>
																		<div style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo%></div>
																<%
																		}
																	}
																%>
															</div>
														</td>
										<%	
													} else {
										%>
														<td>&nbsp;</td>		
										<%			
												}
											}
										%>
									</tr>
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