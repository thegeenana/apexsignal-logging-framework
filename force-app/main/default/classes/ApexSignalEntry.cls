public class ApexSignalEntry {
    public String id { get; private set; }
    public Datetime occurredAt { get; private set; }
    public ApexSignalLevel level { get; private set; }
    public String message { get; private set; }
    public String correlationId { get; private set; }
    public String exceptionType { get; private set; }
    public String exceptionMessage { get; private set; }
    public String stackTrace { get; private set; }
    public Map<String, Object> context { get; private set; }
    public Map<String, Object> limits { get; private set; }

    public ApexSignalEntry(
        ApexSignalLevel level,
        String message,
        String correlationId,
        Map<String, Object> context,
        Exception error
    ) {
        this.id = newIdentifier();
        this.occurredAt = Datetime.now();
        this.level = level;
        this.message = message;
        this.correlationId = correlationId;
        this.context = context == null
            ? new Map<String, Object>()
            : context.deepClone();
        this.limits = ApexSignalLimits.snapshot();

        if (error != null) {
            this.exceptionType = error.getTypeName();
            this.exceptionMessage = error.getMessage();
            this.stackTrace = error.getStackTraceString();
        }
    }

    public String toJson() {
        return JSON.serialize(this);
    }

    private static String newIdentifier() {
        return EncodingUtil.convertToHex(Crypto.generateAesKey(128)).toLowerCase();
    }
}
