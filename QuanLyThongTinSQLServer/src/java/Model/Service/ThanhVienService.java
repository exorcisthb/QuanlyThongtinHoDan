package Model.Service;

import Model.DAO.ThanhVienDAO;
import java.util.List;
import java.util.Map;

public class ThanhVienService {

    private final ThanhVienDAO thanhVienDAO = new ThanhVienDAO();

    public List<Map<String, Object>> getThanhVienByHoDanID(int hoDanID) {
        return thanhVienDAO.getThanhVienByHoDanID(hoDanID);
    }
}