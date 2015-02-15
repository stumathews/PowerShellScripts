function swapinuser( $username, [bool] $doIpoll, [bool] $doLogOff, $sessionDuration )
{    
    $null = & "C:\Program Files (x86)\Citrix\CtxCredApiSample.exe" -l -u $username -p citrix -d xa.local
    Write-Host "Logged On $username." -ForegroundColor Cyan
    dropAuth 
    if( $doIpoll -eq $true )
    {
        ipoll
    }

    Start-Sleep -s $sessionDuration

    if( $doLogOff -eq $true )
    {
        logoff -username $username
    }
}

function swapinnocreds()
{
    Write-host "Logged in as Non-VDA user(no creds)" -ForegroundColor Red
    $test = Read-Host "Continue?"
}

function swapinbaduser( $username )
{   
    swapinuser -username $username -doIpoll $false -doLogOff $false -sessionDuration 0
    Write-host "Logged in as Non-VDA user(bad creds)" -ForegroundColor Red
    $test = Read-Host "Continue?"
}

function dropAuth()
{
    $null = & "C:\Program Files (x86)\Citrix\SelfServicePlugin\SelfService.exe" -terminate
}

function ipoll()
{    
    $null = & "C:\Program Files (x86)\Citrix\SelfServicePlugin\SelfService.exe" -ipoll
    #Write-Host "* Interactive poll started. Expecting to wait until this is done."
}

function logoff($username)
{

    $null = & "C:\Program Files (x86)\Citrix\CtxCredApiSample.exe" -s
    Write-Host "Logged Off $username." -ForegroundColor Green
}

function simulateWorkstationLock( $secs )
{
    Start-Sleep -Seconds $secs
}

function doFullSwap($username)
{
    $sw = [Diagnostics.Stopwatch]::StartNew()

    swapinuser -username $username -doIpoll $true -doLogOff $true -sessionDuration 3
    
    $sw.Stop()
    $secs = $sw.Elapsed.Seconds
    Write-Host "Session lasted $secs sec" -ForegroundColor Yellow 
    simulateWorkstationLock -secs 1
}

function FirstTimeLogOff()
{
    Write-Host "Performing first-time logoff" -ForegroundColor Yellow
    logoff
}


#FirstTimeLogOff

$array = 1..20

foreach( $i in $array )
{
 
    doFullSwap -username "user2"    
    
    <# Randomely swap in a bad user
    $random = Get-Random -minimum 1 -maximum 1000
    if ( [bool]!($random%2) )
    {  
        swapinnocreds
    }
    #>
    #swapinnocreds
    swapinbaduser -username "bad"
    doFullSwap -username "user8"
    
    
    
        
}


    #$done = Read-host "Are you ready"

<#
    # 5 apps
    swapinuser -username "user1"
    logoff

    # 11 apps
    swapinuser -username "user2"
    logoff

    # user3 has too many apps
    #swapinuser -username "user3"
    #logoff

    # 20 apps
    swapinuser -username "user4"
    logoff
    
    # 6 apps
    swapinuser -username "user5"
    logoff

    # 20 apps
    swapinuser -username "user6"
    logoff

    # 40 apps
    swapinuser -username "user7"
    logoff

     # 80 apps
    swapinuser -username "user8"
    logoff

    # 100 apps
    swapinuser -username "user9"
    logoff
    
    #>

