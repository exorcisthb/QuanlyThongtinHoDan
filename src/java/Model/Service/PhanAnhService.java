package Model.Service;

import Model.DAO.PhanAnhDAO;
import Model.Entity.LoaiPhanAnh;

import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.*;

public class PhanAnhService {

    private final PhanAnhDAO phanAnhDAO = new PhanAnhDAO();

    private static final String UPLOAD_DIR    = "uploads/phan-anh/";
    private static final long   MAX_FILE_SIZE = 5 * 1024 * 1024L;
    private static final Set<String> ALLOWED_TYPES = Set.of(
            "image/jpeg", "image/png", "image/webp", "image/gif"
    );

    // ================================================================== //
    //  HỘ DÂN
    // ================================================================== //

    public Map<String, Object> guiPhanAnh(int nguoiGuiID, int toDanPhoID,
                                           int loaiID, int mucDoUuTien,
                                           String tieuDe, String noiDung,
                                           List<Part> parts, String appPath) {
        String err = validateInput(tieuDe, noiDung, loaiID, mucDoUuTien);
        if (err != null) return fail(err);

        List<String> duongDanAnh = new ArrayList<>();
        try {
            duongDanAnh = uploadAnh(parts, appPath);
        } catch (IllegalArgumentException e) {
            return fail(e.getMessage());
        } catch (IOException e) {
            return fail("Lỗi khi upload ảnh: " + e.getMessage());
        }

        int id = phanAnhDAO.guiPhanAnh(nguoiGuiID, toDanPhoID, loaiID,
                mucDoUuTien, tieuDe.trim(), noiDung.trim(), duongDanAnh);
        if (id == -1) return fail("Không thể gửi phản ánh. Vui lòng thử lại.");

        return ok("Gửi phản ánh thành công!", Map.of("phanAnhID", id));
    }

    public Map<String, Object> suaPhanAnh(int phanAnhID, int nguoiGuiID,
                                           int loaiID, int mucDoUuTien,
                                           String tieuDe, String noiDung,
                                           List<Integer> fileIDXoa,
                                           List<Part> partsAnhMoi,
                                           String appPath) {
        String err = validateInput(tieuDe, noiDung, loaiID, mucDoUuTien);
        if (err != null) return fail(err);

        Map<String, Object> hien = phanAnhDAO.getPhanAnhByID(phanAnhID);
        if (hien == null) return fail("Không tìm thấy phản ánh.");
        if ((int) hien.get("nguoiGuiID") != nguoiGuiID)
            return fail("Bạn không có quyền sửa phản ánh này.");

        int ttHienTai = (int) hien.get("trangThaiID");
        if (ttHienTai == 4 || ttHienTai == 5 || ttHienTai == 6 || ttHienTai == 7)
            return fail("Không thể sửa phản ánh ở trạng thái hiện tại.");

        List<String> duongDanAnhMoi = new ArrayList<>();
        try {
            duongDanAnhMoi = uploadAnh(partsAnhMoi, appPath);
        } catch (IllegalArgumentException e) {
            return fail(e.getMessage());
        } catch (IOException e) {
            return fail("Lỗi khi upload ảnh: " + e.getMessage());
        }

        boolean ok = phanAnhDAO.suaPhanAnh(phanAnhID, nguoiGuiID, loaiID,
                mucDoUuTien, tieuDe.trim(), noiDung.trim(),
                duongDanAnhMoi, fileIDXoa);

        return ok ? ok("Cập nhật phản ánh thành công!", null)
                  : fail("Không thể cập nhật phản ánh. Vui lòng thử lại.");
    }

