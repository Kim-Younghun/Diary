<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 글을 작성한 후 리스트로 가도록 요청하는 페이지(response) -> redirection -->
<!-- 보여줄 내용이 없는 페이지 -> View -->
<%@ page import="java.sql.*" %>
<% 
		// post방식 인코딩 처리, 대/소문자 가능 
		request.setCharacterEncoding("utf-8");

		// 유효성 검사 2번 (클라이언트+백엔드) -> 매개 변수로 받은 내용을 올바른 값인지 확인한 후 불만족하면 다시 되돌려보낸다.
		// validation(요청 파라미터값 유효성 검사)
		if(request.getParameter("noticeTitle")== null 
				|| request.getParameter("noticeContent")== null 
				|| request.getParameter("noticeWriter")== null 
				|| request.getParameter("noticePw")== null 
				|| request.getParameter("noticeTitle").equals(" ")
				|| request.getParameter("noticeContent").equals(" ")
				|| request.getParameter("noticeWriter").equals(" ")
				|| request.getParameter("noticePw").equals(" ")) {
			
			// 클라이언트에게는 가라고 지시하지만 서버는 계속 코드를 진행한다. 끝내고 싶다면 return 문 사용
			response.sendRedirect("./insertNoticeForm.jsp");
			return;
		}
		
		// 문자열 변수로 받기
		String noticeTitle = request.getParameter("noticeTitle");
		String noticeContent = request.getParameter("noticeContent");
		String noticeWriter = request.getParameter("noticeWriter");
		String noticePw = request.getParameter("noticePw");
		
		// 값들을 DB 테이블 입력, ?는 값에만 사용이 가능(테이블 명 사용 불가)
		/* 
			insert into notice(
					notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate
			) values(?,?,?,?,now(),now())
		*/
		//스태틱 메서드, 드라이브 로딩, 메모리에 올린다, 변수에 저장할 필요없음.
		Class.forName("org.mariadb.jdbc.Driver");
		// 마리아db 접속을 유지해야 함 
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
		// executeUpdate 실행시 자동으로 커밋을 ON/OFF 한다.
		conn.setAutoCommit(true);
		// 문자열로 sql문을 받아서 sql로 적용
		String sql = "INSERT INTO notice(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate) VALUES(?,?,?,?,now(),now())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		// ? 4개(1~4)
		stmt.setString(1, noticeTitle);
		stmt.setString(2, noticeContent);
		stmt.setString(3, noticeWriter);
		stmt.setString(4, noticePw);
		// SQL문을 실행해서 데이터베이스에 영향을 미친 행의 수를 반환 -> 데이터베이스 처리 결과를 확인 가능함.
		int row = stmt.executeUpdate();
		// row 값을 출력해본다.
		System.out.println(row + "<--  insertNoticeAction param row 확인");
		
		if(row == 1) {
			// 리스트로 리디렉션
			response.sendRedirect("./noticeList.jsp");
			System.out.println("입력 성공");
		} else if(row == 0) {
			System.out.println("입력 실패");
		} else {
			// 개발자가 해결해야 할 문제
			System.out.println(row + "row행 개수");
		}
		// 최종적으로 반영한다.(commit전에는 메모리에만 저장되어 있음), conn.setAutoCommit(true); 생략가능
		// conn.commit();
%>