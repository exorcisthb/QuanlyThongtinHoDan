package Model.Service;

import Model.Common.VaiTroConst;
import Model.DAO.YeuCauDoiTrangThaiDAO;
import Model.DAO.ThongBaoDAO;

import java.util.*;

public class YeuCauDoiTrangThaiService {

    private final YeuCauDoiTrangThaiDAO yeuCauDAO = new YeuCauDoiTrangThaiDAO();
    private final ThongBaoDAO thongBaoDAO = new ThongBaoDAO();

    // ------------------------------------------------------------------ //
    //  TẠO YÊU CẦU (tổ trưởng)
    // ------------------------------------------------------------------ //
    public Map<String, Object> taoYeuCau(int hoDanID, int trangThaiCuID,
            int trangThaiMoiID, int nguoiYeuCauID,
            String lyDo) {
        Map<String, Object> result = new HashMap<>();

        if (lyDo == null || lyDo.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "Vui lòng nhập lý do yêu cầu.");
            return result;
        }

        if (trangThaiCuID == trangThaiMoiID) {
            result.put("success", false);
            result.put("message", "Trạng thái mới phải khác trạng thái hiện tại.");
            return result;
        }

        if (yeuCauDAO.dangCoYeuCauChoDuyet(hoDanID)) {
            result.put("success", false);
            result.put("message", "Hộ dân này đang có yêu cầu chờ duyệt, không thể tạo thêm.");
            return result;
        }

