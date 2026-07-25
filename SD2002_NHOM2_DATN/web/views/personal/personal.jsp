<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thông tin cá nhân</title>
        <style>
            body {
                margin: 0; padding: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-image: url('https://images.unsplash.com/photo-1625246333195-78d9c38ad449?q=80&w=1920&auto=format&fit=crop');
                background-size: cover; background-position: center;
                display: flex; height: 100vh; overflow: hidden; position: relative;
            }
            body::before {
                content: ""; position: absolute; inset: 0; background-color: rgba(20, 35, 20, 0.6); z-index: -1;
            }
            .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
            .content-area { flex: 1; padding: 40px; overflow-y: auto; }

            .page-toolbar { margin-bottom: 25px; }
            .page-toolbar h2 { margin: 0; color: #ffffff; font-size: 24px; font-weight: 700; text-shadow: 0 2px 4px rgba(0,0,0,0.5); }

            /* Grid Layout cho trang cá nhân */
            .profile-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; }

            .card-panel {
                background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(15px);
                border-radius: 16px; padding: 30px; border: 1px solid rgba(255, 255, 255, 0.6);
                box-shadow: 0px 8px 32px rgba(0, 0, 0, 0.15);
            }
            .card-title { margin-top: 0; margin-bottom: 20px; font-size: 20px; color: #2e541f; font-weight: 800; border-bottom: 2px solid #eef2f5; padding-bottom: 10px; }

            /* Khu vực Avatar */
            .profile-header { display: flex; align-items: center; gap: 20px; margin-bottom: 30px; }
            .avatar-circle {
                width: 80px; height: 80px; background: linear-gradient(135deg, #579c3f, #2e541f);
                color: white; font-size: 32px; font-weight: bold; display: flex; justify-content: center;
                align-items: center; border-radius: 50%; box-shadow: 0 4px 15px rgba(87, 156, 63, 0.4);
            }
            .profile-name { font-size: 22px; font-weight: 800; color: #1a2419; margin: 0; }
            .profile-role { font-size: 14px; color: #7f8c8d; margin-top: 5px; font-weight: 600; }

            /* Danh sách thông tin */
            .info-list { list-style: none; padding: 0; margin: 0; }
            .info-list li { display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px dashed #eee; font-size: 15px; }
            .info-list li:last-child { border-bottom: none; }
            .info-label { font-weight: 600; color: #555; }
            .info-value { font-weight: 700; color: #1a2419; text-align: right; }

            /* Form đổi mật khẩu & Mắt bật tắt */
            .form-group { margin-bottom: 20px; position: relative; }
            .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #444; font-size: 14px; }
            .form-control {
                width: 100%; padding: 12px 40px 12px 15px; border: 1px solid #ddd; border-radius: 8px;
                font-size: 14px; box-sizing: border-box; transition: 0.3s; font-family: inherit;
            }
            .form-control:focus { outline: none; border-color: #579c3f; box-shadow: 0 0 0 3px rgba(87,156,63,0.1); }
            
            .toggle-password {
                position: absolute; right: 12px; top: 38px; cursor: pointer; background: none; border: none; font-size: 16px; color: #777;
            }
            .toggle-password:focus { outline: none; }
            .toggle-password:hover { color: #333; }

            .btn-save {
                background: linear-gradient(135deg, #579c3f, #396728); color: white; border: none;
                padding: 12px 24px; border-radius: 8px; font-size: 15px; font-weight: bold; cursor: pointer;
                width: 100%; box-shadow: 0 4px 15px rgba(87, 156, 63, 0.4); transition: 0.3s; margin-top: 10px;
            }
            .btn-save:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(87, 156, 63, 0.6); }

            /* Toast Notification */
            .toast {
                position: fixed; top: 25px; right: 25px; padding: 15px 25px; border-radius: 8px;
                color: white; font-weight: 600; font-size: 15px; z-index: 9999; box-shadow: 0 4px 15px rgba(0,0,0,0.2);
                animation: slideInRight 0.5s ease-out forwards;
            }
            .toast.success { background-color: #2ecc71; border-left: 6px solid #27ae60; }
            .toast.error { background-color: #e74c3c; border-left: 6px solid #c0392b; }
            @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        </style>
    </head>
    <body>
        <jsp:include page="/views/common/sidebar.jsp">
            <jsp:param name="activePage" value="personal" />
        </jsp:include>
        
        <div class="main-wrapper">
            <jsp:include page="/views/common/header.jsp">
                <jsp:param name="pageTitle" value="Thông Tin Cá Nhân" />
            </jsp:include>
            
            <main class="content-area">
                <div class="page-toolbar">
                    <h2>Hồ sơ của tôi</h2>
                </div>

                <div class="profile-grid">
                    <!-- Khung Thông tin cá nhân -->
                    <div class="card-panel">
                        <h3 class="card-title">Thông tin nhân viên</h3>
                        <div class="profile-header">
                            <!-- JS sẽ xử lý cắt chữ cái đầu của Tên và đổ vào đây -->
                            <div class="avatar-circle" id="userAvatarChar">
                                L
                            </div>
                            <div>
                                <h4 class="profile-name" id="userFullName">${staffInfo.hoTen}</h4>
                                <div class="profile-role">ID: #${staffInfo.maNhanVien} | Mã User: #${userInfo.maNguoiDung}</div>
                            </div>
                        </div>

                        <ul class="info-list">
                            <li><span class="info-label">Tài khoản đăng nhập</span> <span class="info-value" style="color: #e67e22;">${userInfo.tenDangNhap}</span></li>
                            <li><span class="info-label">Ngày sinh</span> <span class="info-value">${staffInfo.ngaySinh}</span></li>
                            <li><span class="info-label">Giới tính</span> <span class="info-value">${staffInfo.gioiTinh ? 'Nam' : 'Nữ'}</span></li>
                            <li><span class="info-label">Số điện thoại</span> <span class="info-value">${staffInfo.SDT}</span></li>
                            <li><span class="info-label">Email</span> <span class="info-value">${staffInfo.email}</span></li>
                            <li><span class="info-label">Địa chỉ</span> <span class="info-value">${staffInfo.diaChi}</span></li>
                            <li><span class="info-label">Ngày vào làm</span> <span class="info-value">${staffInfo.ngayVaoLam}</span></li>
                        </ul>
                    </div>

                    <!-- Khung Đổi mật khẩu -->
                    <div class="card-panel">
                        <h3 class="card-title">Đổi mật khẩu</h3>
                        <form action="${pageContext.request.contextPath}/personal" method="POST">
                            <input type="hidden" name="action" value="changePassword">
                            
                            <div class="form-group">
                                <label>Mật khẩu hiện tại</label>
                                <input type="password" name="oldPassword" id="oldPwd" class="form-control" required placeholder="Nhập mật khẩu cũ...">
                                <button type="button" class="toggle-password" onclick="toggleVisibility('oldPwd', this)">👁️</button>
                            </div>
                            
                            <div class="form-group">
                                <label>Mật khẩu mới</label>
                                <input type="password" name="newPassword" id="newPwd" class="form-control" required placeholder="Nhập mật khẩu mới...">
                                <button type="button" class="toggle-password" onclick="toggleVisibility('newPwd', this)">👁️</button>
                            </div>
                            
                            <div class="form-group">
                                <label>Xác nhận mật khẩu mới</label>
                                <input type="password" name="confirmPassword" id="confirmPwd" class="form-control" required placeholder="Nhập lại mật khẩu mới...">
                                <button type="button" class="toggle-password" onclick="toggleVisibility('confirmPwd', this)">👁️</button>
                            </div>

                            <button type="submit" class="btn-save">Cập nhật mật khẩu</button>
                        </form>
                    </div>
                </div>
            </main>
        </div>

        <c:if test="${not empty toastMessage}">
            <div class="toast ${toastType}">${toastMessage}</div>
            <script>
                setTimeout(() => {
                    const toastEl = document.querySelector('.toast');
                    if (toastEl) toastEl.style.display = 'none';
                }, 5000);
            </script>
        </c:if>

        <script>
            // Lấy chữ cái đầu của Tên (từ cuối cùng)
            document.addEventListener('DOMContentLoaded', function() {
                var fullName = document.getElementById('userFullName').innerText.trim();
                if(fullName) {
                    var words = fullName.split(' ');
                    var firstName = words[words.length - 1]; // Lấy từ cuối cùng
                    if(firstName && firstName.length > 0) {
                        document.getElementById('userAvatarChar').innerText = firstName.charAt(0).toUpperCase();
                    }
                }
            });

            // Bật tắt hiển thị mật khẩu
            function toggleVisibility(inputId, btn) {
                var input = document.getElementById(inputId);
                if (input.type === "password") {
                    input.type = "text";
                    btn.innerHTML = "🙈"; 
                } else {
                    input.type = "password";
                    btn.innerHTML = "👁️"; 
                }
            }
        </script>
    </body>
</html>