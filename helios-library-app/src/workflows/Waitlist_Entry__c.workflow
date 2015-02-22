<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_waitlisted_seeker</fullName>
        <description>Alert waitlisted seeker</description>
        <protected>false</protected>
        <recipients>
            <field>Student__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>librarian@heliosns.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Library_Email_Templates/Notify_Waitlist_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Expire_Waitlist_Entry</fullName>
        <field>Status__c</field>
        <literalValue>Expired</literalValue>
        <name>Expire Waitlist Entry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Notified_Date</fullName>
        <field>Date_Notified__c</field>
        <formula>Today()</formula>
        <name>Set_Notified_Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Notify Waitlist</fullName>
        <actions>
            <name>Alert_waitlisted_seeker</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Notified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Waitlist_Entry__c.Status__c</field>
            <operation>equals</operation>
            <value>Notified</value>
        </criteriaItems>
        <description>Notify the student in the waitlist when their book is available, and start the expiration countdown.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Expire_Waitlist_Entry</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