        boolean ok = yeuCauDAO.taoYeuCau(hoDanID, trangThaiCuID, trangThaiMoiID,
                nguoiYeuCauID, lyDo.trim());
        if (ok) {
            // Gửi thông báo đến toàn bộ cán bộ phường — dùng tên thay vì ID số
            thongBaoDAO.guiThongBaoTheoVaiTro(
                    "Yêu cầu đổi trạng thái hộ khẩu mới",
                    "Tổ trưởng vừa gửi yêu cầu đổi trạng thái cho hộ dân. Vui lòng kiểm tra và xử lý.",
                    nguoiYeuCauID,
                    VaiTroConst.CAN_BO_PHUONG
            );
            result.put("success", true);
            result.put("message", "Gửi yêu cầu thành công, đang chờ cán bộ phường xét duyệt.");
        } else {
            result.put("success", false);
            result.put("message", "Gửi yêu cầu thất bại, vui lòng thử lại.");
        }
        return result;
    }

    // ------------------------------------------------------------------ //
    //  DUYỆT YÊU CẦU (cán bộ phường)
    // ------------------------------------------------------------------ //
    public Map<String, Object> duyetYeuCau(int yeuCauID, int nguoiDuyetID, String ghiChu) {
        Map<String, Object> result = new HashMap<>();

        Map<String, Object> yeuCau = yeuCauDAO.layTheoID(yeuCauID);
        if (yeuCau == null) {
            result.put("success", false);
            result.put("message", "Không tìm thấy yêu cầu.");
            return result;
        }

        int trangThaiHienTai = (int) yeuCau.get("trangThaiYeuCauID");
        if (trangThaiHienTai != 1) {
            result.put("success", false);
            result.put("message", "Yêu cầu này đã được xử lý trước đó.");
            return result;
        }

        boolean ok = yeuCauDAO.duyetYeuCau(yeuCauID, nguoiDuyetID,
                ghiChu != null ? ghiChu.trim() : "");
        if (ok) {
            int nguoiYeuCauID = (int) yeuCau.get("nguoiYeuCauID");
            String maHoKhau   = (String) yeuCau.get("maHoKhau");
            thongBaoDAO.guiThongBaoCaNhan(
                    "Yêu cầu đổi trạng thái đã được duyệt",
                    "Yêu cầu đổi trạng thái hộ khẩu " + maHoKhau + " đã được cán bộ phường chấp thuận.",
                    nguoiDuyetID,
                    nguoiYeuCauID
            );
            result.put("success", true);
            result.put("message", "Duyệt yêu cầu thành công.");
        } else {
            result.put("success", false);
            result.put("message", "Duyệt yêu cầu thất bại, vui lòng thử lại.");
        }
        return result;
    }

    // ------------------------------------------------------------------ //
    //  TỪ CHỐI YÊU CẦU (cán bộ phường)
    // ------------------------------------------------------------------ //
    public Map<String, Object> tuChoiYeuCau(int yeuCauID, int nguoiDuyetID, String lyDoTuChoi) {
        Map<String, Object> result = new HashMap<>();

        if (lyDoTuChoi == null || lyDoTuChoi.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "Vui lòng nhập lý do từ chối.");
            return result;
        }

        Map<String, Object> yeuCau = yeuCauDAO.layTheoID(yeuCauID);
        if (yeuCau == null) {
            result.put("success", false);
            result.put("message", "Không tìm thấy yêu cầu.");
            return result;
        }

        int trangThaiHienTai = (int) yeuCau.get("trangThaiYeuCauID");
        if (trangThaiHienTai != 1) {
            result.put("success", false);
            result.put("message", "Yêu cầu này đã được xử lý trước đó.");
            return result;
        }

        boolean ok = yeuCauDAO.tuChoiYeuCau(yeuCauID, nguoiDuyetID, lyDoTuChoi.trim());
        if (ok) {
            int nguoiYeuCauID = (int) yeuCau.get("nguoiYeuCauID");
            String maHoKhau   = (String) yeuCau.get("maHoKhau");
            thongBaoDAO.guiThongBaoCaNhan(
                    "Yêu cầu đổi trạng thái bị từ chối",
                    "Yêu cầu đổi trạng thái hộ khẩu " + maHoKhau + " bị từ chối. Lý do: " + lyDoTuChoi.trim(),
                    nguoiDuyetID,
                    nguoiYeuCauID
            );
            result.put("success", true);
            result.put("message", "Đã từ chối yêu cầu.");
        } else {
            result.put("success", false);
            result.put("message", "Từ chối thất bại, vui lòng thử lại.");
        }
        return result;
    }

    // ------------------------------------------------------------------ //
    //  HUỶ YÊU CẦU (tổ trưởng tự huỷ)
    // ------------------------------------------------------------------ //
    public Map<String, Object> huyYeuCau(int yeuCauID, int nguoiYeuCauID) {
        Map<String, Object> result = new HashMap<>();

        Map<String, Object> yeuCau = yeuCauDAO.layTheoID(yeuCauID);
        if (yeuCau == null) {
            result.put("success", false);
            result.put("message", "Không tìm thấy yêu cầu.");
            return result;
        }

        int nguoiTao = (int) yeuCau.get("nguoiYeuCauID");
        if (nguoiTao != nguoiYeuCauID) {
            result.put("success", false);
            result.put("message", "Bạn không có quyền huỷ yêu cầu này.");
            return result;
        }

        int trangThaiHienTai = (int) yeuCau.get("trangThaiYeuCauID");
        if (trangThaiHienTai != 1) {
            result.put("success", false);
            result.put("message", "Chỉ có thể huỷ yêu cầu đang ở trạng thái chờ duyệt.");
            return result;
        }

        boolean ok = yeuCauDAO.huyYeuCau(yeuCauID, nguoiYeuCauID);
        if (ok) {
            result.put("success", true);
            result.put("message", "Đã huỷ yêu cầu thành công.");
        } else {
            result.put("success", false);
            result.put("message", "Huỷ yêu cầu thất bại, vui lòng thử lại.");
        }
        return result;
    }

    // ------------------------------------------------------------------ //
    //  LẤY DANH SÁCH CHỜ DUYỆT (cán bộ phường)
    // ------------------------------------------------------------------ //
    public List<Map<String, Object>> layDanhSachChoDuyet() {
        return yeuCauDAO.layDanhSachChoDuyet();
    }

    // ------------------------------------------------------------------ //
    //  LẤY DANH SÁCH THEO TỔ (tổ trưởng)
    // ------------------------------------------------------------------ //
    public List<Map<String, Object>> layDanhSachTheoTo(int toDanPhoID) {
        return yeuCauDAO.layDanhSachTheoTo(toDanPhoID);
    }

    // ------------------------------------------------------------------ //
    //  LẤY TẤT CẢ (cán bộ phường xem lịch sử)
    // ------------------------------------------------------------------ //
    public List<Map<String, Object>> layTatCa() {
        return yeuCauDAO.layTatCa();
    }

    // ------------------------------------------------------------------ //
    //  LẤY CHI TIẾT 1 YÊU CẦU
    // ------------------------------------------------------------------ //
    public Map<String, Object> layChiTiet(int yeuCauID) {
        return yeuCauDAO.layTheoID(yeuCauID);
    }

    // ------------------------------------------------------------------ //
    //  LẤY CHI TIẾT THEO THÔNG BÁO ID
    // ------------------------------------------------------------------ //
    public Map<String, Object> layChiTietTheoThongBao(int thongBaoID) {
        return yeuCauDAO.layChiTietTheoThongBao(thongBaoID);
    }
}