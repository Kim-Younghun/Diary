<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
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
		// ArrayList<Notice> noticeList를 이용한 반복문
		for(Notice n : noticeList) {
	%>
	<div class="container">
		<a href="./home.jsp">홈으로</a>
		<a href="./noticeList.jsp">공지리스트</a>
		<a href="./scheduleList.jsp">일정리스트</a>
		<h1 class="text-bg-info">
			<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" class="bi bi-calendar" viewBox="0 0 16 16">
			  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
			</svg>&nbsp;수정폼
		</h1>
		<div>
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
		<form action="./updateNoticeAction.jsp" method="post">
			<table class="table table-striped">
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
	</div>
	<%
		}
	%>
</body>
</html>