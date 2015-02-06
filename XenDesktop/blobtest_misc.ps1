function New-DummyMachineConfiguration()
{
    [cmdletbinding()]
    param(     
            [parameter(Mandatory=$true,ValueFromPipeline=$false)]       
            $slotname,
            [parameter(Mandatory=$true,ValueFromPipeline=$false)]
            $leafName,
            [parameter(Mandatory=$true,ValueFromPipeline=$false)]
            $deliveryGroup
        )

    if($args.count -gt 0) {Write-Error "unhandled arguments supplied"}
    
    # get the default configuration slot for appv
    $config = Get-BrokerMachineConfiguration -Name "AppV\1"
    if( $config -eq $null )
    {
        Write-Host "Could not get the default configuration slot for appv. Add app-v servers to your xendesktop installation via studio"
        return
    }

    $AvailDeliveryGroups  = @(Get-BrokerDesktopGroup | select -ExpandProperty Name)
    if( $AvailDeliveryGroups -notcontains $deliveryGroup )
    {
        Write-Host "Could not find a delivery group that matches the provided group, $deliveryGroup"
        Write-Host "No changes have been persisted."

        return
    }

    Write-Verbose "# get default app-v server's machine configuration value(policy object)"
    $defaultAppVPolicy = $config.Policy

    Write-Verbose "
    # Make a new configuration slot based off the 
    # original one's policy object, specify SettingsGroup as G=AppV"
    $newslot = New-BrokerConfigurationSlot -Name $slotName -SettingsGroup "G=AppV" -Description "Dummy AppV Slot"

    Write-Verbose "# now get what uid for the slot I just created"
    $uid = (Get-BrokerConfigurationSlot -Name $slotName).Uid

    if( $uid -eq $null){ Write-Error "No default AppV Uid could be found" }

    Write-Verbose "# now populate the new slot(refer to it by uid) by creating a machine configuration for it,
                   # setting it to the same value as the original one's value (policy object)"    
    $mc = New-BrokerMachineConfiguration -ConfigurationSlotUid $uid -LeafName $leafName -Policy $defaultAppVPolicy
    $mc | Add-BrokerMachineConfiguration -DesktopGroup $deliveryGroup

    #Set-BrokerMachineConfiguration -InputObject $mc
    
    #we can set this machineconfiguration to an existing policy but this was already done on create
    #Set-BrokerMachineConfiguration -Policy $config.Policy -Name "$slotName\$leafName"
}

function Show-DummySlot
{
    Get-BrokerConfigurationSlot | where-object {$_.Description -eq "Dummy AppV Slot"}
}

function Show-DummyConfiguration
{
    Get-BrokerMachineConfiguration | Where-Object {$_.Description -ne "Created by Studio"}
}

function Remove-DummySlot()
{
    Get-BrokerConfigurationSlot | where {$_.Description -eq "Dummy AppV Slot"} | Remove-BrokerConfigurationSlot
}

function Remove-DummyConfiguration()
{
 Get-BrokerMachineConfiguration | where-object {$_.Description -ne "Created by Studio"} | Remove-BrokerMachineConfiguration
}

function Remove-DummyStuff()
{
    Remove-DummyConfiguration
    Remove-DummySlot

}

function Add-DummyData
{
    [cmdletbinding()]
    param (     
        [parameter(Mandatory=$true,ValueFromPipeline=$false)]
        $StartNumber,
        [parameter(Mandatory=$true,ValueFromPipeline=$false)]
        $EndNumber,
        [parameter(Mandatory=$true,ValueFromPipeline=$false)]
        $DeliveryGroupName
    )

    if($args.count -gt 0) {Write-Error "unhandled arguments supplied"}

    $max = $StartNumber..$EndNumber

    ForEach( $i in $max )
    {    
        New-DummyMachineConfiguration -slotname "Test$i" -leafName "Dummy$i" -deliveryGroup $DeliveryGroupName
        Write-Host "Test$i created."

    }
    
    Write-Host "$max. items created."

}