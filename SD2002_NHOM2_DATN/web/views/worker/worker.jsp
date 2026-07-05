<%-- 
    Document   : worker
    Created on : Jun 23, 2026, 2:14:09 PM
    Author     : longd
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Farmer - Nhiệm Vụ Công Nhân</title>
    <style>
        body {
            margin: 0; padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-image: url('https://images.unsplash.com/photo-1625246333195-78d9c38ad449?q=80&w=1920&auto=format&fit=crop');
            background-size: cover; background-position: center;
            display: flex; height: 100vh; overflow: hidden; position: relative;
        }

        body::before {
            content: ""; position: absolute; inset: 0;
            background-color: rgba(20, 35, 20, 0.6); z-index: -1;
        }

        .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow: hidden; }

        /* ================= HEADER ================= */
        .header {
            height: 85px; background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.4);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 40px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05); z-index: 5;
        }
        .header-title h1 { margin: 0; font-size: 26px; font-weight: 800; color: #1a2419; }
        .user-profile { display: flex; align-items: center; gap: 20px; }
        .notification {
            position: relative; cursor: pointer; width: 45px; height: 45px;
            background: rgba(87, 156, 63, 0.1); border-radius: 50%;
            display: flex; justify-content: center; align-items: center;
        }
        .notification svg { width: 22px; height: 22px; fill: #2e541f; }
        .avatar {
            width: 45px; height: 45px; background: linear-gradient(135deg, #579c3f, #2e541f);
            color: #ffffff; border-radius: 12px; display: flex; justify-content: center; align-items: center;
            font-weight: 800; font-size: 18px; cursor: pointer;
        }

        /* ================= CONTENT AREA & TABLE ================= */
        .content-area { flex: 1; padding: 40px; overflow-y: auto; }
        
        .section-header {
            display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;
        }
        .section-title { color: #ffffff; font-size: 22px; font-weight: 700; margin: 0; }
        
        .btn-add {
            background-color: #579c3f; color: white; border: none; padding: 12px 20px;
            font-size: 14px; font-weight: 600; border-radius: 8px; cursor: pointer;
            display: flex; align-items: center; gap: 8px; box-shadow: 0 4px 12px rgba(87, 156, 63, 0.3);
            transition: all 0.3s; text-decoration: none;
        }
        .btn-add:hover { background-color: #467e32; transform: translateY(-1px); }

        .table-container {
            background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(15px);
            border-radius: 16px; padding: 30px; box-shadow: 0px 8px 32px rgba(0, 0, 0, 0.15);
        }
        .data-info { font-size: 14px; color: #555; margin-bottom: 20px; font-weight: 500; }

        .custom-table { width: 100%; border-collapse: collapse; text-align: left; }
        .custom-table th { padding: 16px; border-bottom: 2px solid #eef2f5; color: #7f8c8d; font-size: 13px; font-weight: 700; text-transform: uppercase; }
        .custom-table td { padding: 16px; border-bottom: 1px solid #eef2f5; color: #2c3e50; font-size: 14px; font-weight: 600; }
        
        .status-badge {
            background-color: #e67e22; color: white; padding: 5px 10px; border-radius: 12px; font-size: 12px; font-weight: 700; display: inline-block;
        }
        .action-link { color: #3498db; text-decoration: none; margin-right: 10px; }
        .action-link:hover { text-decoration: underline; }

        /* ================= MODAL POPUP ================= */
        .modal-overlay {
            position: fixed; inset: 0; background: rgba(0, 0, 0, 0.6);
            display: flex; justify-content: center; align-items: center; z-index: 999;
            opacity: 0; pointer-events: none; transition: opacity 0.3s ease;
        }
        .modal-overlay.active { opacity: 1; pointer-events: auto; }

        .modal-container {
            background: #ffffff; width: 100%; max-width: 650px; border-radius: 16px;
            padding: 35px; box-shadow: 0 10px 40px rgba(0,0,0,0.3);
            position: relative; transform: translateY(-30px); transition: transform 0.3s ease;
        }
        .modal-overlay.active .modal-container { transform: translateY(0); }

        .modal-close {
            position: absolute; top: 20px; right: 20px; background: none; border: none;
            font-size: 24px; color: #aaa; cursor: pointer;
        }
        .modal-close:hover { color: #333; }

        .modal-title { font-size: 22px; font-weight: 800; color: #1a2419; margin-top: 0; margin-bottom: 20px; }
        
        .uc-info { font-size: 13px; color: #4a5c43; margin-bottom: 20px; background: rgba(87, 156, 63, 0.1); padding: 10px 12px; border-radius: 6px; border-left: 4px solid #579c3f; font-weight: 600; }
        
        .form-row { display: flex; gap: 20px; margin-bottom: 18px; }
        .form-group { flex: 1; }
        .form-group label { display: block; font-weight: 700; margin-bottom: 8px; color: #1a2419; font-size: 14px; }
        .form-group input[type="text"], .form-group input[type="date"], .form-group select, .form-group textarea { width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 8px; font-size: 14px; box-sizing: border-box; }
        .form-group textarea { resize: vertical; height: 70px; }
        
        .btn-submit { width: 100%; background: #579c3f; color: white; border: none; padding: 14px; font-size: 15px; font-weight: bold; border-radius: 8px; cursor: pointer; margin-top: 10px; transition: background 0.3s; }
        .btn-submit:hover { background: #467e32; }
        .note-panel { margin-top: 15px; font-size: 12px; color: #c0392b; font-style: italic; background: #fdf2e9; padding: 10px; border-radius: 6px; border-left: 4px solid #e67e22; }
    </style>
</head>
<body>

    <jsp:include page="/views/common/sidebar.jsp">
        <jsp:param name="activePage" value="us6_task" />
    </jsp:include>
    
    <div class="main-wrapper">
        <header class="header">
            <div class="header-title">
                <h1>Quản Lý Công Việc</h1>
            </div>
            <div class="user-profile">
                <div class="notification">
                    <svg viewBox="0 0 24 24"><path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.07-1.63-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.64 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2zm-2 1H8v-6c0-2.48 1.51-4.5 4-4.5s4 2.02 4 4.5v6z"/></svg>
                </div>
                <div class="avatar">A</div>
            </div>
        </header>
        
        <main class="content-area">
            <div class="section-header">
                <h2 class="section-title">Danh sách phân công nhiệm vụ</h2>
                <button class="btn-add" id="openModalBtn">+ Phân công mới</button>
            </div>

            <div class="table-container">
                <div class="data-info">Số lượng công việc đang triển khai: ${taskList != null ? taskList.size() : 0}</div>
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>Mã Việc</th>
                            <th>Tên Công Việc</th>
                            <th>Khu Vực</th>
                            <th>Người Phụ Trách</th>
                            <th>Hạn Chót</th>
                            <th>Trạng Thái</th>
                            <th>Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="task" items="${taskList}">
                            <tr>
                                <td>${task.maCongViec}</td>
                                <td>${task.tenCongViec}</td>
                                <td>Khu ${task.maKhuVuc}</td>
                                <td>Công nhân ${task.nguoiPhuTrach}</td>
                                <td>${task.ngayKetThuc}</td>
                                <td><span class="status-badge">${task.trangThai}</span></td>
                                <td>
                                    <a href="#" class="action-link">Hủy việc</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty taskList}">
                            <tr>
                                <td>101</td>
                                <td>Bón phân đợt 1 luống rau sạch</td>
                                <td>Khu A1 - Lô Đất 2</td>
                                <td>Nguyễn Văn Hùng</td>
                                <td>2026-07-10</td>
                                <td><span class="status-badge" style="background-color: #3498db;">Chưa thực hiện</span></td>
                                <td><a href="#" class="action-link" style="color: #e74c3c;">Hủy việc</a></td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <div class="modal-overlay" id="modalOverlay">
        <div class="modal-container">
            <button class="modal-close" id="closeModalBtn">&times;</button>
            <h3 class="modal-title">Khởi tạo và Phân công việc</h3>
           
            <form action="${pageContext.request.contextPath}/TaskServlet" method="POST">
                <div class="form-row">
                    <div class="form-group">
                        <label for="maKhuVuc">Chọn Lô Đất / Khu Vực:</label>
                        <select id="maKhuVuc" name="maKhuVuc" required>
                            <option value="">-- Chọn khu vực --</option>
                            <option value="1">Khu A1 - Lô Đất 1</option>
                            <option value="2">Khu B2 - Chuồng Nuôi 3</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="maQuyTrinh">Quy Trình Mẫu Áp Dụng:</label>
                        <select id="maQuyTrinh" name="maQuyTrinh" required>
                            <option value="">-- Tự động gợi ý quy trình --</option>
                            <option value="1">Quy trình chuẩn Lúa ST25</option>
                            <option value="2">Quy trình nuôi heo hữu cơ</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="tenCongViec">Tên Công Việc Nhiệm Vụ:</label>
                    <input type="text" id="tenCongViec" name="tenCongViec" placeholder="Nhập tên nhiệm vụ cụ thể..." required>
                </div>

                <div class="form-group">
                    <label for="moTa">Mô Tả Chi Tiết Hướng Dẫn:</label>
                    <textarea id="moTa" name="moTa" placeholder="Ghi chú các bước thực hiện nếu có..."></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="nguoiPhuTrach">Chọn Công Nhân Phụ Trách:</label>
                        <select id="nguoiPhuTrach" name="nguoiPhuTrach" required>
                            <option value="">-- Chọn công nhân --</option>
                            <option value="10">Nguyễn Văn Hùng</option>
                            <option value="11">Trần Thị Mai</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="ngayBatDau">Ngày Bắt Đầu:</label>
                        <input type="date" id="ngayBatDau" name="ngayBatDau" required>
                    </div>
                    <div class="form-group">
                        <label for="ngayKetThuc">Hạn Chót (Ngày Kết Thúc):</label>
                        <input type="date" id="ngayKetThuc" name="ngayKetThuc" required>
                    </div>
                </div>

                <button type="submit" class="btn-submit">Xác Nhận Giao Việc</button>

                <div class="note-panel">
                    * Hệ thống tích hợp cơ chế tự động quét lịch để tránh trùng lặp, quá tải ngày làm việc của công nhân.
                </div>
            </form>
        </div>
    </div>

    <script>
        const openModalBtn = document.getElementById('openModalBtn');
        const closeModalBtn = document.getElementById('closeModalBtn');
        const modalOverlay = document.getElementById('modalOverlay');

        openModalBtn.addEventListener('click', () => modalOverlay.classList.add('active'));
        closeModalBtn.addEventListener('click', () => modalOverlay.classList.remove('active'));
        modalOverlay.addEventListener('click', (e) => {
            if (e.target === modalOverlay) modalOverlay.classList.remove('active');
        });
    </script>
</body>
</html>