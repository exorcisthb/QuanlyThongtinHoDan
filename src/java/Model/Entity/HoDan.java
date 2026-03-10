package Model.Entity;

import java.sql.Date;

/**
 *
 * @author exorc
 */
public class HoDan {
    private int hoDanID;
    private String maHoKhau;
    private String diaChi;
    private Integer toDanPhoID;     // khóa ngoại
    private Integer chuHoID;        // khóa ngoại đến NguoiDung
    private Integer trangThaiID;    // khóa ngoại
    private Date ngayTao;

    public HoDan() {
    }

    public HoDan(int hoDanID, String maHoKhau, String diaChi, Integer toDanPhoID, 
                 Integer chuHoID, Integer trangThaiID, Date ngayTao) {
        this.hoDanID = hoDanID;
        this.maHoKhau = maHoKhau;
        this.diaChi = diaChi;
        this.toDanPhoID = toDanPhoID;
        this.chuHoID = chuHoID;
        this.trangThaiID = trangThaiID;
        this.ngayTao = ngayTao;
    }

    public int getHoDanID() { return hoDanID; }
    public void setHoDanID(int hoDanID) { this.hoDanID = hoDanID; }

    public String getMaHoKhau() { return maHoKhau; }
    public void setMaHoKhau(String maHoKhau) { this.maHoKhau = maHoKhau; }

    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }

    public Integer getToDanPhoID() { return toDanPhoID; }
    public void setToDanPhoID(Integer toDanPhoID) { this.toDanPhoID = toDanPhoID; }

    public Integer getChuHoID() { return chuHoID; }
    public void setChuHoID(Integer chuHoID) { this.chuHoID = chuHoID; }

    public Integer getTrangThaiID() { return trangThaiID; }
    public void setTrangThaiID(Integer trangThaiID) { this.trangThaiID = trangThaiID; }

    public Date getNgayTao() { return ngayTao; }
    public void setNgayTao(Date ngayTao) { this.ngayTao = ngayTao; }

    @Override
    public String toString() {
        return "HoDan{" +
                "hoDanID=" + hoDanID +
                ", maHoKhau='" + maHoKhau + '\'' +
                ", diaChi='" + diaChi + '\'' +
                ", toDanPhoID=" + toDanPhoID +
                ", chuHoID=" + chuHoID +
                ", trangThaiID=" + trangThaiID +
                ", ngayTao=" + ngayTao +
                '}';
    }
}