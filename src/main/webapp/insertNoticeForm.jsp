<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertNoticeForm</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container"><!-- 메인메뉴 -->
		<a href="./home.jsp">홈으로</a>
		<a href="./noticeList.jsp">공지리스트</a>
		<a href="./diaryList.jsp">일정리스트</a>
	
	<h1 class="text-bg-info">
		<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" class="bi bi-calendar" viewBox="0 0 16 16">
		  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
		</svg>&nbsp;공지 입력
	</h1>
	<!-- 폼 데이터 정보 -->
	<form action="./insertNoticeAction.jsp" method="post">
		<table class="table table-striped">
			<tr>
				<td>일정제목</td>
				<td>
					<input type="text" name="noticeTitle">
				</td>
			</tr>
			<tr>
				<td>일정내용</td>
				<td>
					<textarea rows="5" cols="80" name="noticeContent"></textarea>
				</td>
			</tr>
			<tr>
				<td>작성자</td>
				<td>
					<input type="text" name="noticeWriter">
				</td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td>
					<input type="text" name="noticePw">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<button type="submit" class="btn btn-success">등록</button>
				</td>
			</tr>
		</table>
	</form>
	</div>
</body>
</html>