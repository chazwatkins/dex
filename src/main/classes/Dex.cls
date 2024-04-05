public abstract class Dex {
	public static final SHARING_RULE DEFAULT_SHARING_RULE = SHARING_RULE.WITH_SHARING;
	public static final System.AccessLevel DEFAULT_ACCESS_LEVEL = System.AccessLevel.USER_MODE;

	// GOALS:
	// 1. Provide a way to stub all Database crud ops for faster tests
	// 2. Ability to control which class level sharing rule is used for all crud ops - DONE
	// 3. All CRUD ops use the strictest security settings by default.  Devs must
	// decide to elevate when needed.  Apex by default runs in System Mode and tells - DONE
	// devs to restrict when needed.
	// 4. Consolidate DML statements as much as possible to avoid running over limits
	// 5. Add support for a query builder to avoid long string concatenation

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

	private final static Map<SHARING_RULE, System.Type> REPOS_BY_SHARING_RULES = new Map<SHARING_RULE, System.Type>{
		SHARING_RULE.INHERITED_SHARING => InheritedSharingRepo.class,
		SHARING_RULE.WITHOUT_SHARING => WithoutSharingRepo.class,
		SHARING_RULE.WITH_SHARING => WithSharingRepo.class
	};

	private static final Map<SHARING_RULE, IRepository> SHARING_RULE_REPOS = new Map<SHARING_RULE, IRepository>();

	private static IRepository mockInstance;

	private static IRepository getRepo(SHARING_RULE sharingRule) {
		if (mockInstance != null) {
			return mockInstance;
		}

		if (!SHARING_RULE_REPOS.containsKey(sharingRule)) {
			SHARING_RULE_REPOS.put(
				sharingRule,
				(Dex.IRepository) REPOS_BY_SHARING_RULES.get(sharingRule).newInstance()
			);
		}

		return SHARING_RULE_REPOS.get(sharingRule);
	}

	@TestVisible
	private static void setMock(IRepository mockRepo) {
		mockInstance = mockRepo;
	}

	public static SObject one(String query) {
		Dex.QueryOptions options = new Dex.QueryOptions();
		return getRepo(options.sharingRule).one(query, options);
	}

	public static SObject one(String query, Dex.QueryOptions options) {
		return getRepo(options.sharingRule).one(query, options);
	}

	public static Integer count(String query) {
		Dex.QueryOptions options = new Dex.QueryOptions();
		return getRepo(options.sharingRule).count(query, options);
	}

	public static Integer count(String query, Dex.QueryOptions options) {
		return getRepo(options.sharingRule).count(query, options);
	}

	public static SObject[] all(String query) {
		Dex.QueryOptions options = new Dex.QueryOptions();
		return getRepo(options.sharingRule).all(query, options);
	}

	public static SObject[] all(String query, Dex.QueryOptions options) {
		return getRepo(options.sharingRule).all(query, options);
	}

	public static Dex.AggregateResult[] aggregate(String query) {
		Dex.QueryOptions options = new Dex.QueryOptions();
		return getRepo(options.sharingRule).aggregate(query, options);
	}

	public static Dex.AggregateResult[] aggregate(String query, Dex.QueryOptions options) {
		return getRepo(options.sharingRule).aggregate(query, options);
	}

	public static void insertAll(SObject[] records) {
		Dex.DmlOptions options = new Dex.DmlOptions();
		getRepo(options.sharingRule).insertAll(records, options);
	}

	public static void insertAll(SObject[] records, Dex.DmlOptions options) {
		getRepo(options.sharingRule).insertAll(records, options);
	}

	public static void updateAll(SObject[] records) {
		Dex.DmlOptions options = new Dex.DmlOptions();
		getRepo(options.sharingRule).updateAll(records, options);
	}

	public static void updateAll(SObject[] records, Dex.DmlOptions options) {
		getRepo(options.sharingRule).updateAll(records, options);
	}

	public static void upsertAll(SObject[] records) {
		Dex.DmlOptions options = new Dex.DmlOptions();
		getRepo(options.sharingRule).upsertAll(records, options);
	}

	public static void upsertAll(SObject[] records, Dex.DmlOptions options) {
		getRepo(options.sharingRule).upsertAll(records, options);
	}

	public static void softDeleteAll(SObject[] records) {
		Dex.DmlOptions options = new Dex.DmlOptions();
		getRepo(options.sharingRule).softDeleteAll(records, options);
	}

	public static void softDeleteAll(SObject[] records, Dex.DmlOptions options) {
		getRepo(options.sharingRule).softDeleteAll(records, options);
	}

	public static void hardDeleteAll(SObject[] records) {
		Dex.DmlOptions options = new Dex.DmlOptions();
		getRepo(options.sharingRule).hardDeleteAll(records, options);
	}

	public static void hardDeleteAll(SObject[] records, Dex.DmlOptions options) {
		getRepo(options.sharingRule).hardDeleteAll(records, options);
	}

	public static void undeleteAll(SObject[] records) {
		Dex.DmlOptions options = new Dex.DmlOptions();
		getRepo(options.sharingRule).undeleteAll(records, options);
	}

	public static void undeleteAll(SObject[] records, Dex.DmlOptions options) {
		getRepo(options.sharingRule).hardDeleteAll(records, options);
	}

	public static void execute(Dex.Multi multi) {
		Dex.DmlOptions options = new Dex.DmlOptions();
		getRepo(options.sharingRule).execute(multi, options);
	}

	public static void execute(Dex.Multi multi, Dex.DmlOptions options) {
		getRepo(options.sharingRule).execute(multi, options);
	}

	public static void executeAsTransaction(Dex.Multi multi) {
		Dex.DmlOptions options = new Dex.DmlOptions();
		getRepo(options.sharingRule).executeAsTransaction(multi, options);
	}

	public static void executeAsTransaction(Dex.Multi multi, Dex.DmlOptions options) {
		getRepo(options.sharingRule).executeAsTransaction(multi, options);
	}

	public virtual class Repository implements IRepository {
		public SObject one(
			String query,
			Dex.QueryOptions options
		) {
			return getOneResults(Database.queryWithBinds(
				maybeLimitByOne(query),
				options.binds,
				options.accessLevel
			));
		}

		public Integer count(String query, Dex.QueryOptions options) {
			return Database.countQueryWithBinds(query, options.binds, options.accessLevel);
		}

		public SObject[] all(String query, Dex.QueryOptions options) {
			return Database.queryWithBinds(query, options.binds, options.accessLevel);
		}

		public Dex.AggregateResult[] aggregate(String query, Dex.QueryOptions options) {
			return Dex.aggregateResults(
				(Schema.AggregateResult[]) Database.queryWithBinds(query, options.binds, options.accessLevel)
			);
		}

		public void insertAll(SObject[] records, Dex.DmlOptions options) {
			executeDmlOperation(Dex.DmlOperation.OP_INSERT, records, options);
		}

		public void updateAll(SObject[] records, Dex.DmlOptions options) {
			executeDmlOperation(Dex.DmlOperation.OP_UPDATE, records, options);
		}

		public void upsertAll(SObject[] records, Dex.DmlOptions options) {
			executeDmlOperation(Dex.DmlOperation.OP_UPSERT, records, options);
		}

		public void softDeleteAll(SObject[] records, Dex.DmlOptions options) {
			executeDmlOperation(Dex.DmlOperation.OP_SOFT_DELETE, records, options);
		}

		public void hardDeleteAll(SObject[] records, Dex.DmlOptions options) {
			executeDmlOperation(Dex.DmlOperation.OP_HARD_DELETE, records, options);
		}

		public void undeleteAll(SObject[] records, Dex.DmlOptions options) {
			executeDmlOperation(Dex.DmlOperation.OP_UNDELETE, records, options);
		}

		public void execute(Dex.Multi multi, Dex.DmlOptions options) {
			this.executeDmlOperations(multi, options);
		}

		public void executeAsTransaction(Dex.Multi multi, Dex.DmlOptions options) {
			System.Savepoint savepoint = Database.setSavepoint();
			try {
				this.executeDmlOperations(multi, options);
				Database.releaseSavepoint(savepoint);
			} catch (Exception e) {
				Database.rollback(savepoint);
				throw e;
			}
		}

		private void executeDmlOperations(Dex.Multi multi, Dex.DmlOptions options) {
			Dex.DmlOperation[] operations = Dex.DmlOperation.values();
			for (Dex.DmlOperation operation : operations) {
				SObject[] records = multi.operations.get(operation);

				if (records == null) {
					continue;
				}

				this.executeDmlOperation(operation, records, options);
			}
		}

		private void executeDmlOperation(Dex.DmlOperation operation, SObject[] records, Dex.DmlOptions options) {
			Dex.RecordChunk[] chunks = chunkRecords(records);

			for (Dex.RecordChunk chunk : chunks) {
				switch on operation {
					when OP_INSERT {
						Database.insert(chunk.records, options.systemOptions, options.accessLevel);
					}
					when OP_UPDATE {
						Database.update(chunk.records, options.systemOptions, options.accessLevel);
					}
					when OP_UPSERT {
						Database.upsert(chunk.records, options.systemOptions.optAllOrNone, options.accessLevel);
					}
					when OP_SOFT_DELETE {
						Database.delete(chunk.records, options.systemOptions.optAllOrNone, options.accessLevel);
					}
					when OP_HARD_DELETE {
						Database.delete(chunk.records, options.systemOptions.optAllOrNone, options.accessLevel);
						Database.emptyRecycleBin(chunk.records);
					}
					when OP_UNDELETE {
						Database.undelete(chunk.records, options.systemOptions.optAllOrNone, options.accessLevel);
					}
				}
			}
		}

		public Dex.RecordChunk[] chunkRecords(SObject[] records) {
			records.sort();

			// Create chunks of 10 SObjectTypes
			Dex.RecordChunk[] chunks = new Dex.RecordChunk[]{
			};
			Dex.RecordChunk chunk = new Dex.RecordChunk(chunks.size());
			Integer lastRecordIndex = records.size() - 1;
			for (Integer recordIndex = 0; recordIndex < records.size(); ++recordIndex) {
				chunk.addRecord(records[recordIndex]);

				if (recordIndex == lastRecordIndex || chunk.sObjectTypes.size() == 10) {
					chunks.add(chunk);
					chunk = new Dex.RecordChunk(chunks.size());
				}
			}

			return chunks;
		}

		private SObject getOneResults(SObject[] records) {
			return records.isEmpty() ? null : (SObject) records.get(0);
		}

		private String maybeLimitByOne(String query) {
			String limitedQuery = query;
			if (!query.contains('LIMIT 1')) {
				limitedQuery = query + ' LIMIT 1';
			}

			return limitedQuery;
		}
	}

	@TestVisible
	private with sharing class WithSharingRepo extends Repository {
	}

	@TestVisible
	private without sharing class WithoutSharingRepo extends Repository {
	}

	@TestVisible
	private inherited sharing class InheritedSharingRepo extends Repository {
	}

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
		private Dex.AggregateResult put(String alias, Object value) {
			this.data.put(alias, value);
			return this;
		}
	}

	private static Dex.AggregateResult[] aggregateResults(Schema.AggregateResult[] systemResults) {
		Dex.AggregateResult[] aggregateResults = new Dex.AggregateResult[]{
		};

		for (
			Schema.AggregateResult systemResult : (Schema.AggregateResult[]) systemResults
		) {
			aggregateResults.add(new Dex.AggregateResult(systemResult));
		}

		return aggregateResults;
	}

	public interface IRepository {
		SObject one(String query, Dex.QueryOptions options);
		Integer count(String query, Dex.QueryOptions options);
		SObject[] all(String query, Dex.QueryOptions options);
		Dex.AggregateResult[] aggregate(String query, Dex.QueryOptions options);
		void insertAll(SObject[] records, Dex.DmlOptions options);
		void updateAll(SObject[] records, Dex.DmlOptions options);
		void upsertAll(SObject[] records, Dex.DmlOptions options);
		void softDeleteAll(SObject[] records, Dex.DmlOptions options);
		void hardDeleteAll(SObject[] records, Dex.DmlOptions options);
		void undeleteAll(SObject[] records, Dex.DmlOptions options);
		void execute(Dex.Multi multi, Dex.DmlOptions options);
		void executeAsTransaction(Dex.Multi multi, Dex.DmlOptions options);
	}

	public enum DmlOperation {
		OP_INSERT,
		OP_UPDATE,
		OP_UPSERT,
		OP_SOFT_DELETE,
		OP_HARD_DELETE,
		OP_UNDELETE
	}

	public class RecordChunk {
		public Integer order;
		public SObject[] records = new SObject[]{
		};
		public SObjectType[] sObjectTypes = new SObjectType[]{
		};

		public RecordChunk(Integer order) {
			this.order = order;
		}

		public void addRecord(SObject record) {
			if (!sObjectTypes.contains(record.getSObjectType())) {
				sObjectTypes.add(record.getSObjectType());
			}

			this.records.add(record);
		}
	}

	public class Multi {
		private Map<Dex.DmlOperation, SObject[]> operations = new Map<Dex.DmlOperation, SObject[]>();

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

		private void addOperation(SObject[] records, Dex.DmlOperation operation) {
			if (!operations.containsKey(operation)) {
				operations.put(operation, new List<SObject>{
				});
			}

			operations.get(operation).addAll(records);
		}
	}

	public class QueryOptions {
		public Map<String, Object> binds;
		public Dex.SHARING_RULE sharingRule;
		public System.AccessLevel accessLevel;

		public QueryOptions() {
			this.binds = new Map<String, Object>();
			this.sharingRule = DEFAULT_SHARING_RULE;
			this.accessLevel = DEFAULT_ACCESS_LEVEL;
		}

		public QueryOptions withSharing() {
			this.sharingRule = Dex.SHARING_RULE.WITH_SHARING;
			return this;
		}

		public QueryOptions withoutSharing() {
			this.sharingRule = Dex.SHARING_RULE.WITHOUT_SHARING;
			return this;
		}

		public QueryOptions inheritedSharing() {
			this.sharingRule = Dex.SHARING_RULE.INHERITED_SHARING;
			return this;
		}

		public QueryOptions asUser() {
			this.accessLevel = System.AccessLevel.USER_MODE;
			return this;
		}

		public QueryOptions asSystem() {
			this.accessLevel = System.AccessLevel.SYSTEM_MODE;
			return this;
		}

		public QueryOptions withBinds(Map<String, Object> binds) {
			this.binds = binds;
			return this;
		}

		public QueryOptions addBind(String key, Object value) {
			this.binds.put(key, value);
			return this;
		}
	}

	public class DMLOptions {
		public Dex.SHARING_RULE sharingRule;
		public System.AccessLevel accessLevel;
		public Database.DMLOptions systemOptions;

		public DMLOptions() {
			this.sharingRule = DEFAULT_SHARING_RULE;
			this.accessLevel = DEFAULT_ACCESS_LEVEL;
			this.systemOptions = new Database.DMLOptions();
			this.systemOptions.optAllOrNone = false;
		}

		public DMLOptions(
			Dex.SHARING_RULE sharingRule,
			System.AccessLevel accessLevel,
			Database.DMLOptions systemOptions
		) {
			this.sharingRule = sharingRule;
			this.accessLevel = accessLevel;
			this.systemOptions = systemOptions;
		}

		public Dex.DmlOptions withSharing() {
			this.sharingRule = Dex.SHARING_RULE.WITH_SHARING;
			return this;
		}

		public Dex.DmlOptions withoutSharing() {
			this.sharingRule = Dex.SHARING_RULE.WITHOUT_SHARING;
			return this;
		}

		public Dex.DmlOptions inheritedSharing() {
			this.sharingRule = Dex.SHARING_RULE.INHERITED_SHARING;
			return this;
		}

		public Dex.DmlOptions asUser() {
			this.accessLevel = System.AccessLevel.USER_MODE;
			return this;
		}

		public Dex.DmlOptions asSystem() {
			this.accessLevel = System.AccessLevel.SYSTEM_MODE;
			return this;
		}

		public Dex.DmlOptions withSystemOptions(Database.DMLOptions systemOptions) {
			this.systemOptions = systemOptions;
			return this;
		}
	}
}
