package Model.Entity;

import java.time.LocalDateTime;

public class PhanAnh {
    private int phanAnhID;
    private String tieuDe;
    private String noiDung;

    // FK
    private int loaiID;
    private int mucDoUuTien;   // 1=Thấp | 2=Trung bình | 3=Cao
    private int nguoiGuiID;
    private int toDanPhoID;
    private int trangThaiID;
    private Integer nguoiXuLyID;   // nullable

    private boolean daChuyenCap;
    private LocalDateTime ngayTao;
    private LocalDateTime ngayCapNhat;  // nullable

    // Join fields — dùng khi query có JOIN, không map vào DB
    private String tenLoai;
    private String tenTrangThai;
    private String tenNguoiGui;
    private String tenNguoiXuLy;
    private String tenToDanPho;

    public PhanAnh() {}

    // ── Getters / Setters ──

    public int getPhanAnhID() { return phanAnhID; }
    public void setPhanAnhID(int phanAnhID) { this.phanAnhID = phanAnhID; }

    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }

    public int getLoaiID() { return loaiID; }
    public void setLoaiID(int loaiID) { this.loaiID = loaiID; }

    public int getMucDoUuTien() { return mucDoUuTien; }
    public void setMucDoUuTien(int mucDoUuTien) { this.mucDoUuTien = mucDoUuTien; }

    /** Tiện ích — không cần query DB */
    public String getTenMucDo() {
        return switch (mucDoUuTien) {
            case 1 -> "Thấp";
            case 3 -> "Cao";
            default -> "Trung bình";
        };
    }

    public int getNguoiGuiID() { return nguoiGuiID; }
    public void setNguoiGuiID(int nguoiGuiID) { this.nguoiGuiID = nguoiGuiID; }

    public int getToDanPhoID() { return toDanPhoID; }
    public void setToDanPhoID(int toDanPhoID) { this.toDanPhoID = toDanPhoID; }

    public int getTrangThaiID() { return trangThaiID; }
    public void setTrangThaiID(int trangThaiID) { this.trangThaiID = trangThaiID; }

    public Integer getNguoiXuLyID() { return nguoiXuLyID; }
    public void setNguoiXuLyID(Integer nguoiXuLyID) { this.nguoiXuLyID = nguoiXuLyID; }

    public boolean isDaChuyenCap() { return daChuyenCap; }
    public void setDaChuyenCap(boolean daChuyenCap) { this.daChuyenCap = daChuyenCap; }

    public LocalDateTime getNgayTao() { return ngayTao; }
    public void setNgayTao(LocalDateTime ngayTao) { this.ngayTao = ngayTao; }

    public LocalDateTime getNgayCapNhat() { return ngayCapNhat; }
    public void setNgayCapNhat(LocalDateTime ngayCapNhat) { this.ngayCapNhat = ngayCapNhat; }

    // ── Join fields ──

    public String getTenLoai() { return tenLoai; }
    public void setTenLoai(String tenLoai) { this.tenLoai = tenLoai; }

    public String getTenTrangThai() { return tenTrangThai; }
    public void setTenTrangThai(String tenTrangThai) { this.tenTrangThai = tenTrangThai; }

    public String getTenNguoiGui() { return tenNguoiGui; }
    public void setTenNguoiGui(String tenNguoiGui) { this.tenNguoiGui = tenNguoiGui; }

    public String getTenNguoiXuLy() { return tenNguoiXuLy; }
    public void setTenNguoiXuLy(String tenNguoiXuLy) { this.tenNguoiXuLy = tenNguoiXuLy; }

    public String getTenToDanPho() { return tenToDanPho; }
    public void setTenToDanPho(String tenToDanPho) { this.tenToDanPho = tenToDanPho; }
}