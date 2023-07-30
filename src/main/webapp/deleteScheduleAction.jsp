<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- java.sql.에 포함된 모든 클래스 임폴트 -->
<%@ page import="java.sql.*" %>
<%	
	//인코딩 설정
	request.setCharacterEncoding("utf-8");

	// 넘버와 패스워드의 값이 null 또는 ""일 경우 scheduleList.jsp로 서버에서 클라이언트로 요청을 보낸다.(response)요청 후 코드종료
	if(request.getParameter("scheduleNo") == null
			|| request.getParameter("schedulePw") == null
			|| request.getParameter("scheduleNo").equals("")
			|| request.getParameter("schedulePw").equals("")) {
		response.sendRedirect("./scheduleList.jsp");
		return; 
	}
	
	// 입력받을 변수를 각각 정수형, 문자열로 받음
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String schedulePw = request.getParameter("schedulePw");
	// 출력값 확인
	System.out.println(scheduleNo + "<-- deleteScheduleAction param scheduleNo");
	System.out.println(schedulePw + "<-- deleteScheduleAction param schedulePw");
	
	// DB접속
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://52.78.47.161:3306/diary", "root", "java1234");
	// DB접속 디버깅
	System.out.println("deleteScheduleAction.jsp 접속성공");
	
	// 번호와 비밀번호가 일치하면 삭제하는 sql문
	String sql = "DELETE FROM schedule WHERE schedule_no=? AND schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 값 1, 2 번째에 넣을 값
	stmt.setInt(1, scheduleNo);
	stmt.setString(2, schedulePw);
	// ?에 들어가는 값을 확인한다.
	System.out.println(stmt+"<-- deleteScheduleAction sql");
	
	// insert, update, delete 문을 실행하고 영향을 받은 열의 갯수
	int row = stmt.executeUpdate();
	// row값이 정상적으로 출력되는지 확인한다.
	System.out.println(row + "<-- deleteScheduleAction param row");
	// 제대로 실행이 되지 않음
	if(row == 0) { 
		// 비밀번호가 틀렸을 경우 deleteScheduleForm.jsp로 Redirect 하기.
		response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo="+ scheduleNo);
		System.out.println("일정삭제실패");
	} else if(row == 1) {
		// 삭제행이 있다면 scheduleList페이지로 서버가 클라이언트에게 response하기
		response.sendRedirect("./scheduleList.jsp");
		System.out.println("일정삭제성공");
	} else {
		System.out.println(row + "row값수");
	}
%>