@description('VM size')
param vmSize string = 'Standard_B1s'
param location string = resourceGroup().location
@description('The administrator username for your Virtual Machines')
param adminUsername string
@description('The administrator password for your Virtual Machines')
@secure()
param adminPassword string

@description('Name of the NAT gateway')
param natgatewayname string = 'nat-gateway'

@description('Name of the NAT gateway public IP')
param publicipname string = 'public-ip-nat'

@description('Name of the Network Watcher attached to your subscription. Format: NetworkWatcher_<region_name>')
param networkWatcherName string = 'NetworkWatcher_${location}'

@description('Retention period in days. Default is zero which stands for permanent retention. Can be any Integer from 0 to 365')
@minValue(0)
@maxValue(365)
param retentionDays int = 2

@description('FlowLogs Version. Correct values are 1 or 2 (default)')
@allowed([
  1
  2
])
param flowLogsVersion int = 2

@description('Storage Account type')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
])
param storageAccountType string = 'Standard_LRS'

var storageAccountName = 'flowlogs${uniqueString(resourceGroup().id)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {}
}

module flowLog './flowlogs.bicep' = {
  name: 'flogLogDeploy'
  // NEED TO REPLACE THIS RG NAME WITH RG NAME WHERE NETWORK WATCHER LIVES
  //scope: resourceGroup('<RGNAME>')
  scope: resourceGroup('NetworkWatcherRG')
  params: {
    location: location
    networkWatcherName: networkWatcherName
    vmNames: vmNames
    retentionDays: retentionDays
    flowLogsVersion: flowLogsVersion
    storageId: storageAccount.id
    nsgRgName: resourceGroup().name
  }
}

// You can edit this list of VMs to suit your needs. The script will loop through however many entries here to create VMs.
var vmNames = [
  {
    namePrefix: 'Ticketing-Prod-Web5'
    computerName: 'Ticketing-Prod-Web5'
    nsg: 'nsg-ticket-prod-web5'
    ipAddress: '10.40.0.105'
    vnet: 'vnetA'
    subnet: 'subnet0'
    env: 'Prod'
    app: 'Ticketing'
    BizUnit: '1234'
    role: 'web'
    Compliance: 'PCI'
  }
  {
    namePrefix: 'Ticketing-Prod-Web6'
    computerName: 'Ticketing-Prod-Web6'
    nsg: 'nsg-ticket-prod-web6'
    ipAddress: '10.40.0.106'
    vnet: 'vnetA'
    subnet: 'subnet0'
    env: 'Prod'
    app: 'Ticketing'
    BizUnit: '1234'
    role: 'web'
    Compliance: 'PCI'
  }
  {
    namePrefix: 'Ticketing-Prod-Proc5'
    computerName: 'Ticketing-Prod-Proc5'
    nsg: 'nsg-ticket-prod-proc5'
    ipAddress: '10.40.0.107'
    vnet: 'vnetA'
    subnet: 'subnet0'
    env: 'Prod'
    app: 'Ticketing'
    BizUnit: '1234'
    role: 'proc'
    Compliance: 'PCI'
  }
  {
    namePrefix: 'Ticketing-Prod-DB5'
    computerName: 'Ticketing-Prod-DB5'
    nsg: 'nsg-ticket-prod-db5'
    ipAddress: '10.40.0.108'
    vnet: 'vnetA'
    subnet: 'subnet0'
    env: 'Prod'
    app: 'Ticketing'
    BizUnit: '1234'
    role: 'db'
    Compliance: 'PCI'
  } 
  {
    namePrefix: 'Ticketing-Prod-DB6'
    computerName: 'Ticketing-Prod-DB6'
    nsg: 'nsg-ticket-prod-db6'
    ipAddress: '10.40.0.109'
    vnet: 'vnetA'
    subnet: 'subnet0'
    env: 'Prod'
    app: 'Ticketing'
    BizUnit: '1234'
    role: 'db'
    Compliance: 'PCI'
  } 
  
  {
    namePrefix: 'Ticketing-Dev-Web5'
    computerName: 'Ticketing-Dev-Web5'
    nsg: 'nsg-ticket-dev-web5'
    ipAddress: '10.50.2.101'
    vnet: 'vnetB'
    subnet: 'subnet2'
    env: 'Dev'
    app: 'Ticketing'
    BizUnit: '5555'
    role: 'web'
    Compliance: 'none'
  }
  {
    namePrefix: 'Ticketing-Dev-Proc5'
    computerName: 'Ticketing-Dev-Proc5'
    nsg: 'nsg-ticket-dev-proc5'
    ipAddress: '10.50.2.102'
    vnet: 'vnetB'
    subnet: 'subnet2'
    env: 'Dev'
    app: 'Ticketing'
    BizUnit: '5555'
    role: 'proc'
    Compliance: 'none'
  }
  {
    namePrefix: 'Ticketing-Dev-DB5'
    computerName: 'Ticketing-Dev-DB5'
    nsg: 'nsg-ticket-dev-db5'
    ipAddress: '10.50.2.103'
    vnet: 'vnetB'
    subnet: 'subnet2'
    env: 'Dev'
    app: 'Ticketing'
    BizUnit: '5555'
    role: 'db'
    Compliance: 'none'
  }
  {
    namePrefix: 'Ticketing-Staging-Web5'
    computerName: 'Ticketing-Staging-Web5'
    nsg: 'nsg-ticket-staging-web5'
    ipAddress: '10.40.1.101'
    vnet: 'vnetA'
    subnet: 'subnet1'
    env: 'Staging'
    app: 'Ticketing'
    BizUnit: '6789'
    role: 'web'
    Compliance: 'none'
  }
  {
    namePrefix: 'Ticketing-Staging-Proc5'
    computerName: 'Ticketing-Staging-Proc5'
    nsg: 'nsg-ticket-staging-proc5'
    ipAddress: '10.40.1.102'
    vnet: 'vnetA'
    subnet: 'subnet1'
    env: 'Staging'
    app: 'Ticketing'
    BizUnit: '6789'
    role: 'proc'
    Compliance: 'none'
  }
  {
    namePrefix: 'Ticketing-Staging-DB5'
    computerName: 'Ticketing-Staging-DB5'
    nsg: 'nsg-ticket-staging-db5'
    ipAddress: '10.40.1.103'
    vnet: 'vnetA'
    subnet: 'subnet1'
    env: 'Staging'
    app: 'Ticketing'
    BizUnit: '6789'
    role: 'db'
    Compliance: 'none'
  }
]


