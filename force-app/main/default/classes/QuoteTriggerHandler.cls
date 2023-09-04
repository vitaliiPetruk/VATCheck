public with sharing class QuoteTriggerHandler extends TriggerHandler {

	protected override void afterUpdate() {
		if (System.isFuture() || System.IsBatch()) {
			return; // This is a recursive update or Batch, let's skip
		}

		updateVat();
	}

	protected override void afterInsert() {
		if (System.isFuture() || System.IsBatch()) {
			return; // This is a recursive update or Batch, let's skip
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




