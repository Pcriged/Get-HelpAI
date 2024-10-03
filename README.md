This is a basic powershell module that allows the user to request help from a localy or remotely hosted ollama instance.
Use in a session by using "Import-Module .\aihelpv113" from the containing folder or Import-Module .\<filepath>\aihelpv113 from another directory.
Get-helpAI is the basic single shot question and answer use case.
Get-helpAi_CopyCommand copys the LLMs best guess at the command that you are looking for to the clipboard.
Expermental_AI_Pilot Attempts to let the AI exicute commands automaticly - needs serious improvment at this stage. Would not reccomend using this on a non-sandbox enviroment. Will be replace with a version that uses proper chat history and the chat api endpoint. 

Goals I have: 
Enable a set of tools[] to use and help configure for automation 
Create a passthrough API 
Properly impliment conversations
Impliment a script to install and configure the components of RAG to extend capabilities 
Add support for detection automation via vission models IF($you_see_X) do Y{ }  
