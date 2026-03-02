#Requires -RunAsAdministrator
# ============================================================
#  WRATH — Windows Optimizer
#  Paste into an elevated PowerShell window to launch:
#  irm <your_raw_github_url> | iex
# ============================================================

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

[xml]$XAML = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Wrath" Height="680" Width="960"
    MinHeight="520" MinWidth="700"
    WindowStartupLocation="CenterScreen"
    WindowStyle="None" AllowsTransparency="True"
    Background="Transparent" ResizeMode="CanResizeWithGrip">

<Window.Resources>

   <!-- Purple filled pill -->
<Style x:Key="PillBtn" TargetType="Button">
  <Setter Property="Background" Value="#9b6bff"/>
  <Setter Property="Foreground" Value="White"/>
  <Setter Property="FontFamily" Value="Segoe UI Semibold"/>
  <Setter Property="FontSize" Value="14"/>
  <Setter Property="Padding" Value="32,14"/>
  <Setter Property="BorderThickness" Value="0"/>
  <Setter Property="Cursor" Value="Hand"/>
  <Setter Property="Template">
    <Setter.Value>
      <ControlTemplate TargetType="Button">
        <Border x:Name="Bd"
                Background="{TemplateBinding Background}"
                CornerRadius="24"
                Padding="{TemplateBinding Padding}">
          <ContentPresenter HorizontalAlignment="Center"
                            VerticalAlignment="Center"/>
        </Border>
        <ControlTemplate.Triggers>
          <Trigger Property="IsMouseOver" Value="True">
            <Setter TargetName="Bd" Property="Background" Value="#b48cff"/>
          </Trigger>
          <Trigger Property="IsPressed" Value="True">
            <Setter TargetName="Bd" Property="Background" Value="#7f3df5"/>
          </Trigger>
        </ControlTemplate.Triggers>
      </ControlTemplate>
    </Setter.Value>
  </Setter>
</Style>

<!-- Ghost outlined pill -->
<Style x:Key="GhostBtn" TargetType="Button">
  <Setter Property="Background" Value="Transparent"/>
  <Setter Property="Foreground" Value="#bbbbbb"/>
  <Setter Property="FontFamily" Value="Segoe UI"/>
  <Setter Property="FontSize" Value="13"/>
  <Setter Property="Padding" Value="28,12"/>
  <Setter Property="BorderThickness" Value="0"/>
  <Setter Property="Cursor" Value="Hand"/>
  <Setter Property="Template">
    <Setter.Value>
      <ControlTemplate TargetType="Button">
        <Border x:Name="Bd"
                Background="Transparent"
                BorderBrush="#333333"
                BorderThickness="1.4"
                CornerRadius="24"
                Padding="{TemplateBinding Padding}">
          <ContentPresenter HorizontalAlignment="Center"
                            VerticalAlignment="Center"/>
        </Border>
        <ControlTemplate.Triggers>
          <Trigger Property="IsMouseOver" Value="True">
            <Setter TargetName="Bd" Property="BorderBrush" Value="#9b6bff"/>
            <Setter Property="Foreground" Value="#d9c6ff"/>
          </Trigger>
        </ControlTemplate.Triggers>
      </ControlTemplate>
    </Setter.Value>
  </Setter>
</Style>

<!-- Outline pill (secondary actions) -->
<Style x:Key="OutlineBtn" TargetType="Button">
  <Setter Property="Background" Value="Transparent"/>
  <Setter Property="Foreground" Value="#aaaaaa"/>
  <Setter Property="FontFamily" Value="Segoe UI"/>
  <Setter Property="FontSize" Value="13"/>
  <Setter Property="Padding" Value="26,12"/>
  <Setter Property="BorderThickness" Value="0"/>
  <Setter Property="Cursor" Value="Hand"/>
  <Setter Property="Template">
    <Setter.Value>
      <ControlTemplate TargetType="Button">
        <Border x:Name="Bd"
                Background="Transparent"
                BorderBrush="#2a2a2a"
                BorderThickness="1.4"
                CornerRadius="24"
                Padding="{TemplateBinding Padding}">
          <ContentPresenter HorizontalAlignment="Center"
                            VerticalAlignment="Center"/>
        </Border>
        <ControlTemplate.Triggers>
          <Trigger Property="IsMouseOver" Value="True">
            <Setter TargetName="Bd" Property="Background" Value="#120a1f"/>
            <Setter TargetName="Bd" Property="BorderBrush" Value="#9b6bff"/>
            <Setter Property="Foreground" Value="#c7a8ff"/>
          </Trigger>
        </ControlTemplate.Triggers>
      </ControlTemplate>
    </Setter.Value>
  </Setter>
</Style>

<!-- Window chrome buttons (min/close) -->
<Style x:Key="ChromeBtn" TargetType="Button">
  <Setter Property="Background" Value="Transparent"/>
  <Setter Property="Foreground" Value="#444444"/>
  <Setter Property="FontFamily" Value="Consolas"/>
  <Setter Property="FontSize" Value="14"/>
  <Setter Property="Width" Value="32"/>
  <Setter Property="Height" Value="32"/>
  <Setter Property="BorderThickness" Value="0"/>
  <Setter Property="Cursor" Value="Hand"/>
  <Setter Property="Template">
    <Setter.Value>
      <ControlTemplate TargetType="Button">
        <Border x:Name="Bd" Background="Transparent" CornerRadius="999">
          <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
        </Border>
        <ControlTemplate.Triggers>
          <Trigger Property="IsMouseOver" Value="True">
            <Setter TargetName="Bd" Property="Background" Value="#1a1a1a"/>
            <Setter Property="Foreground" Value="#bbbbbb"/>
          </Trigger>
        </ControlTemplate.Triggers>
      </ControlTemplate>
    </Setter.Value>
  </Setter>
</Style>

