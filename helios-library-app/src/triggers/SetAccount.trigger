trigger SetAccount on Contact (before insert) {
    Account theAccount = [select id from account limit 1];
    for (Contact student : Trigger.new) {
        student.AccountId = theAccount.Id;
    }
}