var netint = 'nic'

resource vmName_resource 'Microsoft.Compute/virtualMachines@2020-06-01' = [for (vmName, i) in vmNames: {
  name: vmName.namePrefix
  location: location
  tags: {

    Env:vmName.env
    App:vmName.app
    Biz:vmName.BizUnit
    Role:vmName.role
    Compliance:vmName.Compliance
  }
  properties: {
    osProfile: {
      computerName: vmName.computerName
      adminUsername: adminUsername
      adminPassword: adminPassword
      //The following customData is base64 encoded text that loads cronjobs, on individual VMs based on its hostname, to run some simple traffic flows
      //You can use a base64-to-text converter if you want to edit the cron entries
      customData: 'IyEvYmluL2Jhc2gK4oCLCnN1ZG8geXVtIGluc3RhbGwgdGVsbmV0IC15CuKAiwppZiBbIGAvdXNyL2Jpbi9ob3N0bmFtZWAgPT0gIlRpY2tldGluZy1Qcm9kLVdlYjUiIF0KdGhlbiAKCXN1ZG8geXVtIGluc3RhbGwgdGVsbmV0IC15CiAgICAgICAgKGNyb250YWIgLWwgMj4vZGV2L251bGwgfHwgZWNobyAiIjsgZWNobyAiKi81ICogKiAqICogIHRlbG5ldCAxMC40MC4wLjEwNyA1MDAwID4+IC90bXAvUHJvYy5sb2ciKSB8IGNyb250YWIgLQogICAgICAgIChjcm9udGFiIC1sIDI+L2Rldi9udWxsIHx8IGVjaG8gIiI7IGVjaG8gIiovNSAqICogKiAqICB0ZWxuZXQgMTAuNDAuMC4xMDYgNDQzID4+IC90bXAvUHJvYy5sb2ciKSB8IGNyb250YWIgLQrigIsKZmkK4oCLCuKAiwppZiBbIGAvdXNyL2Jpbi9ob3N0bmFtZWAgPT0gIlRpY2tldGluZy1Qcm9kLVdlYjYiIF0KdGhlbiAKCXN1ZG8geXVtIGluc3RhbGwgdGVsbmV0IC15CiAgICAgICAgKGNyb250YWIgLWwgMj4vZGV2L251bGwgfHwgZWNobyAiIjsgZWNobyAiKi81ICogKiAqICogIHRlbG5ldCAxMC40MC4wLjEwNyA1MDAwID4+IC90bXAvUHJvYy5sb2ciKSB8IGNyb250YWIgLQogICAgICAgIChjcm9udGFiIC1sIDI+L2Rldi9udWxsIHx8IGVjaG8gIiI7IGVjaG8gIiovNSAqICogKiAqICB0ZWxuZXQgMTAuNDAuMC4xMDUgNDQzID4+IC90bXAvUHJvYy5sb2ciKSB8IGNyb250YWIgLQrigIsKZmkK4oCLCuKAiwrigIsKaWYgWyBgL3Vzci9iaW4vaG9zdG5hbWVgID09ICJUaWNrZXRpbmctUHJvZC1Qcm9jNSIgXQp0aGVuIAoJc3VkbyB5dW0gaW5zdGFsbCB0ZWxuZXQgLXkKICAgICAgICAoY3JvbnRhYiAtbCAyPi9kZXYvbnVsbCB8fCBlY2hvICIiOyBlY2hvICIqLzUgKiAqICogKiAgdGVsbmV0IDEwLjQwLjAuMTA4IDMzMDYgPj4gL3RtcC9Qcm9jLmxvZyIpIHwgY3JvbnRhYiAtCiAgICAgICAgKGNyb250YWIgLWwgMj4vZGV2L251bGwgfHwgZWNobyAiIjsgZWNobyAiKi81ICogKiAqICogIHRlbG5ldCAxMC40MC4wLjQgMTQzMyA+PiAvdG1wL1Byb2MubG9nIikgfCBjcm9udGFiIC0KICAgICAgICAoY3JvbnRhYiAtbCAyPi9kZXYvbnVsbCB8fCBlY2hvICIiOyBlY2hvICIqLzUgKiAqICogKiAgdGVsbmV0IDEwLjQwLjAuMTA5IDMzMDYgPj4gL3RtcC9Qcm9jLmxvZyIpIHwgY3JvbnRhYiAtCmZpCuKAiwrigIsKaWYgWyBgL3Vzci9iaW4vaG9zdG5hbWVgID09ICJUaWNrZXRpbmctRGV2LVdlYjUiIF0KdGhlbiAKCXN1ZG8geXVtIGluc3RhbGwgdGVsbmV0IC15CiAgICAgICAgKGNyb250YWIgLWwgMj4vZGV2L251bGwgfHwgZWNobyAiIjsgZWNobyAiKi81ICogKiAqICogIHRlbG5ldCAxMC41MC4yLjEwMiA1MDAwID4+IC90bXAvUHJvYy5sb2ciKSB8IGNyb250YWIgLQogICAgICAgIChjcm9udGFiIC1sIDI+L2Rldi9udWxsIHx8IGVjaG8gIiI7IGVjaG8gIiovNSAqICogKiAqICB0ZWxuZXQgMTAuNDAuMS4xMDMgMzMwNiA+PiAvdG1wL1Byb2MubG9nIikgfCBjcm9udGFiIC0KZmkK4oCLCuKAiwppZiBbIGAvdXNyL2Jpbi9ob3N0bmFtZWAgPT0gIlRpY2tldGluZy1TdGFnaW5nLVdlYjUiIF0KdGhlbiAKCXN1ZG8geXVtIGluc3RhbGwgdGVsbmV0IC15CiAgICAgICAgKGNyb250YWIgLWwgMj4vZGV2L251bGwgfHwgZWNobyAiIjsgZWNobyAiKi81ICogKiAqICogIHRlbG5ldCAxMC40MC4wLjEwOSAzMzA2ID4+IC90bXAvUHJvYy5sb2ciKSB8IGNyb250YWIgLQogICAgICAgIChjcm9udGFiIC1sIDI+L2Rldi9udWxsIHx8IGVjaG8gIiI7IGVjaG8gIiovNSAqICogKiAqICB0ZWxuZXQgMTAuNDAuMS4xMDIgNTAwMCA+PiAvdG1wL1Byb2MubG9nIikgfCBjcm9udGFiIC0K4oCLCmZp'
    }
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'OpenLogic'
        offer: 'CentOS'
        sku: '8_5-gen2'
        version: 'latest'
      }
      
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: []
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: nic[i].id
        }
      ]
    }
  }
  dependsOn: [
    vnetA
    vnetB
  ]
}
]
resource publicip 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: publicipname
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}
resource natgateway 'Microsoft.Network/natGateways@2021-05-01' = {
  name: natgatewayname
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    idleTimeoutInMinutes: 4
    publicIpAddresses: [
      {
        id: publicip.id
      }
    ]
  }
}

