trigger QuoteTrigger on Quote (
		before insert,
		before update,
		before delete,
		after insert,
		after update,
		after delete,
		after undelete
) {

	if (System.isFuture()) {
		return; // This is a recursive update, let's skip
	}
	Set<Id> updateQuote = new Set<Id>();

	for (Integer i = 0, s = Trigger.new.size(); i < s; i++) {

		Quote oldRecord = Trigger.isInsert ? null : Trigger.old[i], newRec = Trigger.new[i];

		if ((Trigger.isInsert && newRec.Client_Country__c != null) ||
				(Trigger.isUpdate && newRec.Client_Country__c != null)) {

			updateQuote.add(newRec.Id);

			if (updateQuote.size() == 100) { // Max callout limit 100
				QuoteTriggerHandler.updateVAT(updateQuote);
				updateQuote.clear();
			}
		}
	}
	if (updateQuote.size() > 0) {
		QuoteTriggerHandler.updateVAT(updateQuote);
	}

}
