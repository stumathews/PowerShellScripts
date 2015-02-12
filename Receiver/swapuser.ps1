function swapinuser( $username )
{
    Write-Host "* Switching in user, $username..."
    & "C:\Program Files (x86)\Citrix\CtxCredApiSample.exe" -l -u $username -p citrix -d xa.local
    dropAuth 
    ipoll
}

function dropAuth()
{
    Write-host "* Dropping SSP credentials via Authman reset"
    & "C:\Program Files (x86)\Citrix\SelfServicePlugin\SelfService.exe" -terminate
}

function ipoll()
{
    Write-Host "* Performing interactive poll"
    & "C:\Program Files (x86)\Citrix\SelfServicePlugin\SelfService.exe" -ipoll
}

function logoff()
{
    Write-Host "Logging off user"
    & "C:\Program Files (x86)\Citrix\CtxCredApiSample.exe" -s
    Write-Host "There should be no pending http activity now"
}

$array = 1..10

foreach( $i in $array )
{

    swapinuser -username "user1"
    logoff


    swapinuser -username "user2"
    logoff
    
    <#

    if ( [bool]!($i%2) )
    {
        Write-Host "###Inserting bad creds##"
       
        swapinuser -username "bad"         
        logoff
        Write-Host "Waiting 5 secs for prompt before dismissing via -terminate"
        Start-Sleep -s 5
        Start-Job -ScriptBlock { Write-host "** Dropping SSP credentials via Authman reset"
                                 & "C:\Program Files (x86)\Citrix\SelfServicePlugin\SelfService.exe" -terminate | out-null  
                                } | Wait-Job
        Write-Host "job done"
        Get-Command

    
    }
    #>    
}

