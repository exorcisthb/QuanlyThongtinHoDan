package Model.Entity;

import java.sql.Date;

/**
 *
 * @author exorc
 */
public class LichSuDangNhap {
    private int id;
    private int nguoiDungID;
    private Date thoiGian;
    private String diaChiIP;
    private boolean thanhCong;

    public LichSuDangNhap() {
    }

    public LichSuDangNhap(int id, int nguoiDungID, Date thoiGian, String diaChiIP, boolean thanhCong) {
        this.id = id;
        this.nguoiDungID = nguoiDungID;
        this.thoiGian = thoiGian;
        this.diaChiIP = diaChiIP;
        this.thanhCong = thanhCong;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getNguoiDungID() { return nguoiDungID; }
    public void setNguoiDungID(int nguoiDungID) { this.nguoiDungID = nguoiDungID; }

    public Date getThoiGian() { return thoiGian; }
    public void setThoiGian(Date thoiGian) { this.thoiGian = thoiGian; }

    public String getDiaChiIP() { return diaChiIP; }
    public void setDiaChiIP(String diaChiIP) { this.diaChiIP = diaChiIP; }

    public boolean isThanhCong() { return thanhCong; }
    public void setThanhCong(boolean thanhCong) { this.thanhCong = thanhCong; }

    @Override
    public String toString() {
        return "LichSuDangNhap{" +
                "id=" + id +
                ", nguoiDungID=" + nguoiDungID +
                ", thoiGian=" + thoiGian +
                ", diaChiIP='" + diaChiIP + '\'' +
                ", thanhCong=" + thanhCong +
                '}';
    }
}