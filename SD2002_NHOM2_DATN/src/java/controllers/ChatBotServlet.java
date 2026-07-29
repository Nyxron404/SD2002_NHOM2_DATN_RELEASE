package controllers;

import dao.ChatDAO;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import models.ChatHistory;
import uril.DBConnect;

@WebServlet(name = "ChatBotServlet", urlPatterns = {"/api/chat"})
public class ChatBotServlet extends HttpServlet {

    private static final String OLLAMA_API_URL = "http://localhost:11434/api/generate";
    private static final String MODEL_NAME = "qwen2.5:7b";
    
    private ChatDAO chatDAO = new ChatDAO();
    
    private Integer getUserIdFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            return (Integer) session.getAttribute("userId");
        }
        return null;
    }

    // ================= CÁC HÀM LẤY DỮ LIỆU ĐỘNG TỪNG BẢNG =================
    
    // 1. Dữ liệu Nhân sự
    private String getStaffContext() {
        StringBuilder data = new StringBuilder("[DỮ LIỆU NHÂN SỰ]\n");
        String sql = "SELECT MaNhanVien, HoTen, SDT, DiaChi FROM Staff";
        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.append("- ").append(rs.getString("HoTen"))
                    .append(" (Mã: ").append(rs.getInt("MaNhanVien"))
                    .append(", SĐT: ").append(rs.getString("SDT"))
                    .append(", Ở: ").append(rs.getString("DiaChi")).append(")\n");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return data.toString();
    }

    // 2. Dữ liệu Thiết bị
    private String getEquipmentContext() {
        StringBuilder data = new StringBuilder("[DỮ LIỆU THIẾT BỊ]\n");
        String sql = "SELECT TenThietBi, LoaiThietBi, TinhTrang FROM Equipment";
        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.append("- ").append(rs.getString("TenThietBi"))
                    .append(" (Loại: ").append(rs.getString("LoaiThietBi"))
                    .append(", Tình trạng: ").append(rs.getString("TinhTrang")).append(")\n");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return data.toString();
    }

    // 3. Dữ liệu Khu vực (FarmArea)
    private String getFarmAreaContext() {
        StringBuilder data = new StringBuilder("[DỮ LIỆU KHU VỰC CANH TÁC]\n");
        String sql = "SELECT TenKhuVuc, LoaiKhuVuc, DienTich FROM FarmArea";
        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.append("- ").append(rs.getString("TenKhuVuc"))
                    .append(" (Loại: ").append(rs.getString("LoaiKhuVuc"))
                    .append(", Diện tích: ").append(rs.getDouble("DienTich")).append(" m2)\n");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return data.toString();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ... (Giữ nguyên đoạn code doGet tải lịch sử của bạn) ...
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        Integer maNguoiDung = getUserIdFromSession(request);
        
        if (maNguoiDung == null) {
            response.getWriter().write("<div class=\"ai-message bot\">Vui lòng đăng nhập.</div>"); return;
        }

        if ("getSessions".equals(action)) {
            List<String> sessions = chatDAO.getSessionsByUser(maNguoiDung);
            StringBuilder html = new StringBuilder();
            if (sessions.isEmpty()) {
                html.append("<div style='padding:15px; text-align:center; color:#666;'>Chưa có lịch sử trò chuyện.</div>");
            } else {
                int count = sessions.size();
                for (String s : sessions) {
                    html.append("<div class='session-item' onclick=\"loadSpecificSession('").append(s).append("')\">")
                        .append("💬 Cuộc trò chuyện ").append(count--).append("</div>");
                }
            }
            response.getWriter().write(html.toString());
        } else { 
            String sessionId = request.getParameter("sessionId");
            if (sessionId == null) sessionId = "";

            List<ChatHistory> history = chatDAO.getChatsBySession(maNguoiDung, sessionId);
            StringBuilder html = new StringBuilder();
            if (history.isEmpty()) {
                html.append("<div class=\"ai-message bot\">Chào bạn! Mình là trợ lý AI. Mình có thể giúp gì cho nông trại hôm nay?</div>");
            } else {
                for (ChatHistory chat : history) {
                    html.append("<div class=\"ai-message ").append(chat.getSenderRole()).append("\">")
                        .append(chat.getMessageContent()).append("</div>");
                }
            }
            response.getWriter().write(html.toString());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");

        Integer maNguoiDung = getUserIdFromSession(request);
        if (maNguoiDung == null) {
            response.getWriter().write("Phiên đăng nhập đã hết hạn."); return;
        }

        String userMessage = request.getParameter("message");
        String sessionId = request.getParameter("sessionId");
        
        if (sessionId == null || sessionId.trim().isEmpty()) sessionId = "DEFAULT_SESSION";
        if (userMessage == null || userMessage.trim().isEmpty()) {
            response.getWriter().write("Tin nhắn rỗng."); return;
        }

        chatDAO.insertChat(maNguoiDung, sessionId, "user", userMessage);

        try {
            // =========================================================
            // SMART ROUTER: PHÂN TÍCH TỪ KHÓA ĐỂ BƠM DỮ LIỆU TƯƠNG ỨNG
            // =========================================================
            String dbContext = "";
            String msgLower = userMessage.toLowerCase();
            
            if (msgLower.contains("nhân viên") || msgLower.contains("nhân sự") || msgLower.contains("ai") || msgLower.contains("linh")) {
                dbContext = getStaffContext();
            } 
            else if (msgLower.contains("thiết bị") || msgLower.contains("máy móc") || msgLower.contains("công cụ")) {
                dbContext = getEquipmentContext();
            } 
            else if (msgLower.contains("khu vực") || msgLower.contains("chuồng") || msgLower.contains("ruộng") || msgLower.contains("diện tích")) {
                dbContext = getFarmAreaContext();
            }

            // Lấy Lịch sử trò chuyện gần nhất
            List<ChatHistory> historyList = chatDAO.getChatsBySession(maNguoiDung, sessionId);
            StringBuilder historyContext = new StringBuilder();
            int start = Math.max(0, historyList.size() - 6);
            for (int i = start; i < historyList.size(); i++) {
                ChatHistory h = historyList.get(i);
                String role = h.getSenderRole().equals("user") ? "Người dùng" : "Trợ lý AI";
                String cleanMsg = h.getMessageContent().replace("<br>", " ");
                historyContext.append(role).append(": ").append(cleanMsg).append("\n");
            }

            // Lắp ráp Prompt thông minh
            String systemPrompt = "Bạn là trợ lý AI ảo của hệ thống Smart Farm. Trả lời bằng tiếng Việt gọn gàng, tự nhiên.\n";
            
            // Chỉ thêm dbContext nếu Router tìm thấy từ khóa
            if (!dbContext.isEmpty()) {
                systemPrompt += "Dựa vào DỮ LIỆU HỆ THỐNG sau đây để trả lời câu hỏi của người dùng:\n" + dbContext + "\n";
            }
            
            systemPrompt += "--- LỊCH SỬ TRÒ CHUYỆN GẦN ĐÂY ---\n"
                         + historyContext.toString()
                         + "Người dùng: " + userMessage + "\nTrợ lý AI:";
            
            systemPrompt = systemPrompt.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
            
            String jsonBody = "{\n" +
                              "  \"model\": \"" + MODEL_NAME + "\",\n" +
                              "  \"prompt\": \"" + systemPrompt + "\",\n" +
                              "  \"stream\": false\n" +
                              "}";

            URL url = new URL(OLLAMA_API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setDoOutput(true);
            conn.setConnectTimeout(60000);
            conn.setReadTimeout(60000);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonBody.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
                StringBuilder responseStr = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) responseStr.append(line.trim());
                
                String answer = extractOllamaResponse(responseStr.toString());
                String formattedAnswer = answer.replace("\n", "<br>");
                
                chatDAO.insertChat(maNguoiDung, sessionId, "bot", formattedAnswer);
                response.getWriter().write(formattedAnswer);
            } else {
                response.getWriter().write("Lỗi kết nối tới Ollama. Mã lỗi: " + conn.getResponseCode());
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Không thể kết nối. Bạn hãy kiểm tra xem ứng dụng Ollama đang chạy ngầm chưa nhé!");
        }
    }

    private String extractOllamaResponse(String json) {
        try {
            String key = "\"response\":\"";
            int start = json.indexOf(key);
            if (start == -1) {
                key = "\"response\": \""; 
                start = json.indexOf(key);
            }
            if (start == -1) return "Lỗi: Không đọc được phản hồi.";
            
            start += key.length();
            int end = start;
            while (end < json.length()) {
                if (json.charAt(end) == '"' && json.charAt(end - 1) != '\\') break;
                end++;
            }
            String text = json.substring(start, end);
            return text.replace("\\n", "\n").replace("\\\"", "\"").replace("\\\\", "\\").replace("**", "");
        } catch (Exception e) {
            return "Lỗi phân tích cú pháp dữ liệu từ Ollama.";
        }
    }
}