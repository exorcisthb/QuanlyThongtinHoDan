package Model.Service;

import Model.DAO.HoDanDAO;
import Model.Entity.HoDan;
import Model.Entity.ImportResult;
import Model.Entity.NguoiDung;
import Util.QRCodeUtil;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.*;

public class HoDanService {

    private final HoDanDAO hoDanDAO = new HoDanDAO();

    // ── Tổ trưởng: nhóm hộ dân theo đường, chỉ trong tổ mình ──────────
    public Map<String, List<HoDan>> getDanhSachNhomTheoDuong(int toDanPhoID, String keyword) {
        List<HoDan> all = hoDanDAO.getDanhSachHoDan(toDanPhoID, keyword);
        Map<String, List<HoDan>> result = new LinkedHashMap<>();
        for (HoDan h : all) {
            result.computeIfAbsent(h.getTenDuong(), k -> new ArrayList<>()).add(h);
        }
        return result;
    }

    // ── Tổ trưởng: lấy danh sách phẳng theo toDanPhoID từ session ──────
    public List<HoDan> getDanhSachTheoToTruong(NguoiDung toTruong, String keyword) {
        if (toTruong == null || toTruong.getToDanPhoID() == null) {
            return Collections.emptyList();
        }
        return hoDanDAO.getDanhSachHoDan(toTruong.getToDanPhoID(), keyword);
    }

    // ── Cán bộ phường: lấy tất cả hộ dân toàn phường ───────────────────
    public List<HoDan> getDanhSachTatCa(String keyword) {
        return hoDanDAO.getDanhSachTatCaHoDan(keyword);
    }

    // ── Cán bộ phường: nhóm theo tổ dân phố rồi nhóm theo đường ────────
    public Map<String, Map<String, List<HoDan>>> getDanhSachNhomTheoTo(String keyword) {
        List<HoDan> all = hoDanDAO.getDanhSachTatCaHoDan(keyword);
        Map<String, Map<String, List<HoDan>>> result = new LinkedHashMap<>();
        for (HoDan h : all) {
            String tenTo = h.getTenTo() != null ? h.getTenTo() : "Chưa phân tổ";
            String tenDuong = h.getTenDuong() != null ? h.getTenDuong() : "Không rõ";
            result.computeIfAbsent(tenTo, k -> new LinkedHashMap<>())
                    .computeIfAbsent(tenDuong, k -> new ArrayList<>())
                    .add(h);
        }
        return result;
    }

