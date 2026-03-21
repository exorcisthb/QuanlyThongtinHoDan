package Model.Entity;

import java.time.LocalDateTime;

public class FileDinhKemPhanAnh {
    private int fileID;
    private int phanAnhID;
    private String duongDan;
    private LocalDateTime ngayUpload;

    public FileDinhKemPhanAnh() {}

    public FileDinhKemPhanAnh(int phanAnhID, String duongDan) {
        this.phanAnhID  = phanAnhID;
        this.duongDan   = duongDan;
    }

    public int getFileID() { return fileID; }
    public void setFileID(int fileID) { this.fileID = fileID; }

    public int getPhanAnhID() { return phanAnhID; }
    public void setPhanAnhID(int phanAnhID) { this.phanAnhID = phanAnhID; }

    public String getDuongDan() { return duongDan; }
    public void setDuongDan(String duongDan) { this.duongDan = duongDan; }

    public LocalDateTime getNgayUpload() { return ngayUpload; }
    public void setNgayUpload(LocalDateTime ngayUpload) { this.ngayUpload = ngayUpload; }
}