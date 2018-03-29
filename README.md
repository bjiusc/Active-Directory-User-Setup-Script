# Active Directory Scripting for User Setup

-------------------------------------------------------------------------------------------------------
AD_UserSetup_Public.ps1

This script creates a user in the AD under <Your Organizational Unit Here> and automatically assigns a default password of <Your Default Password Convention Here>. 
It will use the convention of firstname.lastname as the username, both for domain logon as well as E-mail for the synced AD to Azure AD (primary SMTP proxyAddress in the on-prem AD). 
It will also populate various fields in the domain profile. 
This is modifiable in the code below to fit your organization's setup processes.

Last updated: 3/28/2018		Author: Brian Ji
-------------------------------------------------------------------------------------------------------
