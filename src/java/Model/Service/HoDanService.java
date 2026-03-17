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

    // ── Import tổng hợp ─────────────────────────────────────────────────
    public ImportResult importFromExcel(InputStream inputStream, int toDanPhoID) {
        List<Map<String, Object>> danhSach = new ArrayList<>();
        List<String> parseErrors = new ArrayList<>();
        int totalRows = 0;

        try (Workbook workbook = new XSSFWorkbook(inputStream)) {
            Sheet sheet = workbook.getSheetAt(0);

            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) {
                    continue;
                }
                Cell firstCell = row.getCell(0);
                if (firstCell == null || firstCell.getCellType() == CellType.BLANK) {
                    continue;
                }

                totalRows++;
                Map<String, Object> data = new HashMap<>();
                data.put("rowNum", i + 1);
                data.put("tenHoDan", getCellString(row.getCell(0)));
                data.put("cccd", getCellString(row.getCell(1)));
                data.put("ho", getCellString(row.getCell(2)));
                data.put("ten", getCellString(row.getCell(3)));
                data.put("ngaySinh", getCellSqlDate(row.getCell(4)));
                data.put("gioiTinh", getCellString(row.getCell(5)));
                data.put("soDienThoai", getCellString(row.getCell(6)));
                data.put("email", getCellString(row.getCell(7)));
                data.put("quanHe", getCellString(row.getCell(8)));
                data.put("diaChi", getCellString(row.getCell(9)));
                danhSach.add(data);
            }

            Map<String, List<Map<String, Object>>> grouped = new LinkedHashMap<>();
            for (Map<String, Object> row : danhSach) {
                String key = (String) row.get("tenHoDan");
                grouped.computeIfAbsent(key, k -> new ArrayList<>()).add(row);
            }

            parseErrors.addAll(hoDanDAO.importHoDanVaNguoiDung(
                    flattenGrouped(grouped), toDanPhoID));

        } catch (Exception e) {
            parseErrors.add("Không thể đọc file Excel: " + e.getMessage());
        }

        return new ImportResult(totalRows, totalRows - parseErrors.size(), parseErrors);
    }

    private List<Map<String, Object>> flattenGrouped(
            Map<String, List<Map<String, Object>>> grouped) {
        List<Map<String, Object>> result = new ArrayList<>();
        for (List<Map<String, Object>> group : grouped.values()) {
            result.addAll(group);
        }
        return result;
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
            if (cell.getCellType() == CellType.NUMERIC && DateUtil.isCellDateFormatted(cell)) {
                return new java.sql.Date(cell.getDateCellValue().getTime());
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
