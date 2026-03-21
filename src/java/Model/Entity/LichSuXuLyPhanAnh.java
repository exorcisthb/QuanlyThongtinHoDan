package Model.Entity;

import java.time.LocalDateTime;

public class LichSuXuLyPhanAnh {
    private int logID;
    private int phanAnhID;
    private int nguoiThucHienID;
    private String hanhDong;
    // TIEP_NHAN | CHUYEN_CAP | GIAI_QUYET | TU_CHOI | BINH_LUAN
    private Integer trangThaiCu;   // nullable
    private Integer trangThaiMoi;  // nullable
    private String ghiChu;
    private LocalDateTime thoiGian;

    // Join fields
    private String tenNguoiThucHien;
    private String tenTrangThaiCu;
    private String tenTrangThaiMoi;

    public LichSuXuLyPhanAnh() {}

    // ── Getters / Setters ──

    public int getLogID() { return logID; }
    public void setLogID(int logID) { this.logID = logID; }

    public int getPhanAnhID() { return phanAnhID; }
    public void setPhanAnhID(int phanAnhID) { this.phanAnhID = phanAnhID; }

    public int getNguoiThucHienID() { return nguoiThucHienID; }
    public void setNguoiThucHienID(int nguoiThucHienID) { this.nguoiThucHienID = nguoiThucHienID; }

    public String getHanhDong() { return hanhDong; }
    public void setHanhDong(String hanhDong) { this.hanhDong = hanhDong; }

    public Integer getTrangThaiCu() { return trangThaiCu; }
    public void setTrangThaiCu(Integer trangThaiCu) { this.trangThaiCu = trangThaiCu; }

    public Integer getTrangThaiMoi() { return trangThaiMoi; }
    public void setTrangThaiMoi(Integer trangThaiMoi) { this.trangThaiMoi = trangThaiMoi; }

    public String getGhiChu() { return ghiChu; }
    public void setGhiChu(String ghiChu) { this.ghiChu = ghiChu; }

    public LocalDateTime getThoiGian() { return thoiGian; }
    public void setThoiGian(LocalDateTime thoiGian) { this.thoiGian = thoiGian; }

    // ── Join fields ──

    public String getTenNguoiThucHien() { return tenNguoiThucHien; }
    public void setTenNguoiThucHien(String tenNguoiThucHien) { this.tenNguoiThucHien = tenNguoiThucHien; }

    public String getTenTrangThaiCu() { return tenTrangThaiCu; }
    public void setTenTrangThaiCu(String tenTrangThaiCu) { this.tenTrangThaiCu = tenTrangThaiCu; }

    public String getTenTrangThaiMoi() { return tenTrangThaiMoi; }
    public void setTenTrangThaiMoi(String tenTrangThaiMoi) { this.tenTrangThaiMoi = tenTrangThaiMoi; }
}