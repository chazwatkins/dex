@IsTest(IsParallel=true)
private class DexTest {

    @IsTest
    static void eachSharingRuleHasRepo() {
        for(Dex.SHARING_RULE sharingRule : Dex.SHARING_RULE.values()) {
            System.Assert.isTrue(Dex.REPOS_BY_SHARING_RULES.containsKey(sharingRule));
        }
    }

    @IsTest
    static void getRepoReturnsSharingRuleRepoInstance() {
        Dex.IRepository repo;
        for(Dex.SHARING_RULE sharingRule : Dex.SHARING_RULE.values()) {
            repo = Dex.getRepo(sharingRule);
            System.Assert.isInstanceOfType(repo, Dex.REPOS_BY_SHARING_RULES.get(sharingRule));
        }
    }
}
