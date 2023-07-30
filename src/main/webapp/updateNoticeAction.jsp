<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// 1. 인코딩 설정
	request.setCharacterEncoding("utf-8");
	
	// 2. updateNoticeForm으로부터 넘어온 값 확인(디버깅)
	System.out.println(request.getParameter("noticeNo")+"<-- updateNoticeForm에서 받은 param noticeNo확인");
	System.out.println(request.getParameter("noticeTitle")+"<-- updateNoticeForm에서 받은 param noticeTitle확인");
	System.out.println(request.getParameter("noticePw")+"<-- updateNoticeForm에서 받은 noticePw확인");
	System.out.println(request.getParameter("noticeContent")+"<-- updateNoticeForm에서 받은 param noticeContent확인");
	
	// 3. 2번 유효성검정 -> 잘못된 결과 -> 분기 -> 코드종료(return)
	//유효성 코드 noticeNo값이 null 또는 공백일경우 ./noticeList.jsp로 리다이렉션 후 코드종료
	if(request.getParameter("noticeNo") == null
		|| request.getParameter("noticeNo").equals("")) {
		response.sendRedirect("./noticeList.jsp");
		return;
	} 
	// 분기에 따른 메세지값 설정
	String msg = null;
	if(request.getParameter("noticeTitle") == null
		|| request.getParameter("noticeTitle").equals("")) {
		msg = "noticeTitle is required";
	} else if (request.getParameter("noticePw") == null
		|| request.getParameter("noticePw").equals("")) {
		msg = "noticePw is required";
	} else if (request.getParameter("noticeContent") == null
		|| request.getParameter("noticeContent").equals("")) {
		msg = "noticeContent is required";
	}
	// 위 if-else if 문에 하나라도 해당된다.
	// updateNoticeForm으로 noticeNo와 msg를 리다이렉션
	// return문 빠지면 java.lang.IllegalStateException: 응답이 이미 커밋된 후에는, sendRedirect()를 호출할 수 없습니다. 에러발생(title, content, password 비어있는 경우)
	if(msg != null) {
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo=" + request.getParameter("noticeNo") + "&msg="+msg);
		return;
	}
	
	// 4. 요청값들을 변수에 할당(형변환)
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticeTitle = request.getParameter("noticeTitle");
	String noticePw = request.getParameter("noticePw");
	String noticeContent = request.getParameter("noticeContent");
	
	// 변수확인
	System.out.println(noticeNo + "<-- updateNoticeAction param noticeNo확인");
	System.out.println(noticeTitle + "<-- updateNoticeAction param noticeTitle확인");
	System.out.println(noticePw + "<-- updateNoticeAction param noticePw확인");
	System.out.println(noticeContent + "<-- updateNoticeAction param noticeContent확인");
	
	//5. mariadb에 RDBMS에 update문을 전송한다.
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://52.78.47.161:3306/diary", "root", "java1234");
	String sql = "update notice set notice_title=?, notice_content=?, updatedate=now() where notice_no=? and notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ?에 입력될 값 적용
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setInt(3, noticeNo);
	stmt.setString(4, noticePw);
	// stmt값 확인
	System.out.println(stmt + "<-- stmt");
	
	// 적용된 행의 수
	int row = stmt.executeUpdate();
	
	// 6. 5번 결과에 페이지(View)를 분기한다.
	// 비밀번호가 맞지 않은 경우
	if(row == 0) {
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="
			+request.getParameter("noticeNo")
			+"&msg=incorrect noticePw");
		System.out.println("공지수정실패");
	} else if(row == 1) { // 정상적으로 수정이 실행된 경우 공지상세페이지로 리디렉션
		response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo);
		System.out.println("공지수정성공");
	} else {
		System.out.println("error row값"+ row);
	}
%>    
