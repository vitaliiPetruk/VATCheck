public with sharing class QuoteUpdateBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
	final private String query = 'SELECT Id, Client_Country__c, VAT_Rate__c FROM Quote';

	public Database.QueryLocator start(Database.BatchableContext bc) {
		return Database.getQueryLocator(query);
	}

	public void execute(Database.BatchableContext bc, List<Quote> scope) {
		QuoteUpdateBatchHelper.batchVATUpdate(scope);
	}

	public void finish(Database.BatchableContext bc) {
	}
}
