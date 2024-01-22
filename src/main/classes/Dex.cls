public abstract class Dex {
    public static final SHARING_RULE DEFAULT_SHARING_RULE = SHARING_RULE.INHERITED_SHARING;
    public static final System.AccessLevel DEFAULT_ACCESS_LEVEL = System.AccessLevel.SYSTEM_MODE;

    public enum SHARING_RULE {
        INHERITED_SHARING,
        WITH_SHARING,
        WITHOUT_SHARING
    }

    private final static Map<SHARING_RULE, ISharingRepo> sharingRuleRepos =
            new Map<SHARING_RULE, ISharingRepo>{
                    SHARING_RULE.INHERITED_SHARING => new InheritedSharingRepo(),
                    SHARING_RULE.WITHOUT_SHARING => new WithoutSharingRepo(),
                    SHARING_RULE.WITH_SHARING => new WithSharingRepo()
            };

    private static IRepo instance;

    private static IRepo getRepo() {
        if (instance == null) {
            instance = new Repo();
        }

        return instance;
    }

    @TestVisible
    private static void setMock(IRepo mockRepo) {
        instance = mockRepo;
    }

    public static Object get(String query) {
        return getRepo().get(query, new Map<String, Object>());
    }

    public static Object get(String query, Map<String, Object> binds) {
        return getRepo().get(query, binds, DEFAULT_ACCESS_LEVEL);
    }

    public static Object get(String query, System.AccessLevel accessLevel) {
        return getRepo().get(query, accessLevel);
    }

    public static Object get(String query, SHARING_RULE sharingRule) {
        return getRepo().get(query, sharingRule);
    }

    public static Object get(String query, Map<String, Object> binds, System.AccessLevel accessLevel) {
        return getRepo().get(query, binds, accessLevel, DEFAULT_SHARING_RULE);
    }

    public static Object get(String query, Map<String, Object> binds, SHARING_RULE sharingRule) {
        return getRepo().get(query, binds, sharingRule);
    }

    public static Object get(
            String query,
            Map<String, Object> binds,
            System.AccessLevel accessLevel,
            SHARING_RULE sharingRule
    ) {
        Object[] results = getRepo().getAll(query, binds, accessLevel, sharingRule);

        return results.isEmpty() ? null : results.get(0);
    }

    public static Object[] getAll(
            String query
    ) {
        return getRepo().getAll(query);
    }

    public static Object[] getAll(
            String query,
            Map<String, Object> binds
    ) {
        return getRepo().getAll(query, binds);
    }

    public static Object[] getAll(String query, System.AccessLevel accessLevel) {
        return getRepo().getAll(query, accessLevel);
    }

    public static Object[] getAll(String query, SHARING_RULE sharingRule) {
        return getRepo().getAll(query, sharingRule);
    }

    public static Object[] getAll(
            String query,
            Map<String, Object> binds,
            System.AccessLevel accessLevel
    ) {
        return getRepo().getAll(query, binds, accessLevel);
    }

    public static Object[] getAll(
            String query,
            Map<String, Object> binds,
            SHARING_RULE sharingRule
    ) {
        return getRepo().getAll(query, binds, sharingRule);
    }

    public static Object[] getAll(
            String query,
            Map<String, Object> binds,
            System.AccessLevel accessLevel,
            SHARING_RULE sharingRule
    ) {
        return getRepo().getAll(
                query,
                binds,
                accessLevel,
                sharingRule
        );
    }

    public static Database.QueryLocator getQueryLocator(
            String query
    ) {
        return getRepo().getQueryLocator(query);
    }

    public static Database.QueryLocator getQueryLocator(
            String query,
            Map<String, Object> binds
    ) {
        return getRepo().getQueryLocator(query, binds);
    }

    public static Database.QueryLocator getQueryLocator(
            String query,
            SHARING_RULE sharingRule
    ) {
        return getRepo().getQueryLocator(query, sharingRule);
    }

    public static Database.QueryLocator getQueryLocator(
            String query,
            System.AccessLevel accessLevel
    ) {
        return getRepo().getQueryLocator(query, accessLevel);
    }


    public static Database.QueryLocator getQueryLocator(
            String query,
            Map<String, Object> binds,
            System.AccessLevel accessLevel
    ) {
        return getRepo().getQueryLocator(query, binds, accessLevel);
    }

    public static Database.QueryLocator getQueryLocator(
            String query,
            Map<String, Object> binds,
            SHARING_RULE sharingRule
    ) {
        return getRepo().getQueryLocator(query, binds, sharingRule);
    }

    public static Database.QueryLocator getQueryLocator(
            String query,
            Map<String, Object> binds,
            System.AccessLevel accessLevel,
            SHARING_RULE sharingRule
    ) {
        return getRepo().getQueryLocator(
                query,
                binds,
                accessLevel,
                sharingRule
        );
    }

    private class Repo implements IRepo {
        public Object get(String query) {
            return this.get(query, new Map<String, Object>());
        }

        public Object get(String query, Map<String, Object> binds) {
            return this.get(query, binds, Dex.DEFAULT_ACCESS_LEVEL);
        }

        public Object get(
                String query,
                Map<String, Object> binds,
                System.AccessLevel accessLevel
        ) {
            return this.get(query, binds, accessLevel, Dex.DEFAULT_SHARING_RULE);
        }

        public Object get(
                String query,
                Map<String, Object> binds,
                Dex.SHARING_RULE sharingRule
        ) {
            return this.get(query, binds, Dex.DEFAULT_ACCESS_LEVEL, sharingRule);
        }

        public Object get(
                String query,
                Dex.SHARING_RULE sharingRule
        ) {
            return this.get(
                    query,
                    new Map<String, Object>(),
                    sharingRule
            );
        }

        public Object get(
                String query,
                System.AccessLevel accessLevel
        ) {
            return this.get(
                    query,
                    new Map<String, Object>(),
                    accessLevel
            );
        }

        public Object get(
                String query,
                Map<String, Object> binds,
                System.AccessLevel accessLevel,
                Dex.SHARING_RULE sharingRule
        ) {
            Object[] results = this.getAll(query, binds, accessLevel, sharingRule);

            return results.isEmpty() ? null : results.get(0);
        }

        public Object[] getAll(
                String query
        ) {
            return this.getAll(query, new Map<String, Object>());
        }

        public Object[] getAll(
                String query,
                Map<String, Object> binds
        ) {
            return this.getAll(query, binds, Dex.DEFAULT_ACCESS_LEVEL);
        }

        public Object[] getAll(
                String query,
                Dex.SHARING_RULE sharingRule
        ) {
            return this.getAll(
                    query,
                    new Map<String, Object>(),
                    sharingRule
            );
        }

        public Object[] getAll(
                String query,
                System.AccessLevel accessLevel
        ) {
            return this.getAll(
                    query,
                    new Map<String, Object>(),
                    accessLevel
            );
        }

        public Object[] getAll(
                String query,
                Map<String, Object> binds,
                System.AccessLevel accessLevel
        ) {
            return this.getAll(query, binds, accessLevel, Dex.DEFAULT_SHARING_RULE);
        }

        public Object[] getAll(
                String query,
                Map<String, Object> binds,
                Dex.SHARING_RULE sharingRule
        ) {
            return this.getAll(query, binds, Dex.DEFAULT_ACCESS_LEVEL, sharingRule);
        }

        public Object[] getAll(
                String query,
                Map<String, Object> binds,
                System.AccessLevel accessLevel,
                Dex.SHARING_RULE sharingRule
        ) {
            return Dex.queryResults(
                    Dex.getSharingDatabase(sharingRule).getAll(
                            query,
                            binds,
                            accessLevel
                    ));
        }

        public Database.QueryLocator getQueryLocator(
                String query
        ) {
            return this.getQueryLocator(query, new Map<String, Object>());
        }

        public Database.QueryLocator getQueryLocator(
                String query,
                Map<String, Object> binds
        ) {
            return this.getQueryLocator(query, binds, Dex.DEFAULT_ACCESS_LEVEL);
        }

        public Database.QueryLocator getQueryLocator(
                String query,
                SHARING_RULE sharingRule
        ) {
            return this.getQueryLocator(query, new Map<String, Object>(), sharingRule);
        }

        public Database.QueryLocator getQueryLocator(
                String query,
                System.AccessLevel accessLevel
        ) {
            return this.getQueryLocator(query, new Map<String, Object>(), accessLevel);
        }


        public Database.QueryLocator getQueryLocator(
                String query,
                Map<String, Object> binds,
                System.AccessLevel accessLevel
        ) {
            return this.getQueryLocator(
                    query,
                    binds,
                    accessLevel,
                    Dex.DEFAULT_SHARING_RULE
            );
        }

        public Database.QueryLocator getQueryLocator(
                String query,
                Map<String, Object> binds,
                Dex.SHARING_RULE sharingRule
        ) {
            return this.getQueryLocator(
                    query,
                    binds,
                    Dex.DEFAULT_ACCESS_LEVEL,
                    sharingRule
            );
        }

        public Database.QueryLocator getQueryLocator(
                String query,
                Map<String, Object> binds,
                System.AccessLevel accessLevel,
                Dex.SHARING_RULE sharingRule
        ) {
            return Dex.getSharingDatabase(sharingRule).getQueryLocator(
                    query,
                    binds,
                    accessLevel
            );
        }

        public Dex.Results insertAll(SObject[] records) {
            maybeSortToPreventChunkingError(records);
            return getRepoResults(
                    Database.insert(records)
            );
        }

        public Dex.Results updateAll(SObject[] records) {
            maybeSortToPreventChunkingError(records);
            return getRepoResults(
                    Database.update(records)
            );
        }

        public Dex.Results upsertAll(SObject[] records) {
            maybeSortToPreventChunkingError(records);
            return getRepoResults(
                    Database.update(records)
            );
        }

        public Dex.Results softDeleteAll(SObject[] records) {
            maybeSortToPreventChunkingError(records);
            return getRepoResults(
                    Database.update(records)
            );
        }

        public Dex.Results undeleteAll(SObject[] records) {
            maybeSortToPreventChunkingError(records);
            return getRepoResults(
                    Database.update(records)
            );
        }

        public Dex.Results hardDeleteAll(SObject[] records) {
            maybeSortToPreventChunkingError(records);
            Dex.Results results = getRepoResults(
                    Database.delete(records)
            );
            Database.emptyRecycleBin(records);
            return results;
        }

        public Dex.Results insertAllUnsafe(SObject[] records) {
            maybeSortToPreventChunkingError(records);
            return getRepoResults(
                    Database.insert(records, false)
            );
        }

        public Dex.Results updateAllUnsafe(SObject[] records) {
            maybeSortToPreventChunkingError(records);
            return getRepoResults(
                    Database.update(records, false)
            );
        }

        public Dex.Results upsertAllUnsafe(SObject[] records) {
            maybeSortToPreventChunkingError(records);
            return getRepoResults(
                    Database.upsert(records, false)
            );
        }

        public Dex.Results softDeleteAllUnsafe(SObject[] records) {
            maybeSortToPreventChunkingError(records);
            return getRepoResults(
                    Database.delete(records, false)
            );
        }

        public Dex.Results undeleteAllUnsafe(SObject[] records) {
            maybeSortToPreventChunkingError(records);
            return getRepoResults(
                    Database.undelete(records, false)
            );
        }

        public Dex.Results hardDeleteAllUnsafe(SObject[] records) {
            maybeSortToPreventChunkingError(records);
            Dex.Results results = getRepoResults(
                    Database.delete(records, false)
            );

            List<Id> deletedRecordIds = new List<Id>();
            for(Dex.Result result : results.success) {
                deletedRecordIds.add(result.getId());
            }

            Database.emptyRecycleBin(deletedRecordIds);

            return results;
        }

        /**
        * @description prevents a chunking error that can occur if SObject types are in the list out of order.
        * no need to sort if the list size is below the limit.
        *
        * Taken from https://github.com/jamessimone/apex-dml-mocking/blob/main/force-app/dml/DML.cls
        *
        * @param records SObjects to be submitted for a DML operation
        */
        private void maybeSortToPreventChunkingError(SObject[] records) {
            final Integer MAX_DML_CHUNKING = 10;
            if(records.size() >= MAX_DML_CHUNKING) {
                records.sort();
            }
        }

        private Dex.Results getRepoResults(Database.SaveResult[] databaseResults) {
            Dex.Result[] results = new List<Dex.Result>();
            for(Database.SaveResult databaseResult : databaseResults) {
                results.add(new Dex.Result(databaseResult));
            }

            return new Dex.Results(results);
        }

        private Dex.Results getRepoResults(Database.UpsertResult[] databaseResults) {
            Dex.Result[] results = new List<Dex.Result>();
            for(Database.UpsertResult databaseResult : databaseResults) {
                results.add(new Dex.Result(databaseResult));
            }

            return new Dex.Results(results);
        }

        private Dex.Results getRepoResults(
                Database.DeleteResult[] databaseResults
        ) {
            Dex.Result[] results = new List<Dex.Result>();
            for(Database.DeleteResult databaseResult : databaseResults) {
                results.add(new Dex.Result(databaseResult));
            }

            return new Dex.Results(results);
        }

        private Dex.Results getRepoResults(
                Database.UndeleteResult[] databaseResults
        ) {
            Dex.Result[] results = new List<Dex.Result>();
            for(Database.UndeleteResult databaseResult : databaseResults) {
                results.add(new Dex.Result(databaseResult));
            }

            return new Dex.Results(results);
        }

        private Dex.Results getRepoResults(
                Database.EmptyRecycleBinResult[] databaseResults
        ) {
            Dex.Result[] results = new List<Dex.Result>();
            for(Database.EmptyRecycleBinResult databaseResult : databaseResults) {
                results.add(new Dex.Result(databaseResult));
            }

            return new Dex.Results(results);
        }

        private Dex.Results getRepoResults(
                Database.MergeResult[] databaseResults
        ) {
            Dex.Result[] results = new List<Dex.Result>();
            for(Database.MergeResult databaseResult : databaseResults) {
                results.add(new Dex.Result(databaseResult));
            }

            return new Dex.Results(results);
        }
    }

    @TestVisible
    private static ISharingRepo getSharingDatabase(SHARING_RULE sharingRule) {
        return sharingRuleRepos.get(sharingRule);
    }

    private static Object[] queryResults(SObject[] systemResults) {
        if (systemResults.getSObjectType() != Schema.AggregateResult.SObjectType) {
            return systemResults;
        }

        AggregateResult[] aggregateResults = new List<AggregateResult>();

        for (Schema.AggregateResult systemResult : (Schema.AggregateResult[]) systemResults) {
            aggregateResults.add(new AggregateResult(systemResult));
        }

        return aggregateResults;
    }

    @TestVisible
    private interface ISharingRepo {
        SObject[] getAll(String query, Map<String, Object> binds, System.AccessLevel accessLevel);
        Database.QueryLocator getQueryLocator(String query, Map<String, Object> binds, System.AccessLevel accessLevel);
    }

    private virtual class SharingRepo implements ISharingRepo {
        public SObject[] getAll(String query, Map<String, Object> binds, System.AccessLevel accessLevel) {
            return System.Database.queryWithBinds(query, binds, accessLevel);
        }

        public Database.QueryLocator getQueryLocator(String query, Map<String, Object> binds, System.AccessLevel accessLevel) {
            return System.Database.getQueryLocatorWithBinds(query, binds, accessLevel);
        }
    }

    @TestVisible
    private with sharing class WithSharingRepo extends SharingRepo { }

    @TestVisible
    private without sharing class WithoutSharingRepo extends SharingRepo { }

    @TestVisible
    private inherited sharing class InheritedSharingRepo extends SharingRepo { }

    public class AggregateResult {
        public final Map<String, Object> data;

        @TestVisible
        private AggregateResult() {
            this.data = new Map<String, Object>();
        }

        public AggregateResult(Schema.AggregateResult aggregateResult) {
            this.data = aggregateResult.getPopulatedFieldsAsMap();
        }

        public Object get(String alias) {
            return this.data.get(alias);
        }

        @TestVisible
        private AggregateResult put(String alias, Object value) {
            this.data.put(alias, value);
            return this;
        }
    }

    public interface IRepo {
        Object get(
                String query
        );
        Object get(
                String query,
                Map<String, Object> binds
        );
        Object get(
                String query,
                Map<String, Object> binds,
                System.AccessLevel accessLevel
        );
        Object get(
                String query,
                Map<String, Object> binds,
                Dex.SHARING_RULE sharingRule
        );
        Object get(
                String query,
                System.AccessLevel accessLevel
        );
        Object get(
                String query,
                Dex.SHARING_RULE sharingRule
        );
        Object get(
                String query,
                Map<String, Object> binds,
                System.AccessLevel accessLevel,
                Dex.SHARING_RULE sharingRule
        );
        Object[] getAll(
                String query
        );
        Object[] getAll(
                String query,
                Map<String, Object> binds
        );
        Object[] getAll(
                String query,
                Map<String, Object> binds,
                System.AccessLevel accessLevel
        );
        Object[] getAll(
                String query,
                Map<String, Object> binds,
                Dex.SHARING_RULE sharingRule
        );
        Object[] getAll(
                String query,
                System.AccessLevel accessLevel
        );
        Object[] getAll(
                String query,
                Dex.SHARING_RULE sharingRule
        );
        Object[] getAll(
                String query,
                Map<String, Object> binds,
                System.AccessLevel accessLevel,
                Dex.SHARING_RULE sharingRule
        );
        Database.QueryLocator getQueryLocator(
                String query
        );
        Database.QueryLocator getQueryLocator(
                String query,
                Map<String, Object> binds
        );
        Database.QueryLocator getQueryLocator(
                String query,
                Map<String, Object> binds,
                System.AccessLevel accessLevel
        );
        Database.QueryLocator getQueryLocator(
                String query,
                Map<String, Object> binds,
                Dex.SHARING_RULE sharingRule
        );
        Database.QueryLocator getQueryLocator(
                String query,
                System.AccessLevel accessLevel
        );
        Database.QueryLocator getQueryLocator(
                String query,
                Dex.SHARING_RULE sharingRule
        );
        Database.QueryLocator getQueryLocator(
                String query,
                Map<String, Object> binds,
                System.AccessLevel accessLevel,
                Dex.SHARING_RULE sharingRule
        );
        Dex.Results insertAll(SObject[] records);
        Dex.Results updateAll(SObject[] records);
        Dex.Results upsertAll(SObject[] records);
        Dex.Results softDeleteAll(SObject[] records);
        Dex.Results undeleteAll(SObject[] records);
        Dex.Results hardDeleteAll(SObject[] records);
        Dex.Results insertAllUnsafe(SObject[] records);
        Dex.Results updateAllUnsafe(SObject[] records);
        Dex.Results upsertAllUnsafe(SObject[] records);
        Dex.Results softDeleteAllUnsafe(SObject[] records);
        Dex.Results undeleteAllUnsafe(SObject[] records);
        Dex.Results hardDeleteAllUnsafe(SObject[] records);

    }

    public class Error {
        private System.StatusCode statusCode;
        private String[] fields;
        private String message;

        public Error() {}

        public Error(Database.Error databaseError) {
            this.statusCode = databaseError.getStatusCode();
            this.fields = databaseError.getFields();
            this.message = databaseError.getMessage();
        }

        public String getMessage() {
            return this.message;
        }

        public System.StatusCode getStatusCode() {
            return this.statusCode;
        }

        public String[] getFields() {
            return this.fields;
        }

        @TestVisible
        public Error setMessage(String message) {
            this.message = message;
            return this;
        }

        @TestVisible
        public Error setStatusCode(System.StatusCode statusCode) {
            this.statusCode = statusCode;
            return this;
        }

        @TestVisible
        public Error setFields(String[] fields) {
            this.fields = fields;
            return this;
        }
    }

    public class Results {
        public Result[] success {get; private set;}
        public Result[] error {get; private set;}

        public Results(Result[] results) {
            this.success = new List<Result>();
            this.error = new List<Result>();

            for(Result result : results) {
                Result[] resultType = result.isSuccess() ? this.success: this.error;
                resultType.add(result);
            }
        }

        public Boolean hasErrors() {
            return !this.error.isEmpty();
        }
    }

    public class Result {
        private Id recordId;
        private String operationType;
        private Error[] errors = new List<Error>();

        @TestVisible
        private Result() { }

        public Result(Database.SaveResult result) {
            this.recordId = result.getId();

            if(result.isSuccess()) {
                return;
            }

            for(Database.Error databaseError : result.getErrors()) {
                this.addError(new Error(databaseError));
            }
        }

        public Result(Database.UpsertResult result) {
            this.recordId = result.getId();

            if(result.isSuccess()) {
                return;
            }

            for(Database.Error databaseError : result.getErrors()) {
                this.addError(new Error(databaseError));
            }
        }

        public Result(Database.DeleteResult result) {
            this.recordId = result.getId();

            if(result.isSuccess()) {
                return;
            }

            for(Database.Error databaseError : result.getErrors()) {
                this.addError(new Error(databaseError));
            }
        }

        public Result(Database.UndeleteResult result) {
            this.recordId = result.getId();

            if(result.isSuccess()) {
                return;
            }

            for(Database.Error databaseError : result.getErrors()) {
                this.addError(new Error(databaseError));
            }
        }

        public Result(Database.EmptyRecycleBinResult result) {
            this.recordId = result.getId();

            if(result.isSuccess()) {
                return;
            }

            for(Database.Error databaseError : result.getErrors()) {
                this.addError(new Error(databaseError));
            }
        }

        public Result(Database.MergeResult result) {
            this.recordId = result.getId();

            if(result.isSuccess()) {
                return;
            }

            for(Database.Error databaseError : result.getErrors()) {
                this.addError(new Error(databaseError));
            }
        }

        public Id getId() {
            return this.recordId;
        }

        public Error[] getErrors() {
            return this.errors;
        }

        public Boolean isSuccess() {
            return this.errors.isEmpty();
        }

        public Result setRecordId(Id recordId) {
            this.recordId = recordId;
            return this;
        }

        @TestVisible
        public Result addError(Error error) {
            this.errors.add(error);
            return this;
        }

        @TestVisible
        public Result addErrors(Error[] errors) {
            this.errors.addAll(errors);
            return this;
        }
    }

    // Inserts
    // Updates
    // Upserts
    // Soft Deletes
    // Hard Deletes
    // Restores

    public enum OperationType {
        REPO_INSERT,
        REPO_UPDATE,
        REPO_UPSERT,
        REPO_SOFT_DELETE,
        REPO_HARD_DELETE,
        REPO_RESTORE
    }

    private static Map<SObjectType, SObject[]> groupRecordsBySObjectType(SObject[] records) {
        records.sort();
        Map<SObjectType, SObject[]> recordsBySObjectType = new Map<SObjectType, SObject[]>();
        for (SObject record : records) {
            SObjectType sObjectType = record.getSObjectType();
            if (!recordsBySObjectType.containsKey(sObjectType)) {
                recordsBySObjectType.put(sObjectType, new List<SObject>());
            }
            recordsBySObjectType.get(sObjectType).add(record);
        }

        return recordsBySObjectType;
    }

    private interface IOperation {
        OperationType getType();
        SObject[] getRecords();
        System.AccessLevel getAccessLevel();
        Boolean isSafe();
    }

    private class Operation implements IOperation {
        private OperationType type;
        private System.AccessLevel accessLevel;
        private Boolean allOrNone;
        private SObject[] records;

        public Operation(
                OperationType type,
                System.AccessLevel accessLevel,
                Boolean allOrNone,
                SObject[] records
        ) {
            this.type = type;
            this.accessLevel = accessLevel;
            this.allOrNone = allOrNone;
            this.records = records;
        }

        public OperationType getType() {
            return this.type;
        }

        public SObject[] getRecords() {
            return this.records;
        }

        public System.AccessLevel getAccessLevel() {
            return this.accessLevel;
        }

        public Boolean isSafe() {
            return this.allOrNone;
        }
    }

    private class UpsertOperation implements IOperation {
        private Operation op;
        private SObjectField externalIdField;

        public UpsertOperation(Operation op, SObjectField externalIdField) {
            this.op = op;
            this.externalIdField = externalIdField;
        }

        public OperationType getType() {
            return this.op.getType();
        }

        public SObject[] getRecords() {
            return this.op.getRecords();
        }

        public System.AccessLevel getAccessLevel() {
            return this.op.getAccessLevel();
        }

        public Boolean isSafe() {
            return this.op.isSafe();
        }
    }

    public class Multi {
        List<SObjectType> hiearchy;
        Map<SObjectType, IOperation[]> operationsBySObjectType;

        public Multi(SObjectType[] hiearchy) {
            this.hiearchy = hiearchy;
        }

        public void insertAll(SObject[] records) {
            IOperation op = new Operation(OperationType.REPO_INSERT, Dex.DEFAULT_ACCESS_LEVEL, true, records);
            this.addOperation(op);
        }

        public void insertAllUnsafe(SObject[] records) {
            IOperation op = new Operation(OperationType.REPO_INSERT, Dex.DEFAULT_ACCESS_LEVEL, false, records);
            this.addOperation(op);
        }

        private void addOperation(
                IOperation operation
        ) {
            Map<SObjectType, SObject[]> recordsBySObjectType = groupRecordsBySObjectType(operation.getRecords());
            if(recordsBySObjectType.keySet().size() > 1) {
                throw new MultiSObjectTypeException('One SObjectType per operation is allowed');
            }

            SObjectType sObjType = operation.getRecords().getSObjectType();
            if(!this.operationsBySObjectType.keySet().contains(sObjType)) {
                this.operationsBySObjectType.put(sObjType, new List<IOperation>());
            }

            this.operationsBySObjectType.get(sObjType).add(operation);
        }
    }

    public class MultiSObjectTypeException extends Exception {}

    public static Results insertAll(SObject[] records) {
        return getRepo().insertAll(records);
    }

    public static Results updateAll(SObject[] records) {
        return getRepo().updateAll(records);
    }

    public static Results upsertAll(SObject[] records) {
        return getRepo().upsertAll(records);
    }

    public static Results softDeleteAll(SObject[] records) {
        return getRepo().softDeleteAll(records);
    }

    public static Results hardDeleteAll(SObject[] records) {
        return getRepo().hardDeleteAll(records);
    }

    public static Results insertAllUnsafe(SObject[] records) {
        return getRepo().insertAllUnsafe(records);
    }

    public static Results updateAllUnsafe(SObject[] records) {
        return getRepo().updateAllUnsafe(records);
    }

    public static Results upsertAllUnsafe(SObject[] records) {
        return getRepo().upsertAllUnsafe(records);
    }

    public static Results softDeleteAllUnsafe(SObject[] records) {
        return getRepo().softDeleteAllUnsafe(records);
    }

    public static Results hardDeleteAllUnsafe(SObject[] records) {
        return getRepo().hardDeleteAllUnsafe(records);
    }


}