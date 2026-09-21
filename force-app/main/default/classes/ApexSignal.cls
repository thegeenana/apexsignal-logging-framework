public class ApexSignal {
    @TestVisible private static ApexSignalBuffer buffer = new ApexSignalBuffer();
    @TestVisible private static List<ApexSignalSink> sinks =
        new List<ApexSignalSink>{ new ApexSignalDebugSink() };
    @TestVisible private static Map<String, Object> sharedContext =
        new Map<String, Object>();
    @TestVisible private static String correlationId;
    @TestVisible private static Boolean failOpen = true;

    private ApexSignal() {
    }

    public static String getCorrelationId() {
        if (String.isBlank(correlationId)) {
            correlationId = newIdentifier();
        }
        return correlationId;
    }

    public static void setCorrelationId(String value) {
        correlationId = String.isBlank(value) ? newIdentifier() : value;
    }

    public static void context(String key, Object value) {
        if (!String.isBlank(key)) {
            sharedContext.put(key, value);
        }
    }

    public static void clearContext() {
        sharedContext.clear();
    }

    public static void setFailOpen(Boolean value) {
        failOpen = value == null ? true : value;
    }

    public static void addSink(ApexSignalSink sink) {
        if (sink != null) {
            sinks.add(sink);
        }
    }

    public static void clearSinks() {
        sinks.clear();
    }

    public static void debug(String message) {
        log(ApexSignalLevel.DEBUG, message, null, null);
    }

    public static void info(String message) {
        log(ApexSignalLevel.INFO, message, null, null);
    }

    public static void warn(String message) {
        log(ApexSignalLevel.WARN, message, null, null);
    }

    public static void error(String message, Exception error) {
        log(ApexSignalLevel.ERROR, message, null, error);
    }

    public static void fatal(String message, Exception error) {
        log(ApexSignalLevel.FATAL, message, null, error);
    }

    public static void log(
        ApexSignalLevel level,
        String message,
        Map<String, Object> eventContext
    ) {
        log(level, message, eventContext, null);
    }

    public static void log(
        ApexSignalLevel level,
        String message,
        Map<String, Object> eventContext,
        Exception error
    ) {
        Map<String, Object> mergedContext = sharedContext.deepClone();
        if (eventContext != null) {
            mergedContext.putAll(eventContext);
        }

        buffer.add(new ApexSignalEntry(
            level == null ? ApexSignalLevel.INFO : level,
            message,
            getCorrelationId(),
            mergedContext,
            error
        ));
    }

    public static Integer pendingCount() {
        return buffer.size();
    }

    public static void flush() {
        List<ApexSignalEntry> entries = buffer.drain();
        if (entries.isEmpty()) {
            return;
        }

        for (ApexSignalSink sink : sinks) {
            try {
                sink.write(entries);
            } catch (Exception error) {
                System.debug(
                    LoggingLevel.ERROR,
                    'APEX_SIGNAL sink failure: ' + error.getMessage()
                );
                if (!failOpen) {
                    throw new ApexSignalException(
                        'ApexSignal sink failed: ' + error.getMessage()
                    );
                }
            }
        }
    }

    @TestVisible
    private static void reset() {
        buffer = new ApexSignalBuffer();
        sinks = new List<ApexSignalSink>{ new ApexSignalDebugSink() };
        sharedContext = new Map<String, Object>();
        correlationId = null;
        failOpen = true;
    }

    private static String newIdentifier() {
        return EncodingUtil.convertToHex(Crypto.generateAesKey(128)).toLowerCase();
    }
}
