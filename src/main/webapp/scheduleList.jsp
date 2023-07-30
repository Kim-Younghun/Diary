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
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleList</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container"><!-- 메인메뉴 -->
		<a href="./home.jsp">홈으로</a>
		<a href="./noticeList.jsp">공지 리스트</a>
		<a href="./scheduleList.jsp">일정 리스트</a>
	
	<!-- 출력할때는 +1를 더해서 보여질때 Month값이 일치되도록 -->
	<h1 class="text-bg-info">
		<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" class="bi bi-book" viewBox="0 0 16 16">
			  <path d="M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811V2.828zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492V2.687zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783z"/>
		</svg>&nbsp;<%=targetYear%>년 <%=targetMonth+1%>월
	</h1>
	<div>
		<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>">이전달</a>
		<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>">다음달</a>
	</div>
		<table class="table table-bordered">
			<thead class="table-primary">
				<tr>
					<th>일</th>
					<th>월</th>
					<th>화</th>
					<th>수</th>
					<th>목</th>
					<th>금</th>
					<th>토</th>
				</tr>
			</thead>
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
		</table>
	</div>
</body>
</html>