    public Map<String, Object> huyPhanAnh(int phanAnhID, int nguoiGuiID, String lyDo) {
        if (lyDo == null || lyDo.trim().isEmpty())
            return fail("Vui lòng nhập lý do hủy.");

        Map<String, Object> hien = phanAnhDAO.getPhanAnhByID(phanAnhID);
        if (hien == null) return fail("Không tìm thấy phản ánh.");
        if ((int) hien.get("nguoiGuiID") != nguoiGuiID)
            return fail("Bạn không có quyền hủy phản ánh này.");

        int tt = (int) hien.get("trangThaiID");
        if (tt == 3) return fail("Phản ánh đã chuyển cấp, không thể hủy.");
        if (tt == 4 || tt == 5 || tt == 6 || tt == 7)
            return fail("Không thể hủy phản ánh ở trạng thái hiện tại.");

        boolean ok = phanAnhDAO.huyPhanAnh(phanAnhID, nguoiGuiID, lyDo.trim());
        return ok ? ok("Đã hủy phản ánh.", null)
                  : fail("Không thể hủy phản ánh. Vui lòng thử lại.");
    }

    // ================================================================== //
    //  TỔ TRƯỞNG
    // ================================================================== //

    public Map<String, Object> tiepNhan(int phanAnhID, int toTruongID, String ghiChu) {
        Map<String, Object> hien = phanAnhDAO.getPhanAnhByID(phanAnhID);
        if (hien == null) return fail("Không tìm thấy phản ánh.");
        if ((int) hien.get("trangThaiID") != 1)
            return fail("Phản ánh không ở trạng thái chờ tiếp nhận.");

        boolean ok = phanAnhDAO.tiepNhan(phanAnhID, toTruongID,
                ghiChu != null ? ghiChu.trim() : "");
        return ok ? ok("Đã tiếp nhận phản ánh.", null)
                  : fail("Không thể tiếp nhận. Vui lòng thử lại.");
    }

    public Map<String, Object> giaiQuyetToTruong(int phanAnhID, int toTruongID, String ketQua) {
        if (ketQua == null || ketQua.trim().isEmpty())
            return fail("Vui lòng nhập kết quả giải quyết.");

        Map<String, Object> hien = phanAnhDAO.getPhanAnhByID(phanAnhID);
        if (hien == null) return fail("Không tìm thấy phản ánh.");
        if ((int) hien.get("trangThaiID") != 2)
            return fail("Chỉ có thể giải quyết khi phản ánh đang ở trạng thái Đang xử lý.");

        boolean ok = phanAnhDAO.giaiQuyetToTruong(phanAnhID, toTruongID, ketQua.trim());
        return ok ? ok("Đã giải quyết phản ánh và thông báo đến người dân.", null)
                  : fail("Không thể giải quyết. Vui lòng thử lại.");
    }

    public Map<String, Object> tuChoi(int phanAnhID, int toTruongID, String lyDo) {
        if (lyDo == null || lyDo.trim().isEmpty())
            return fail("Vui lòng nhập lý do từ chối.");

        Map<String, Object> hien = phanAnhDAO.getPhanAnhByID(phanAnhID);
        if (hien == null) return fail("Không tìm thấy phản ánh.");
        int tt = (int) hien.get("trangThaiID");
        if (tt != 1 && tt != 2)
            return fail("Phản ánh không ở trạng thái có thể từ chối.");

        boolean ok = phanAnhDAO.tuChoi(phanAnhID, toTruongID, lyDo.trim());
        return ok ? ok("Đã từ chối phản ánh và thông báo đến người dân.", null)
                  : fail("Không thể từ chối. Vui lòng thử lại.");
    }

    public Map<String, Object> danhDauSpam(int phanAnhID, int toTruongID, String ghiChu) {
        if (ghiChu == null || ghiChu.trim().isEmpty())
            return fail("Vui lòng nhập lý do đánh dấu spam.");

        Map<String, Object> hien = phanAnhDAO.getPhanAnhByID(phanAnhID);
        if (hien == null) return fail("Không tìm thấy phản ánh.");
        int tt = (int) hien.get("trangThaiID");
        if (tt != 1 && tt != 2)
            return fail("Phản ánh không ở trạng thái có thể đánh dấu spam.");

        boolean ok = phanAnhDAO.danhDauSpam(phanAnhID, toTruongID, ghiChu.trim());
        return ok ? ok("Đã đánh dấu spam và thông báo đến người dân.", null)
                  : fail("Không thể đánh dấu spam. Vui lòng thử lại.");
    }