resource vnetA 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: 'vnetA'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.40.0.0/22'
      ]
    }
    subnets: [
      {
        name: 'subnet0'
        properties: {
          addressPrefix: '10.40.0.0/24'
          privateEndpointNetworkPolicies: 'Enabled'
          natGateway: {
            id: natgateway.id
          }
        }
      }
      {
        name: 'subnet1'
        properties: {
          addressPrefix: '10.40.1.0/24'
          natGateway: {
            id: natgateway.id
          }
        }
      }
    ]

  }
}
 
resource vnetB 'Microsoft.Network/virtualNetworks@2020-06-01' = {
    name: 'vnetB'
    location: location
    properties: {
      addressSpace: {
        addressPrefixes: [
          '10.50.0.0/22'
        ]
      }
      subnets: [
        {
          name: 'subnet2'
          properties: {
            addressPrefix: '10.50.2.0/24'
          }
        }
      ]
    }
}

resource peerA 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  parent: vnetA
  name: 'vnetA-to-vnetB'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnetB.id
    }
  }
}

resource peerB 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  parent: vnetB
  name: 'vnetB-to-vnetA'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnetA.id
    }
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2020-06-01' = [for (myVM, i) in vmNames: {
  name: '${netint}${i}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', myVM.vnet, myVM.subnet)

          }
          privateIPAllocationMethod:'Static'
          privateIPAddress: myVM.ipAddress

        }
      }
    ]
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', myVM.nsg)
    }
  }
  dependsOn: [
    vnetA
    vnetB
    networkSecurityGroup
  ]
}]

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-05-01' = [for myNSG in vmNames: {
  name: myNSG.nsg
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}]



