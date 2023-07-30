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
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>noticeList</title>
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
			</svg>&nbsp;공지사항리스트
		</h1>
		<a href="./insertNoticeForm.jsp"></a>
		<table class="table table-striped">
			<tr>
				<th>공지사항제목</th>
				<th>생성날짜</th>
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
</body>
</html>