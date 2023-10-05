$subscriptionId = ""

$sp = az ad sp create-for-rbac --name PackerServicePrincipal --role Contributor --scopes /subscriptions/$subscriptionId | ConvertFrom-Json

packer build -var "client_id=${sp.appId}" -var "client_secret=${sp.password}" -var "subscription_id=$subscriptionId"

az ad sp delete --name PackerServicePrincipal