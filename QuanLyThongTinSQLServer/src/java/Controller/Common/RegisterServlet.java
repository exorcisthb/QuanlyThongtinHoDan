package Controller.Common;

import Model.DAO.NguoiDungDAO;
import Model.Entity.NguoiDung;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final NguoiDungDAO dao = new NguoiDungDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("nguoiDung") != null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/Views/Common/Register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email = trim(req.getParameter("email"));
        String matKhau = req.getParameter("matKhau");
        String xacNhan = req.getParameter("xacNhanMatKhau");
        String cccd = trim(req.getParameter("cccd"));
        String ho = trim(req.getParameter("ho"));
        String ten = trim(req.getParameter("ten"));
        String ngaySinhStr = trim(req.getParameter("ngaySinh"));
        String sdt = trim(req.getParameter("soDienThoai"));

        boolean hasError = false;

        // ── Giữ lại giá trị form ──────────────────────────────────────
        req.setAttribute("oldEmail", email);
        req.setAttribute("oldCccd", cccd);
        req.setAttribute("oldHo", ho);
        req.setAttribute("oldTen", ten);
        req.setAttribute("oldNgaySinh", ngaySinhStr);
        req.setAttribute("oldSdt", sdt);

        // ── Validate từng field riêng lẻ ─────────────────────────────
        if (blank(email)) {
            req.setAttribute("errEmail", "Vui lòng nhập Gmail");
            hasError = true;
        } else if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            req.setAttribute("errEmail", "Email không hợp lệ");
            hasError = true;
        } else if (dao.isEmailExist(email)) {
            req.setAttribute("errEmail", "Email này đã được sử dụng");
            hasError = true;
        }

        if (blank(matKhau) || matKhau.length() < 6) {
            req.setAttribute("errMatKhau", "Mật khẩu phải có ít nhất 6 ký tự");
            hasError = true;
        }

        if (blank(xacNhan) || !xacNhan.equals(matKhau)) {
            req.setAttribute("errXacNhan", "Mật khẩu xác nhận không khớp");
            hasError = true;
        }

        if (blank(cccd) || !cccd.matches("\\d{12}")) {
            req.setAttribute("errCccd", "CCCD phải đúng 12 chữ số");
            hasError = true;
        }

        if (blank(ho)) {
            req.setAttribute("errHo", "Vui lòng nhập họ");
            hasError = true;
        }

        if (blank(ten)) {
            req.setAttribute("errTen", "Vui lòng nhập tên");
            hasError = true;
        }

        if (blank(ngaySinhStr)) {
            req.setAttribute("errNgaySinh", "Vui lòng chọn ngày sinh");
            hasError = true;
        }

        if (blank(sdt)) {
            req.setAttribute("errSdt", "Vui lòng nhập số điện thoại");
            hasError = true;
        }

        if (hasError) {
            forward(req, resp);
            return;
        }

        // ── Parse ngày sinh ───────────────────────────────────────────
        Date ngaySinh;
        try {
            ngaySinh = Date.valueOf(ngaySinhStr);
        } catch (Exception e) {
            req.setAttribute("errNgaySinh", "Ngày sinh không hợp lệ");
            forward(req, resp);
            return;
        }

        // ── Tìm bản ghi đã import theo CCCD ──────────────────────────
        NguoiDung nd = dao.findChuaKichHoatByCCCD(cccd);
        if (nd == null) {
            req.setAttribute("errCccd",
                    "CCCD không tồn tại hoặc tài khoản đã được đăng ký. "
                    + "Liên hệ cán bộ phường để được hỗ trợ.");
            forward(req, resp);
            return;
        }

        // ── Xác minh từng trường, báo lỗi CỤ THỂ ─────────────────────
        boolean infoError = false;

        if (!nd.getHo().trim().equalsIgnoreCase(ho)) {
            req.setAttribute("errHo", "Họ không khớp với dữ liệu hệ thống");
            infoError = true;
        }
        if (!nd.getTen().trim().equalsIgnoreCase(ten)) {
            req.setAttribute("errTen", "Tên không khớp với dữ liệu hệ thống");
            infoError = true;
        }
        if (nd.getNgaySinh() == null || !nd.getNgaySinh().equals(ngaySinh)) {
            req.setAttribute("errNgaySinh", "Ngày sinh không khớp với dữ liệu hệ thống");
            infoError = true;
        }
        if (nd.getSoDienThoai() == null || !nd.getSoDienThoai().trim().equals(sdt)) {
            req.setAttribute("errSdt", "Số điện thoại không khớp với dữ liệu hệ thống");
            infoError = true;
        }

        if (infoError) {
            forward(req, resp);
            return;
        }

        // ── Kích hoạt tài khoản ───────────────────────────────────────
        String hash = BCrypt.hashpw(matKhau, BCrypt.gensalt(12));
        boolean ok = dao.kichHoatTaiKhoan(nd.getNguoiDungID(), email.toLowerCase(), hash);

        if (!ok) {
            req.setAttribute("error", "Đăng ký thất bại, vui lòng thử lại.");
            forward(req, resp);
            return;
        }

        // ── Thành công ────────────────────────────────────────────────
        // ── Thành công ────────────────────────────────────────────────
        req.setAttribute("dangKyThanhCong", true);
        req.setAttribute("tenNguoiDung", nd.getHo() + " " + nd.getTen());
        forward(req, resp);
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/Views/Common/Register.jsp").forward(req, resp);
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private boolean blank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
