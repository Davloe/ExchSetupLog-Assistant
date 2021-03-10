# ExchSetupLog-Assistant
Download ExchSetupLog-Assistant:
[![Downloads](https://img.shields.io/github/downloads/dpaulson45/HealthChecker/total.svg?label=Downloads&maxAge=9999)](https://github.com/davloe/ExchSetupLog-Assistant/releases):
Warning! This function has 3 global variables that might overwrite variables with the same name: ExchSetupIndex, FocusedExchLog, and ExchSetupLog

The ExchangeSetupLog-Assistant is intended to help you review ExchangeSetup.log to establish a timeline of the log, what was some of the statuses, and if there were errors, what were they?

The default behavior of the function will search the local directory for "ExchangeSetup.log", index the log, then review the logs for failures on the last 3 attempts.

Once the attempts are found, it will be in a variable, $ExchSetupLog, which you can review in the shell session accordingly.


# How To Run
For now, you MUST 'dot source' the script to import the function ExchSetupLog-Assistant, navigate to where the .ps1 was downloaded and run:
```
. .\ExchSetupLog-Assistant.ps1
```

### Examples:

This cmdlet with run the assistant in the default behavior.
```
ExchSetupLog-Assistant
```
This cmdlet with run the assistant in the default behavior, then show you the results right away in the shell
```
ExchSetupLog-Assistant -LiveReview $true
```
This cmdlet will run the assistant against the ENTIRE log and export the timeline to the local path, otherwise, default behavior:

```
ExchSetupLog-Assistant -EntireLog $true -ExportLogToLog $true
```
This cmdlet will run the assistant against the specified log, review the entire log, return more than the standard 12 errors, and export the timeline to a custom path:

```
ExchSetupLog-Assistant -log "C:\ExchangeSetupLogs\ExchangeSetup.log" -EntireLog $true -ErrorCount 30 -ExportLogToLog $true -ExportPath "C:\Temp"
```

###
# Parameters

Parameter | Description
----------|------------
Log | The path to where the setup log is located. The default behavior is to look in the local directory for .\ExchangeSetup.Log.
BaseString | The string we expect to be in every line of the log. The default behavior is to search the log for character "]".
ErrorCount | If the setup is believed to be encountering error, how many error strings do you want to include? The default value for this is 12.
LastAttempts | Of the attempts found, how many of the attempts at the bottom of the log do we want to review? The default value for this is 3.
EntireLog | Boolean on whether we want to search the entire log or not. The default value for this is False.
ExportLogToShell | Boolean on whether we want the log timeline exported to the shell or not. The default value for this is True.
ExportPath | Path where we want to export the highlighted timeline into. The default value is the local path.
LiveReview | Boolean on whether we want to do a live review of the timeline or not. The default value is False.
Character | The character that we want to stamp in the logs between the logs for custom formatting preferences. The default value is "__".
RawStringOnTermination | This boolean specifies whether we want raw logs on terminal error or not. The default value is true.
RawStringsCount | This is the number of lines you want to include when a terminal error is observed. The default value is 30.

# Review:
```
#Review entire log in scrolling fashion:
$ExchSetupLog | More
```

```
#stage string for format of attempt 22 only
$SearchString = “__22__” 
#Then perform where object to find the desired
$ExchSetupLog | ? {$_ -like “*”+$SearchString+”*”}
```
