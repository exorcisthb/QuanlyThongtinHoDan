package Model.Entity;

import java.sql.Date;

/**
 *
 * @author exorc
 */
public class NguoiNhanThongBao {
    private int id;
    private int thongBaoID;
    private int nguoiDungID;
    private boolean daDoc;
    private Date thoiGianDoc;

    public NguoiNhanThongBao() {
    }

    public NguoiNhanThongBao(int id, int thongBaoID, int nguoiDungID, boolean daDoc, Date thoiGianDoc) {
        this.id = id;
        this.thongBaoID = thongBaoID;
        this.nguoiDungID = nguoiDungID;
        this.daDoc = daDoc;
        this.thoiGianDoc = thoiGianDoc;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getThongBaoID() { return thongBaoID; }
    public void setThongBaoID(int thongBaoID) { this.thongBaoID = thongBaoID; }

    public int getNguoiDungID() { return nguoiDungID; }
    public void setNguoiDungID(int nguoiDungID) { this.nguoiDungID = nguoiDungID; }

    public boolean isDaDoc() { return daDoc; }
    public void setDaDoc(boolean daDoc) { this.daDoc = daDoc; }

    public Date getThoiGianDoc() { return thoiGianDoc; }
    public void setThoiGianDoc(Date thoiGianDoc) { this.thoiGianDoc = thoiGianDoc; }

    @Override
    public String toString() {
        return "NguoiNhanThongBao{" +
                "id=" + id +
                ", thongBaoID=" + thongBaoID +
                ", nguoiDungID=" + nguoiDungID +
                ", daDoc=" + daDoc +
                ", thoiGianDoc=" + thoiGianDoc +
                '}';
    }
}