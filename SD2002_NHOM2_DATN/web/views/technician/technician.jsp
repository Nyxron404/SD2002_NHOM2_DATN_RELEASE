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
    <title>Smart Farmer - Thiết Lập Quy Trình</title>
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
            background-color: #f39c12; color: white; padding: 5px 10px; border-radius: 12px; font-size: 12px; font-weight: 700; display: inline-block;
        }
        .status-badge.active-status {
            background-color: #2ecc71;
        }
        .action-link { color: #3498db; text-decoration: none; margin-right: 10px; cursor: pointer; }
        .action-link:hover { text-decoration: underline; }

        /* ================= MODAL PURE CSS LOGIC ================= */
        .modal-toggle { display: none; }

        .modal-overlay {
            position: fixed; inset: 0; background: rgba(0, 0, 0, 0.6);
            display: flex; justify-content: center; align-items: center; z-index: 999;
            opacity: 0; pointer-events: none; transition: opacity 0.3s ease;
        }

        .modal-container {
            background: #ffffff; width: 100%; max-width: 600px; border-radius: 16px;
            padding: 35px; box-shadow: 0 10px 40px rgba(0,0,0,0.3);
            position: relative; transform: translateY(-30px); transition: transform 0.3s ease;
        }

        /* Trigger hiển thị Modal Tạo Mới qua CSS */
        #createModalToggle:checked ~ .modal-overlay#modalOverlay { opacity: 1; pointer-events: auto; }
        #createModalToggle:checked ~ .modal-overlay#modalOverlay .modal-container { transform: translateY(0); }

        /* Trigger hiển thị các Modal Chi Tiết riêng biệt qua CSS */
        <c:forEach var="item" items="${farmingPracticeList}">
        #detailToggle-${item.maQuyTrinh}:checked ~ .modal-overlay#detailModal-${item.maQuyTrinh} { opacity: 1; pointer-events: auto; }
        #detailToggle-${item.maQuyTrinh}:checked ~ .modal-overlay#detailModal-${item.maQuyTrinh} .modal-container { transform: translateY(0); }
        </c:forEach>

        .modal-close {
            position: absolute; top: 20px; right: 20px; background: none; border: none;
            font-size: 24px; color: #aaa; cursor: pointer; display: inline-block; line-height: 1;
        }
        .modal-close:hover { color: #333; }

        .modal-title { font-size: 22px; font-weight: 800; color: #1a2419; margin-top: 0; margin-bottom: 20px; }
        
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-weight: 700; margin-bottom: 8px; color: #1a2419; font-size: 14px; }
        .form-group input[type="text"], .form-group textarea { width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 8px; font-size: 14px; box-sizing: border-box; font-family: inherit; }
        
        .btn-submit { width: 100%; background: #579c3f; color: white; border: none; padding: 14px; font-size: 15px; font-weight: bold; border-radius: 8px; cursor: pointer; margin-top: 10px; transition: background 0.3s; }
        .btn-submit:hover { background: #467e32; }
        .note-panel { margin-top: 20px; font-size: 12px; color: #c0392b; font-style: italic; background: #fdf2e9; padding: 10px; border-radius: 6px; border-left: 4px solid #e67e22; }

        /* Chi tiết quy trình */
        .detail-item { margin-bottom: 15px; font-size: 14px; line-height: 1.6; }
        .detail-item strong { display: inline-block; width: 150px; color: #2e541f; }
        .detail-description { background: #f9fbf9; padding: 15px; border-radius: 8px; border: 1px solid #e2ece2; margin-top: 10px; white-space: pre-line; }
    </style>
</head>
<body>

    <!-- Các thẻ Checkbox ẩn để xử lý đóng mở Modal bằng CSS -->
    <input type="checkbox" id="createModalToggle" class="modal-toggle">
    
    <c:forEach var="item" items="${farmingPracticeList}">
        <input type="checkbox" id="detailToggle-${item.maQuyTrinh}" class="modal-toggle">
    </c:forEach>

    <jsp:include page="/views/common/sidebar.jsp">
        <jsp:param name="activePage" value="technician" />
    </jsp:include>
    
    <div class="main-wrapper">
        <header class="header">
            <div class="header-title">
                <h1>Thiết Lập Quy Trình</h1>
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
                <h2 class="section-title">Danh sách bộ quy chuẩn canh tác</h2>
                <label for="createModalToggle" class="btn-add">+ Tạo bộ quy chuẩn canh tác, sản xuất</label>
            </div>

            <div class="table-container">
                <div class="data-info">Số lượng quy trình lấy được: ${farmingPracticeList != null ? farmingPracticeList.size() : 0}</div>
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên Quy Trình</th>
                            <th>Ngày Tạo</th>
                            <th>Người Tạo</th>
                            <th>Trạng Thái</th>
                            <th>Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${farmingPracticeList}">
                            <tr>
                                <td>${item.maQuyTrinh}</td>
                                <td>${item.tenQuyTrinh}</td>
                                <td>${item.ngayTao}</td>
                                <td>${item.nguoiTao}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.trangThai}">
                                            <span class="status-badge active-status">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge">Bản nháp</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <label for="detailToggle-${item.maQuyTrinh}" class="action-link" style="color: #3498db;">Chi tiết</label>
                                    <form action="${pageContext.request.contextPath}/technician" method="POST" style="display:inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa quy trình này không?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${item.maQuyTrinh}">
                                    <button type="submit" style="background:none; border:none; color:red; cursor:pointer; padding:0; font-family:inherit; font-size:inherit;"> Xóa </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty farmingPracticeList}">
                            <tr>
                                <td colspan="6" style="text-align: center; color: #7f8c8d; padding: 30px;">Chưa có quy trình nào được thiết lập. Hãy bấm nút tạo mới bên trên.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <!-- ================= MODAL TẠO MỚI QUY TRÌNH ================= -->
    <div class="modal-overlay" id="modalOverlay">
        <div class="modal-container">
            <label for="createModalToggle" class="modal-close">&times;</label>
            <h3 class="modal-title">Tạo bộ quy chuẩn canh tác, sản xuất</h3>
            
            <form action="${pageContext.request.contextPath}/technician" method="POST">
                <div class="form-group">
                    <label for="processName">Tên Quy Trình Quy Chuẩn:</label>
                    <input type="text" id="processName" name="processName" placeholder="Nhập tên bộ quy chuẩn..." required>
                </div>

                <div class="form-group">
                    <label for="description">Mô tả quy trình:</label>
                    <textarea id="description" name="description" rows="5" placeholder="Nhập mô tả tóm tắt cho quy trình canh tác này (ví dụ: mục tiêu, yêu cầu thổ nhưỡng, mùa vụ thích hợp...)" required></textarea>
                </div>

                <button type="submit" class="btn-submit">Lưu Khởi Tạo (Bản nháp)</button>

                <div class="note-panel">
                    * Lưu ý: Quy trình sau khi tạo sẽ nằm ở trạng thái "Bản nháp". Bạn cần phê duyệt để chính thức áp dụng.
                </div>
            </form>
        </div>
    </div>

    <!-- ================= CÁC MODAL CHI TIẾT QUY TRÌNH (Vòng lặp tạo động qua CSS) ================= -->
    <c:forEach var="item" items="${farmingPracticeList}">
        <div class="modal-overlay" id="detailModal-${item.maQuyTrinh}">
            <div class="modal-container">
                <label for="detailToggle-${item.maQuyTrinh}" class="modal-close">&times;</label>
                <h3 class="modal-title" style="color: #2e541f; border-bottom: 2px solid #579c3f; padding-bottom: 10px;">Chi Tiết Quy Trình Canh Tác</h3>
                
                <div style="margin-top: 20px;">
                    <div class="detail-item">
                        <strong>ID Quy Trình:</strong> <span>${item.maQuyTrinh}</span>
                    </div>
                    <div class="detail-item">
                        <strong>Tên Quy Trình:</strong> <span>${item.tenQuyTrinh}</span>
                    </div>
                    <div class="detail-item">
                        <strong>Ngày Tạo:</strong> <span>${item.ngayTao}</span>
                    </div>
                    <div class="detail-item">
                        <strong>Người Tạo (Mã):</strong> <span>${item.nguoiTao}</span>
                    </div>
                    <div class="detail-item">
                        <strong>Trạng Thái:</strong> 
                        <span class="status-badge ${item.trangThai ? 'active-status' : ''}">
                            ${item.trangThai ? 'Hoạt động' : 'Bản nháp'}
                        </span>
                    </div>
                    
                    <div class="detail-item" style="margin-top: 20px;">
                        <label style="font-weight: 700; color: #1a2419;">Mô tả quy trình:</label>
                        <div class="detail-description">${item.moTa != null ? item.moTa : 'Không có mô tả chi tiết.'}</div>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>

</body>
</html>