<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>home.jsp</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
			<a href="./home.jsp">홈으로</a>
			<a href="./noticeList.jsp">공지리스트</a>
			<a href="./scheduleList.jsp">일정리스트</a>
	
		<!-- 날짜순 최근 공지 5개 -->
		<% 
			//스태틱 메서드, 드라이브 로딩, 메모리에 올린다, 변수에 저장할 필요없음.
			Class.forName("org.mariadb.jdbc.Driver");
			// 마리아db 접속을 유지해야 함 
			Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
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
		<h1 class="text-bg-info">
			<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" class="bi bi-calendar" viewBox="0 0 16 16">
			  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
			</svg>&nbsp;공지사항
		</h1>
		<table class="table table-striped" >
			<tr>
				<th>공지사항제목</th>
				<th>생성날짜</th>
			</tr>
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
		</table>
			<h1 class="text-bg-info">
				<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" class="bi bi-calendar" viewBox="0 0 16 16">
				  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
				</svg>&nbsp;오늘일정
			</h1>
		<table class="table table-striped">
			<tr>
				<th>일정년월</th>
				<th>일정시간</th>
				<th>일정내용</th>
			</tr>
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
						<a href="./scheduleOne.jsp?scheduleNo=<%=s.scheduleNo%>">
							<%=s.scheduleMemo%>
						</a>
					</td>
				</tr>
			<%		
				}
			%>
		</table>
			<h1 class="text-bg-info">
				<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" class="bi bi-calendar" viewBox="0 0 16 16">
				  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
				</svg>&nbsp;다이어리 프로젝트
			</h1>
		<table class="table table-striped">
			<tr>
				<td>
					개발 환경 및 라이브러리
				</td>
			</tr>
			<tr>
				<td>
					JDK 17(Calendar API 사용), HTML, CSS, SQL, Maria DB, Eclipse, Bootstrap, JSP, JDBC, JSTL
				</td>
			</tr>
			<tr>
				<td>
				[구현기능] <br> 1. 공지사항 및 스케쥴 UPDATE, DELETE, INSERT 기능 <br> 2. 달력에 일정내용 출력 <br> 3. 공지사항 목록 페이징 기능 
				</td>
			</tr>
		</table>
	</div>
</body>
</html>