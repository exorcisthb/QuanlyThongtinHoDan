package Model.Entity;

import java.time.LocalDateTime;

public class LichSuSuaLichHop {

    private int suaID;
    private int lichHopID;
    private int nguoiSuaID;
    private LocalDateTime thoiGianSua;
    private String noiDungThayDoi;   // JSON snapshot: {"truoc": {...}, "sau": {...}}
    private String lyDoSua;

    public LichSuSuaLichHop() {
    }

    public LichSuSuaLichHop(int suaID, int lichHopID, int nguoiSuaID,
            LocalDateTime thoiGianSua, String noiDungThayDoi,
            String lyDoSua) {
        this.suaID = suaID;
        this.lichHopID = lichHopID;
        this.nguoiSuaID = nguoiSuaID;
        this.thoiGianSua = thoiGianSua;
        this.noiDungThayDoi = noiDungThayDoi;
        this.lyDoSua = lyDoSua;
    }

    public int getSuaID() {
        return suaID;
    }

    public void setSuaID(int suaID) {
        this.suaID = suaID;
    }

    public int getLichHopID() {
        return lichHopID;
    }

    public void setLichHopID(int lichHopID) {
        this.lichHopID = lichHopID;
    }

    public int getNguoiSuaID() {
        return nguoiSuaID;
    }

    public void setNguoiSuaID(int nguoiSuaID) {
        this.nguoiSuaID = nguoiSuaID;
    }

    public LocalDateTime getThoiGianSua() {
        return thoiGianSua;
    }

    public void setThoiGianSua(LocalDateTime thoiGianSua) {
        this.thoiGianSua = thoiGianSua;
    }

    public String getNoiDungThayDoi() {
        return noiDungThayDoi;
    }

    public void setNoiDungThayDoi(String noiDungThayDoi) {
        this.noiDungThayDoi = noiDungThayDoi;
    }

    public String getLyDoSua() {
        return lyDoSua;
    }

    public void setLyDoSua(String lyDoSua) {
        this.lyDoSua = lyDoSua;
    }

    @Override
    public String toString() {
        return "LichSuSuaLichHop{suaID=" + suaID + ", lichHopID=" + lichHopID
                + ", nguoiSuaID=" + nguoiSuaID + ", thoiGianSua=" + thoiGianSua + "}";
    }
}
