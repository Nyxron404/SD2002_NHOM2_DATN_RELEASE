<%-- 
    Document   : equipmentManager
    Author     : (Quản lý thiết bị & Bảo trì - UC-5.1, 5.2, 5.3, 6.1, 6.2)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý thiết bị &amp; bảo trì</title>
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
            .page-toolbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
                flex-wrap: wrap;
                gap: 15px;
            }
            .page-toolbar h2 {
                margin: 0;
                color: #ffffff;
                font-size: 24px;
                font-weight: 700;
                text-shadow: 0 2px 4px rgba(0,0,0,0.5);
            }
            .alert-banner {
                padding: 14px 20px;
                border-radius: 10px;
                margin-bottom: 20px;
                font-weight: 600;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }
            .alert-success {
                background: #e8f5e9;
                color: #2e7d32;
                border-left: 5px solid #2e7d32;
            }
            .alert-error {
                background: #ffebee;
                color: #c62828;
                border-left: 5px solid #c62828;
            }
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
                width: 220px;
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
            }
            .btn-add {
                background: linear-gradient(135deg, #579c3f, #396728);
                color: white;
                border: none;
                padding: 12px 20px;
                border-radius: 8px;
                font-size: 15px;
                font-weight: bold;
                cursor: pointer;
                box-shadow: 0 4px 15px rgba(87, 156, 63, 0.4);
                transition: all 0.3s ease;
            }
            .btn-add:hover {
                transform: translateY(-2px);
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
                padding: 14px;
                text-align: left;
                border-bottom: 1px solid rgba(0, 0, 0, 0.08);
                font-size: 13px;
            }
            th {
                color: #4a5c43;
                font-weight: 700;
                text-transform: uppercase;
                font-size: 12px;
            }
            td {
                color: #1a2419;
                font-weight: 500;
            }
            .status-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 700;
                display: inline-block;
                white-space: nowrap;
            }
            .status-green { background: #e8f5e9; color: #2e7d32; }
            .status-blue  { background: #e3f2fd; color: #1565c0; }
            .status-orange{ background: #fff3e0; color: #e65100; }
            .status-red   { background: #ffebee; color: #c62828; }
            .status-gray  { background: #f1f2f6; color: #57606f; }

            .action-btns { display: flex; gap: 8px; flex-wrap: wrap; }
            .btn-action {
                border: none;
                padding: 7px 11px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
                color: white;
            }
            .btn-edit { background: #f39c12; }
            .btn-edit:hover { background: #e67e22; }
            .btn-borrow { background: #2980b9; }
            .btn-borrow:hover { background: #1f5f8b; }
            .btn-return { background: #8e44ad; }
            .btn-return:hover { background: #6c3483; }
            .btn-complete { background: #16a085; }
            .btn-complete:hover { background: #0e7a63; }

            .modal-overlay {
                position: fixed;
                top: 0; left: 0;
                width: 100%; height: 100%;
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
                max-height: 90vh;
                overflow-y: auto;
            }
            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                border-bottom: 1px solid #eee;
                padding-bottom: 10px;
            }
            .modal-header h3 { margin: 0; color: #2e541f; font-size: 20px; font-weight: 700; }
            .close-btn { background: none; border: none; font-size: 24px; cursor: pointer; color: #999; }
            .close-btn:hover { color: #e74c3c; }

            .form-row { display: flex; gap: 15px; }
            .form-row .form-group { flex: 1; }
            .form-group { margin-bottom: 15px; }
            .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #444; font-size: 14px; }
            .form-control {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                box-sizing: border-box;
                font-family: inherit;
            }
            .form-control:focus { outline: none; border-color: #579c3f; box-shadow: 0 0 0 3px rgba(87,156,63,0.1); }
            textarea.form-control { resize: vertical; min-height: 70px; }

            .modal-footer { display: flex; justify-content: flex-end; gap: 10px; margin-top: 25px; }
            .btn-cancel {
                padding: 10px 20px; background: #f1f2f6; color: #333;
                border: none; border-radius: 8px; font-weight: 600; cursor: pointer;
            }
            .btn-cancel:hover { background: #dfe4ea; }
            .btn-save {
                padding: 10px 20px; background: #579c3f; color: white;
                border: none; border-radius: 8px; font-weight: 600; cursor: pointer;
            }
            .btn-save:hover { background: #467e32; }

            .view-tabs { display: flex; gap: 12px; margin-bottom: 20px; }
            .tab-btn {
                padding: 12px 24px;
                background: rgba(255, 255, 255, 0.85);
                color: #2e541f;
                border-radius: 10px;
                text-decoration: none;
                font-weight: 700;
                font-size: 14px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            }
            .tab-btn.tab-active {
                background: linear-gradient(135deg, #579c3f, #396728);
                color: #ffffff;
            }
        </style>
    </head>
    <body>

        <jsp:include page="/views/common/sidebar.jsp">
            <jsp:param name="activePage" value="equipmentManager" />
        </jsp:include>

        <div class="main-wrapper">
            <jsp:include page="/views/common/header.jsp">
                <jsp:param name="pageTitle" value="Quản Lý Thiết Bị & Bảo Trì" />
            </jsp:include>

            <main class="content-area">

                <div class="view-tabs">
                    <a href="${pageContext.request.contextPath}/equipmentManager?view=equipment"
                       class="tab-btn ${ACTIVE_VIEW == 'equipment' ? 'tab-active' : ''}">🛠 Danh sách thiết bị</a>
                    <a href="${pageContext.request.contextPath}/equipmentManager?view=maintenance"
                       class="tab-btn ${ACTIVE_VIEW == 'maintenance' ? 'tab-active' : ''}">🔧 Lịch bảo trì</a>
                    <a href="${pageContext.request.contextPath}/equipmentManager?view=usage"
                       class="tab-btn ${ACTIVE_VIEW == 'usage' ? 'tab-active' : ''}">📖 Lịch sử sử dụng</a>
                </div>

                <c:if test="${not empty SUCCESS_MSG}">
                    <div class="alert-banner alert-success">✔ ${SUCCESS_MSG}</div>
                </c:if>
                <c:if test="${not empty ERROR_MSG}">
                    <div class="alert-banner alert-error">✖ ${ERROR_MSG}</div>
                </c:if>

                <%-- ===================== TAB 1: DANH SÁCH THIẾT BỊ (UC-5.1, UC-5.2) ===================== --%>
                <c:if test="${ACTIVE_VIEW == 'equipment'}">
                    <div class="page-toolbar">
                        <h2>Danh sách thiết bị</h2>
                        <div style="display: flex; align-items: center; gap: 12px; flex-wrap: wrap;">
                            <form class="search-box" action="${pageContext.request.contextPath}/equipmentManager" method="GET">
                                <input type="hidden" name="view" value="equipment">
                                <input type="text" name="keyword" placeholder="Nhập tên hoặc mã thiết bị..." value="${KEYWORD}">
                                <button type="submit" class="btn-search">🔍 Tìm</button>
                            </form>
                            <button class="btn-add" onclick="openModal('addEquipmentModal')">+ Thêm thiết bị</button>
                        </div>
                    </div>

                    <div class="table-card">
                        <table>
                            <thead>
                                <tr>
                                    <th>Mã TB</th>
                                    <th>Tên thiết bị</th>
                                    <th>Loại</th>
                                    <th>Ngày mua</th>
                                    <th>Giá trị</th>
                                    <th>Chu kỳ BT (tháng)</th>
                                    <th>Tình trạng</th>
                                    <th>Mô tả</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="equip" items="${LIST_EQUIPMENT}">
                                    <tr>
                                        <td>${equip.getMaThietBi()}</td>
                                        <td><strong>${fn:escapeXml(equip.getTenThietBi())}</strong></td>
                                        <td>${fn:escapeXml(equip.getLoaiThietBi())}</td>
                                        <td>${equip.getNgayMua()}</td>
                                        <td><fmt:formatNumber value="${equip.getGiaTri()}" pattern="#,###"/></td>
                                        <td>${equip.getChuKyBaoTriThang()}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${equip.getTinhTrang() == 'Sẵn sàng'}"><span class="status-badge status-green">Sẵn sàng</span></c:when>
                                                <c:when test="${equip.getTinhTrang() == 'Đang sử dụng'}"><span class="status-badge status-blue">Đang sử dụng</span></c:when>
                                                <c:when test="${equip.getTinhTrang() == 'Bảo trì'}"><span class="status-badge status-orange">Bảo trì</span></c:when>
                                                <c:when test="${equip.getTinhTrang() == 'Hỏng'}"><span class="status-badge status-red">Hỏng</span></c:when>
                                                <c:otherwise><span class="status-badge status-gray">${equip.getTinhTrang()}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${fn:escapeXml(equip.getMoTa())}</td>
                                        <td>
                                            <div class="action-btns">
                                                <button class="btn-action btn-edit"
                                                        data-id="${equip.getMaThietBi()}"
                                                        data-trangthai="${equip.getTinhTrang()}"
                                                        onclick="openStatusModal(this)">Đổi trạng thái</button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty LIST_EQUIPMENT}">
                                    <tr><td colspan="9" style="text-align:center; color:#7f8c8d; padding:20px;">Chưa có thiết bị nào.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <%-- ===================== TAB 2: LỊCH BẢO TRÌ (UC-6.1, UC-6.2) ===================== --%>
                <c:if test="${ACTIVE_VIEW == 'maintenance'}">
                    <div class="page-toolbar">
                        <h2>Lịch bảo trì thiết bị</h2>
                        <button class="btn-add" onclick="openModal('addScheduleModal')">+ Lập lịch bảo trì</button>
                    </div>

                    <div class="table-card">
                        <table>
                            <thead>
                                <tr>
                                    <th>Mã BT</th>
                                    <th>Thiết bị</th>
                                    <th>Ngày dự kiến</th>
                                    <th>Nội dung dự kiến</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày thực tế</th>
                                    <th>Chi phí</th>
                                    <th>Kết quả</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ms" items="${LIST_SCHEDULE}">
                                    <tr>
                                        <td>${ms.getMaBaoTri()}</td>
                                        <td><strong>${fn:escapeXml(ms.getTenThietBi())}</strong></td>
                                        <td>${ms.getNgayDuKien()}</td>
                                        <td>${fn:escapeXml(ms.getNoiDungDuKien())}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${ms.getTrangThai() == 'Đã hoàn thành'}"><span class="status-badge status-green">Đã hoàn thành</span></c:when>
                                                <c:when test="${ms.getTrangThai() == 'Đến hạn'}"><span class="status-badge status-orange">Đến hạn</span></c:when>
                                                <c:when test="${ms.getTrangThai() == 'Đang thực hiện'}"><span class="status-badge status-blue">Đang thực hiện</span></c:when>
                                                <c:otherwise><span class="status-badge status-gray">${ms.getTrangThai()}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${ms.getNgayThucTe()}</td>
                                        <td>${ms.getChiPhi()}</td>
                                        <td>${fn:escapeXml(ms.getKetQua())}</td>
                                        <td>
                                            <c:if test="${ms.getTrangThai() != 'Đã hoàn thành'}">
                                                <button class="btn-action btn-complete"
                                                        data-id="${ms.getMaBaoTri()}"
                                                        onclick="openCompleteModal(this)">Ghi nhận kết quả</button>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty LIST_SCHEDULE}">
                                    <tr><td colspan="9" style="text-align:center; color:#7f8c8d; padding:20px;">Chưa có lịch bảo trì nào.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <%-- ===================== TAB 3: LỊCH SỬ SỬ DỤNG (UC-5.3) ===================== --%>
                <c:if test="${ACTIVE_VIEW == 'usage'}">
                    <div class="page-toolbar">
                        <h2>Lịch sử sử dụng thiết bị</h2>
                        <button class="btn-add" onclick="openModal('borrowModal')">+ Lập phiếu sử dụng</button>
                    </div>

                    <div class="table-card">
                        <table>
                            <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th>Thiết bị</th>
                                    <th>Người mượn</th>
                                    <th>Khu vực</th>
                                    <th>Bắt đầu</th>
                                    <th>Kết thúc</th>
                                    <th>Tổng giờ SD</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="bo" items="${LIST_USAGE}">
                                    <tr>
                                        <td>${bo.getMaMuonThietBi()}</td>
                                        <td><strong>${fn:escapeXml(bo.getTenThietBi())}</strong></td>
                                        <td>${fn:escapeXml(bo.getHoTenNhanVien())}</td>
                                        <td>${fn:escapeXml(bo.getTenKhuVuc())}</td>
                                        <td>${bo.getThoiGianBatDau()}</td>
                                        <td>${bo.getThoiGianKetThuc()}</td>
                                        <td>${bo.getTongThoiGianSuDung()}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${bo.getTrangThai() == 'Đang sử dụng'}"><span class="status-badge status-blue">Đang sử dụng</span></c:when>
                                                <c:when test="${bo.getTrangThai() == 'Đã trả'}"><span class="status-badge status-green">Đã trả</span></c:when>
                                                <c:otherwise><span class="status-badge status-gray">${bo.getTrangThai()}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${bo.getTrangThai() == 'Đang sử dụng'}">
                                                <button class="btn-action btn-return"
                                                        data-id="${bo.getMaMuonThietBi()}"
                                                        onclick="openReturnModal(this)">Xác nhận trả</button>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty LIST_USAGE}">
                                    <tr><td colspan="9" style="text-align:center; color:#7f8c8d; padding:20px;">Chưa có lịch sử sử dụng nào.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </c:if>

            </main>
        </div>

        <%-- ===================== MODAL: THÊM THIẾT BỊ (UC-5.1) ===================== --%>
        <div class="modal-overlay" id="addEquipmentModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Thêm thiết bị mới</h3>
                    <button class="close-btn" onclick="closeModal('addEquipmentModal')">&times;</button>
                </div>
                <form action="${pageContext.request.contextPath}/equipmentManager" method="POST">
                    <input type="hidden" name="action" value="addEquipment">
                    <div class="form-group">
                        <label>Tên thiết bị</label>
                        <input type="text" name="tenThietBi" class="form-control" required>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Loại thiết bị</label>
                            <input type="text" name="loaiThietBi" class="form-control" placeholder="Vd: Máy móc, Dụng cụ...">
                        </div>
                        <div class="form-group">
                            <label>Ngày mua</label>
                            <input type="date" name="ngayMua" class="form-control" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Giá trị (VNĐ)</label>
                            <input type="number" step="0.01" min="0" name="giaTri" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Chu kỳ bảo trì (tháng)</label>
                            <input type="number" min="1" name="chuKyBaoTriThang" class="form-control" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Mô tả</label>
                        <textarea name="moTa" class="form-control" placeholder="Mô tả chi tiết để dễ nhận diện thiết bị..."></textarea>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-cancel" onclick="closeModal('addEquipmentModal')">Hủy</button>
                        <button type="submit" class="btn-save">Lưu thiết bị</button>
                    </div>
                </form>
            </div>
        </div>

        <%-- ===================== MODAL: ĐỔI TRẠNG THÁI (UC-5.2) ===================== --%>
        <div class="modal-overlay" id="statusModal">
            <div class="modal-content" style="width: 420px;">
                <div class="modal-header">
                    <h3>Cập nhật tình trạng thiết bị</h3>
                    <button class="close-btn" onclick="closeModal('statusModal')">&times;</button>
                </div>
                <form action="${pageContext.request.contextPath}/equipmentManager" method="POST">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="maThietBi" id="statusMaThietBi">
                    <div class="form-group">
                        <label>Trạng thái mới</label>
                        <select name="tinhTrangMoi" id="statusSelect" class="form-control" required>
                            <option value="Sẵn sàng">Sẵn sàng</option>
                            <option value="Đang sử dụng">Đang sử dụng</option>
                            <option value="Bảo trì">Bảo trì</option>
                            <option value="Hỏng">Hỏng</option>
                        </select>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-cancel" onclick="closeModal('statusModal')">Hủy</button>
                        <button type="submit" class="btn-save">Cập nhật</button>
                    </div>
                </form>
            </div>
        </div>

        <%-- ===================== MODAL: LẬP LỊCH BẢO TRÌ (UC-6.1) ===================== --%>
        <div class="modal-overlay" id="addScheduleModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Lập lịch bảo trì định kỳ</h3>
                    <button class="close-btn" onclick="closeModal('addScheduleModal')">&times;</button>
                </div>
                <form action="${pageContext.request.contextPath}/equipmentManager" method="POST">
                    <input type="hidden" name="action" value="addSchedule">
                    <div class="form-group">
                        <label>Thiết bị</label>
                        <select name="maThietBi" class="form-control" required>
                            <option value="" disabled selected>-- Chọn thiết bị --</option>
                            <c:forEach var="equip" items="${LIST_EQUIPMENT}">
                                <option value="${equip.getMaThietBi()}">${fn:escapeXml(equip.getTenThietBi())}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Ngày bảo trì dự kiến</label>
                            <input type="date" name="ngayDuKien" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Chi phí dự kiến (VNĐ)</label>
                            <input type="number" step="0.01" min="0" name="chiPhiDuKien" class="form-control">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Hạng mục cần kiểm tra</label>
                        <textarea name="noiDungDuKien" class="form-control" required></textarea>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-cancel" onclick="closeModal('addScheduleModal')">Hủy</button>
                        <button type="submit" class="btn-save">Lưu lịch</button>
                    </div>
                </form>
            </div>
        </div>

        <%-- ===================== MODAL: GHI NHẬN KẾT QUẢ BẢO TRÌ (UC-6.2) ===================== --%>
        <div class="modal-overlay" id="completeModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Ghi nhận kết quả bảo trì</h3>
                    <button class="close-btn" onclick="closeModal('completeModal')">&times;</button>
                </div>
                <form action="${pageContext.request.contextPath}/equipmentManager" method="POST">
                    <input type="hidden" name="action" value="completeSchedule">
                    <input type="hidden" name="maBaoTri" id="completeMaBaoTri">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Ngày hoàn thành thực tế</label>
                            <input type="date" name="ngayThucTe" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Chi phí thực tế (VNĐ)</label>
                            <input type="number" step="0.01" min="0" name="chiPhiThucTe" class="form-control" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Nội dung đã sửa chữa / thay thế</label>
                        <textarea name="noiDungThucTe" class="form-control"></textarea>
                    </div>
                    <div class="form-group">
                        <label>Kết quả</label>
                        <input type="text" name="ketQua" class="form-control" placeholder="Vd: Hoàn thành tốt, đã thay lọc dầu...">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-cancel" onclick="closeModal('completeModal')">Hủy</button>
                        <button type="submit" class="btn-save">Lưu kết quả</button>
                    </div>
                </form>
            </div>
        </div>

        <%-- ===================== MODAL: LẬP PHIẾU SỬ DỤNG (UC-5.3) ===================== --%>
        <div class="modal-overlay" id="borrowModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Lập phiếu sử dụng thiết bị</h3>
                    <button class="close-btn" onclick="closeModal('borrowModal')">&times;</button>
                </div>
                <form action="${pageContext.request.contextPath}/equipmentManager" method="POST">
                    <input type="hidden" name="action" value="borrow">
                    <div class="form-group">
                        <label>Thiết bị (chỉ hiện thiết bị đang Sẵn sàng)</label>
                        <select name="maThietBi" class="form-control" required>
                            <option value="" disabled selected>-- Chọn thiết bị --</option>
                            <c:forEach var="equip" items="${LIST_EQUIPMENT}">
                                <c:if test="${equip.getTinhTrang() == 'Sẵn sàng'}">
                                    <option value="${equip.getMaThietBi()}">${fn:escapeXml(equip.getTenThietBi())}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                    <%-- TODO: đổi thành <select> khi có FarmAreaDAO để lấy danh sách khu vực --%>
                    <div class="form-group">
                        <label>Mã khu vực sử dụng</label>
                        <input type="number" name="maKhuVuc" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Tình trạng thiết bị trước khi dùng</label>
                        <input type="text" name="tinhTrangTruocKhiDung" class="form-control" placeholder="Vd: Hoạt động tốt">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-cancel" onclick="closeModal('borrowModal')">Hủy</button>
                        <button type="submit" class="btn-save">Lập phiếu</button>
                    </div>
                </form>
            </div>
        </div>

        <%-- ===================== MODAL: XÁC NHẬN TRẢ THIẾT BỊ (UC-5.3) ===================== --%>
        <div class="modal-overlay" id="returnModal">
            <div class="modal-content" style="width: 460px;">
                <div class="modal-header">
                    <h3>Xác nhận trả thiết bị</h3>
                    <button class="close-btn" onclick="closeModal('returnModal')">&times;</button>
                </div>
                <form action="${pageContext.request.contextPath}/equipmentManager" method="POST">
                    <input type="hidden" name="action" value="returnEquipment">
                    <input type="hidden" name="maMuonThietBi" id="returnMaMuon">
                    <div class="form-group">
                        <label>Tình trạng sau khi sử dụng</label>
                        <select name="tinhTrangSauKhiDung" class="form-control" required>
                            <option value="Hoạt động tốt">Hoạt động tốt</option>
                            <option value="Hỏng">Hỏng</option>
                            <option value="Cần kiểm tra">Cần kiểm tra</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Ghi chú</label>
                        <textarea name="ghiChu" class="form-control"></textarea>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-cancel" onclick="closeModal('returnModal')">Hủy</button>
                        <button type="submit" class="btn-save">Xác nhận trả</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openModal(id) {
                document.getElementById(id).style.display = 'flex';
            }
            function closeModal(id) {
                document.getElementById(id).style.display = 'none';
            }
            function openStatusModal(btn) {
                document.getElementById('statusMaThietBi').value = btn.dataset.id;
                document.getElementById('statusSelect').value = btn.dataset.trangthai;
                openModal('statusModal');
            }
            function openCompleteModal(btn) {
                document.getElementById('completeMaBaoTri').value = btn.dataset.id;
                openModal('completeModal');
            }
            function openReturnModal(btn) {
                document.getElementById('returnMaMuon').value = btn.dataset.id;
                openModal('returnModal');
            }
            window.onclick = function (event) {
                document.querySelectorAll('.modal-overlay').forEach(function (m) {
                    if (event.target === m) {
                        m.style.display = 'none';
                    }
                });
            };
        </script>
    </body>
</html>