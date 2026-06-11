<#
.SYNOPSIS
Creates and shows the UI progress window.

.DESCRIPTION
Initializes a modeless WPF progress window, stores references in script scope,
and positions the window based on the selected screen and corner/center option.

.PARAMETER WindowTitle
Text shown in the window title bar.

.PARAMETER HeaderText
Main heading text shown inside the window.

.PARAMETER Topmost
If provided, keeps the window on top of other windows.

.PARAMETER Position
Window placement mode: Center, TopLeft, TopRight, BottomLeft, or BottomRight.

.PARAMETER OffsetX
Horizontal offset in pixels from the selected edge.

.PARAMETER OffsetY
Vertical offset in pixels from the selected edge.

.PARAMETER ScreenTarget
Which monitor to use for placement:
ActiveCursor, ActiveWindow, or Primary.

.PARAMETER IconPath
Optional path to an icon file to use in the title bar.

.EXAMPLE
Start-UIProgressWindow -WindowTitle "AD Sync" -HeaderText "Processing users..." -Topmost

.EXAMPLE
Start-UIProgressWindow -Position BottomRight -ScreenTarget ActiveWindow -IconPath "C:\Icons\sync.ico"
#>
function Start-UIProgressWindow {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$WindowTitle = "Installation",

        [Parameter()]
        [string]$HeaderText = "Installing Software...",

        [Parameter()]
        [switch]$Topmost,

        [Parameter()]
        [ValidateSet("Center", "TopLeft", "TopRight", "BottomLeft", "BottomRight")]
        [string]$Position = "Center",

        [Parameter()]
        [ValidateRange(0, 500)]
        [int]$OffsetX = 20,

        [Parameter()]
        [ValidateRange(0, 500)]
        [int]$OffsetY = 20,

        [Parameter()]
        [ValidateSet("ActiveCursor", "ActiveWindow", "Primary")]
        [string]$ScreenTarget = "ActiveCursor",

        [Parameter()]
        [string]$IconPath
    )

    Add-Type -AssemblyName PresentationFramework
    Add-Type -AssemblyName System.Windows.Forms

    if (-not ("UIProgressWindow.NativeMethods" -as [type])) {
        Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

namespace UIProgressWindow {
    public static class NativeMethods {
        [DllImport("user32.dll")]
        public static extern IntPtr GetForegroundWindow();
    }
}
"@
    }

    if ($script:InstallProgressContext -and $script:InstallProgressContext.Window -and $script:InstallProgressContext.Window.IsVisible) {
        Stop-UIProgressWindow
    }

    [xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Width="420" Height="220" WindowStartupLocation="CenterScreen">
    <StackPanel Margin="20">
        <TextBlock x:Name="Header" FontSize="14" FontWeight="Bold"/>
        <ProgressBar x:Name="Progress" Height="30" Margin="0,10,0,0" Minimum="0" Maximum="100"/>
        <TextBlock x:Name="Status" Margin="0,10,0,0" FontSize="12"/>
        <Button x:Name="CloseBtn" Content="Close" Width="120" Margin="0,10,0,0" HorizontalAlignment="Left"/>
    </StackPanel>
</Window>
"@

    $reader = [System.Xml.XmlNodeReader]::new($xaml)
    $window = [System.Windows.Markup.XamlReader]::Load($reader)
    $header = $window.FindName("Header")
    $progress = $window.FindName("Progress")
    $status = $window.FindName("Status")
    $closeBtn = $window.FindName("CloseBtn")

    $window.Title = $WindowTitle
    $window.Topmost = $Topmost.IsPresent
    $header.Text = $HeaderText
    $progress.Value = 0
    $status.Text = "0% Complete"

    if (-not [string]::IsNullOrWhiteSpace($IconPath) -and (Test-Path -LiteralPath $IconPath)) {
        $resolvedIconPath = (Resolve-Path -LiteralPath $IconPath).Path
        $iconUri = [System.Uri]::new($resolvedIconPath, [System.UriKind]::Absolute)
        $window.Icon = [System.Windows.Media.Imaging.BitmapFrame]::Create($iconUri)
    }

    $window.WindowStartupLocation = "Manual"
    $targetScreen = switch ($ScreenTarget) {
        "Primary" {
            [System.Windows.Forms.Screen]::PrimaryScreen
            break
        }
        "ActiveWindow" {
            $foregroundHandle = [UIProgressWindow.NativeMethods]::GetForegroundWindow()
            if ($foregroundHandle -ne [IntPtr]::Zero) {
                [System.Windows.Forms.Screen]::FromHandle($foregroundHandle)
            }
            else {
                [System.Windows.Forms.Screen]::FromPoint([System.Windows.Forms.Cursor]::Position)
            }
            break
        }
        default {
            [System.Windows.Forms.Screen]::FromPoint([System.Windows.Forms.Cursor]::Position)
            break
        }
    }
    $workArea = $targetScreen.WorkingArea
    $windowWidth = [double]$window.Width
    $windowHeight = [double]$window.Height

    switch ($Position) {
        "TopLeft" {
            $window.Left = $workArea.Left + $OffsetX
            $window.Top = $workArea.Top + $OffsetY
        }
        "TopRight" {
            $window.Left = $workArea.Right - $windowWidth - $OffsetX
            $window.Top = $workArea.Top + $OffsetY
        }
        "BottomLeft" {
            $window.Left = $workArea.Left + $OffsetX
            $window.Top = $workArea.Bottom - $windowHeight - $OffsetY
        }
        "BottomRight" {
            $window.Left = $workArea.Right - $windowWidth - $OffsetX
            $window.Top = $workArea.Bottom - $windowHeight - $OffsetY
        }
        default {
            $window.Left = $workArea.Left + (($workArea.Width - $windowWidth) / 2)
            $window.Top = $workArea.Top + (($workArea.Height - $windowHeight) / 2)
        }
    }

    $closeBtn.Add_Click({ $window.Close() }.GetNewClosure())
    $window.Add_Closed({
        $script:InstallProgressContext = $null
    })

    $script:InstallProgressContext = @{
        Window = $window
        Progress = $progress
        Status = $status
        Header = $header
        CloseButton = $closeBtn
        Percent = 0
    }

    $window.Show() | Out-Null
}