package Model.Entity;

import java.util.List;

public class ImportResult {

    private int total;
    private int success;
    private List<String> errors;

    public ImportResult(int total, int success, List<String> errors) {
        this.total = total;
        this.success = success;
        this.errors = errors;
    }

    public int getTotal() {
        return total;
    }

    public int getSuccess() {
        return success;
    }

    public List<String> getErrors() {
        return errors;
    }
}
