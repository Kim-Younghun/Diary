<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% 

	// 인코딩 설정
	request.setCharacterEncoding("utf-8");

	// 변수 선언
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	
	// 변수값 확인
	System.out.println(scheduleDate + "insertScheduleAction param scheduleDate");
	System.out.println(scheduleTime + "insertScheduleAction param scheduleTime");
	System.out.println(scheduleColor + "insertScheduleAction param scheduleColor");
	System.out.println(scheduleMemo + "insertScheduleAction param scheduleMemo");
	
	
	String y = scheduleDate.substring(0,4);
	// +1로 값을 받았으므로 자바 API로 변환하려면 다시 -1을 해준다.
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1 ;
	String d = scheduleDate.substring(8);
	
	
	// 년/월/일 확인
	System.out.println(y+ "insertScheduleAction param y");
	System.out.println(m + "insertScheduleAction param m");
	System.out.println(d + "insertScheduleAction param d");
	
	
	// DB 연결 Part
	//스태틱 메서드, 드라이브 로딩, 메모리에 올린다, 변수에 저장할 필요없음.
	Class.forName("org.mariadb.jdbc.Driver");
	// 마리아db 접속을 유지해야 함 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://52.78.47.161:3306/diary", "root", "java1234");
	// 문자열로 sql문을 받아서 sql로 적용
	String sql = "INSERT INTO schedule(schedule_date, schedule_time, schedule_memo, schedule_color, createdate, updatedate) values(?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 에 입력될 값 (4개)
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleMemo);
	stmt.setString(4, scheduleColor);
	
	// stmt값 확인
	System.out.println(stmt + "<--  insertScheduleAction param stmt 확인");
	
	// SQL문을 실행해서 데이터베이스에 영향을 미친 행의 수를 반환 -> 데이터베이스 처리 결과를 확인 가능함.
	int row = stmt.executeUpdate();
	
	// row 값을 출력해본다.
	System.out.println(row + "<--  insertScheduleAction param row 확인");
	
	if(row == 1) {
		// 상세 페이지로 리디렉션(y, m, d 값 같이 보냄)
		response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d); 
		System.out.println("입력 성공");
	} else if(row == 0) {
		System.out.println("입력 실패");
	} else {
		// 개발자가 해결해야 할 문제
		System.out.println(row + "row행 개수");
	}
%>