    public Map<String, Object> chuyenCapCanBo(int phanAnhID, int toTruongID, String ghiChu) {
        if (ghiChu == null || ghiChu.trim().isEmpty())
            return fail("Vui lòng nhập lý do chuyển cấp.");

        Map<String, Object> hien = phanAnhDAO.getPhanAnhByID(phanAnhID);
        if (hien == null) return fail("Không tìm thấy phản ánh.");
        if ((int) hien.get("trangThaiID") != 1)
            return fail("Chỉ có thể chuyển cấp khi phản ánh chưa được tiếp nhận.");

        boolean ok = phanAnhDAO.chuyenCapCanBo(phanAnhID, toTruongID, ghiChu.trim());
        return ok ? ok("Đã chuyển lên cán bộ phường và thông báo đến người dân.", null)
                  : fail("Không thể chuyển cấp. Vui lòng thử lại.");
    }

    public Map<String, Object> guiPhanHoi(int phanAnhID, int toTruongID, String noiDung) {
        if (noiDung == null || noiDung.trim().isEmpty())
            return fail("Vui lòng nhập nội dung phản hồi.");

        Map<String, Object> hien = phanAnhDAO.getPhanAnhByID(phanAnhID);
        if (hien == null) return fail("Không tìm thấy phản ánh.");
        int tt = (int) hien.get("trangThaiID");
        if (tt == 3) return fail("Phản ánh đã chuyển cấp, không thể gửi phản hồi trực tiếp.");
        if (tt == 4 || tt == 5 || tt == 6 || tt == 7)
            return fail("Phản ánh đã kết thúc, không thể gửi phản hồi.");

        int nguoiNhanID = (int) hien.get("nguoiGuiID");
        String tieuDe   = "[Phản hồi] " + hien.get("tieuDe");

        boolean ok = phanAnhDAO.guiPhanHoiToTruong(
                phanAnhID, toTruongID, nguoiNhanID, tieuDe, noiDung.trim());
        return ok ? ok("Đã gửi phản hồi đến người dân.", null)
                  : fail("Không thể gửi phản hồi. Vui lòng thử lại.");
    }

    // ================================================================== //
    //  CÁN BỘ PHƯỜNG
    // ================================================================== //

    public Map<String, Object> giaiquyetPhanAnh(int phanAnhID, int canBoID, String ketQua) {
        if (ketQua == null || ketQua.trim().isEmpty())
            return fail("Vui lòng nhập kết quả xử lý.");

        Map<String, Object> hien = phanAnhDAO.getPhanAnhByID(phanAnhID);
        if (hien == null) return fail("Không tìm thấy phản ánh.");
        if ((int) hien.get("trangThaiID") != 3)
            return fail("Phản ánh không ở trạng thái chuyển cấp.");

        boolean ok = phanAnhDAO.giaiquyetPhanAnh(phanAnhID, canBoID, ketQua.trim());
        return ok ? ok("Đã giải quyết phản ánh và thông báo cho hộ dân.", null)
                  : fail("Không thể giải quyết. Vui lòng thử lại.");
    }

    // ================================================================== //
    //  QUERY
    // ================================================================== //

    public Map<String, Object> getChiTiet(int phanAnhID) {
        Map<String, Object> pa = phanAnhDAO.getPhanAnhByID(phanAnhID);
        if (pa == null) return null;
        pa.put("danhSachAnh", phanAnhDAO.getAnhDinhKem(phanAnhID));
        pa.put("lichSuXuLy",  phanAnhDAO.getLichSuXuLy(phanAnhID));
        return pa;
    }

