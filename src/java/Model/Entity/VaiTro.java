package Model.Entity;

import java.sql.Date;

/**
 *
 * @author exorc
 */
public class VaiTro {
    private int vaiTroID;
    private String tenVaiTro;

    public VaiTro() {
    }

    public VaiTro(int vaiTroID, String tenVaiTro) {
        this.vaiTroID = vaiTroID;
        this.tenVaiTro = tenVaiTro;
    }

    public int getVaiTroID() {
        return vaiTroID;
    }

    public void setVaiTroID(int vaiTroID) {
        this.vaiTroID = vaiTroID;
    }

    public String getTenVaiTro() {
        return tenVaiTro;
    }

    public void setTenVaiTro(String tenVaiTro) {
        this.tenVaiTro = tenVaiTro;
    }

    @Override
    public String toString() {
        return "VaiTro{" + "vaiTroID=" + vaiTroID + ", tenVaiTro=" + tenVaiTro + '}';
    }
}