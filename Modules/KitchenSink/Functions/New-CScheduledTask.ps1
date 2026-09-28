<#
.SYNOPSIS
    Creates or updates a scheduled task that runs a PowerShell script.

.DESCRIPTION
    Creates a scheduled task with a daily trigger and repetition interval.
    Supports running as either a supplied credential or the currently
    logged-in user.

.PARAMETER TaskName
    Name of the scheduled task.

.PARAMETER ScriptPath
    Full path to the PowerShell script to execute.

.PARAMETER Credential
    Credential used to run the task.

.PARAMETER CurrentUser
    Creates the task using the currently logged-in user and does not
    require a password.

.PARAMETER StartTime
    Time the task should first run.

.PARAMETER RepetitionIntervalHours
    Number of hours between task executions.

.PARAMETER ExecutionTimeLimitHours
    Maximum runtime before the task is terminated.

.PARAMETER Replace
    Remove and recreate an existing task.

.EXAMPLE
    $Credential = Get-Credential

    New-CScheduledTask `
        -TaskName 'Service Monitor' `
        -ScriptPath 'C:\Scripts\ServiceMonitor.ps1' `
        -Credential $Credential `
        -Replace

.EXAMPLE
    New-CScheduledTask `
        -TaskName 'Reis Daily Tasks' `
        -ScriptPath 'C:\Code\LD\Daily Script (repo sync, obsidian docs).ps1' `
        -CurrentUser `
        -Replace

