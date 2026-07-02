<%-- 
    Document   : inventory_management
    Created on : Jun 30, 2026
    Author     : Nguyen Hoang Anh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Smart Farmer - Quản lý kho vật tư</title>
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

            /* ================= SIDEBAR ================= */
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

            .logo-area svg {
                width: 36px;
                height: 36px;
                filter: drop-shadow(0px 2px 4px rgba(0,0,0,0.15));
            }
            .logo-area h2 {
                margin: 0;
                font-size: 22px;
                font-weight: 850;
                background: linear-gradient(135deg, #1e4512, #467e32);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            .menu {
                list-style: none;
                padding: 25px 0;
                margin: 0;
                flex: 1;
                overflow-y: auto;
            }
            .menu-item {
                padding: 14px 25px;
                display: flex;
                align-items: center;
                gap: 15px;
                color: #1a2419;
                text-decoration: none;
                font-weight: 700;
                font-size: 15px;
                transition: all 0.3s ease;
                border-left: 5px solid transparent;
            }

            .menu-item:hover, .menu-item.active {
                background: linear-gradient(90deg, rgba(87, 156, 63, 0.15) 0%, rgba(255, 255, 255, 0) 100%);
                border-left-color: #579c3f;
                color: #467e32;
            }
            .menu-item svg {
                width: 22px;
                height: 22px;
                fill: currentColor;
            }

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
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
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

            /* ================= PAGE STYLES ================= */
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

            /* ================= MODAL (FORM BẬT LÊN) ================= */
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
            <header class="header">
                <div class="header-title">
                    <h1>Quản Lý Kho Vật Tư</h1>
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

                <div class="page-toolbar">
                    <h2>Danh sách vật tư</h2>
                    <button class="btn-add" onclick="openSupplieForm('add')">
                        <svg viewBox="0 0 24 24" width="20" height="20" fill="white"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
                        Thêm vật tư
                    </button>
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
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>Phân bón NPK</td>
                                <td><span class="category-badge">Phân bón</span></td>
                                <td>Bao</td>
                                <td>150</td>
                                <td>350,000</td>
                                <td>30/06/2026</td>
                                <td><span class="status-badge status-active">Hoạt động</span></td>
                                <td>
                                    <div class="action-btns">
                                        <button class="btn-action btn-edit" title="Sửa" onclick="openSupplieForm('edit')">Sửa</button>
                                        <button class="btn-action btn-delete" title="Xóa">Xóa</button>
                                    </div>
                                </td>
                            </tr>

                            <tr>
                                <td>2</td>
                                <td>Phân bón Kali</td>
                                <td><span class="category-badge">Phân bón</span></td>
                                <td>Bao</td>
                                <td>80</td>
                                <td>420,000</td>
                                <td>02/07/2026</td>
                                <td><span class="status-badge status-active">Hoạt động</span></td>
                                <td>
                                    <div class="action-btns">
                                        <button class="btn-action btn-edit" onclick="openSupplieForm('edit')">Sửa</button>
                                        <button class="btn-action btn-delete">Xóa</button>
                                    </div>
                                </td>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <div class="modal-overlay" id="supplieModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="supplieModalTitle">Thêm vật tư mới</h3>
                    <button class="close-btn" onclick="closeModal('supplieModal')">&times;</button>
                </div>
                <form action="SupplieServlet" method="POST">
                    <input type="hidden" name="action" id="formAction" value="add">
                    <input type="hidden" name="maVatTu" id="maVatTu"> <div class="form-group">
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
            // Hàm mở Form Thêm/Sửa cho Vật Tư
            function openSupplieForm(mode) {
                const modal = document.getElementById('supplieModal');
                const title = document.getElementById('supplieModalTitle');
                const actionInput = document.getElementById('formAction');

                if (mode === 'add') {
                    title.innerText = 'Thêm vật tư mới';
                    actionInput.value = 'add';
                    // Đặt lại rỗng cho toàn bộ input
                    modal.querySelector('form').reset();
                } else if (mode === 'edit') {
                    title.innerText = 'Sửa thông tin vật tư';
                    actionInput.value = 'edit';
                    // Ở đây, bạn có thể thực hiện lấy data qua ID (vd dùng JS DOM hoặc Fetch API) để đổ lại vào form
                }

                modal.style.display = 'flex';
            }

            // Hàm đóng Modal
            function closeModal(modalId) {
                document.getElementById(modalId).style.display = 'none';
            }

            // Bấm ra vùng tối để đóng Modal
            window.onclick = function (event) {
                let supplieModal = document.getElementById('supplieModal');
                if (event.target == supplieModal) {
                    supplieModal.style.display = "none";
                }
            }
        </script>
    </body>
</html>