<!-- Scrollbar -->
<Style TargetType="ScrollBar">
  <Setter Property="Width" Value="5"/>
  <Setter Property="Background" Value="Transparent"/>
  <Setter Property="Template">
    <Setter.Value>
      <ControlTemplate TargetType="ScrollBar">
        <Grid>
          <Track x:Name="PART_Track" IsDirectionReversed="True">
            <Track.Thumb>
              <Thumb>
                <Thumb.Template>
                  <ControlTemplate TargetType="Thumb">
                    <Border Background="#221540" CornerRadius="3"/>
                  </ControlTemplate>
                </Thumb.Template>
              </Thumb>
            </Track.Thumb>
          </Track>
        </Grid>
      </ControlTemplate>
    </Setter.Value>
  </Setter>
</Style>

</Window.Resources>


  <!-- Root border gives the window shape + border -->
  <Border Background="#080808" CornerRadius="14"
          BorderBrush="#1e1e1e" BorderThickness="1">
    <Grid>
      <Grid.RowDefinitions>
        <RowDefinition Height="64"/>
        <RowDefinition Height="*"/>
        <RowDefinition Height="Auto"/>
      </Grid.RowDefinitions>

      <!-- ── TITLE BAR ── -->
      <Border Grid.Row="0" Background="Transparent"
              CornerRadius="14,14,0,0" Padding="28,0,14,0"
              x:Name="TitleBar">
        <Grid VerticalAlignment="Center">
          <TextBlock VerticalAlignment="Center">
            <Run Text="Wrath" FontFamily="Georgia" FontSize="28"
                 FontWeight="Bold" Foreground="White"/>
            <Run Text="." FontFamily="Georgia" FontSize="28"
                 FontWeight="Bold" Foreground="#8b5cf6"/>
          </TextBlock>
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Right"
            VerticalAlignment="Center">
    <Button x:Name="BtnMin" Content="&#x2212;" Style="{StaticResource ChromeBtn}"
            Margin="0,0,4,0"/>

    <Button x:Name="BtnMax" Content="&#x25A1;" Style="{StaticResource ChromeBtn}"
            Margin="0,0,4,0"/>

    <Button x:Name="BtnClose" Content="&#x2715;" Style="{StaticResource ChromeBtn}"/>
