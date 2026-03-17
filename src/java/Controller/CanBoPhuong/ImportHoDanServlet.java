package Controller.CanBoPhuong;

import Model.Entity.ImportResult;
import Model.Entity.NguoiDung;
import Model.Service.HoDanService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;

@WebServlet("/canbophuong/import-hodan")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class ImportHoDanServlet extends HttpServlet {

    private final HoDanService hoDanService = new HoDanService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("nguoiDung") != null) {
            req.setAttribute("currentUser", session.getAttribute("nguoiDung"));
        }
        req.getRequestDispatcher("/Views/CanBoPhuong/ImportHoDan.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        NguoiDung currentUser = (session != null)
                ? (NguoiDung) session.getAttribute("nguoiDung") : null;

        System.out.println("=== ImportHoDanServlet POST ===");
        System.out.println("currentUser: " + currentUser);

        if (currentUser == null) {
            System.out.println(">> currentUser NULL -> redirect login");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Part filePart = null;
        try {
            filePart = req.getPart("excelFile");
        } catch (Exception e) {
            System.out.println(">> Lỗi getPart: " + e.getMessage());
            req.setAttribute("errorMsg", "Lỗi đọc file upload: " + e.getMessage());
            req.setAttribute("currentUser", currentUser);
            req.getRequestDispatcher("/Views/CanBoPhuong/ImportHoDan.jsp").forward(req, resp);
            return;
        }

        if (filePart == null || filePart.getSize() == 0) {
            req.setAttribute("errorMsg", "Vui lòng chọn file Excel để import.");
            req.setAttribute("currentUser", currentUser);
            req.getRequestDispatcher("/Views/CanBoPhuong/ImportHoDan.jsp").forward(req, resp);
            return;
        }

        String fileName = filePart.getSubmittedFileName();
        System.out.println("fileName: " + fileName);

        if (fileName == null || (!fileName.endsWith(".xlsx") && !fileName.endsWith(".xls"))) {
            req.setAttribute("errorMsg", "Chỉ chấp nhận file .xlsx hoặc .xls");
            req.setAttribute("currentUser", currentUser);
            req.getRequestDispatcher("/Views/CanBoPhuong/ImportHoDan.jsp").forward(req, resp);
            return;
        }

        try (InputStream inputStream = filePart.getInputStream()) {
            // Cán bộ phường import tổng — không gán tổ, truyền 0
            ImportResult result = hoDanService.importFromExcel(inputStream, 0);
            System.out.println("Import result: total=" + result.getTotal()
                    + " success=" + result.getSuccess()
                    + " errors=" + result.getErrors().size());
            req.setAttribute("importResult", result);
            req.setAttribute("fileName", fileName);
        } catch (Exception e) {
            System.out.println(">> Lỗi importFromExcel: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("errorMsg", "Lỗi xử lý file: " + e.getMessage());
        }

        req.setAttribute("currentUser", currentUser);
        req.getRequestDispatcher("/Views/CanBoPhuong/ImportHoDan.jsp").forward(req, resp);
    }
}