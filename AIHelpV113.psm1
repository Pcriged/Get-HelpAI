#API requests handeler 
function Get-HelpAI_API {
    param (
        [string]$system,
        [string]$prompt,
		[string]$mod = "llama3.1"
    )
#replace with your api endpoint
    $url = "http://localhost:11434/api/generate"
    $body = @{
        model  = "$($model)"
        prompt = "$($system) $($prompt)"
        stream = $false
    } | ConvertTo-Json

    try {
        Invoke-WebRequest -Uri $url -Method Post -Body $body -ContentType 'application/json' |
        ForEach-Object { $_.Content | ConvertFrom-Json }
    } catch {
        Write-Error "An error occurred: $($Error[0].Message)"
    }
}
#Basic info request on the topic of the users choosing -SystemPrompt to chnage the nature of the Ai's response
function Get-HelpAI {
    param (
        [string]$SystemPrompt = "You are the AI help agent for a powershell terminal. You can help the user with anything, but your primary function is helping the user With powershell commands and scripting.",
        [string]$model = "llama3.1",
		[bool]$bash = $false
     )
	 if($bash){
       $SystemPrompt = "You will respond back to the users following request with only a bash command, no comments, explanations, or formating. The request is:"
	}	
    
    $p = Read-Host "How can I assist you?"
    $response = Get-HelpAI_API -prompt $p -system $SystemPrompt -mod $model
    Write-Host "$($response.response)"
}
#Sends request and returns a PS command matching the users request to clipboard
# v113 gave bash support for powershell in linux -bash true
function Get-HelpAI_CopyCommand {
   param (
        [string]$SystemPrompt = "You will respond back to the users following request with only a powershell command, no comments, explanations, or formating. The request is:",
        [bool]$bash = $false,
		[string]$model = "llama3.1"
    )

    $p = Read-Host "How can I assist you?"
    if($bash){
       $SystemPrompt = "You will respond back to the users following request with only a bash command, no comments, explanations, or formating. The request is:"
	}	
    $response = Get-HelpAI_API -prompt $p -system $SystemPrompt -model = $model
    Write-Host "$($response.response)"
    Set-Clipboard $response.response
}
#Expermental: give control to a guided AI session. !Use at your own risk! Under devlopment
function Expermental_AI_Pilot {
    param (
        [string]$SystemPrompt = "You will respond back to the users following request with only a powershell command, no comments, explanations, or formating. The request is:",
        [bool]$bash = $false,
		[string]$model = "llama3.1"
    )

    $p = Read-Host "How can I assist you?"
    if($bash){
       $SystemPrompt = "You will respond back to the users following request with only a bash command, no comments, explanations, or formating. The request is:"
	}	
    $response = Get-HelpAI_API -prompt $p -system $SystemPrompt -model = $model
    Write-Host "$($response.response)"
    
    
    do{
      $Command = $response.response
      $output = Invoke-Expression -Command $command
      Write-Host $output
      $debug = Read-Host "Debug? y to Debug anything else to continue"
      if($debug -eq "y"){
    	 $History = "The command was $($Command) and the output was $($output)"
    	 $Feedback = Read-Host "What is your concern with how this exicuted?"
    	 $SystemPrompt = "The user needs help with a command: $($History). The users concern was$($Feedback).
	     Please adresss the concern: You will respond back to the users concern with only a powershell command, no comments, explanations, or formating."
	 $response = Get-HelpAI_API  -system $SystemPrompt
         Write-Host "$($response.response)"
	
        }
  }while($debug -eq "y")
}

Export-ModuleMember -Function Get-HelpAI
Export-ModuleMember -Function Get-HelpAI_CopyCommand
Export-ModuleMember -Function Expermental_AI_Pilot