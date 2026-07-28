package controllers;

import dao.FarmAreaDAO;
import dao.FarmingPracticeDAO;
import dao.LiveStockDAO;
import dao.LiveStockHarvestDAO;
import dao.SupplieDAO;
import dao.UserDAO;
import dao.VegetableDAO;
import dao.VegetableHarvestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import models.FarmingPractice;
import models.LiveStock;
import models.LiveStockHarvest;
import models.Vegetable;
import models.VegetableHarvest;
import services.TechnicianService;

/**
 * Servlet trung tâm cho khu vực Kỹ thuật viên (Technician), chia làm 4 chức năng lớn
 * thông qua tham số "view":
 *   1) view=process    -> Phân chia công việc & tạo bộ quy trình chuẩn (logic gốc, giữ nguyên)
 *   2) view=vegetable  -> Quản lý rau trồng
 *   3) view=harvest    -> Quản lý thu hoạch rau
 *   4) view=livestock  -> Quản lý vật nuôi
 */
@WebServlet(name = "TechnicianServlet", urlPatterns = {"/technician"})
public class TechnicianServlet extends HttpServlet {

    private final SupplieDAO supplieDAO = new SupplieDAO();
    private final FarmAreaDAO faDAO = new FarmAreaDAO();
    private final FarmingPracticeDAO fqDAO = new FarmingPracticeDAO();
    private final TechnicianService farmingPracticeService = new TechnicianService();

    private final VegetableDAO vegetableDAO = new VegetableDAO();
    private final VegetableHarvestDAO harvestDAO = new VegetableHarvestDAO();
    private final LiveStockDAO liveStockDAO = new LiveStockDAO();
    private final LiveStockHarvestDAO liveStockHarvestDAO = new LiveStockHarvestDAO();

    List<FarmingPractice> list;

    // =====================================================================
    // ================================ GET ===============================
    // =====================================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String view = request.getParameter("view");
        if (view == null || view.trim().isEmpty()) {
            view = "process";
        }
        request.setAttribute("ACTIVE_VIEW", view);

        // Hứng thông báo (dùng chung cho cả 4 chức năng)
        HttpSession session = request.getSession();
        if (session.getAttribute("SUCCESS_MSG") != null) {
            request.setAttribute("SUCCESS_MSG", session.getAttribute("SUCCESS_MSG"));
            session.removeAttribute("SUCCESS_MSG");
        }
        if (session.getAttribute("ERROR_MSG") != null) {
            request.setAttribute("ERROR_MSG", session.getAttribute("ERROR_MSG"));
            session.removeAttribute("ERROR_MSG");
        }

        switch (view) {
            case "vegetable":
                loadVegetableView(request);
                break;
            case "harvest":
                loadHarvestView(request);
                break;
            case "livestock":
                loadLiveStockView(request);
                break;
            default:
                loadProcessView(request);
                break;
        }

        // Danh sách khu vực dùng chung cho cả 3 tab mới (dropdown chọn khu vực)
        request.setAttribute("farmAreaList", faDAO.getAllFarmAreas());

