package Model.Entity;

import java.sql.Date;

/**
 *
 * @author exorc
 */
public class TokenResetMatKhau {
    private int tokenID;
    private int nguoiDungID;
    private String token;
    private Date ngayHetHan;

    public TokenResetMatKhau() {
    }

    public TokenResetMatKhau(int tokenID, int nguoiDungID, String token, Date ngayHetHan) {
        this.tokenID = tokenID;
        this.nguoiDungID = nguoiDungID;
        this.token = token;
        this.ngayHetHan = ngayHetHan;
    }

    public int getTokenID() { return tokenID; }
    public void setTokenID(int tokenID) { this.tokenID = tokenID; }

    public int getNguoiDungID() { return nguoiDungID; }
    public void setNguoiDungID(int nguoiDungID) { this.nguoiDungID = nguoiDungID; }

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }

    public Date getNgayHetHan() { return ngayHetHan; }
    public void setNgayHetHan(Date ngayHetHan) { this.ngayHetHan = ngayHetHan; }

    @Override
    public String toString() {
        return "TokenResetMatKhau{" +
                "tokenID=" + tokenID +
                ", nguoiDungID=" + nguoiDungID +
                ", token='" + token + '\'' +
                ", ngayHetHan=" + ngayHetHan +
                '}';
    }
}