package Model.Entity;

import java.sql.Date;

/**
 *
 * @author exorc
 */
public class NguoiDung {
    private int nguoiDungID;
    private String cccd;
    private String ho;
    private String ten;
    private Date ngaySinh;
    private String gioiTinh;
    private String email;
    private String soDienThoai;
    private String tenDangNhap;
    private String matKhauHash;
    private Integer vaiTroID;       // khóa ngoại - có thể null
    private Integer toDanPhoID;     // khóa ngoại - có thể null
    private boolean isActivated;
    private Date ngayTao;

    public NguoiDung() {
    }

    public NguoiDung(int nguoiDungID, String cccd, String ho, String ten, Date ngaySinh, 
                     String gioiTinh, String email, String soDienThoai, String tenDangNhap, 
                     String matKhauHash, Integer vaiTroID, Integer toDanPhoID, 
                     boolean isActivated, Date ngayTao) {
        this.nguoiDungID = nguoiDungID;
        this.cccd = cccd;
        this.ho = ho;
        this.ten = ten;
        this.ngaySinh = ngaySinh;
        this.gioiTinh = gioiTinh;
        this.email = email;
        this.soDienThoai = soDienThoai;
        this.tenDangNhap = tenDangNhap;
        this.matKhauHash = matKhauHash;
        this.vaiTroID = vaiTroID;
        this.toDanPhoID = toDanPhoID;
        this.isActivated = isActivated;
        this.ngayTao = ngayTao;
    }

    // Getter và Setter cho tất cả các trường
    public int getNguoiDungID() { return nguoiDungID; }
    public void setNguoiDungID(int nguoiDungID) { this.nguoiDungID = nguoiDungID; }

    public String getCccd() { return cccd; }
    public void setCccd(String cccd) { this.cccd = cccd; }

    public String getHo() { return ho; }
    public void setHo(String ho) { this.ho = ho; }

    public String getTen() { return ten; }
    public void setTen(String ten) { this.ten = ten; }

    public Date getNgaySinh() { return ngaySinh; }
    public void setNgaySinh(Date ngaySinh) { this.ngaySinh = ngaySinh; }

    public String getGioiTinh() { return gioiTinh; }
    public void setGioiTinh(String gioiTinh) { this.gioiTinh = gioiTinh; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSoDienThoai() { return soDienThoai; }
    public void setSoDienThoai(String soDienThoai) { this.soDienThoai = soDienThoai; }

    public String getTenDangNhap() { return tenDangNhap; }
    public void setTenDangNhap(String tenDangNhap) { this.tenDangNhap = tenDangNhap; }

    public String getMatKhauHash() { return matKhauHash; }
    public void setMatKhauHash(String matKhauHash) { this.matKhauHash = matKhauHash; }

    public Integer getVaiTroID() { return vaiTroID; }
    public void setVaiTroID(Integer vaiTroID) { this.vaiTroID = vaiTroID; }

    public Integer getToDanPhoID() { return toDanPhoID; }
    public void setToDanPhoID(Integer toDanPhoID) { this.toDanPhoID = toDanPhoID; }

    public boolean isIsActivated() { return isActivated; }
    public void setIsActivated(boolean isActivated) { this.isActivated = isActivated; }

    public Date getNgayTao() { return ngayTao; }
    public void setNgayTao(Date ngayTao) { this.ngayTao = ngayTao; }

    @Override
    public String toString() {
        return "NguoiDung{" +
                "nguoiDungID=" + nguoiDungID +
                ", cccd='" + cccd + '\'' +
                ", ho='" + ho + '\'' +
                ", ten='" + ten + '\'' +
                ", ngaySinh=" + ngaySinh +
                ", gioiTinh='" + gioiTinh + '\'' +
                ", email='" + email + '\'' +
                ", soDienThoai='" + soDienThoai + '\'' +
                ", tenDangNhap='" + tenDangNhap + '\'' +
                ", matKhauHash='" + matKhauHash + '\'' +
                ", vaiTroID=" + vaiTroID +
                ", toDanPhoID=" + toDanPhoID +
                ", isActivated=" + isActivated +
                ", ngayTao=" + ngayTao +
                '}';
    }
}