public class DexDatabase implements IDexDatabase {
    public SObject[] queryWithBinds(String query, Map<String, Object> binds, AccessLevel accessLevel) {
        return Database.queryWithBinds(query, binds, accessLevel);
    }

    public Integer countQueryWithBinds(
            String query,
            Map<String, Object> binds,
            System.AccessLevel accessLevel
    ) {
        return Database.countQueryWithBinds(
                query,
                binds,
                accessLevel
        );
    }

    public Database.SaveResult[] insertAll(SObject[] records, Database.DMLOptions dmlOptions, AccessLevel accessLevel) {
        return Database.insert(records, dmlOptions, accessLevel);
    }

    public Database.SaveResult[] updateAll(SObject[] records, Database.DMLOptions dmlOptions, AccessLevel accessLevel) {
        return Database.update(records, dmlOptions, accessLevel);
    }

    public Database.DeleteResult[] deleteAll(SObject[] records, Database.DMLOptions dmlOptions, AccessLevel accessLevel) {
        return Database.delete(records, dmlOptions.optAllOrNone, accessLevel);
    }

    public Database.DeleteResult[] deleteAll(Id[] recordIds, Database.DMLOptions dmlOptions, AccessLevel accessLevel) {
        return Database.delete(recordIds, dmlOptions.optAllOrNone);
    }

    public Database.UndeleteResult[] undeleteAll(SObject[] records, Database.DMLOptions dmlOptions, AccessLevel accessLevel) {
        return Database.undelete(records, dmlOptions.optAllOrNone, accessLevel);
    }

    public Database.UndeleteResult[] undeleteAll(
            Id[] recordIds,
            Database.DMLOptions dmlOptions,
            AccessLevel accessLevel
    ) {
        return Database.undelete(recordIds, dmlOptions.optAllOrNone, accessLevel);
    }

    public Database.EmptyRecycleBinResult[] emptyRecycleBin(Id[] recordIds) {
        return Database.emptyRecycleBin(recordIds);
    }

    public Database.EmptyRecycleBinResult[] emptyRecycleBin(SObject[] records) {
        return Database.emptyRecycleBin(records);
    }

    public Savepoint setSavepoint() {
        return Database.setSavepoint();
    }

    public void releaseSavepoint(Savepoint savePoint) {
        Database.releaseSavepoint(savePoint);
    }

    public void rollback(Savepoint savePoint) {
        Database.rollback(savePoint);
    }
}