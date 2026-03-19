package Model.Entity;

import java.sql.Timestamp;

public class ThiepMoi {

    private int thiepMoiID;
    private String tieuDe;
    private String noiDung;
    private String diaDiem;
    private Timestamp thoiGianBatDau;
    private Timestamp thoiGianKetThuc;
    private int toDanPhoID;
    private int nguoiTaoID;
    private int trangThaiID;
    private boolean daIn;
    private Timestamp thoiGianIn;
    private Integer nguoiInID;
    private Integer lichHopID;
    private Timestamp ngayTao;
    // Thông tin join để hiển thị
    private String tenTrangThai;
    private String tenTo;
    private String tenNguoiTao;
    private String ghiChuHoan; // thêm dòng này

    public ThiepMoi() {
    }

    public int getThiepMoiID() {
        return thiepMoiID;
    }

    public void setThiepMoiID(int thiepMoiID) {
        this.thiepMoiID = thiepMoiID;
    }

    public String getTieuDe() {
        return tieuDe;
    }

    public void setTieuDe(String tieuDe) {
        this.tieuDe = tieuDe;
    }

    public String getNoiDung() {
        return noiDung;
    }

    public void setNoiDung(String noiDung) {
        this.noiDung = noiDung;
    }

    public String getDiaDiem() {
        return diaDiem;
    }

    public void setDiaDiem(String diaDiem) {
        this.diaDiem = diaDiem;
    }

    public Timestamp getThoiGianBatDau() {
        return thoiGianBatDau;
    }

    public void setThoiGianBatDau(Timestamp thoiGianBatDau) {
        this.thoiGianBatDau = thoiGianBatDau;
    }

    public Timestamp getThoiGianKetThuc() {
        return thoiGianKetThuc;
    }

    public void setThoiGianKetThuc(Timestamp thoiGianKetThuc) {
        this.thoiGianKetThuc = thoiGianKetThuc;
    }

    public int getToDanPhoID() {
        return toDanPhoID;
    }

    public void setToDanPhoID(int toDanPhoID) {
        this.toDanPhoID = toDanPhoID;
    }

    public int getNguoiTaoID() {
        return nguoiTaoID;
    }

    public void setNguoiTaoID(int nguoiTaoID) {
        this.nguoiTaoID = nguoiTaoID;
    }

    public int getTrangThaiID() {
        return trangThaiID;
    }

    public void setTrangThaiID(int trangThaiID) {
        this.trangThaiID = trangThaiID;
    }

    public boolean isDaIn() {
        return daIn;
    }

    public void setDaIn(boolean daIn) {
        this.daIn = daIn;
    }

    public Timestamp getThoiGianIn() {
        return thoiGianIn;
    }

    public void setThoiGianIn(Timestamp thoiGianIn) {
        this.thoiGianIn = thoiGianIn;
    }

    public Integer getNguoiInID() {
        return nguoiInID;
    }

    public void setNguoiInID(Integer nguoiInID) {
        this.nguoiInID = nguoiInID;
    }

    public Integer getLichHopID() {
        return lichHopID;
    }

    public void setLichHopID(Integer lichHopID) {
        this.lichHopID = lichHopID;
    }

    public Timestamp getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(Timestamp ngayTao) {
        this.ngayTao = ngayTao;
    }

    public String getTenTrangThai() {
        return tenTrangThai;
    }

    public void setTenTrangThai(String tenTrangThai) {
        this.tenTrangThai = tenTrangThai;
    }

    public String getTenTo() {
        return tenTo;
    }

    public void setTenTo(String tenTo) {
        this.tenTo = tenTo;
    }

    public String getTenNguoiTao() {
        return tenNguoiTao;
    }

    public void setTenNguoiTao(String tenNguoiTao) {
        this.tenNguoiTao = tenNguoiTao;
    }

    public String getGhiChuHoan() {
        return ghiChuHoan;
    }

    public void setGhiChuHoan(String ghiChuHoan) {
        this.ghiChuHoan = ghiChuHoan;
    }
}
