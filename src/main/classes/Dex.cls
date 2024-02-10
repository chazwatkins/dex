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

    }

}