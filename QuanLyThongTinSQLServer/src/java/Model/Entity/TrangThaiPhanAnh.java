package Model.Entity;

public class TrangThaiPhanAnh {
    private int trangThaiID;
    private String tenTrangThai;

    public TrangThaiPhanAnh() {}

    public TrangThaiPhanAnh(int trangThaiID, String tenTrangThai) {
        this.trangThaiID = trangThaiID;
        this.tenTrangThai = tenTrangThai;
    }

    public int getTrangThaiID() { return trangThaiID; }
    public void setTrangThaiID(int trangThaiID) { this.trangThaiID = trangThaiID; }

    public String getTenTrangThai() { return tenTrangThai; }
    public void setTenTrangThai(String tenTrangThai) { this.tenTrangThai = tenTrangThai; }
}