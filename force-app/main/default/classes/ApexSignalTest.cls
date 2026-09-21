@IsTest
private class ApexSignalTest {
    private class RecordingSink implements ApexSignalSink {
        private List<ApexSignalEntry> received = new List<ApexSignalEntry>();

        public void write(List<ApexSignalEntry> entries) {
            received.addAll(entries);
        }
    }

    private class FailingSink implements ApexSignalSink {
        public void write(List<ApexSignalEntry> entries) {
            Integer impossible = 1 / 0;
        }
    }

    @IsTest
    static void buffersStructuredEntriesAndFlushesOnce() {
        ApexSignal.reset();
        ApexSignal.clearSinks();
        RecordingSink sink = new RecordingSink();
        ApexSignal.addSink(sink);
        ApexSignal.setCorrelationId('correlation-123');
        ApexSignal.context('operation', 'closeWon');

        ApexSignal.info('Started');
        ApexSignal.log(
            ApexSignalLevel.INFO,
            'Completed',
            new Map<String, Object>{ 'recordId' => '006000000000001' }
        );

        System.assertEquals(2, ApexSignal.pendingCount());

        ApexSignal.flush();

        System.assertEquals(0, ApexSignal.pendingCount());
        System.assertEquals(2, sink.received.size());
        System.assertEquals('correlation-123', sink.received[0].correlationId);
        System.assertEquals('closeWon', sink.received[1].context.get('operation'));
        System.assertEquals(
            '006000000000001',
            sink.received[1].context.get('recordId')
        );
    }

    @IsTest
    static void capturesExceptionDetails() {
        ApexSignal.reset();
        ApexSignal.clearSinks();
        RecordingSink sink = new RecordingSink();
        ApexSignal.addSink(sink);

        try {
            Integer impossible = 1 / 0;
        } catch (Exception error) {
            ApexSignal.error('Calculation failed', error);
        }
        ApexSignal.flush();

        System.assertEquals(1, sink.received.size());
        System.assertEquals(ApexSignalLevel.ERROR, sink.received[0].level);
        System.assertNotEquals(null, sink.received[0].exceptionType);
        System.assertNotEquals(null, sink.received[0].stackTrace);
    }

    @IsTest
    static void failOpenProtectsBusinessTransaction() {
        ApexSignal.reset();
        ApexSignal.clearSinks();
        ApexSignal.addSink(new FailingSink());
        ApexSignal.info('This entry cannot be delivered');

        Test.startTest();
        ApexSignal.flush();
        Test.stopTest();

        System.assertEquals(0, ApexSignal.pendingCount());
    }

    @IsTest
    static void failClosedSurfacesSinkFailure() {
        ApexSignal.reset();
        ApexSignal.clearSinks();
        ApexSignal.addSink(new FailingSink());
        ApexSignal.setFailOpen(false);
        ApexSignal.info('Strict delivery');

        try {
            ApexSignal.flush();
            System.assert(false, 'Expected ApexSignalException');
        } catch (ApexSignalException expected) {
            System.assert(expected.getMessage().contains('sink failed'));
        }
    }

    @IsTest
    static void generatesStableTransactionCorrelationId() {
        ApexSignal.reset();

        String first = ApexSignal.getCorrelationId();
        String second = ApexSignal.getCorrelationId();

        System.assertEquals(first, second);
        System.assertEquals(32, first.length());
    }
}
