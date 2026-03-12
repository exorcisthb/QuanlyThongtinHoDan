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

    // Thêm từ JOIN
    private String tenChuHo;      // ho + ten của chủ hộ
    private String tenTrangThai;
    private int soThanhVien;
    private String tenDuong;      // tách từ diaChi

    public HoDan() {}

    // ── Getters / Setters ──
    public int getHoDanID() { return hoDanID; }
    public void setHoDanID(int hoDanID) { this.hoDanID = hoDanID; }

    public String getMaHoKhau() { return maHoKhau; }
    public void setMaHoKhau(String maHoKhau) { this.maHoKhau = maHoKhau; }

    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }

    public int getToDanPhoID() { return toDanPhoID; }
    public void setToDanPhoID(int toDanPhoID) { this.toDanPhoID = toDanPhoID; }

    public Integer getChuHoID() { return chuHoID; }
    public void setChuHoID(Integer chuHoID) { this.chuHoID = chuHoID; }

    public int getTrangThaiID() { return trangThaiID; }
    public void setTrangThaiID(int trangThaiID) { this.trangThaiID = trangThaiID; }

    public Date getNgayTao() { return ngayTao; }
    public void setNgayTao(Date ngayTao) { this.ngayTao = ngayTao; }

    public String getTenChuHo() { return tenChuHo; }
    public void setTenChuHo(String tenChuHo) { this.tenChuHo = tenChuHo; }

    public String getTenTrangThai() { return tenTrangThai; }
    public void setTenTrangThai(String tenTrangThai) { this.tenTrangThai = tenTrangThai; }

    public int getSoThanhVien() { return soThanhVien; }
    public void setSoThanhVien(int soThanhVien) { this.soThanhVien = soThanhVien; }

    public String getTenDuong() { return tenDuong; }
    public void setTenDuong(String tenDuong) { this.tenDuong = tenDuong; }

    // Tách tên đường từ địa chỉ
    // VD: "12 Hùng Vương, Phường X" → "Hùng Vương"
    public String extractTenDuong() {
        if (diaChi == null || diaChi.trim().isEmpty()) return "Không rõ";
        String part = diaChi.split(",")[0].trim(); // "12 Hùng Vương"
        // Bỏ số đầu
        String[] tokens = part.split(" ", 2);
        if (tokens.length == 2 && tokens[0].matches("\\d+")) {
            return tokens[1].trim();
        }
        return part;
    }
}