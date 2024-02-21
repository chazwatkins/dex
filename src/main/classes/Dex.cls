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

	private static IRepository getRepo() {
		return getRepo(DEFAULT_SHARING_RULE);
	}

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
		return getRepo().one(query, new Map<String, Object>());
	}

	public static SObject one(String query, Map<String, Object> binds) {
		return getRepo().one(query, binds, DEFAULT_ACCESS_LEVEL);
	}

	public static SObject one(String query, System.AccessLevel accessLevel) {
		return getRepo().one(query, accessLevel);
	}

	public static SObject one(
		String query,
		Map<String, Object> binds,
		System.AccessLevel accessLevel
	) {
		return getRepo().one(query, binds, accessLevel);
	}

	public static Integer count(String query) {
		return getRepo().count(query, new Map<String, Object>());
	}

	public static Integer count(String query, Map<String, Object> binds) {
		return getRepo().count(query, binds, DEFAULT_ACCESS_LEVEL);
	}

	public static Integer count(String query, System.AccessLevel accessLevel) {
		return getRepo().count(query, accessLevel);
	}

	public static Integer count(
		String query,
		Map<String, Object> binds,
		System.AccessLevel accessLevel
	) {
		return getRepo().count(query, binds, accessLevel);
	}

	public static SObject[] all(String query) {
		return getRepo().all(query);
	}

	public static SObject[] all(String query, Map<String, Object> binds) {
		return getRepo().all(query, binds);
	}

	public static SObject[] all(String query, System.AccessLevel accessLevel) {
		return getRepo().all(query, accessLevel);
	}

	public static SObject[] all(String query, SHARING_RULE sharingRule) {
		return getRepo(sharingRule).all(query);
	}

	public static SObject[] all(
		String query,
		Map<String, Object> binds,
		System.AccessLevel accessLevel
	) {
		return getRepo().all(query, binds, accessLevel);
	}

	public static Dex.AggregateResult[] aggregate(String query) {
		return getRepo().aggregate(query);
	}

	public static Dex.AggregateResult[] aggregate(String query, Map<String, Object> binds) {
		return getRepo().aggregate(query, binds);
	}

	public static Dex.AggregateResult[] aggregate(String query, System.AccessLevel accessLevel) {
		return getRepo().aggregate(query, accessLevel);
	}

	public static Dex.AggregateResult[] aggregate(String query, SHARING_RULE sharingRule) {
		return getRepo(sharingRule).aggregate(query);
	}

	public static Dex.AggregateResult[] aggregate(
		String query,
		Map<String, Object> binds,
		System.AccessLevel accessLevel
	) {
		return getRepo().aggregate(query, binds, accessLevel);
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

	public static void run(Dex.Multi multi) {
		getRepo().execute(multi);
	}

	public static void executeTransaction(Dex.Multi multi) {
		getRepo().executeTransaction(multi);
	}

	public virtual class Repository implements IRepository {
		public SObject one(String query) {
			return getOneResults(Database.query(maybeLimitByOne(query), DEFAULT_ACCESS_LEVEL));
		}

		public SObject one(String query, Map<String, Object> binds) {
			return getOneResults(Database.queryWithBinds(maybeLimitByOne(query), binds, DEFAULT_ACCESS_LEVEL));
		}

		public SObject one(String query, System.AccessLevel accessLevel) {
			return getOneResults(Database.query(maybeLimitByOne(query), accessLevel));
		}

		public SObject one(
			String query,
			Map<String, Object> binds,
			System.AccessLevel accessLevel
		) {
			return getOneResults(Database.queryWithBinds(
				maybeLimitByOne(query),
				binds,
				accessLevel
			));
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

		public Integer count(String query) {
			return Database.countQuery(query, DEFAULT_ACCESS_LEVEL);
		}

		public Integer count(String query, Map<String, Object> binds) {
			return Database.countQueryWithBinds(query, binds, DEFAULT_ACCESS_LEVEL);
		}

		public Integer count(String query, System.AccessLevel accessLevel) {
			return Database.countQuery(query, accessLevel);
		}

		public Integer count(
			String query,
			Map<String, Object> binds,
			System.AccessLevel accessLevel
		) {
			return Database.countQueryWithBinds(query, binds, accessLevel);
		}

		public SObject[] all(String query) {
			return Database.query(query, Dex.DEFAULT_ACCESS_LEVEL);
		}

		public SObject[] all(String query, Map<String, Object> binds) {
			return Database.queryWithBinds(query, binds, Dex.DEFAULT_ACCESS_LEVEL);
		}

		public SObject[] all(String query, System.AccessLevel accessLevel) {
			return Database.query(query, accessLevel);
		}

		public SObject[] all(
			String query,
			Map<String, Object> binds,
			System.AccessLevel accessLevel
		) {
			return Database.queryWithBinds(query, binds, accessLevel);
		}

		public Dex.AggregateResult[] aggregate(String query) {
			return Dex.aggregateResults((Schema.AggregateResult[]) Database.query(query, Dex.DEFAULT_ACCESS_LEVEL));
		}

		public Dex.AggregateResult[] aggregate(String query, Map<String, Object> binds) {
			return Dex.aggregateResults(
				(Schema.AggregateResult[]) Database.queryWithBinds(query, binds, Dex.DEFAULT_ACCESS_LEVEL)
			);
		}

		public Dex.AggregateResult[] aggregate(String query, System.AccessLevel accessLevel) {
			return Dex.aggregateResults((Schema.AggregateResult[]) Database.query(query, accessLevel));
		}

		public Dex.AggregateResult[] aggregate(
			String query,
			Map<String, Object> binds,
			System.AccessLevel accessLevel
		) {
			return Dex.aggregateResults(
				(Schema.AggregateResult[]) Database.queryWithBinds(query, binds, accessLevel)
			);
		}

		public void insertAll(SObject[] records) {
			executeDmlOperation(Dex.DmlOperation.OP_INSERT, records);
		}

		public void updateAll(SObject[] records) {
			executeDmlOperation(Dex.DmlOperation.OP_UPDATE, records);
		}

		public void upsertAll(SObject[] records) {
			executeDmlOperation(Dex.DmlOperation.OP_UPSERT, records);
		}

		public void softDeleteAll(SObject[] records) {
			executeDmlOperation(Dex.DmlOperation.OP_SOFT_DELETE, records);
		}

		public void hardDeleteAll(SObject[] records) {
			executeDmlOperation(Dex.DmlOperation.OP_HARD_DELETE, records);
		}

		public void undeleteAll(SObject[] records) {
			executeDmlOperation(Dex.DmlOperation.OP_UNDELETE, records);
		}

		public void execute(Dex.Multi multi) {
			this.executeDmlOperations(multi);
		}

		public void executeTransaction(Dex.Multi multi) {
			System.Savepoint savepoint = Database.setSavepoint();
			try {
				this.executeDmlOperations(multi);
				Database.releaseSavepoint(savepoint);
			} catch (Exception e) {
				Database.rollback(savepoint);
				throw e;
			}
		}

		private void executeDmlOperations(Dex.Multi multi) {
			Dex.DmlOperation[] operations = Dex.DmlOperation.values();
			for (Dex.DmlOperation operation : operations) {
				SObject[] records = multi.operations.get(operation);

				if (records == null) {
					continue;
				}

				this.executeDmlOperation(operation, records);
			}
		}

		private void executeDmlOperation(Dex.DmlOperation operation, SObject[] records) {
			Dex.RecordChunk[] chunks = chunkRecords(records);

			for (Dex.RecordChunk chunk : chunks) {
				switch on operation {
					when OP_INSERT {
						Database.insert(chunk.records);
					}
					when OP_UPDATE {
						Database.update(chunk.records);
					}
					when OP_UPSERT {
						Database.upsert(chunk.records);
					}
					when OP_SOFT_DELETE {
						Database.delete(chunk.records);
					}
					when OP_HARD_DELETE {
						Database.delete(chunk.records);
						Database.emptyRecycleBin(chunk.records);
					}
					when OP_UNDELETE {
						Database.undelete(chunk.records);
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
		private AggregateResult put(String alias, Object value) {
			this.data.put(alias, value);
			return this;
		}
	}

	private static AggregateResult[] aggregateResults(Schema.AggregateResult[] systemResults) {
		AggregateResult[] aggregateResults = new AggregateResult[]{
		};

		for (
			Schema.AggregateResult systemResult : (Schema.AggregateResult[]) systemResults
		) {
			aggregateResults.add(new AggregateResult(systemResult));
		}

		return aggregateResults;
	}

	public interface IRepository {
		SObject one(String query);
		SObject one(String query, Map<String, Object> binds);
		SObject one(
			String query,
			Map<String, Object> binds,
			System.AccessLevel accessLevel
		);
		SObject one(String query, System.AccessLevel accessLevel);
		Integer count(String query);
		Integer count(String query, Map<String, Object> binds);
		Integer count(
			String query,
			Map<String, Object> binds,
			System.AccessLevel accessLevel
		);
		Integer count(String query, System.AccessLevel accessLevel);
		SObject[] all(String query);
		SObject[] all(String query, Map<String, Object> binds);
		SObject[] all(
			String query,
			Map<String, Object> binds,
			System.AccessLevel accessLevel
		);
		SObject[] all(String query, System.AccessLevel accessLevel);
		Dex.AggregateResult[] aggregate(String query);
		Dex.AggregateResult[] aggregate(String query, Map<String, Object> binds);
		Dex.AggregateResult[] aggregate(
			String query,
			Map<String, Object> binds,
			System.AccessLevel accessLevel
		);
		Dex.AggregateResult[] aggregate(String query, System.AccessLevel accessLevel);
		void insertAll(SObject[] records);
		void updateAll(SObject[] records);
		void upsertAll(SObject[] records);
		void softDeleteAll(SObject[] records);
		void hardDeleteAll(SObject[] records);
		void undeleteAll(SObject[] records);
		void execute(Dex.Multi multi);
		void executeTransaction(Dex.Multi multi);
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
}
