package Model.Entity;

import java.sql.Date;

/**
 *
 * @author exorc
 */
public class ThanhVienHo {
    private int thanhVienID;
    private int hoDanID;
    private int nguoiDungID;
    private Integer quanHeID;
    private Date ngayVao;
    private Date ngayRa;

    public ThanhVienHo() {
    }

    public ThanhVienHo(int thanhVienID, int hoDanID, int nguoiDungID, Integer quanHeID, 
                       Date ngayVao, Date ngayRa) {
        this.thanhVienID = thanhVienID;
        this.hoDanID = hoDanID;
        this.nguoiDungID = nguoiDungID;
        this.quanHeID = quanHeID;
        this.ngayVao = ngayVao;
        this.ngayRa = ngayRa;
    }

    public int getThanhVienID() { return thanhVienID; }
    public void setThanhVienID(int thanhVienID) { this.thanhVienID = thanhVienID; }

    public int getHoDanID() { return hoDanID; }
    public void setHoDanID(int hoDanID) { this.hoDanID = hoDanID; }

    public int getNguoiDungID() { return nguoiDungID; }
    public void setNguoiDungID(int nguoiDungID) { this.nguoiDungID = nguoiDungID; }

    public Integer getQuanHeID() { return quanHeID; }
    public void setQuanHeID(Integer quanHeID) { this.quanHeID = quanHeID; }

    public Date getNgayVao() { return ngayVao; }
    public void setNgayVao(Date ngayVao) { this.ngayVao = ngayVao; }

    public Date getNgayRa() { return ngayRa; }
    public void setNgayRa(Date ngayRa) { this.ngayRa = ngayRa; }

    @Override
    public String toString() {
        return "ThanhVienHo{" +
                "thanhVienID=" + thanhVienID +
                ", hoDanID=" + hoDanID +
                ", nguoiDungID=" + nguoiDungID +
                ", quanHeID=" + quanHeID +
                ", ngayVao=" + ngayVao +
                ", ngayRa=" + ngayRa +
                '}';
    }
}