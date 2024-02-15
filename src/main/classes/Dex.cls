public abstract class Dex {
    public static final SHARING_RULE DEFAULT_SHARING_RULE = SHARING_RULE.WITH_SHARING;
    public static final System.AccessLevel DEFAULT_ACCESS_LEVEL = System.AccessLevel.USER_MODE;

    // TODO: Add custom result type for queries
    // TODO: Add DML support
    // TODO: Combine dml statements where possible.
    //  Salesforce can support up to 10 SObjectTypes in a single statement
    // TODO: Add support for parent-child relationship inserts
    // TODO: add interface to allow mocking dml statements and responses

    // Database.SaveResult - insert, update
    // Database.UpsertResult - upsert
    // Database.DeleteResult - delete
    // Database.UndeleteResult - undelete
    // Database.EmptyRecycleBinResult - emptyRecyclingBin
    // Database.rollback - Database.SavePoint

    public enum SHARING_RULE {
        INHERITED_SHARING,
        WITH_SHARING,
        WITHOUT_SHARING
    }

    private final static Map<SHARING_RULE, IRepo> sharingRuleRepos =
            new Map<SHARING_RULE, IRepo>{
                    SHARING_RULE.INHERITED_SHARING => new InheritedSharingRepo(),
                    SHARING_RULE.WITHOUT_SHARING => new WithoutSharingRepo(),
                    SHARING_RULE.WITH_SHARING => new WithSharingRepo()
            };

    private static IRepo getRepo() {
        return sharingRuleRepos.get(DEFAULT_SHARING_RULE);
    }

    private static IRepo getRepo(SHARING_RULE sharingRule) {
        return sharingRuleRepos.get(sharingRule);
    }

    @TestVisible
    private static void setMock(IRepo mockRepo) {
        for(SHARING_RULE sharingRule : sharingRuleRepos.keySet()) {
            sharingRuleRepos.put(sharingRule, mockRepo);
        }
    }

    @TestVisible
    private static void setMock(IRepo mockRepo, SHARING_RULE sharingRule) {
        sharingRuleRepos.put(sharingRule, mockRepo);
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

    public static Object get(String query, Map<String, Object> binds, System.AccessLevel accessLevel) {
        return getRepo().get(query, binds, accessLevel);
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
        return getRepo(sharingRule).getAll(query);
    }

    public static Object[] getAll(
            String query,
            Map<String, Object> binds,
            System.AccessLevel accessLevel
    ) {
        return getRepo().getAll(query, binds, accessLevel);
    }

    public static void insertAll(SObject[] records) {
        getRepo().insertAll(records);
    }

    public static void updateAll(SObject[] records) {
        getRepo().updateAll(records);
    }

    public static void upsertAll(SObject[] records) {
        getRepo().upsertAll(records);
    }

    public static void softDeleteAll(SObject[] records) {
        getRepo().softDeleteAll(records);
    }

    public static void hardDeleteAll(SObject[] records) {
        getRepo().hardDeleteAll(records);
    }

    public static void undeleteAll(SObject[] records) {
        getRepo().undeleteAll(records);
    }

    private virtual class Repo implements IRepo {

        public Object get(
                String query
        ) {
            return Dex.queryResults(Database.query(query, DEFAULT_ACCESS_LEVEL));
        }

        public Object get(
                String query,
                Map<String, Object> binds
        ) {
            return Dex.queryResults(Database.queryWithBinds(query, binds, DEFAULT_ACCESS_LEVEL));
        }

        public Object get(
                String query,
                System.AccessLevel accessLevel
        ) {
            return Dex.queryResults(Database.query(query, accessLevel));
        }

        public Object get(
                String query,
                Map<String, Object> binds,
                System.AccessLevel accessLevel
        ) {
            Object[] results = Dex.queryResults(Database.queryWithBinds(query, binds, accessLevel));

            return results.isEmpty() ? null : results.get(0);
        }

        public Object[] getAll(
                String query
        ) {
            return Dex.queryResults(Database.query(query, Dex.DEFAULT_ACCESS_LEVEL));
        }

        public Object[] getAll(
                String query,
                Map<String, Object> binds
        ) {
            return Dex.queryResults(Database.queryWithBinds(query, binds, Dex.DEFAULT_ACCESS_LEVEL));
        }

        public Object[] getAll(
                String query,
                System.AccessLevel accessLevel
        ) {
            return Dex.queryResults(Database.query(query, accessLevel));
        }

        public Object[] getAll(
                String query,
                Map<String, Object> binds,
                System.AccessLevel accessLevel
        ) {
            return Dex.queryResults(Database.queryWithBinds(query, binds, accessLevel));
        }

        public void insertAll(SObject[] records) {
            records.sort();
            Database.insert(records);
        }

        public void updateAll(SObject[] records) {
            records.sort();
            Database.update(records);
        }

        public void upsertAll(SObject[] records) {
            records.sort();
            Database.upsert(records);
        }

        public void softDeleteAll(SObject[] records) {
            records.sort();
            Database.delete(records);
        }

        public void hardDeleteAll(SObject[] records) {
            this.softDeleteAll(records);
            Database.emptyRecycleBin(records);
        }

        public void undeleteAll(SObject[] records) {
            records.sort();
            Database.undelete(records);
        }

        private Map<Integer, SObject[]> chunkRecords(SObject[] records) {
            records.sort();

            Map<Integer, SObject[]> chunks = new Map<Integer, SObject[]>();
            SObjectType[] sObjectTypes = new SObjectType[]{};

            for(SObject record : records) {
                if(!sObjectTypes.contains(record.getSObjectType())) {
                    sObjectTypes.add(record.getSObjectType());
                }
            }

            if(sObjectTypes.size() <= 10) {
                chunks.put(0, records);
                return chunks;
            }

            // Create chunks of 10 SObjectTypes

            return chunks;

        }
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
    private with sharing class WithSharingRepo extends Repo { }

    @TestVisible
    private without sharing class WithoutSharingRepo extends Repo { }

    @TestVisible
    private inherited sharing class InheritedSharingRepo extends Repo { }

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
                System.AccessLevel accessLevel
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
                System.AccessLevel accessLevel
        );
        void insertAll(SObject[] records);
        void updateAll(SObject[] records);
        void upsertAll(SObject[] records);
        void softDeleteAll(SObject[] records);
        void hardDeleteAll(SObject[] records);
        void undeleteAll(SObject[] records);
    }


    public enum DmlOperation {
        OP_INSERT,
        OP_UPDATE,
        OP_UPSERT,
        OP_SOFT_DELETE,
        OP_HARD_DELETE,
        OP_UNDELETE
    }

    public class Multi {
        private Map<Dex.DmlOperation, SObject[]> operations =
                new Map<Dex.DmlOperation, SObject[]>();


        public void insertAll(SObject[] records) {
            this.addOperation(records, Dex.DmlOperation.OP_INSERT);
        }

        public void updateAll(SObject[] records) {
            this.addOperation(records, Dex.DmlOperation.OP_UPDATE);
        }

        public void upsertAll(SObject[] records) {
            this.addOperation(records, Dex.DmlOperation.OP_UPSERT);
        }

        public void softDeleteAll(SObject[] records) {
            this.addOperation(records, Dex.DmlOperation.OP_SOFT_DELETE);
        }

        public void hardDeleteAll(SObject[] records) {
            this.addOperation(records, Dex.DmlOperation.OP_HARD_DELETE);
        }

        public void undeleteAll(SObject[] records) {
            this.addOperation(records, Dex.DmlOperation.OP_UNDELETE);
        }

        public void execute() {
            Dex.DmlOperation[] operations = Dex.DmlOperation.values();

            for(Dex.DmlOperation operation : operations) {
                SObject[] records = this.operations.get(operation);

                if(records == null) {
                    continue;
                }

                switch on operation {
                    when OP_INSERT {
                        Dex.insertAll(records);
                    }
                    when OP_UPDATE {
                        Dex.updateAll(records);
                    }
                    when OP_UPSERT {
                        Dex.upsertAll(records);
                    }
                    when OP_SOFT_DELETE {
                        Dex.softDeleteAll(records);
                    }
                    when OP_HARD_DELETE {
                        Dex.hardDeleteAll(records);
                    }
                    when OP_UNDELETE {
                        Dex.undeleteAll(records);
                    }
                }
            }
        }

        private void addOperation(SObject[] records, Dex.DmlOperation operation) {
            if(!operations.containsKey(operation)) {
                operations.put(operation, new SObject[]{});
            }

            operations.get(operation).addAll(records);
        }
    }

}