<%-- 
    Document   : inventory_management
    Created on : Jun 30, 2026
    Author     : Nguyen Hoang Anh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý kho vật tư</title>
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

            .header {
                height: 85px;
                background: rgba(255, 255, 255, 0.85);
                backdrop-filter: blur(20px);
                border-bottom: 1px solid rgba(255, 255, 255, 0.4);
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 40px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                z-index: 5;
            }
            .header-title h1 {
                margin: 0;
                font-size: 26px;
                font-weight: 800;
                color: #1a2419;
            }
            .user-profile {
                display: flex;
                align-items: center;
                gap: 20px;
            }
            .notification {
                position: relative;
                cursor: pointer;
                width: 45px;
                height: 45px;
                background: rgba(87, 156, 63, 0.1);
                border-radius: 50%;
                display: flex;
                justify-content: center;
                align-items: center;
                transition: background 0.3s;
            }
            .notification:hover {
                background: rgba(87, 156, 63, 0.2);
            }
            .notification svg {
                width: 22px;
                height: 22px;
                fill: #2e541f;
            }
            .badge {
                position: absolute;
                top: 2px;
                right: 2px;
                background-color: #e74c3c;
                color: white;
                font-size: 11px;
                font-weight: 800;
                padding: 3px 6px;
                border-radius: 12px;
                min-width: 10px;
                min-height: 12px;
                display: flex;
                justify-content: center;
                align-items: center;
            }
            .avatar {
                width: 45px;
                height: 45px;
                background: linear-gradient(135deg, #579c3f, #2e541f);
                color: #ffffff;
                border-radius: 12px;
                display: flex;
                justify-content: center;
                align-items: center;
                font-weight: 800;
                font-size: 18px;
                cursor: pointer;
                box-shadow: 0 4px 10px rgba(46, 84, 31, 0.3);
            }

            .content-area {
                flex: 1;
                padding: 40px;
                overflow-y: auto;
            }

            .page-toolbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
            }
            .page-toolbar h2 {
                margin: 0;
                color: #ffffff;
                font-size: 24px;
                font-weight: 700;
                text-shadow: 0 2px 4px rgba(0,0,0,0.5);
            }

            /* ================= THANH TÌM KIẾM ================= */
            .search-box {
                display: flex;
                align-items: center;
                background: white;
                border-radius: 8px;
                padding: 4px 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }
            .search-box input {
                border: none;
                outline: none;
                padding: 8px 10px;
                width: 250px;
                font-size: 14px;
            }
            .btn-search {
                background: #f39c12;
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
                transition: 0.3s;
            }
            .btn-search:hover {
                background: #e67e22;
            }

            .btn-add {
                background: linear-gradient(135deg, #579c3f, #396728);
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 8px;
                font-size: 15px;
                font-weight: bold;
                cursor: pointer;
                box-shadow: 0 4px 15px rgba(87, 156, 63, 0.4);
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .btn-add:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(87, 156, 63, 0.6);
            }

            .table-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(15px);
                border-radius: 16px;
                padding: 25px;
                border: 1px solid rgba(255, 255, 255, 0.6);
                box-shadow: 0px 8px 32px rgba(0, 0, 0, 0.15);
                overflow-x: auto;
            }
            table {
                width: 100%;
                border-collapse: collapse;
            }
            th, td {
                padding: 16px;
                text-align: left;
                border-bottom: 1px solid rgba(0, 0, 0, 0.08);
            }
            th {
                color: #4a5c43;
                font-weight: 700;
                text-transform: uppercase;
                font-size: 13px;
            }
            td {
                color: #1a2419;
                font-weight: 500;
                font-size: 14px;
            }

            .status-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 700;
                display: inline-block;
            }
            .status-active {
                background: #e8f5e9;
                color: #2e7d32;
            }
            .status-locked {
                background: #ffebee;
                color: #c62828;
            }
            .category-badge {
                background: #f1f2f6;
                color: #2f3542;
                padding: 6px 10px;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 600;
                border: 1px solid #dfe4ea;
            }

            .action-btns {
                display: flex;
                gap: 8px;
            }
            .btn-action {
                border: none;
                padding: 8px 12px;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                color: white;
                transition: 0.2s;
                text-decoration: none;
            }
            .btn-edit {
                background: #f39c12;
            }
            .btn-edit:hover {
                background: #e67e22;
            }
            .btn-delete {
                background: #e74c3c;
            }
            .btn-delete:hover {
                background: #c0392b;
            }

            /* ================= MODAL ================= */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.6);
                z-index: 100;
                display: none;
                justify-content: center;
                align-items: center;
                backdrop-filter: blur(5px);
            }
            .modal-content {
                background: white;
                width: 550px;
                max-width: 90%;
                border-radius: 16px;
                padding: 30px;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
                animation: slideIn 0.3s ease-out;
                max-height: 90vh;
                overflow-y: auto;
            }
            @keyframes slideIn {
                from {
                    transform: translateY(-30px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                border-bottom: 1px solid #eee;
                padding-bottom: 10px;
            }
            .modal-header h3 {
                margin: 0;
                color: #2e541f;
                font-size: 20px;
                font-weight: 700;
            }
            .close-btn {
                background: none;
                border: none;
                font-size: 24px;
                cursor: pointer;
                color: #999;
            }
            .close-btn:hover {
                color: #e74c3c;
            }

            .form-row {
                display: flex;
                gap: 15px;
            }
            .form-row .form-group {
                flex: 1;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #444;
                font-size: 14px;
            }
            .form-control {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                box-sizing: border-box;
                transition: 0.3s;
                font-family: inherit;
            }
            .form-control:focus {
                outline: none;
                border-color: #579c3f;
                box-shadow: 0 0 0 3px rgba(87,156,63,0.1);
            }
            textarea.form-control {
                resize: vertical;
                min-height: 80px;
            }

            .modal-footer {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                margin-top: 25px;
            }
            .btn-cancel {
                padding: 10px 20px;
                background: #f1f2f6;
                color: #333;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
            }
            .btn-cancel:hover {
                background: #dfe4ea;
            }
            .btn-save {
                padding: 10px 20px;
                background: #579c3f;
                color: white;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
            }
            .btn-save:hover {
                background: #467e32;
            }
        </style>
    </head>
    <body>

        <jsp:include page="/views/common/sidebar.jsp">
            <jsp:param name="activePage" value="inventoryManager" />
        </jsp:include>

        <div class="main-wrapper">
            <jsp:include page="/views/common/header.jsp">
                <jsp:param name="pageTitle" value="Quản Lý Kho Vật Tư" />
            </jsp:include>
          

            <main class="content-area">
                <div class="page-toolbar">
                    <h2>Danh sách vật tư</h2>

                    <%-- THANH TÌM KIẾM THEO GIAO DIỆN MỚI --%>
                    <div style="display: flex; align-items: center; gap: 15px;">
                        <div class="search-box">
                            <input type="text" id="searchInput" placeholder="Nhập tên hoặc ID vật tư..." onkeydown="if (event.key === 'Enter')
                                        openSearchModal()">
                            <button class="btn-search" onclick="openSearchModal()">🔍 Tìm kiếm</button>
                        </div>

                        <button class="btn-add" onclick="openSupplieForm('add')">
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="white"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
                            Thêm vật tư
                        </button>
                    </div>
                </div>

                <div class="table-card">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên vật tư</th>
                                <th>Loại vật tư</th>
                                <th>Đơn vị tính</th>
                                <th>Tồn kho</th>
                                <th>Đơn giá</th>
                                <th>Ngày nhập</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <%-- CẤP ID CHO TBODY ĐỂ JS LẤY DỮ LIỆU ĐỔ VÀO MODAL TÌM KIẾM --%>
                        <tbody id="mainTableBody">
                            <c:forEach var="item" items="${LIST_SUPPLIE}">
                                <tr>
                                    <td>${item.maVatTu}</td>
                                    <td><strong>${item.tenVatTu}</strong></td>
                                    <td><span class="category-badge">${item.loaiVatTu}</span></td>
                                    <td>${item.donViTinh}</td>
                                    <td>${item.soLuongTon}</td>
                                    <td>${item.donGia}</td>
                                    <td>${fn:substring(item.ngayNhapGanNhat, 0, 10)}</td>
                                    <td>
                                        <span class="status-badge ${item.trangThai ? 'status-active' : 'status-locked'}">
                                            ${item.trangThai ? 'Hoạt động' : 'Ngừng'}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="btn-action btn-edit" title="Sửa" onclick="openSupplieForm('edit')">Sửa</button>
                                            <a href="${pageContext.request.contextPath}/inventory?action=delete&id=${item.maVatTu}" class="btn-action btn-delete" title="Xóa" onclick="return confirm('Bạn có chắc muốn xóa vật tư này?')">Xóa</a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty LIST_SUPPLIE}">
                                <tr>
                                    <td colspan="9" style="text-align: center; color: #7f8c8d; padding: 20px;">Kho vật tư hiện đang trống. Vui lòng thêm vật tư mới!</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <%-- MODAL KẾT QUẢ TÌM KIẾM --%>
        <div class="modal-overlay" id="searchModal">
            <div class="modal-content" style="width: 1000px; max-width: 95%;"> 
                <div class="modal-header">
                    <h3>Kết quả Tìm kiếm</h3>
                    <button class="close-btn" onclick="closeModal('searchModal')">&times;</button>
                </div>

                <div class="table-card" style="box-shadow: none; border: 1px solid #ddd; padding: 10px; max-height: 400px; overflow-y: auto;">
                    <table style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên vật tư</th>
                                <th>Loại vật tư</th>
                                <th>Đơn vị tính</th>
                                <th>Tồn kho</th>
                                <th>Đơn giá</th>
                                <th>Ngày nhập</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <%-- Tbody rỗng, JS sẽ nhét kết quả vào đây --%>
                        <tbody id="searchResultBody">

                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Modal Form Thêm/Sửa -->
        <div class="modal-overlay" id="supplieModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="supplieModalTitle">Thêm vật tư mới</h3>
                    <button class="close-btn" onclick="closeModal('supplieModal')">&times;</button>
                </div>
                <form action="${pageContext.request.contextPath}/inventory" method="POST">
                    <input type="hidden" name="action" id="formAction" value="add">
                    <input type="hidden" name="maVatTu" id="maVatTu">

                    <div class="form-group">
                        <label>Tên vật tư</label>
                        <input type="text" name="tenVatTu" id="tenVatTu" class="form-control" placeholder="Nhập tên vật tư" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Loại vật tư</label>
                            <select name="loaiVatTu" id="loaiVatTu" class="form-control" required>
                                <option value="" disabled selected>-- Chọn loại --</option>
                                <option value="Phân bón">Phân bón</option>
                                <option value="Hạt giống">Hạt giống</option>
                                <option value="Thuốc BVTV">Thuốc BVTV</option>
                                <option value="Dụng cụ">Dụng cụ nông nghiệp</option>
                                <option value="Khác">Khác</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Đơn vị tính</label>
                            <input type="text" name="donViTinh" id="donViTinh" class="form-control" placeholder="Ví dụ: Kg, Lít, Bao..." required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Số lượng tồn</label>
                            <input type="number" name="soLuongTon" id="soLuongTon" class="form-control" placeholder="0" min="0" required>
                        </div>
                        <div class="form-group">
                            <label>Đơn giá (VNĐ)</label>
                            <input type="number" step="0.01" name="donGia" id="donGia" class="form-control" placeholder="0.0" min="0" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Ngày nhập gần nhất</label>
                            <input type="datetime-local" name="ngayNhapGanNhat" id="ngayNhapGanNhat" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Trạng thái</label>
                            <select name="trangThai" id="trangThai" class="form-control" required>
                                <option value="true">Đang sử dụng</option>
                                <option value="false">Ngừng sử dụng</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Mô tả vật tư</label>
                        <textarea name="moTa" id="moTa" class="form-control" placeholder="Nhập ghi chú chi tiết về vật tư..."></textarea>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn-cancel" onclick="closeModal('supplieModal')">Hủy bỏ</button>
                        <button type="submit" class="btn-save">Lưu thông tin</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // HÀM MỚI: TÌM KIẾM JS 
            function openSearchModal() {
                // Lấy từ khóa, chuyển thành chữ thường để tìm kiếm
                let keyword = document.getElementById('searchInput').value.trim().toLowerCase();
                let resultBody = document.getElementById('searchResultBody');

                // Xóa dữ liệu kết quả cũ
                resultBody.innerHTML = '';

                if (keyword === '') {
                    alert("Vui lòng nhập tên hoặc ID vật tư để tìm kiếm!");
                    return;
                }

                // Lấy tất cả các dòng <tr> nằm trong <tbody> của bảng gốc
                let mainTableRows = document.querySelectorAll('#mainTableBody tr');
                let matchCount = 0;

                mainTableRows.forEach(row => {
                    // Bỏ qua dòng báo "Kho vật tư trống" nếu có
                    if (row.cells.length > 1) {
                        // Cột 0 là ID, Cột 1 là Tên vật tư
                        let idText = row.cells[0].innerText.toLowerCase();
                        let nameText = row.cells[1].innerText.toLowerCase();

                        // Nếu ID hoặc Tên có chứa từ khóa
                        if (idText.includes(keyword) || nameText.includes(keyword)) {
                            // Copy nguyên dòng đó ném vào Modal
                            let clonedRow = row.cloneNode(true);
                            resultBody.appendChild(clonedRow);
                            matchCount++;
                        }
                    }
                });

                // Nếu không có kết quả
                if (matchCount === 0) {
                    resultBody.innerHTML = '<tr><td colspan="9" style="text-align: center; padding: 25px; color: #c0392b; font-weight: bold;">Không tìm thấy vật tư nào khớp với "' + keyword + '"</td></tr>';
                }

                // Bật Modal tìm kiếm
                document.getElementById('searchModal').style.display = 'flex';
            }

            function openSupplieForm(mode) {
                // Đóng luôn cái modal tìm kiếm nếu đang mở
                closeModal('searchModal');

                const modal = document.getElementById('supplieModal');
                const title = document.getElementById('supplieModalTitle');
                const actionInput = document.getElementById('formAction');

                if (mode === 'add') {
                    title.innerText = 'Thêm vật tư mới';
                    actionInput.value = 'add';
                    modal.querySelector('form').reset();
                } else if (mode === 'edit') {
                    title.innerText = 'Sửa thông tin vật tư';
                    actionInput.value = 'edit';
                }
                modal.style.display = 'flex';
            }

            function closeModal(modalId) {
                document.getElementById(modalId).style.display = 'none';
            }

            window.onclick = function (event) {
                let supplieModal = document.getElementById('supplieModal');
                let searchModal = document.getElementById('searchModal');

                if (event.target == supplieModal)
                    supplieModal.style.display = "none";
                if (event.target == searchModal)
                    searchModal.style.display = "none";
            }
        </script>
    </body>
</html>