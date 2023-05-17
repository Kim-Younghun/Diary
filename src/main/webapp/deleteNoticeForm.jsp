<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 요청값 유효성 검사 후 해당되면 리디렉션 후 코드종료
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp");
		return; 
	}

	// HTTP 요청 (request)에서 해당 이름의 파라미터를 가져와서 문자열 형태로 저장한 후
	// Integer.parseInt 메서드를 사용해서 정수형(int)로 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	// deleteNoticeForm param noticeNo에 대한 디버깅 코드
	System.out.println(noticeNo + "deleteNoticeForm param noticeNo");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteNoticeForm</title>
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
			</svg>&nbsp;공지 삭제
		</h1>
		<form action="./deleteNoticeAction.jsp" method="post">
			<table class="table table-striped">
				<tr>
					<td>번호</td>
					<%-- hidden 타입으로 수정 불가로 만들수도 있음.
					<td><input type="hidden" name="noticeNo" value="<%=noticeNo%>"></td>
					--%>
					<!-- 수정 불가 readonly 속성을 사용 -->
					<td><input type="text" name="noticeNo" value="<%=noticeNo%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<!-- 비밀번호 타입으로 받음(입력된 숫자가 보이지 않음) -->
						<input type="password" name="noticePw">
					</td>
				</tr>
				<tr>
					<!-- 삭제버튼 가운데로 -->
					<td colspan="2">
						<button type="submit" class="btn btn-danger">삭제</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>