package Model.Service;

import Model.DAO.HoDanDAO;
import Model.Entity.HoDan;
import java.util.*;

public class HoDanService {

    private final HoDanDAO hoDanDAO = new HoDanDAO();

    // Trả về Map: tên đường → danh sách hộ
    public Map<String, List<HoDan>> getDanhSachNhomTheoDuong(int toDanPhoID, String keyword) {
        List<HoDan> all = hoDanDAO.getDanhSachHoDan(toDanPhoID, keyword);

        // Dùng LinkedHashMap để giữ thứ tự alphabet
        Map<String, List<HoDan>> result = new LinkedHashMap<>();
        for (HoDan h : all) {
            String duong = h.getTenDuong();
            result.computeIfAbsent(duong, k -> new ArrayList<>()).add(h);
        }
        return result;
    }

    public int tongSoHo(Map<String, List<HoDan>> map) {
        return map.values().stream().mapToInt(List::size).sum();
    }
}