param vmNames array
param networkWatcherName string
param location string
param storageId string
param retentionDays int
param flowLogsVersion int

// the nsg is being created in a different RG
param nsgRgName string

resource networkWatcher 'Microsoft.Network/networkWatchers@2022-01-01' = {
  //resource networkWatcher 'Microsoft.Network/networkWatchers@2022-01-01' existing = {
  name: networkWatcherName
  location: location
  properties: {}
}

// re-establish reference to NSGs via "existing"
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-05-01' existing = [for myNSG in vmNames: {
  name: myNSG.nsg
  scope: resourceGroup(nsgRgName)
}]

resource flowLog 'Microsoft.Network/networkWatchers/flowLogs@2022-01-01' = [for (myNSG, i) in vmNames: {

  parent:  networkWatcher
  name: '${myNSG.nsg}-log'
  location: location
  properties: {

    targetResourceId: networkSecurityGroup[i].id

    storageId: storageId
    enabled: true
    retentionPolicy: {
      days: retentionDays
      enabled: true
    }
    format: {
      type: 'JSON'
      version: flowLogsVersion
    }
  }
}]
