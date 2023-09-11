public with sharing class QuoteTriggerHandler extends TriggerHandler {

	protected override void afterUpdate() {
		if (System.isBatch() || System.isQueueable() || System.isFuture()) {
			return;
		}

		updateVat();
	}

	protected override void afterInsert() {
		if (System.isBatch() || System.isQueueable() || System.isFuture()) {
			return;
		}

		updateVat();
	}

	public static void updateVat() {
		Set<Id> idSet = new Map<Id, SObject>(Trigger.new).keySet();
		QuoteTriggerHelper.vatUpdate(idSet);
	}
}
