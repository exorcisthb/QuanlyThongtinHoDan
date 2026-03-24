package Model.Entity;

/**
 *
 * @author exorc
 */
public class TrangThaiHoKhau {
    private int trangThaiID;
    private String tenTrangThai;

    public TrangThaiHoKhau() {
    }

    public TrangThaiHoKhau(int trangThaiID, String tenTrangThai) {
        this.trangThaiID = trangThaiID;
        this.tenTrangThai = tenTrangThai;
    }

    public int getTrangThaiID() {
        return trangThaiID;
    }

    public void setTrangThaiID(int trangThaiID) {
        this.trangThaiID = trangThaiID;
    }

    public String getTenTrangThai() {
        return tenTrangThai;
    }

    public void setTenTrangThai(String tenTrangThai) {
        this.tenTrangThai = tenTrangThai;
    }

    @Override
    public String toString() {
        return "TrangThaiHoKhau{" + "trangThaiID=" + trangThaiID + ", tenTrangThai=" + tenTrangThai + '}';
    }
}