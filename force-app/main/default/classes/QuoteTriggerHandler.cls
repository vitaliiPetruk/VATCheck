public with sharing class QuoteTriggerHandler extends TriggerHandler {

	protected override void afterUpdate() {
		if (System.isFuture()) {
			return; // This is a recursive update, let's skip
		}

		updateVat();
	}

	protected override void afterInsert() {
		if (System.isFuture()) {
			return; // This is a recursive update, let's skip
		}

		updateVat();
	}

	public static void updateVat() {
		Set<String> quoteIds = new Set<String>();
		for (SObject obj : Trigger.new) {
			quoteIds.add(obj.Id);
		}

		QuoteTriggerHelper.VATUpdate(quoteIds);
	}
}




