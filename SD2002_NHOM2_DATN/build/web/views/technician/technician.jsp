<%-- 
    Document   : technician
    Created on : Jun 23, 2026, 0:00:00 PM
    Author     : pminh
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

            .main-wrapper {
                flex: 1;
                display: flex;
                flex-direction: column;
                overflow: hidden;
            }

            .content-area {
                flex: 1;
                padding: 40px;
                overflow-y: auto;
            }

            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
            }
            .section-title {
                color: #ffffff;
                font-size: 22px;
                font-weight: 700;
                margin: 0;
            }

            .header-actions {
                display: flex;
                gap: 15px;
                align-items: center;
            }

            .search-form {
                display: flex;
                gap: 8px;
                margin: 0;
            }
            .search-input {
                padding: 10px 15px;
                border: 1px solid #ccc;
                border-radius: 8px;
                outline: none;
                font-family: inherit;
                font-size: 14px;
                width: 250px;
            }
            .search-input:focus {
                border-color: #579c3f;
            }
            .btn-search {
                background-color: #2c3e50;
                color: white;
                border: none;
                padding: 10px 15px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: bold;
                font-size: 14px;
                transition: 0.3s;
            }
            .btn-search:hover {
                background-color: #1a252f;
            }

            .btn-add {
                background-color: #579c3f;
                color: white;
                border: none;
                padding: 12px 20px;
                font-size: 14px;
                font-weight: 600;
                border-radius: 8px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                box-shadow: 0 4px 12px rgba(87, 156, 63, 0.3);
                transition: all 0.3s;
                text-decoration: none;
            }
            .btn-add:hover {
                background-color: #467e32;
                transform: translateY(-1px);
            }

            .table-container {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(15px);
                border-radius: 16px;
                padding: 30px;
                box-shadow: 0px 8px 32px rgba(0, 0, 0, 0.15);
            }
            .data-info {
                font-size: 14px;
                color: #555;
                margin-bottom: 20px;
                font-weight: 500;
            }

            .custom-table {
                width: 100%;
                border-collapse: collapse;
                text-align: left;
            }
            .custom-table th {
                padding: 16px;
                border-bottom: 2px solid #eef2f5;
                color: #7f8c8d;
                font-size: 13px;
                font-weight: 700;
                text-transform: uppercase;
            }
            .custom-table td {
                padding: 16px;
                border-bottom: 1px solid #eef2f5;
                color: #2c3e50;
                font-size: 14px;
                font-weight: 600;
                vertical-align: middle;
            }

            .status-badge {
                background-color: #fff3cd;
                color: #856404;
                border: 1px solid #ffeeba;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 700;
                display: inline-block;
            }
            .status-badge.active-status {
                background-color: #e6f4ea;
                color: #1e8e3e;
                border: 1px solid #cce8d6;
            }

            .desc-column {
                max-width: 180px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                font-weight: 500;
                color: #555;
            }

            .action-buttons {
                display: flex;
                gap: 8px;
                align-items: center;
            }
            .btn-action-edit {
                background-color: #f39c12;
                color: white;
                padding: 6px 14px;
                border-radius: 6px;
                font-size: 13px;
                font-weight: bold;
                cursor: pointer;
                border: none;
                text-decoration: none;
                display: inline-block;
            }
            .btn-action-edit:hover {
                background-color: #e67e22;
            }

            .btn-action-stage {
                background-color: #2980b9;
                color: white;
                padding: 6px 14px;
                border-radius: 6px;
                font-size: 13px;
                font-weight: bold;
                cursor: pointer;
                border: none;
                display: inline-block;
            }
            .btn-action-stage:hover {
                background-color: #3498db;
            }

            .btn-action-delete {
                background-color: #e74c3c;
                color: white;
                padding: 6px 14px;
                border-radius: 6px;
                font-size: 13px;
                font-weight: bold;
                cursor: pointer;
                border: none;
                display: inline-block;
                font-family: inherit;
            }
            .btn-action-delete:hover {
                background-color: #c0392b;
            }

            /* --- MODAL CSS PURA --- */
            .modal-toggle {
                display: none;
            }

            .modal-overlay {
                position: fixed;
                inset: 0;
                background: rgba(0, 0, 0, 0.6);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 999;
                opacity: 0;
                pointer-events: none;
                transition: opacity 0.3s ease;
            }

            .modal-container {
                background: #ffffff;
                width: 100%;
                max-width: 600px;
                border-radius: 16px;
                padding: 35px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.3);
                position: relative;
                transform: translateY(-30px);
                transition: transform 0.3s ease;
                max-height: 90vh;
                overflow-y: auto;
            }

            /* Bật mở Modal Tạo Mới */
            #createModalToggle:checked ~ .modal-overlay#modalOverlay {
                opacity: 1;
                pointer-events: auto;
            }
            #createModalToggle:checked ~ .modal-overlay#modalOverlay .modal-container {
                transform: translateY(0);
            }

            /* Bật mở các Modal Chỉnh Sửa & Thiết lập giai đoạn */
            <c:forEach var="item" items="${farmingPracticeList}">
                #editToggle-${item.maQuyTrinh}:checked ~ .modal-overlay#editModal-${item.maQuyTrinh},
                #stageToggle-${item.maQuyTrinh}:checked ~ .modal-overlay#stageModal-${item.maQuyTrinh} {
                    opacity: 1;
                    pointer-events: auto;
                }
                #editToggle-${item.maQuyTrinh}:checked ~ .modal-overlay#editModal-${item.maQuyTrinh} .modal-container,
                #stageToggle-${item.maQuyTrinh}:checked ~ .modal-overlay#stageModal-${item.maQuyTrinh} .modal-container {
                    transform: translateY(0);
                }
            </c:forEach>

            .modal-close {
                position: absolute;
                top: 20px;
                right: 20px;
                background: none;
                border: none;
                font-size: 24px;
                color: #aaa;
                cursor: pointer;
                display: inline-block;
                line-height: 1;
            }
            .modal-close:hover {
                color: #333;
            }

            .modal-title {
                font-size: 22px;
                font-weight: 800;
                color: #1a2419;
                margin-top: 0;
                margin-bottom: 20px;
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
            .form-group input[type="number"], 
            .form-group textarea, 
            .form-group select {
                width: 100%;
                padding: 12px;
                border: 1px solid #ccc;
                border-radius: 8px;
                font-size: 14px;
                box-sizing: border-box;
                font-family: inherit;
            }

            /* Grid Layout cho Modal Giai đoạn */
            .grid-2-cols {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
            }
            .grid-7-5-cols {
                display: grid;
                grid-template-columns: 3fr 2fr;
                gap: 15px;
            }
            .input-group-custom {
                display: flex;
                gap: 8px;
            }
            .input-group-custom input {
                flex: 1;
            }
            .input-group-custom select {
                width: 90px;
            }

            .btn-submit {
                width: 100%;
                background: #579c3f;
                color: white;
                border: none;
                padding: 14px;
                font-size: 15px;
                font-weight: bold;
                border-radius: 8px;
                cursor: pointer;
                margin-top: 10px;
                transition: background 0.3s;
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

            .btn-cancel {
                background-color: #6c757d;
                color: white;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                border: none;
                font-size: 14px;
                text-decoration: none;
                font-weight: bold;
                display: inline-block;
            }
            .btn-cancel:hover {
                background-color: #5a6268;
            }
            .btn-save {
                background-color: #28a745;
                color: white;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                border: none;
                font-size: 14px;
                font-weight: bold;
                display: inline-block;
            }
            .btn-save:hover {
                background-color: #218838;
            }
        </style>
    </head>
    <body>

        <input type="checkbox" id="createModalToggle" class="modal-toggle">

        <c:forEach var="item" items="${farmingPracticeList}">
            <input type="checkbox" id="editToggle-${item.maQuyTrinh}" class="modal-toggle">
            <input type="checkbox" id="stageToggle-${item.maQuyTrinh}" class="modal-toggle">
        </c:forEach>

        <jsp:include page="/views/common/sidebar.jsp">
            <jsp:param name="activePage" value="technician" />
        </jsp:include>

        <div class="main-wrapper">
            <jsp:include page="/views/common/header.jsp">
                <jsp:param name="pageTitle" value="Thiết Lập Quy Trình" />
            </jsp:include>

            <main class="content-area">
                <div class="section-header">
                    <h2 class="section-title">Danh sách bộ quy chuẩn canh tác</h2>

                    <div class="header-actions">
                        <form action="${pageContext.request.contextPath}/technician" method="GET" class="search-form">
                            <input type="hidden" name="action" value="search">
                            <input type="text" name="keyword" class="search-input" placeholder="Nhập ID hoặc tên quy trình..." value="${param.keyword}">
                            <button type="submit" class="btn-search">Tìm kiếm</button>
                        </form>

                        <label for="createModalToggle" class="btn-add">+ Tạo bộ quy chuẩn</label>
                    </div>
                </div>

                <div class="table-container">
                    <div class="data-info">Số lượng quy trình lấy được: ${farmingPracticeList != null ? farmingPracticeList.size() : 0}</div>
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên Quy Trình</th>
                                <th>Đối Tượng Áp Dụng</th>
                                <th>Ngày Tạo</th>
                                <th>Người Tạo</th>
                                <th>Trạng Thái</th>
                                <th>Mô Tả</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${farmingPracticeList}">
                                <tr>
                                    <td>${item.maQuyTrinh}</td>
                                    <td>${item.tenQuyTrinh}</td>
                                    <td>${item.loaiApDung}</td>
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
                                    <td class="desc-column" title="${item.moTa}">${item.moTa != null ? item.moTa : '---'}</td>
                                    <td>
                                        <div class="action-buttons">
                                            <label for="editToggle-${item.maQuyTrinh}" class="btn-action-edit">Sửa</label>

                                            <c:if test="${!item.trangThai}">
                                                <label for="stageToggle-${item.maQuyTrinh}" class="btn-action-stage">Thêm quy trình</label>
                                            </c:if>

                                            <form action="${pageContext.request.contextPath}/technician" method="POST" style="margin: 0;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${item.maQuyTrinh}">
                                                <button type="submit" class="btn-action-delete">Xóa</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty farmingPracticeList}">
                                <tr>
                                    <td colspan="8" style="text-align: center; color: #7f8c8d; padding: 30px;">Chưa có quy trình nào được thiết lập. Hãy bấm nút tạo mới bên trên.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <div class="modal-overlay" id="modalOverlay">
            <div class="modal-container">
                <label for="createModalToggle" class="modal-close">&times;</label>
                <h3 class="modal-title">Tạo bộ quy chuẩn canh tác, sản xuất</h3>

                <form action="${pageContext.request.contextPath}/technician" method="POST">
                    <input type="hidden" name="action" value="create">
                    <div class="form-group">
                        <label for="processName">Tên Quy Trình Quy Chuẩn:</label>
                        <input type="text" id="processName" name="processName" placeholder="Nhập tên bộ quy chuẩn..." required>
                    </div>

                    <div class="form-group">
                        <label for="loaiApDung">Giống cây/Vật nuôi áp dụng:</label>
                        <select id="loaiApDung" name="loaiApDung" required>
                            <option value="">-- Chọn giống cây/vật nuôi --</option>
                            <option value="Lúa">Lúa</option>
                            <option value="Ngô">Ngô</option>
                            <option value="Cà phê">Cà phê</option>
                            <option value="Hồ tiêu">Hồ tiêu</option>
                            <option value="Cao su">Cao su</option>
                            <option value="Bò">Bò</option>
                            <option value="Gà">Gà</option>
                            <option value="Lợn">Lợn</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="description">Mô tả quy trình:</label>
                        <textarea id="description" name="description" rows="5" placeholder="Nhập mô tả tóm tắt cho quy trình canh tác này..." required></textarea>
                    </div>

                    <button type="submit" class="btn-submit">Lưu Khởi Tạo (Bản nháp)</button>

                    <div class="note-panel">
                        * Lưu ý: Quy trình sau khi tạo sẽ nằm ở trạng thái "Bản nháp". Bạn cần phê duyệt để chính thức áp dụng.
                    </div>
                </form>
            </div>
        </div>

        <c:forEach var="item" items="${farmingPracticeList}">
            
            <div class="modal-overlay" id="editModal-${item.maQuyTrinh}">
                <div class="modal-container">
                    <label for="editToggle-${item.maQuyTrinh}" class="modal-close">&times;</label>
                    <h3 class="modal-title" style="color: #2e541f; border-bottom: 2px solid #579c3f; padding-bottom: 10px;">Cập Nhật Quy Trình Canh Tác</h3>

                    <form action="${pageContext.request.contextPath}/technician" method="POST" style="margin-top: 20px;">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${item.maQuyTrinh}">

                        <div class="form-group" style="margin-top: 15px;">
                            <label>ID Quy Trình:</label>
                            <input type="text" value="${item.maQuyTrinh}" disabled style="background: #e9ecef; color: #495057; cursor: not-allowed;">
                        </div>

                        <div class="form-group">
                            <label for="editName-${item.maQuyTrinh}">Tên Quy Trình:</label>
                            <input type="text" id="editName-${item.maQuyTrinh}" name="processName" value="${item.tenQuyTrinh}" required>
                        </div>

                        <div class="form-group">
                            <label for="editLoaiApDung-${item.maQuyTrinh}">Giống cây/Vật nuôi áp dụng:</label>
                            <select id="editLoaiApDung-${item.maQuyTrinh}" name="loaiApDung" required>
                                <option value="Lúa" ${item.loaiApDung == 'Lúa' ? 'selected' : ''}>Lúa</option>
                                <option value="Ngô" ${item.loaiApDung == 'Ngô' ? 'selected' : ''}>Ngô</option>
                                <option value="Cà phê" ${item.loaiApDung == 'Cà phê' ? 'selected' : ''}>Cà phê</option>
                                <option value="Hồ tiêu" ${item.loaiApDung == 'Hồ tiêu' ? 'selected' : ''}>Hồ tiêu</option>
                                <option value="Cao su" ${item.loaiApDung == 'Cao su' ? 'selected' : ''}>Cao su</option>
                                <option value="Bò" ${item.loaiApDung == 'Bò' ? 'selected' : ''}>Bò</option>
                                <option value="Gà" ${item.loaiApDung == 'Gà' ? 'selected' : ''}>Gà</option>
                                <option value="Lợn" ${item.loaiApDung == 'Lợn' ? 'selected' : ''}>Lợn</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="editStatus-${item.maQuyTrinh}">Trạng Thái:</label>
                            <select id="editStatus-${item.maQuyTrinh}" name="status">
                                <option value="false" ${!item.trangThai ? 'selected' : ''}>Bản nháp</option>
                                <option value="true" ${item.trangThai ? 'selected' : ''}>Hoạt động</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="editDesc-${item.maQuyTrinh}">Mô tả quy trình:</label>
                            <textarea id="editDesc-${item.maQuyTrinh}" name="description" rows="5" required>${item.moTa}</textarea>
                        </div>

                        <div style="text-align: right; margin-top: 25px; gap: 10px; display: flex; justify-content: flex-end;">
                            <label for="editToggle-${item.maQuyTrinh}" class="btn-cancel">Hủy</label>
                            <button type="submit" class="btn-save">Lưu Cập Nhật</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="modal-overlay" id="stageModal-${item.maQuyTrinh}">
                <div class="modal-container">
                    <label for="stageToggle-${item.maQuyTrinh}" class="modal-close">&times;</label>
                    <h3 class="modal-title" style="color: #2e541f; border-bottom: 2px solid #579c3f; padding-bottom: 10px;">
                        Thiết lập lộ trình: <span>${item.tenQuyTrinh}</span>
                    </h3>

                    <form action="${pageContext.request.contextPath}/technician" method="POST" style="margin-top: 20px;">
                        <input type="hidden" name="farmingPracticeId" value="${item.maQuyTrinh}">

                        <div class="form-group">
                            <label>Tên giai đoạn:</label>
                            <input type="text" name="stageName" placeholder="Ví dụ: Giai đoạn ngâm ủ mầm..." required>
                        </div>

                        <div class="grid-2-cols">
                            <div class="form-group">
                                <label>Ngày bắt đầu:</label>
                                <input type="number" name="startDay" min="1" required>
                            </div>
                            <div class="form-group">
                                <label>Ngày kết thúc:</label>
                                <input type="number" name="endDay" min="1" required>
                            </div>
                        </div>

                        <div class="grid-7-5-cols">
                            <div class="form-group">
                                <label>Tên vật tư (Đồng bộ từ CSDL):</label>
                                <select name="supplyId" required>
                                    <option value="">-- Chọn vật tư --</option>
                                    <c:forEach var="sup" items="${suppliesList}">
                                        <option value="${sup.id}">${sup.name} (Mã: ${sup.id})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Định lượng vật tư:</label>
                                <div class="input-group-custom">
                                    <input type="number" step="0.01" name="quantity" required>
                                    <select name="unit">
                                        <option value="kg">kg</option>
                                        <option value="g">g</option>
                                        <option value="con">con</option>
                                        <option value="lít">lít</option>
                                        <option value="bao">bao</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Mô tả:</label>
                            <textarea name="description" rows="3" placeholder="Ghi chú thêm về quy trình thực hiện..."></textarea>
                        </div>

                        <div style="text-align: right; margin-top: 25px; gap: 10px; display: flex; justify-content: flex-end;">
                            <label for="stageToggle-${item.maQuyTrinh}" class="btn-cancel">Đóng</label>
                            <button type="submit" name="action" value="saveStage" class="btn-save">Lưu giai đoạn</button>
                            <button type="submit" name="action" value="publishProcess" class="btn-action-delete" style="border: none; padding: 10px 20px; font-size: 14px;">Ban hành</button>
                        </div>
                    </form>
                </div>
            </div>

        </c:forEach>

    </body>
</html>