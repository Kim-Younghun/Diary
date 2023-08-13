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

<!doctype html>
<html>
<head>
	<meta charset="utf-8" />
	<link rel="apple-touch-icon" sizes="76x76" href="./resources/assets/img/apple-icon.png">
	<link rel="icon" type="image/png" sizes="96x96" href="./resources/assets/img/favicon.png">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />

	<title>deleteNoticeForm</title>

	<meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0' name='viewport' />
    <meta name="viewport" content="width=device-width" />


    <!-- Bootstrap core CSS     -->
    <link href="./resources/assets/css/bootstrap.min.css" rel="stylesheet" />

    <!-- Animation library for notifications   -->
    <link href="./resources/assets/css/animate.min.css" rel="stylesheet"/>

    <!--  Paper Dashboard core CSS    -->
    <link href="./resources/assets/css/paper-dashboard.css" rel="stylesheet"/>


    <!--  CSS for Demo Purpose, don't include it in your project     -->
    <link href="./resources/assets/css/demo.css" rel="stylesheet" />


    <!--  Fonts and icons     -->
    <link href="http://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css" rel="stylesheet">
    <link href='https://fonts.googleapis.com/css?family=Muli:400,300' rel='stylesheet' type='text/css'>
    <link href="./resources/assets/css/themify-icons.css" rel="stylesheet">

</head>
<body>


<div class="wrapper">
    <div class="sidebar" data-background-color="white" data-active-color="danger">

    <!--
		Tip 1: you can change the color of the sidebar's background using: data-background-color="white | black"
		Tip 2: you can change the color of the active button using the data-active-color="primary | info | success | warning | danger"
	-->

    	<div class="sidebar-wrapper">
            <div class="logo">
                <a href="https://github.com/Kim-Younghun/Diary" class="simple-text">
                    Dairy Project
                </a>
            </div>

            <ul class="nav">
                <li>
                    <a href="./home.jsp">
                        <i class="ti-home"></i>
                        <p>home</p>
                    </a>
                </li>
                <li>
                    <a href="./noticeList.jsp">
                        <i class="ti-bell"></i>
                        <p>noticeList</p>
                    </a>
                </li>
                <li>
                    <a href="./scheduleList.jsp">
                        <i class="ti-view-list-alt"></i>
                        <p>scheduleList</p>
                    </a>
                </li>
            </ul>
    	</div>
    </div>

    <div class="main-panel">
        <nav class="navbar navbar-default">
            <div class="container-fluid">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar bar1"></span>
                        <span class="icon-bar bar2"></span>
                        <span class="icon-bar bar3"></span>
                    </button>
                   	<table class="table">
                   		<tr>
							<td>
								개발 환경 및 라이브러리
							</td>
						</tr>
						<tr>
							<td>
								JDK 17(Calendar API 사용), HTML, CSS, HeidiSQL, Maria DB(10.5), Eclipse(22-12), Bootstrap5, JSP, JDBC
							</td>
						</tr>
						<tr>
							<td>
							[구현기능] <br> 1. 공지사항 및 스케쥴 UPDATE, DELETE, INSERT 기능 <br> 2. 달력에 일정내용 출력 <br> 3. 공지사항 목록 페이징 기능 
							</td>
						</tr>
                   	</table>
                </div>
            </div>
        </nav>

        <div class="content">
            <div class="container-fluid">
                <div class="row">
					<div class="col-md-8 col-md-offset-2">
                        <div class="card">
                            <div class="header text-center">
                                <h3 class="title">공지삭제</h3>
								<br>
                            </div>
                            <div class="content table-responsive table-full-width table-upgrade">
                            	<form action="./deleteNoticeAction.jsp" method="post">
	                                <table class="table">
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
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <footer class="footer">
            <div class="container-fluid">
                <div class="copyright pull-right">
                    &copy; <script>document.write(new Date().getFullYear())</script>, made with <i class="fa fa-heart heart"></i> by Creative Tim
                </div>
            </div>
        </footer>

    </div>
</div>


</body>

    <!--   Core JS Files   -->
    <script src="./resources/assets/js/jquery-1.10.2.js" type="text/javascript"></script>
	<script src="./resources/assets/js/bootstrap.min.js" type="text/javascript"></script>

	<!--  Checkbox, Radio & Switch Plugins -->
	<script src="./resources/assets/js/bootstrap-checkbox-radio.js"></script>

	<!--  Charts Plugin -->
	<script src="./resources/assets/js/chartist.min.js"></script>

    <!--  Notifications Plugin    -->
    <script src="./resources/assets/js/bootstrap-notify.js"></script>

    <!--  Google Maps Plugin    -->
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js"></script>

    <!-- Paper Dashboard Core javascript and methods for Demo purpose -->
	<script src="./resources/assets/js/paper-dashboard.js"></script>

	<!-- Paper Dashboard DEMO methods, don't include it in your project! -->
	<script src="./resources/assets/js/demo.js"></script>
</html>