        request.getRequestDispatcher("/views/technician/technician.jsp").forward(request, response);
    }

    // ---- 1) Phân chia công việc & tạo bộ quy trình chuẩn (giữ nguyên logic gốc) ----
    private void loadProcessView(HttpServletRequest request) {
    String action = request.getParameter("action");
    String keyword = request.getParameter("keyword");

    if ("search".equals(action) && keyword != null && !keyword.trim().isEmpty()) {
        list = farmingPracticeService.searchFarmingPractices(keyword);
        request.setAttribute("keyword", keyword);
    } else {
        list = farmingPracticeService.getAllFarmingPractices();
    }

    request.setAttribute("suppliesList", supplieDAO.SelectSupplie());
    request.setAttribute("workerList", fqDAO.WorkerList()); // Đã có sẵn để hiển thị danh sách công nhân
    request.setAttribute("farmingPracticeList", list);
}

    // ---- 2) Quản lý rau trồng ----
    private void loadVegetableView(HttpServletRequest request) {
        String action = request.getParameter("action");
        String keyword = request.getParameter("keyword");
        List<Vegetable> vList;

        if ("search".equals(action) && keyword != null && !keyword.trim().isEmpty()) {
            vList = vegetableDAO.searchVegetables(keyword);
            request.setAttribute("keyword", keyword);
        } else if ("filter".equals(action)) {
            String maKhuVucStr = request.getParameter("maKhuVuc");
            String ngayGieoStr = request.getParameter("ngayGieo");
            String trangThai = request.getParameter("trangThai");

            Integer maKhuVuc = (maKhuVucStr != null && !maKhuVucStr.isEmpty()) ? Integer.parseInt(maKhuVucStr) : null;
            LocalDate ngayGieo = (ngayGieoStr != null && !ngayGieoStr.isEmpty()) ? LocalDate.parse(ngayGieoStr) : null;

            vList = vegetableDAO.filterVegetables(maKhuVuc, ngayGieo, trangThai);

            request.setAttribute("filterMaKhuVuc", maKhuVucStr);
            request.setAttribute("filterNgayGieo", ngayGieoStr);
            request.setAttribute("filterTrangThai", trangThai);
        } else {
            vList = vegetableDAO.getDefaultVegetableList();
        }

        request.setAttribute("LIST_VEGETABLE", vList);
    }

    // ---- 3) Quản lý thu hoạch rau ----
    private void loadHarvestView(HttpServletRequest request) {
        String action = request.getParameter("action");
        List<VegetableHarvest> hList;

        if ("filter".equals(action)) {
            String tuNgayStr = request.getParameter("tuNgay");
            String denNgayStr = request.getParameter("denNgay");
            String soLuongMoc = request.getParameter("soLuongMoc");
            String giaTriMoc = request.getParameter("giaTriMoc");

            LocalDate tuNgay = (tuNgayStr != null && !tuNgayStr.isEmpty()) ? LocalDate.parse(tuNgayStr) : null;
            LocalDate denNgay = (denNgayStr != null && !denNgayStr.isEmpty()) ? LocalDate.parse(denNgayStr) : null;

            hList = harvestDAO.filterHarvests(tuNgay, denNgay,
                    (soLuongMoc == null || soLuongMoc.isEmpty()) ? null : soLuongMoc,
                    (giaTriMoc == null || giaTriMoc.isEmpty()) ? null : giaTriMoc);

            request.setAttribute("filterTuNgay", tuNgayStr);
            request.setAttribute("filterDenNgay", denNgayStr);
            request.setAttribute("filterSoLuongMoc", soLuongMoc);
            request.setAttribute("filterGiaTriMoc", giaTriMoc);
        } else {
            hList = harvestDAO.getAllHarvests();
        }

        request.setAttribute("LIST_HARVEST", hList);
        request.setAttribute("HARVESTABLE_VEGETABLE_LIST", harvestDAO.getHarvestableVegetables());
        request.setAttribute("WORKER_STAFF_LIST", harvestDAO.getWorkerStaffList());
        request.setAttribute("CHART_DATA", harvestDAO.getChartDataByVegetableName());

        // ---- Dữ liệu thu hoạch vật nuôi (dùng chung view "harvest") ----
        request.setAttribute("LIST_LIVESTOCK_HARVEST", liveStockHarvestDAO.getAllLiveStockHarvests());
        request.setAttribute("HARVESTABLE_LIVESTOCK_LIST", liveStockHarvestDAO.getHarvestableLiveStock());
        request.setAttribute("CHART_DATA_LIVESTOCK", liveStockHarvestDAO.getChartDataByLiveStockType());
    }

    // ---- 4) Quản lý vật nuôi ----
    private void loadLiveStockView(HttpServletRequest request) {
        String action = request.getParameter("action");
        String keyword = request.getParameter("keyword");
        List<LiveStock> lsList;

        if ("search".equals(action) && keyword != null && !keyword.trim().isEmpty()) {
            lsList = liveStockDAO.searchLiveStock(keyword);
            request.setAttribute("keyword", keyword);
        } else if ("filter".equals(action)) {
            String ngayNhapStr = request.getParameter("ngayNhap");
            String maKhuVucStr = request.getParameter("maKhuVuc");
            String soLuongMoc = request.getParameter("soLuongMoc");

            LocalDate ngayNhap = (ngayNhapStr != null && !ngayNhapStr.isEmpty()) ? LocalDate.parse(ngayNhapStr) : null;
            Integer maKhuVuc = (maKhuVucStr != null && !maKhuVucStr.isEmpty()) ? Integer.parseInt(maKhuVucStr) : null;

            lsList = liveStockDAO.filterLiveStock(ngayNhap, maKhuVuc,
                    (soLuongMoc == null || soLuongMoc.isEmpty()) ? null : soLuongMoc);

            request.setAttribute("filterNgayNhap", ngayNhapStr);
            request.setAttribute("filterMaKhuVuc", maKhuVucStr);
            request.setAttribute("filterSoLuongMoc", soLuongMoc);
        } else {
            lsList = liveStockDAO.getAllLiveStock();
        }

        request.setAttribute("LIST_LIVESTOCK", lsList);
    }

    // =====================================================================
    // ================================ POST ==============================
    // =====================================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // ================= 1) PHÂN CHIA CÔNG VIỆC & QUY TRÌNH (giữ nguyên) =================
        if ("saveStage".equals(action) || "publishProcess".equals(action)) {
            FarmingPracticeDAO practiceDAO = new FarmingPracticeDAO();
            String practiceIdStr = request.getParameter("farmingPracticeId");

            if (practiceIdStr != null && !practiceIdStr.isEmpty()) {
                try {
                    int practiceId = Integer.parseInt(practiceIdStr);
                    String stageName = request.getParameter("stageName");
                    java.sql.Date startDay = java.sql.Date.valueOf(request.getParameter("startDay"));
                    java.sql.Date endDay = java.sql.Date.valueOf(request.getParameter("endDay"));
                    int maVatTu = Integer.parseInt(request.getParameter("maVatTu"));
                    double dinhLuong = Double.parseDouble(request.getParameter("quantity"));
                    String donVi = request.getParameter("unit");
                    String moTa = request.getParameter("description");

                    boolean ok = practiceDAO.saveFarmingStage(practiceId, stageName, startDay, endDay, maVatTu, dinhLuong, donVi, moTa);

                    if ("publishProcess".equals(action)) {
                        practiceDAO.publishProcess(practiceId);
                    }

                    session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                            ok ? "Lưu giai đoạn thành công!" : "Lưu giai đoạn thất bại.");
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("ERROR_MSG", "Lỗi lưu giai đoạn: " + e.getMessage());
                }
            } else {
                session.setAttribute("ERROR_MSG", "Thiếu farmingPracticeId.");
            }
            response.sendRedirect(request.getContextPath() + "/technician?view=process");
            return;

        } else if ("delete".equals(action)) {
            String idRaw = request.getParameter("id");
            if (idRaw != null) {
                try {
                    int id = Integer.parseInt(idRaw);
                    boolean ok = farmingPracticeService.deleteFarmingPractice(id);
                    session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                            ok ? "Xóa quy trình thành công!" : "Xóa quy trình thất bại.");
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect(request.getContextPath() + "/technician?view=process");
            return;

        } else if ("update".equals(action)) {
            String idRaw = request.getParameter("id");
            String tenQuyTrinh = request.getParameter("processName");
            String moTa = request.getParameter("description");
            String loaiApDung = request.getParameter("loaiApDung");
            String trangThai = request.getParameter("status");

            if (idRaw != null) {
                try {
                    int id = Integer.parseInt(idRaw);
                    boolean ok = farmingPracticeService.updateFarmingPractice(id, tenQuyTrinh, moTa, loaiApDung, trangThai);
                    session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                            ok ? "Cập nhật quy trình thành công!" : "Cập nhật quy trình thất bại.");
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect(request.getContextPath() + "/technician?view=process");
            return;

        } else if ("create".equals(action)) {
            String tenQuyTrinh = request.getParameter("processName");
            String moTa = request.getParameter("description");
            String loaiApDung = request.getParameter("loaiApDung");
            Integer userId = (Integer) session.getAttribute("userId");

            models.FarmingPractice fp = new models.FarmingPractice();
            fp.setTenQuyTrinh(tenQuyTrinh);
            fp.setMoTa(moTa);
            fp.setLoaiApDung(loaiApDung);
            fp.setNgayTao(java.time.LocalDate.now());
            fp.setNguoiTao(userId);

            boolean ok = farmingPracticeService.createFarmingPractice(fp);
            session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                    ok ? "Tạo bộ quy chuẩn mới thành công!" : "Vui lòng nhập đầy đủ thông tin.");
            response.sendRedirect(request.getContextPath() + "/technician?view=process");
            return;

        // ================= 2) QUẢN LÝ RAU TRỒNG =================
        } else if ("addVegetable".equals(action)) {
            try {
                Vegetable v = new Vegetable();
                v.setTenRau(request.getParameter("tenRau"));
                v.setLoaiRau(request.getParameter("loaiRau"));
                v.setGiong(request.getParameter("giong"));
                v.setMaKhuVuc(Integer.parseInt(request.getParameter("maKhuVuc")));
                v.setNgayGieo(LocalDate.parse(request.getParameter("ngayGieo")));
                v.setNgayThuHoachDuKien(LocalDate.parse(request.getParameter("ngayThuHoachDuKien")));
                v.setDienTich(Double.parseDouble(request.getParameter("dienTich")));
                v.setSoLuong(Integer.parseInt(request.getParameter("soLuong")));
                v.setGhiChu(request.getParameter("ghiChu"));

                boolean ok = vegetableDAO.insertVegetable(v);
                session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                        ok ? "Thêm rau trồng thành công!" : "Thêm rau trồng thất bại.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("ERROR_MSG", "Dữ liệu không hợp lệ: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/technician?view=vegetable");
            return;

        } else if ("editVegetable".equals(action)) {
            try {
                Vegetable v = new Vegetable();
                v.setMaRau(Integer.parseInt(request.getParameter("maRau")));
                v.setTenRau(request.getParameter("tenRau"));
                v.setLoaiRau(request.getParameter("loaiRau"));
                v.setGiong(request.getParameter("giong"));
                v.setMaKhuVuc(Integer.parseInt(request.getParameter("maKhuVuc")));
                v.setNgayGieo(LocalDate.parse(request.getParameter("ngayGieo")));
                v.setNgayThuHoachDuKien(LocalDate.parse(request.getParameter("ngayThuHoachDuKien")));
                v.setDienTich(Double.parseDouble(request.getParameter("dienTich")));
                v.setSoLuong(Integer.parseInt(request.getParameter("soLuong")));
                v.setTrangThai(request.getParameter("trangThai"));
                v.setGhiChu(request.getParameter("ghiChu"));

                boolean ok = vegetableDAO.updateVegetable(v);
                session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                        ok ? "Cập nhật rau trồng thành công!" : "Cập nhật rau trồng thất bại.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("ERROR_MSG", "Dữ liệu không hợp lệ: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/technician?view=vegetable");
            return;

        // ================= 3) QUẢN LÝ THU HOẠCH RAU =================
        } else if ("harvestVegetable".equals(action)) {
            try {
                VegetableHarvest h = new VegetableHarvest();
                h.setMaRau(Integer.parseInt(request.getParameter("maRau")));
                h.setNgayThuHoach(LocalDate.parse(request.getParameter("ngayThuHoach")));
                h.setSoLuongThuHoach(Integer.parseInt(request.getParameter("soLuongThuHoach")));
                h.setChatLuong(request.getParameter("chatLuong"));
                h.setGiaTriUocTinh(Double.parseDouble(request.getParameter("giaTriUocTinh")));
                h.setNguoiThuHoach(Integer.parseInt(request.getParameter("nguoiThuHoach")));
                h.setGhiChu(request.getParameter("ghiChu"));

                boolean ok = harvestDAO.insertHarvestAndUpdateVegetable(h);
                session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                        ok ? "Ghi nhận thu hoạch thành công!"
                           : "Thu hoạch thất bại: số lượng không hợp lệ hoặc vượt quá số lượng rau hiện có.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("ERROR_MSG", "Dữ liệu không hợp lệ: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/technician?view=harvest");
            return;

        // ================= 3b) QUẢN LÝ THU HOẠCH VẬT NUÔI =================
        } else if ("harvestLiveStock".equals(action)) {
            try {
                LiveStockHarvest h = new LiveStockHarvest();
                h.setMaVatNuoi(Integer.parseInt(request.getParameter("maVatNuoiHarvest")));
                h.setNgayThuHoach(LocalDate.parse(request.getParameter("ngayThuHoachVN")));
                h.setSoLuongThuHoach(Integer.parseInt(request.getParameter("soLuongThuHoachVN")));
                h.setChatLuong(request.getParameter("chatLuongVN"));
                h.setGiaTriUocTinh(Double.parseDouble(request.getParameter("giaTriUocTinhVN")));
                h.setNguoiThuHoach(Integer.parseInt(request.getParameter("nguoiThuHoachVN")));
                h.setGhiChu(request.getParameter("ghiChuVN"));

                boolean ok = liveStockHarvestDAO.insertHarvestAndUpdateLiveStock(h);
                session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                        ok ? "Ghi nhận thu hoạch vật nuôi thành công!"
                           : "Thu hoạch thất bại: vật nuôi không ở trạng thái Khỏe mạnh, hoặc số lượng không hợp lệ / vượt quá số lượng hiện có.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("ERROR_MSG", "Dữ liệu không hợp lệ: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/technician?view=harvest");
            return;

        // ================= 4) QUẢN LÝ VẬT NUÔI =================
        } else if ("addLiveStock".equals(action)) {
            try {
                LiveStock ls = new LiveStock();
                ls.setTenVatNuoi(request.getParameter("tenVatNuoi"));
                ls.setLoaiVatNuoi(request.getParameter("loaiVatNuoi"));
                ls.setGiong(request.getParameter("giong"));
                ls.setNgayNhap(LocalDate.parse(request.getParameter("ngayNhap")));
                ls.setSoLuong(Integer.parseInt(request.getParameter("soLuong")));
                ls.setTrongLuongTrungBinh(Double.parseDouble(request.getParameter("trongLuongTrungBinh")));
                ls.setMaKhuVuc(Integer.parseInt(request.getParameter("maKhuVuc")));
                ls.setTrangThai(request.getParameter("trangThai"));
                ls.setGhiChu(request.getParameter("ghiChu"));

                boolean ok = liveStockDAO.insertLiveStock(ls);
                session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                        ok ? "Thêm vật nuôi thành công!" : "Thêm vật nuôi thất bại.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("ERROR_MSG", "Dữ liệu không hợp lệ: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/technician?view=livestock");
            return;

        } else if ("editLiveStock".equals(action)) {
            try {
                LiveStock ls = new LiveStock();
                ls.setMaVatNuoi(Integer.parseInt(request.getParameter("maVatNuoi")));
                ls.setTenVatNuoi(request.getParameter("tenVatNuoi"));
                ls.setLoaiVatNuoi(request.getParameter("loaiVatNuoi"));
                ls.setGiong(request.getParameter("giong"));
                ls.setNgayNhap(LocalDate.parse(request.getParameter("ngayNhap")));
                ls.setSoLuong(Integer.parseInt(request.getParameter("soLuong")));
                ls.setTrongLuongTrungBinh(Double.parseDouble(request.getParameter("trongLuongTrungBinh")));
                ls.setMaKhuVuc(Integer.parseInt(request.getParameter("maKhuVuc")));
                ls.setTrangThai(request.getParameter("trangThai"));
                ls.setGhiChu(request.getParameter("ghiChu"));

                boolean ok = liveStockDAO.updateLiveStock(ls);
                session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                        ok ? "Cập nhật vật nuôi thành công!" : "Cập nhật vật nuôi thất bại.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("ERROR_MSG", "Dữ liệu không hợp lệ: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/technician?view=livestock");
            return;

        } else if ("importLiveStock".equals(action)) {
            try {
                int maVatNuoi = Integer.parseInt(request.getParameter("maVatNuoi"));
                int soLuong = Integer.parseInt(request.getParameter("soLuongNhap"));
                boolean ok = liveStockDAO.importQuantity(maVatNuoi, soLuong);
                session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                        ok ? "Nhập vật nuôi thành công!" : "Nhập vật nuôi thất bại. Số lượng phải lớn hơn 0.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("ERROR_MSG", "Dữ liệu không hợp lệ: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/technician?view=livestock");
            return;

        } else if ("exportLiveStock".equals(action)) {
            try {
                int maVatNuoi = Integer.parseInt(request.getParameter("maVatNuoi"));
                int soLuong = Integer.parseInt(request.getParameter("soLuongXuat"));
                boolean ok = liveStockDAO.exportQuantity(maVatNuoi, soLuong);
                session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                        ok ? "Xuất vật nuôi thành công!" : "Xuất vật nuôi thất bại: số lượng không hợp lệ hoặc vượt quá tồn hiện có.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("ERROR_MSG", "Dữ liệu không hợp lệ: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/technician?view=livestock");
            return;
        // ================= PHÂN CÔNG CÔNG VIỆC MỚI =================
        } else if ("assignTask".equals(action)) {
            try {
                String tenCongViec = request.getParameter("tenCongViec");
                String moTa = request.getParameter("moTa");
                int maQuyTrinh = Integer.parseInt(request.getParameter("maQuyTrinh"));
                int maKhuVuc = Integer.parseInt(request.getParameter("maKhuVuc"));
                int nguoiPhuTrach = Integer.parseInt(request.getParameter("nguoiPhuTrach"));
                LocalDate ngayBatDau = LocalDate.parse(request.getParameter("ngayBatDau"));
                LocalDate ngayKetThuc = LocalDate.parse(request.getParameter("ngayKetThuc"));

                Integer nguoiThucHien = (Integer) session.getAttribute("userId");
                if (nguoiThucHien == null) nguoiThucHien = 1; // Giá trị dự phòng nếu session trống

                models.Task newTask = new models.Task(0, tenCongViec, moTa, maQuyTrinh, maKhuVuc, nguoiPhuTrach, ngayBatDau, ngayKetThuc, "Chưa thực hiện");

                // Gọi Service hoặc trực tiếp DAO để thêm Task và phân công
                boolean ok = farmingPracticeService.addTaskAndAssign(newTask, nguoiThucHien);
                
                session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                        ok ? "Phân công công việc mới thành công!" : "Phân công công việc thất bại.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("ERROR_MSG", "Lỗi phân công công việc: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/technician?view=process");
            return;
        }

        // Không khớp action nào -> quay lại trang mặc định
        response.sendRedirect(request.getContextPath() + "/technician");
    }
}