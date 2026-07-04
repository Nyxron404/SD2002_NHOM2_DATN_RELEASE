/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers;

import dao.StaffDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import models.Staff;
import services.HrManagerService;

/**
 *
 * @author longd
 */
@WebServlet(name="hrManagerServlet", urlPatterns={"/hr"})
public class HrManagerServlet extends HttpServlet {
   
    private HrManagerService hrService = new HrManagerService();
    private StaffDAO stDAO = new StaffDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setAttribute("LIST_STAFF", stDAO.SelectStaff());
        request.getRequestDispatcher("./views/hrManager/hrManager.jsp").forward(request, response);
    } 
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            
        }
        
        request.setAttribute("LIST_STAFF", stDAO.SelectStaff());
        request.getRequestDispatcher("./views/hrManager/hrManager.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
