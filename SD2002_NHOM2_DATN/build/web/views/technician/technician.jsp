<%-- 
    Document   : technician
    Created on : Jun 23, 2026, 2:13:59 PM
    Author     : longd
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Farmer - Trang Chủ Hệ Thống</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-image: url('https://images.unsplash.com/photo-1625246333195-78d9c38ad449?q=80&w=1920&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            display: flex;
            height: 100vh;
            overflow: hidden;
            position: relative;
        }

        body::before {
            content: "";
            position: absolute;
            inset: 0;
            background-color: rgba(20, 35, 20, 0.6);
            z-index: -1;
        }

        /* ================= SIDEBAR (MENU TRÁI TỪ US1 - US7) ================= */
        .sidebar {
            width: 300px;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-right: 1px solid rgba(255, 255, 255, 0.4);
            display: flex;
            flex-direction: column;
            box-shadow: 4px 0 25px rgba(0, 0, 0, 0.15);
            z-index: 10;
        }

        .logo-area {
            height: 85px;
            display: flex;
            align-items: center;
            padding: 0 25px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.08);
            gap: 15px;
        }

        .logo-area svg { width: 36px; height: 36px; filter: drop-shadow(0px 2px 4px rgba(0,0,0,0.15)); }
        .logo-area h2 {
            margin: 0; font-size: 22px; font-weight: 850;
            background: linear-gradient(135deg, #1e4512, #467e32);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }

        .menu { list-style: none; padding: 25px 0; margin: 0; flex: 1; overflow-y: auto; }
        .menu-item {
            padding: 14px 25px; display: flex; align-items: center; gap: 15px;
            color: #1a2419; text-decoration: none; font-weight: 700; font-size: 15px;
            transition: all 0.3s ease; border-left: 5px solid transparent;
        }

        .menu-item:hover, .menu-item.active {
            background: linear-gradient(90deg, rgba(87, 156, 63, 0.15) 0%, rgba(255, 255, 255, 0) 100%);
            border-left-color: #579c3f; color: #467e32;
        }
        .menu-item svg { width: 22px; height: 22px; fill: currentColor; }

        .logout-btn {
            border-top: 1px solid rgba(0, 0, 0, 0.08);
            padding: 20px 0;
        }

        /* ================= HEADER & MAIN CONTENT ================= */
        .main-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .header {
            height: 85px;
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.4);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 40px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05); z-index: 5;
        }

        .header-title h1 { margin: 0; font-size: 26px; font-weight: 800; color: #1a2419; }

        .user-profile { display: flex; align-items: center; gap: 20px; }
        .notification {
            position: relative; cursor: pointer; width: 45px; height: 45px;
            background: rgba(87, 156, 63, 0.1); border-radius: 50%;
            display: flex; justify-content: center; align-items: center; transition: background 0.3s;
        }
        .notification:hover { background: rgba(87, 156, 63, 0.2); }
        .notification svg { width: 22px; height: 22px; fill: #2e541f; }
        
        .badge {
            position: absolute; top: 2px; right: 2px; background-color: #e74c3c; color: white;
            font-size: 11px; font-weight: 800; padding: 3px 6px; border-radius: 12px;
            min-width: 10px; min-height: 12px;
            display: flex; justify-content: center; align-items: center;
        }

        .avatar {
            width: 45px; height: 45px; background: linear-gradient(135deg, #579c3f, #2e541f);
            color: #ffffff; border-radius: 12px; display: flex; justify-content: center; align-items: center;
            font-weight: 800; font-size: 18px; cursor: pointer; box-shadow: 0 4px 10px rgba(46, 84, 31, 0.3);
        }

        .content-area { 
            flex: 1; 
            padding: 40px; 
            overflow-y: auto; 
            position: relative;
        }

        /* ================= NÚT THÊM MỚI QUY TRÌNH ================= */
        .action-bar {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 20px;
        }

        .btn-open-modal {
            background-color: #579c3f;
            color: white;
            border: none;
            padding: 12px 20px;
            font-size: 15px;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(87, 156, 63, 0.3);
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-open-modal:hover {
            background-color: #467e32;
            transform: translateY(-2px);
        }

        /* ================= MODAL DIALOG POPUP (ẨN MẶC ĐỊNH) ================= */
        .modal-overlay {
            position: fixed;
            inset: 0;
            background-color: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.3s ease;
        }

        .modal-overlay.show {
            opacity: 1;
            pointer-events: auto;
        }

        .modal-container {
            background: #ffffff;
            border-radius: 16px;
            padding: 35px;
            width: 100%;
            max-width: 600px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            position: relative;
            transform: translateY(-20px);
            transition: transform 0.3s ease;
        }

        .modal-overlay.show .modal-container {
            transform: translateY(0);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
        }

        .modal-header h2 {
            margin: 0;
            font-size: 22px;
            color: #1a2419;
            font-weight: 800;
        }

        .btn-close-modal {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #aaa;
            transition: color 0.2s;
        }

        .btn-close-modal:hover {
            color: #333;
        }

        /* ================= FORM PHẦN TỬ PHÍA TRONG POPUP ================= */
        .uc-info {
            font-size: 13px;
            color: #4a5c43;
            margin-bottom: 20px;
            background: rgba(87, 156, 63, 0.1);
            padding: 10px 12px;
            border-radius: 6px;
            border-left: 4px solid #579c3f;
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: 700;
            margin-bottom: 8px;
            color: #1a2419;
            font-size: 14px;
        }

        .form-group input[type="text"],
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #cccccc;
            border-radius: 8px;
            font-size: 14px;
            box-sizing: border-box;
            background-color: #fff;
            transition: border-color 0.3s;
        }

        .form-group input[type="text"]:focus,
        .form-group select:focus {
            border-color: #579c3f;
            outline: none;
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 25px;
            border-top: 1px solid #eee;
            padding-top: 15px;
        }

        .btn-cancel {
            background-color: #f5f5f5;
            color: #333;
            border: 1px solid #ccc;
            padding: 10px 20px;
            font-weight: 700;
            border-radius: 6px;
            cursor: pointer;
        }

        .btn-submit {
            background: #579c3f;
            color: white;
            border: none;
            padding: 10px 20px;
            font-weight: 700;
            border-radius: 6px;
            cursor: pointer;
            box-shadow: 0 4px 10px rgba(87, 156, 63, 0.2);
        }

        .btn-submit:hover {
            background: #467e32;
        }

        .note-panel {
            margin-top: 20px;
            font-size: 12px;
            color: #c0392b;
            font-style: italic;
            background: #fdf2e9;
            padding: 10px;
            border-radius: 6px;
            border-left: 4px solid #e67e22;
        }
    </style>
</head>
<body>

    <jsp:include page="/views/common/sidebar.jsp">
        <jsp:param name="activePage" value="setupProcess" />
    </jsp:include>
    
    <div class="main-wrapper">
        <header class="header">
            <div class="header-title">
                <h1>Thiết Lập Quy Trình</h1>
            </div>
            <div class="user-profile">
                <div class="notification">
                    <svg viewBox="0 0 24 24"><path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.07-1.63-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.64 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2zm-2 1H8v-6c0-2.48 1.51-4.5 4-4.5s4 2.02 4 4.5v6z"/></svg>
                    <span class="badge"></span>
                </div>
                <div class="avatar">A</div>
            </div>
        </header>
        
        <main class="content-area">
            <div class="action-bar">
                <button class="btn-open-modal" onclick="openModal()">+ Tạo bộ quy chuẩn cây trồng</button>
            </div>

            </main>
    </div>

    <div class="modal-overlay" id="processModal">
        <div class="modal-container">
            <div class="modal-header">
                <h2>Tạo bộ quy chuẩn cây trồng</h2>
                <button class="btn-close-modal" onclick="closeModal()">&times;</button>
            </div>
            
            <form action="${pageContext.request.contextPath}/FarmingPracticeServlet" method="POST">
                <div class="form-group">
                    <label for="processName">Tên Quy Trình Quy Chuẩn:</label>
                    <input type="text" id="processName" name="processName" placeholder="Nhập tên bộ quy chuẩn..." required>
                </div>

                <div class="form-group">
                    <label for="breedId">Áp Dụng Cho Giống Cây Trồng / Vật Nuôi:</label>
                    <select id="breedId" name="breedId" required>
                        <option value="">-- Chọn giống từ danh sách --</option>
                        <c:forEach var="breed" items="${breedList}">
                            <option value="${breed.id}">${breed.name}</option>
                        </c:forEach>
                        <option value="1">Lúa ST25</option>
                        <option value="2">Dưa lưới Huỳnh Long</option>
                    </select>
                </div>

                <div class="note-panel">
                    * Lưu ý: Việc chuẩn hóa danh mục giống cây trồng cần được thực hiện trước để đảm bảo dữ liệu đầu vào không bị rác.
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeModal()">Hủy bỏ</button>
                    <button type="submit" class="btn-submit">Lưu thông tin</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openModal() {
            document.getElementById('processModal').classList.add('show');
        }

        function closeModal() {
            document.getElementById('processModal').classList.remove('show');
        }

        // Đóng popup khi nhấn ra vùng ngoài màu đen
        window.onclick = function(event) {
            var modal = document.getElementById('processModal');
            if (event.target == modal) {
                modal.classList.remove('show');
            }
        }
    </script>
</body>
</html>