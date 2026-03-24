package Model.Entity;

import java.sql.Date;

public class HoDan {

    private int hoDanID;
    private String maHoKhau;
    private String diaChi;
    private int toDanPhoID;
    private Integer chuHoID;
    private int trangThaiID;
    private Date ngayTao;
    private String tenChuHo;
    private String tenTrangThai;
    private int soThanhVien;
    private String tenDuong;
    private String tenTo; // ← thêm mới
    private String cccdChuHo;
    private Date ngaySinhChuHo;
    private String gioiTinhChuHo;
    private String soDienThoaiChuHo;
    private String emailChuHo;
    private int tuoiChuHo;
    private boolean daKichHoat;

    public HoDan() {
    }

    public int getHoDanID() {
        return hoDanID;
    }

    public void setHoDanID(int hoDanID) {
        this.hoDanID = hoDanID;
    }

    public String getMaHoKhau() {
        return maHoKhau;
    }

    public void setMaHoKhau(String maHoKhau) {
        this.maHoKhau = maHoKhau;
    }

    public String getDiaChi() {
        return diaChi;
    }

    public void setDiaChi(String diaChi) {
        this.diaChi = diaChi;
    }

    public int getToDanPhoID() {
        return toDanPhoID;
    }

    public void setToDanPhoID(int toDanPhoID) {
        this.toDanPhoID = toDanPhoID;
    }

    public Integer getChuHoID() {
        return chuHoID;
    }

    public void setChuHoID(Integer chuHoID) {
        this.chuHoID = chuHoID;
    }

    public int getTrangThaiID() {
        return trangThaiID;
    }

    public void setTrangThaiID(int trangThaiID) {
        this.trangThaiID = trangThaiID;
    }

    public Date getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(Date ngayTao) {
        this.ngayTao = ngayTao;
    }

    public String getTenChuHo() {
        return tenChuHo;
    }

    public void setTenChuHo(String tenChuHo) {
        this.tenChuHo = tenChuHo;
    }

    public String getTenTrangThai() {
        return tenTrangThai;
    }

    public void setTenTrangThai(String tenTrangThai) {
        this.tenTrangThai = tenTrangThai;
    }

    public int getSoThanhVien() {
        return soThanhVien;
    }

    public void setSoThanhVien(int soThanhVien) {
        this.soThanhVien = soThanhVien;
    }

    public String getTenDuong() {
        return tenDuong;
    }

    public void setTenDuong(String tenDuong) {
        this.tenDuong = tenDuong;
    }

    public String getTenTo() {
        return tenTo;
    }           // ← thêm mới

    public void setTenTo(String tenTo) {
        this.tenTo = tenTo;
    } // ← thêm mới

    public String getCccdChuHo() {
        return cccdChuHo;
    }

    public void setCccdChuHo(String cccdChuHo) {
        this.cccdChuHo = cccdChuHo;
    }

    public Date getNgaySinhChuHo() {
        return ngaySinhChuHo;
    }

    public void setNgaySinhChuHo(Date ngaySinhChuHo) {
        this.ngaySinhChuHo = ngaySinhChuHo;
    }

    public String getGioiTinhChuHo() {
        return gioiTinhChuHo;
    }

    public void setGioiTinhChuHo(String gioiTinhChuHo) {
        this.gioiTinhChuHo = gioiTinhChuHo;
    }

    public String getSoDienThoaiChuHo() {
        return soDienThoaiChuHo;
    }

    public void setSoDienThoaiChuHo(String soDienThoaiChuHo) {
        this.soDienThoaiChuHo = soDienThoaiChuHo;
    }

    public String getEmailChuHo() {
        return emailChuHo;
    }

    public void setEmailChuHo(String emailChuHo) {
        this.emailChuHo = emailChuHo;
    }

    public int getTuoiChuHo() {
        return tuoiChuHo;
    }

    public void setTuoiChuHo(int tuoiChuHo) {
        this.tuoiChuHo = tuoiChuHo;
    }

    public boolean isDaKichHoat() {
        return daKichHoat;
    }

    public void setDaKichHoat(boolean daKichHoat) {
        this.daKichHoat = daKichHoat;
    }

    public String extractTenDuong() {
        if (diaChi == null || diaChi.trim().isEmpty()) {
            return "Không rõ";
        }
        String part = diaChi.split(",")[0].trim();
        String[] tokens = part.split(" ", 2);
        if (tokens.length == 2 && tokens[0].matches("\\d+")) {
            return tokens[1].trim();
        }
        return part;
    }
}
