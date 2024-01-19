@description('VM size')
param vmSize string = 'Standard_B1s'
param location string = resourceGroup().location
param adminUsername string
@secure()
param adminPassword string

@description('Virtual network name')
param vnetName string = 'trial-vnet1'

// You can edit this list of VMs to suit your needs. The script will loop through however many entries here to create VMs.
var vmNames = [
  {
    namePrefix: 'Ticketing-Prod-Web5'
    computerName: 'Ticketing-Prod-Web5'
    nsg: 'nsg-ticket-prod-web5'
    ipAddress: '10.40.0.105'
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
    ipAddress: '10.40.1.101'
    subnet: 'subnet1'
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
    ipAddress: '10.40.1.102'
    subnet: 'subnet1'
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
    ipAddress: '10.40.1.103'
    subnet: 'subnet1'
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
    ipAddress: '10.40.2.101'
    subnet: 'subnet2'
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
    ipAddress: '10.40.2.102'
    subnet: 'subnet2'
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
    ipAddress: '10.40.2.103'
    subnet: 'subnet2'
    env: 'Staging'
    app: 'Ticketing'
    BizUnit: '6789'
    role: 'db'
    Compliance: 'none'
  }
]

var netint = 'trial-nic'
var subnet0Name = 'subnet0'
var subnet1Name = 'subnet1'
var subnet2Name = 'subnet2'

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
      customData:'IyEvYmluL2Jhc2gK4oCLCnN1ZG8geXVtIGluc3RhbGwgdGVsbmV0IC15CuKAiwppZiBbIGAvdXNyL2Jpbi9ob3N0bmFtZWAgPT0gIlRpY2tldGluZy1Qcm9kLVdlYjUiIF0KdGhlbiAKCXN1ZG8geXVtIGluc3RhbGwgdGVsbmV0IC15CiAgICAgICAgKGNyb250YWIgLWwgMj4vZGV2L251bGwgfHwgZWNobyAiIjsgZWNobyAiKi81ICogKiAqICogIHRlbG5ldCAxMC40MC4wLjEwNyA1MDAwID4+IC90bXAvUHJvYy5sb2ciKSB8IGNyb250YWIgLQogICAgICAgIChjcm9udGFiIC1sIDI+L2Rldi9udWxsIHx8IGVjaG8gIiI7IGVjaG8gIiovNSAqICogKiAqICB0ZWxuZXQgMTAuNDAuMC4xMDYgNDQzID4+IC90bXAvUHJvYy5sb2ciKSB8IGNyb250YWIgLQrigIsKZmkK4oCLCuKAiwppZiBbIGAvdXNyL2Jpbi9ob3N0bmFtZWAgPT0gIlRpY2tldGluZy1Qcm9kLVdlYjYiIF0KdGhlbiAKCXN1ZG8geXVtIGluc3RhbGwgdGVsbmV0IC15CiAgICAgICAgKGNyb250YWIgLWwgMj4vZGV2L251bGwgfHwgZWNobyAiIjsgZWNobyAiKi81ICogKiAqICogIHRlbG5ldCAxMC40MC4wLjEwNyA1MDAwID4+IC90bXAvUHJvYy5sb2ciKSB8IGNyb250YWIgLQogICAgICAgIChjcm9udGFiIC1sIDI+L2Rldi9udWxsIHx8IGVjaG8gIiI7IGVjaG8gIiovNSAqICogKiAqICB0ZWxuZXQgMTAuNDAuMC4xMDUgNDQzID4+IC90bXAvUHJvYy5sb2ciKSB8IGNyb250YWIgLQrigIsKZmkK4oCLCuKAiwrigIsKaWYgWyBgL3Vzci9iaW4vaG9zdG5hbWVgID09ICJUaWNrZXRpbmctUHJvZC1Qcm9jNSIgXQp0aGVuIAoJc3VkbyB5dW0gaW5zdGFsbCB0ZWxuZXQgLXkKICAgICAgICAoY3JvbnRhYiAtbCAyPi9kZXYvbnVsbCB8fCBlY2hvICIiOyBlY2hvICIqLzUgKiAqICogKiAgdGVsbmV0IDEwLjQwLjAuMTA4IDMzMDYgPj4gL3RtcC9Qcm9jLmxvZyIpIHwgY3JvbnRhYiAtCiAgICAgICAgKGNyb250YWIgLWwgMj4vZGV2L251bGwgfHwgZWNobyAiIjsgZWNobyAiKi81ICogKiAqICogIHRlbG5ldCAxMC40MC4wLjEwOSAzMzA2ID4+IC90bXAvUHJvYy5sb2ciKSB8IGNyb250YWIgLQpmaQrigIsK4oCLCmlmIFsgYC91c3IvYmluL2hvc3RuYW1lYCA9PSAiVGlja2V0aW5nLURldi1XZWI1IiBdCnRoZW4gCglzdWRvIHl1bSBpbnN0YWxsIHRlbG5ldCAteQogICAgICAgIChjcm9udGFiIC1sIDI+L2Rldi9udWxsIHx8IGVjaG8gIiI7IGVjaG8gIiovNSAqICogKiAqICB0ZWxuZXQgMTAuNDAuMC4xMDkgMzMwNiA+PiAvdG1wL1Byb2MubG9nIikgfCBjcm9udGFiIC0KICAgICAgICAoY3JvbnRhYiAtbCAyPi9kZXYvbnVsbCB8fCBlY2hvICIiOyBlY2hvICIqLzUgKiAqICogKiAgdGVsbmV0IDEwLjQwLjEuMTAyIDUwMDAgPj4gL3RtcC9Qcm9jLmxvZyIpIHwgY3JvbnRhYiAtCmZpCuKAiwrigIsKaWYgWyBgL3Vzci9iaW4vaG9zdG5hbWVgID09ICJUaWNrZXRpbmctU3RhZ2luZy1XZWI1IiBdCnRoZW4gCglzdWRvIHl1bSBpbnN0YWxsIHRlbG5ldCAteQogICAgICAgIChjcm9udGFiIC1sIDI+L2Rldi9udWxsIHx8IGVjaG8gIiI7IGVjaG8gIiovNSAqICogKiAqICB0ZWxuZXQgMTAuNDAuMS4xMDMgMzMwNiA+PiAvdG1wL1Byb2MubG9nIikgfCBjcm9udGFiIC0KICAgICAgICAoY3JvbnRhYiAtbCAyPi9kZXYvbnVsbCB8fCBlY2hvICIiOyBlY2hvICIqLzUgKiAqICogKiAgdGVsbmV0IDEwLjQwLjIuMTAyIDUwMDAgPj4gL3RtcC9Qcm9jLmxvZyIpIHwgY3JvbnRhYiAtCuKAiwpmaQ=='
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
          id: resourceId('Microsoft.Network/networkInterfaces', '${netint}${i}')
        }
      ]
    }
  }
  dependsOn: [
    vnet
    nic
  ]
}
]
resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.40.0.0/22'
      ]
    }
    subnets: [
      {
        name: subnet0Name
        properties: {
          addressPrefix: '10.40.0.0/24'
        }
      }
      {
        name: subnet1Name
        properties: {
          addressPrefix: '10.40.1.0/24'
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: '10.40.2.0/24'
        }
      }
    ]
  }
}
 resource nic 'Microsoft.Network/networkInterfaces@2020-06-01' = [for (mySubnet, i) in vmNames: {
  name: '${netint}${i}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, mySubnet.subnet)
          }
          privateIPAllocationMethod:'Static'
          privateIPAddress: mySubnet.ipAddress

        }
      }
    ]
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', mySubnet.nsg)
    }
  }
  dependsOn: [
    vnet
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

