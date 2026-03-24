package Model.Entity;

/**
 *
 * @author exorc
 */
public class ToDanPho {
    private int toDanPhoID;
    private String tenTo;
    private String phuongXa;
    private String quanHuyen;
    private String tinhTP;

    public ToDanPho() {
    }

    public ToDanPho(int toDanPhoID, String tenTo, String phuongXa, String quanHuyen, String tinhTP) {
        this.toDanPhoID = toDanPhoID;
        this.tenTo = tenTo;
        this.phuongXa = phuongXa;
        this.quanHuyen = quanHuyen;
        this.tinhTP = tinhTP;
    }

    public int getToDanPhoID() {
        return toDanPhoID;
    }

    public void setToDanPhoID(int toDanPhoID) {
        this.toDanPhoID = toDanPhoID;
    }

    public String getTenTo() {
        return tenTo;
    }

    public void setTenTo(String tenTo) {
        this.tenTo = tenTo;
    }

    public String getPhuongXa() {
        return phuongXa;
    }

    public void setPhuongXa(String phuongXa) {
        this.phuongXa = phuongXa;
    }

    public String getQuanHuyen() {
        return quanHuyen;
    }

    public void setQuanHuyen(String quanHuyen) {
        this.quanHuyen = quanHuyen;
    }

    public String getTinhTP() {
        return tinhTP;
    }

    public void setTinhTP(String tinhTP) {
        this.tinhTP = tinhTP;
    }

    @Override
    public String toString() {
        return "ToDanPho{" + "toDanPhoID=" + toDanPhoID + ", tenTo=" + tenTo + ", phuongXa=" + phuongXa + ", quanHuyen=" + quanHuyen + ", tinhTP=" + tinhTP + '}';
    }
}