</StackPanel>
        </Grid>
      </Border>
      <Border Grid.Row="0" Height="1" VerticalAlignment="Bottom"
              Background="#161616" Margin="0,0,0,0"/>

      <!-- ── PAGES ── -->

      <!-- HOME -->
      <Grid x:Name="PageHome" Grid.Row="1">
        <StackPanel VerticalAlignment="Center" HorizontalAlignment="Center"
                    Margin="0,-30,0,0">
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Center"
                      Margin="0,0,0,12">
            <Button x:Name="BtnDelay"   Content="Delay"     Style="{StaticResource PillBtn}" Margin="6,0"/>
            <Button x:Name="BtnDebloat" Content="Debloat"   Style="{StaticResource PillBtn}" Margin="6,0"/>
            <Button x:Name="BtnGame"    Content="Game Mode" Style="{StaticResource PillBtn}" Margin="6,0"/>
          </StackPanel>
          <Button x:Name="BtnRestore" Content="Restore Point"
                  Style="{StaticResource GhostBtn}" HorizontalAlignment="Center"/>
        </StackPanel>
      </Grid>

      <!-- DELAY -->
      <Grid x:Name="PageDelay" Grid.Row="1" Visibility="Collapsed" Margin="28,0,14,0">
        <Grid.RowDefinitions>
          <RowDefinition Height="Auto"/>
          <RowDefinition Height="Auto"/>
          <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <StackPanel Grid.Row="0" HorizontalAlignment="Center" Margin="0,24,0,18">
          <TextBlock HorizontalAlignment="Center" Margin="0,0,0,14">
            <Run Text="Delay" FontFamily="Georgia" FontSize="38" FontWeight="Bold" Foreground="White"/>
            <Run Text="." FontFamily="Georgia" FontSize="38" FontWeight="Bold" Foreground="#8b5cf6"/>
          </TextBlock>
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
            <Button x:Name="DelayAll"  Content="Select All"   Style="{StaticResource PillBtn}"    Margin="5,0"/>
            <Button x:Name="DelayRec"  Content="Recommended"  Style="{StaticResource OutlineBtn}" Margin="5,0"/>
            <Button x:Name="DelayClear" Content="Clear"       Style="{StaticResource OutlineBtn}" Margin="5,0"/>
            <Button x:Name="DelayBack" Content="Back"         Style="{StaticResource GhostBtn}"   Margin="5,0"/>
          </StackPanel>
        </StackPanel>
        <Border Grid.Row="1" Height="1" Background="#161616" Margin="0,0,14,12"/>
        <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto" Padding="0,0,12,0">
          <StackPanel x:Name="DelayList" Margin="0,0,0,16"/>
        </ScrollViewer>
      </Grid>

      <!-- DEBLOAT -->
      <Grid x:Name="PageDebloat" Grid.Row="1" Visibility="Collapsed" Margin="28,0,14,0">
        <Grid.RowDefinitions>
          <RowDefinition Height="Auto"/>
          <RowDefinition Height="Auto"/>
          <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <StackPanel Grid.Row="0" HorizontalAlignment="Center" Margin="0,24,0,18">
          <TextBlock HorizontalAlignment="Center" Margin="0,0,0,14">
            <Run Text="Debloat" FontFamily="Georgia" FontSize="38" FontWeight="Bold" Foreground="White"/>
            <Run Text="." FontFamily="Georgia" FontSize="38" FontWeight="Bold" Foreground="#8b5cf6"/>
          </TextBlock>
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
            <Button x:Name="DebloatAll"   Content="Select All"  Style="{StaticResource PillBtn}"    Margin="5,0"/>
            <Button x:Name="DebloatRec"   Content="Recommended" Style="{StaticResource OutlineBtn}" Margin="5,0"/>
            <Button x:Name="DebloatClear" Content="Clear"       Style="{StaticResource OutlineBtn}" Margin="5,0"/>
            <Button x:Name="DebloatBack"  Content="Back"        Style="{StaticResource GhostBtn}"   Margin="5,0"/>
          </StackPanel>
        </StackPanel>
        <Border Grid.Row="1" Height="1" Background="#161616" Margin="0,0,14,12"/>
        <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto" Padding="0,0,12,0">
          <StackPanel x:Name="DebloatList" Margin="0,0,0,16"/>
        </ScrollViewer>
      </Grid>

      <!-- GAME MODE -->
      <Grid x:Name="PageGame" Grid.Row="1" Visibility="Collapsed" Margin="28,0,14,0">
        <Grid.RowDefinitions>
          <RowDefinition Height="Auto"/>
          <RowDefinition Height="Auto"/>
          <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <StackPanel Grid.Row="0" HorizontalAlignment="Center" Margin="0,24,0,18">
          <TextBlock HorizontalAlignment="Center" Margin="0,0,0,14">
            <Run Text="Game Mode" FontFamily="Georgia" FontSize="38" FontWeight="Bold" Foreground="White"/>
            <Run Text="." FontFamily="Georgia" FontSize="38" FontWeight="Bold" Foreground="#8b5cf6"/>
          </TextBlock>
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
            <Button x:Name="GameAll"   Content="Select All"  Style="{StaticResource PillBtn}"    Margin="5,0"/>
            <Button x:Name="GameRec"   Content="Recommended" Style="{StaticResource OutlineBtn}" Margin="5,0"/>
            <Button x:Name="GameClear" Content="Clear"       Style="{StaticResource OutlineBtn}" Margin="5,0"/>
            <Button x:Name="GameBack"  Content="Back"        Style="{StaticResource GhostBtn}"   Margin="5,0"/>
          </StackPanel>
        </StackPanel>
        <Border Grid.Row="1" Height="1" Background="#161616" Margin="0,0,14,12"/>
        <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto" Padding="0,0,12,0">
          <StackPanel x:Name="GameList" Margin="0,0,0,16"/>
        </ScrollViewer>
      </Grid>

      <!-- LOG / PROGRESS PAGE -->
      <Grid x:Name="PageLog" Grid.Row="1" Visibility="Collapsed" Margin="28,0,14,0">
        <Grid.RowDefinitions>
          <RowDefinition Height="Auto"/>
          <RowDefinition Height="Auto"/>
          <RowDefinition Height="*"/>
          <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        <StackPanel Grid.Row="0" HorizontalAlignment="Center" Margin="0,24,0,4">
          <TextBlock HorizontalAlignment="Center">
            <Run Text="Applying" FontFamily="Georgia" FontSize="38" FontWeight="Bold" Foreground="White"/>
            <Run Text="." FontFamily="Georgia" FontSize="38" FontWeight="Bold" Foreground="#8b5cf6"/>
          </TextBlock>
          <TextBlock x:Name="LogStatus" Text="Running tweaks..." FontFamily="Consolas"
                     FontSize="11" Foreground="#444" HorizontalAlignment="Center" Margin="0,6,0,0"/>
        </StackPanel>
        <Border Grid.Row="1" Height="1" Background="#161616" Margin="0,16,14,12"/>
        <ScrollViewer x:Name="LogScroll" Grid.Row="2"
                      VerticalScrollBarVisibility="Auto" Padding="0,0,12,0">
          <TextBlock x:Name="LogText" FontFamily="Consolas" FontSize="11"
                     Foreground="#3a3a3a" TextWrapping="Wrap" LineHeight="22"
                     Margin="0,0,0,8"/>
        </ScrollViewer>
        <Button x:Name="LogDone" Grid.Row="3" Content="Done"
                Style="{StaticResource PillBtn}" HorizontalAlignment="Center"
                Margin="0,14,0,24" Visibility="Collapsed"/>
      </Grid>

      <!-- ── APPLY BAR ── -->
      <Border x:Name="ApplyBar" Grid.Row="2" Visibility="Collapsed"
              Background="#0a0a0a" BorderBrush="#161616" BorderThickness="0,1,0,0"
              CornerRadius="0,0,14,14" Padding="28,14">
        <Grid>
          <TextBlock x:Name="ApplyLabel" FontFamily="Consolas" FontSize="12"
                     Foreground="#444" VerticalAlignment="Center"/>
          <Button x:Name="BtnApply" Content="Apply Now"
                  Style="{StaticResource PillBtn}" HorizontalAlignment="Right"/>
        </Grid>
      </Border>

    </Grid>
  </Border>
</Window>
'@

# ════════════════════════════════════════════════════════
#  TWEAK DEFINITIONS
# ════════════════════════════════════════════════════════

