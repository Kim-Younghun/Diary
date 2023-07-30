<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// 1. 인코딩 설정
	request.setCharacterEncoding("utf-8");
	
	// 2. updateScheduleForm으로부터 넘어온 값 확인(디버깅)
	System.out.println(request.getParameter("scheduleNo")+"<-- updateScheduleForm에서 받은 param scheduleNo");
	System.out.println(request.getParameter("scheduleDate")+"<-- updateScheduleForm에서 받은 param scheduleDate");
	System.out.println(request.getParameter("schedulePw")+"<-- updateScheduleForm에서 받은 param schedulePw");
	System.out.println(request.getParameter("scheduleColor")+"<-- updateScheduleForm에서 받은 param scheduleColor");
	System.out.println(request.getParameter("scheduleTime")+"<-- updateScheduleForm에서 받은 scheduleTime");
	System.out.println(request.getParameter("scheduleMemo")+"<-- updateScheduleForm에서 받은 param scheduleMemo");
	
	// 3. 2번 유효성검정 -> 잘못된 결과 -> 분기 -> 코드종료(return)
	//유효성 코드 해당값이 null 또는 공백일경우 ./scheduleList.jsp로 리다이렉션 후 코드종료
	if(request.getParameter("scheduleNo") == null
		||	request.getParameter("scheduleDate") == null 
		||	request.getParameter("scheduleColor") == null
		||	request.getParameter("scheduleTime") == null
		|| request.getParameter("scheduleNo").equals("")
		|| request.getParameter("scheduleDate").equals("") 
		|| request.getParameter("scheduleColor").equals("")
		|| request.getParameter("scheduleTime").equals("")) {
		
		response.sendRedirect("./scheduleList.jsp");
		System.out.println("updateScheduleAction 에러 발생");
		return;
	} 
	
	// 각 분기에 맞게 출력문 저장
	String msg = null;
	if(request.getParameter("schedulePw") == null
		|| request.getParameter("schedulePw").equals("")) {
		msg = "schedulePw is required";
	} else if (request.getParameter("scheduleMemo") == null
		|| request.getParameter("scheduleMemo").equals("")) {
		msg = "scheduleMemo is required";
	} 
	
	// 4. 요청값들을 변수에 할당(형변환)
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String scheduleDate = request.getParameter("scheduleDate");
	String schedulePw = request.getParameter("schedulePw");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleMemo = request.getParameter("scheduleMemo");
	
	// yyyy(년)-mm(월)-dd(일) 형식으로 사용하기 위해
	String y = null;
	int m = 0;
	String d = null;
	if(scheduleDate != "") {
		y = scheduleDate.substring(0,4);
		m = Integer.parseInt(scheduleDate.substring(5,7))-1 ;
		d = scheduleDate.substring(8);
	}
	System.out.println(y+"updateScheduleAction param y");
	System.out.println(m+"updateScheduleAction param m");
	System.out.println(d+"updateScheduleAction param d");
	
	
	// 메세지가 있을경우 폼페이지로 이동 및 전달값 보냄
	if(msg != null) {
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo=" + request.getParameter("scheduleNo") + "&msg="+msg);
		return;
	}
	
	// 변수확인
	System.out.println(scheduleNo + "<-- updateScheduleAction param scheduleNo");
	System.out.println(schedulePw + "<-- updateScheduleAction param schedulePw");
	System.out.println(scheduleDate + "<-- updateScheduleAction param scheduleDate");
	System.out.println(scheduleColor + "<-- updateScheduleAction param scheduleColor");
	System.out.println(scheduleTime + "<-- updateScheduleAction param scheduleTime");
	System.out.println(scheduleMemo + "<-- updateScheduleAction param scheduleMemo");
	
	
	
	//5. mariadb에 RDBMS에 update문을 전송한다.
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://52.78.47.161:3306/diary", "root", "java1234");
	String sql = "UPDATE schedule SET schedule_date=?, schedule_time=?, schedule_memo=?, schedule_color=?, updatedate=now() WHERE schedule_no=? AND schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ?에 입력될 값 적용
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleMemo);
	stmt.setString(4, scheduleColor);
	stmt.setInt(5, scheduleNo);
	stmt.setString(6, schedulePw);
	// stmt값 확인
	System.out.println(stmt + "<-- stmt");
	
	// 적용된 행의 수
	int row = stmt.executeUpdate();
	
	// 6. 5번 결과에 페이지(View)를 분기한다.
	if(row == 0) { // UPDATE가 되지 않은경우 폼페이지로 이동 및 전달값 보냄
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo="
			+request.getParameter("scheduleNo")
			+"&msg=incorrect schedulePw");
		
	} else if(row == 1) { // 정상적으로 수정이 실행된 경우 해당 상세페이지로
		response.sendRedirect("./scheduleListByDate.jsp?y=" + y + "&m=" + m + "&d=" + d);
	} else {
		System.out.println("error row값"+ row);
	}
%>    
