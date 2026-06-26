<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Farmer - Quên mật khẩu</title>
    <style>
        body {
            margin: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-image: url('https://media.istockphoto.com/id/863542630/vi/anh/ho%C3%A0ng-h%C3%B4n-m%C3%B9a-h%C3%A8-v%E1%BB%9Bi-chu%E1%BB%93ng-tr%E1%BA%A1i-m%C3%A0u-%C4%91%E1%BB%8F-%E1%BB%9F-v%C3%B9ng-n%C3%B4ng-th%C3%B4n-montana-v%C3%A0-d%C3%A3y-n%C3%BAi-rocky.jpg?s=612x612&w=0&k=20&c=6EaDA4wBhWLYKVK7mhDExYQII8ZD1617vIjQzdr_cTA=');
            background-size: cover;
            background-position: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body::before {
            content: "";
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background-color: rgba(30, 50, 25, 0.4);
            z-index: -1;
        }

        .form-div {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 40px; 
            width: 400px;
            border-radius: 16px;
            background-color: rgba(255, 255, 255, 0.85); 
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            box-shadow: 0px 15px 35px rgba(0, 0, 0, 0.2);
        }

        .title-group {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            margin-bottom: 30px;
        }

        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-5px); }
            100% { transform: translateY(0px); }
        }

        .title-group svg {
            width: 38px;
            height: 38px;
            filter: drop-shadow(0px 3px 4px rgba(0,0,0,0.15));
            animation: float 3s ease-in-out infinite;
        }

        h1 {
            margin: 0;
            font-size: 30px;
            font-weight: 700;
            background: linear-gradient(135deg, #2e541f, #467e32);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: 0.5px;
        }
        
        form {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
        }

        table {
            border-collapse: collapse;
            width: 100%;
        }
        
        .input-group {
            position: relative;
            display: flex;
            align-items: center;
            margin-bottom: 18px;
            width: 100%;
        }

        .icon-left {
            position: absolute;
            left: 14px; 
            width: 18px;
            height: 18px;
            fill: #3e4d3a;
            transition: fill 0.2s ease;
            pointer-events: none; 
        }

        input {
            padding: 12px 12px 12px 42px; 
            width: 100%;
            border: 1.5px solid #a3bfa1;
            border-radius: 8px;
            box-sizing: border-box;
            background-color: rgba(255, 255, 255, 0.9);
            color: #1a2419;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.25s ease; 
        }

        input::placeholder {
            color: #5c7357;
            font-weight: 400;
        }

        input:focus {
            border-color: #467e32;
            background-color: #ffffff;
            box-shadow: 0 0 0 4px rgba(70, 126, 50, 0.2);
            outline: none;
        }

        input:focus ~ .icon-left {
            fill: #467e32;
        }

        .btn-dk {
            width: 100%;
            margin: 15px 0;
            padding: 13px; 
            background: linear-gradient(135deg, #467e32, #396728);
            color: #fff;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600; 
            letter-spacing: 0.8px;
            box-shadow: 0 5px 15px rgba(70, 126, 50, 0.3);
            transition: all 0.2s ease;
        }

        .btn-dk:hover {
            transform: translateY(-1px);
            box-shadow: 0 7px 20px rgba(70, 126, 50, 0.4);
        }

        .btn-dk:active {
            transform: translateY(0);
        }

        .link-group {
            display: flex;
            justify-content: space-between;
            width: 100%;
            gap: 10px;
            margin-top: 10px;
        }

        .register-link, .login-link {
            font-size: 14px;
            color: #2e541f;
            font-weight: 600; 
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .register-link:hover, .login-link:hover {
            text-decoration: underline; 
            color: #467e32;
        }
    </style>
</head>

<body>
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
        <form>
            <table>
                <tr>
                    <td>
                        <div class="input-group">
                            <input type="text" class="ten-dk" name="ten-dk" placeholder="Nhập tên đăng ký" required>
                            <svg class="icon-left" viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="input-group">
                            <input type="email" class="email-dk" name="email-dk" placeholder="Nhập email đăng ký" required>
                            <svg class="icon-left" viewBox="0 0 24 24"><path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg>
                        </div>
                    </td>
                </tr>
            </table>
            <button type="submit" class="btn-dk" name="tn-dk" value="action">Gửi yêu cầu</button>
            <div class="link-group">
                <a href="${pageContext.request.contextPath}/views/auth/register.jsp" class="register-link" name="register-link">Đăng ký mới</a>
                <a href="${pageContext.request.contextPath}/views/auth/login.jsp" class="login-link" name="login-link">Đăng nhập ngay</a>
            </div>
        </form>
    </div>
</body>

</html>
