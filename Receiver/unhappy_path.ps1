function swapinuser( $username )
{    
    $null = & "C:\Program Files (x86)\Citrix\CtxCredApiSample.exe" -l -u $username -p citrix -d xa.local
    Write-Host "Logged On $username." -ForegroundColor Cyan
    dropAuth 
    ipoll    
    logoff -username $username
}

function swapinbaduser( $username )
{   
    Write-host "Logged in as Non-VDA user(no creds)" -ForegroundColor Red
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
    swapinuser -username $username   
    simulateWorkstationLock -secs 1
}

function FirstTimeLogOff()
{
    Write-Host "Performing first-time logoff" -ForegroundColor Yellow
    logoff
}


FirstTimeLogOff

$array = 1..20

foreach( $i in $array )
{
 
    doFullSwap -username "user2"
 
    doFullSwap -username "user8"
    
    
    if ( [bool]!($i%2) )
    {  
        swapinbaduser -username "bad" 
    }
    
    
    
        
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

