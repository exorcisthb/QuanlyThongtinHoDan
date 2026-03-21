package Model.Entity;

public class LoaiPhanAnh {
    private int loaiID;
    private String tenLoai;

    public LoaiPhanAnh() {}

    public LoaiPhanAnh(int loaiID, String tenLoai) {
        this.loaiID = loaiID;
        this.tenLoai = tenLoai;
    }

    public int getLoaiID() { return loaiID; }
    public void setLoaiID(int loaiID) { this.loaiID = loaiID; }

    public String getTenLoai() { return tenLoai; }
    public void setTenLoai(String tenLoai) { this.tenLoai = tenLoai; }
}