@description('The name of the SQL logical server.')
param serverName string = uniqueString('sql', resourceGroup().id)

@description('The name of the SQL Database.')
param sqlDBName string = 'SampleDB'

var PrivateEndpointName1 = 'db-pe-1'
//var PrivateEndpointName2 = 'cosmos-pe-1'

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: PrivateEndpointName1
  location: location
  properties: {
    subnet: {
     id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'vnetA', 'subnet0')
    }
    ipConfigurations: [
      {
        name: 'db-pe-1'
        properties: {
          memberName: 'sqlServer'
          groupId: 'sqlServer'
          privateIPAddress: '10.40.0.4'
        }
      }
    ]
    privateLinkServiceConnections: [
      {
        name: PrivateEndpointName1
        properties: {
          privateLinkServiceId: sqlServer.id
          groupIds: [
            'sqlServer'
          ]
        }
      }
    ]
  }
  dependsOn: [
    vnetA
  ]
}

/*
// I'm commenting out this Cosmos DB as it takes 10 minutes to deploy...

resource privateEndpoint2 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: PrivateEndpointName2
  location: location
  properties: {
    subnet: {
     id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'vnetA', 'subnet0')
    }
    
    
    // for some reason i cant use static ip on this private endpoint, not sure why
     
    //ipConfigurations: [
     // {
      //  name: 'db-pe-2'
      //  properties: {
      //    //memberName: 'Sql'
      //    memberName: accountName
      //    groupId: 'Sql'
      //    privateIPAddress: '10.50.0.5'
      //  }
      //}
      //  "message": "Private Endpoint /subscriptions/92e7ed99-799a-4807-b9a4-36b86b4b8119/resourceGroups/logs9/providers/Microsoft.Network/privateEndpoints/cosmos-pe-1 
      // contains static ipconfigurations: [PrivateIPAddress: 10.40.0.5, GroupId: Sql, MemberName: Sql] and its missing these membernames/groupids requested by Private Link service 
      // [GroupId: Sql, MemberName: cosmos-tajbf4sblovti; GroupId: Sql, MemberName: cosmos-tajbf4sblovti-eastus2]. Private Endpoint needs to be reconfigured with missing memberNames.",
      //         "code": "PrivateEndpointIpConfigurationMissingMemberNamesRequiredByFps",

    //]
    
    privateLinkServiceConnections: [
      {
        name: PrivateEndpointName2
        properties: {
          privateLinkServiceId: account.id
          groupIds: [
            'Sql'
          ]
        }
      }
    ]
  }
  dependsOn: [
    vnetA
  ]
}
*/

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: serverName
  location: location
  properties: {
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: sqlServer
  name: sqlDBName
  location: location
  sku: {
    name: 'GP_S_Gen5_1'
    tier: 'GeneralPurpose'
  }
}

/*
@description('Cosmos DB account name')
param accountName string = 'cosmos-${uniqueString(resourceGroup().id)}'

@description('The name for the SQL API database')
param databaseName string ='randomstring'

resource account 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' = {
  //name: toLower(accountName)
  name: accountName
  location: location
  //kind: 'MongoDB'
  kind: 'GlobalDocumentDB'
  properties: {
    //enableFreeTier: true
    databaseAccountOfferType: 'Standard'
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    publicNetworkAccess: 'Disabled'
    locations: [
      {
        locationName: location
      }
    ]
  }
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-05-15' = {
  parent: account
  name: databaseName
  properties: {
    resource: {
      id: databaseName
    }
  }
}

*/
