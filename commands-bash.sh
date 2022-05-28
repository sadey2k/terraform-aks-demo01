### Variables ###
keyvaultname="demodevopsvault"
location="ukwest"
keyvaultrg="demodevopsvaultrg"
sshkeysecret="xxxxx"
spnclientid="xxxxxx"
clientidkvsecretname="xxxxxx"
spnclientsecret="xxxxxx"
spnkvsecretname="xxxxx"
spobjectID="xxxxx"
userobjectid="xxxxx"


#### Create Key Vault ###
az group create --name -Name $keyvaultrg --Location $location

#### Create Key Vault ###
az keyvault create --name $keyvaultname --resource-group $keyvaultrg --location $location

az keyvault set-policy --name $keyvaultname --object-id $userobjectid --key-permissions get,set,delete,list


#### create an ssh key for setting up password-less login between agent nodes.
ssh-keygen  -f ~/.ssh/id_rsa_terraform


#### Add SSH Key in Azure Key vault secret
pubkey="cat ~/.ssh/id_rsa_terraform.pub"

$Secret = ConvertTo-SecureString -String $pubkey -AsPlainText -Force

az keyvault secret set –vault-name $keyvaultname --name $sshkeysecret -SecretValue $Secret


#### Store service principal Client id in Azure KeyVault
$Secret = ConvertTo-SecureString -String $spnclientid -AsPlainText -Force

az keyvault secret set –vault-name $keyvaultname --name $clientidkvsecretname -SecretValue $Secret


#### Store service principal Secret in Azure KeyVault
$Secret = ConvertTo-SecureString -String $spnclientsecret -AsPlainText -Force

az keyvault secret set –vault-name $keyvaultname -Name $spnkvsecretname -SecretValue $Secret


#### Provide Keyvault secret access to SPN using Keyvault access policy
Set-AzKeyVaultAccessPolicy –vault--name $keyvaultname -ServicePrincipalName $spobjectID -PermissionsToSecrets Get,Set