    public List<Map<String, Object>> getDanhSachCuaHoDan(int nguoiGuiID) {
        return phanAnhDAO.getPhanAnhCuaHoDan(nguoiGuiID);
    }

    public List<Map<String, Object>> getDanhSachTheoTo(int toDanPhoID) {
        return phanAnhDAO.getPhanAnhTheoTo(toDanPhoID);
    }

    public List<Map<String, Object>> getDanhSachDaChuyenCap() {
        return phanAnhDAO.getPhanAnhDaChuyenCap();
    }

    public List<LoaiPhanAnh> getDanhSachLoai() {
        return phanAnhDAO.getDanhSachLoai();
    }

    // ================================================================== //
    //  THỐNG KÊ
    // ================================================================== //

    public Map<String, Integer> getTongHopPhanAnh(int toDanPhoID, int nam) {
        return phanAnhDAO.thongKe_TongHopPhanAnh(toDanPhoID, nam);
    }

    public Map<String, Integer> getPhanAnhTheoThang(int toDanPhoID, int nam) {
        return phanAnhDAO.thongKe_PhanAnhTheoThang(toDanPhoID, nam);
    }

    public Map<String, Integer> getPhanAnhTheoTrangThai(int toDanPhoID, int nam) {
        return phanAnhDAO.thongKe_PhanAnhTheoTrangThai(toDanPhoID, nam);
    }

    public Map<String, Integer> getPhanAnhTheoLoai(int toDanPhoID, int nam) {
        return phanAnhDAO.thongKe_PhanAnhTheoLoai(toDanPhoID, nam);
    }

    // ================================================================== //
    //  UPLOAD ẢNH
    // ================================================================== //

    public List<String> uploadAnh(List<Part> parts, String appPath) throws IOException {
        List<String> result = new ArrayList<>();
        if (parts == null || parts.isEmpty()) return result;

        String uploadPath = appPath + File.separator + UPLOAD_DIR.replace("/", File.separator);
        Files.createDirectories(Paths.get(uploadPath));

        for (Part part : parts) {
            if (part == null || part.getSize() == 0) continue;

            String contentType = part.getContentType();
            if (contentType == null || !ALLOWED_TYPES.contains(contentType.toLowerCase()))
                throw new IllegalArgumentException(
                        "Định dạng ảnh không hợp lệ. Chỉ chấp nhận JPG, PNG, WEBP, GIF.");

            if (part.getSize() > MAX_FILE_SIZE)
                throw new IllegalArgumentException("Ảnh không được vượt quá 5MB.");

            String ext      = contentType.substring(contentType.lastIndexOf('/') + 1);
            String fileName = UUID.randomUUID().toString() + "." + ext;
            String fullPath = uploadPath + File.separator + fileName;

            try (InputStream is = part.getInputStream()) {
                Files.copy(is, Paths.get(fullPath), StandardCopyOption.REPLACE_EXISTING);
            }

            result.add(UPLOAD_DIR + fileName);
        }
        return result;
    }

    // ================================================================== //
    //  PRIVATE HELPERS
    // ================================================================== //

    private String validateInput(String tieuDe, String noiDung,
                                  int loaiID, int mucDoUuTien) {
        if (tieuDe == null || tieuDe.trim().isEmpty())
            return "Tiêu đề không được để trống.";
        if (tieuDe.trim().length() > 255)
            return "Tiêu đề không được vượt quá 255 ký tự.";
        if (noiDung == null || noiDung.trim().isEmpty())
            return "Nội dung không được để trống.";
        if (loaiID <= 0)
            return "Vui lòng chọn loại phản ánh.";
        if (mucDoUuTien < 1 || mucDoUuTien > 3)
            return "Mức độ ưu tiên không hợp lệ.";
        return null;
    }

    private Map<String, Object> ok(String message, Map<String, Object> extra) {
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", message);
        if (extra != null) res.putAll(extra);
        return res;
    }

    private Map<String, Object> fail(String message) {
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", false);
        res.put("message", message);
        return res;
    }
}