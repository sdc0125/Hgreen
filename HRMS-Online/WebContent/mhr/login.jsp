<%@page import="h5.common.auth.AuthChecker"%>
<%@page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@page import="h5.sys.util.Logger"%>
<%@page import="h5.sys.util.DBUtil,	
						java.util.*,				
						java.math.BigDecimal,
						java.sql.Connection,
						java.sql.PreparedStatement,
						java.sql.ResultSet,
						org.json.simple.JSONArray,
						h5.common.*,
						java.sql.ResultSetMetaData,
						java.sql.SQLException,
						h5.security.SeedCipher,
						javax.servlet.ServletException,
						javax.servlet.http.HttpServlet,
						javax.servlet.http.HttpServletRequest,
						javax.servlet.http.HttpServletResponse,
						h5.security.SeedCipher,
						h5.sys.util.LanguageUtil,
						h5.sys.registry.*"
				contentType="text/html; charset=UTF-8"
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	AuthChecker ac = new AuthChecker();
	boolean isSessionAlive = ac.checkSessionEmpId(request, response);
	Logger.log("isSessionAlive : " + isSessionAlive);
	
	if(isSessionAlive) response.sendRedirect("/mhr/main/main.jsp");

/* 	String userAgent = request.getHeader("user-agent").toUpperCase();
	Logger.log("userAgent : " + userAgent);
	
	boolean isMobile = false;
	boolean isDesktop = false;
	
	String desktopfilter = "WIN16|WIN32|WIN64|MACINTEL";
	String[] desktopFilters = desktopfilter.split("\\|");
	
	String mobileFilter = "IPOD|IPAD|IPHONE|ANDROID|MOBI";
	String[] mobileFilters = mobileFilter.split("\\|");
	
	// 데스크 탑 여부 체크
	for(String tmp : desktopFilters){
		// 데스크탑 OS 가 있고 MOBILE 이 아닌 경우
		if(userAgent.indexOf(tmp) != -1 && userAgent.indexOf("MOBI") == -1){
			isDesktop = true;
		}
	}
	
	// 모바일 여부 체크
	for(String tmp : mobileFilters){
		if(userAgent.indexOf(tmp) != -1){
			isMobile = true;
		}
	}
	
	Logger.log("isDesktop : " + isDesktop + " | isMobile : " + isMobile);
	
	if(!isMobile){
		out.write("<script>alert('모바일로 접근해주세요'); location = '/error.jsp';</script>");
		out.flush();
	} */
	
	String chid = session.getId();
	
	// 2023.01.26 motp 사용 여부 
	RegistryItem registryItem = SystemRegistry.getRegistryItem("GLOBAL_ATTR/MODULES/LOGIN");
	String motp_yn = "";

	if (registryItem != null) {
		motp_yn = registryItem.findItem("MOTP_YN").getValue();
	}
	request.setAttribute("motp_yn",motp_yn);

%>

<!DOCTYPE html>
<html lang="ko">

<head>
	<meta charset="utf-8">
	<meta name="format-detection" content="telephone=no" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<link rel="stylesheet" href="/mhr/common/css/reset.css" />
	<link rel="stylesheet" href="/mhr/common/css/layout.css" />
	<link rel="stylesheet" href="/mhr/common/css/contents.css" />
	<script src="/mhr/common/js/jquery-1.12.4.min.js"></script>
	<script src="/mhr/common/js/ui.js"></script>
	<script src="/common/js/aes.js"></script>
	<script src="/common/js/sha256.js"></script>
	<title>인사지원시스템 | HRMS</title>
	
	<script>
	var jwtVal = false;
	var deviceVal = false;
	var UA = navigator.userAgent.toLowerCase();
	var motp_yn = "${motp_yn}";
	
	window.onpageshow = function(event){
		if(event.persisted || (window.performance && window.performance.navigation.type == 2)){
			location.reload();
		}
    } 
	
	$(document).ready(function(){
		$('#company_cd').val("01").prop("selected", true);
		$('#locale_cd').val("KO").prop("selected", true);
		loadPage();
	});
	
	function loadPage(){
		if (motp_yn == 'N')
			$("#login_02").attr("disabled",true);
		else
			$("#login_02").attr("disabled",false);
	}
	
	function login() {
		var inputId = $('#login_01').val();
		var inputPass = CryptoJS.AES.encrypt($('#login_03').val().replace(/\s/gi, ""), "<%=chid%>");
		var motp = $('#login_02').val();
		
		
		
        if( inputId.length <= 0 )
        {
            alert('아이디를 입력하세요');
            $('#login_01').focus();
            return false;
        }
        
        if( motp.length <= 0 && motp_yn != 'N')
        {
            alert('M-OTP를 입력하세요');
            $('#login_02').focus();
            return false;
        }

        if( inputPass.length <= 0 )
        {
            alert('비밀번호를 입력하세요');
            $('#login_03').focus();
            return false;
        }
		
		$(form1.loginId).val(inputId);
		$(form1.password).val(inputPass);
		$(form1.motp).val(motp);
		
		form1.submit();
	}
	
	
