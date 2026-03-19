package Model.Service;

import Model.DAO.ThiepMoiDAO;
import Model.Entity.ThiepMoi;
import java.util.List;

public class ThiepMoiService {

    private final ThiepMoiDAO dao = new ThiepMoiDAO();

    public List<ThiepMoi> getDanhSach(String keyword, int toDanPhoID, int trangThaiID) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            return dao.search(keyword.trim());
        }
        if (toDanPhoID > 0) {
            return dao.getByTo(toDanPhoID);
        }
        if (trangThaiID > 0) {
            return dao.getByTrangThai(trangThaiID);
        }
        return dao.getAll();
    }

    public ThiepMoi getChiTiet(int id) {
        return dao.getByID(id);
    }

    public boolean taoThiepMoi(ThiepMoi t, int nguoiTaoID) {
        if (t.getTieuDe() == null || t.getTieuDe().trim().isEmpty()) return false;
        if (t.getThoiGianBatDau() == null) return false;
        if (t.getToDanPhoID() <= 0) return false;
        return dao.taoThiepMoi(t, nguoiTaoID);
    }

    public boolean suaThiepMoi(ThiepMoi t, int nguoiSuaID) {
        if (t.getTieuDe() == null || t.getTieuDe().trim().isEmpty()) return false;
        if (t.getThoiGianBatDau() == null) return false;

        ThiepMoi hienTai = dao.getByID(t.getThiepMoiID());
        if (hienTai == null) return false;
        if (hienTai.isDaIn()) return false;

        // Validation trạng thái để DAO tự xử lý
        return dao.suaThiepMoi(t, nguoiSuaID);
    }

    public boolean xoaThiepMoi(int thiepMoiID, int nguoiXoaID) {
        return dao.xoaThiepMoi(thiepMoiID, nguoiXoaID);
    }

    public boolean inThiepMoi(int thiepMoiID, int nguoiInID) {
        return dao.inThiepMoi(thiepMoiID, nguoiInID);
    }

    public boolean tamHoanThiepMoi(int thiepMoiID, int nguoiThucHienID, String ghiChuHoan) {
        if (ghiChuHoan == null || ghiChuHoan.trim().isEmpty()) return false;
        return dao.tamHoanThiepMoi(thiepMoiID, nguoiThucHienID, ghiChuHoan.trim());
    }

    public boolean moLaiThiepMoi(int thiepMoiID, int nguoiThucHienID,
                                  java.sql.Timestamp thoiGianBatDau, java.sql.Timestamp thoiGianKetThuc,
                                  String noiDung, String diaDiem) {
        if (thoiGianBatDau == null) return false;
        if (thoiGianBatDau.getTime() <= System.currentTimeMillis()) return false;
        if (diaDiem == null || diaDiem.trim().isEmpty()) return false;
        return dao.moLaiThiepMoi(thiepMoiID, nguoiThucHienID,
                                  thoiGianBatDau, thoiGianKetThuc,
                                  noiDung, diaDiem.trim());
    }
}