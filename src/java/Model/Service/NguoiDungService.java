package Model.Service;

import Model.DAO.NguoiDungDAO;

public class NguoiDungService {

    private final NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();

    public boolean changePassword(int nguoiDungID, String currentPw, String newPw, String confirmPw) {
        // 1. Xác nhận mật khẩu mới khớp nhau
        if (newPw == null || !newPw.equals(confirmPw)) {
            return false;
        }

        // 2. Kiểm tra mật khẩu hiện tại đúng không
        if (!nguoiDungDAO.checkCurrentPassword(nguoiDungID, currentPw)) {
            return false;
        }

        // 3. Mật khẩu mới không được giống mật khẩu cũ  ← thêm dòng này
        if (nguoiDungDAO.checkCurrentPassword(nguoiDungID, newPw)) {
            return false;
        }

        // 4. Cập nhật
        return nguoiDungDAO.updatePassword(nguoiDungID, newPw);
    }
}
