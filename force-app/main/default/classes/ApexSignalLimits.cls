public class ApexSignalLimits {
    private ApexSignalLimits() {
    }

    public static Map<String, Object> snapshot() {
        return new Map<String, Object>{
            'cpuTime' => Limits.getCpuTime(),
            'cpuLimit' => Limits.getLimitCpuTime(),
            'dmlRows' => Limits.getDmlRows(),
            'dmlRowsLimit' => Limits.getLimitDmlRows(),
            'dmlStatements' => Limits.getDmlStatements(),
            'dmlStatementsLimit' => Limits.getLimitDmlStatements(),
            'queries' => Limits.getQueries(),
            'queriesLimit' => Limits.getLimitQueries(),
            'queryRows' => Limits.getQueryRows(),
            'queryRowsLimit' => Limits.getLimitQueryRows(),
            'heapSize' => Limits.getHeapSize(),
            'heapSizeLimit' => Limits.getLimitHeapSize()
        };
    }
}