$Script:Data = [ordered]@{

  Delay = @(
    [PSCustomObject]@{ Cat="Telemetry"; Name="Disable Windows Telemetry";     Badge="REC";     Desc="Sets telemetry to level 0. Stops Microsoft collecting usage and diagnostic data."
      Action={ Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name AllowTelemetry -Value 0 -Force -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Telemetry"; Name="Disable DiagTrack Service";      Badge="REC";     Desc="Stops the Connected User Experiences and Telemetry background service."
      Action={ Stop-Service DiagTrack -EA SilentlyContinue; Set-Service DiagTrack -StartupType Disabled -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Telemetry"; Name="Disable dmwappushsvc";           Badge="REC";     Desc="Kills WAP Push telemetry routing service. No user-facing feature relies on it."
      Action={ Stop-Service dmwappushsvc -EA SilentlyContinue; Set-Service dmwappushsvc -StartupType Disabled -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Telemetry"; Name="Disable CEIP Tasks";             Badge="REC";     Desc="Disables all Customer Experience Improvement Program scheduled tasks."
      Action={ Get-ScheduledTask -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program\*" -EA SilentlyContinue | Disable-ScheduledTask -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Telemetry"; Name="Disable Feedback Notifications"; Badge="REC";     Desc="Turns off Windows prompts asking you to send Microsoft feedback."
      Action={ $p="HKCU:\SOFTWARE\Microsoft\Siuf\Rules"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name NumberOfSIUFInPeriod -Value 0 -Force }}
    [PSCustomObject]@{ Cat="Telemetry"; Name="Disable Error Reporting";        Badge="REC";     Desc="Stops Windows sending crash and error reports to Microsoft."
      Action={ Disable-WindowsErrorReporting -EA SilentlyContinue }}

    [PSCustomObject]@{ Cat="Background Services"; Name="Disable SysMain (Superfetch)";    Badge="REC";     Desc="Prevents disk thrashing on SSDs. Reduces stutters in games."
      Action={ Stop-Service SysMain -EA SilentlyContinue; Set-Service SysMain -StartupType Disabled -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Background Services"; Name="Disable Search Indexing";         Badge="CAUTION"; Desc="Stops background index service. Search still works but may be slower."
      Action={ Stop-Service WSearch -EA SilentlyContinue; Set-Service WSearch -StartupType Disabled -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Background Services"; Name="Disable Delivery Optimization";   Badge="REC";     Desc="Stops Windows using your PC as a P2P update server for other machines."
      Action={ $p="HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name DODownloadMode -Value 0 -Force }}
    [PSCustomObject]@{ Cat="Background Services"; Name="Disable Print Spooler";           Badge="CAUTION"; Desc="Frees memory if you have no printer. Re-enable if you need to print."
      Action={ Stop-Service Spooler -EA SilentlyContinue; Set-Service Spooler -StartupType Disabled -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Background Services"; Name="Disable Windows Insider Service"; Badge="REC";     Desc="Kills Insider telemetry even if not enrolled in the Insider program."
      Action={ Stop-Service wisvc -EA SilentlyContinue; Set-Service wisvc -StartupType Disabled -EA SilentlyContinue }}

    [PSCustomObject]@{ Cat="Privacy"; Name="Disable Advertising ID";       Badge="REC"; Desc="Stops Windows assigning an advertising ID to your session. Zero downsides."
      Action={ $p="HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name Enabled -Value 0 -Force }}
    [PSCustomObject]@{ Cat="Privacy"; Name="Disable Activity History";     Badge="REC"; Desc="Stops Windows logging app usage and sending it to Microsoft Timeline cloud."
      Action={ $p="HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name EnableActivityFeed -Value 0 -Force }}
    [PSCustomObject]@{ Cat="Privacy"; Name="Disable Location Tracking";    Badge="REC"; Desc="Disables the system-wide location service."
      Action={ Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name Value -Value Deny -Force -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Privacy"; Name="Disable App Diagnostics Access"; Badge="REC"; Desc="Prevents apps reading diagnostic info about other running apps."
      Action={ Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" -Name Value -Value Deny -Force -EA SilentlyContinue }}

    [PSCustomObject]@{ Cat="Timers & Scheduler"; Name="Set Timer Resolution to 0.5ms"; Badge="REC"; Desc="Forces minimum timer interval. Reduces scheduling jitter and improves frame pacing."
      Action={ powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR TIMERRESOLUTION 5000 2>$null }}
    [PSCustomObject]@{ Cat="Timers & Scheduler"; Name="Disable Auto-Defrag on SSD";   Badge="REC"; Desc="Stops Windows defragging SSDs. Defragging an SSD wastes write cycles for zero gain."
      Action={ $p="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name MaintenanceDisabled -Value 1 -Force }}

    [PSCustomObject]@{ Cat="UI Latency"; Name="Disable Menu Show Delay";  Badge="REC"; Desc="Sets MenuShowDelay to 0ms. Context menus open instantly with no lag."
      Action={ Set-ItemProperty "HKCU:\Control Panel\Desktop" -Name MenuShowDelay -Value 0 -Force }}
    [PSCustomObject]@{ Cat="UI Latency"; Name="Disable Startup Delay";    Badge="REC"; Desc="Removes the 10-second artificial delay before startup apps launch after login."
      Action={ $p="HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name StartupDelayInMSec -Value 0 -Force }}
    [PSCustomObject]@{ Cat="UI Latency"; Name="Disable Window Animations"; Badge="REC"; Desc="Turns off all window animations and transitions. UI feels immediately snappier."
      Action={ Set-ItemProperty "HKCU:\Control Panel\Desktop\WindowMetrics" -Name MinAnimate -Value 0 -Force }}
    [PSCustomObject]@{ Cat="UI Latency"; Name="Disable Mouse Acceleration"; Badge="REC"; Desc="Removes pointer acceleration for 1:1 mouse movement. Essential for gaming accuracy."
      Action={ Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name MouseSpeed -Value 0 -Force; Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name MouseThreshold1 -Value 0 -Force; Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name MouseThreshold2 -Value 0 -Force }}
  )

  Debloat = @(
    [PSCustomObject]@{ Cat="Microsoft Apps"; Name="Remove Candy Crush";             Badge="REC";     Desc="Removes Candy Crush Saga and all King games pre-installed by Microsoft."
      Action={ Get-AppxPackage "king.com*" -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Microsoft Apps"; Name="Remove Xbox Apps";               Badge="CAUTION"; Desc="Removes Xbox Console Companion. Skip if you use Xbox services."
      Action={ Get-AppxPackage Microsoft.XboxApp -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Microsoft Apps"; Name="Remove 3D Builder";              Badge="REC";     Desc="Removes 3D Builder. Rarely used. Safe to remove on virtually all systems."
      Action={ Get-AppxPackage Microsoft.3DBuilder -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Microsoft Apps"; Name="Remove Solitaire Collection";    Badge="REC";     Desc="Removes the pre-installed ad-supported card game collection."
      Action={ Get-AppxPackage Microsoft.MicrosoftSolitaireCollection -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Microsoft Apps"; Name="Remove MSN Money/Sports/News";   Badge="REC";     Desc="Removes the ad-supported MSN app suite. Better alternatives exist in browser."
      Action={ "Microsoft.BingFinance","Microsoft.BingSports","Microsoft.BingNews" | ForEach-Object { Get-AppxPackage $_ -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}}
    [PSCustomObject]@{ Cat="Microsoft Apps"; Name="Remove Get Office Nag App";      Badge="REC";     Desc="Removes the app whose sole purpose is prompting you to buy Microsoft 365."
      Action={ Get-AppxPackage Microsoft.MicrosoftOfficeHub -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Microsoft Apps"; Name="Remove Skype UWP";               Badge="REC";     Desc="Removes the pre-installed Store version of Skype."
      Action={ Get-AppxPackage Microsoft.SkypeApp -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Microsoft Apps"; Name="Remove People App";              Badge="REC";     Desc="Removes the Contacts app that integrates annoyingly into the taskbar."
      Action={ Get-AppxPackage Microsoft.People -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}

    [PSCustomObject]@{ Cat="Windows Features"; Name="Remove Mixed Reality Portal"; Badge="REC";     Desc="Removes Mixed Reality Portal installed on all PCs even without VR headsets."
      Action={ Get-AppxPackage Microsoft.MixedReality.Portal -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Windows Features"; Name="Disable Cortana";             Badge="REC";     Desc="Fully disables Cortana and its background data collection. Search still works."
      Action={ Get-AppxPackage Microsoft.549981C3F5F10 -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue; $p="HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name AllowCortana -Value 0 -Force }}
    [PSCustomObject]@{ Cat="Windows Features"; Name="Remove Clipchamp";            Badge="REC";     Desc="Removes Microsoft Clipchamp video editor bundled into Windows 11."
      Action={ Get-AppxPackage Clipchamp.Clipchamp -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Windows Features"; Name="Remove Teams (Consumer)";     Badge="REC";     Desc="Removes pre-installed Teams consumer app. Does not affect enterprise Teams."
      Action={ Get-AppxPackage MicrosoftTeams -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Windows Features"; Name="Remove Paint 3D";             Badge="REC";     Desc="Removes Paint 3D. Classic MS Paint is kept untouched."
      Action={ Get-AppxPackage Microsoft.MSPaint -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Windows Features"; Name="Remove OneNote UWP";          Badge="CAUTION"; Desc="Removes Store version of OneNote. Install full desktop version if you use it."
      Action={ Get-AppxPackage Microsoft.Office.OneNote -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}

    [PSCustomObject]@{ Cat="System Junk"; Name="Disable OneDrive Auto-Start";      Badge="REC"; Desc="Stops OneDrive launching at startup. Still works if opened manually."
      Action={ reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDrive /f 2>$null }}
    [PSCustomObject]@{ Cat="System Junk"; Name="Block Silently-Installed Apps";    Badge="REC"; Desc="Stops Windows auto-downloading sponsored apps from the Store in the background."
      Action={ Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SilentInstalledAppsEnabled -Value 0 -Force }}
    [PSCustomObject]@{ Cat="System Junk"; Name="Remove Start Menu Ads";            Badge="REC"; Desc="Disables sponsored app suggestions and ads in Start Menu and search results."
      Action={ Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SystemPaneSuggestionsEnabled -Value 0 -Force }}
    [PSCustomObject]@{ Cat="System Junk"; Name="Disable Web Search in Start";      Badge="REC"; Desc="Stops Start Menu sending searches to Bing. Search stays local only."
      Action={ $p="HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name DisableWebSearch -Value 1 -Force }}
    [PSCustomObject]@{ Cat="System Junk"; Name="Disable Lock Screen Spotlight Ads";Badge="REC"; Desc="Replaces Windows Spotlight ad rotation on lock screen with your wallpaper."
      Action={ Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name RotatingLockScreenEnabled -Value 0 -Force }}

    [PSCustomObject]@{ Cat="Taskbar"; Name="Remove Widgets Button";         Badge="REC"; Desc="Removes the ad-supported Windows 11 Widgets button from the taskbar."
      Action={ Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarDa -Value 0 -Force }}
    [PSCustomObject]@{ Cat="Taskbar"; Name="Remove Task View Button";       Badge="REC"; Desc="Hides Task View button. Virtual desktops still work via Win+Tab."
      Action={ Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name ShowTaskViewButton -Value 0 -Force }}
    [PSCustomObject]@{ Cat="Taskbar"; Name="Disable News & Interests Feed"; Badge="REC"; Desc="Removes MSN news feed from taskbar and disables its background update service."
      Action={ $p="HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name EnableFeeds -Value 0 -Force }}
  )

  Game = @(
    [PSCustomObject]@{ Cat="Power & CPU"; Name="Enable Ultimate Performance Plan"; Badge="REC"; Desc="Unlocks hidden Ultimate Performance power plan. Max CPU frequency, no core parking."
      Action={ powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null; $s=(powercfg /list|Select-String "Ultimate"); if($s){ $g=$s.ToString().Trim().Split()[3]; powercfg /setactive $g }}}
    [PSCustomObject]@{ Cat="Power & CPU"; Name="Disable CPU Core Parking";         Badge="REC"; Desc="Keeps all CPU cores active and instantly available. No more park/unpark delays."
      Action={ powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100; powercfg -setactive SCHEME_CURRENT }}
    [PSCustomObject]@{ Cat="Power & CPU"; Name="Prioritize Foreground Programs";   Badge="REC"; Desc="Adjusts scheduler to give your active game priority over background tasks."
      Action={ Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name Win32PrioritySeparation -Value 38 -Force }}
    [PSCustomObject]@{ Cat="Power & CPU"; Name="Disable Power Throttling";         Badge="REC"; Desc="Forces full CPU performance at all times. Disables efficiency throttling."
      Action={ $p="HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name PowerThrottlingOff -Value 1 -Force }}

    [PSCustomObject]@{ Cat="GPU & Graphics"; Name="Enable HAGS";                       Badge="REC";     Desc="Hardware-Accelerated GPU Scheduling. Reduces latency on RTX 2000+ and RX 5000+."
      Action={ Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name HwSchMode -Value 2 -Force }}
    [PSCustomObject]@{ Cat="GPU & Graphics"; Name="Disable Game Bar & DVR";            Badge="REC";     Desc="Removes Game Bar overlay and DVR hook. Noticeable FPS boost in some games."
      Action={ $p="HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name AppCaptureEnabled -Value 0 -Force; $p2="HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"; if(!(Test-Path $p2)){New-Item $p2 -Force|Out-Null}; Set-ItemProperty $p2 -Name AllowGameDVR -Value 0 -Force }}
    [PSCustomObject]@{ Cat="GPU & Graphics"; Name="Disable NVIDIA Telemetry";          Badge="REC";     Desc="Stops NVIDIA background telemetry services. Frees RAM and reduces CPU usage."
      Action={ Stop-Service NvTelemetryContainer -EA SilentlyContinue; Set-Service NvTelemetryContainer -StartupType Disabled -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="GPU & Graphics"; Name="Enable Variable Refresh Rate (VRR)"; Badge="REC";    Desc="Enables VRR and Adaptive Sync for windowed and fullscreen games."
      Action={ Set-ItemProperty "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences" -Name DirectXUserGlobalSettings -Value "VRROptimizeEnable=1;" -Force -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="GPU & Graphics"; Name="Disable Full-Screen Optimizations"; Badge="REC";     Desc="Turns off Windows FSO which can cause input lag in certain games."
      Action={ $p="HKCU:\System\GameConfigStore"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name GameDVR_FSEBehaviorMode -Value 2 -Force; Set-ItemProperty $p -Name GameDVR_HonorUserFSEBehaviorMode -Value 1 -Force }}
    [PSCustomObject]@{ Cat="GPU & Graphics"; Name="Force Maximum GPU Power State";     Badge="CAUTION"; Desc="Keeps GPU at P0 state always. Increases power draw and heat. Desktop use only."
      Action={ Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" -Name PP_GPUPowerGatingDisable -Value 1 -Force -EA SilentlyContinue }}

    [PSCustomObject]@{ Cat="Network"; Name="Disable Nagle's Algorithm";      Badge="REC"; Desc="Removes TCP packet buffering delay. Lower ping in online games."
      Action={ $ifaces=Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" -EA SilentlyContinue; foreach($i in $ifaces){ Set-ItemProperty $i.PSPath -Name TcpAckFrequency -Value 1 -Force -EA SilentlyContinue; Set-ItemProperty $i.PSPath -Name TCPNoDelay -Value 1 -Force -EA SilentlyContinue }}}
    [PSCustomObject]@{ Cat="Network"; Name="Set DNS to Cloudflare 1.1.1.1"; Badge="REC"; Desc="Fastest public DNS resolver. Reduces game server and matchmaking resolution time."
      Action={ Get-NetAdapter|Where-Object Status -eq Up|ForEach-Object { Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -ServerAddresses 1.1.1.1,1.0.0.1 -EA SilentlyContinue }}}

    [PSCustomObject]@{ Cat="Memory & Storage"; Name="Disable Paging Executive"; Badge="CAUTION"; Desc="Keeps Windows kernel in RAM. Requires 8GB+. Improves frame time consistency."
      Action={ Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name DisablePagingExecutive -Value 1 -Force }}
    [PSCustomObject]@{ Cat="Memory & Storage"; Name="Run TRIM on SSD";         Badge="REC";     Desc="Runs TRIM on your C: drive for optimal SSD health and consistent read performance."
      Action={ Optimize-Volume -DriveLetter C -ReTrim -EA SilentlyContinue }}

    [PSCustomObject]@{ Cat="Windows Gaming"; Name="Enable Windows Game Mode";     Badge="REC"; Desc="Dedicates more CPU/GPU to your active game and suppresses background notifications."
      Action={ $p="HKCU:\Software\Microsoft\GameBar"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name AutoGameModeEnabled -Value 1 -Force }}
    [PSCustomObject]@{ Cat="Windows Gaming"; Name="Disable Game Bar Hotkeys";    Badge="REC"; Desc="Disables Win+G and other game bar shortcuts that interrupt gameplay."
      Action={ Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name GameDVR_Enabled -Value 0 -Force -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Windows Gaming"; Name="Force High Performance GPU";  Badge="REC"; Desc="Forces dedicated GPU for all apps. Critical on laptops with integrated + discrete GPUs."
      Action={ Set-ItemProperty "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences" -Name DirectXUserGlobalSettings -Value "SwapEffectUpgradeEnable=1;VRROptimizeEnable=1;" -Force -EA SilentlyContinue }}
  )
}

# ════════════════════════════════════════════════════════
#  LOAD WINDOW
# ════════════════════════════════════════════════════════

$reader = New-Object System.Xml.XmlNodeReader $XAML
$Window = [Windows.Markup.XamlReader]::Load($reader)

# Get named controls
function gn($n){ $Window.FindName($n) }

$PageHome    = gn "PageHome"
$PageDelay   = gn "PageDelay"
$PageDebloat = gn "PageDebloat"
$PageGame    = gn "PageGame"
$PageLog     = gn "PageLog"

$ApplyBar    = gn "ApplyBar"
$ApplyLabel  = gn "ApplyLabel"
$BtnApply    = gn "BtnApply"

$LogText     = gn "LogText"
$LogStatus   = gn "LogStatus"
$LogScroll   = gn "LogScroll"
$LogDone     = gn "LogDone"

$Script:Checks = @()  # all CheckBox controls

# ════════════════════════════════════════════════════════
#  BUILD TWEAK LIST
# ════════════════════════════════════════════════════════

function New-CategorySeparator($label) {
    $g = New-Object System.Windows.Controls.Grid
    $g.Margin = [System.Windows.Thickness]::new(0,18,0,6)
    $c0 = New-Object System.Windows.Controls.ColumnDefinition; $c0.Width = [System.Windows.GridLength]::Auto
    $c1 = New-Object System.Windows.Controls.ColumnDefinition; $c1.Width = New-Object System.Windows.GridLength(1,[System.Windows.GridUnitType]::Star)
    $g.ColumnDefinitions.Add($c0); $g.ColumnDefinitions.Add($c1)

    $lbl = New-Object System.Windows.Controls.TextBlock
    $lbl.Text = $label.ToUpper()
    $lbl.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
    $lbl.FontSize = 10
    $lbl.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#3a3a3a")
    $lbl.VerticalAlignment = "Center"
    $lbl.Margin = [System.Windows.Thickness]::new(0,0,12,0)
    [System.Windows.Controls.Grid]::SetColumn($lbl,0)

    $line = New-Object System.Windows.Controls.Border
    $line.Height = 1
    $line.VerticalAlignment = "Center"
    $line.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#161616")
    [System.Windows.Controls.Grid]::SetColumn($line,1)

    $g.Children.Add($lbl)|Out-Null
    $g.Children.Add($line)|Out-Null
    return $g
}

function New-TweakItem($tweak) {
    $badgeMap = @{
        "REC"     = @{ Bg="#0d2218"; Fg="#6ee7b7"; Br="#1a3d2a" }
        "CAUTION" = @{ Bg="#2a1f00"; Fg="#fbbf24"; Br="#3d2d00" }
        "ADVANCED"= @{ Bg="#2a0a0a"; Fg="#f87171"; Br="#3d1515" }
    }

    # Outer border (the whole row)
    $outer = New-Object System.Windows.Controls.Border
    $outer.CornerRadius = New-Object System.Windows.CornerRadius(8)
    $outer.BorderThickness = [System.Windows.Thickness]::new(1)
    $outer.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#00000000")
    $outer.Padding = [System.Windows.Thickness]::new(12,10,12,10)
    $outer.Margin = [System.Windows.Thickness]::new(0,1,0,1)
    $outer.Cursor = [System.Windows.Input.Cursors]::Hand
    $outer.Tag = $tweak

    # Grid layout: checkbox | name+desc | badge
    $g = New-Object System.Windows.Controls.Grid
    $c0 = New-Object System.Windows.Controls.ColumnDefinition; $c0.Width = [System.Windows.GridLength]::Auto
    $c1 = New-Object System.Windows.Controls.ColumnDefinition; $c1.Width = New-Object System.Windows.GridLength(1,[System.Windows.GridUnitType]::Star)
    $c2 = New-Object System.Windows.Controls.ColumnDefinition; $c2.Width = [System.Windows.GridLength]::Auto
    $g.ColumnDefinitions.Add($c0); $g.ColumnDefinitions.Add($c1); $g.ColumnDefinitions.Add($c2)

    # Checkbox
    $cb = New-Object System.Windows.Controls.CheckBox
    $cb.VerticalAlignment = "Center"
    $cb.Margin = [System.Windows.Thickness]::new(0,0,12,0)
    $cb.Tag = $tweak
    $cb.Foreground = [System.Windows.Media.Brushes]::Transparent
    $cb.Width = 0; $cb.Height = 0  # hidden native checkbox, we draw our own box
    [System.Windows.Controls.Grid]::SetColumn($cb,0)

    # Custom visual checkbox box
    $box = New-Object System.Windows.Controls.Border
    $box.Width = 17; $box.Height = 17
    $box.CornerRadius = New-Object System.Windows.CornerRadius(4)
    $box.BorderThickness = [System.Windows.Thickness]::new(1)
    $box.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#2a2a2a")
    $box.Background = [System.Windows.Media.Brushes]::Transparent
    $box.VerticalAlignment = "Center"
    $box.Margin = [System.Windows.Thickness]::new(0,0,12,0)
    [System.Windows.Controls.Grid]::SetColumn($box,0)

    $check = New-Object System.Windows.Controls.TextBlock
    $check.Text = [char]0x2713
    $check.FontSize = 11
    $check.HorizontalAlignment = "Center"
    $check.VerticalAlignment = "Center"
    $check.Foreground = [System.Windows.Media.Brushes]::Black
    $check.Visibility = "Collapsed"
    $box.Child = $check

    # Name + description stack
    $stack = New-Object System.Windows.Controls.StackPanel
    $stack.VerticalAlignment = "Center"
    [System.Windows.Controls.Grid]::SetColumn($stack,1)

    $nameTb = New-Object System.Windows.Controls.TextBlock
    $nameTb.Text = $tweak.Name
    $nameTb.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
    $nameTb.FontSize = 12
    $nameTb.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#b0b0b0")
    $nameTb.TextWrapping = "Wrap"

    $descTb = New-Object System.Windows.Controls.TextBlock
    $descTb.Text = $tweak.Desc
    $descTb.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
    $descTb.FontSize = 11
    $descTb.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#3a3a3a")
    $descTb.TextWrapping = "Wrap"
    $descTb.Margin = [System.Windows.Thickness]::new(0,4,0,0)
    $descTb.Visibility = "Collapsed"

    $stack.Children.Add($nameTb)|Out-Null
    $stack.Children.Add($descTb)|Out-Null

    # Badge
    $bc = $badgeMap[$tweak.Badge]
    $badgeBorder = New-Object System.Windows.Controls.Border
    $badgeBorder.CornerRadius = New-Object System.Windows.CornerRadius(999)
    $badgeBorder.Padding = [System.Windows.Thickness]::new(8,2,8,2)
    $badgeBorder.VerticalAlignment = "Center"
    $badgeBorder.Margin = [System.Windows.Thickness]::new(12,0,0,0)
    $badgeBorder.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString($bc.Bg)
    $badgeBorder.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString($bc.Br)
    $badgeBorder.BorderThickness = [System.Windows.Thickness]::new(1)
    [System.Windows.Controls.Grid]::SetColumn($badgeBorder,2)

    $badgeText = New-Object System.Windows.Controls.TextBlock
    $badgeText.Text = $tweak.Badge
    $badgeText.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
    $badgeText.FontSize = 9
    $badgeText.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString($bc.Fg)
    $badgeText.VerticalAlignment = "Center"
    $badgeBorder.Child = $badgeText

    $g.Children.Add($box)|Out-Null
    $g.Children.Add($stack)|Out-Null
    $g.Children.Add($badgeBorder)|Out-Null
    $outer.Child = $g

    # State: checked = true/false stored in Tag
    $outer.Tag = @{ Tweak=$tweak; Checked=$false; Box=$box; Check=$check; NameTb=$nameTb; DescTb=$descTb; OuterBorder=$outer }

    # Hover: show desc
    $outer.Add_MouseEnter({
        param($s,$e)
        $s.Tag.DescTb.Visibility = "Visible"
        if (-not $s.Tag.Checked) {
            $s.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#0d0d0d")
            $s.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#222222")
        }
    })
    $outer.Add_MouseLeave({
        param($s,$e)
        $s.Tag.DescTb.Visibility = "Collapsed"
        if (-not $s.Tag.Checked) {
            $s.Background = [System.Windows.Media.Brushes]::Transparent
            $s.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#00000000")
        }
    })

    # Click: toggle
    $outer.Add_MouseLeftButtonUp({
        param($s,$e)
        $t = $s.Tag
        $t.Checked = -not $t.Checked
        if ($t.Checked) {
            $s.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#0f0820")
            $s.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#2e1f47")
            $t.Box.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#8b5cf6")
            $t.Box.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#8b5cf6")
            $t.Check.Visibility = "Visible"
            $t.NameTb.Foreground = [System.Windows.Media.Brushes]::White
        } else {
            $s.Background = [System.Windows.Media.Brushes]::Transparent
            $s.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#00000000")
            $t.Box.Background = [System.Windows.Media.Brushes]::Transparent
            $t.Box.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#2a2a2a")
            $t.Check.Visibility = "Collapsed"
            $t.NameTb.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#b0b0b0")
        }
        Update-ApplyBar
    })

    return $outer
}

function Build-Section($panel, $sectionKey) {
    $tweaks = $Script:Data[$sectionKey]
    $lastCat = ""
    foreach ($t in $tweaks) {
        if ($t.Cat -ne $lastCat) {
            $panel.Children.Add((New-CategorySeparator $t.Cat))|Out-Null
            $lastCat = $t.Cat
        }
        $item = New-TweakItem $t
        $panel.Children.Add($item)|Out-Null
        $Script:Checks += $item
    }
}

Build-Section (gn "DelayList")   "Delay"
Build-Section (gn "DebloatList") "Debloat"
Build-Section (gn "GameList")    "Game"

# ════════════════════════════════════════════════════════
#  HELPERS
# ════════════════════════════════════════════════════════

function Update-ApplyBar {
    $n = ($Script:Checks | Where-Object { $_.Tag.Checked }).Count
    if ($n -gt 0) {
        $ApplyBar.Visibility = "Visible"
        $ApplyLabel.Text = "$n tweak$(if($n -ne 1){'s'}) selected"
    } else {
        $ApplyBar.Visibility = "Collapsed"
    }
}

function Show-Page($p) {
    foreach ($pg in @($PageHome,$PageDelay,$PageDebloat,$PageGame,$PageLog)) {
        $pg.Visibility = "Collapsed"
    }
    $p.Visibility = "Visible"
}

function Set-SectionChecked($sectionKey, $value, [switch]$RecOnly) {
    $names = $Script:Data[$sectionKey] | ForEach-Object { $_.Name }
    foreach ($item in $Script:Checks) {
        if ($item.Tag.Tweak.Name -in $names) {
            $should = if ($RecOnly) { $item.Tag.Tweak.Badge -eq "REC" } else { $value }
            if ($item.Tag.Checked -ne $should) {
                $item.RaiseEvent((New-Object System.Windows.Input.MouseButtonEventArgs(
                    [System.Windows.Input.Mouse]::PrimaryDevice, 0,
                    [System.Windows.Input.MouseButton]::Left
                )) )
                # Direct set is cleaner:
                $t = $item.Tag
                $t.Checked = $should
                if ($should) {
                    $item.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#0f0820")
                    $item.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#2e1f47")
                    $t.Box.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#8b5cf6")
                    $t.Box.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#8b5cf6")
                    $t.Check.Visibility = "Visible"
                    $t.NameTb.Foreground = [System.Windows.Media.Brushes]::White
                } else {
                    $item.Background = [System.Windows.Media.Brushes]::Transparent
                    $item.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#00000000")
                    $t.Box.Background = [System.Windows.Media.Brushes]::Transparent
                    $t.Box.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#2a2a2a")
                    $t.Check.Visibility = "Collapsed"
                    $t.NameTb.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#b0b0b0")
                }
            }
        }
    }
    Update-ApplyBar
}

# ═════════════════════
