<%--
    Document   : technician
    Mô tả      : Trang trung tâm của Kỹ thuật viên, chia 4 chức năng lớn qua view-tabs:
                 1) process   - Phân chia công việc & tạo bộ quy trình chuẩn (logic gốc)
                 2) vegetable - Quản lý rau trồng
                 3) harvest   - Quản lý thu hoạch rau
                 4) livestock - Quản lý vật nuôi
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Canh Tác</title>
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
            .content-area { flex: 1; padding: 40px; overflow-y: auto; }

            .alert-banner { padding: 14px 20px; border-radius: 10px; margin-bottom: 20px; font-weight: 600; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
            .alert-success { background: #e8f5e9; color: #2e7d32; border-left: 5px solid #2e7d32; }
            .alert-error { background: #ffebee; color: #c62828; border-left: 5px solid #c62828; }

            .view-tabs { display: flex; gap: 12px; margin-bottom: 20px; flex-wrap: wrap; }
            .tab-btn {
                padding: 12px 22px; background: rgba(255,255,255,0.85); color: #2e541f;
                border-radius: 10px; text-decoration: none; font-weight: 700; font-size: 14px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.08); transition: 0.3s;
            }
            .tab-btn:hover { background: #ffffff; }
            .tab-btn.tab-active { background: linear-gradient(135deg, #579c3f, #396728); color: #fff; box-shadow: 0 4px 15px rgba(87,156,63,0.4); }

            .page-toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 15px; }
            .page-toolbar h2 { margin: 0; color: #fff; font-size: 24px; font-weight: 700; text-shadow: 0 2px 4px rgba(0,0,0,0.5); }

            .search-box { display: flex; align-items: center; background: white; border-radius: 8px; padding: 4px 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
            .search-box input { border: none; outline: none; padding: 8px 10px; width: 200px; font-size: 14px; }
            .btn-search { background: #f39c12; color: white; border: none; padding: 8px 15px; border-radius: 6px; font-weight: 600; cursor: pointer; }
            .btn-search:hover { background: #e67e22; }

            .btn-add { background: linear-gradient(135deg, #579c3f, #396728); color: white; border: none; padding: 12px 20px; border-radius: 8px; font-size: 15px; font-weight: bold; cursor: pointer; box-shadow: 0 4px 15px rgba(87,156,63,0.4); display: flex; align-items: center; gap: 8px; }
            .btn-add:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(87,156,63,0.6); }
            .btn-import { background: linear-gradient(135deg, #2980b9, #1f5f8b); box-shadow: 0 4px 15px rgba(41,128,185,0.4); }
            .btn-export { background: linear-gradient(135deg, #d35400, #a94400); box-shadow: 0 4px 15px rgba(211,84,0,0.4); }

            .table-card { background: rgba(255,255,255,0.95); backdrop-filter: blur(15px); border-radius: 16px; padding: 25px; border: 1px solid rgba(255,255,255,0.6); box-shadow: 0px 8px 32px rgba(0,0,0,0.15); overflow-x: auto; margin-bottom: 20px; }
            table { width: 100%; border-collapse: collapse; }
            th, td { padding: 14px; text-align: left; border-bottom: 1px solid rgba(0,0,0,0.08); }
            th { color: #4a5c43; font-weight: 700; text-transform: uppercase; font-size: 12px; }
            td { color: #1a2419; font-weight: 500; font-size: 14px; }

            .status-badge { padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; display: inline-block; }
            .status-green { background: #e8f5e9; color: #2e7d32; }
            .status-red { background: #ffebee; color: #c62828; }
            .status-gray { background: #f1f2f6; color: #57606f; }
            .status-orange { background: #fff3e0; color: #e65100; }
            .status-blue { background: #e3f2fd; color: #1565c0; }

            .row-disease { background: rgba(231,76,60,0.08); }
            .row-harvestable { background: rgba(46,204,113,0.10); }
            .id-disease { color: #c0392b; font-weight: 800; }
            .id-harvestable { color: #1e8449; font-weight: 800; }

            .action-btns { display: flex; gap: 8px; }
            .btn-action { border: none; padding: 8px 12px; border-radius: 6px; font-size: 13px; font-weight: 600; cursor: pointer; color: white; text-decoration: none; }
            .btn-view { background: #2980b9; }
            .btn-view:hover { background: #1f6391; }
            .btn-edit { background: #f39c12; }
            .btn-edit:hover { background: #e67e22; }
            .btn-harvest { background: #27ae60; }
            .btn-harvest:hover { background: #1e8449; }

            /* ===== MODAL CHUẨN ===== */
            .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); z-index: 100; display: none; justify-content: center; align-items: center; backdrop-filter: blur(5px); }
            .modal-content { background: white; width: 600px; max-width: 92%; border-radius: 16px; padding: 30px; box-shadow: 0 10px 40px rgba(0,0,0,0.3); max-height: 90vh; overflow-y: auto; }
            .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
            .modal-header h3 { margin: 0; color: #2e541f; font-size: 20px; font-weight: 700; }
            .close-btn { background: none; border: none; font-size: 24px; cursor: pointer; color: #999; }
            .close-btn:hover { color: #e74c3c; }

            .form-row { display: flex; gap: 15px; flex-wrap: wrap; }
            .form-row .form-group { flex: 1; min-width: 160px; }
            .form-group { margin-bottom: 15px; }
            .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #444; font-size: 14px; }
            .form-control { width: 100%; padding: 10px 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; box-sizing: border-box; font-family: inherit; }
            .form-control:focus { outline: none; border-color: #579c3f; box-shadow: 0 0 0 3px rgba(87,156,63,0.1); }
            .form-control:disabled { background: #f4f5f7; color: #555; }
            textarea.form-control { resize: vertical; min-height: 70px; }
            .field-hint { font-size: 12px; color: #888; margin-top: 4px; }

            .modal-footer { display: flex; justify-content: space-between; align-items: center; gap: 10px; margin-top: 25px; }
            .modal-footer-right { display:flex; gap:10px; margin-left:auto; }
            .btn-cancel { padding: 10px 20px; background: #f1f2f6; color: #333; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; }
            .btn-cancel:hover { background: #dfe4ea; }
            .btn-save { padding: 10px 20px; background: #579c3f; color: white; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; }
            .btn-save:hover { background: #467e32; }
            .btn-warning { padding: 10px 20px; background: #e67e22; color: white; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; }
            .btn-warning:hover { background: #d35400; }

            .filter-row { flex-wrap: wrap; align-items: flex-end; }
            .filter-row .form-group { min-width: 160px; margin-bottom: 0; }
            .btn-clear-filter { display: inline-block; text-align: center; text-decoration: none; padding: 10px 20px; border-radius: 8px; background: #f1f2f6; color: #333; font-weight: 600; white-space: nowrap; }
            .btn-clear-filter:hover { background: #dfe4ea; }

            /* ===== Danh sách rau/vật nuôi để chọn thu hoạch/nhập/xuất ===== */
            .mini-table th, .mini-table td { padding: 10px 12px; font-size: 13px; }

            /* ===== Biểu đồ cột tự vẽ ===== */
            .chart-wrapper { display: flex; }
            .chart-y-axis { display: flex; flex-direction: column; justify-content: space-between; height: 280px; padding-right: 10px; font-size: 12px; color: #666; text-align: right; }
            .chart-plot { flex: 1; display: flex; align-items: flex-end; gap: 18px; height: 280px; border-left: 2px solid #ccc; border-bottom: 2px solid #ccc; padding: 0 15px; position: relative; overflow-x: auto; }
            .chart-bar-col { display: flex; flex-direction: column; align-items: center; min-width: 60px; }
            .chart-bar { width: 42px; background: linear-gradient(180deg, #6fce54, #2e7d32); border-radius: 6px 6px 0 0; position: relative; transition: 0.3s; }
            .chart-bar-value { font-size: 12px; font-weight: 700; color: #1a2419; margin-bottom: 4px; }
            .chart-bar-label { margin-top: 8px; font-size: 12px; color: #444; font-weight: 600; text-align: center; max-width: 70px; word-break: break-word; }

            .detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 0 15px; }
        </style>
    </head>
    <body>

        <jsp:include page="/views/common/sidebar.jsp">
            <jsp:param name="activePage" value="technician" />
        </jsp:include>

        <div class="main-wrapper">
            <jsp:include page="/views/common/header.jsp">
                <jsp:param name="pageTitle" value="Quản Lý Canh Tác" />
            </jsp:include>

            <main class="content-area">

                <div class="view-tabs">
                    <a href="${pageContext.request.contextPath}/technician?view=process"
                       class="tab-btn ${ACTIVE_VIEW == 'process' ? 'tab-active' : ''}">🗂 Phân công &amp; Quy trình chuẩn</a>
                    <a href="${pageContext.request.contextPath}/technician?view=vegetable"
                       class="tab-btn ${ACTIVE_VIEW == 'vegetable' ? 'tab-active' : ''}">🥬 Quản lý rau trồng</a>
                    <a href="${pageContext.request.contextPath}/technician?view=harvest"
                       class="tab-btn ${ACTIVE_VIEW == 'harvest' ? 'tab-active' : ''}">🧺 Quản lý thu hoạch</a>
                    <a href="${pageContext.request.contextPath}/technician?view=livestock"
                       class="tab-btn ${ACTIVE_VIEW == 'livestock' ? 'tab-active' : ''}">🐄 Quản lý vật nuôi</a>
                </div>

                <c:if test="${not empty SUCCESS_MSG}"><div class="alert-banner alert-success">✔ ${SUCCESS_MSG}</div></c:if>
                <c:if test="${not empty ERROR_MSG}"><div class="alert-banner alert-error">✖ ${ERROR_MSG}</div></c:if>

                <%-- ========================================================= --%>
                <%-- 1) PHÂN CHIA CÔNG VIỆC & TẠO BỘ QUY TRÌNH CHUẨN            --%>
                <%-- ========================================================= --%>
                <c:if test="${ACTIVE_VIEW == 'process'}">
                    <div class="page-toolbar">
                        <h2>Phân chia công việc &amp; Bộ quy trình chuẩn</h2>
                        <div style="display:flex; gap:12px; flex-wrap:wrap;">
                            <form action="${pageContext.request.contextPath}/technician" method="GET" style="display:flex;">
                                <input type="hidden" name="view" value="process">
                                <div class="search-box">
                                    <input type="text" name="keyword" value="${keyword}" placeholder="Tìm quy trình theo tên/ID...">
                                    <button type="submit" name="action" value="search" class="btn-search">🔍 Tìm</button>
                                </div>
                            </form>

                            <!-- NÚT BẤM KÍCH HOẠT PHÂN CÔNG -->
                            <button class="btn-add" id="openModalBtn">
                                + Phân công công việc mới
                            </button>

                            <button class="btn-add" onclick="openProcessForm('add')">+ Tạo bộ quy trình</button>
                        </div>
                    </div>

                    <div class="table-card">
                        <table>
                            <thead>
                                <tr>
                                    <th>Mã</th><th>Tên quy trình</th><th>Loại áp dụng</th><th>Ngày tạo</th><th>Trạng thái</th><th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="fp" items="${farmingPracticeList}">
                                    <tr>
                                        <td><strong>${fp.getMaQuyTrinh()}</strong></td>
                                        <td>${fn:escapeXml(fp.getTenQuyTrinh())}</td>
                                        <td>${fn:escapeXml(fp.getLoaiApDung())}</td>
                                        <td>${fp.getNgayTao()}</td>
                                        <td>
                                            <span class="status-badge ${fp.isTrangThai() ? 'status-green' : 'status-gray'}">
                                                ${fp.isTrangThai() ? 'Đã ban hành' : 'Bản nháp'}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="action-btns">
                                                <button class="btn-action btn-edit"
                                                        data-id="${fp.getMaQuyTrinh()}"
                                                        data-ten="${fn:escapeXml(fp.getTenQuyTrinh())}"
                                                        data-mota="${fn:escapeXml(fp.getMoTa())}"
                                                        data-loai="${fn:escapeXml(fp.getLoaiApDung())}"
                                                        data-trangthai="${fp.isTrangThai()}"
                                                        onclick="openProcessForm('edit', this)">Sửa</button>
                                                <a class="btn-action btn-view"
                                                   href="#" onclick="openStageForm(${fp.getMaQuyTrinh()}); return false;">Giai đoạn</a>
                                                <a class="btn-action" style="background:#e74c3c;"
                                                   href="${pageContext.request.contextPath}/technician?view=process"
                                                   onclick="return confirmDeleteProcess(${fp.getMaQuyTrinh()})">Xóa</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty farmingPracticeList}">
                                    <tr><td colspan="6" style="text-align:center;color:#7f8c8d;padding:20px;">Chưa có quy trình nào.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- MODAL FORM PHÂN CÔNG CÔNG VIỆC -->
                    <div class="modal-overlay" id="modalOverlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>Khởi tạo và Phân công việc</h3>
                                <button class="close-btn" id="closeModalBtn">&times;</button>
                            </div>

                            <form action="${pageContext.request.contextPath}/technician" method="POST">
                                <input type="hidden" name="action" value="assignTask">
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="maKhuVuc">Chọn Lô Đất / Khu Vực:</label>
                                        <select id="maKhuVuc" name="maKhuVuc" class="form-control" required>
                                            <option value="">-- Chọn khu vực --</option>
                                            <c:forEach var="area" items="${farmAreaList}">
                                                <option value="${area.getMaKhuVuc()}">${area.getTenKhuVuc()}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label for="maQuyTrinh">Quy Trình Mẫu Áp Dụng:</label>
                                        <select id="maQuyTrinh" name="maQuyTrinh" class="form-control" required>
                                            <option value="">-- Tự động gợi ý quy trình --</option>
                                            <c:forEach var="practice" items="${farmingPracticeList}">
                                                <option value="${practice.getMaQuyTrinh()}">${practice.getTenQuyTrinh()}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="tenCongViec">Tên Công Việc Nhiệm Vụ:</label>
                                    <input type="text" id="tenCongViec" name="tenCongViec" class="form-control" placeholder="Nhập tên nhiệm vụ cụ thể..." required>
                                </div>

                                <div class="form-group">
                                    <label for="moTa">Mô Tả Chi Tiết Hướng Dẫn:</label>
                                    <textarea id="moTa" name="moTa" class="form-control" placeholder="Ghi chú các bước thực hiện nếu có..."></textarea>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="nguoiPhuTrach">Chọn Công Nhân Phụ Trách:</label>
                                        <select id="nguoiPhuTrach" name="nguoiPhuTrach" class="form-control" required>
                                            <option value="">-- Chọn công nhân --</option>
                                            <c:forEach var="worker" items="${workerList}">
                                                <option value="${worker.getMaNguoiDung()}">${worker.getHoTen()} (Mã: ${worker.getMaNguoiDung()})</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="ngayBatDau">Ngày Bắt Đầu:</label>
                                        <input type="date" id="ngayBatDau" name="ngayBatDau" class="form-control" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="ngayKetThuc">Hạn Chót (Ngày Kết Thúc):</label>
                                        <input type="date" id="ngayKetThuc" name="ngayKetThuc" class="form-control" required>
                                    </div>
                                </div>

                                <div class="modal-footer">
                                    <div class="field-hint" style="text-align:left; flex:1;">
                                        * Hệ thống tích hợp cơ chế tự động quét lịch để tránh trùng lặp, quá tải ngày làm việc của công nhân.
                                    </div>
                                    <div class="modal-footer-right">
                                        <button type="button" class="btn-cancel" id="closeModalBtn2">Hủy bỏ</button>
                                        <button type="submit" class="btn-save">Xác Nhận Giao Việc</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <%-- Modal thêm/sửa quy trình --%>
                    <div class="modal-overlay" id="processModal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3 id="processModalTitle">Tạo bộ quy trình mới</h3>
                                <button class="close-btn" onclick="closeModal('processModal')">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/technician" method="POST">
                                <input type="hidden" name="action" id="processAction" value="create">
                                <input type="hidden" name="id" id="processId">
                                <div class="form-group">
                                    <label>Tên quy trình</label>
                                    <input type="text" name="processName" id="processName" class="form-control" required>
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label>Loại áp dụng</label>
                                        <input type="text" name="loaiApDung" id="processLoaiApDung" class="form-control" placeholder="VD: Rau ăn lá, Cây ăn quả..." required>
                                    </div>
                                    <div class="form-group" id="processStatusGroup" style="display:none;">
                                        <label>Trạng thái</label>
                                        <select name="status" id="processStatus" class="form-control">
                                            <option value="true">Đã ban hành</option>
                                            <option value="false">Bản nháp</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Mô tả</label>
                                    <textarea name="description" id="processDescription" class="form-control"></textarea>
                                </div>
                                <div class="modal-footer">
                                    <div class="modal-footer-right">
                                        <button type="button" class="btn-cancel" onclick="closeModal('processModal')">Hủy bỏ</button>
                                        <button type="submit" class="btn-save">Lưu</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <%-- Modal thêm giai đoạn quy trình --%>
                    <div class="modal-overlay" id="stageModal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>Thêm giai đoạn quy trình</h3>
                                <button class="close-btn" onclick="closeModal('stageModal')">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/technician" method="POST">
                                <input type="hidden" name="action" value="saveStage">
                                <input type="hidden" name="farmingPracticeId" id="stagePracticeId">
                                <div class="form-group">
                                    <label>Tên giai đoạn</label>
                                    <input type="text" name="stageName" class="form-control" required>
                                </div>
                                <div class="form-row">
                                    <div class="form-group"><label>Ngày bắt đầu</label><input type="date" name="startDay" class="form-control" required></div>
                                    <div class="form-group"><label>Ngày kết thúc</label><input type="date" name="endDay" class="form-control" required></div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label>Vật tư sử dụng</label>
                                        <select name="maVatTu" class="form-control" required>
                                            <option value="" disabled selected>-- Chọn vật tư --</option>
                                            <c:forEach var="s" items="${suppliesList}">
                                                <option value="${s.getMaVatTu()}">${fn:escapeXml(s.getTenVatTu())}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-group"><label>Định lượng</label><input type="number" step="0.01" name="quantity" class="form-control" required></div>
                                    <div class="form-group"><label>Đơn vị</label><input type="text" name="unit" class="form-control" required></div>
                                </div>
                                <div class="form-group"><label>Mô tả</label><textarea name="description" class="form-control"></textarea></div>
                                <div class="modal-footer">
                                    <div class="modal-footer-right">
                                        <button type="button" class="btn-cancel" onclick="closeModal('stageModal')">Đóng</button>
                                        <button type="submit" name="publishAfterSave" class="btn-save">Lưu giai đoạn</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <form id="deleteProcessForm" action="${pageContext.request.contextPath}/technician" method="POST" style="display:none;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" id="deleteProcessId">
                    </form>
                </c:if>

                <%-- ========================================================= --%>
                <%-- 2) QUẢN LÝ RAU TRỒNG                                        --%>
                <%-- ========================================================= --%>
                <c:if test="${ACTIVE_VIEW == 'vegetable'}">
                    <div class="page-toolbar">
                        <h2>Quản lý rau trồng</h2>
                        <button class="btn-add" onclick="openAddVegetable()">+ Thêm rau trồng</button>
                    </div>

                    <div class="table-card" style="margin-bottom:15px;">
                        <div class="form-row" style="align-items:flex-end;">
                            <form action="${pageContext.request.contextPath}/technician" method="GET" style="display:flex; gap:10px; flex:1;">
                                <input type="hidden" name="view" value="vegetable">
                                <div class="search-box" style="flex:1;">
                                    <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo tên rau..." style="width:100%;">
                                    <button type="submit" name="action" value="search" class="btn-search">🔍</button>
                                </div>
                            </form>
                        </div>
                        <form action="${pageContext.request.contextPath}/technician" method="GET" class="form-row filter-row" style="margin-top:15px;">
                            <input type="hidden" name="view" value="vegetable">
                            <input type="hidden" name="action" value="filter">
                            <div class="form-group">
                                <label>Khu vực</label>
                                <select name="maKhuVuc" class="form-control">
                                    <option value="">-- Tất cả --</option>
                                    <c:forEach var="fa" items="${farmAreaList}">
                                        <option value="${fa.getMaKhuVuc()}" ${filterMaKhuVuc == fa.getMaKhuVuc() ? 'selected' : ''}>${fn:escapeXml(fa.getTenKhuVuc())}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Ngày gieo</label>
                                <input type="date" name="ngayGieo" class="form-control" value="${filterNgayGieo}">
                            </div>
                            <div class="form-group">
                                <label>Trạng thái</label>
                                <select name="trangThai" class="form-control">
                                    <option value="">-- Tất cả (mặc định) --</option>
                                    <option value="Đang trồng" ${filterTrangThai == 'Đang trồng' ? 'selected' : ''}>Đang trồng</option>
                                    <option value="Bị bệnh" ${filterTrangThai == 'Bị bệnh' ? 'selected' : ''}>Bị bệnh</option>
                                    <option value="Có thể thu hoạch" ${filterTrangThai == 'Có thể thu hoạch' ? 'selected' : ''}>Có thể thu hoạch</option>
                                    <option value="Chết" ${filterTrangThai == 'Chết' ? 'selected' : ''}>Chết</option>
                                    <option value="Đã thu hoạch hết" ${filterTrangThai == 'Đã thu hoạch hết' ? 'selected' : ''}>Đã thu hoạch hết</option>
                                </select>
                            </div>
                            <div class="form-group"><button type="submit" class="btn-add">🔍 Lọc</button></div>
                            <div class="form-group"><a href="${pageContext.request.contextPath}/technician?view=vegetable" class="btn-clear-filter">Xóa lọc</a></div>
                        </form>
                    </div>

                    <div class="table-card">
                        <table>
                            <thead>
                                <tr><th>Mã rau</th><th>Tên rau</th><th>Khu vực</th><th>Ngày gieo</th><th>Trạng thái</th><th>Hành động</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="v" items="${LIST_VEGETABLE}">
                                    <c:set var="rowClass" value="" />
                                    <c:set var="idClass" value="" />
                                    <c:set var="badgeClass" value="status-gray" />
                                    <c:if test="${v.getTrangThai() == 'Bị bệnh'}"><c:set var="rowClass" value="row-disease" /><c:set var="idClass" value="id-disease" /><c:set var="badgeClass" value="status-red" /></c:if>
                                    <c:if test="${v.getTrangThai() == 'Có thể thu hoạch'}"><c:set var="rowClass" value="row-harvestable" /><c:set var="idClass" value="id-harvestable" /><c:set var="badgeClass" value="status-green" /></c:if>
                                    <c:if test="${v.getTrangThai() == 'Đang trồng'}"><c:set var="badgeClass" value="status-blue" /></c:if>
                                    <c:if test="${v.getTrangThai() == 'Chết' || v.getTrangThai() == 'Đã thu hoạch hết'}"><c:set var="badgeClass" value="status-gray" /></c:if>
                                    <tr class="${rowClass}">
                                        <td class="${idClass}">${v.getMaRau()}</td>
                                        <td><strong>${fn:escapeXml(v.getTenRau())}</strong></td>
                                        <td>${fn:escapeXml(v.getTenKhuVuc())}</td>
                                        <td>${v.getNgayGieo()}</td>
                                        <td><span class="status-badge ${badgeClass}">${v.getTrangThai()}</span></td>
                                        <td>
                                            <div class="action-btns">
                                                <button class="btn-action btn-view" onclick="openVegetableDetail(${v.getMaRau()})">Xem chi tiết</button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty LIST_VEGETABLE}">
                                    <tr><td colspan="6" style="text-align:center;color:#7f8c8d;padding:20px;">Không có rau trồng nào khớp điều kiện.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <%-- Dữ liệu ẩn JSON cho từng rau để JS đổ vào modal chi tiết (tránh gọi AJAX) --%>
                    <div id="vegetableDataStore" style="display:none;">
                        <c:forEach var="v" items="${LIST_VEGETABLE}">
                            <div class="veg-data"
                                 data-id="${v.getMaRau()}"
                                 data-ten="${fn:escapeXml(v.getTenRau())}"
                                 data-loai="${fn:escapeXml(v.getLoaiRau())}"
                                 data-giong="${fn:escapeXml(v.getGiong())}"
                                 data-makhuvuc="${v.getMaKhuVuc()}"
                                 data-tenkhuvuc="${fn:escapeXml(v.getTenKhuVuc())}"
                                 data-ngaygieo="${v.getNgayGieo()}"
                                 data-ngaythuhoach="${v.getNgayThuHoachDuKien()}"
                                 data-dientich="${v.getDienTich()}"
                                 data-soluong="${v.getSoLuong()}"
                                 data-trangthai="${v.getTrangThai()}"
                                 data-ghichu="${fn:escapeXml(v.getGhiChu())}"></div>
                        </c:forEach>
                    </div>

                    <%-- Modal thêm rau trồng --%>
                    <div class="modal-overlay" id="addVegetableModal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>Thêm rau trồng mới</h3>
                                <button class="close-btn" onclick="closeModal('addVegetableModal')">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/technician" method="POST">
                                <input type="hidden" name="action" value="addVegetable">
                                <div class="form-row">
                                    <div class="form-group"><label>Tên rau</label><input type="text" name="tenRau" class="form-control" required></div>
                                    <div class="form-group"><label>Loại rau</label><input type="text" name="loaiRau" class="form-control" required></div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group"><label>Giống</label><input type="text" name="giong" class="form-control" required></div>
                                    <div class="form-group">
                                        <label>Khu vực</label>
                                        <select name="maKhuVuc" class="form-control" required>
                                            <option value="" disabled selected>-- Chọn khu vực --</option>
                                            <c:forEach var="fa" items="${farmAreaList}">
                                                <option value="${fa.getMaKhuVuc()}">${fn:escapeXml(fa.getTenKhuVuc())}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group"><label>Ngày gieo</label><input type="date" name="ngayGieo" class="form-control" required></div>
                                    <div class="form-group"><label>Ngày dự kiến thu hoạch</label><input type="date" name="ngayThuHoachDuKien" class="form-control" required></div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group"><label>Diện tích (m²)</label><input type="number" step="0.01" min="0" name="dienTich" class="form-control" required></div>
                                    <div class="form-group"><label>Số lượng</label><input type="number" min="0" name="soLuong" class="form-control" required></div>
                                </div>
                                <div class="form-group"><label>Ghi chú</label><textarea name="ghiChu" class="form-control" placeholder="Có thể bỏ trống"></textarea></div>
                                <div class="field-hint">Trạng thái mặc định khi thêm mới: <strong>Đang trồng</strong>.</div>
                                <div class="modal-footer">
                                    <div class="modal-footer-right">
                                        <button type="button" class="btn-cancel" onclick="closeModal('addVegetableModal')">Hủy bỏ</button>
                                        <button type="submit" class="btn-save">Lưu</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <%-- Modal xem chi tiết / chỉnh sửa rau trồng --%>
                    <div class="modal-overlay" id="vegetableDetailModal">
                        <div class="modal-content" style="width:640px;">
                            <div class="modal-header">
                                <h3>Chi tiết rau trồng #<span id="dv_MaRau"></span></h3>
                                <button class="close-btn" onclick="closeModal('vegetableDetailModal')">&times;</button>
                            </div>
                            <form id="vegetableEditForm" action="${pageContext.request.contextPath}/technician" method="POST">
                                <input type="hidden" name="action" value="editVegetable">
                                <input type="hidden" name="maRau" id="dv_MaRau_input">

                                <div class="form-row">
                                    <div class="form-group"><label>Tên rau</label><input type="text" name="tenRau" id="dv_TenRau" class="form-control" disabled required></div>
                                    <div class="form-group"><label>Loại rau</label><input type="text" name="loaiRau" id="dv_LoaiRau" class="form-control" disabled required></div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group"><label>Giống</label><input type="text" name="giong" id="dv_Giong" class="form-control" disabled required></div>
                                    <div class="form-group">
                                        <label>Khu vực</label>
                                        <select name="maKhuVuc" id="dv_MaKhuVuc" class="form-control" disabled required>
                                            <c:forEach var="fa" items="${farmAreaList}">
                                                <option value="${fa.getMaKhuVuc()}">${fn:escapeXml(fa.getTenKhuVuc())} (Mã ${fa.getMaKhuVuc()})</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group"><label>Ngày gieo</label><input type="date" name="ngayGieo" id="dv_NgayGieo" class="form-control" disabled required></div>
                                    <div class="form-group"><label>Ngày dự kiến thu hoạch</label><input type="date" name="ngayThuHoachDuKien" id="dv_NgayThuHoachDuKien" class="form-control" disabled required></div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group"><label>Diện tích (m²)</label><input type="number" step="0.01" name="dienTich" id="dv_DienTich" class="form-control" disabled required></div>
                                    <div class="form-group"><label>Số lượng</label><input type="number" name="soLuong" id="dv_SoLuong" class="form-control" disabled required></div>
                                </div>
                                <div class="form-group">
                                    <label>Trạng thái</label>
                                    <select name="trangThai" id="dv_TrangThai" class="form-control" disabled required>
                                        <option value="Đang trồng">Đang trồng</option>
                                        <option value="Bị bệnh">Bị bệnh</option>
                                        <option value="Có thể thu hoạch">Có thể thu hoạch</option>
                                        <option value="Chết">Chết</option>
                                        <option value="Đã thu hoạch hết">Đã thu hoạch hết</option>
                                    </select>
                                </div>
                                <div class="form-group"><label>Ghi chú</label><textarea name="ghiChu" id="dv_GhiChu" class="form-control" disabled></textarea></div>

                                <div class="modal-footer">
                                    <button type="button" class="btn-warning" id="dv_CancelBtn" style="display:none;" onclick="cancelVegetableEdit()">Hủy chỉnh sửa</button>
                                    <div class="modal-footer-right">
                                        <button type="button" class="btn-edit btn-action" id="dv_EditBtn" style="padding:10px 20px;" onclick="enableVegetableEdit()">Chỉnh sửa</button>
                                        <button type="submit" class="btn-save" id="dv_SaveBtn" style="display:none;">Lưu thay đổi</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:if>

                <%-- ========================================================= --%>
                <%-- 3) QUẢN LÝ THU HOẠCH                                    --%>
                <%-- ========================================================= --%>
                <c:if test="${ACTIVE_VIEW == 'harvest'}">
                    <div class="page-toolbar">
                        <h2>Quản lý thu hoạch</h2>
                        <div style="display:flex; gap:10px; flex-wrap:wrap;">
                            <button class="btn-add" onclick="openHarvestPicker()">🧺 Thu hoạch rau</button>
                            <button class="btn-add btn-import" onclick="openHarvestLiveStockPicker()">🐄 Thu hoạch vật nuôi</button>
                        </div>
                    </div>

                    <div class="table-card" style="margin-bottom:15px;">
                        <form action="${pageContext.request.contextPath}/technician" method="GET" class="form-row filter-row">
                            <input type="hidden" name="view" value="harvest">
                            <input type="hidden" name="action" value="filter">
                            <div class="form-group"><label>Từ ngày</label><input type="date" name="tuNgay" class="form-control" value="${filterTuNgay}"></div>
                            <div class="form-group"><label>Đến ngày</label><input type="date" name="denNgay" class="form-control" value="${filterDenNgay}"></div>
                            <div class="form-group">
                                <label>Số lượng thu hoạch</label>
                                <select name="soLuongMoc" class="form-control">
                                    <option value="">-- Tất cả --</option>
                                    <option value="duoi50" ${filterSoLuongMoc == 'duoi50' ? 'selected' : ''}>Dưới 50</option>
                                    <option value="50-200" ${filterSoLuongMoc == '50-200' ? 'selected' : ''}>50 - 200</option>
                                    <option value="200-500" ${filterSoLuongMoc == '200-500' ? 'selected' : ''}>200 - 500</option>
                                    <option value="tren500" ${filterSoLuongMoc == 'tren500' ? 'selected' : ''}>Trên 500</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Giá trị ước tính</label>
                                <select name="giaTriMoc" class="form-control">
                                    <option value="">-- Tất cả --</option>
                                    <option value="duoi1tr" ${filterGiaTriMoc == 'duoi1tr' ? 'selected' : ''}>Dưới 1 triệu</option>
                                    <option value="1-5tr" ${filterGiaTriMoc == '1-5tr' ? 'selected' : ''}>1 - 5 triệu</option>
                                    <option value="5-10tr" ${filterGiaTriMoc == '5-10tr' ? 'selected' : ''}>5 - 10 triệu</option>
                                    <option value="tren10tr" ${filterGiaTriMoc == 'tren10tr' ? 'selected' : ''}>Trên 10 triệu</option>
                                </select>
                            </div>
                            <div class="form-group"><button type="submit" class="btn-add">🔍 Lọc</button></div>
                            <div class="form-group"><a href="${pageContext.request.contextPath}/technician?view=harvest" class="btn-clear-filter">Xóa lọc</a></div>
                        </form>
                    </div>

                    <div class="table-card">
                        <table>
                            <thead>
                                <tr><th>Mã thu hoạch</th><th>Tên rau</th><th>Ngày thu hoạch</th><th>Giá trị ước tính</th><th>Hành động</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="h" items="${LIST_HARVEST}">
                                    <tr>
                                        <td><strong>${h.getMaThuHoach()}</strong></td>
                                        <td>${fn:escapeXml(h.getTenRau())}</td>
                                        <td>${h.getNgayThuHoach()}</td>
                                        <td>${h.getGiaTriUocTinh()} VNĐ</td>
                                        <td><button class="btn-action btn-view" onclick="openHarvestDetail(${h.getMaThuHoach()})">Xem chi tiết</button></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty LIST_HARVEST}">
                                    <tr><td colspan="5" style="text-align:center;color:#7f8c8d;padding:20px;">Chưa có phiếu thu hoạch nào.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <%-- Biểu đồ cột: tổng số lượng đã thu hoạch theo tên rau --%>
                    <div class="table-card">
                        <h3 style="margin-top:0;color:#2e541f;">📊 Sản lượng thu hoạch theo loại rau</h3>
                        <c:if test="${empty CHART_DATA}">
                            <p style="color:#7f8c8d;">Chưa có dữ liệu để hiển thị biểu đồ.</p>
                        </c:if>
                        <c:if test="${not empty CHART_DATA}">
                            <div id="harvestChart" class="chart-wrapper"></div>
                        </c:if>
                    </div>

                    <%-- Dữ liệu ẩn cho modal chi tiết phiếu thu hoạch --%>
                    <div id="harvestDataStore" style="display:none;">
                        <c:forEach var="h" items="${LIST_HARVEST}">
                            <div class="harvest-data"
                                 data-id="${h.getMaThuHoach()}"
                                 data-marau="${h.getMaRau()}"
                                 data-tenrau="${fn:escapeXml(h.getTenRau())}"
                                 data-ngay="${h.getNgayThuHoach()}"
                                 data-soluong="${h.getSoLuongThuHoach()}"
                                 data-chatluong="${fn:escapeXml(h.getChatLuong())}"
                                 data-giatri="${h.getGiaTriUocTinh()}"
                                 data-nguoithuhoach="${fn:escapeXml(h.getTenNguoiThuHoach())}"
                                 data-ghichu="${fn:escapeXml(h.getGhiChu())}"></div>
                        </c:forEach>
                    </div>

                    <%-- Modal 1: chọn rau có thể thu hoạch --%>
                    <div class="modal-overlay" id="harvestPickerModal">
                        <div class="modal-content" style="width:700px;">
                            <div class="modal-header">
                                <h3>Chọn rau để thu hoạch</h3>
                                <button class="close-btn" onclick="closeModal('harvestPickerModal')">&times;</button>
                            </div>
                            <table class="mini-table">
                                <thead><tr><th>Mã rau</th><th>Tên rau</th><th>Trạng thái</th><th></th></tr></thead>
                                <tbody>
                                    <c:forEach var="v" items="${HARVESTABLE_VEGETABLE_LIST}">
                                        <tr>
                                            <td>${v.getMaRau()}</td>
                                            <td>${fn:escapeXml(v.getTenRau())}</td>
                                            <td><span class="status-badge status-green">${v.getTrangThai()}</span></td>
                                            <td>
                                                <button type="button" class="btn-action btn-harvest"
                                                        onclick="openHarvestForm(${v.getMaRau()}, '${fn:escapeXml(v.getTenRau())}', ${v.getSoLuong()})">Thu hoạch</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty HARVESTABLE_VEGETABLE_LIST}">
                                        <tr><td colspan="4" style="text-align:center;color:#7f8c8d;padding:15px;">Hiện chưa có rau nào có thể thu hoạch.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                            <div class="modal-footer"><div class="modal-footer-right"><button type="button" class="btn-cancel" onclick="closeModal('harvestPickerModal')">Đóng</button></div></div>
                        </div>
                    </div>

                    <%-- Modal 2: form nhập thông tin thu hoạch --%>
                    <div class="modal-overlay" id="harvestFormModal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>Thu hoạch: <span id="hf_TenRau"></span></h3>
                                <button class="close-btn" onclick="closeModal('harvestFormModal')">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/technician" method="POST" id="harvestForm">
                                <input type="hidden" name="action" value="harvestVegetable">
                                <input type="hidden" name="maRau" id="hf_MaRau">
                                <div class="form-row">
                                    <div class="form-group"><label>Ngày thu hoạch</label><input type="date" name="ngayThuHoach" class="form-control" required></div>
                                    <div class="form-group">
                                        <label>Số lượng thu hoạch</label>
                                        <input type="number" name="soLuongThuHoach" id="hf_SoLuong" class="form-control" min="1" required oninput="checkHarvestQty()">
                                        <div class="field-hint">Số lượng gốc hiện có: <strong id="hf_SoLuongGoc"></strong>. Chỉ được thu hoạch nhỏ hơn hoặc bằng số lượng này và phải khác 0.</div>
                                        <div class="field-hint" id="hf_QtyWarning" style="color:#c0392b; font-weight:700;"></div>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label>Chất lượng</label>
                                        <select name="chatLuong" class="form-control" required>
                                            <option value="Tốt">Tốt</option>
                                            <option value="Trung bình">Trung bình</option>
                                            <option value="Kém">Kém</option>
                                        </select>
                                    </div>
                                    <div class="form-group"><label>Giá trị ước tính (VNĐ)</label><input type="number" step="0.01" min="0" name="giaTriUocTinh" class="form-control" required></div>
                                </div>
                                <div class="form-group">
                                    <label>Người thu hoạch</label>
                                    <select name="nguoiThuHoach" class="form-control" required>
                                        <option value="" disabled selected>-- Chọn công nhân --</option>
                                        <c:forEach var="w" items="${WORKER_STAFF_LIST}">
                                            <option value="${w.getMaNhanVien()}">${fn:escapeXml(w.getHoTen())}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group"><label>Ghi chú</label><textarea name="ghiChu" class="form-control" placeholder="Có thể bỏ trống"></textarea></div>
                                <div class="modal-footer">
                                    <button type="button" class="btn-cancel" onclick="closeModal('harvestFormModal')">Đóng</button>
                                    <div class="modal-footer-right"><button type="submit" class="btn-save" id="hf_SubmitBtn">Xác nhận</button></div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <%-- Modal 3: xem chi tiết phiếu thu hoạch --%>
                    <div class="modal-overlay" id="harvestDetailModal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>Chi tiết phiếu thu hoạch #<span id="hd_Ma"></span></h3>
                                <button class="close-btn" onclick="closeModal('harvestDetailModal')">&times;</button>
                            </div>
                            <div class="detail-grid">
                                <p><strong>Tên rau:</strong> <span id="hd_TenRau"></span></p>
                                <p><strong>Ngày thu hoạch:</strong> <span id="hd_Ngay"></span></p>
                                <p><strong>Số lượng thu hoạch:</strong> <span id="hd_SoLuong"></span></p>
                                <p><strong>Chất lượng:</strong> <span id="hd_ChatLuong"></span></p>
                                <p><strong>Giá trị ước tính:</strong> <span id="hd_GiaTri"></span> VNĐ</p>
                                <p><strong>Người thu hoạch:</strong> <span id="hd_NguoiThuHoach"></span></p>
                            </div>
                            <p><strong>Ghi chú:</strong> <span id="hd_GhiChu"></span></p>
                            <div class="modal-footer"><div class="modal-footer-right"><button type="button" class="btn-cancel" onclick="closeModal('harvestDetailModal')">Đóng</button></div></div>
                        </div>
                    </div>

                    <%-- ===================================================== --%>
                    <%-- 3b) THU HOẠCH VẬT NUÔI (cùng trong view "harvest")     --%>
                    <%-- ===================================================== --%>
                    <div class="table-card">
                        <table>
                            <thead>
                                <tr><th>Mã thu hoạch</th><th>Vật nuôi</th><th>Loại</th><th>Ngày thu hoạch</th><th>Giá trị ước tính</th><th>Hành động</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="hv" items="${LIST_LIVESTOCK_HARVEST}">
                                    <tr>
                                        <td><strong>${hv.getMaThuHoachVN()}</strong></td>
                                        <td>${fn:escapeXml(hv.getTenVatNuoi())}</td>
                                        <td>${fn:escapeXml(hv.getLoaiVatNuoi())}</td>
                                        <td>${hv.getNgayThuHoach()}</td>
                                        <td>${hv.getGiaTriUocTinh()} VNĐ</td>
                                        <td><button class="btn-action btn-view" onclick="openHarvestLiveStockDetail(${hv.getMaThuHoachVN()})">Xem chi tiết</button></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty LIST_LIVESTOCK_HARVEST}">
                                    <tr><td colspan="6" style="text-align:center;color:#7f8c8d;padding:20px;">Chưa có phiếu thu hoạch vật nuôi nào.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <%-- Biểu đồ cột: tổng số lượng đã thu hoạch theo loại vật nuôi --%>
                    <div class="table-card">
                        <h3 style="margin-top:0;color:#2e541f;">📊 Sản lượng thu hoạch theo loại vật nuôi</h3>
                        <c:if test="${empty CHART_DATA_LIVESTOCK}">
                            <p style="color:#7f8c8d;">Chưa có dữ liệu để hiển thị biểu đồ.</p>
                        </c:if>
                        <c:if test="${not empty CHART_DATA_LIVESTOCK}">
                            <div id="harvestChartLiveStock" class="chart-wrapper"></div>
                        </c:if>
                    </div>

                    <%-- Dữ liệu ẩn cho modal chi tiết phiếu thu hoạch vật nuôi --%>
                    <div id="harvestLiveStockDataStore" style="display:none;">
                        <c:forEach var="hv" items="${LIST_LIVESTOCK_HARVEST}">
                            <div class="harvest-vn-data"
                                 data-id="${hv.getMaThuHoachVN()}"
                                 data-mavatnuoi="${hv.getMaVatNuoi()}"
                                 data-ten="${fn:escapeXml(hv.getTenVatNuoi())}"
                                 data-loai="${fn:escapeXml(hv.getLoaiVatNuoi())}"
                                 data-ngay="${hv.getNgayThuHoach()}"
                                 data-soluong="${hv.getSoLuongThuHoach()}"
                                 data-chatluong="${fn:escapeXml(hv.getChatLuong())}"
                                 data-giatri="${hv.getGiaTriUocTinh()}"
                                 data-nguoithuhoach="${fn:escapeXml(hv.getTenNguoiThuHoach())}"
                                 data-ghichu="${fn:escapeXml(hv.getGhiChu())}"></div>
                        </c:forEach>
                    </div>

                    <%-- Modal 1b: chọn vật nuôi để thu hoạch --%>
                    <div class="modal-overlay" id="harvestLiveStockPickerModal">
                        <div class="modal-content" style="width:700px;">
                            <div class="modal-header">
                                <h3>Chọn vật nuôi để thu hoạch</h3>
                                <button class="close-btn" onclick="closeModal('harvestLiveStockPickerModal')">&times;</button>
                            </div>
                            <table class="mini-table">
                                <thead><tr><th>Mã vật nuôi</th><th>Tên vật nuôi</th><th>Loại</th><th>Số lượng hiện có</th><th></th></tr></thead>
                                <tbody>
                                    <c:forEach var="hls" items="${HARVESTABLE_LIVESTOCK_LIST}">
                                        <tr>
                                            <td>${hls.getMaVatNuoi()}</td>
                                            <td>${fn:escapeXml(hls.getTenVatNuoi())}</td>
                                            <td>${fn:escapeXml(hls.getLoaiVatNuoi())}</td>
                                            <td>${hls.getSoLuong()}</td>
                                            <td>
                                                <button type="button" class="btn-action btn-harvest"
                                                        onclick="openHarvestLiveStockForm(${hls.getMaVatNuoi()}, '${fn:escapeXml(hls.getTenVatNuoi())}', ${hls.getSoLuong()})">Thu hoạch</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty HARVESTABLE_LIVESTOCK_LIST}">
                                        <tr><td colspan="5" style="text-align:center;color:#7f8c8d;padding:15px;">Hiện chưa có vật nuôi nào có thể thu hoạch.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                            <div class="modal-footer"><div class="modal-footer-right"><button type="button" class="btn-cancel" onclick="closeModal('harvestLiveStockPickerModal')">Đóng</button></div></div>
                        </div>
                    </div>

                    <%-- Modal 2b: form nhập thông tin thu hoạch vật nuôi --%>
                    <div class="modal-overlay" id="harvestLiveStockFormModal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>Thu hoạch: <span id="hfvn_TenVatNuoi"></span></h3>
                                <button class="close-btn" onclick="closeModal('harvestLiveStockFormModal')">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/technician" method="POST" id="harvestLiveStockForm">
                                <input type="hidden" name="action" value="harvestLiveStock">
                                <input type="hidden" name="maVatNuoiHarvest" id="hfvn_MaVatNuoi">
                                <div class="form-row">
                                    <div class="form-group"><label>Ngày thu hoạch</label><input type="date" name="ngayThuHoachVN" class="form-control" required></div>
                                    <div class="form-group">
                                        <label>Số lượng thu hoạch</label>
                                        <input type="number" name="soLuongThuHoachVN" id="hfvn_SoLuong" class="form-control" min="1" required oninput="checkHarvestLiveStockQty()">
                                        <div class="field-hint">Số lượng hiện có: <strong id="hfvn_SoLuongGoc"></strong>. Chỉ được thu hoạch nhỏ hơn hoặc bằng số lượng này và phải khác 0.</div>
                                        <div class="field-hint" id="hfvn_QtyWarning" style="color:#c0392b; font-weight:700;"></div>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label>Chất lượng</label>
                                        <select name="chatLuongVN" class="form-control" required>
                                            <option value="Tốt">Tốt</option>
                                            <option value="Trung bình">Trung bình</option>
                                            <option value="Kém">Kém</option>
                                        </select>
                                    </div>
                                    <div class="form-group"><label>Giá trị ước tính (VNĐ)</label><input type="number" step="0.01" min="0" name="giaTriUocTinhVN" class="form-control" required></div>
                                </div>
                                <div class="form-group">
                                    <label>Người thu hoạch</label>
                                    <select name="nguoiThuHoachVN" class="form-control" required>
                                        <option value="" disabled selected>-- Chọn công nhân --</option>
                                        <c:forEach var="w" items="${WORKER_STAFF_LIST}">
                                            <option value="${w.getMaNhanVien()}">${fn:escapeXml(w.getHoTen())}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group"><label>Ghi chú</label><textarea name="ghiChuVN" class="form-control" placeholder="Có thể bỏ trống"></textarea></div>
                                <div class="modal-footer">
                                    <button type="button" class="btn-cancel" onclick="closeModal('harvestLiveStockFormModal')">Đóng</button>
                                    <div class="modal-footer-right"><button type="submit" class="btn-save" id="hfvn_SubmitBtn">Xác nhận</button></div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <%-- Modal 3b: xem chi tiết phiếu thu hoạch vật nuôi --%>
                    <div class="modal-overlay" id="harvestLiveStockDetailModal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>Chi tiết phiếu thu hoạch #<span id="hdvn_Ma"></span></h3>
                                <button class="close-btn" onclick="closeModal('harvestLiveStockDetailModal')">&times;</button>
                            </div>
                            <div class="detail-grid">
                                <p><strong>Tên vật nuôi:</strong> <span id="hdvn_TenVatNuoi"></span></p>
                                <p><strong>Loại:</strong> <span id="hdvn_Loai"></span></p>
                                <p><strong>Ngày thu hoạch:</strong> <span id="hdvn_Ngay"></span></p>
                                <p><strong>Số lượng thu hoạch:</strong> <span id="hdvn_SoLuong"></span></p>
                                <p><strong>Chất lượng:</strong> <span id="hdvn_ChatLuong"></span></p>
                                <p><strong>Giá trị ước tính:</strong> <span id="hdvn_GiaTri"></span> VNĐ</p>
                                <p><strong>Người thu hoạch:</strong> <span id="hdvn_NguoiThuHoach"></span></p>
                            </div>
                            <p><strong>Ghi chú:</strong> <span id="hdvn_GhiChu"></span></p>
                            <div class="modal-footer"><div class="modal-footer-right"><button type="button" class="btn-cancel" onclick="closeModal('harvestLiveStockDetailModal')">Đóng</button></div></div>
                        </div>
                    </div>
                </c:if>

                <%-- ========================================================= --%>
                <%-- 4) QUẢN LÝ VẬT NUÔI                                         --%>
                <%-- ========================================================= --%>
                <c:if test="${ACTIVE_VIEW == 'livestock'}">
                    <div class="page-toolbar">
                        <h2>Quản lý vật nuôi</h2>
                        <div style="display:flex; gap:10px; flex-wrap:wrap;">
                            <button class="btn-add btn-import" onclick="openImportLiveStock()">⬆ Nhập vật nuôi</button>
                            <button class="btn-add btn-export" onclick="openExportLiveStock()">⬇ Xuất vật nuôi</button>
                            <button class="btn-add" onclick="openAddLiveStock()">+ Thêm vật nuôi</button>
                        </div>
                    </div>

                    <div class="table-card" style="margin-bottom:15px;">
                        <form action="${pageContext.request.contextPath}/technician" method="GET" style="display:flex; gap:10px;">
                            <input type="hidden" name="view" value="livestock">
                            <div class="search-box" style="flex:1;">
                                <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo tên vật nuôi..." style="width:100%;">
                                <button type="submit" name="action" value="search" class="btn-search">🔍</button>
                            </div>
                        </form>
                        <form action="${pageContext.request.contextPath}/technician" method="GET" class="form-row filter-row" style="margin-top:15px;">
                            <input type="hidden" name="view" value="livestock">
                            <input type="hidden" name="action" value="filter">
                            <div class="form-group"><label>Ngày nhập</label><input type="date" name="ngayNhap" class="form-control" value="${filterNgayNhap}"></div>
                            <div class="form-group">
                                <label>Khu vực</label>
                                <select name="maKhuVuc" class="form-control">
                                    <option value="">-- Tất cả --</option>
                                    <c:forEach var="fa" items="${farmAreaList}">
                                        <option value="${fa.getMaKhuVuc()}" ${filterMaKhuVuc == fa.getMaKhuVuc() ? 'selected' : ''}>${fn:escapeXml(fa.getTenKhuVuc())}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Số lượng</label>
                                <select name="soLuongMoc" class="form-control">
                                    <option value="">-- Tất cả --</option>
                                    <option value="duoi10" ${filterSoLuongMoc == 'duoi10' ? 'selected' : ''}>Dưới 10</option>
                                    <option value="10-50" ${filterSoLuongMoc == '10-50' ? 'selected' : ''}>10 - 50</option>
                                    <option value="50-100" ${filterSoLuongMoc == '50-100' ? 'selected' : ''}>50 - 100</option>
                                    <option value="tren100" ${filterSoLuongMoc == 'tren100' ? 'selected' : ''}>Trên 100</option>
                                </select>
                            </div>
                            <div class="form-group"><button type="submit" class="btn-add">🔍 Lọc</button></div>
                            <div class="form-group"><a href="${pageContext.request.contextPath}/technician?view=livestock" class="btn-clear-filter">Xóa lọc</a></div>
                        </form>
                    </div>

                    <div class="table-card">
                        <table>
                            <thead>
                                <tr><th>Mã vật nuôi</th><th>Tên vật nuôi</th><th>Ngày nhập</th><th>Khu vực</th><th>Số lượng</th><th>Hành động</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ls" items="${LIST_LIVESTOCK}">
                                    <tr>
                                        <td><strong>${ls.getMaVatNuoi()}</strong></td>
                                        <td>${fn:escapeXml(ls.getTenVatNuoi())}</td>
                                        <td>${ls.getNgayNhap()}</td>
                                        <td>${fn:escapeXml(ls.getTenKhuVuc())}</td>
                                        <td>${ls.getSoLuong()}</td>
                                        <td><button class="btn-action btn-view" onclick="openLiveStockDetail(${ls.getMaVatNuoi()})">Xem chi tiết</button></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty LIST_LIVESTOCK}">
                                    <tr><td colspan="6" style="text-align:center;color:#7f8c8d;padding:20px;">Không có vật nuôi nào khớp điều kiện.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <%-- Dữ liệu ẩn cho JS --%>
                    <div id="liveStockDataStore" style="display:none;">
                        <c:forEach var="ls" items="${LIST_LIVESTOCK}">
                            <div class="ls-data"
                                 data-id="${ls.getMaVatNuoi()}"
                                 data-ten="${fn:escapeXml(ls.getTenVatNuoi())}"
                                 data-loai="${fn:escapeXml(ls.getLoaiVatNuoi())}"
                                 data-giong="${fn:escapeXml(ls.getGiong())}"
                                 data-ngaynhap="${ls.getNgayNhap()}"
                                 data-soluong="${ls.getSoLuong()}"
                                 data-trongluong="${ls.getTrongLuongTrungBinh()}"
                                 data-makhuvuc="${ls.getMaKhuVuc()}"
                                 data-tenkhuvuc="${fn:escapeXml(ls.getTenKhuVuc())}"
                                 data-trangthai="${fn:escapeXml(ls.getTrangThai())}"
                                 data-ghichu="${fn:escapeXml(ls.getGhiChu())}"></div>
                        </c:forEach>
                    </div>

                    <%-- Modal thêm vật nuôi --%>
                    <div class="modal-overlay" id="addLiveStockModal">
                        <div class="modal-content">
                            <div class="modal-header"><h3>Thêm vật nuôi mới</h3><button class="close-btn" onclick="closeModal('addLiveStockModal')">&times;</button></div>
                            <form action="${pageContext.request.contextPath}/technician" method="POST">
                                <input type="hidden" name="action" value="addLiveStock">
                                <div class="form-row">
                                    <div class="form-group"><label>Tên vật nuôi</label><input type="text" name="tenVatNuoi" class="form-control" required></div>
                                    <div class="form-group"><label>Loại vật nuôi</label><input type="text" name="loaiVatNuoi" class="form-control" required></div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group"><label>Giống</label><input type="text" name="giong" class="form-control" required></div>
                                    <div class="form-group">
                                        <label>Khu vực</label>
                                        <select name="maKhuVuc" class="form-control" required>
                                            <option value="" disabled selected>-- Chọn khu vực --</option>
                                            <c:forEach var="fa" items="${farmAreaList}">
                                                <option value="${fa.getMaKhuVuc()}">${fn:escapeXml(fa.getTenKhuVuc())}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group"><label>Ngày nhập</label><input type="date" name="ngayNhap" class="form-control" required></div>
                                    <div class="form-group"><label>Số lượng</label><input type="number" min="0" name="soLuong" class="form-control" required></div>
                                    <div class="form-group"><label>Trọng lượng TB (kg)</label><input type="number" step="0.01" min="0" name="trongLuongTrungBinh" class="form-control" required></div>
                                </div>
                                <div class="form-group">
                                    <label>Trạng thái</label>
                                    <select name="trangThai" class="form-control" required>
                                        <option value="Khỏe mạnh">Khỏe mạnh</option>
                                        <option value="Bị bệnh">Bị bệnh</option>
                                        <option value="Đã xuất chuồng">Đã xuất chuồng</option>
                                    </select>
                                </div>
                                <div class="form-group"><label>Ghi chú</label><textarea name="ghiChu" class="form-control" placeholder="Có thể bỏ trống"></textarea></div>
                                <div class="modal-footer"><div class="modal-footer-right">
                                    <button type="button" class="btn-cancel" onclick="closeModal('addLiveStockModal')">Hủy bỏ</button>
                                    <button type="submit" class="btn-save">Lưu</button>
                                </div></div>
                            </form>
                        </div>
                    </div>

                    <%-- Modal chi tiết / sửa vật nuôi --%>
                    <div class="modal-overlay" id="liveStockDetailModal">
                        <div class="modal-content" style="width:640px;">
                            <div class="modal-header"><h3>Chi tiết vật nuôi #<span id="dls_Ma"></span></h3><button class="close-btn" onclick="closeModal('liveStockDetailModal')">&times;</button></div>
                            <form id="liveStockEditForm" action="${pageContext.request.contextPath}/technician" method="POST">
                                <input type="hidden" name="action" value="editLiveStock">
                                <input type="hidden" name="maVatNuoi" id="dls_Ma_input">
                                <div class="form-row">
                                    <div class="form-group"><label>Tên vật nuôi</label><input type="text" name="tenVatNuoi" id="dls_Ten" class="form-control" disabled required></div>
                                    <div class="form-group"><label>Loại vật nuôi</label><input type="text" name="loaiVatNuoi" id="dls_Loai" class="form-control" disabled required></div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group"><label>Giống</label><input type="text" name="giong" id="dls_Giong" class="form-control" disabled required></div>
                                    <div class="form-group">
                                        <label>Khu vực</label>
                                        <select name="maKhuVuc" id="dls_MaKhuVuc" class="form-control" disabled required>
                                            <c:forEach var="fa" items="${farmAreaList}">
                                                <option value="${fa.getMaKhuVuc()}">${fn:escapeXml(fa.getTenKhuVuc())} (Mã ${fa.getMaKhuVuc()})</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group"><label>Ngày nhập</label><input type="date" name="ngayNhap" id="dls_NgayNhap" class="form-control" disabled required></div>
                                    <div class="form-group"><label>Số lượng</label><input type="number" name="soLuong" id="dls_SoLuong" class="form-control" disabled required></div>
                                    <div class="form-group"><label>Trọng lượng TB (kg)</label><input type="number" step="0.01" name="trongLuongTrungBinh" id="dls_TrongLuong" class="form-control" disabled required></div>
                                </div>
                                <div class="form-group">
                                    <label>Trạng thái</label>
                                    <select name="trangThai" id="dls_TrangThai" class="form-control" disabled required>
                                        <option value="Khỏe mạnh">Khỏe mạnh</option>
                                        <option value="Bị bệnh">Bị bệnh</option>
                                        <option value="Đã xuất chuồng">Đã xuất chuồng</option>
                                    </select>
                                </div>
                                <div class="form-group"><label>Ghi chú</label><textarea name="ghiChu" id="dls_GhiChu" class="form-control" disabled></textarea></div>
                                <div class="modal-footer">
                                    <button type="button" class="btn-warning" id="dls_CancelBtn" style="display:none;" onclick="cancelLiveStockEdit()">Hủy chỉnh sửa</button>
                                    <div class="modal-footer-right">
                                        <button type="button" class="btn-edit btn-action" id="dls_EditBtn" style="padding:10px 20px;" onclick="enableLiveStockEdit()">Chỉnh sửa</button>
                                        <button type="submit" class="btn-save" id="dls_SaveBtn" style="display:none;">Lưu thay đổi</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <%-- Modal nhập vật nuôi --%>
                    <div class="modal-overlay" id="importLiveStockModal">
                        <div class="modal-content">
                            <div class="modal-header"><h3>Nhập vật nuôi</h3><button class="close-btn" onclick="closeModal('importLiveStockModal')">&times;</button></div>
                            <form action="${pageContext.request.contextPath}/technician" method="POST">
                                <input type="hidden" name="action" value="importLiveStock">
                                <div class="form-group">
                                    <label>Chọn vật nuôi</label>
                                    <select name="maVatNuoi" class="form-control" required>
                                        <option value="" disabled selected>-- Chọn vật nuôi --</option>
                                        <c:forEach var="ls" items="${LIST_LIVESTOCK}">
                                            <option value="${ls.getMaVatNuoi()}">${fn:escapeXml(ls.getTenVatNuoi())} (Mã ${ls.getMaVatNuoi()} - Đang có: ${ls.getSoLuong()})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group"><label>Số lượng nhập</label><input type="number" min="1" name="soLuongNhap" class="form-control" required></div>
                                <div class="modal-footer"><div class="modal-footer-right">
                                    <button type="button" class="btn-cancel" onclick="closeModal('importLiveStockModal')">Hủy bỏ</button>
                                    <button type="submit" class="btn-save">Xác nhận nhập</button>
                                </div></div>
                            </form>
                        </div>
                    </div>

                    <%-- Modal xuất vật nuôi --%>
                    <div class="modal-overlay" id="exportLiveStockModal">
                        <div class="modal-content">
                            <div class="modal-header"><h3>Xuất vật nuôi</h3><button class="close-btn" onclick="closeModal('exportLiveStockModal')">&times;</button></div>
                            <form action="${pageContext.request.contextPath}/technician" method="POST">
                                <input type="hidden" name="action" value="exportLiveStock">
                                <div class="form-group">
                                    <label>Chọn vật nuôi</label>
                                    <select name="maVatNuoi" class="form-control" required>
                                        <option value="" disabled selected>-- Chọn vật nuôi --</option>
                                        <c:forEach var="ls" items="${LIST_LIVESTOCK}">
                                            <option value="${ls.getMaVatNuoi()}">${fn:escapeXml(ls.getTenVatNuoi())} (Mã ${ls.getMaVatNuoi()} - Đang có: ${ls.getSoLuong()})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group"><label>Số lượng xuất</label><input type="number" min="1" name="soLuongXuat" class="form-control" required></div>
                                <div class="modal-footer"><div class="modal-footer-right">
                                    <button type="button" class="btn-cancel" onclick="closeModal('exportLiveStockModal')">Hủy bỏ</button>
                                    <button type="submit" class="btn-save">Xác nhận xuất</button>
                                </div></div>
                            </form>
                        </div>
                    </div>
                </c:if>

            </main>
        </div>

        <script>
            // ============== DÙNG CHUNG ==============
            function closeModal(id) {
                document.getElementById(id).style.display = 'none';
            }
            window.onclick = function (event) {
                document.querySelectorAll('.modal-overlay').forEach(function (m) {
                    if (event.target === m) m.style.display = 'none';
                });
            };

            // ============== 1) QUY TRÌNH ==============
            function openProcessForm(mode, btn) {
                const modal = document.getElementById('processModal');
                const title = document.getElementById('processModalTitle');
                const actionInput = document.getElementById('processAction');
                const statusGroup = document.getElementById('processStatusGroup');
                const form = modal.querySelector('form');
                if (mode === 'add') {
                    title.innerText = 'Tạo bộ quy trình mới';
                    actionInput.value = 'create';
                    statusGroup.style.display = 'none';
                    form.reset();
                    document.getElementById('processId').value = '';
                } else if (mode === 'edit' && btn) {
                    title.innerText = 'Sửa bộ quy trình';
                    actionInput.value = 'update';
                    statusGroup.style.display = 'block';
                    document.getElementById('processId').value = btn.dataset.id;
                    document.getElementById('processName').value = btn.dataset.ten;
                    document.getElementById('processLoaiApDung').value = btn.dataset.loai;
                    document.getElementById('processDescription').value = btn.dataset.mota;
                    document.getElementById('processStatus').value = btn.dataset.trangthai;
                }
                modal.style.display = 'flex';
            }
            function openStageForm(practiceId) {
                document.getElementById('stagePracticeId').value = practiceId;
                document.getElementById('stageModal').style.display = 'flex';
            }
            function confirmDeleteProcess(id) {
                if (confirm('Bạn có chắc muốn xóa quy trình này?')) {
                    document.getElementById('deleteProcessId').value = id;
                    document.getElementById('deleteProcessForm').submit();
                }
                return false;
            }

            // ============== 2) RAU TRỒNG ==============
            function openAddVegetable() {
                document.getElementById('addVegetableModal').style.display = 'flex';
            }
            function openVegetableDetail(maRau) {
                const el = document.querySelector('.veg-data[data-id="' + maRau + '"]');
                if (!el) return;
                document.getElementById('dv_MaRau').innerText = el.dataset.id;
                document.getElementById('dv_MaRau_input').value = el.dataset.id;
                document.getElementById('dv_TenRau').value = el.dataset.ten;
                document.getElementById('dv_LoaiRau').value = el.dataset.loai;
                document.getElementById('dv_Giong').value = el.dataset.giong;
                document.getElementById('dv_MaKhuVuc').value = el.dataset.makhuvuc;
                document.getElementById('dv_NgayGieo').value = el.dataset.ngaygieo;
                document.getElementById('dv_NgayThuHoachDuKien').value = el.dataset.ngaythuhoach;
                document.getElementById('dv_DienTich').value = el.dataset.dientich;
                document.getElementById('dv_SoLuong').value = el.dataset.soluong;
                document.getElementById('dv_TrangThai').value = el.dataset.trangthai;
                document.getElementById('dv_GhiChu').value = el.dataset.ghichu;

                // Khóa lại toàn bộ + đưa về trạng thái "xem"
                lockVegetableForm();
                document.getElementById('vegetableDetailModal').style.display = 'flex';
            }
            function lockVegetableForm() {
                ['dv_TenRau','dv_LoaiRau','dv_Giong','dv_MaKhuVuc','dv_NgayGieo','dv_NgayThuHoachDuKien','dv_DienTich','dv_SoLuong','dv_TrangThai','dv_GhiChu']
                    .forEach(function (id) { document.getElementById(id).disabled = true; });
                document.getElementById('dv_EditBtn').style.display = 'inline-block';
                document.getElementById('dv_SaveBtn').style.display = 'none';
                document.getElementById('dv_CancelBtn').style.display = 'none';
            }
            function enableVegetableEdit() {
                ['dv_TenRau','dv_LoaiRau','dv_Giong','dv_MaKhuVuc','dv_NgayGieo','dv_NgayThuHoachDuKien','dv_DienTich','dv_SoLuong','dv_TrangThai','dv_GhiChu']
                    .forEach(function (id) { document.getElementById(id).disabled = false; });
                document.getElementById('dv_EditBtn').style.display = 'none';
                document.getElementById('dv_SaveBtn').style.display = 'inline-block';
                document.getElementById('dv_CancelBtn').style.display = 'inline-block';
            }
            function cancelVegetableEdit() {
                openVegetableDetail(document.getElementById('dv_MaRau_input').value);
            }

            // ============== 3) THU HOẠCH RAU ==============
            function openHarvestPicker() {
                document.getElementById('harvestPickerModal').style.display = 'flex';
            }
            function openHarvestForm(maRau, tenRau, soLuongGoc) {
                closeModal('harvestPickerModal');
                document.getElementById('hf_MaRau').value = maRau;
                document.getElementById('hf_TenRau').innerText = tenRau;
                document.getElementById('hf_SoLuongGoc').innerText = soLuongGoc;
                document.getElementById('hf_SoLuong').max = soLuongGoc;
                document.getElementById('hf_SoLuong').value = '';
                document.getElementById('hf_QtyWarning').innerText = '';
                document.getElementById('hf_SubmitBtn').disabled = false;
                document.getElementById('harvestFormModal').style.display = 'flex';
            }
            function checkHarvestQty() {
                const input = document.getElementById('hf_SoLuong');
                const max = parseInt(input.max, 10);
                const val = parseInt(input.value, 10);
                const warn = document.getElementById('hf_QtyWarning');
                const btn = document.getElementById('hf_SubmitBtn');
                if (isNaN(val) || val <= 0) {
                    warn.innerText = 'Số lượng thu hoạch phải khác 0.';
                    btn.disabled = true;
                } else if (val > max) {
                    warn.innerText = 'Số lượng thu hoạch không được vượt quá số lượng gốc (' + max + ').';
                    btn.disabled = true;
                } else {
                    warn.innerText = '';
                    btn.disabled = false;
                }
            }
            function openHarvestDetail(maThuHoach) {
                const el = document.querySelector('.harvest-data[data-id="' + maThuHoach + '"]');
                if (!el) return;
                document.getElementById('hd_Ma').innerText = el.dataset.id;
                document.getElementById('hd_TenRau').innerText = el.dataset.tenrau;
                document.getElementById('hd_Ngay').innerText = el.dataset.ngay;
                document.getElementById('hd_SoLuong').innerText = el.dataset.soluong;
                document.getElementById('hd_ChatLuong').innerText = el.dataset.chatluong;
                document.getElementById('hd_GiaTri').innerText = el.dataset.giatri;
                document.getElementById('hd_NguoiThuHoach').innerText = el.dataset.nguoithuhoach;
                document.getElementById('hd_GhiChu').innerText = el.dataset.ghichu || '(không có)';
                document.getElementById('harvestDetailModal').style.display = 'flex';
            }

            // ---- Vẽ biểu đồ cột (tổng sản lượng theo tên rau) ----
            <c:if test="${ACTIVE_VIEW == 'harvest' && not empty CHART_DATA}">
            (function () {
                var chartData = [
                    <c:forEach var="entry" items="${CHART_DATA}" varStatus="st">
                    { name: "${fn:escapeXml(entry.key)}", value: ${entry.value} }<c:if test="${!st.last}">,</c:if>
                    </c:forEach>
                ];
                var maxVal = Math.max.apply(null, chartData.map(function (d) { return d.value; }));
                if (maxVal <= 0) maxVal = 1;

                var wrapper = document.getElementById('harvestChart');
                var yAxis = document.createElement('div');
                yAxis.className = 'chart-y-axis';
                for (var i = 4; i >= 0; i--) {
                    var lbl = document.createElement('div');
                    lbl.innerText = Math.round(maxVal * i / 4);
                    yAxis.appendChild(lbl);
                }
                var plot = document.createElement('div');
                plot.className = 'chart-plot';
                chartData.forEach(function (d) {
                    var col = document.createElement('div');
                    col.className = 'chart-bar-col';
                    var valueLbl = document.createElement('div');
                    valueLbl.className = 'chart-bar-value';
                    valueLbl.innerText = d.value;
                    var bar = document.createElement('div');
                    bar.className = 'chart-bar';
                    bar.style.height = Math.max(4, (d.value / maxVal * 250)) + 'px';
                    var nameLbl = document.createElement('div');
                    nameLbl.className = 'chart-bar-label';
                    nameLbl.innerText = d.name;
                    col.appendChild(valueLbl);
                    col.appendChild(bar);
                    col.appendChild(nameLbl);
                    plot.appendChild(col);
                });
                wrapper.appendChild(yAxis);
                wrapper.appendChild(plot);
            })();
            </c:if>

            // ============== 3b) THU HOẠCH VẬT NUÔI ==============
            function openHarvestLiveStockPicker() {
                document.getElementById('harvestLiveStockPickerModal').style.display = 'flex';
            }
            function openHarvestLiveStockForm(maVatNuoi, tenVatNuoi, soLuongGoc) {
                closeModal('harvestLiveStockPickerModal');
                document.getElementById('hfvn_MaVatNuoi').value = maVatNuoi;
                document.getElementById('hfvn_TenVatNuoi').innerText = tenVatNuoi;
                document.getElementById('hfvn_SoLuongGoc').innerText = soLuongGoc;
                document.getElementById('hfvn_SoLuong').max = soLuongGoc;
                document.getElementById('hfvn_SoLuong').value = '';
                document.getElementById('hfvn_QtyWarning').innerText = '';
                document.getElementById('hfvn_SubmitBtn').disabled = false;
                document.getElementById('harvestLiveStockFormModal').style.display = 'flex';
            }
            function checkHarvestLiveStockQty() {
                const input = document.getElementById('hfvn_SoLuong');
                const max = parseInt(input.max, 10);
                const val = parseInt(input.value, 10);
                const warn = document.getElementById('hfvn_QtyWarning');
                const btn = document.getElementById('hfvn_SubmitBtn');
                if (isNaN(val) || val <= 0) {
                    warn.innerText = 'Số lượng thu hoạch phải khác 0.';
                    btn.disabled = true;
                } else if (val > max) {
                    warn.innerText = 'Số lượng thu hoạch không được vượt quá số lượng hiện có (' + max + ').';
                    btn.disabled = true;
                } else {
                    warn.innerText = '';
                    btn.disabled = false;
                }
            }
            function openHarvestLiveStockDetail(maThuHoachVN) {
                const el = document.querySelector('.harvest-vn-data[data-id="' + maThuHoachVN + '"]');
                if (!el) return;
                document.getElementById('hdvn_Ma').innerText = el.dataset.id;
                document.getElementById('hdvn_TenVatNuoi').innerText = el.dataset.ten;
                document.getElementById('hdvn_Loai').innerText = el.dataset.loai;
                document.getElementById('hdvn_Ngay').innerText = el.dataset.ngay;
                document.getElementById('hdvn_SoLuong').innerText = el.dataset.soluong;
                document.getElementById('hdvn_ChatLuong').innerText = el.dataset.chatluong;
                document.getElementById('hdvn_GiaTri').innerText = el.dataset.giatri;
                document.getElementById('hdvn_NguoiThuHoach').innerText = el.dataset.nguoithuhoach;
                document.getElementById('hdvn_GhiChu').innerText = el.dataset.ghichu || '(không có)';
                document.getElementById('harvestLiveStockDetailModal').style.display = 'flex';
            }

            // ---- Vẽ biểu đồ cột (tổng sản lượng theo loại vật nuôi) ----
            <c:if test="${ACTIVE_VIEW == 'harvest' && not empty CHART_DATA_LIVESTOCK}">
            (function () {
                var chartData = [
                    <c:forEach var="entry" items="${CHART_DATA_LIVESTOCK}" varStatus="st">
                    { name: "${fn:escapeXml(entry.key)}", value: ${entry.value} }<c:if test="${!st.last}">,</c:if>
                    </c:forEach>
                ];
                var maxVal = Math.max.apply(null, chartData.map(function (d) { return d.value; }));
                if (maxVal <= 0) maxVal = 1;

                var wrapper = document.getElementById('harvestChartLiveStock');
                var yAxis = document.createElement('div');
                yAxis.className = 'chart-y-axis';
                for (var i = 4; i >= 0; i--) {
                    var lbl = document.createElement('div');
                    lbl.innerText = Math.round(maxVal * i / 4);
                    yAxis.appendChild(lbl);
                }
                var plot = document.createElement('div');
                plot.className = 'chart-plot';
                chartData.forEach(function (d) {
                    var col = document.createElement('div');
                    col.className = 'chart-bar-col';
                    var valueLbl = document.createElement('div');
                    valueLbl.className = 'chart-bar-value';
                    valueLbl.innerText = d.value;
                    var bar = document.createElement('div');
                    bar.className = 'chart-bar';
                    bar.style.height = Math.max(4, (d.value / maxVal * 250)) + 'px';
                    var nameLbl = document.createElement('div');
                    nameLbl.className = 'chart-bar-label';
                    nameLbl.innerText = d.name;
                    col.appendChild(valueLbl);
                    col.appendChild(bar);
                    col.appendChild(nameLbl);
                    plot.appendChild(col);
                });
                wrapper.appendChild(yAxis);
                wrapper.appendChild(plot);
            })();
            </c:if>

            // ============== 4) VẬT NUÔI ==============
            function openAddLiveStock() {
                document.getElementById('addLiveStockModal').style.display = 'flex';
            }
            function openImportLiveStock() {
                document.getElementById('importLiveStockModal').style.display = 'flex';
            }
            function openExportLiveStock() {
                document.getElementById('exportLiveStockModal').style.display = 'flex';
            }
            function openLiveStockDetail(maVatNuoi) {
                const el = document.querySelector('.ls-data[data-id="' + maVatNuoi + '"]');
                if (!el) return;
                document.getElementById('dls_Ma').innerText = el.dataset.id;
                document.getElementById('dls_Ma_input').value = el.dataset.id;
                document.getElementById('dls_Ten').value = el.dataset.ten;
                document.getElementById('dls_Loai').value = el.dataset.loai;
                document.getElementById('dls_Giong').value = el.dataset.giong;
                document.getElementById('dls_MaKhuVuc').value = el.dataset.makhuvuc;
                document.getElementById('dls_NgayNhap').value = el.dataset.ngaynhap;
                document.getElementById('dls_SoLuong').value = el.dataset.soluong;
                document.getElementById('dls_TrongLuong').value = el.dataset.trongluong;
                document.getElementById('dls_TrangThai').value = el.dataset.trangthai;
                document.getElementById('dls_GhiChu').value = el.dataset.ghichu;

                lockLiveStockForm();
                document.getElementById('liveStockDetailModal').style.display = 'flex';
            }
            function lockLiveStockForm() {
                ['dls_Ten','dls_Loai','dls_Giong','dls_MaKhuVuc','dls_NgayNhap','dls_SoLuong','dls_TrongLuong','dls_TrangThai','dls_GhiChu']
                    .forEach(function (id) { document.getElementById(id).disabled = true; });
                document.getElementById('dls_EditBtn').style.display = 'inline-block';
                document.getElementById('dls_SaveBtn').style.display = 'none';
                document.getElementById('dls_CancelBtn').style.display = 'none';
            }
            function enableLiveStockEdit() {
                ['dls_Ten','dls_Loai','dls_Giong','dls_MaKhuVuc','dls_NgayNhap','dls_SoLuong','dls_TrongLuong','dls_TrangThai','dls_GhiChu']
                    .forEach(function (id) { document.getElementById(id).disabled = false; });
                document.getElementById('dls_EditBtn').style.display = 'none';
                document.getElementById('dls_SaveBtn').style.display = 'inline-block';
                document.getElementById('dls_CancelBtn').style.display = 'inline-block';
            }
            function cancelLiveStockEdit() {
                openLiveStockDetail(document.getElementById('dls_Ma_input').value);
            }

            // ============== SỰ KIỆN MODAL PHÂN CÔNG CÔNG VIỆC ==============
            document.addEventListener("DOMContentLoaded", function () {
                const openModalBtn = document.getElementById('openModalBtn');
                const closeModalBtn = document.getElementById('closeModalBtn');
                const closeModalBtn2 = document.getElementById('closeModalBtn2');
                const modalOverlay = document.getElementById('modalOverlay');

                if (openModalBtn && modalOverlay) {
                    openModalBtn.addEventListener('click', () => {
                        modalOverlay.style.display = 'flex';
                    });
                    if (closeModalBtn) {
                        closeModalBtn.addEventListener('click', () => {
                            modalOverlay.style.display = 'none';
                        });
                    }
                    if (closeModalBtn2) {
                        closeModalBtn2.addEventListener('click', () => {
                            modalOverlay.style.display = 'none';
                        });
                    }
                    modalOverlay.addEventListener('click', (e) => {
                        if (e.target === modalOverlay) {
                            modalOverlay.style.display = 'none';
                        }
                    });
                }
            });
        </script>
    </body>
</html>