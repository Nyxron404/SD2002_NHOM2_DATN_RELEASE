package dao;

import models.ChatHistory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import uril.DBConnect;

public class ChatDAO {
    
    // Thêm tin nhắn có kèm SessionId
    public void insertChat(int maNguoiDung, String sessionId, String senderRole, String messageContent) {
        String sql = "INSERT INTO ChatHistory (MaNguoiDung, SessionId, SenderRole, MessageContent) VALUES (?, ?, ?, ?)";
        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);
            ps.setString(2, sessionId);
            ps.setString(3, senderRole);
            ps.setString(4, messageContent);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy danh sách các ID cuộc trò chuyện của User
    public List getSessionsByUser(int maNguoiDung) {
        List list = new ArrayList<>();
        String sql = "SELECT SessionId FROM ChatHistory WHERE MaNguoiDung = ? GROUP BY SessionId ORDER BY MIN(CreatedAt) DESC";
        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getString("SessionId"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy nội dung của 1 cuộc trò chuyện cụ thể
    public List getChatsBySession(int maNguoiDung, String sessionId) {
        List list = new ArrayList<>();
        String sql = "SELECT * FROM ChatHistory WHERE MaNguoiDung = ? AND SessionId = ? ORDER BY CreatedAt ASC";
        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);
            ps.setString(2, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChatHistory chat = new ChatHistory();
                    chat.setId(rs.getInt("Id"));
                    chat.setMaNguoiDung(rs.getInt("MaNguoiDung"));
                    chat.setSessionId(rs.getString("SessionId"));
                    chat.setSenderRole(rs.getString("SenderRole"));
                    chat.setMessageContent(rs.getString("MessageContent"));
                    chat.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    list.add(chat);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}