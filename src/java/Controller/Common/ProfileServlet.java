package Controller.Common;

import Model.Entity.NguoiDung;
import Model.Service.NguoiDungService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.nio.file.*;

@WebServlet("/profile")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class ProfileServlet extends HttpServlet {

    private final NguoiDungService nguoiDungService = new NguoiDungService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        NguoiDung nd = getUser(session);
        if (nd == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Flash message
        if (session.getAttribute("message") != null) {
            request.setAttribute("message", session.getAttribute("message"));
            session.removeAttribute("message");
        }
        if (session.getAttribute("error") != null) {
            request.setAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }

        // ✅ Lấy đúng người đang đăng nhập từ session, forward về 1 JSP duy nhất
        request.setAttribute("profile", nd);
        request.getRequestDispatcher("/Views/Common/Profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        NguoiDung nd = getUser(session);
        if (nd == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Part filePart = request.getPart("avatar");

            if (filePart == null || filePart.getSize() == 0
                    || filePart.getSubmittedFileName() == null
                    || filePart.getSubmittedFileName().isBlank()) {
                session.setAttribute("error", "Vui lòng chọn file ảnh.");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }

            String fileName = buildFileName(filePart, nd.getNguoiDungID());
            if (fileName == null) {
                session.setAttribute("error",
                        "Chỉ chấp nhận JPG, PNG, GIF, WEBP. Kích thước tối đa 5MB.");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }

            String uploadDir = getServletContext().getRealPath("/uploads/avatars");
            Files.createDirectories(Paths.get(uploadDir));

            // Xóa avatar cũ nếu có
            if (nd.getAvatarPath() != null && !nd.getAvatarPath().isBlank()) {
                Path oldFile = Paths.get(
                        getServletContext().getRealPath("/"), nd.getAvatarPath());
                Files.deleteIfExists(oldFile);
            }

            Path dest = Paths.get(uploadDir, fileName);
            filePart.write(dest.toString());

            String relativePath = "uploads/avatars/" + fileName;
            boolean ok = nguoiDungService.updateAvatar(nd.getNguoiDungID(), relativePath);

            if (ok) {
                nd.setAvatarPath(relativePath);
                session.setAttribute("nguoiDung", nd);
                session.setAttribute("message", "Cập nhật ảnh đại diện thành công!");
            } else {
                Files.deleteIfExists(dest);
                session.setAttribute("error", "Lưu ảnh thất bại, vui lòng thử lại.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Đã xảy ra lỗi khi upload ảnh.");
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }

    private String buildFileName(Part part, int userId) {
        String original = Paths.get(part.getSubmittedFileName())
                .getFileName().toString();
        String ext = original.contains(".")
                ? original.substring(original.lastIndexOf('.')).toLowerCase()
                : "";
        if (!ext.matches("\\.(jpg|jpeg|png|gif|webp)")) return null;
        if (part.getSize() > 5 * 1024 * 1024) return null;
        return "avatar_" + userId + "_" + System.currentTimeMillis() + ext;
    }

    private NguoiDung getUser(HttpSession session) {
        if (session == null) return null;
        return (NguoiDung) session.getAttribute("nguoiDung");
    }
}