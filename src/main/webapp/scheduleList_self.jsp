<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
	// 년월일 변수 선언
	int targetYear = 0;
	int targetMonth = 0;
	int targetDate = 0;
	
	// 년 or 월이 null일경우 오늘 년, 월을 넣는다.
	// -1, 12 의 값이 Month값이 들어가도 Calendar가 내부적으로 전년, 다음년으로 처리된다.
	if(request.getParameter("targetYear") == null 
		|| request.getParameter("targetMonth") == null) {
		Calendar c = Calendar.getInstance();
		targetYear = c.get(Calendar.YEAR);
		targetMonth = c.get(Calendar.MONTH);
	} else { // 정수형으로 값 넣기	
		targetYear = Integer.parseInt(request.getParameter("targetYear"));
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
	// 변수값 제대로 입력됬는지 확인
	System.out.println(targetYear +"<--- scheduleList param targetYear");
	System.out.println(targetMonth +"<--- scheduleList param targetMonth");
	
	// 오늘 날짜
	Calendar today = Calendar.getInstance();
	targetDate = today.get(Calendar.DATE);
	
	
	// targetMonth 1일 요일 확인
	Calendar firstDay = Calendar.getInstance();
	firstDay.set(Calendar.YEAR, targetYear);
	firstDay.set(Calendar.MONTH, targetMonth);
	firstDay.set(Calendar.DATE, 1); // 2023 4 1
	
	// targetMonth에 -1, 12의 값이 들어갈 경우 내부에서 처리했으므로 다시 내부의 값을 저장한다.
	// ex) 년23월12 입력 Calendar API 년24월1로 변경함.
	// ex) 년23월-1 입력 Calendar API 년22월12로 변경함.
	targetYear = firstDay.get(Calendar.YEAR);
	targetMonth = firstDay.get(Calendar.MONTH);
	
	// 2023 4 1이 몇 요일인지(일-1, 토-7)
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK); 
	// 1일 앞의 빈 공백 수 (요일수 -1로 공백수를 구한다.)
	int startTdBlank = firstYoil-1;
	
	// startTdBlank 확인
	System.out.println(startTdBlank +"<--- scheduleList param startTdBlank");

	 // targetMonth 마지막일, firstDay의 날짜에 해당하는 달의 최대일
	 int lastDate = firstDay.getActualMaximum(Calendar.DATE);
	 
	// lastDate 확인
	System.out.println(lastDate +"<--- scheduleList param lastDate");
	
	// lastDate 날짜 뒤 공백칸의 개수
	int endTdBlank = 0;
	if((startTdBlank + lastDate) % 7 != 0) {
		endTdBlank = 7-((startTdBlank + lastDate)% 7);
	} 
	
	// 전체 TD이 개수는 앞 빈칸 + 마지막날짜(1~마지막날짜) + 뒤 빈칸
	int totalTd = startTdBlank + lastDate + endTdBlank;
	// 전체 Td 개수확인
	System.out.println(totalTd +"<--- scheduleList param totalTd");
	
	// 이전 달의 마지막 날짜를 저장할 변수
	Calendar preMonth = Calendar.getInstance();
	preMonth.set(Calendar.YEAR, targetYear);
	preMonth.set(Calendar.MONTH, targetMonth-1);
	
	// preMonth의 마지막일
	int preLastDate = preMonth.getActualMaximum(Calendar.DATE);
	// preLastDate 확인
	System.out.println(preLastDate +"<--- scheduleList param preLastDate");
%>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleList</title>
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
	
	<!-- 출력할때는 +1를 더해서 보여질때 Month값이 일치되도록 -->
	<h1 class="text-bg-info"><%=targetYear%>년<%=targetMonth+1%>월</h1>
	<div>
		<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>">이전달</a>
		<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>">다음달</a>
	</div>
	<table class="table table-striped">
		<thead>
			<tr>
				<th>일</th>
				<th>월</th>
				<th>화</th>
				<th>수</th>
				<th>목</th>
				<th>금</th>
				<th>토</th>
			</tr>
		</thead>
		<tr>
			<%
				// for문을 통해서 td를 추가
				for(int i=0; i<totalTd; i++ ) {
					int num = i-startTdBlank+1;
					// 지난달 날짜부터 이번달 달력의 첫째 날짜까지 일자를 출력할 변수
					int preNum = preLastDate-startTdBlank+1;
					// 이번달 마지막 날짜부터 다음달 날짜를 출력하기 위한 변수
					int nextNum = num-lastDate;
					if(i!=0 && i%7==0) { // 분기코드는 td가 찍힌 후에 나와야한다.(i!=0), td 7칸마다 줄바꿈
			%>
					</tr><tr>
			<%
					}
					if(num > 0 && num<=lastDate) {
						// 현재 날짜와 달력에서 출력하고자 하는 날짜가 일치할경우
						if(today.get(Calendar.YEAR) == targetYear
								&& today.get(Calendar.MONTH) == targetMonth
								&& today.get(Calendar.DATE) == num) {
			%>
								<td class="text-warning">
									<!-- style="color: inherit;"으로 링크색 class="text-secondary"와 동일하게 -->
									<a href="" style="color: inherit;">
										<%=num%>
									</a>
								</td>
			<% 				
						} else if(i%7==0) {
			%>
							<td class="text-danger">
								<a href="" style="color: inherit;">
									<%=num%>
								</a>
							</td>
			<% 
							} else {
			%>
							<td>
								<a href="">
									<%=num%>
								</a>
							</td>
			<% 
							}
					} else if(num <=0) {
			%>
						<td class="text-secondary">
							<a href="" style="color: inherit;">
								<%=preNum + i%>
							</a>
						</td>
			<% 
						} else {
			%>
						<td class="text-secondary">
							<a href="" style="color: inherit;">
								<%=nextNum%>
							</a>
						</td>
			<% 
						}
				}
			%>
		</tr>
	</table>
	</div>
</body>
</html>