    public int tongSoHo(Map<String, List<HoDan>> map) {
        return map.values().stream().mapToInt(List::size).sum();
    }
public ImportResult importFromExcel(InputStream inputStream, int toDanPhoID) {
    List<Map<String, Object>> danhSach = new ArrayList<>();
    List<String> parseErrors = new ArrayList<>();
    int totalRows = 0;

    try (Workbook workbook = new XSSFWorkbook(inputStream)) {
        Sheet sheet = workbook.getSheetAt(0);

        for (int i = 0; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null) continue;
            Cell firstCell = row.getCell(0);
            if (firstCell == null || firstCell.getCellType() == CellType.BLANK) continue;

            String tenHoDan = getCellString(row.getCell(0));
            if (tenHoDan == null || tenHoDan.trim().isEmpty()
                    || tenHoDan.startsWith("★")
                    || tenHoDan.contains("(VD:")) continue;

            totalRows++;

            String cccd        = getCellString(row.getCell(1));
            String ho          = getCellString(row.getCell(2));
            String ten         = getCellString(row.getCell(3));
            java.sql.Date ngaySinh = getCellSqlDate(row.getCell(4));
            String gioiTinh    = getCellString(row.getCell(5));
            String soDienThoai = getCellString(row.getCell(6));
            String email       = getCellString(row.getCell(7));
            String quanHe      = getCellString(row.getCell(8));
            String diaChi      = getCellString(row.getCell(9));

            // ✅ VALIDATE CƠ BẢN
            List<String> rowErrors = new ArrayList<>();

            if (cccd == null || cccd.trim().isEmpty()) {
                rowErrors.add("Dòng " + (i + 1) + ": CCCD không được trống");
            } else if (!cccd.trim().matches("\\d{12}")) {
                rowErrors.add("Dòng " + (i + 1) + ": CCCD không hợp lệ (phải đủ 12 chữ số)");
            }

            if (ho == null || ho.trim().isEmpty())
                rowErrors.add("Dòng " + (i + 1) + ": Họ không được trống");

            if (ten == null || ten.trim().isEmpty())
                rowErrors.add("Dòng " + (i + 1) + ": Tên không được trống");

            if (ngaySinh == null)
                rowErrors.add("Dòng " + (i + 1) + ": Ngày sinh không được trống hoặc sai định dạng (dd/MM/yyyy)");

            if (gioiTinh == null || gioiTinh.trim().isEmpty()) {
                rowErrors.add("Dòng " + (i + 1) + ": Giới tính không được trống");
            } else if (!gioiTinh.trim().matches("Nam|Nữ|Khác")) {
                rowErrors.add("Dòng " + (i + 1) + ": Giới tính phải là Nam / Nữ / Khác");
            }

            if (quanHe == null || quanHe.trim().isEmpty())
                rowErrors.add("Dòng " + (i + 1) + ": Quan hệ hộ gia đình không được trống");

            if (!rowErrors.isEmpty()) {
                parseErrors.addAll(rowErrors);
                continue;
            }

            // ✅ CHECK TRÙNG VỚI DB
            if (cccd != null && !cccd.trim().isEmpty() && cccd.trim().matches("\\d{12}")) {
                if (hoDanDAO.isCCCDExists(cccd.trim()))
                    rowErrors.add("Dòng " + (i + 1) + ": CCCD '" + cccd.trim() + "' đã tồn tại trong hệ thống");
            }
            if (soDienThoai != null && !soDienThoai.trim().isEmpty()) {
                if (hoDanDAO.isSDTExists(soDienThoai.trim()))
                    rowErrors.add("Dòng " + (i + 1) + ": Số điện thoại '" + soDienThoai.trim() + "' đã tồn tại trong hệ thống");
            }

            if (!rowErrors.isEmpty()) {
                parseErrors.addAll(rowErrors);
                continue;
            }

            Map<String, Object> data = new HashMap<>();
            data.put("rowNum", i + 1);
            data.put("tenHoDan", tenHoDan.trim().toUpperCase());
            data.put("cccd", cccd.trim());
            data.put("ho", ho);
            data.put("ten", ten);
            data.put("ngaySinh", ngaySinh);
            data.put("gioiTinh", gioiTinh);
            data.put("soDienThoai", soDienThoai);
            data.put("email", email);
            data.put("quanHe", quanHe);
            data.put("diaChi", diaChi != null ? diaChi.trim() : "");
            danhSach.add(data);
        }

        // ════════════════════════════════════════════════════════
        // ✅ CHECK TRÙNG NỘI BỘ FILE EXCEL
        // ════════════════════════════════════════════════════════

        // 1️⃣ Trùng CCCD trong file
        Map<String, Integer> cccdSeenAt = new LinkedHashMap<>();
        for (Map<String, Object> row : danhSach) {
            String cccd = (String) row.get("cccd");
            if (cccd == null || cccd.trim().isEmpty()) continue;
            int rowNum = (int) row.get("rowNum");
            if (cccdSeenAt.containsKey(cccd.trim())) {
                parseErrors.add("Dòng " + rowNum + ": CCCD '" + cccd.trim()
                        + "' bị trùng với dòng " + cccdSeenAt.get(cccd.trim()) + " trong file Excel");
            } else {
                cccdSeenAt.put(cccd.trim(), rowNum);
            }
        }

        // 2️⃣ Trùng SĐT trong file
        Map<String, Integer> sdtSeenAt = new LinkedHashMap<>();
        for (Map<String, Object> row : danhSach) {
            String sdt = (String) row.get("soDienThoai");
            if (sdt == null || sdt.trim().isEmpty()) continue;
            int rowNum = (int) row.get("rowNum");
            if (sdtSeenAt.containsKey(sdt.trim())) {
                parseErrors.add("Dòng " + rowNum + ": Số điện thoại '" + sdt.trim()
                        + "' bị trùng với dòng " + sdtSeenAt.get(sdt.trim()) + " trong file Excel");
            } else {
                sdtSeenAt.put(sdt.trim(), rowNum);
            }
        }

        // 3️⃣ Mỗi số nhà (cùng địa chỉ) chỉ được có 1 Chủ hộ
        // ✅ FIX: key = tenHoDan + "|" + diaChi (phân biệt Số nhà 12 Hòa Bình vs Số nhà 12 Vị Hoàng)
        Map<String, Integer> chuHoSeenAt = new LinkedHashMap<>();
        for (Map<String, Object> row : danhSach) {
            String tenHoDan = (String) row.get("tenHoDan");
            String quanHe   = (String) row.get("quanHe");
            String diaChi   = (String) row.get("diaChi");
            int rowNum      = (int)    row.get("rowNum");
            if (quanHe == null) continue;
            boolean laChuHo = quanHe.trim().equalsIgnoreCase("Chủ hộ")
                           || quanHe.trim().equalsIgnoreCase("Chu ho");
            if (!laChuHo) continue;
            // ✅ FIX: key kết hợp cả tenHoDan + diaChi
            String key = tenHoDan.trim().toUpperCase() + "|" + (diaChi != null ? diaChi.trim().toUpperCase() : "");
            if (chuHoSeenAt.containsKey(key)) {
                parseErrors.add("Dòng " + rowNum + ": Số nhà '" + tenHoDan
                        + "' (địa chỉ: " + diaChi + ") đã có Chủ hộ ở dòng " + chuHoSeenAt.get(key)
                        + " — mỗi hộ chỉ được có 1 Chủ hộ");
            } else {
                chuHoSeenAt.put(key, rowNum);
            }
        }

        // ════════════════════════════════════════════════════════
        // ✅ NẾU CÓ BẤT KỲ LỖI NÀO → KHÔNG INSERT GÌ CẢ
        if (!parseErrors.isEmpty()) {
            return new ImportResult(totalRows, 0, parseErrors);
        }

        // ════════════════════════════════════════════════════════
        // ✅ GROUP ĐÚNG: key = tenHoDan + "|" + diaChi (KHÁC TỔ/NGÁCH/NGÕ = HỘ KHÁC NHAU)
        // ════════════════════════════════════════════════════════
        Map<String, List<Map<String, Object>>> grouped = new LinkedHashMap<>();
        for (Map<String, Object> row : danhSach) {
            String tenHoDan = ((String) row.get("tenHoDan")).trim().toUpperCase();
            String diaChi   = ((String) row.get("diaChi")).trim().toUpperCase();
            // ✅ FIX CHÍNH: Số nhà 12 Hòa Bình ≠ Số nhà 12 Vị Hoàng
            String key = tenHoDan + "|" + diaChi;
            grouped.computeIfAbsent(key, k -> new ArrayList<>()).add(row);
        }

        // ✅ Với mỗi group, kiểm tra xem DB đã có hộ trùng tenHoDan+diaChi chưa
        // Nếu có → kiểm tra quanHe:
        //   - Là thành viên (em/con/cháu) → thêm vào hộ đã có
        //   - Là Chủ hộ → báo lỗi (hộ đó đã có chủ hộ rồi)
        // Nếu chưa có → tạo hộ mới
        List<String> insertErrors = hoDanDAO.importHoDanVaNguoiDung(
                flattenGrouped(grouped), toDanPhoID);

        int success = danhSach.size() - insertErrors.size();
        return new ImportResult(totalRows, success, insertErrors);

    } catch (Exception e) {
        parseErrors.add("Không thể đọc file Excel: " + e.getMessage());
        return new ImportResult(totalRows, 0, parseErrors);
    }
}

    // ════════════════════════════════════════════════════════════════════
    // ── QR CODE METHODS ─────────────────────────────────────────────────
    // ════════════════════════════════════════════════════════════════════
    // Lấy hộ dân mà user đang login thuộc về
    public HoDan getHoDanCuaUser(int nguoiDungID) {
        try {
            return hoDanDAO.getHoDanByNguoiDungID(nguoiDungID);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private List<Map<String, Object>> flattenGrouped(
            Map<String, List<Map<String, Object>>> grouped) {
        List<Map<String, Object>> result = new ArrayList<>();
        for (List<Map<String, Object>> group : grouped.values()) {
            result.addAll(group);
        }
        return result;
    }

    // Tạo ảnh QR base64 cho hộ dân — gọi từ HoDanQRServlet
    public String taoQRBase64(int hoDanID, String baseUrl) {
        try {
            String token = hoDanDAO.getOrCreateQRToken(hoDanID);
            String qrContent = baseUrl + "/scan?token=" + token;
            return QRCodeUtil.generateQRBase64(qrContent);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Lấy token QR (dùng khi cần hiển thị URL hoặc debug)
    public String getQRToken(int hoDanID) {
        try {
            return hoDanDAO.getOrCreateQRToken(hoDanID);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Reset QR token — tạo mã mới, vô hiệu mã cũ
    public String resetQRToken(int hoDanID) {
        try {
            return hoDanDAO.resetQRToken(hoDanID);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Tổ trưởng quét QR → lấy thông tin hộ theo token
    public HoDan getHoDanByToken(String token) {
        try {
            return hoDanDAO.getHoDanByToken(token);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Lấy danh sách nhân khẩu trong hộ (dùng cho trang scan result)
    public List<NguoiDung> getThanhVienByHoDanID(int hoDanID) {
        try {
            return hoDanDAO.getThanhVienByHoDanID(hoDanID);
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    // ── Helpers ─────────────────────────────────────────────────────────
    private String getCellString(Cell cell) {
        if (cell == null) {
            return "";
        }
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue().trim();
            case NUMERIC:
                return String.valueOf((long) cell.getNumericCellValue());
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            default:
                return "";
        }
    }

    private java.sql.Date getCellSqlDate(Cell cell) {
        if (cell == null) {
            return null;
        }
        try {
            if (cell.getCellType() == CellType.NUMERIC) {
                if (DateUtil.isCellDateFormatted(cell)) {
                    return new java.sql.Date(cell.getDateCellValue().getTime());
                } else {
                    double serial = cell.getNumericCellValue();
                    if (serial > 1000) {
                        return new java.sql.Date(
                                DateUtil.getJavaDate(serial).getTime());
                    }
                }
            }
            if (cell.getCellType() == CellType.STRING) {
                String val = cell.getStringCellValue().trim();
                for (String fmt : new String[]{"dd/MM/yyyy", "yyyy-MM-dd", "dd-MM-yyyy"}) {
                    try {
                        return new java.sql.Date(
                                new SimpleDateFormat(fmt).parse(val).getTime());
                    } catch (Exception ignored) {
                    }
                }
            }
        } catch (Exception ignored) {
        }
        return null;
    }
    // ── Tổ trưởng: nhóm hộ dân theo đường, có đầy đủ filter ──────────────

    public Map<String, List<HoDan>> getDanhSachNhomTheoDuong(
            int toDanPhoID, String keyword,
            Integer tuoiMin, Integer tuoiMax, String vung,
            Boolean coChuHo, Boolean daKichHoat, Integer trangThaiID) {

        List<HoDan> all = hoDanDAO.getDanhSachHoDan(
                toDanPhoID, keyword, tuoiMin, tuoiMax, vung, coChuHo, daKichHoat, trangThaiID);

        Map<String, List<HoDan>> result = new LinkedHashMap<>();
        for (HoDan h : all) {
            result.computeIfAbsent(h.getTenDuong(), k -> new ArrayList<>()).add(h);
        }
        return result;
    }
    // ── Lọc cá nhân, nhóm theo đường ────────────────────────────────────

    public Map<String, List<Map<String, Object>>> getDanhSachCaNhanNhomTheoDuong(
            int toDanPhoID, String keyword,
            Integer tuoiMin, Integer tuoiMax, String vung,
            Boolean coChuHo, Boolean daKichHoat, Integer trangThaiID) {

        List<Map<String, Object>> all = hoDanDAO.getDanhSachCaNhanTheoFilter(
                toDanPhoID, keyword, tuoiMin, tuoiMax,
                vung, coChuHo, daKichHoat, trangThaiID);

        Map<String, List<Map<String, Object>>> result = new LinkedHashMap<>();
        for (Map<String, Object> row : all) {
            String tenDuong = (String) row.get("tenDuong");
            result.computeIfAbsent(tenDuong, k -> new ArrayList<>()).add(row);
        }
        return result;
    }

    public int tongSoCaNhan(Map<String, List<Map<String, Object>>> map) {
        return map.values().stream().mapToInt(List::size).sum();
    }
    // ── Cán bộ phường: nhóm hộ dân theo Tổ → Đường, có filter ──────────

    public Map<String, Map<String, List<HoDan>>> getDanhSachNhomTheoToCoFilter(
            String keyword,
            Integer tuoiMin, Integer tuoiMax,
            Boolean daKichHoat, Integer trangThaiID) {

        List<HoDan> all = hoDanDAO.getDanhSachTatCaHoDanCoFilter(
                keyword, tuoiMin, tuoiMax, daKichHoat, trangThaiID);

        Map<String, Map<String, List<HoDan>>> result = new LinkedHashMap<>();
        for (HoDan h : all) {
            String tenTo = h.getTenTo() != null ? h.getTenTo() : "Chưa phân tổ";
            String tenDuong = h.getTenDuong() != null ? h.getTenDuong() : "Không rõ";
            result.computeIfAbsent(tenTo, k -> new LinkedHashMap<>())
                    .computeIfAbsent(tenDuong, k -> new ArrayList<>())
                    .add(h);
        }
        return result;
    }

    // ── Cán bộ phường: chế độ cá nhân — nhóm Tổ → Đường → từng người ──
    public Map<String, Map<String, List<Map<String, Object>>>> getDanhSachCaNhanCBP(
            String keyword,
            Integer tuoiMin, Integer tuoiMax,
            Boolean daKichHoat, Integer trangThaiID) {

        List<Map<String, Object>> all = hoDanDAO.getDanhSachCaNhanTheoFilterCBP(
                keyword, tuoiMin, tuoiMax, daKichHoat, trangThaiID);

        Map<String, Map<String, List<Map<String, Object>>>> result = new LinkedHashMap<>();
        for (Map<String, Object> row : all) {
            String tenTo = row.get("tenTo") != null ? (String) row.get("tenTo") : "Chưa phân tổ";
            String tenDuong = row.get("tenDuong") != null ? (String) row.get("tenDuong") : "Không rõ";
            result.computeIfAbsent(tenTo, k -> new LinkedHashMap<>())
                    .computeIfAbsent(tenDuong, k -> new ArrayList<>())
                    .add(row);
        }
        return result;
    }

    public int tongSoCaNhanCBP(Map<String, Map<String, List<Map<String, Object>>>> map) {
        return map.values().stream()
                .flatMap(m -> m.values().stream())
                .mapToInt(List::size)
                .sum();
    }

    public List<Map<String, Object>> getDanhSachQuanHe() {
        try {
            return hoDanDAO.getDanhSachQuanHe();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public boolean capNhatQuanHe(int hoDanID, int nguoiDungID, int quanHeID) {
        try {
            hoDanDAO.capNhatQuanHe(hoDanID, nguoiDungID, quanHeID);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
