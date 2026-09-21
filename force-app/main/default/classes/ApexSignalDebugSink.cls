public class ApexSignalDebugSink implements ApexSignalSink {
    public void write(List<ApexSignalEntry> entries) {
        for (ApexSignalEntry entry : entries) {
            System.debug(LoggingLevel.INFO, 'APEX_SIGNAL ' + entry.toJson());
        }
    }
}
