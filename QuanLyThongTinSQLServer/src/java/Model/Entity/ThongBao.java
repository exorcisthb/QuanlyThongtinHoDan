package Model.Entity;

import java.sql.Date;

/**
 *
 * @author exorc
 */
public class ThongBao {
    private int thongBaoID;
    private String tieuDe;
    private String noiDung;
    private int nguoiGuiID;
    private Integer toDanPhoID;
    private Date ngayGui;

    public ThongBao() {
    }

    public ThongBao(int thongBaoID, String tieuDe, String noiDung, int nguoiGuiID, 
                    Integer toDanPhoID, Date ngayGui) {
        this.thongBaoID = thongBaoID;
        this.tieuDe = tieuDe;
        this.noiDung = noiDung;
        this.nguoiGuiID = nguoiGuiID;
        this.toDanPhoID = toDanPhoID;
        this.ngayGui = ngayGui;
    }

    public int getThongBaoID() { return thongBaoID; }
    public void setThongBaoID(int thongBaoID) { this.thongBaoID = thongBaoID; }

    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }

    public int getNguoiGuiID() { return nguoiGuiID; }
    public void setNguoiGuiID(int nguoiGuiID) { this.nguoiGuiID = nguoiGuiID; }

    public Integer getToDanPhoID() { return toDanPhoID; }
    public void setToDanPhoID(Integer toDanPhoID) { this.toDanPhoID = toDanPhoID; }

    public Date getNgayGui() { return ngayGui; }
    public void setNgayGui(Date ngayGui) { this.ngayGui = ngayGui; }

    @Override
    public String toString() {
        return "ThongBao{" +
                "thongBaoID=" + thongBaoID +
                ", tieuDe='" + tieuDe + '\'' +
                ", noiDung='" + noiDung + '\'' +
                ", nguoiGuiID=" + nguoiGuiID +
                ", toDanPhoID=" + toDanPhoID +
                ", ngayGui=" + ngayGui +
                '}';
    }
}