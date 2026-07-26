<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Smart Farm - Quên mật khẩu</title>
        <style>
            body {
                margin: 0; height: 100vh; display: flex; gap: 35px; flex-direction: column;
                justify-content: center; align-items: center;
                background-image: url('https://media.istockphoto.com/id/863542630/vi/anh/ho%C3%A0ng-h%C3%B4n-m%C3%B9a-h%C3%A8-v%E1%BB%9Bi-chu%E1%BB%93ng-tr%E1%BA%A1i-m%C3%A0u-%C4%91%E1%BB%8F-%E1%BB%9F-v%C3%B9ng-n%C3%B4ng-th%C3%B4n-montana-v%C3%A0-d%C3%A3y-n%C3%BAi-rocky.jpg?s=612x612&w=0&k=20&c=6EaDA4wBhWLYKVK7mhDExYQII8ZD1617vIjQzdr_cTA=');
                background-size: cover; background-position: center; font-family: 'Segoe UI', sans-serif;
            }
            body::before { content: ""; position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(30, 50, 25, 0.4); z-index: -1; }
            .form-div {
                display: flex; flex-direction: column; align-items: center; padding: 40px; width: 400px;
                border-radius: 16px; background-color: rgba(255, 255, 255, 0.85); backdrop-filter: blur(12px);
                border: 1px solid rgba(255, 255, 255, 0.5); box-shadow: 0px 15px 35px rgba(0, 0, 0, 0.2);
            }
            .title-group { display: flex; align-items: center; justify-content: center; gap: 12px; margin-bottom: 25px; }
            @keyframes float { 0% { transform: translateY(0px); } 50% { transform: translateY(-5px); } 100% { transform: translateY(0px); } }
            .title-group svg { width: 38px; height: 38px; filter: drop-shadow(0px 3px 4px rgba(0,0,0,0.15)); animation: float 3s ease-in-out infinite; }
            h1 { margin: 0; font-size: 30px; font-weight: 700; background: linear-gradient(135deg, #2e541f, #467e32); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
            
            form { display: flex; flex-direction: column; align-items: center; width: 100%; }
            .input-group { position: relative; display: flex; align-items: center; margin-bottom: 18px; width: 100%; }
            .icon-left { position: absolute; left: 14px; width: 18px; height: 18px; fill: #3e4d3a; transition: fill 0.2s ease; pointer-events: none; }
            input.txt-input {
                padding: 12px 12px 12px 42px; width: 100%; border: 1.5px solid #a3bfa1; border-radius: 8px; box-sizing: border-box;
                background-color: rgba(255, 255, 255, 0.9); color: #1a2419; font-size: 15px; font-weight: 500; transition: all 0.25s ease;
            }
            input.txt-input:focus { border-color: #467e32; background-color: #ffffff; box-shadow: 0 0 0 4px rgba(70, 126, 50, 0.2); outline: none; }
            input.txt-input:focus ~ .icon-left { fill: #467e32; }

            /* Định dạng 6 ô OTP */
            .otp-group { display: flex; gap: 10px; justify-content: center; margin-bottom: 25px; width: 100%; }
            .otp-group input {
                width: 45px; height: 55px; text-align: center; font-size: 22px; font-weight: 700; border: 2px solid #a3bfa1;
                border-radius: 8px; padding: 0; background-color: rgba(255, 255, 255, 0.9); color: #1a2419; transition: all 0.25s ease;
            }
            .otp-group input:focus { border-color: #467e32; box-shadow: 0 0 0 4px rgba(70, 126, 50, 0.2); outline: none; }

            .btn-dk {
                width: 100%; margin: 10px 0; padding: 13px; background: linear-gradient(135deg, #467e32, #396728); color: #fff;
                border: none; border-radius: 8px; cursor: pointer; font-size: 16px; font-weight: 600; box-shadow: 0 5px 15px rgba(70, 126, 50, 0.3); transition: all 0.2s ease;
            }
            .btn-dk:hover { transform: translateY(-1px); box-shadow: 0 7px 20px rgba(70, 126, 50, 0.4); }
            .link-group { display: flex; justify-content: space-between; width: 100%; gap: 10px; margin-top: 10px; }
            .link-group a { font-size: 14px; color: #2e541f; font-weight: 600; text-decoration: none; transition: color 0.2s ease; }
            .link-group a:hover { text-decoration: underline; color: #467e32; }
            .error-msg { color: #e74c3c; font-size: 14px; font-weight: bold; margin-bottom: 15px; text-align: center; }
            .success-msg { color: #2e7d32; font-size: 14px; font-weight: bold; margin-bottom: 20px; text-align: center; }
        </style>
    </head>

    <body>
        <jsp:include page="/views/common/authtitle.jsp"></jsp:include>
        <div class="form-div">
            <div class="title-group">
                <svg viewBox="0 0 100 100">
                    <defs>
                        <linearGradient id="leafGrad" x1="0%" y1="100%" x2="100%" y2="0%">
                            <stop offset="0%" stop-color="#396728" />
                            <stop offset="100%" stop-color="#579c3f" />
                        </linearGradient>
                    </defs>
                    <path d="M52 90 C55 70 58 55 52 45 C50 42 48 44 50 48 C55 58 52 72 49 90 Z" fill="url(#leafGrad)" />
                    <path d="M50 51 C38 48 26 38 28 30 C30 22 45 32 52 45 C50 47 49 49 50 51 Z" fill="url(#leafGrad)" />
                    <path d="M52 47 C55 30 65 12 71 12 C77 12 68 35 50 51 C50 49 51 48 52 47 Z" fill="url(#leafGrad)" />
                </svg>
                <h1>Quên Mật Khẩu</h1>
            </div>
                
            <c:if test="${not empty errorSystem}"><div class="error-msg">${errorSystem}</div></c:if>

            <form method="Post" action="${pageContext.request.contextPath}/auth">
                <c:choose>
                    <%-- BƯỚC 2: NHẬP OTP VÀ MẬT KHẨU MỚI --%>
                    <c:when test="${step == 2}">
                        <input type="hidden" name="action" value="resetPassword">
                        <div class="success-msg">Mã OTP 6 chữ số đã được gửi đến email của bạn.</div>
                        
                        <!-- Đã bổ sung inputmode và pattern để ép trình duyệt nhận diện ô số -->
                        <div class="otp-group">
                            <input type="text" name="otp1" id="otp1" maxlength="1" inputmode="numeric" pattern="[0-9]*" required autocomplete="off" oninput="moveToNext(this, 'otp2')" onkeydown="moveToPrev(event, this, null)">
                            <input type="text" name="otp2" id="otp2" maxlength="1" inputmode="numeric" pattern="[0-9]*" required autocomplete="off" oninput="moveToNext(this, 'otp3')" onkeydown="moveToPrev(event, this, 'otp1')">
                            <input type="text" name="otp3" id="otp3" maxlength="1" inputmode="numeric" pattern="[0-9]*" required autocomplete="off" oninput="moveToNext(this, 'otp4')" onkeydown="moveToPrev(event, this, 'otp2')">
                            <input type="text" name="otp4" id="otp4" maxlength="1" inputmode="numeric" pattern="[0-9]*" required autocomplete="off" oninput="moveToNext(this, 'otp5')" onkeydown="moveToPrev(event, this, 'otp3')">
                            <input type="text" name="otp5" id="otp5" maxlength="1" inputmode="numeric" pattern="[0-9]*" required autocomplete="off" oninput="moveToNext(this, 'otp6')" onkeydown="moveToPrev(event, this, 'otp4')">
                            <input type="text" name="otp6" id="otp6" maxlength="1" inputmode="numeric" pattern="[0-9]*" required autocomplete="off" oninput="moveToNext(this, null)" onkeydown="moveToPrev(event, this, 'otp5')">
                        </div>
                        
                        <div class="input-group">
                            <!-- Đã bổ sung autocomplete="new-password" để chặn Autofill -->
                            <input type="password" class="txt-input" name="newPassword" placeholder="Nhập mật khẩu mới" required autocomplete="new-password">
                            <svg class="icon-left" viewBox="0 0 24 24"><path d="M12 17c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm6-9h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zM8.9 6c0-1.71 1.39-3.1 3.1-3.1s3.1 1.39 3.1 3.1v2H8.9V6z"/></svg>
                        </div>
                        <button type="submit" class="btn-dk">Xác nhận đổi mật khẩu</button>
                    </c:when>

                    <%-- BƯỚC 1: NHẬP TÀI KHOẢN VÀ EMAIL --%>
                    <c:otherwise>
                        <input type="hidden" name="action" value="forgotPassword">
                        <div class="input-group">
                            <input type="text" class="txt-input" name="TenDangNhap" placeholder="Nhập tên tài khoản" required>
                            <svg class="icon-left" viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                        </div>
                        <div class="input-group">
                            <input type="email" class="txt-input" name="Email" placeholder="Nhập email tài khoản" required>
                            <svg class="icon-left" viewBox="0 0 24 24"><path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg>
                        </div>
                        <button type="submit" class="btn-dk">Gửi mã OTP</button>
                    </c:otherwise>
                </c:choose>

                <div class="link-group">
                    <a href="${pageContext.request.contextPath}/views/auth/register.jsp">Đăng ký mới</a>
                    <a href="${pageContext.request.contextPath}/views/auth/login.jsp">Đăng nhập ngay</a>
                </div>
            </form>
        </div>

        <script>
            // Đã tối ưu lại hàm này để bắt cứng chỉ giữ lại Số, và chỉ nhảy focus khi trong ô thực sự có số
            function moveToNext(current, nextFieldID) {
                current.value = current.value.replace(/[^0-9]/g, ''); 
                if (current.value.length === 1 && nextFieldID !== null) {
                    document.getElementById(nextFieldID).focus();
                }
            }
            function moveToPrev(e, current, prevFieldID) {
                if (e.key === "Backspace" && current.value === '') {
                    if (prevFieldID != null) {
                        document.getElementById(prevFieldID).focus();
                    }
                }
            }
        </script>
    </body>
</html>