<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 유효성 검사해서 해당되면 리스트로 리디렉션 후 코드종료
	if(request.getParameter("noticeNo")== null) {
		response.sendRedirect("./noticeList.jsp");
		return;
	} 
		// Cannot parse null string
		int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
		// DB접속
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://52.78.47.161:3306/diary", "root", "java1234");
		// notice_no에 해당하는 행을 SELECT하는 SQL문
		String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate FROM notice WHERE notice_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		// stmt의 첫번째 ?를 noticeNo안의 값으로 바꾼다.
		stmt.setInt(1, noticeNo);
		// 값 확인
		System.out.println(stmt + "<-- stmt");
		ResultSet rs = stmt.executeQuery();
		// ResultSet -> ArrayList<Notice> // 모델(모델값)
		ArrayList<Notice> noticeList = new ArrayList<Notice>();
		while(rs.next()) {
			Notice n = new Notice();
			n.noticeNo = rs.getInt("noticeNo");
			n.noticeTitle = rs.getString("noticeTitle");
			n.noticeContent = rs.getString("noticeContent");
			n.noticeWriter = rs.getString("noticeWriter");
			n.createdate = rs.getString("createdate");
			n.updatedate = rs.getString("updatedate");
			noticeList.add(n);
		}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>noticeOne</title>
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
		
		<h1 class="text-bg-info">
			<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" class="bi bi-calendar" viewBox="0 0 16 16">
			  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
			</svg>&nbsp;공지 상세
		</h1>
		<%
			for(Notice n : noticeList) {
		%>
		<table class="table table-striped">
			<tr>
				<td>공지번호</td>
				<td><%=n.noticeNo%></td>
			</tr>
			<tr>
				<td>공지제목</td>
				<td><%=n.noticeTitle%></td>
			</tr>
			<tr>
				<td>공지내용</td>
				<td><%=n.noticeContent%></td>
			</tr>
			<tr>
				<td>작성자</td>
				<td><%=n.noticeWriter%></td>
			</tr>
			<tr>
				<td>생성날짜</td>
				<td><%=n.createdate%></td>
			</tr>
			<tr>
				<td>수정날짜</td>
				<td><%=n.updatedate%></td>
			</tr>
		</table>
		<% 
			}
		%>
		<div class="text-center">
			<!-- 수정 및 삭제 버튼-->	
			<a href="./updateNoticeForm.jsp?noticeNo=<%=noticeNo%>" class="btn btn-warning">수정</a>
			<a href="./deleteNoticeForm.jsp?noticeNo=<%=noticeNo%>" class="btn btn-danger">삭제</a>
		</div>
	</div>
</body>
</html>