package Model.Entity;

import java.sql.Date;

public class YeuCauDoiTrangThai {

    private int yeuCauID;
    private int loaiYeuCau;          // THÊM MỚI: 1=ĐổiTrangThái | 2=CậpNhậtThôngTin
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

    // THÊM MỚI: fields cho loại 2 - cập nhật thông tin cá nhân
    private Integer nguoiDungCapNhatID;
    private String ho_Cu;
    private String ten_Cu;
    private Date ngaySinh_Cu;
    private String gioiTinh_Cu;
    private String email_Cu;
    private String sDT_Cu;
    private String cCCD_Cu;
    private String avatar_Cu;
    private String ho_Moi;
    private String ten_Moi;
    private Date ngaySinh_Moi;
    private String gioiTinh_Moi;
    private String email_Moi;
    private String sDT_Moi;
    private String cCCD_Moi;
    private String avatar_Moi;

    // --- Join fields (display only) --- GIỮ NGUYÊN
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

    // ── GIỮ NGUYÊN toàn bộ getter/setter cũ ──────────────────
    public int getYeuCauID() {
        return yeuCauID;
    }

    public void setYeuCauID(int yeuCauID) {
        this.yeuCauID = yeuCauID;
    }

    public int getLoaiYeuCau() {
        return loaiYeuCau;
    }

    public void setLoaiYeuCau(int loaiYeuCau) {
        this.loaiYeuCau = loaiYeuCau;
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

    // ── THÊM MỚI: getter/setter cho loại 2 ───────────────────
    public Integer getNguoiDungCapNhatID() {
        return nguoiDungCapNhatID;
    }

    public void setNguoiDungCapNhatID(Integer nguoiDungCapNhatID) {
        this.nguoiDungCapNhatID = nguoiDungCapNhatID;
    }

    public String getHo_Cu() {
        return ho_Cu;
    }

    public void setHo_Cu(String ho_Cu) {
        this.ho_Cu = ho_Cu;
    }

    public String getTen_Cu() {
        return ten_Cu;
    }

    public void setTen_Cu(String ten_Cu) {
        this.ten_Cu = ten_Cu;
    }

    public Date getNgaySinh_Cu() {
        return ngaySinh_Cu;
    }

    public void setNgaySinh_Cu(Date ngaySinh_Cu) {
        this.ngaySinh_Cu = ngaySinh_Cu;
    }

    public String getGioiTinh_Cu() {
        return gioiTinh_Cu;
    }

    public void setGioiTinh_Cu(String gioiTinh_Cu) {
        this.gioiTinh_Cu = gioiTinh_Cu;
    }

    public String getEmail_Cu() {
        return email_Cu;
    }

    public void setEmail_Cu(String email_Cu) {
        this.email_Cu = email_Cu;
    }

    public String getSDT_Cu() {
        return sDT_Cu;
    }

    public void setSDT_Cu(String sDT_Cu) {
        this.sDT_Cu = sDT_Cu;
    }

    public String getCCCD_Cu() {
        return cCCD_Cu;
    }

    public void setCCCD_Cu(String cCCD_Cu) {
        this.cCCD_Cu = cCCD_Cu;
    }

    public String getAvatar_Cu() {
        return avatar_Cu;
    }

    public void setAvatar_Cu(String avatar_Cu) {
        this.avatar_Cu = avatar_Cu;
    }

    public String getHo_Moi() {
        return ho_Moi;
    }

    public void setHo_Moi(String ho_Moi) {
        this.ho_Moi = ho_Moi;
    }

    public String getTen_Moi() {
        return ten_Moi;
    }

    public void setTen_Moi(String ten_Moi) {
        this.ten_Moi = ten_Moi;
    }

    public Date getNgaySinh_Moi() {
        return ngaySinh_Moi;
    }

    public void setNgaySinh_Moi(Date ngaySinh_Moi) {
        this.ngaySinh_Moi = ngaySinh_Moi;
    }

    public String getGioiTinh_Moi() {
        return gioiTinh_Moi;
    }

    public void setGioiTinh_Moi(String gioiTinh_Moi) {
        this.gioiTinh_Moi = gioiTinh_Moi;
    }

    public String getEmail_Moi() {
        return email_Moi;
    }

    public void setEmail_Moi(String email_Moi) {
        this.email_Moi = email_Moi;
    }

    public String getSDT_Moi() {
        return sDT_Moi;
    }

    public void setSDT_Moi(String sDT_Moi) {
        this.sDT_Moi = sDT_Moi;
    }

    public String getCCCD_Moi() {
        return cCCD_Moi;
    }

    public void setCCCD_Moi(String cCCD_Moi) {
        this.cCCD_Moi = cCCD_Moi;
    }

    public String getAvatar_Moi() {
        return avatar_Moi;
    }

    public void setAvatar_Moi(String avatar_Moi) {
        this.avatar_Moi = avatar_Moi;
    }

    // ── Helper methods GIỮ NGUYÊN ─────────────────────────────
    public boolean isChoDuyet() {
        return trangThaiYeuCauID == 1;
    }

    public boolean isDaDuyet() {
        return trangThaiYeuCauID == 2;
    }

    public boolean isTuChoi() {
        return trangThaiYeuCauID == 3;
    }

    public boolean isDaHuy() {
        return trangThaiYeuCauID == 4;
    }

    // THÊM MỚI: helper phân loại yêu cầu
    public boolean isLoaiDoiTrangThai() {
        return loaiYeuCau == 1;
    }

    public boolean isLoaiCapNhatThongTin() {
        return loaiYeuCau == 2;
    }
}
