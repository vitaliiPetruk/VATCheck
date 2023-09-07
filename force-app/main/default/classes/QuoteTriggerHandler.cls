public with sharing class QuoteTriggerHandler extends TriggerHandler {

	protected override void afterUpdate() {
		if (System.isBatch() || System.isQueueable() || System.isFuture()) {
			return; // This is a recursive update or Batch, let's skip
		}

		updateVat();
	}

	protected override void afterInsert() {
		if (System.isBatch() || System.isQueueable() || System.isFuture()) {
			return; // This is a recursive update or Batch, let's skip
		}

		updateVat();
	}

	public static void updateVat() {
		Set<Id> idSet = new Map<Id, SObject>(Trigger.new).keySet();

		QuoteTriggerHelper.VATUpdate(idSet);
	}
}




