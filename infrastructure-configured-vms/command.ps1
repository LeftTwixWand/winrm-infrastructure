# param(
#     # [Parameter(Mandatory=$true)]
#     [string]$subscriptionId = ""
# )

# # $sp = az ad sp create-for-rbac --name PackerServicePrincipal --role Contributor --scopes /subscriptions/$subscriptionId | ConvertFrom-Json;

# $appId = ""
# $password = ""

# packer validate `
#     -var "client_id=$appId" `
#     -var "client_secret=$password" `
#     -var "subscription_id=$subscriptionId" `
#     iis-vm.pkr.hcl;

# packer build `
#      -var "client_id=$appId" `
#      -var "client_secret=$password" `
#      -var "subscription_id=$subscriptionId" `
#      iis-vm.pkr.hcl;

# # az ad sp delete --id $sp.appId;