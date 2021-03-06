#Requires -Version 4.0
# Requires -Modules VMware.PowerCLI

<#
.SYNOPSIS
    Retrieves distributed port groups

.DESCRIPTION

.NOTES
    This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
    The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
    The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
    the use and the consequences of the use of this freely available script.
    PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
    © ScriptRunner Software GmbH

.COMPONENT
    Requires Module VMware.PowerCLI

.LINK
    https://github.com/scriptrunner/ActionPacks/tree/master/VMware/Network

.Parameter VIServer
    Specifies the IP address or the DNS name of the vSphere server to which you want to connect

.Parameter VICredential
    Specifies a PSCredential object that contains credentials for authenticating with the server

.Parameter GroupName
    Specifies the name of the distributed port group that you want to retrieve, is the parameter empty all distributed port groups retrieved

.Parameter GroupID
    Specifies the ID of the distributed port group that you want to retrieve
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true,ParameterSetName = "ByName")]
    [Parameter(Mandatory = $true,ParameterSetName = "ByID")]
    [string]$VIServer,
    [Parameter(Mandatory = $true,ParameterSetName = "ByName")]
    [Parameter(Mandatory = $true,ParameterSetName = "ByID")]
    [pscredential]$VICredential,
    [Parameter(ParameterSetName = "ByName")]
    [string]$GroupName,
    [Parameter(Mandatory = $true,ParameterSetName = "ByID")]    
    [string]$GroupID
)

Import-Module VMware.PowerCLI

try{
    $Script:vmServer = Connect-VIServer -Server $VIServer -Credential $VICredential -ErrorAction Stop
    
    if($PSCmdlet.ParameterSetName  -eq "ByName"){
        if([System.String]::IsNullOrWhiteSpace($SwitchName) -eq $true){
            $Script:Output = Get-VDPortgroup -Server $Script:vmServer -ErrorAction Stop | Select-Object *
        }
        else {
            $Script:Output = Get-VDPortgroup -Server $Script:vmServer -Name $GroupName -ErrorAction Stop | Select-Object *            
        }
    }   
    else {
        $Script:Output = Get-VDPortgroup -Server $Script:vmServer -Id $GroupID -ErrorAction Stop | Select-Object *
    }

    if($SRXEnv) {
        $SRXEnv.ResultMessage = $Script:Output 
    }
    else{
        Write-Output $Script:Output
    }
}
catch{
    throw
}
finally{    
    if($null -ne $Script:vmServer){
        Disconnect-VIServer -Server $Script:vmServer -Force -Confirm:$false
    }
}