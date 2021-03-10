Function ExchSetupLog-Assistant {
	Param (
		#Stage Variable for Exchange setup log path:
		$Log = ".\ExchangeSetup.log",
		#Stage Variable for base string that we expect in every line of the log:
		$BaseString = "]",
		#Target Error count per install:
		[int]$ErrorCount = "12",
		#How many of the  last attempts do you want to review?
		[int]$Lastattempts = "3",
		#Do we want to review the entire log?## At this time, we will still index the entire log
		[boolean]$EntireLog = $false,
		#Do we want to place focused log into variable?
		[boolean]$ExportLogToShell = $true,
		#Do we want to export the log highlight to a local directory?
		[boolean]$ExportLogToLog = $false,
		#Log directory export path:
		[string]$ExportPath = (Get-Location).Path,
		#Do we want live review?
		[boolean]$LiveReview = $false,
		#What is the custom formatting we want between Attempt number and whether entry is Status,Timeline, or error
		[string]$Character = "__"
	)

#Stage variable for the key point in log:
[string]$Key = "Starting Microsoft Exchange Server"+"*"+"Setup"
#Stage an array of base strings that help with timeline:
[String[]]$TimelineStrings = "Server Name=","Logged on User:","Command Line Parameter Name=","OrganizationName","MSExchangeADTopology has a persisted domain controller:","Setup Version:", "Operating System Version:", "PrepareAD has", "The Schema "," End of Setup","Starting copy from","Finished Copy from","Setup will use"
#Stage an array for status strings: 
[String[]]$StatusStrings = "Organization Configuration Update Required Status :","Schema Update Required Status :", "Setup encountered a problem while validating the state of Active Directory", "Domain Configuration Update Required Status :", "Setup has detected","The Exchange Server setup operation didn't complete.","tasks were found to run.","A reboot from a previous installation is pending","The local domain needs to be updated.", "RestoreServerOnPrereqFailure.ps1"
#Variable containing hard stop message:
[String[]]$KeyFail = "Setup is stopping now because of one or more critical errors", "The Exchange Server setup operation didn't complete."
#Variable containing desired error strings:
[String[]]$Failstrings = "Error","Critical","Terminate","Fail","errors","failure","warining"
#Variable containing success strings:
[string[]]$SuccessStrings = "The Exchange Server setup operation completed successfully.","Install is complete. "
#Variable containing ignore strings: #### For now, this only applies to Errors!####
[string[]]$IgnoreStrings = "RuleType:Error","ErrorAction:","RuleType:Warning","Setting:ADinitError","HasException:False","RestoreServerOnPrereqFailure.ps1"," finished "
#Get the entire log into string array varible:
$TotalLog = GCI $Log |Sls $BaseString
#stage an integer containing the total count of entries in the log
[int]$TotalLogCount = $totallog.count
Write-Host "There are " $totallogcount " entries in this log"
#Ensure our loop count is at 0:
[int]$TerminalLoop = "0"
#Create index:
$Global:ExchSetupIndex = New-Object PsCustomObject
#Enter Foreach Loop for Index build & Key:
	Foreach ($entry in $totalLog) {
		#Increment number by 1 to know which string this is in the sequence of strings
	$I ++
#If Entry is like our key:
	If ($entry -like "*"+$key+"*") {
		#Increment number by 1 for the number of key hits we have:
		$IndexHits ++
		#Then add the number in sequence of strings to our index of instance of hits
		$ExchSetupIndex | Add-Member -MemberType NoteProperty -Name ("Key" + $indexHits) -Value $I
		#Add what the entry is to the index so we can include time stamp of setup
		$ExchSetupIndex | Add-Member -MemberType NoteProperty -Name ("Key" + $indexHits+ "Entry") -Value $Entry
		Write-Host "Found Index hit at entry number" $I}
			}
##Now that we are indexed, what kind of strings do we find in the desired index?##
		#Catch if there are less entries than the specified number of attempts:
		If ($LastAttempts -ge $IndexHits) {$entirelog = $true}
		#If we want to reference the index:
		If ($entirelog -eq $false) {
		#Which of the keys do we care about? (Number of key hits versus the user specified number)
		[string]$KeyIndexes = $IndexHits-$LastAttempts+1
		#Stage string of what we expect the property to be called:
		[string]$KeyReference = "Key"+$KeyIndexes
		#Stage an integer containing the number of key indexes:
		[int]$StartingPoint = ($ExchSetupIndex).$KeyReference - 1
		#Reference the property specified on the index, then get it's definition, then use that number found to reference that point in the index to the end of the log:
		$Global:FocusedExchLog =$totallog[$StartingPoint..$TotalLogCount]}
		#If we want the entire log, set focused log to total log
		If ($entirelog -eq $true) {$Global:FocusedExchLog  = $TotalLog}
##Now let's search the specified range:
Foreach ($entry in $FocusedExchLog) {
	#If our entry matches our key:
	If ($entry -like "*"+$key+"*") {
		#add a blank entry to our log:
		[string[]]$review += "" 
		#If we didn't detect our key error(s) or success in the last loop:
		If (($AttemptCount -gt $terminalLoop) -and ($AttemptCount -gt $Successloop) -and ($terminalLoop -ne $null)) {
			#Stamp a string based on error count:
			[string[]]$review += "-=-=-=-=-=-=Didn't find terminal 'KEY' error before next setup attempt here are the last $ErrorCount errors observed-=-=-=-="
			#Stage a search string for log review:
			$SearchString = $Character+$AttemptCount+$Character+"*"
			#Add the last number of errors desired to our log file and continue flow if the entry matches our key
			[string[]]$review += $ErrorTable | ? {$_ -like $SearchString} | Select -Last $ErrorCount}
		#Increment variable of attempt count by 1
		$AttemptCount ++
		#Add blank string to log for line break:
		[string[]]$review += "" 
		#Stage speacial string for entry
		$SpecialString = "NewInstance"
		#Stage the entire string for loop count, special string, and log entry:
		[string]$temp = $Character+$attemptcount+$Character+"|"+$Character+$SpecialString+$Character+"|"+$entry.line 
		#Add the entry to the log file:
		[string[]]$review +=$temp
		#Notify host that a new install attempt was detected
		Write-host "Found attempt" $entry.line}
	#If entry matches one of our timeline strings:
	If ($entry -match ('(' + [string]::Join(')|(', $TimelineStrings) + ')')) {
		#Stage special string:
		$SpecialString = "TimeLine"
		#Stage the entire string for loop count, special string, and log entry:
		[string]$temp = $Character+$attemptcount+$Character+"|"+$Character+$SpecialString+$Character+"|"+$entry.line 
		#Add the entry to the log file:
		[string[]]$Review += $temp}
	#If entry matches one of our status strings:
	If ($entry -match ('(' + [string]::Join(')|(', $StatusStrings) + ')')) {
		#Stage variable for special string
		$SpecialString = "Status"
		#Stage the entire string for loop count, special string, and log entry:
		[string]$temp = $Character+$attemptcount+$Character+"|"+$Character+$SpecialString+$Character+"|"+$entry.line 
		#Add the entry to the log file:
		[string[]]$Review += $temp}
	#If entry matches one of our error strings:
	If (($entry -match ('(' + [string]::Join(')|(', $Failstrings) + ')'))) {
		#Stage variable for special string
		$SpecialString = "Error"
		#Stage the entire string for loop count, special string, and log entry:
		[string]$temp = $Character+$attemptcount+$Character+"|"+$Character+$SpecialString+$Character+"|"+$entry.line 
		#If entry doesn't match our ignore strings, add it to the errors table:
		If ($entry -notmatch ('(' + [string]::Join(')|(', $IgnoreStrings) + ')')){
		#Add the entry to the log file:
		[string[]]$ErrorTable += $temp}}
		#if entry is our key error
		If ($Entry -match ('(' + [string]::Join(')|(', $KeyFail) + ')')) {
			#Save the loop count
			[int]$terminalLoop = $AttemptCount
			#Determine what is the current error count
			[int]$targetError = $ErrorTable.count
			#Add blank string to log for line break:
			[string[]]$review += "" 
			$terminalerror = $entry.line
			#Add a special entry in the log:
			[string[]]$Review += "-=-=-=-=-= Setup has encountered a hard termination!
			$terminalerror
			Here are the $ErrorCount leading errors prior to termination in this attempt -=-=-=-=-=
			"
			#Stage search string
			$SearchString = $Character+$AttemptCount+$Character+"*"
			#Add the user specified amount of errors in this setup attempt to the log:
			[string[]]$Review += $ErrorTable | ? {$_ -like $SearchString} | Select -Last $ErrorCount}
		#If entry is our key success:
		If ($entry -match ('(' + [string]::Join(')|(', $SuccessStrings) + ')')) {
			#Stage special string:
			$SpecialString = "Success!"
			#Stage the entire string for loop count, special string, and log entry:
			[string]$temp = $Character+$attemptcount+$Character+"|"+$Character+$SpecialString+$Character+"|"+$entry.line 
			#Add the entry to the log file:
			[string[]]$Review += $temp
			$Successloop = $AttemptCount
			}
		}
#Stage search string
	$SearchString = $Character+$AttemptCount+$Character+"*"
	#If we didn't find the hard exception on the last setup log... add special entry & the user specified number of errors in the error table that match the search string:
	If (($AttemptCount -gt $terminalLoop) -and ($AttemptCount -gt $Successloop) -and ($terminalLoop -ne $null) -and ($Successloop -ne $null)) {[string[]]$review += "-=-=-=-=-= The last attempt of the server errors!!!-=-=-=-=" ; [string[]]$review += $ErrorTable |? {$_ -like $SearchString} | select -Last $ErrorCount}
	#If export log, set global variable called ExchSetupLog
	If ($ExportLogtoShell -eq $true) {[String[]]$Global:ExchSetupLog = $review}
	#If Export Directory, export the log into a CSV:
	If ($ExportLogToLog -eq $true) {$time = (Get-Date -format hh_mm_ss) ; $Exportlog = $ExportPath + "\ExchangeSetupLogTimeline" +$time + ".log" ; $review | Out-File $Exportlog}
	#Let us know how many setup attempts were found
	Write-Host "There were $IndexHits attempts in total in this log, we are have the timeline highlight of the last $AttemptCount in the specified location(s)" -ForegroundColor Yellow
	#If live review pump results into a |MORE
	If ($LiveReview -eq $true) {$Review | More}
}