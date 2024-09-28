public interface IDexDatabase {
    SObject[] queryWithBinds(
            String query,
            Map<String, Object> binds,
            System.AccessLevel accessLevel
    );
    Integer countQueryWithBinds(
            String query,
            Map<String, Object> binds,
            System.AccessLevel accessLevel
    );
    Database.SaveResult[] insertAll(
            SObject[] records,
            Database.DMLOptions dmlOptions,
            System.AccessLevel accessLevel
    );
    Database.SaveResult[] updateAll(
            SObject[] records,
            Database.DMLOptions dmlOptions,
            System.AccessLevel accessLevel
    );
    Database.DeleteResult[] deleteAll(
            SObject[] records,
            Database.DMLOptions dmlOptions,
            System.AccessLevel accessLevel
    );
    Database.DeleteResult[] deleteAll(
            Id[] recordIds,
            Database.DMLOptions dmlOptions,
            System.AccessLevel accessLevel
    );
    Database.UndeleteResult[] undeleteAll(
            SObject[] records,
            Database.DMLOptions dmlOptions,
            System.AccessLevel accessLevel
    );
    Database.UndeleteResult[] undeleteAll(
            Id[] recordIds,
            Database.DMLOptions dmlOptions,
            System.AccessLevel accessLevel
    );
    Database.EmptyRecycleBinResult[] emptyRecycleBin(
            Id[] recordIds
    );
    Database.EmptyRecycleBinResult[] emptyRecycleBin(
            SObject[] records
    );

    System.Savepoint setSavepoint();
    void releaseSavepoint(System.Savepoint savePoint);
    void rollback(System.Savepoint savePoint);
}