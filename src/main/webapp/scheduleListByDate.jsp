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
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleListByDate</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<a href="./home.jsp">홈으로</a>
		<a href="./noticeList.jsp">공지 리스트</a>
		<a href="./scheduleList.jsp">일정 리스트</a>
		<h1 class="text-bg-info">
			<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" class="bi bi-book" viewBox="0 0 16 16">
				  <path d="M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811V2.828zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492V2.687zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783z"/>
			</svg>&nbsp;스케쥴 입력
		</h1>
		<form action="./insertScheduleAction.jsp" method="post">
			<table class="table table-striped">
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
	<div class="container">
		<!-- 상세페이지 -->
		<h1 class="text-bg-info"><%=y%>년 <%=m%>월 <%=d%>일 스케쥴 목록</h1>
		<table class="table table-striped text-center">
			<tr>
				<th style="width: 100px;">일정시간</th>
				<th>일정메모</th>
				<th>생성시간</th>
				<th>수정시간</th>
				<th style="width: 50px;">수정</th>
				<th style="width: 50px;">삭제</th>
			</tr>
			<%
				for(Schedule s : scheduleList) {
			%>
				<tr>
					<td style="width: 100px;"><%=s.scheduleTime%></td>
					<td><%=s.scheduleMemo%></td>
					<td><%=s.createdate%></td>
					<td><%=s.updatedate%></td>
					<td style="width: 50px;"><a href="./updateScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">수정</a></td>
					<td style="width: 50px;"><a href="./deleteScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">삭제</a></td>
				</tr>
			<%
				}
			%>
		</table>
	</div>
</body>
</html>