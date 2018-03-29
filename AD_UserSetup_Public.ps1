<#
-------------------------------------------------------------------------------------------------------
AD_UserSetup_Public.ps1

This script creates a user in the AD under <Your Organizational Unit Here> and automatically assigns a default password of <Your Default Password Convention Here>. 
It will use the convention of firstname.lastname as the username, both for domain logon as well as E-mail for the synced AD to Azure AD (primary SMTP proxyAddress in the on-prem AD). 
It will also populate various fields in the domain profile. 
This is modifiable in the code below to fit your organization's setup processes.

Last updated: 3/28/2018		Author: Brian Ji
-------------------------------------------------------------------------------------------------------
#>

Write-Host "-----------------------------------------------------`nAD User Creation Script`nAuthor: Brian Ji`nLast updated: 3/28/18`n-----------------------------------------------------"
Write-Host " "

#prompt for employee name
$employeeName = Read-Host -Prompt 'Input the name of the new employee (ex. John Smith)'
$department = Read-Host -Prompt 'Input the employees department (ex. Accounting)'
$location = Read-Host -Prompt 'Input the employees location (ex. Los Angeles)'
$title = Read-Host -Prompt 'Input the employees title (ex. Accountant)'

#create new variables with appropriate values based on the name inputted, TODO: implement input checking
$firstName,$lastName = $employeeName.split(' ')
$userNameAD = "$($firstName).$($lastName)"
$initials = "$($firstName.SubString(0,1))$($lastName.SubString(0,1))"
$password = "DEFAULT_PW_HERE$initials"
$securePassword = ConvertTo-SecureString -String "$password" -AsPlainText -Force
$mUserPrincipalName = "$($userNameAD)@domain.com"
$mProxyAddress = "SMTP:" + $mUserPrincipalName

#create AD user
New-ADUser -Name "$employeeName" -SamAccountName "$userNameAD" -GivenName "$firstName" -Surname "$lastName" -DisplayName "$employeeName"`
-UserPrincipalName "$mUserPrincipalName"`
-Path "YOUR_OU_PATH_HERE"`
-Department "$department" -Company "YOUR_COMPANY_HERE" -Office "$location" -Title "$title" -Description "$title" -Email "$mUserPrincipalName"`

#set users primary SMTP proxyaddress
Set-ADUser -identity $userNameAD -add @{proxyAddresses = $mProxyAddress}

#set AD user password and activate account
Set-ADAccountPassword -Identity $userNameAD -Reset -NewPassword $securePassword
Enable-ADAccount -Identity $userNameAD


#See user attributes
Write-Host " `nUser Created! Deatils below:"
Get-ADUser $userNameAD -Properties * | Format-List DistinguishedName,Name,Department,Company,Office,sAMAccountName,proxyAddresses

Write-Host "-------------------------`nScript Ended...`n `n "
