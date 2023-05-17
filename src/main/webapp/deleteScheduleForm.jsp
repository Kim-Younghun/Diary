<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 요청값 유효성 검사후 해당되면 리디렉션 후 코드종료
	if(request.getParameter("scheduleNo") == null) {
		response.sendRedirect("./scheduleList.jsp");
		return; 
	}

	// Integer.parseInt 메서드를 사용해서 정수형(int)로 저장
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	// 값 확인
	System.out.println(scheduleNo + "deleteScheduleForm param scheduleNo");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteScheduleForm</title>
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
			<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" class="bi bi-book" viewBox="0 0 16 16">
			  <path d="M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811V2.828zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492V2.687zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783z"/>
			</svg>&nbsp;일정삭제
		</h1>
		<form action="./deleteScheduleAction.jsp" method="post">
			<table class="table table-striped">
				<tr>
					<td>번호</td>
					<!-- 수정 불가 readonly 속성을 사용 -->
					<td><input type="text" name="scheduleNo" value="<%=scheduleNo%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<!-- 비밀번호 타입으로 받음(입력된 숫자가 보이지 않음) -->
						<input type="password" name="schedulePw">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<button type="submit" class="btn btn-danger">삭제</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>