.EXAMPLE
    New-CScheduledTask `
        -TaskName 'Reis Daily Tasks' `
        -ScriptPath 'C:\Code\LD\Daily Script (repo sync, obsidian docs).ps1' `
        -CurrentUser `
        -Command 'pwsh' `
        -Replace

.NOTES
Need to add these as a switch or something
    Powershell Window Pops: <Arguments>-NoProfile -ExecutionPolicy Bypass -File "$ScriptPath"</Arguments>
    Powershell Window Hidden (PS7): <Arguments>-NoProfile -WindowStyle Hidden -File "$ScriptPath"</Arguments>
#>
function New-CScheduledTask {
    [CmdletBinding(SupportsShouldProcess = $true,DefaultParameterSetName = 'CurrentUser')]
    param(
        [Parameter(Mandatory,Position = 0,ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$TaskName,

        [Parameter(Mandatory,Position = 1,ValueFromPipelineByPropertyName)]
        [ValidateScript({
            if (-not (Test-Path $_)) {
                throw "ScriptPath not found: $_"
            }

            $true
        })]
        [string]$ScriptPath,

        [Parameter(Mandatory,ParameterSetName = 'Credential')]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter()]
        $DaysInterval = 1,

        [Parameter()]
        [ValidationSet('true','false')]
        $Enabled = 'true',

        [Parameter()]
        [ValidationSet('true','false')]
        $StopAtDurationEnd = 'false',

        [Parameter()]
        $Duration = 'P1D',

        [Parameter()]
        $RunLevel = 'HighestAvailable',

        [Parameter()]
        $MultipleInstancesPolicy = 'IgnoreNew',

        [Parameter()]
        [ValidationSet('true','false')]
        $DisallowStartIfOnBatteries = 'true',

        [Parameter()]
        [ValidationSet('true','false')]
        $StopIfGoingOnBatteries = 'true',

        [Parameter()]
        [ValidationSet('true','false')]
        $AllowHardTerminate = 'true',

        [Parameter()]
        [ValidationSet('true','false')]
        $AllowStartOnDemand = 'true',

        [Parameter()]
        [ValidationSet('true','false')]
        $Hidden = 'false',

        [Parameter()]
        [ValidationSet('true','false')]
        $RunOnlyIfIdle = 'false',

        [Parameter()]
        [ValidationSet('true','false')]
        $WakeToRun = 'false',

        [Parameter()]
        [int]$Priority = 7,

        [Parameter()]
        [ValidationSet('powershell.exe','pwsh')] # PS 5.1 and 7 support
        $Command = 'powershell.exe',

        [Parameter(Mandatory,ParameterSetName = 'CurrentUser')]
        [switch]$CurrentUser,

        [datetime]$StartTime = (Get-Date),

        [ValidateRange(1,24)]
        [int]$RepetitionIntervalHours = 1,

        [ValidateRange(1,720)]
        [int]$ExecutionTimeLimitHours = 72,

        [switch]$Replace
    )

    process {

        $ExistingTask = Get-ScheduledTask `
            -TaskName $TaskName `
            -ErrorAction SilentlyContinue

        if ($ExistingTask -and -not $Replace) {
            throw "Scheduled task '$TaskName' already exists. Use -Replace."
        }

        if ($PSCmdlet.ParameterSetName -eq 'Credential') {
            $UserName = $Credential.UserName
            $LogonType = 'Password'
        }
        else {
            $UserName = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
            $LogonType = 'InteractiveToken'
        }

        $StartBoundary = $StartTime.ToString('yyyy-MM-ddTHH:mm:ss')

        $Xml = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
    <RegistrationInfo>
        <Author>$UserName</Author>
        <URI>\$TaskName</URI>
    </RegistrationInfo>

    <Triggers>
        <CalendarTrigger>
            <Repetition>
                <Interval>PT$($RepetitionIntervalHours)H</Interval>
                <Duration>$Duration</Duration>
                <StopAtDurationEnd>$StopAtDurationEnd</StopAtDurationEnd>
            </Repetition>
            <StartBoundary>$StartBoundary</StartBoundary>
            <Enabled>$Enabled</Enabled>
            <ScheduleByDay>
                <DaysInterval>$DaysInterval</DaysInterval>
            </ScheduleByDay>
        </CalendarTrigger>
    </Triggers>

    <Principals>
        <Principal id="Author">
            <UserId>$UserName</UserId>
            <LogonType>$LogonType</LogonType>
            <RunLevel>$RunLevel</RunLevel>
        </Principal>
    </Principals>

    <Settings>
        <MultipleInstancesPolicy>$MultipleInstancesPolicy</MultipleInstancesPolicy>
        <DisallowStartIfOnBatteries>$DisallowStartIfOnBatteries</DisallowStartIfOnBatteries>
        <StopIfGoingOnBatteries>$StopIfGoingOnBatteries</StopIfGoingOnBatteries>
        <AllowHardTerminate>$AllowHardTerminate</AllowHardTerminate>
        <AllowStartOnDemand>$AllowStartOnDemand</AllowStartOnDemand>
        <Enabled>$Enabled</Enabled>
        <Hidden>$Hidden</Hidden>
        <RunOnlyIfIdle>$RunOnlyIfIdle</RunOnlyIfIdle>
        <WakeToRun>$WakeToRun</WakeToRun>
        <ExecutionTimeLimit>PT$($ExecutionTimeLimitHours)H</ExecutionTimeLimit>
        <Priority>$Priority</Priority>
    </Settings>

    <Actions Context="Author">
        <Exec>
            <Command>$Command</Command>
            <Arguments>-NoProfile -ExecutionPolicy Bypass -File "$ScriptPath"</Arguments>
        </Exec>
    </Actions>
</Task>
"@

        if ($PSCmdlet.ShouldProcess($TaskName, 'Create Scheduled Task')) {

            if ($ExistingTask -and $Replace) {
                Unregister-ScheduledTask `
                    -TaskName $TaskName `
                    -Confirm:$false
            }

            if ($PSCmdlet.ParameterSetName -eq 'Credential') {

                Register-ScheduledTask `
                    -TaskName $TaskName `
                    -Xml $Xml `
                    -User $Credential.UserName `
                    -Password $Credential.GetNetworkCredential().Password | Out-Null
            }
            else {

                Register-ScheduledTask `
                   -TaskName $TaskName `
                    -Xml $Xml | Out-Null
            }

            Get-ScheduledTask -TaskName $TaskName
        }
    }
}

