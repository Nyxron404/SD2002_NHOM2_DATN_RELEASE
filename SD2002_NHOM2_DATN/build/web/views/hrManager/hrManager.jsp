<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý nhân sự</title>
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

            /* ================= HEADER & MAIN CONTENT ================= */
            .main-wrapper {
                flex: 1;
                display: flex;
                flex-direction: column;
                overflow: hidden;
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

            .content-area {
                flex: 1;
                padding: 40px;
                overflow-y: auto;
            }

            /* ================= HR MANAGEMENT STYLES ================= */
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

            /* THANH TÌM KIẾM */
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
                color: green;
                font-weight: 700;
                text-transform: uppercase;
                font-size: 14px;
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

            .role-badge {
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
            .btn-role {
                background: #3498db;
            }
            .btn-role:hover {
                background: #2980b9;
            }
            .btn-lock {
                background: #e74c3c;
            }
            .btn-lock:hover {
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
                width: 500px;
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

            .modal-footer {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                margin-top: 25px;
            }
            .btn-cancel, .btn-save {
                padding: 10px 20px;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
            }
            .btn-cancel {
                background: #f1f2f6;
                color: #333;
            }
            .btn-cancel:hover {
                background: #dfe4ea;
            }
            .btn-save {
                background: #579c3f;
                color: white;
            }
            .btn-save:hover {
                background: #467e32;
            }

            /* Checkbox styles */
            .checkbox-group {
                display: flex;
                flex-direction: column;
                gap: 10px;
                margin-top: 10px;
                background: #f9f9f9;
                padding: 15px;
                border-radius: 8px;
                border: 1px solid #eee;
            }
            .checkbox-group label {
                margin: 0;
                display: flex;
                align-items: center;
                gap: 8px;
                cursor: pointer;
                font-weight: 500;
            }
            .checkbox-group input[type="checkbox"] {
                width: 16px;
                height: 16px;
                cursor: pointer;
            }
            /* ================= TOAST NOTIFICATION ================= */
            .toast {
                position: fixed;
                top: 25px;
                right: 25px;
                padding: 15px 25px;
                border-radius: 8px;
                color: white;
                font-weight: 600;
                font-size: 15px;
                z-index: 9999;
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
                display: flex;
                align-items: center;
                gap: 10px;
                /* Hiệu ứng trượt vào */
                animation: slideInRight 0.5s ease-out forwards;
            }
            .toast.success {
                background-color: #2ecc71;
                border-left: 6px solid #27ae60;
            }
            .toast.error {
                background-color: #e74c3c;
                border-left: 6px solid #c0392b;
            }

            @keyframes slideInRight {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }
            /* Cố định chiều rộng cột mật khẩu để không bị xô lệch */
            .password-cell {
                min-width: 150px;
                display: inline-block;
                vertical-align: middle;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/views/common/sidebar.jsp"><jsp:param name="activePage" value="hrManager" /></jsp:include>
            <div class="main-wrapper">
            <jsp:include page="/views/common/header.jsp"><jsp:param name="pageTitle" value="Quản Lý Nhân Sự" /></jsp:include>
                <main class="content-area">
                    <div class="page-toolbar">
                        <h2>Danh sách nhân viên</h2>
                        <div style="display: flex; align-items: center; gap: 15px;">
                            <form action="hr" method="GET" class="search-box" autocomplete="off">
                                <input type="text" name="keyword" placeholder="Nhập tên hoặc ID..." 
                                       value="${param.keyword}" autocomplete="off">
                            <button type="submit" class="btn-search">🔍 Tìm kiếm</button>
                        </form>
                        <button class="btn-add" onclick="openEmployeeForm('add')">Thêm nhân viên</button>
                    </div>
                </div>

                <div class="table-card">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Họ và Tên</th>
                                <th>Nhóm</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody id="mainTableBody">
                            <c:forEach var="st" items="${LIST_STAFF}">
                                <c:set var="userForStaff" value="${null}" />
                                <c:forEach var="u" items="${LIST_USER}">
                                    <c:if test="${u.maNguoiDung == st.maNguoiDung}">
                                        <c:set var="userForStaff" value="${u}" />
                                    </c:if>
                                </c:forEach>
                                <tr>
                                    <td>${st.getMaNhanVien()}</td>
                                    <td><strong>${st.getHoTen()}</strong></td>
                                    <td>
                                        <c:forEach var="group" items="${LIST_GROUP}">
                                            <c:if test="${group.getMaNhom() == st.getMaNhom()}">${group.getTenNhom()}</c:if>
                                        </c:forEach>
                                    </td>
                                    <td>
                                        <td>
                                        <c:if test="${st.isDangKy()}">
                                            <span class="status-badge ${userForStaff.trangThai ? 'status-active' : 'status-locked'}">
                                                ${userForStaff.trangThai ? 'Bình thường' : 'Đã khóa'}
                                            </span>
                                        </c:if>
                                    </td>
                                    </td>
                                    <td>
                                        <button class="btn-action" style="background: #27ae60;" 
                                                onclick="openDetailModal('${st.getMaNhanVien()}', '${st.getHoTen()}', '${st.getNgaySinh()}', '${st.isGioiTinh() ? 1 : 0}', '${st.getSDT()}', '${st.getEmail()}', '${st.getDiaChi()}', '${st.getNgayVaoLam()}', '${st.getLuong()}', '${st.getMaNguoiDung()}', '${st.getMaNhom()}', '${userForStaff.tenDangNhap}', '${userForStaff.matKhau}', '${st.isDangKy()}')">
                                            Chi tiết
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <c:if test="${not empty param.keyword && empty LIST_STAFF}">
                        <div style="text-align: center; padding: 20px; color: #777;">
                            <p>Không tìm thấy nhân viên phù hợp với từ khóa: <strong>${param.keyword}</strong></p>
                        </div>
                    </c:if>
                </div>
            </main>
        </div>

        <%-- MODAL CHI TIẾT --%>
        <div class="modal-overlay" id="detailModal">
            <div class="modal-content">
                <div class="modal-header"><h3>Chi tiết nhân viên</h3><button class="close-btn" onclick="closeModal('detailModal')">&times;</button></div>
                <div class="detail-info" id="detailContent"></div>
                <div class="modal-footer" id="detailActions" style="justify-content: center; gap: 10px;"></div>
            </div>
        </div>

        <%-- MODAL SỬA/THÊM --%>
        <div class="modal-overlay" id="employeeModal">
            <div class="modal-content">
                <div class="modal-header"><h3 id="employeeModalTitle">Thông tin</h3><button class="close-btn" onclick="closeModal('employeeModal')">&times;</button></div>
                <form action="hr" method="POST" autocomplete="off">
                    <input type="hidden" name="action" id="formAction" value="add"><input type="hidden" name="maNhanVien" id="editEmpId" value="">
                    <div class="form-group"><label>Họ và tên</label><input type="text" name="hoTen" class="form-control" required autocomplete="off"></div>
                    <div class="form-row"><div class="form-group"><label>Ngày sinh</label><input type="date" name="ngaySinh" class="form-control" required autocomplete="off"></div><div class="form-group"><label>Giới tính</label><select name="gioiTinh" class="form-control"><option value="1">Nam</option><option value="0">Nữ</option></select></div></div>
                    <div class="form-row"><div class="form-group"><label>SĐT</label><input type="number" name="sdt" class="form-control" required autocomplete="off"></div><div class="form-group"><label>Email</label><input type="email" name="email" class="form-control" required autocomplete="off"></div></div>
                    <div class="form-group"><label>Địa chỉ</label><input type="text" name="diaChi" class="form-control" required autocomplete="off"></div>
                    <div class="form-group"><label>Lương</label><input type="number" name="luong" class="form-control" required autocomplete="off"></div>
                    <div class="modal-footer"><button type="button" class="btn-cancel" onclick="closeModal('employeeModal')">Hủy</button><button type="submit" class="btn-save">Lưu</button></div>
                </form>
            </div>
        </div>

        <%-- MODAL PHÂN QUYỀN --%>
        <div class="modal-overlay" id="roleModal">
            <div class="modal-content"><div class="modal-header"><h3>Phân Quyền</h3><button class="close-btn" onclick="closeModal('roleModal')">&times;</button></div>
                <form action="hr" method="POST"><input type="hidden" name="action" value="updateRole"><input type="hidden" name="maNhanVien" id="roleEmployeeId"><input type="hidden" name="maNguoiDung" id="roleUserId">
                    <div class="checkbox-group">
                        <c:forEach var="group" items="${LIST_GROUP}"><label><input type="radio" name="selectedGroup" value="${group.getMaNhom()}" required> ${group.getTenNhom()}</label></c:forEach>
                        </div>
                        <div class="modal-footer"><button type="submit" class="btn-save">Lưu</button></div>
                    </form>
                </div>
            </div>

        <%-- MODAL KHÓA --%>
        <div class="modal-overlay" id="lockModal">
            <div class="modal-content"><h3>Khóa tài khoản</h3>
                <form action="hr" method="POST"><input type="hidden" name="action" value="lock"><input type="hidden" name="maNguoiDung" id="lockUserId">
                    <select name="trangThai" class="form-control"><option value="true">Mở</option><option value="false">Khóa</option></select>
                    <div class="modal-footer"><button type="submit" class="btn-save">Lưu</button></div>
                </form>
            </div>
        </div>

        <script>
            function openDetailModal(id, ten, ngaysinh, gioitinh, sdt, email, diachi, ngayVaoLam, luong, maNguoiDung, maNhom, username, password, dangKy) {
                document.getElementById('detailContent').innerHTML =
                        '<p><span class="detail-label">Họ tên:</span> ' + ten + '</p>' +
                        '<p><span class="detail-label">Ngày sinh:</span> ' + ngaysinh + '</p>' +
                        '<p><span class="detail-label">Giới tính:</span> ' + (gioitinh == 1 ? 'Nam' : 'Nữ') + '</p>' +
                        '<p><span class="detail-label">SĐT:</span> ' + sdt + '</p>' +
                        '<p><span class="detail-label">Email:</span> ' + email + '</p>' +
                        '<p><span class="detail-label">Địa chỉ:</span> ' + diachi + '</p>' +
                        '<p><span class="detail-label">Ngày vào làm:</span> ' + ngayVaoLam + '</p>' +
                        '<p><span class="detail-label">Lương:</span> ' + new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(luong) + '</p>' +
                        '<hr>' +
                        '<p><span class="detail-label">Tài khoản:</span> ' + (username && username !== 'null' && username !== '' ? username : 'Chưa có') + '</p>' +
                        '<p><span class="detail-label">Mật khẩu:</span> ' +
                        (password && password !== 'null' && password !== '' ?
                                '<span id="modal-pwd-span">••••••••</span> ' +
                                '<button type="button" style="border:none; background:none; cursor:pointer;" onclick="togglePwd(\'' + password + '\')">👁️</button>'
                                : 'Chưa có') + '</p>' +
                        '<p><span class="detail-label">Trạng thái:</span> ' + (dangKy === 'true' ? 'Đã đăng ký' : 'Chưa đăng ký') + '</p>';

                document.getElementById('detailActions').innerHTML =
                        '<button class="btn-action" style="background:#f39c12;" onclick="openEmployeeForm(\'edit\', \'' + id + '\', \'' + ten + '\', \'' + ngaysinh + '\', \'' + gioitinh + '\', \'' + sdt + '\', \'' + email + '\', \'' + diachi + '\', \'' + luong + '\')">Sửa</button>' +
                        '<button class="btn-action" style="background:#3498db;" onclick="openRoleForm(\'' + id + '\', \'' + maNguoiDung + '\', \'' + maNhom + '\')">Phân Quyền</button>' +
                        '<button class="btn-action" style="background:#e74c3c;" onclick="openLockForm(\'' + maNguoiDung + '\')">Khóa</button>' +
                        '<button class="btn-action" style="background:#c0392b;" onclick="confirmDelete(\'' + id + '\', \'' + maNguoiDung + '\', \'' + ten + '\')">Xóa</button>';
                document.getElementById('detailModal').style.display = 'flex';
            }

            function openEmployeeForm(mode, id, ten, ngaysinh, gioitinh, sdt, email, diachi, luong) {
                closeModal('detailModal');
                const modal = document.getElementById('employeeModal');
                document.getElementById('formAction').value = mode;

                if (mode === 'edit') {
                    // Chế độ Sửa: Điền dữ liệu cũ vào
                    document.getElementById('editEmpId').value = id;
                    modal.querySelector('input[name="hoTen"]').value = ten;
                    modal.querySelector('input[name="ngaySinh"]').value = ngaysinh;
                    modal.querySelector('select[name="gioiTinh"]').value = gioitinh;
                    modal.querySelector('input[name="sdt"]').value = sdt;
                    modal.querySelector('input[name="email"]').value = email;
                    modal.querySelector('input[name="diaChi"]').value = diachi;
                    modal.querySelector('input[name="luong"]').value = luong;
                } else {
                    // Chế độ Thêm: Reset trắng form
                    document.getElementById('editEmpId').value = '';
                    modal.querySelector('input[name="hoTen"]').value = '';
                    modal.querySelector('input[name="ngaySinh"]').value = '';
                    modal.querySelector('select[name="gioiTinh"]').value = '1';
                    modal.querySelector('input[name="sdt"]').value = '';
                    modal.querySelector('input[name="email"]').value = '';
                    modal.querySelector('input[name="diaChi"]').value = '';
                    modal.querySelector('input[name="luong"]').value = '';
                }
                modal.style.display = 'flex';
            }

            function openRoleForm(id, user, group) {
                closeModal('detailModal');
                document.getElementById('roleEmployeeId').value = id;
                document.getElementById('roleUserId').value = user;
                document.getElementById('roleModal').style.display = 'flex';
            }

            function openLockForm(user) {
                closeModal('detailModal');
                document.getElementById('lockUserId').value = user;
                document.getElementById('lockModal').style.display = 'flex';
            }

            function confirmDelete(id, maNguoiDung, ten) {
                if (confirm("Bạn có chắc chắn muốn xóa nhân viên [" + ten + "] không?\nHành động này sẽ XÓA LUÔN TÀI KHOẢN ĐĂNG NHẬP và không thể hoàn tác!")) {
                    // Tạo một form ảo để gửi request xóa lên Servlet
                    var form = document.createElement("form");
                    form.method = "POST";
                    form.action = "hr";

                    var actionInput = document.createElement("input");
                    actionInput.type = "hidden";
                    actionInput.name = "action";
                    actionInput.value = "delete";
                    form.appendChild(actionInput);

                    var idInput = document.createElement("input");
                    idInput.type = "hidden";
                    idInput.name = "maNhanVien";
                    idInput.value = id;
                    form.appendChild(idInput);

                    var userInput = document.createElement("input");
                    userInput.type = "hidden";
                    userInput.name = "maNguoiDung";
                    userInput.value = maNguoiDung;
                    form.appendChild(userInput);

                    document.body.appendChild(form);
                    form.submit();
                }
            }

            function closeModal(id) {
                document.getElementById(id).style.display = 'none';
            }

            window.onclick = function (e) {
                if (e.target.className === 'modal-overlay')
                    e.target.style.display = 'none';
            };
            // Thêm hàm này vào để xử lý ẩn hiện mật khẩu
            function togglePwd(pwd) {
                var span = document.getElementById('modal-pwd-span');
                if (span.innerText === '••••••••') {
                    span.innerText = pwd; // Hiện mật khẩu
                } else {
                    span.innerText = '••••••••'; // Ẩn mật khẩu
                }
            }
            // Thêm đoạn này vào phần script của bạn
            window.addEventListener('DOMContentLoaded', (event) => {
                const toast = document.querySelector('.toast');
                if (toast) {
                    // Sau 5 giây (5000ms) thì ẩn toast
                    setTimeout(() => {
                        toast.style.display = 'none';
                    }, 5000);
                }
            });
        </script>
    </body>
    <c:if test="${not empty toastMessage}"><div class="toast ${toastType}">${toastMessage}</div></c:if>
</html>