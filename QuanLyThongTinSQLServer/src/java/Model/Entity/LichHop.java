package Model.Entity;

import java.time.LocalDateTime;

public class LichHop {

    private int lichHopID;
    private String tieuDe;
    private String noiDung;
    private String diaDiem;
    private LocalDateTime thoiGianBatDau;
    private LocalDateTime thoiGianKetThuc;
    private int toDanPhoID;
    private int nguoiTaoID;

    private int trangThai;
    private LocalDateTime ngayTao;
    private int mucDo;
    private String doiTuong;

    public LichHop() {
    }

    public LichHop(int lichHopID, String tieuDe, String noiDung, String diaDiem,
            LocalDateTime thoiGianBatDau, LocalDateTime thoiGianKetThuc,
            int toDanPhoID, int nguoiTaoID, int trangThai, LocalDateTime ngayTao) {
        this.lichHopID = lichHopID;
        this.tieuDe = tieuDe;
        this.noiDung = noiDung;
        this.diaDiem = diaDiem;
        this.thoiGianBatDau = thoiGianBatDau;
        this.thoiGianKetThuc = thoiGianKetThuc;
        this.toDanPhoID = toDanPhoID;
        this.nguoiTaoID = nguoiTaoID;
        this.trangThai = trangThai;
        this.ngayTao = ngayTao;
    }

    public int getLichHopID() {
        return lichHopID;
    }

    public void setLichHopID(int lichHopID) {
        this.lichHopID = lichHopID;
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

    public LocalDateTime getThoiGianBatDau() {
        return thoiGianBatDau;
    }

    public void setThoiGianBatDau(LocalDateTime thoiGianBatDau) {
        this.thoiGianBatDau = thoiGianBatDau;
    }

    public LocalDateTime getThoiGianKetThuc() {
        return thoiGianKetThuc;
    }

    public void setThoiGianKetThuc(LocalDateTime thoiGianKetThuc) {
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

    public int getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(int trangThai) {
        this.trangThai = trangThai;
    }

    public LocalDateTime getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(LocalDateTime ngayTao) {
        this.ngayTao = ngayTao;
    }

    public int getMucDo() {
        return mucDo;
    }

    public void setMucDo(int mucDo) {
        this.mucDo = mucDo;
    }

    public String getDoiTuong() {
        return doiTuong;
    }

    public void setDoiTuong(String doiTuong) {
        this.doiTuong = doiTuong;
    }

    @Override
    public String toString() {
        return "LichHop{lichHopID=" + lichHopID + ", tieuDe='" + tieuDe
                + "', diaDiem='" + diaDiem + "', thoiGianBatDau=" + thoiGianBatDau
                + ", trangThai=" + trangThai + "}";
    }
}
