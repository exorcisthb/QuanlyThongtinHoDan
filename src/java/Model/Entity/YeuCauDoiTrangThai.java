package Model.Entity;

import java.sql.Date;

public class YeuCauDoiTrangThai {

    private int yeuCauID;
    private int hoDanID;
    private int trangThaiCuID;
    private int trangThaiMoiID;
    private int nguoiYeuCauID;
    private String lyDoYeuCau;
    private int trangThaiYeuCauID;
    private Integer nguoiDuyetID;
    private Date ngayDuyet;
    private String ghiChuDuyet;
    private Date ngayTao;

    // --- Join fields (display only) ---
    private String maHoKhau;
    private String diaChiHo;
    private String tenChuHo;
    private String tenTrangThaiCu;
    private String tenTrangThaiMoi;
    private String tenNguoiYeuCau;
    private String tenNguoiDuyet;
    private String tenTrangThaiYeuCau;
    private String tenTo;

    public YeuCauDoiTrangThai() {
    }

    public int getYeuCauID() {
        return yeuCauID;
    }

    public void setYeuCauID(int yeuCauID) {
        this.yeuCauID = yeuCauID;
    }

    public int getHoDanID() {
        return hoDanID;
    }

    public void setHoDanID(int hoDanID) {
        this.hoDanID = hoDanID;
    }

    public int getTrangThaiCuID() {
        return trangThaiCuID;
    }

    public void setTrangThaiCuID(int trangThaiCuID) {
        this.trangThaiCuID = trangThaiCuID;
    }

    public int getTrangThaiMoiID() {
        return trangThaiMoiID;
    }

    public void setTrangThaiMoiID(int trangThaiMoiID) {
        this.trangThaiMoiID = trangThaiMoiID;
    }

    public int getNguoiYeuCauID() {
        return nguoiYeuCauID;
    }

    public void setNguoiYeuCauID(int nguoiYeuCauID) {
        this.nguoiYeuCauID = nguoiYeuCauID;
    }

    public String getLyDoYeuCau() {
        return lyDoYeuCau;
    }

    public void setLyDoYeuCau(String lyDoYeuCau) {
        this.lyDoYeuCau = lyDoYeuCau;
    }

    public int getTrangThaiYeuCauID() {
        return trangThaiYeuCauID;
    }

    public void setTrangThaiYeuCauID(int trangThaiYeuCauID) {
        this.trangThaiYeuCauID = trangThaiYeuCauID;
    }

    public Integer getNguoiDuyetID() {
        return nguoiDuyetID;
    }

    public void setNguoiDuyetID(Integer nguoiDuyetID) {
        this.nguoiDuyetID = nguoiDuyetID;
    }

    public Date getNgayDuyet() {
        return ngayDuyet;
    }

    public void setNgayDuyet(Date ngayDuyet) {
        this.ngayDuyet = ngayDuyet;
    }

    public String getGhiChuDuyet() {
        return ghiChuDuyet;
    }

    public void setGhiChuDuyet(String ghiChuDuyet) {
        this.ghiChuDuyet = ghiChuDuyet;
    }

    public Date getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(Date ngayTao) {
        this.ngayTao = ngayTao;
    }

    public String getMaHoKhau() {
        return maHoKhau;
    }

    public void setMaHoKhau(String maHoKhau) {
        this.maHoKhau = maHoKhau;
    }

    public String getDiaChiHo() {
        return diaChiHo;
    }

    public void setDiaChiHo(String diaChiHo) {
        this.diaChiHo = diaChiHo;
    }

    public String getTenChuHo() {
        return tenChuHo;
    }

    public void setTenChuHo(String tenChuHo) {
        this.tenChuHo = tenChuHo;
    }

    public String getTenTrangThaiCu() {
        return tenTrangThaiCu;
    }

    public void setTenTrangThaiCu(String tenTrangThaiCu) {
        this.tenTrangThaiCu = tenTrangThaiCu;
    }

    public String getTenTrangThaiMoi() {
        return tenTrangThaiMoi;
    }

    public void setTenTrangThaiMoi(String tenTrangThaiMoi) {
        this.tenTrangThaiMoi = tenTrangThaiMoi;
    }

    public String getTenNguoiYeuCau() {
        return tenNguoiYeuCau;
    }

    public void setTenNguoiYeuCau(String tenNguoiYeuCau) {
        this.tenNguoiYeuCau = tenNguoiYeuCau;
    }

    public String getTenNguoiDuyet() {
        return tenNguoiDuyet;
    }

    public void setTenNguoiDuyet(String tenNguoiDuyet) {
        this.tenNguoiDuyet = tenNguoiDuyet;
    }

    public String getTenTrangThaiYeuCau() {
        return tenTrangThaiYeuCau;
    }

    public void setTenTrangThaiYeuCau(String tenTrangThaiYeuCau) {
        this.tenTrangThaiYeuCau = tenTrangThaiYeuCau;
    }

    public String getTenTo() {
        return tenTo;
    }

    public void setTenTo(String tenTo) {
        this.tenTo = tenTo;
    }

    /** Kiểm tra yêu cầu đang chờ duyệt */
    public boolean isChoDuyet() {
        return trangThaiYeuCauID == 1;
    }

    /** Kiểm tra yêu cầu đã được duyệt */
    public boolean isDaDuyet() {
        return trangThaiYeuCauID == 2;
    }

    /** Kiểm tra yêu cầu bị từ chối */
    public boolean isTuChoi() {
        return trangThaiYeuCauID == 3;
    }

    /** Kiểm tra yêu cầu đã bị huỷ */
    public boolean isDaHuy() {
        return trangThaiYeuCauID == 4;
    }
}