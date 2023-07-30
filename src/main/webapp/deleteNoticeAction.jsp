<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- java.sql.에 포함된 모든 클래스 임폴트 -->
<%@ page import="java.sql.*" %>
<%	

	// 넘버와 패스워드의 값이 null 또는 ""일 경우 noticeList.jsp로 서버에서 클라이언트로 요청을 보낸다.(response)요청 후 코드종료
	if(request.getParameter("noticeNo") == null
			|| request.getParameter("noticePw") == null
			|| request.getParameter("noticeNo").equals("")
			|| request.getParameter("noticePw").equals("")) {
		response.sendRedirect("./noticeList.jsp");
		return; 
	}
	
	// 해당 변수의 값을 메서드를 사용해서 정수형, 문자열로 변수에 받음
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	// 해당 변수에 들어간 값을 확인한다.
	System.out.println("여기부터 deleteNoticeAction 디버깅 코드" +noticeNo + "<-- deleteNoticeAction param noticeNo");
	System.out.println(noticePw + "<-- deleteNoticeAction param noticePw");
	
	//스태틱 메서드
	Class.forName("org.mariadb.jdbc.Driver");
	// 마리아db 접속을 유지해야 함.
	Connection conn = DriverManager.getConnection("jdbc:mariadb://52.78.47.161:3306/diary", "root", "java1234");
	// 번호와 비밀번호가 일치하는 경우에 삭제하는 sql
	String sql = "DELETE FROM notice WHERE notice_no=? AND notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 값 1, 2 번째에 값을 넣는다.
	stmt.setInt(1, noticeNo);
	stmt.setString(2, noticePw);
	// ?에 들어가는 값을 확인한다.
	System.out.println(stmt+"<-- deleteNoticeAction param sql");
	
	// insert, update, delete 문을 실행하고 영향을 받은 열의 갯수
	int row = stmt.executeUpdate();
	// row값이 정상적으로 출력되는지 확인한다.
	System.out.println(row + "<-- deleteNoticeAction param row");
	// insert, update, delete 문 적용이 안된경우
	if(row == 0) { 
		// 비밀번호가 틀렸을 경우 deleteNoticeForm.jsp로 Redirect 하기.
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo="+ noticeNo);
		System.out.println("공지삭제실패");
	} else {
		// 삭제행이 있다면 리스트로 가라고 서버가 클라이언트에게 response하기
		response.sendRedirect("./noticeList.jsp");
		System.out.println("공지삭제성공");
	}
%>