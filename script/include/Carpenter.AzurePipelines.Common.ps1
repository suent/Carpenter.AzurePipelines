function IsNumeric {
 
<#   
.SYNOPSIS   
    Analyse whether input value is numeric or not
   
.DESCRIPTION   
    Allows the administrator or programmer to analyse if the value is numeric value or 
    not.
     
    By default, the return result value will be in 1 or 0. The binary of 1 means on and 
    0 means off is used as a straightforward implementation in electronic circuitry 
    using logic gates. Therefore, I have kept it this way. But this IsNumeric cmdlet 
    will return True or False boolean when user specified to return in boolean value 
    using the -Boolean parameter.
 
.PARAMETER Value
     
    Specify a value
 
.PARAMETER Boolean
     
    Specify to return result value using True or False
 
.EXAMPLE
    Get-ChildItem C:\Windows\Logs | where { $_.GetType().Name -eq "FileInfo" } | Select -ExpandProperty Name | IsNumeric -Verbose
    DirectX.log
    VERBOSE: False
    0
    IE9_NR_Setup.log
    VERBOSE: False
    0
 
    The default return value is 0 when we attempt to get the files name through the 
    pipeline. You can see the Verbose output stating False when you specified the 
    -Verbose parameter
 
.EXAMPLE
    Get-ChildItem C:\Windows\Logs | where { $_.GetType().Name -eq "FileInfo" } | Select -ExpandProperty Length | IsNumeric -Verbose
    119155
    VERBOSE: True
    1
    2740
    VERBOSE: True
    1
     
    The default return value is 1 when we attempt to get the files length through the 
    pipeline. You can see the Verbose output stating False when you specified the 
    -Verbose parameter
         
.EXAMPLE
    $IsThisNumbers? = ("1234567890" | IsNumeric -Boolean) ; $IsThisNumbers?
    True
     
    The return value is True for the input value 1234567890 because we specified the 
    -Boolean parameter
     
.EXAMPLE    
    $IsThisNumbers? = ("ABCDEFGHIJ" | IsNumeric -Boolean) ; $IsThisNumbers?
    False
 
    The return value is False for the input value ABCDEFGHIJ because we specified the 
    -Boolean parameter
 
.NOTES   
    Author  : Ryen Kia Zhi Tang
    Date    : 20/07/2012
    Blog    : ryentang.wordpress.com
    Version : 1.0
     
#>
 
[CmdletBinding(
    SupportsShouldProcess=$True,
    ConfirmImpact='High')]
 
param (
 
[Parameter(
    Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True)]
     
    $Value,
     
[Parameter(
    Mandatory=$False,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True)]
    [alias('B')]
    [Switch] $Boolean
     
)
     
BEGIN {
 
    #clear variable
    $IsNumeric = 0
 
}
 
PROCESS {
 
    #verify input value is numeric data type
    try { 0 + $Value | Out-Null
    $IsNumeric = 1 }catch{ $IsNumeric = 0 }
 
    if($IsNumeric){ 
        $IsNumeric = 1
        if($Boolean) { $Isnumeric = $True }
    }else{ 
        $IsNumeric = 0
        if($Boolean) { $IsNumeric = $False }
    }
     
    if($PSBoundParameters['Verbose'] -and $IsNumeric) { 
    Write-Verbose "True" }else{ Write-Verbose "False" }
     
    
    return $IsNumeric
}
 
END {}
 
} #end of #function IsNumeric

Function Write-ScriptHeader {
	param(
		[string] $Name
	)
	Write-Verbose "$Name"
}

Function Set-CarpenterVariable {
	param(
		[string] $OutputVariableName,
		[string] $VariableName,
		[object] $Value
	)
	If ($VariableName) {
		Write-Verbose "$($VariableName): $Value"
		Write-Host "##vso[task.setvariable variable=$VariableName]$Value" 
	} elseif ($OutputVariableName) {
		Write-Verbose "$($OutputVariableName): $Value"
	}
	if ($OutputVariableName) { Write-Host "##vso[task.setvariable variable=$OutputVariableName;isOutput=true]$Value" }
	return $Value
}

Function Write-PipelineError {
	param(
		[string] $Message
	)
    Write-Host "##vso[task.logissue type=error]$Message"
	Throw $Message
}

Function Write-PipelineWarning {
	param(
		[string] $Message
	)
    Write-Host "##vso[task.logissue type=warning]$Message"
	Write-Warning $Message
}

Function Get-NextCounterValue {
	[CmdletBinding()]
	param(
		[string] $Key,
        [int] $Offset = 0
	)

	if (-Not ($Key)) {
		Write-PipelineError "Key parameter must be supplied."
	}
    $baseUri = "https://counter-dev.azurewebsites.net/Counter"
    $uri = "$($baseUri)?Key=$($Key)&Offset=$($Offset)"

    $response = Invoke-RestMethod -Uri $uri -Method Post -Verbose:$false
    return $response.Count
}