</script>
<style>
	.header_zone.type3{
		display: flex;
    	justify-content: flex-start;
	}
	
	.header_logo_g {
   		position: relative;
   		left: 0;
	}
	.field_form_cell{
		border: 0 !important;
	}
	input[type="text"], input[type="password"]{
		border-radius: 6.666666667px;
		font-size: 16px;
		line-height: 26.666666667px;
		padding: 6.666666667px;
		width: 133.333333333%;
		
		transform: scale(0.75);
		transform-origin: left top;
		height : 41px;
		margin-bottom: -10px;
		margin-right: -33.333333333%;
	}
	
	.field_form_cell.define_th{
		vertical-align: middle;
 	    height: 31px;
	}
	
	
</style>
</head>


<body class="front_body">
	<div class="page_wrap field_container_wrap">
		<%-- header --%>
		<header class="header_zone type3"> 
			<div class="header_logo_g" style="padding-left: 1rem; padding-right: 0.5rem;">
				<a href="#" class="header_plogo logo_kt"><img style="width: 6rem;" src="/mhr/common/images/toplogo_moffice.png" alt="M-Office"></a>
			</div>
			<%-- <div class="header_logo_g" style="padding-left: 1rem; padding-right: 0.5rem;">
				<a href="#" class="header_plogo logo_kt"><img src="/mhr/common/images/kt_toplogo.png" alt="KT"></a>
			</div>
			<div class="header_logo_g" style="padding-left: 0.5rem; padding-right: 1rem;">
				<a href="#" class="header_plogo logo_bc"><img src="/mhr/common/images/bc_toplogo.png" alt="BC"></a>
<%-- 			</div> --%> 
			<%-- // mobile_menu --%>
		</header>
		<%-- // header --%>

		<%-- middle --%>
		<section class="middle_zone field_container">
			<div class="field_content_box">
				<div class="field_copy_group">
					<h2 class="field_copy_main">
						<span class="fcopy_main_sig"><img style="width: 6rem;" src="/mhr/common/images/copy_moffice.png" alt="M-Office"></span>
					</h2>
				</div>
				<div class="field_form_group">
					<div class="field_form_tb">
						<div class="field_form_tr">
							<div class="field_form_cell define_th"><label for="login_01" class="field_form_label">사원번호</label></div>
							<div class="field_form_cell define_td">
								<input type="text" class="field_form_input" placeholder="사원번호" id="login_01">
							</div>
						</div>
						<div class="field_form_tr nbsp_tr">
							<div class="field_form_cell"></div>
						</div>
						<div class="field_form_tr">
							<div class="field_form_cell define_th"><label for="login_03" class="field_form_label">비밀번호</label></div>
							<div class="field_form_cell define_td">
								<input type="password" class="field_form_input"  placeholder="비밀번호" id="login_03">
							</div>
						</div>
						<div class="field_form_tr nbsp_tr">
							<div class="field_form_cell"></div>
						</div>
						<div class="field_form_tr">
							<div class="field_form_cell define_th"><label for="login_02" class="field_form_label">M-OTP</label></div>
							<div class="field_form_cell define_td">
								<input type="password" class="field_form_input " placeholder="M-OTP" id="login_02">
							</div>
						</div>
					</div>
					<%-- <div class="field_else_row">
                        <div class="rdchkitem small">
                            <input type="checkbox" class="rdchk" name="choice" id="idsave">
                            <label for="idsave" class="rdchk_lab">아이디 저장</label>
                        </div>
                    </div> --%>
					<div class="btn_field_submit_row">
						<a href="javascript:login();" class="btn_field_submit">로그인</a>
					</div>
				</div>
			</div>
		</section>
		<%-- // middle --%>
		<form name="form1" action="/mhr/login_ok.jsp" method="post" target="_self">
			<input type="hidden" name="locale_cd" value="KO" ></input>
		    <input type="hidden" name="pageType" value="back_door" ></input>
		    <input type="hidden"  id="deviceKey" name="deviceKey" value="" ></input>	
		    <input type="hidden"  id="motp" name="motp" value="" ></input>	
		    <input type="hidden"  id="loginId" name="loginId" value="" ></input>	
		    <input type="hidden"  id="password" name="password" value="win!@3456" ></input>	
		    <input type="hidden"  id="company_cd" name="company_cd" value="01" ></input>	
		    <%-- <input type="hidden"  id="jwtToken" name="jwtToken" value="" ></input>	 --%>
		</form>
	</div>
</body>

</html>