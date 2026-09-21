public class ApexSignalBuffer {
    @TestVisible
    private List<ApexSignalEntry> entries = new List<ApexSignalEntry>();

    public void add(ApexSignalEntry entry) {
        if (entry != null) {
            entries.add(entry);
        }
    }

    public Integer size() {
        return entries.size();
    }

    public Boolean isEmpty() {
        return entries.isEmpty();
    }

    public List<ApexSignalEntry> drain() {
        List<ApexSignalEntry> drained = new List<ApexSignalEntry>();
        drained.addAll(entries);
        entries.clear();
        return drained;
    }
}
