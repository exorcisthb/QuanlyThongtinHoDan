package Model.Entity;

/**
 *
 * @author exorc
 */
public class QuanHeHoGia {
    private int quanHeID;
    private String tenQuanHe;

    public QuanHeHoGia() {
    }

    public QuanHeHoGia(int quanHeID, String tenQuanHe) {
        this.quanHeID = quanHeID;
        this.tenQuanHe = tenQuanHe;
    }

    public int getQuanHeID() {
        return quanHeID;
    }

    public void setQuanHeID(int quanHeID) {
        this.quanHeID = quanHeID;
    }

    public String getTenQuanHe() {
        return tenQuanHe;
    }

    public void setTenQuanHe(String tenQuanHe) {
        this.tenQuanHe = tenQuanHe;
    }

    @Override
    public String toString() {
        return "QuanHeHoGia{" + "quanHeID=" + quanHeID + ", tenQuanHe=" + tenQuanHe + '}';
    }
}