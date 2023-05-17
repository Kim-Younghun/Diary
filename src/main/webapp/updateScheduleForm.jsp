<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 이전페이지로부터 넘어온 값 확인
	System.out.println(request.getParameter("scheduleNo"));
	System.out.println(request.getParameter("y"));
	System.out.println(request.getParameter("m"));
	System.out.println(request.getParameter("d"));

	//유효성 코드(이전 페이지로부터 넘어온 값 확인)
	if(request.getParameter("scheduleNo") == null
		|| request.getParameter("scheduleNo").equals("")) {
			
		response.sendRedirect("./scheduleList.jsp");
		System.out.println("updateScheduleForm 오류");
		return;
		}
	
	// 메소드 이용해서 정수형으로 받기
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	// 1) 드라이버 구동(외부 라이브러리에서 가져온다.)
	Class.forName("org.mariadb.jdbc.Driver");
	// 2) db 접속, 3가지 매개변수값 전달받는다.(url, 계정id, 계정pw)
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	// sql문을 받아서 prepareStatement 사용하여 적용한다.
	// AS 사용해서 DB 컬럼값과 자바 클래스값과 일치시킨다.
	String sql = "SELECT schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_color scheduleColor, schedule_memo scheduleMemo, createdate, updatedate, schedule_pw schedulePw FROM schedule WHERE schedule_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// stmt의 첫번째 ?를 바꿈
	stmt.setInt(1, scheduleNo);
	// stmt 값 전달받아서 확인
	System.out.println(stmt + "<-- updateScheduleForm param stmt");
	// 데이터베이스에서 select 쿼리를 실행하고 결과를 ResultSet에 반환한다.
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
		s.scheduleDate = rs.getString("scheduleDate"); 
		s.scheduleTime = rs.getString("scheduleTime"); 
		s.scheduleColor = rs.getString("scheduleColor");
		s.scheduleMemo = rs.getString("scheduleMemo");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		s.schedulePw = rs.getString("schedulePw");
		// while문 밖에 있는 변수에 관련 내용을 추가한다.
		scheduleList.add(s);
	}
%>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateNoticeForm</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<%
		for(Schedule s : scheduleList) {
	%>
	<div class="container">
		<h1 class="text-bg-info">
			<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" class="bi bi-book" viewBox="0 0 16 16">
				  <path d="M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811V2.828zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492V2.687zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783z"/>
			</svg>&nbsp;일정수정
		</h1>
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
		<!-- 액션페이지로 연동되도록,  -->
		<form action="./updateScheduleAction.jsp" method="post">
			<table class="table table-striped">
				<tr>
					<td>
						번호
					</td>
					<td>
						<input type="text" name="scheduleNo" value="<%=s.scheduleNo%>" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td>
						일정날짜
					</td>
					<td>
						<input type="date" name="scheduleDate" value="<%=s.scheduleDate%>">
					</td>
				</tr>
				<tr>
					<td>
						비밀번호
					</td>
					<td>
						<input type="password" name="schedulePw">
					</td>
				</tr>
				<tr>
					<td>
						색상
					</td>
					<td>
						<input type="color" name="scheduleColor" value="<%=s.scheduleColor%>">
					</td>
				</tr>
				<tr>
					<td>
						일정시간
					</td>
					<td>
						<input type="time" name="scheduleTime" value="<%=s.scheduleTime%>">
					</td>
				</tr>
				<tr>
					<td>
						일정내용
					</td>
					<td>
						<textarea rows="5" cols="80" name="scheduleMemo"><%=s.scheduleMemo%></textarea>
					</td>
				</tr>
				<tr>
					<td>
						생성날짜
					</td>
					<td>
						<%=s.createdate%>
					</td>
				</tr>
				<tr>
					<td>
						수정날짜
					</td>
					<td>
						<%=s.updatedate%>
					</td>
				</tr>
			</table>
			<div>
				<button type="submit" class="btn btn-warning">수정</button>
			</div>
		</form>
	</div>
	<%
		}
	%>
</body>
</html>