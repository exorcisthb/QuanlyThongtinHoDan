package Model.Service;

import Model.DAO.QuenMatKhauDAO;
import Model.Entity.NguoiDung;
import Model.Entity.TokenResetMatKhau;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.Timestamp;
import java.util.UUID;

public class QuenMatKhauService {

    private final QuenMatKhauDAO dao = new QuenMatKhauDAO();

    // ==================== VERIFY ====================

    // ── MỚI: Bước 1 - kiểm tra Gmail ──
    public NguoiDung timNguoiDungTheoEmail(String email) {
        if (email == null || email.trim().isEmpty()) return null;
        return dao.timNguoiDungTheoEmail(email.trim());
    }

    // Bước 2 - xác minh CCCD + SĐT
    public NguoiDung xacMinhNguoiDung(String cccd, String soDienThoai) {
        if (cccd == null || cccd.trim().isEmpty() ||
            soDienThoai == null || soDienThoai.trim().isEmpty()) {
            return null;
        }
        return dao.timNguoiDungTheoCCCDvaSoDienThoai(cccd.trim(), soDienThoai.trim());
    }

    public boolean kiemTraCCCD(String cccd) {
        if (cccd == null || cccd.trim().isEmpty()) return false;
        return dao.kiemTraCCCDTonTai(cccd.trim());
    }

    // ==================== TOKEN ====================

    public String taoVaLuuToken(int nguoiDungID) {
        String token = UUID.randomUUID().toString();
        Timestamp ngayHetHan = new Timestamp(System.currentTimeMillis() + 15 * 60 * 1000);
        boolean ok = dao.luuToken(nguoiDungID, token, ngayHetHan);
        return ok ? token : null;
    }

    public boolean kiemTraTokenHopLe(String token) {
        if (token == null || token.trim().isEmpty()) return false;
        return dao.kiemTraTokenHopLe(token);
    }

    public TokenResetMatKhau layThongTinToken(String token) {
        if (token == null || token.trim().isEmpty()) return null;
        return dao.timTheoToken(token);
    }

    // ==================== DOI MAT KHAU ====================

    public boolean doiMatKhau(String token, String matKhauMoi, String xacNhanMatKhau) {
        if (!kiemTraTokenHopLe(token)) return false;
        if (!validateMatKhau(matKhauMoi, xacNhanMatKhau)) return false;

        TokenResetMatKhau t = dao.timTheoToken(token);
        if (t == null) return false;

        String matKhauHash = BCrypt.hashpw(matKhauMoi, BCrypt.gensalt());
        boolean ok = dao.capNhatMatKhau(t.getNguoiDungID(), matKhauHash);

        if (ok) dao.xoaToken(token);
        return ok;
    }

    // ==================== VALIDATE ====================

    private boolean validateMatKhau(String matKhauMoi, String xacNhan) {
        if (matKhauMoi == null || matKhauMoi.trim().isEmpty()) return false;
        if (matKhauMoi.length() < 6) return false;
        if (!matKhauMoi.equals(xacNhan)) return false;
        return true;
    }
}