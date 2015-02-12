. .\useful_functions.ps1

function Get-IsTrusted($RemoteComputerName)
{
    $trusted_hosts = (Get-Item WSMan:\localhost\Client\TrustedHosts).Value

    if( $trusted_hosts.Contains($RemoteComputerName) -eq $true )
    {       

        return [bool]$true;
    }
    else
    {
        return [bool]$false;
    }
}

#Trap [SystemException] { "Could not create remote session: $error, $StackTrace" ; continue }
function CreateRemoteSession($RemoteComputerName)
{

    if( (Get-IsTrusted($RemoteComputerName)) -eq $false)
    {
        Write-Host "Won't connect to host that is not trusted. Add it to trusted hosts."
        return
    }
    
    $remote_session = New-PSSession -ComputerName $RemoteComputerName -authentication Default -credential (Get-Credential)
    return $remote_session
        
}

function EnterRemoteSession($session)
{
    Enter-PSSession -Session $session
}


function EndRemoteSession($Session)
{
    Remove-PSSession -Session $Session
}

function InvokeCommandOnRemote()
{
    [cmdletbinding(SupportsShouldProcess=$True)]
    param(
        [parameter(Mandatory=$true)]
        $Session,

        [parameter(Mandatory=$true)] 
        [string] $scriptBlock 
        )

    if( $args.Count -gt 0 ) { Write-Error "unhandled arguments supplied"} #$args is eveyrthing else after the 2 arguments I expect.


    $block = [ScriptBlock]::Create($scriptBlock)

    Write-Verbose "Invoking command, $block on remote host $Session.ComputerName"

    $result = Invoke-Command -Session $Session -ScriptBlock $block
    
    return $result
}


