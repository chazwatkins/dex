@IsTest(IsParallel=true)
private class DexTest {
	@IsTest
	static void defaultSharingRuleShouldBeInheritedSharing() {
		System.Assert.areEqual(
			Dex.DEFAULT_SHARING_RULE,
			Dex.SHARING_RULE.INHERITED_SHARING
		);
	}

	@IsTest
	static void defaultAccessLevelShouldBeSystemMode() {
		System.Assert.areEqual(
			Dex.DEFAULT_ACCESS_LEVEL,
			System.AccessLevel.SYSTEM_MODE
		);
	}

	@IsTest
	static void getSharingDatabaseShouldReturnInheritedDatabase() {
		Dex.ISharingRepo sharingDatabase = Dex.getSharingDatabase(
			Dex.SHARING_RULE.INHERITED_SHARING
		);

		System.Assert.isInstanceOfType(
			sharingDatabase,
			Dex.InheritedSharingRepo.class
		);
	}

	@IsTest
	static void getSharingDatabaseShouldReturnWithSharingDatabase() {
		Dex.ISharingRepo sharingDatabase = Dex.getSharingDatabase(
			Dex.SHARING_RULE.WITH_SHARING
		);

		System.Assert.isInstanceOfType(sharingDatabase, Dex.WithSharingRepo.class);
	}

	@IsTest
	static void getSharingDatabaseShouldReturnWithoutSharingDatabase() {
		Dex.ISharingRepo sharingDatabase = Dex.getSharingDatabase(
			Dex.SHARING_RULE.WITHOUT_SHARING
		);

		System.Assert.isInstanceOfType(
			sharingDatabase,
			Dex.WithoutSharingRepo.class
		);
	}

	@IsTest
	static void sharingDatabasesShouldCallSystemDatabaseForQueries() {
		String query = 'Select Id FROM Task wHERE Subject = :testSubject';
		Map<String, Object> bindVariables = new Map<String, Object>{
			'testSubject' => 'Test Task'
		};

		Test.startTest();

		for (Dex.SHARING_RULE sharingRule : Dex.SHARING_RULE.values()) {
			Dex.ISharingRepo sharingRepo = Dex.getSharingDatabase(sharingRule);

			Object[] results = sharingRepo.getAll(
				query,
				bindVariables,
				System.AccessLevel.SYSTEM_MODE
			);

			System.Assert.isInstanceOfType(results, List<SObject>.class);
		}

		Test.stopTest();
	}

	@IsTest
	static void getWithRecordShouldReturnOneSObject() {
		getTestRecord();

		String query = 'SELECT Id FROM Task';

		Test.startTest();

		Object result = Dex.get(query);

		Test.stopTest();

		System.Assert.isInstanceOfType(result, SObject.class);

		System.Assert.isNotNull(result);
	}

	@IsTest
	static void getWithoutRecordShouldReturnNull() {
		String query = 'SELECT Id FROM Task';

		Test.startTest();

		Object result = Dex.get(query);

		Test.stopTest();

		System.Assert.isNull(result);
	}

	@IsTest
	static void queryShouldReturnSObjectList() {
		SObject[] testRecords = getTestRecords(10);

		String query = 'SELECT Id FROM Task';

		Test.startTest();

		Object[] results = Dex.getAll(query);

		Test.stopTest();

		System.Assert.isInstanceOfType(results, List<SObject>.class);

		System.Assert.areEqual(testRecords.size(), results.size());
	}

	@IsTest
	static void getIncludingAggregateResultsShouldReturnAggregateWrapper() {
		String query = 'SELECT COUNT(Id), COUNT(Id) TaskCount FROM Task';

		Test.startTest();

		Object result = Dex.get(query);

		Test.stopTest();

		System.Assert.isInstanceOfType(result, Dex.AggregateResult.class);

		Dex.AggregateResult aggregateResult = (Dex.AggregateResult) result;
		System.Assert.areEqual(0, aggregateResult.get('expr0'));
		System.Assert.areEqual(0, aggregateResult.get('TaskCount'));
	}

	@IsTest
	static void getAllIncludingAggregateResultsShouldReturnAggregateWrappers() {
		String query = 'SELECT COUNT(Id), COUNT(Id) TaskCount FROM Task';

		Test.startTest();

		Object[] results = Dex.getAll(query);

		Test.stopTest();

		System.Assert.isInstanceOfType(results, List<Dex.AggregateResult>.class);

		Dex.AggregateResult[] aggregateResults = (Dex.AggregateResult[]) results;
		System.Assert.areEqual(1, aggregateResults.size());
		System.Assert.areEqual(0, aggregateResults.get(0).get('expr0'));
		System.Assert.areEqual(0, aggregateResults.get(0).get('TaskCount'));
	}

	private static SObject getTestRecord() {
		return getTestRecords(1).get(0);
	}

	private static SObject[] getTestRecords(Integer size) {
		ATK.SaveResult result = ATK.prepare(Task.SObjectType, size)
			.field(Task.Subject)
			.index('Task-{0000}')
			.save();

		return result.get(Task.SObjectType);
	}

	@IsTest
	static void getQueryLocatorShouldReturnSsytemDatabaseQueryLocator() {
		String query = 'SELECT Id FROM Task';

		Test.startTest();

		Object queryLocator = Dex.getQueryLocator(query);

		System.Assert.isInstanceOfType(queryLocator, Database.QueryLocator.class);

		Test.stopTest();
	}

	@IsTest
	static void sharingDatabaseGetQueryLocatorShouldReturnSystemDatabaseQueryLocator() {
		String query = 'SELECT Id FROM Task';

		Test.startTest();

		for (Dex.SHARING_RULE sharingRule : Dex.SHARING_RULE.values()) {
			Object queryLocator = Dex.getQueryLocator(query, sharingRule);

			System.Assert.isInstanceOfType(queryLocator, Database.QueryLocator.class);
		}

		Test.stopTest();
	}

	@IsTest
	static void accessLevelGetQueryLocatorShouldReturnSystemDatabaseQueryLocator() {
		String query = 'SELECT Id FROM Task';

		Test.startTest();

		for (System.AccessLevel accessLevel : accessLevels()) {
			Object queryLocator = Dex.getQueryLocator(query, accessLevel);

			System.Assert.isInstanceOfType(queryLocator, Database.QueryLocator.class);
		}

		Test.stopTest();
	}

	private static List<System.AccessLevel> accessLevels() {
		return new List<System.AccessLevel>{
			System.AccessLevel.SYSTEM_MODE,
			System.AccessLevel.USER_MODE
		};
	}

	@IsTest
	static void aggregateResultCanBeMocked() {
		Dex.AggregateResult result = new Dex.AggregateResult();

		result.put('expr0', 0).put('TestCount', 25);

		System.Assert.areEqual(0, result.get('expr0'));
		System.Assert.areEqual(25, result.get('TestCount'));
	}
}
