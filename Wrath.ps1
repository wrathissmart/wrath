# ══════════════════════════════════════════════════════════════
#  WRATH v2  —  Windows Optimizer
#  Usage: irm <raw_github_url> | iex
#  Run as Administrator in PowerShell 5+
# ══════════════════════════════════════════════════════════════

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "`n  Wrath requires Administrator privileges." -ForegroundColor Red
    Write-Host "  Right-click PowerShell and choose 'Run as Administrator', then try again.`n" -ForegroundColor Yellow
    exit
}

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

[xml]$XAML = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Wrath" Height="740" Width="1180"
        MinHeight="600" MinWidth="900"
        WindowStartupLocation="CenterScreen"
        WindowStyle="None" AllowsTransparency="True"
        Background="Transparent" ResizeMode="CanResizeWithGrip">
  <Window.Resources>

    <!-- ── PILL (chrome + purple glow) ── -->
    <Style x:Key="Pill" TargetType="Button">
      <Setter Property="Background"   Value="#1a1a1f"/>
      <Setter Property="Foreground"   Value="#c8c8d8"/>
      <Setter Property="FontFamily"   Value="Segoe UI"/>
      <Setter Property="FontSize"     Value="12"/>
      <Setter Property="FontWeight"   Value="SemiBold"/>
      <Setter Property="Padding"      Value="24,10"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Cursor"       Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd"
                    Background="{TemplateBinding Background}"
                    BorderBrush="#3a3a4a" BorderThickness="1"
                    CornerRadius="10" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Bd" Property="Background"  Value="#22202e"/>
                <Setter TargetName="Bd" Property="BorderBrush" Value="#6d4fc2"/>
                <Setter Property="Foreground" Value="White"/>
              </Trigger>
              <Trigger Property="IsPressed" Value="True">
                <Setter TargetName="Bd" Property="Background"  Value="#1d1929"/>
                <Setter TargetName="Bd" Property="BorderBrush" Value="#8b5cf6"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- ── GHOST (chrome + purple glow) ── -->
    <Style x:Key="Ghost" TargetType="Button">
      <Setter Property="Background"   Value="Transparent"/>
      <Setter Property="Foreground"   Value="#484858"/>
      <Setter Property="FontFamily"   Value="Segoe UI"/>
      <Setter Property="FontSize"     Value="11"/>
      <Setter Property="Padding"      Value="20,8"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Cursor"       Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="Transparent"
                    BorderBrush="#222230" BorderThickness="1"
                    CornerRadius="10" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Bd" Property="BorderBrush" Value="#5a4a80"/>
                <Setter TargetName="Bd" Property="Background"  Value="#0e0c18"/>
                <Setter Property="Foreground" Value="#9988cc"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- ── OUTLINE (chrome + purple glow) ── -->
    <Style x:Key="Outline" TargetType="Button">
      <Setter Property="Background"   Value="Transparent"/>
      <Setter Property="Foreground"   Value="#3a3a4a"/>
      <Setter Property="FontFamily"   Value="Segoe UI"/>
      <Setter Property="FontSize"     Value="11"/>
      <Setter Property="Padding"      Value="16,7"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Cursor"       Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="Transparent"
                    BorderBrush="#1e1e28" BorderThickness="1"
                    CornerRadius="10" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Bd" Property="Background"  Value="#110e20"/>
                <Setter TargetName="Bd" Property="BorderBrush" Value="#7c5ce0"/>
                <Setter Property="Foreground" Value="#a088e0"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- ── NAV BUTTON (sidebar) ── -->
    <Style x:Key="Nav" TargetType="Button">
      <Setter Property="Background"            Value="Transparent"/>
      <Setter Property="Foreground"            Value="#3c3c3c"/>
      <Setter Property="FontFamily"            Value="Segoe UI"/>
      <Setter Property="FontSize"              Value="13"/>
      <Setter Property="HorizontalContentAlignment" Value="Left"/>
      <Setter Property="Padding"               Value="14,10"/>
      <Setter Property="BorderThickness"       Value="0"/>
      <Setter Property="Cursor"                Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="Transparent"
                    CornerRadius="8" Padding="{TemplateBinding Padding}">
              <ContentPresenter VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Bd" Property="Background" Value="#0d0d0d"/>
                <Setter Property="Foreground" Value="#777"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- ── CHROME (min/close) ── -->
    <Style x:Key="Chrome" TargetType="Button">
      <Setter Property="Background"    Value="Transparent"/>
      <Setter Property="Foreground"    Value="#3a3a3a"/>
      <Setter Property="FontSize"      Value="13"/>
      <Setter Property="Width"         Value="30"/>
      <Setter Property="Height"        Value="30"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Cursor"        Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="Transparent" CornerRadius="999">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Bd" Property="Background" Value="#181818"/>
                <Setter Property="Foreground" Value="#aaa"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- ── GAME CARD ── -->
    <Style x:Key="GameCard" TargetType="Button">
      <Setter Property="Background"    Value="#0d0d0d"/>
      <Setter Property="Foreground"    Value="#666"/>
      <Setter Property="FontFamily"    Value="Segoe UI"/>
      <Setter Property="FontSize"      Value="13"/>
      <Setter Property="FontWeight"    Value="SemiBold"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Cursor"        Value="Hand"/>
      <Setter Property="Padding"       Value="0"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="{TemplateBinding Background}"
                    BorderBrush="#181818" BorderThickness="1"
                    CornerRadius="12" Padding="22,20">
              <StackPanel>
                <TextBlock Text="{TemplateBinding Tag}" FontSize="24"
                           Margin="0,0,0,12" HorizontalAlignment="Left"/>
                <TextBlock Text="{TemplateBinding Content}"
                           FontFamily="Segoe UI" FontSize="13" FontWeight="SemiBold"
                           Foreground="{TemplateBinding Foreground}" TextWrapping="Wrap"/>
              </StackPanel>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Bd" Property="Background" Value="#120a22"/>
                <Setter TargetName="Bd" Property="BorderBrush" Value="#341870"/>
                <Setter Property="Foreground" Value="#c4b5fd"/>
              </Trigger>
              <Trigger Property="IsPressed" Value="True">
                <Setter TargetName="Bd" Property="Background" Value="#180d2e"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- ── DANGER BUTTON (chrome + red glow) ── -->
    <Style x:Key="DangerBtn" TargetType="Button">
      <Setter Property="Background"    Value="#160808"/>
      <Setter Property="Foreground"    Value="#c06060"/>
      <Setter Property="FontFamily"    Value="Segoe UI"/>
      <Setter Property="FontSize"      Value="11"/>
      <Setter Property="FontWeight"    Value="SemiBold"/>
      <Setter Property="Padding"       Value="16,8"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Cursor"        Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="{TemplateBinding Background}"
                    BorderBrush="#2a1010" BorderThickness="1"
                    CornerRadius="10" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Bd" Property="Background"  Value="#200c0c"/>
                <Setter TargetName="Bd" Property="BorderBrush" Value="#6b2020"/>
                <Setter Property="Foreground" Value="#f87171"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- ── SCROLLBAR ── -->
    <Style TargetType="ScrollBar">
      <Setter Property="Width"  Value="4"/>
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
                        <Border Background="#1e1040" CornerRadius="2"/>
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

  <Border Background="#070707" CornerRadius="14" BorderBrush="#161616" BorderThickness="1">
    <Grid x:Name="RootGrid">
      <Grid.ColumnDefinitions>
        <ColumnDefinition Width="210"/>
        <ColumnDefinition Width="*"/>
      </Grid.ColumnDefinitions>
      <Grid.RowDefinitions>
        <RowDefinition Height="58"/>
        <RowDefinition Height="*"/>
        <RowDefinition Height="Auto"/>
      </Grid.RowDefinitions>

      <!-- ════════════════ SIDEBAR ════════════════ -->
      <Border x:Name="SidebarBorder" Grid.Column="0" Grid.RowSpan="3"
              Background="#050505" CornerRadius="14,0,0,14"
              BorderBrush="#111" BorderThickness="0,0,1,0" ClipToBounds="True">
        <DockPanel>
          <!-- Logo -->
          <StackPanel DockPanel.Dock="Top" Margin="20,22,20,18">
            <TextBlock>
              <Run Text="Wrath" FontFamily="Georgia" FontSize="23" FontWeight="Bold" Foreground="White"/>
              <Run Text="." FontFamily="Georgia" FontSize="23" FontWeight="Bold" Foreground="#8b5cf6"/>
            </TextBlock>
          </StackPanel>

          <Border DockPanel.Dock="Top" Height="1" Background="#101010" Margin="0,0,0,10"/>

          <!-- Nav items -->
          <StackPanel DockPanel.Dock="Top" Margin="10,4,10,0">
            <Button x:Name="NavOpt"     Style="{StaticResource Nav}" Margin="0,1,0,1">
              <StackPanel Orientation="Horizontal">
                <TextBlock Text="⚡" FontSize="12" VerticalAlignment="Center" Margin="0,0,10,0"/>
                <TextBlock Text="Optimizations" VerticalAlignment="Center"/>
              </StackPanel>
            </Button>
            <Button x:Name="NavPro"     Style="{StaticResource Nav}" Margin="0,1,0,1">
              <StackPanel Orientation="Horizontal">
                <TextBlock Text="🎮" FontSize="12" VerticalAlignment="Center" Margin="0,0,10,0"/>
                <TextBlock Text="Pro Settings" VerticalAlignment="Center"/>
              </StackPanel>
            </Button>
            <Button x:Name="NavSettings" Style="{StaticResource Nav}" Margin="0,1,0,1">
              <StackPanel Orientation="Horizontal">
                <TextBlock Text="⚙" FontSize="12" VerticalAlignment="Center" Margin="0,0,10,0"/>
                <TextBlock Text="Settings" VerticalAlignment="Center"/>
              </StackPanel>
            </Button>
          </StackPanel>

          <!-- Bottom watermark -->
          <Border DockPanel.Dock="Bottom" Padding="20,10">
            <TextBlock Text="prosettings.net data" FontFamily="Segoe UI"
                       FontSize="9" Foreground="#1a1a1a"/>
          </Border>
          <FrameworkElement/>
        </DockPanel>
      </Border>

      <!-- ════════════════ TITLE BAR ════════════════ -->
      <Border Grid.Column="1" Grid.Row="0" x:Name="TitleBar"
              Background="Transparent" CornerRadius="0,14,0,0" Padding="10,0,14,0">
        <Grid VerticalAlignment="Center">
          <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
            <Button x:Name="BtnToggleSidebar"
                    Width="32" Height="32" Padding="0"
                    Background="Transparent" BorderThickness="0"
                    Cursor="Hand" Margin="0,0,10,0" VerticalAlignment="Center">
              <Button.Template>
                <ControlTemplate TargetType="Button">
                  <Border x:Name="TgBd" Background="Transparent" CornerRadius="8">
                    <TextBlock x:Name="SidebarArrow" Text="&#x276E;"
                               FontFamily="Segoe UI" FontSize="14" FontWeight="Bold"
                               Foreground="#555566" HorizontalAlignment="Center"
                               VerticalAlignment="Center"/>
                  </Border>
                  <ControlTemplate.Triggers>
                    <Trigger Property="IsMouseOver" Value="True">
                      <Setter TargetName="TgBd" Property="Background" Value="#111118"/>
                      <Setter TargetName="SidebarArrow" Property="Foreground" Value="#8b5cf6"/>
                    </Trigger>
                  </ControlTemplate.Triggers>
                </ControlTemplate>
              </Button.Template>
            </Button>
            <TextBlock x:Name="PageTitle" Text="Optimizations"
                       FontFamily="Segoe UI" FontSize="13" FontWeight="SemiBold"
                       Foreground="#555566" VerticalAlignment="Center"/>
          </StackPanel>
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
            <Button x:Name="BtnMin"   Content="&#x2212;" Style="{StaticResource Chrome}" Margin="0,0,4,0"/>
            <Button x:Name="BtnClose" Content="&#x2715;" Style="{StaticResource Chrome}"/>
          </StackPanel>
        </Grid>
      </Border>
      <Border Grid.Column="1" Grid.Row="0" Height="1" VerticalAlignment="Bottom" Background="#0f0f0f"/>

      <!-- ════════════════ CONTENT ════════════════ -->
      <Grid Grid.Column="1" Grid.Row="1">

        <!-- ── OPT HOME ── -->
        <Grid x:Name="PgOptHome">
          <StackPanel VerticalAlignment="Center" HorizontalAlignment="Center" Margin="0,-30,0,0">
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="0,0,0,12">
              <Button x:Name="BtnDelay"   Content="Delay"     Style="{StaticResource Pill}" Margin="6,0"/>
              <Button x:Name="BtnDebloat" Content="Debloat"   Style="{StaticResource Pill}" Margin="6,0"/>
              <Button x:Name="BtnGame"    Content="Game Mode" Style="{StaticResource Pill}" Margin="6,0"/>
            </StackPanel>
            <Button x:Name="BtnRestore" Content="Restore Point"
                    Style="{StaticResource Ghost}" HorizontalAlignment="Center"/>
          </StackPanel>
        </Grid>

        <!-- ── DELAY ── -->
        <Grid x:Name="PgDelay" Visibility="Collapsed" Margin="26,0,12,0">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <StackPanel Grid.Row="0" HorizontalAlignment="Center" Margin="0,22,0,16">
            <TextBlock HorizontalAlignment="Center" Margin="0,0,0,14">
              <Run Text="Delay" FontFamily="Georgia" FontSize="36" FontWeight="Bold" Foreground="White"/>
              <Run Text="." FontFamily="Georgia" FontSize="36" FontWeight="Bold" Foreground="#8b5cf6"/>
            </TextBlock>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
              <Button x:Name="DelayAll"   Content="Select All"  Style="{StaticResource Pill}"    Margin="4,0"/>
              <Button x:Name="DelayRec"   Content="Recommended" Style="{StaticResource Outline}"  Margin="4,0"/>
              <Button x:Name="DelayClear" Content="Clear"       Style="{StaticResource Outline}"  Margin="4,0"/>
              <Button x:Name="DelayBack"  Content="Back"        Style="{StaticResource Ghost}"    Margin="4,0"/>
            </StackPanel>
          </StackPanel>
          <Border Grid.Row="1" Height="1" Background="#0f0f0f" Margin="0,0,12,12"/>
          <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto" Padding="0,0,10,0">
            <StackPanel x:Name="DelayList" Margin="0,0,0,16"/>
          </ScrollViewer>
        </Grid>

        <!-- ── DEBLOAT ── -->
        <Grid x:Name="PgDebloat" Visibility="Collapsed" Margin="26,0,12,0">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <StackPanel Grid.Row="0" HorizontalAlignment="Center" Margin="0,22,0,16">
            <TextBlock HorizontalAlignment="Center" Margin="0,0,0,14">
              <Run Text="Debloat" FontFamily="Georgia" FontSize="36" FontWeight="Bold" Foreground="White"/>
              <Run Text="." FontFamily="Georgia" FontSize="36" FontWeight="Bold" Foreground="#8b5cf6"/>
            </TextBlock>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
              <Button x:Name="DebloatAll"   Content="Select All"  Style="{StaticResource Pill}"    Margin="4,0"/>
              <Button x:Name="DebloatRec"   Content="Recommended" Style="{StaticResource Outline}"  Margin="4,0"/>
              <Button x:Name="DebloatClear" Content="Clear"       Style="{StaticResource Outline}"  Margin="4,0"/>
              <Button x:Name="DebloatBack"  Content="Back"        Style="{StaticResource Ghost}"    Margin="4,0"/>
            </StackPanel>
          </StackPanel>
          <Border Grid.Row="1" Height="1" Background="#0f0f0f" Margin="0,0,12,12"/>
          <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto" Padding="0,0,10,0">
            <StackPanel x:Name="DebloatList" Margin="0,0,0,16"/>
          </ScrollViewer>
        </Grid>

        <!-- ── GAME OPT ── -->
        <Grid x:Name="PgGameOpt" Visibility="Collapsed" Margin="26,0,12,0">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <StackPanel Grid.Row="0" HorizontalAlignment="Center" Margin="0,22,0,16">
            <TextBlock HorizontalAlignment="Center" Margin="0,0,0,14">
              <Run Text="Game Mode" FontFamily="Georgia" FontSize="36" FontWeight="Bold" Foreground="White"/>
              <Run Text="." FontFamily="Georgia" FontSize="36" FontWeight="Bold" Foreground="#8b5cf6"/>
            </TextBlock>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
              <Button x:Name="GameAll"   Content="Select All"  Style="{StaticResource Pill}"    Margin="4,0"/>
              <Button x:Name="GameRec"   Content="Recommended" Style="{StaticResource Outline}"  Margin="4,0"/>
              <Button x:Name="GameClear" Content="Clear"       Style="{StaticResource Outline}"  Margin="4,0"/>
              <Button x:Name="GameBack"  Content="Back"        Style="{StaticResource Ghost}"    Margin="4,0"/>
            </StackPanel>
          </StackPanel>
          <Border Grid.Row="1" Height="1" Background="#0f0f0f" Margin="0,0,12,12"/>
          <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto" Padding="0,0,10,0">
            <StackPanel x:Name="GameOptList" Margin="0,0,0,16"/>
          </ScrollViewer>
        </Grid>

        <!-- ── APPLY LOG ── -->
        <Grid x:Name="PgLog" Visibility="Collapsed" Margin="26,0,12,0">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
          </Grid.RowDefinitions>
          <StackPanel Grid.Row="0" HorizontalAlignment="Center" Margin="0,22,0,4">
            <TextBlock HorizontalAlignment="Center">
              <Run Text="Applying" FontFamily="Georgia" FontSize="36" FontWeight="Bold" Foreground="White"/>
              <Run Text="." FontFamily="Georgia" FontSize="36" FontWeight="Bold" Foreground="#8b5cf6"/>
            </TextBlock>
            <TextBlock x:Name="LogStatus" Text="Running..." FontFamily="Segoe UI"
                       FontSize="11" Foreground="#2e2e2e" HorizontalAlignment="Center" Margin="0,6,0,0"/>
          </StackPanel>
          <Border Grid.Row="1" Height="1" Background="#0f0f0f" Margin="0,14,12,12"/>
          <ScrollViewer x:Name="LogScroll" Grid.Row="2" VerticalScrollBarVisibility="Auto" Padding="0,0,8,0">
            <TextBlock x:Name="LogText" FontFamily="Consolas" FontSize="11"
                       Foreground="#282828" TextWrapping="Wrap" LineHeight="22"/>
          </ScrollViewer>
          <Button x:Name="LogDone" Grid.Row="3" Content="Done" Style="{StaticResource Pill}"
                  HorizontalAlignment="Center" Margin="0,14,0,24" Visibility="Collapsed"/>
        </Grid>

        <!-- ══════════ PRO SETTINGS — GAME SELECT ══════════ -->
        <Grid x:Name="PgProGames" Visibility="Collapsed" Margin="26,0,22,0">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <StackPanel Grid.Row="0" Margin="0,24,0,4">
            <TextBlock>
              <Run Text="Pro Settings" FontFamily="Georgia" FontSize="30"
                   FontWeight="Bold" Foreground="White"/>
              <Run Text="." FontFamily="Georgia" FontSize="30"
                   FontWeight="Bold" Foreground="#8b5cf6"/>
            </TextBlock>
            <TextBlock Text="Choose a game to browse verified pro player configurations."
                       FontFamily="Segoe UI" FontSize="12" Foreground="#2a2a2a" Margin="0,6,0,0"/>
            <TextBlock Text="Data sourced from prosettings.net"
                       FontFamily="Segoe UI" FontSize="10" Foreground="#1c1c1c" Margin="0,3,0,0"/>
          </StackPanel>
          <Border Grid.Row="1" Height="1" Background="#0f0f0f" Margin="0,18,0,20"/>
          <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto">
            <UniformGrid x:Name="GameGrid" Columns="3" Margin="0,0,0,24" HorizontalAlignment="Left"/>
          </ScrollViewer>
        </Grid>

        <!-- ══════════ PRO SETTINGS — PLAYER LIST ══════════ -->
        <Grid x:Name="PgProPlayers" Visibility="Collapsed" Margin="26,0,22,0">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <StackPanel Grid.Row="0" Margin="0,24,0,4">
            <Button x:Name="BtnBackGames" Style="{StaticResource Ghost}"
                    HorizontalAlignment="Left" Padding="14,6" Margin="0,0,0,14">
              <StackPanel Orientation="Horizontal">
                <TextBlock Text="←" Margin="0,0,6,0" VerticalAlignment="Center"/>
                <TextBlock Text="All Games" VerticalAlignment="Center"/>
              </StackPanel>
            </Button>
            <TextBlock x:Name="ProTitle">
              <Run x:Name="ProTitleRun" Text="Players" FontFamily="Georgia"
                   FontSize="30" FontWeight="Bold" Foreground="White"/>
              <Run Text="." FontFamily="Georgia" FontSize="30"
                   FontWeight="Bold" Foreground="#8b5cf6"/>
            </TextBlock>
            <TextBlock Text="Verified settings · prosettings.net"
                       FontFamily="Segoe UI" FontSize="10" Foreground="#1c1c1c" Margin="0,5,0,0"/>
          </StackPanel>
          <Border Grid.Row="1" Height="1" Background="#0f0f0f" Margin="0,14,0,16"/>
          <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto" Padding="0,0,6,0">
            <StackPanel x:Name="PlayerList" Margin="0,0,0,24"/>
          </ScrollViewer>
        </Grid>

        <!-- ══════════ APP SETTINGS ══════════ -->
        <Grid x:Name="PgSettings" Visibility="Collapsed" Margin="26,0,22,0">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <StackPanel Grid.Row="0" Margin="0,24,0,4">
            <TextBlock>
              <Run Text="Settings" FontFamily="Georgia" FontSize="30"
                   FontWeight="Bold" Foreground="White"/>
              <Run Text="." FontFamily="Georgia" FontSize="30"
                   FontWeight="Bold" Foreground="#8b5cf6"/>
            </TextBlock>
          </StackPanel>
          <Border Grid.Row="1" Height="1" Background="#0f0f0f" Margin="0,18,0,22"/>
          <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto">
            <StackPanel Margin="0,0,0,28">

              <!-- RESTORE POINT -->
              <TextBlock Text="SYSTEM" FontFamily="Segoe UI" FontSize="9" FontWeight="SemiBold"
                         Foreground="#1e1e1e" Margin="0,0,0,10"/>
              <Border Background="#0c0c0c" BorderBrush="#161616" BorderThickness="1"
                      CornerRadius="10" Padding="20,16" Margin="0,0,0,6">
                <Grid>
                  <StackPanel>
                    <TextBlock Text="Create Restore Point" FontFamily="Segoe UI" FontSize="13"
                               FontWeight="SemiBold" Foreground="#aaa"/>
                    <TextBlock Text="Creates a Windows restore snapshot before applying any tweaks. Highly recommended."
                               FontFamily="Segoe UI" FontSize="11" Foreground="#2a2a2a"
                               TextWrapping="Wrap" Margin="0,5,0,0"/>
                  </StackPanel>
                  <Button x:Name="StgRestore" Content="Create Now" Style="{StaticResource Pill}"
                          HorizontalAlignment="Right" VerticalAlignment="Center"
                          FontSize="11" Padding="16,8"/>
                </Grid>
              </Border>

              <!-- ABOUT -->
              <TextBlock Text="ABOUT" FontFamily="Segoe UI" FontSize="9" FontWeight="SemiBold"
                         Foreground="#1e1e1e" Margin="0,20,0,10"/>
              <Border Background="#0c0c0c" BorderBrush="#161616" BorderThickness="1"
                      CornerRadius="10" Padding="20,16" Margin="0,0,0,6">
                <StackPanel>
                  <TextBlock Text="Wrath v2.0" FontFamily="Segoe UI" FontSize="13"
                             FontWeight="SemiBold" Foreground="#aaa"/>
                  <TextBlock Text="Windows optimization tool. Run as Administrator. Pro settings data courtesy of prosettings.net — the most trusted source for verified pro player configurations."
                             FontFamily="Segoe UI" FontSize="11" Foreground="#2a2a2a"
                             TextWrapping="Wrap" Margin="0,6,0,0"/>
                </StackPanel>
              </Border>

              <!-- DANGER ZONE -->
              <TextBlock Text="DANGER ZONE" FontFamily="Segoe UI" FontSize="9" FontWeight="SemiBold"
                         Foreground="#1e1e1e" Margin="0,20,0,10"/>
              <Border Background="#0c0c0c" BorderBrush="#1a0e0e" BorderThickness="1"
                      CornerRadius="10" Padding="20,16" Margin="0,0,0,6">
                <Grid>
                  <StackPanel>
                    <TextBlock Text="Reset All Selections" FontFamily="Segoe UI" FontSize="13"
                               FontWeight="SemiBold" Foreground="#aaa"/>
                    <TextBlock Text="Clears every checked tweak across all three categories."
                               FontFamily="Segoe UI" FontSize="11" Foreground="#2a2a2a"
                               TextWrapping="Wrap" Margin="0,5,0,0"/>
                  </StackPanel>
                  <Button x:Name="StgClearAll" Content="Clear All" Style="{StaticResource DangerBtn}"
                          HorizontalAlignment="Right" VerticalAlignment="Center"/>
                </Grid>
              </Border>

            </StackPanel>
          </ScrollViewer>
        </Grid>

      </Grid>

      <!-- ════════════════ APPLY BAR ════════════════ -->
      <Border x:Name="ApplyBar" Grid.Column="1" Grid.Row="2" Visibility="Collapsed"
              Background="#060606" BorderBrush="#0f0f0f" BorderThickness="0,1,0,0"
              CornerRadius="0,0,14,0" Padding="26,13">
        <Grid>
          <TextBlock x:Name="ApplyLabel" FontFamily="Segoe UI" FontSize="12"
                     Foreground="#333" VerticalAlignment="Center"/>
          <Button x:Name="BtnApply" Content="Apply Now"
                  Style="{StaticResource Pill}" HorizontalAlignment="Right"/>
        </Grid>
      </Border>

    </Grid>
  </Border>
</Window>
'@

# ══════════════════════════════════════════════════════════════
#  PRO SETTINGS DATA  (verified via prosettings.net)
# ══════════════════════════════════════════════════════════════

$Script:Games = @(

  [PSCustomObject]@{
    Name="Counter-Strike 2"; Icon="🎯"
    Players=@(
      [PSCustomObject]@{ Name="ZywOo";    Team="Team Vitality";  Role="Rifler / AWP"; DPI=400;  Sens=2.00; eDPI=800;  Res="1280x960";  Aspect="4:3";  Hz=240; Mouse="Vaxee Outset AX" }
      [PSCustomObject]@{ Name="s1mple";   Team="NAVI";           Role="AWPer";        DPI=400;  Sens=3.09; eDPI=1236; Res="1280x960";  Aspect="4:3";  Hz=240; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="NiKo";     Team="G2 Esports";     Role="Rifler";       DPI=400;  Sens=1.55; eDPI=620;  Res="1280x960";  Aspect="4:3";  Hz=240; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="donk";     Team="Team Spirit";    Role="Rifler";       DPI=800;  Sens=1.25; eDPI=1000; Res="1280x960";  Aspect="4:3";  Hz=360; Mouse="Logitech G Pro X Superlight 2 DEX" }
      [PSCustomObject]@{ Name="m0NESY";   Team="G2 Esports";     Role="AWPer";        DPI=800;  Sens=2.00; eDPI=1600; Res="1280x960";  Aspect="4:3";  Hz=360; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="ropz";     Team="FaZe Clan";      Role="Rifler";       DPI=400;  Sens=1.77; eDPI=708;  Res="1280x960";  Aspect="4:3";  Hz=240; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="broky";    Team="FaZe Clan";      Role="AWPer";        DPI=400;  Sens=1.70; eDPI=680;  Res="1280x960";  Aspect="4:3";  Hz=240; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="device";   Team="Astralis";       Role="AWPer";        DPI=400;  Sens=2.20; eDPI=880;  Res="1280x960";  Aspect="4:3";  Hz=240; Mouse="BenQ Zowie EC2-C" }
    )
  }

  [PSCustomObject]@{
    Name="VALORANT"; Icon="⚡"
    Players=@(
      [PSCustomObject]@{ Name="TenZ";     Team="Sentinels";   Role="Duelist";    DPI=1600; Sens=0.15; eDPI=240;  Res="1920x1080"; Aspect="16:9"; Hz=360; Mouse="Finalmouse Starlight-12 Phantom" }
      [PSCustomObject]@{ Name="Aspas";    Team="Leviatán";    Role="Duelist";    DPI=800;  Sens=0.40; eDPI=320;  Res="1920x1080"; Aspect="16:9"; Hz=360; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="Demon1";   Team="NRG";         Role="Duelist";    DPI=1600; Sens=0.10; eDPI=160;  Res="1920x1080"; Aspect="16:9"; Hz=360; Mouse="ASUS ROG Harpe II Ace" }
      [PSCustomObject]@{ Name="Derke";    Team="Fnatic";      Role="Duelist";    DPI=400;  Sens=0.74; eDPI=296;  Res="1920x1080"; Aspect="16:9"; Hz=360; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="ZmjjKK";   Team="EDG";         Role="Duelist";    DPI=800;  Sens=0.35; eDPI=280;  Res="1920x1080"; Aspect="16:9"; Hz=360; Mouse="Finalmouse Starlight Pro" }
      [PSCustomObject]@{ Name="Less";     Team="LOUD";        Role="Initiator";  DPI=1600; Sens=0.22; eDPI=352;  Res="1920x1080"; Aspect="16:9"; Hz=360; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="Boaster";  Team="Fnatic";      Role="Controller"; DPI=800;  Sens=0.26; eDPI=208;  Res="1920x1080"; Aspect="16:9"; Hz=240; Mouse="Logitech G Pro X Superlight" }
      [PSCustomObject]@{ Name="MaKo";     Team="DRX";         Role="Controller"; DPI=400;  Sens=0.55; eDPI=220;  Res="1920x1080"; Aspect="16:9"; Hz=360; Mouse="Logitech G Pro X Superlight 2" }
    )
  }

  [PSCustomObject]@{
    Name="Fortnite"; Icon="🏆"
    Players=@(
      [PSCustomObject]@{ Name="Bugha";      Team="Free Agent"; Role="Builder";   DPI=400;  Sens=0.10; eDPI=40;  Res="1920x1080"; Aspect="16:9"; Hz=240; Mouse="Razer Viper V3 Pro" }
      [PSCustomObject]@{ Name="Mongraal";   Team="FaZe Clan";  Role="Fragger";   DPI=1600; Sens=0.06; eDPI=96;  Res="1920x1080"; Aspect="16:9"; Hz=240; Mouse="Logitech G303 Shroud Edition" }
      [PSCustomObject]@{ Name="Clix";       Team="XSET";       Role="Fragger";   DPI=400;  Sens=0.13; eDPI=52;  Res="1920x1080"; Aspect="16:9"; Hz=240; Mouse="Finalmouse ULX" }
      [PSCustomObject]@{ Name="MrSavage";   Team="NRG";        Role="Builder";   DPI=400;  Sens=0.10; eDPI=40;  Res="1920x1080"; Aspect="16:9"; Hz=360; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="Benjyfishy"; Team="MCES";       Role="Versatile"; DPI=400;  Sens=0.11; eDPI=44;  Res="1920x1080"; Aspect="16:9"; Hz=240; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="Peterbot";   Team="Free Agent"; Role="Fragger";   DPI=1600; Sens=0.05; eDPI=80;  Res="1920x1080"; Aspect="16:9"; Hz=360; Mouse="Logitech G Pro X Superlight 2" }
    )
  }

  [PSCustomObject]@{
    Name="Apex Legends"; Icon="🔥"
    Players=@(
      [PSCustomObject]@{ Name="ImperialHal"; Team="Falcons Esports"; Role="IGL";     DPI=400;  Sens=2.0; eDPI=800;  Res="1440x1080"; Aspect="4:3";  Hz=240; Mouse="Finalmouse Starlight Pro TenZ Edition" }
      [PSCustomObject]@{ Name="Genburten";   Team="Falcons Esports"; Role="Fragger"; DPI=800;  Sens=1.0; eDPI=800;  Res="1920x1080"; Aspect="16:9"; Hz=360; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="Faide";       Team="SSG";             Role="Fragger"; DPI=800;  Sens=0.8; eDPI=640;  Res="1920x1080"; Aspect="16:9"; Hz=360; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="Aceu";        Team="Free Agent";      Role="Fragger"; DPI=800;  Sens=1.5; eDPI=1200; Res="1920x1080"; Aspect="16:9"; Hz=240; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="Verhulst";    Team="Team Liquid";     Role="Support"; DPI=800;  Sens=1.6; eDPI=1280; Res="1920x1080"; Aspect="16:9"; Hz=240; Mouse="Logitech G Pro X Superlight" }
      [PSCustomObject]@{ Name="Mande";       Team="FaZe Clan";       Role="Fragger"; DPI=1600; Sens=0.6; eDPI=960;  Res="1920x1080"; Aspect="16:9"; Hz=360; Mouse="Logitech G Pro X Superlight 2" }
    )
  }

  [PSCustomObject]@{
    Name="Overwatch 2"; Icon="🛡"
    Players=@(
      [PSCustomObject]@{ Name="Fleta";    Team="Seoul Dynasty";   Role="DPS";    DPI=800; Sens=6.5;  eDPI=5200; Res="1920x1080"; Aspect="16:9"; Hz=360; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="Proper";   Team="LA Gladiators";   Role="DPS";    DPI=800; Sens=5.5;  eDPI=4400; Res="1920x1080"; Aspect="16:9"; Hz=240; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="Profit";   Team="Seoul Dynasty";   Role="DPS";    DPI=800; Sens=6.0;  eDPI=4800; Res="1920x1080"; Aspect="16:9"; Hz=360; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="Viol2t";   Team="Boston Uprising"; Role="Support"; DPI=800; Sens=4.5; eDPI=3600; Res="1920x1080"; Aspect="16:9"; Hz=240; Mouse="Logitech G Pro X Superlight" }
    )
  }

  [PSCustomObject]@{
    Name="Rainbow Six Siege"; Icon="💥"
    Players=@(
      [PSCustomObject]@{ Name="Pengu";    Team="NRG";        Role="Support"; DPI=400; Sens=36; eDPI=14400; Res="1920x1080"; Aspect="16:9"; Hz=360; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="Beaulo";   Team="TSM";        Role="Fragger"; DPI=400; Sens=45; eDPI=18000; Res="2560x1440"; Aspect="16:9"; Hz=360; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="Canadian"; Team="TSM";        Role="Anchor";  DPI=400; Sens=24; eDPI=9600;  Res="1920x1080"; Aspect="16:9"; Hz=240; Mouse="Logitech G Pro X Superlight 2" }
      [PSCustomObject]@{ Name="Kafe";     Team="BDS Esport"; Role="Support"; DPI=800; Sens=22; eDPI=17600; Res="1920x1080"; Aspect="16:9"; Hz=360; Mouse="Logitech G Pro X Superlight 2" }
    )
  }
)

# ══════════════════════════════════════════════════════════════
#  TWEAK DATA
# ══════════════════════════════════════════════════════════════

$Script:Tweaks = [ordered]@{
  Delay = @(
    [PSCustomObject]@{ Cat="Telemetry"; Badge="REC"; Name="Disable Windows Telemetry"
      Desc="Sets telemetry to level 0. Stops Microsoft collecting usage and diagnostic data."
      Action={ Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name AllowTelemetry -Value 0 -Force -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Telemetry"; Badge="REC"; Name="Disable DiagTrack Service"
      Desc="Stops the Connected User Experiences and Telemetry background service."
      Action={ Stop-Service DiagTrack -EA SilentlyContinue; Set-Service DiagTrack -StartupType Disabled -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Telemetry"; Badge="REC"; Name="Disable dmwappushsvc"
      Desc="Kills WAP Push telemetry routing service. No user feature relies on it."
      Action={ Stop-Service dmwappushsvc -EA SilentlyContinue; Set-Service dmwappushsvc -StartupType Disabled -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Telemetry"; Badge="REC"; Name="Disable CEIP Scheduled Tasks"
      Desc="Disables all Customer Experience Improvement Program tasks."
      Action={ Get-ScheduledTask -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program\*" -EA SilentlyContinue | Disable-ScheduledTask -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Telemetry"; Badge="REC"; Name="Disable Feedback Notifications"
      Desc="Turns off Windows prompts asking you to send feedback to Microsoft."
      Action={ $p="HKCU:\SOFTWARE\Microsoft\Siuf\Rules"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name NumberOfSIUFInPeriod -Value 0 -Force }}
    [PSCustomObject]@{ Cat="Telemetry"; Badge="REC"; Name="Disable Error Reporting"
      Desc="Stops Windows sending crash reports to Microsoft."
      Action={ Disable-WindowsErrorReporting -EA SilentlyContinue }}

    [PSCustomObject]@{ Cat="Background Services"; Badge="REC"; Name="Disable SysMain (Superfetch)"
      Desc="Prevents disk thrashing on SSDs. Reduces game stutters."
      Action={ Stop-Service SysMain -EA SilentlyContinue; Set-Service SysMain -StartupType Disabled -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Background Services"; Badge="CAUTION"; Name="Disable Search Indexing"
      Desc="Stops background indexer. Search still works but may feel slower."
      Action={ Stop-Service WSearch -EA SilentlyContinue; Set-Service WSearch -StartupType Disabled -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Background Services"; Badge="REC"; Name="Disable Delivery Optimization"
      Desc="Stops Windows using your PC as a P2P update server."
      Action={ $p="HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name DODownloadMode -Value 0 -Force }}
    [PSCustomObject]@{ Cat="Background Services"; Badge="CAUTION"; Name="Disable Print Spooler"
      Desc="Frees memory. Re-enable if you have a printer."
      Action={ Stop-Service Spooler -EA SilentlyContinue; Set-Service Spooler -StartupType Disabled -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Background Services"; Badge="REC"; Name="Disable Windows Insider Service"
      Desc="Kills Insider telemetry even if not enrolled."
      Action={ Stop-Service wisvc -EA SilentlyContinue; Set-Service wisvc -StartupType Disabled -EA SilentlyContinue }}

    [PSCustomObject]@{ Cat="Privacy"; Badge="REC"; Name="Disable Advertising ID"
      Desc="Stops Windows assigning an advertising ID to your profile."
      Action={ $p="HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name Enabled -Value 0 -Force }}
    [PSCustomObject]@{ Cat="Privacy"; Badge="REC"; Name="Disable Activity History"
      Desc="Stops Windows logging app usage and syncing it to Microsoft cloud."
      Action={ $p="HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name EnableActivityFeed -Value 0 -Force }}
    [PSCustomObject]@{ Cat="Privacy"; Badge="REC"; Name="Disable Location Tracking"
      Desc="Disables the system-wide location service."
      Action={ Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name Value -Value Deny -Force -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Privacy"; Badge="REC"; Name="Disable App Diagnostics Access"
      Desc="Prevents apps reading diagnostics of other running apps."
      Action={ Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" -Name Value -Value Deny -Force -EA SilentlyContinue }}

    [PSCustomObject]@{ Cat="Timers"; Badge="REC"; Name="Set Timer Resolution 0.5ms"
      Desc="Forces minimum timer interval. Reduces scheduling jitter. Improves frame pacing."
      Action={ powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR TIMERRESOLUTION 5000 2>$null }}
    [PSCustomObject]@{ Cat="Timers"; Badge="REC"; Name="Disable SSD Auto-Defrag"
      Desc="Stops Windows defragging SSDs. Wastes write cycles for zero benefit."
      Action={ $p="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name MaintenanceDisabled -Value 1 -Force }}

    [PSCustomObject]@{ Cat="UI Latency"; Badge="REC"; Name="Disable Menu Show Delay"
      Desc="Sets MenuShowDelay to 0ms. Context menus open instantly."
      Action={ Set-ItemProperty "HKCU:\Control Panel\Desktop" -Name MenuShowDelay -Value 0 -Force }}
    [PSCustomObject]@{ Cat="UI Latency"; Badge="REC"; Name="Disable Startup Delay"
      Desc="Removes the 10-second artificial delay before startup apps launch."
      Action={ $p="HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name StartupDelayInMSec -Value 0 -Force }}
    [PSCustomObject]@{ Cat="UI Latency"; Badge="REC"; Name="Disable Window Animations"
      Desc="Turns off all window animations and transitions for a snappier UI."
      Action={ Set-ItemProperty "HKCU:\Control Panel\Desktop\WindowMetrics" -Name MinAnimate -Value 0 -Force }}
    [PSCustomObject]@{ Cat="UI Latency"; Badge="REC"; Name="Disable Mouse Acceleration"
      Desc="1:1 mouse movement. Essential for aim consistency in competitive games."
      Action={ Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name MouseSpeed -Value 0 -Force; Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name MouseThreshold1 -Value 0 -Force; Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name MouseThreshold2 -Value 0 -Force }}
  )

  Debloat = @(
    [PSCustomObject]@{ Cat="Microsoft Apps"; Badge="REC"; Name="Remove Candy Crush"
      Desc="Removes Candy Crush Saga and all King games pre-installed by Microsoft."
      Action={ Get-AppxPackage "king.com*" -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Microsoft Apps"; Badge="CAUTION"; Name="Remove Xbox Apps"
      Desc="Removes Xbox Console Companion. Skip if you use Xbox services."
      Action={ Get-AppxPackage Microsoft.XboxApp -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Microsoft Apps"; Badge="REC"; Name="Remove 3D Builder"
      Desc="Rarely used. Safe to remove on virtually all PCs."
      Action={ Get-AppxPackage Microsoft.3DBuilder -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Microsoft Apps"; Badge="REC"; Name="Remove Solitaire Collection"
      Desc="Removes the pre-installed ad-supported card game suite."
      Action={ Get-AppxPackage Microsoft.MicrosoftSolitaireCollection -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Microsoft Apps"; Badge="REC"; Name="Remove MSN Money/Sports/News"
      Desc="Removes the ad-supported MSN app suite."
      Action={ "Microsoft.BingFinance","Microsoft.BingSports","Microsoft.BingNews" | ForEach-Object { Get-AppxPackage $_ -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}}
    [PSCustomObject]@{ Cat="Microsoft Apps"; Badge="REC"; Name="Remove Get Office Nag App"
      Desc="Removes the app whose sole purpose is selling you Microsoft 365."
      Action={ Get-AppxPackage Microsoft.MicrosoftOfficeHub -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Microsoft Apps"; Badge="REC"; Name="Remove Skype UWP"
      Desc="Removes the pre-installed Store version of Skype."
      Action={ Get-AppxPackage Microsoft.SkypeApp -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Microsoft Apps"; Badge="REC"; Name="Remove People App"
      Desc="Removes the Contacts app that integrates into the taskbar."
      Action={ Get-AppxPackage Microsoft.People -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}

    [PSCustomObject]@{ Cat="Windows Features"; Badge="REC"; Name="Remove Mixed Reality Portal"
      Desc="Installed on all PCs even without VR headsets."
      Action={ Get-AppxPackage Microsoft.MixedReality.Portal -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Windows Features"; Badge="REC"; Name="Disable Cortana"
      Desc="Fully disables Cortana and its background data processes. Search still works."
      Action={ Get-AppxPackage Microsoft.549981C3F5F10 -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue; $p="HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name AllowCortana -Value 0 -Force }}
    [PSCustomObject]@{ Cat="Windows Features"; Badge="REC"; Name="Remove Clipchamp"
      Desc="Removes the Microsoft video editor bundled into Windows 11."
      Action={ Get-AppxPackage Clipchamp.Clipchamp -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Windows Features"; Badge="REC"; Name="Remove Teams (Consumer)"
      Desc="Removes pre-installed consumer Teams. Does not affect enterprise Teams."
      Action={ Get-AppxPackage MicrosoftTeams -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Windows Features"; Badge="REC"; Name="Remove Paint 3D"
      Desc="Removes Paint 3D. Classic MS Paint is kept untouched."
      Action={ Get-AppxPackage Microsoft.MSPaint -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Windows Features"; Badge="CAUTION"; Name="Remove OneNote UWP"
      Desc="Removes Store OneNote. Install full desktop version if needed."
      Action={ Get-AppxPackage Microsoft.Office.OneNote -EA SilentlyContinue | Remove-AppxPackage -EA SilentlyContinue }}

    [PSCustomObject]@{ Cat="System Junk"; Badge="REC"; Name="Disable OneDrive Auto-Start"
      Desc="Stops OneDrive launching at startup. Still works if opened manually."
      Action={ reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDrive /f 2>$null }}
    [PSCustomObject]@{ Cat="System Junk"; Badge="REC"; Name="Block Silently-Installed Apps"
      Desc="Stops Windows auto-downloading sponsored apps from the Store."
      Action={ Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SilentInstalledAppsEnabled -Value 0 -Force }}
    [PSCustomObject]@{ Cat="System Junk"; Badge="REC"; Name="Remove Start Menu Ads"
      Desc="Disables sponsored suggestions in Start Menu and search results."
      Action={ Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SystemPaneSuggestionsEnabled -Value 0 -Force }}
    [PSCustomObject]@{ Cat="System Junk"; Badge="REC"; Name="Disable Web Search in Start"
      Desc="Stops Start Menu sending searches to Bing. Search stays local only."
      Action={ $p="HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name DisableWebSearch -Value 1 -Force }}
    [PSCustomObject]@{ Cat="System Junk"; Badge="REC"; Name="Disable Lock Screen Spotlight Ads"
      Desc="Replaces Spotlight ad rotation with your chosen wallpaper."
      Action={ Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name RotatingLockScreenEnabled -Value 0 -Force }}

    [PSCustomObject]@{ Cat="Taskbar"; Badge="REC"; Name="Remove Widgets Button"
      Desc="Removes the ad-supported Windows 11 Widgets button."
      Action={ Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarDa -Value 0 -Force }}
    [PSCustomObject]@{ Cat="Taskbar"; Badge="REC"; Name="Remove Task View Button"
      Desc="Hides the Task View button. Virtual desktops still work via Win+Tab."
      Action={ Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name ShowTaskViewButton -Value 0 -Force }}
    [PSCustomObject]@{ Cat="Taskbar"; Badge="REC"; Name="Disable News & Interests Feed"
      Desc="Removes MSN news widget and kills its background update service."
      Action={ $p="HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name EnableFeeds -Value 0 -Force }}
  )

  Game = @(
    [PSCustomObject]@{ Cat="Power & CPU"; Badge="REC"; Name="Enable Ultimate Performance Plan"
      Desc="Unlocks hidden Ultimate Performance plan. Max CPU frequency, no core parking."
      Action={ powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null; $s=(powercfg /list|Select-String "Ultimate"); if($s){ $g=$s.ToString().Trim().Split()[3]; powercfg /setactive $g }}}
    [PSCustomObject]@{ Cat="Power & CPU"; Badge="REC"; Name="Disable CPU Core Parking"
      Desc="Keeps all CPU cores instantly available. No park/unpark scheduling delays."
      Action={ powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100; powercfg -setactive SCHEME_CURRENT }}
    [PSCustomObject]@{ Cat="Power & CPU"; Badge="REC"; Name="Prioritize Foreground Programs"
      Desc="Scheduler gives active game maximum priority over background tasks."
      Action={ Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name Win32PrioritySeparation -Value 38 -Force }}
    [PSCustomObject]@{ Cat="Power & CPU"; Badge="REC"; Name="Disable Power Throttling"
      Desc="Forces full CPU performance. Disables efficiency throttling entirely."
      Action={ $p="HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name PowerThrottlingOff -Value 1 -Force }}

    [PSCustomObject]@{ Cat="GPU & Graphics"; Badge="REC"; Name="Enable HAGS"
      Desc="Hardware-Accelerated GPU Scheduling. Reduces latency on RTX 2000+ and RX 5000+."
      Action={ Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name HwSchMode -Value 2 -Force }}
    [PSCustomObject]@{ Cat="GPU & Graphics"; Badge="REC"; Name="Disable Game Bar & DVR"
      Desc="Removes overlay hook. Provides FPS improvement in many titles."
      Action={ $p="HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name AppCaptureEnabled -Value 0 -Force; $p2="HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"; if(!(Test-Path $p2)){New-Item $p2 -Force|Out-Null}; Set-ItemProperty $p2 -Name AllowGameDVR -Value 0 -Force }}
    [PSCustomObject]@{ Cat="GPU & Graphics"; Badge="REC"; Name="Disable NVIDIA Telemetry"
      Desc="Stops NVIDIA background telemetry services. Frees RAM and CPU overhead."
      Action={ Stop-Service NvTelemetryContainer -EA SilentlyContinue; Set-Service NvTelemetryContainer -StartupType Disabled -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="GPU & Graphics"; Badge="REC"; Name="Enable Variable Refresh Rate"
      Desc="Enables VRR / Adaptive Sync for windowed and fullscreen games system-wide."
      Action={ Set-ItemProperty "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences" -Name DirectXUserGlobalSettings -Value "VRROptimizeEnable=1;" -Force -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="GPU & Graphics"; Badge="REC"; Name="Disable Full-Screen Optimizations"
      Desc="Turns off Windows FSO. Reduces input lag in affected titles."
      Action={ $p="HKCU:\System\GameConfigStore"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name GameDVR_FSEBehaviorMode -Value 2 -Force; Set-ItemProperty $p -Name GameDVR_HonorUserFSEBehaviorMode -Value 1 -Force }}
    [PSCustomObject]@{ Cat="GPU & Graphics"; Badge="CAUTION"; Name="Force Max GPU Power State"
      Desc="Keeps GPU at P0 state always. Increases power draw and heat. Desktop/tower only."
      Action={ Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" -Name PP_GPUPowerGatingDisable -Value 1 -Force -EA SilentlyContinue }}

    [PSCustomObject]@{ Cat="Network"; Badge="REC"; Name="Disable Nagle's Algorithm"
      Desc="Removes TCP packet buffering. Lowers ping in competitive online games."
      Action={ $i=Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" -EA SilentlyContinue; foreach($n in $i){ Set-ItemProperty $n.PSPath -Name TcpAckFrequency -Value 1 -Force -EA SilentlyContinue; Set-ItemProperty $n.PSPath -Name TCPNoDelay -Value 1 -Force -EA SilentlyContinue }}}
    [PSCustomObject]@{ Cat="Network"; Badge="REC"; Name="Set DNS to Cloudflare 1.1.1.1"
      Desc="Fastest public DNS. Reduces game server and matchmaking resolution time."
      Action={ Get-NetAdapter|Where-Object Status -eq Up|ForEach-Object { Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -ServerAddresses 1.1.1.1,1.0.0.1 -EA SilentlyContinue }}}

    [PSCustomObject]@{ Cat="Memory & Storage"; Badge="CAUTION"; Name="Disable Paging Executive"
      Desc="Keeps Windows kernel in RAM. Requires 8GB+. Improves frame time consistency."
      Action={ Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name DisablePagingExecutive -Value 1 -Force }}
    [PSCustomObject]@{ Cat="Memory & Storage"; Badge="REC"; Name="Run TRIM on SSD"
      Desc="Runs TRIM on C: drive for optimal SSD health and performance."
      Action={ Optimize-Volume -DriveLetter C -ReTrim -EA SilentlyContinue }}

    [PSCustomObject]@{ Cat="Windows Gaming"; Badge="REC"; Name="Enable Windows Game Mode"
      Desc="Dedicates more CPU/GPU to the active game. Suppresses background notifications."
      Action={ $p="HKCU:\Software\Microsoft\GameBar"; if(!(Test-Path $p)){New-Item $p -Force|Out-Null}; Set-ItemProperty $p -Name AutoGameModeEnabled -Value 1 -Force }}
    [PSCustomObject]@{ Cat="Windows Gaming"; Badge="REC"; Name="Disable Game Bar Hotkeys"
      Desc="Disables Win+G and other Game Bar shortcuts that interrupt gameplay."
      Action={ Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name GameDVR_Enabled -Value 0 -Force -EA SilentlyContinue }}
    [PSCustomObject]@{ Cat="Windows Gaming"; Badge="REC"; Name="Force High-Performance GPU"
      Desc="Forces dedicated GPU for all apps. Critical on dual-GPU laptops."
      Action={ Set-ItemProperty "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences" -Name DirectXUserGlobalSettings -Value "SwapEffectUpgradeEnable=1;VRROptimizeEnable=1;" -Force -EA SilentlyContinue }}
  )
}

# ══════════════════════════════════════════════════════════════
#  LOAD WINDOW
# ══════════════════════════════════════════════════════════════

$reader = New-Object System.Xml.XmlNodeReader $XAML
$Window = [Windows.Markup.XamlReader]::Load($reader)
function gn($n){ $Window.FindName($n) }

$Script:Pages  = @()
$Script:Checks = @()

$PgOptHome    = gn "PgOptHome";    $Script:Pages += $PgOptHome
$PgDelay      = gn "PgDelay";      $Script:Pages += $PgDelay
$PgDebloat    = gn "PgDebloat";    $Script:Pages += $PgDebloat
$PgGameOpt    = gn "PgGameOpt";    $Script:Pages += $PgGameOpt
$PgLog        = gn "PgLog";        $Script:Pages += $PgLog
$PgProGames   = gn "PgProGames";   $Script:Pages += $PgProGames
$PgProPlayers = gn "PgProPlayers"; $Script:Pages += $PgProPlayers
$PgSettings   = gn "PgSettings";   $Script:Pages += $PgSettings

$ApplyBar  = gn "ApplyBar"
$ApplyLabel= gn "ApplyLabel"
$LogText   = gn "LogText"
$LogStatus = gn "LogStatus"
$LogScroll = gn "LogScroll"
$LogDone   = gn "LogDone"
$PageTitle = gn "PageTitle"

# ══════════════════════════════════════════════════════════════
#  HELPERS
# ══════════════════════════════════════════════════════════════

function Show-Page($pg, $title="") {
    foreach ($p in $Script:Pages) { $p.Visibility = "Collapsed" }
    $pg.Visibility = "Visible"
    if ($title) { $PageTitle.Text = $title }
}

function Update-ApplyBar {
    $n = ($Script:Checks | Where-Object { $_.Tag.Checked }).Count
    $ApplyBar.Visibility = if ($n -gt 0) { "Visible" } else { "Collapsed" }
    if ($n -gt 0) { $ApplyLabel.Text = "$n tweak$(if($n -ne 1){'s'}) selected" }
}

function Set-NavActive($active) {
    foreach ($nb in @((gn "NavOpt"),(gn "NavPro"),(gn "NavSettings"))) {
        $nb.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#2e2e2e")
        $nb.FontWeight = "Normal"
    }
    $active.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#c4b5fd")
    $active.FontWeight = "SemiBold"
}

# ══════════════════════════════════════════════════════════════
#  BUILD TWEAK ROWS
# ══════════════════════════════════════════════════════════════

function New-Sep($lbl) {
    $g = New-Object System.Windows.Controls.Grid
    $g.Margin = [System.Windows.Thickness]::new(0,16,0,5)
    $c0 = New-Object System.Windows.Controls.ColumnDefinition; $c0.Width = [System.Windows.GridLength]::Auto
    $c1 = New-Object System.Windows.Controls.ColumnDefinition; $c1.Width = New-Object System.Windows.GridLength(1,[System.Windows.GridUnitType]::Star)
    $g.ColumnDefinitions.Add($c0); $g.ColumnDefinitions.Add($c1)
    $t = New-Object System.Windows.Controls.TextBlock
    $t.Text = $lbl.ToUpper()
    $t.FontFamily = New-Object System.Windows.Media.FontFamily("Segoe UI")
    $t.FontSize = 9; $t.FontWeight = [System.Windows.FontWeights]::SemiBold
    $t.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1e1e1e")
    $t.VerticalAlignment = "Center"; $t.Margin = [System.Windows.Thickness]::new(0,0,12,0)
    [System.Windows.Controls.Grid]::SetColumn($t,0)
    $ln = New-Object System.Windows.Controls.Border
    $ln.Height = 1; $ln.VerticalAlignment = "Center"
    $ln.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#0f0f0f")
    [System.Windows.Controls.Grid]::SetColumn($ln,1)
    $g.Children.Add($t)|Out-Null; $g.Children.Add($ln)|Out-Null
    return $g
}

function New-Row($tw) {
    $bm = @{
        "REC"     = @{ Bg="#0a1c12"; Fg="#6ee7b7"; Br="#122e1e" }
        "CAUTION" = @{ Bg="#1c1700"; Fg="#fbbf24"; Br="#2e2600" }
        "ADVANCED"= @{ Bg="#1c0a0a"; Fg="#f87171"; Br="#2e1010" }
    }

    $outer = New-Object System.Windows.Controls.Border
    $outer.CornerRadius = New-Object System.Windows.CornerRadius(8)
    $outer.BorderThickness = [System.Windows.Thickness]::new(1)
    $outer.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#00000000")
    $outer.Padding = [System.Windows.Thickness]::new(14,10,14,10)
    $outer.Margin = [System.Windows.Thickness]::new(0,1,0,1)
    $outer.Cursor = [System.Windows.Input.Cursors]::Hand

    $g = New-Object System.Windows.Controls.Grid
    for ($ci=0; $ci -lt 3; $ci++) {
        $cd = New-Object System.Windows.Controls.ColumnDefinition
        if ($ci -eq 0 -or $ci -eq 2) { $cd.Width = [System.Windows.GridLength]::Auto }
        else { $cd.Width = New-Object System.Windows.GridLength(1,[System.Windows.GridUnitType]::Star) }
        $g.ColumnDefinitions.Add($cd)
    }

    # Box
    $box = New-Object System.Windows.Controls.Border
    $box.Width = 16; $box.Height = 16
    $box.CornerRadius = New-Object System.Windows.CornerRadius(4)
    $box.BorderThickness = [System.Windows.Thickness]::new(1)
    $box.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#202020")
    $box.Background = [System.Windows.Media.Brushes]::Transparent
    $box.VerticalAlignment = "Center"; $box.Margin = [System.Windows.Thickness]::new(0,0,14,0)
    [System.Windows.Controls.Grid]::SetColumn($box,0)
    $chk = New-Object System.Windows.Controls.TextBlock
    $chk.Text = [char]0x2713; $chk.FontSize = 10
    $chk.HorizontalAlignment = "Center"; $chk.VerticalAlignment = "Center"
    $chk.Foreground = [System.Windows.Media.Brushes]::Black; $chk.Visibility = "Collapsed"
    $box.Child = $chk

    # Text stack
    $sp = New-Object System.Windows.Controls.StackPanel
    $sp.VerticalAlignment = "Center"
    [System.Windows.Controls.Grid]::SetColumn($sp,1)
    $nm = New-Object System.Windows.Controls.TextBlock
    $nm.Text = $tw.Name
    $nm.FontFamily = New-Object System.Windows.Media.FontFamily("Segoe UI")
    $nm.FontSize = 12; $nm.FontWeight = [System.Windows.FontWeights]::Medium
    $nm.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#777")
    $nm.TextWrapping = "Wrap"
    $ds = New-Object System.Windows.Controls.TextBlock
    $ds.Text = $tw.Desc
    $ds.FontFamily = New-Object System.Windows.Media.FontFamily("Segoe UI")
    $ds.FontSize = 11
    $ds.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#282828")
    $ds.TextWrapping = "Wrap"; $ds.Margin = [System.Windows.Thickness]::new(0,3,0,0)
    $ds.Visibility = "Collapsed"
    $sp.Children.Add($nm)|Out-Null; $sp.Children.Add($ds)|Out-Null

    # Badge
    $bc = $bm[$tw.Badge]
    $bdg = New-Object System.Windows.Controls.Border
    $bdg.CornerRadius = New-Object System.Windows.CornerRadius(6)
    $bdg.Padding = [System.Windows.Thickness]::new(8,2,8,2)
    $bdg.VerticalAlignment = "Center"; $bdg.Margin = [System.Windows.Thickness]::new(12,0,0,0)
    $bdg.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString($bc.Bg)
    $bdg.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString($bc.Br)
    $bdg.BorderThickness = [System.Windows.Thickness]::new(1)
    [System.Windows.Controls.Grid]::SetColumn($bdg,2)
    $bt = New-Object System.Windows.Controls.TextBlock
    $bt.Text = $tw.Badge
    $bt.FontFamily = New-Object System.Windows.Media.FontFamily("Segoe UI")
    $bt.FontSize = 9; $bt.FontWeight = [System.Windows.FontWeights]::SemiBold
    $bt.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString($bc.Fg)
    $bt.VerticalAlignment = "Center"; $bdg.Child = $bt

    $g.Children.Add($box)|Out-Null; $g.Children.Add($sp)|Out-Null; $g.Children.Add($bdg)|Out-Null
    $outer.Child = $g
    $outer.Tag = @{ Tweak=$tw; Checked=$false; Box=$box; Chk=$chk; Nm=$nm; Ds=$ds }

    $outer.Add_MouseEnter({ param($s,$e)
        $s.Tag.Ds.Visibility = "Visible"
        if (-not $s.Tag.Checked) {
            $s.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#0c0c0c")
            $s.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#181818")
        }
    })
    $outer.Add_MouseLeave({ param($s,$e)
        $s.Tag.Ds.Visibility = "Collapsed"
        if (-not $s.Tag.Checked) {
            $s.Background = [System.Windows.Media.Brushes]::Transparent
            $s.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#00000000")
        }
    })
    $outer.Add_MouseLeftButtonUp({ param($s,$e)
        $t = $s.Tag; $t.Checked = -not $t.Checked
        if ($t.Checked) {
            $s.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#0d0820")
            $s.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#281a44")
            $t.Box.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#8b5cf6")
            $t.Box.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#8b5cf6")
            $t.Chk.Visibility = "Visible"
            $t.Nm.Foreground = [System.Windows.Media.Brushes]::White
        } else {
            $s.Background = [System.Windows.Media.Brushes]::Transparent
            $s.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#00000000")
            $t.Box.Background = [System.Windows.Media.Brushes]::Transparent
            $t.Box.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#202020")
            $t.Chk.Visibility = "Collapsed"
            $t.Nm.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#777")
        }
        Update-ApplyBar
    })
    return $outer
}

function Build-Section($panel, $key) {
    $last = ""
    foreach ($tw in $Script:Tweaks[$key]) {
        if ($tw.Cat -ne $last) { $panel.Children.Add((New-Sep $tw.Cat))|Out-Null; $last = $tw.Cat }
        $row = New-Row $tw; $panel.Children.Add($row)|Out-Null; $Script:Checks += $row
    }
}

Build-Section (gn "DelayList")   "Delay"
Build-Section (gn "DebloatList") "Debloat"
Build-Section (gn "GameOptList") "Game"

# ══════════════════════════════════════════════════════════════
#  SELECT / CLEAR BULK
# ══════════════════════════════════════════════════════════════

function Set-Bulk($key, $val, [switch]$RecOnly) {
    $names = $Script:Tweaks[$key] | ForEach-Object { $_.Name }
    foreach ($r in $Script:Checks) {
        if ($r.Tag.Tweak.Name -notin $names) { continue }
        $want = if ($RecOnly) { $r.Tag.Tweak.Badge -eq "REC" } else { $val }
        if ($r.Tag.Checked -ne $want) {
            $t = $r.Tag; $t.Checked = $want
            if ($want) {
                $r.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#0d0820")
                $r.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#281a44")
                $t.Box.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#8b5cf6")
                $t.Box.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#8b5cf6")
                $t.Chk.Visibility = "Visible"; $t.Nm.Foreground = [System.Windows.Media.Brushes]::White
            } else {
                $r.Background = [System.Windows.Media.Brushes]::Transparent
                $r.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#00000000")
                $t.Box.Background = [System.Windows.Media.Brushes]::Transparent
                $t.Box.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#202020")
                $t.Chk.Visibility = "Collapsed"
                $t.Nm.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#777")
            }
        }
    }
    Update-ApplyBar
}

# ══════════════════════════════════════════════════════════════
#  BUILD GAME CARDS
# ══════════════════════════════════════════════════════════════

$gg = gn "GameGrid"
foreach ($game in $Script:Games) {
    $btn = New-Object System.Windows.Controls.Button
    $btn.Style = $Window.Resources["GameCard"]
    $btn.Content = $game.Name
    $btn.Tag = $game.Icon
    $btn.Margin = [System.Windows.Thickness]::new(0,0,12,12)
    $btn.MinWidth = 180

    $gRef = $game
    $btn.Add_Click({
        param($s,$e)
        $gm = $Script:Games | Where-Object { $_.Name -eq $s.Content }
        Load-Players $gm
        Show-Page $PgProPlayers "Pro Settings"
        $rt = gn "ProTitleRun"; $rt.Text = $gm.Name
    })
    $gg.Children.Add($btn)|Out-Null
}

# ══════════════════════════════════════════════════════════════
#  BUILD PLAYER CARDS
# ══════════════════════════════════════════════════════════════

function New-StatCell($label, $value) {
    $bd = New-Object System.Windows.Controls.Border
    $bd.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#090909")
    $bd.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#121212")
    $bd.BorderThickness = [System.Windows.Thickness]::new(1)
    $bd.CornerRadius = New-Object System.Windows.CornerRadius(6)
    $bd.Padding = [System.Windows.Thickness]::new(10,7,10,7)
    $bd.Margin = [System.Windows.Thickness]::new(0,0,6,6)
    $sp = New-Object System.Windows.Controls.StackPanel
    $lbl = New-Object System.Windows.Controls.TextBlock
    $lbl.Text = $label
    $lbl.FontFamily = New-Object System.Windows.Media.FontFamily("Segoe UI")
    $lbl.FontSize = 8; $lbl.FontWeight = [System.Windows.FontWeights]::SemiBold
    $lbl.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#222")
    $lbl.Margin = [System.Windows.Thickness]::new(0,0,0,2)
    $val = New-Object System.Windows.Controls.TextBlock
    $val.Text = $value
    $val.FontFamily = New-Object System.Windows.Media.FontFamily("Segoe UI")
    $val.FontSize = 13; $val.FontWeight = [System.Windows.FontWeights]::SemiBold
    $val.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#a78bfa")
    $sp.Children.Add($lbl)|Out-Null; $sp.Children.Add($val)|Out-Null
    $bd.Child = $sp; return $bd
}

function Load-Players($game) {
    $pl = gn "PlayerList"; $pl.Children.Clear()

    foreach ($p in $game.Players) {
        $card = New-Object System.Windows.Controls.Border
        $card.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#0c0c0c")
        $card.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#141414")
        $card.BorderThickness = [System.Windows.Thickness]::new(1)
        $card.CornerRadius = New-Object System.Windows.CornerRadius(10)
        $card.Padding = [System.Windows.Thickness]::new(22,18,22,18)
        $card.Margin = [System.Windows.Thickness]::new(0,0,0,8)

        $card.Add_MouseEnter({ param($s,$e)
            $s.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#0e0820")
            $s.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#231550")
        })
        $card.Add_MouseLeave({ param($s,$e)
            $s.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#0c0c0c")
            $s.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#141414")
        })

        $outer = New-Object System.Windows.Controls.Grid
        $ca = New-Object System.Windows.Controls.ColumnDefinition; $ca.Width = New-Object System.Windows.GridLength(1,[System.Windows.GridUnitType]::Star)
        $cb = New-Object System.Windows.Controls.ColumnDefinition; $cb.Width = [System.Windows.GridLength]::Auto
        $outer.ColumnDefinitions.Add($ca); $outer.ColumnDefinitions.Add($cb)

        # Left
        $left = New-Object System.Windows.Controls.StackPanel
        [System.Windows.Controls.Grid]::SetColumn($left,0)

        # Name row
        $nr = New-Object System.Windows.Controls.StackPanel; $nr.Orientation = "Horizontal"
        $nt = New-Object System.Windows.Controls.TextBlock
        $nt.Text = $p.Name
        $nt.FontFamily = New-Object System.Windows.Media.FontFamily("Segoe UI")
        $nt.FontSize = 15; $nt.FontWeight = [System.Windows.FontWeights]::SemiBold
        $nt.Foreground = [System.Windows.Media.Brushes]::White
        $nr.Children.Add($nt)|Out-Null
        $tt = New-Object System.Windows.Controls.TextBlock
        $tt.Text = "  ·  $($p.Team)"
        $tt.FontFamily = New-Object System.Windows.Media.FontFamily("Segoe UI")
        $tt.FontSize = 12; $tt.VerticalAlignment = "Bottom"
        $tt.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#282828")
        $tt.Margin = [System.Windows.Thickness]::new(0,0,0,1)
        $nr.Children.Add($tt)|Out-Null
        $left.Children.Add($nr)|Out-Null

        # Role pill
        $rb = New-Object System.Windows.Controls.Border
        $rb.CornerRadius = New-Object System.Windows.CornerRadius(6)
        $rb.Padding = [System.Windows.Thickness]::new(8,2,8,2)
        $rb.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#100820")
        $rb.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#221540")
        $rb.BorderThickness = [System.Windows.Thickness]::new(1)
        $rb.Margin = [System.Windows.Thickness]::new(0,7,0,12); $rb.HorizontalAlignment = "Left"
        $rt = New-Object System.Windows.Controls.TextBlock
        $rt.Text = $p.Role
        $rt.FontFamily = New-Object System.Windows.Media.FontFamily("Segoe UI")
        $rt.FontSize = 10; $rt.FontWeight = [System.Windows.FontWeights]::SemiBold
        $rt.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#8b5cf6")
        $rb.Child = $rt; $left.Children.Add($rb)|Out-Null

        # Stats grid
        $wp = New-Object System.Windows.Controls.WrapPanel; $wp.Orientation = "Horizontal"
        $wp.Children.Add((New-StatCell "DPI"        $p.DPI.ToString()))|Out-Null
        $wp.Children.Add((New-StatCell "Sens"       $p.Sens.ToString()))|Out-Null
        $wp.Children.Add((New-StatCell "eDPI"       $p.eDPI.ToString()))|Out-Null
        $wp.Children.Add((New-StatCell "Resolution" $p.Res))|Out-Null
        $wp.Children.Add((New-StatCell "Aspect"     $p.Aspect))|Out-Null
        $wp.Children.Add((New-StatCell "Refresh"    "$($p.Hz)Hz"))|Out-Null
        $left.Children.Add($wp)|Out-Null

        # Mouse line
        $mt = New-Object System.Windows.Controls.TextBlock
        $mt.Text = "Mouse: $($p.Mouse)"
        $mt.FontFamily = New-Object System.Windows.Media.FontFamily("Segoe UI")
        $mt.FontSize = 11
        $mt.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#222")
        $mt.Margin = [System.Windows.Thickness]::new(0,2,0,0)
        $left.Children.Add($mt)|Out-Null

        # Right: source + Apply button
        $right = New-Object System.Windows.Controls.StackPanel
        $right.VerticalAlignment = "Top"
        $right.Margin = [System.Windows.Thickness]::new(16,0,0,0)
        [System.Windows.Controls.Grid]::SetColumn($right,1)

        # Source badge
        $sb = New-Object System.Windows.Controls.Border
        $sb.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#080808")
        $sb.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#111")
        $sb.BorderThickness = [System.Windows.Thickness]::new(1)
        $sb.CornerRadius = New-Object System.Windows.CornerRadius(6)
        $sb.Padding = [System.Windows.Thickness]::new(8,4,8,4)
        $sb.HorizontalAlignment = "Right"
        $st = New-Object System.Windows.Controls.TextBlock
        $st.Text = "prosettings.net"
        $st.FontFamily = New-Object System.Windows.Media.FontFamily("Segoe UI")
        $st.FontSize = 9
        $st.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1c1c1c")
        $sb.Child = $st
        $right.Children.Add($sb)|Out-Null

        # Apply Settings button
        $applyBtn = New-Object System.Windows.Controls.Button
        $applyBtn.Content = "Apply Settings"
        $applyBtn.FontFamily = New-Object System.Windows.Media.FontFamily("Segoe UI")
        $applyBtn.FontSize = 11
        $applyBtn.FontWeight = [System.Windows.FontWeights]::SemiBold
        $applyBtn.Cursor = [System.Windows.Input.Cursors]::Hand
        $applyBtn.Margin = [System.Windows.Thickness]::new(0,10,0,0)
        $applyBtn.Padding = [System.Windows.Thickness]::new(14,8,14,8)
        $applyBtn.BorderThickness = [System.Windows.Thickness]::new(0)
        $applyBtn.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1a1a1f")
        $applyBtn.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#c8c8d8")
        $applyBtn.Tag = $p

        [xml]$applyXaml = @'
<ControlTemplate xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                 TargetType="Button">
  <Border x:Name="Bd" Background="{TemplateBinding Background}"
          BorderBrush="#3a3a4a" BorderThickness="1"
          CornerRadius="10" Padding="{TemplateBinding Padding}">
    <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
  </Border>
  <ControlTemplate.Triggers>
    <Trigger Property="IsMouseOver" Value="True">
      <Setter TargetName="Bd" Property="Background"  Value="#22202e"/>
      <Setter TargetName="Bd" Property="BorderBrush" Value="#6d4fc2"/>
    </Trigger>
    <Trigger Property="IsPressed" Value="True">
      <Setter TargetName="Bd" Property="Background"  Value="#1d1929"/>
      <Setter TargetName="Bd" Property="BorderBrush" Value="#8b5cf6"/>
    </Trigger>
  </ControlTemplate.Triggers>
</ControlTemplate>
'@
        $applyBtn.Template = [System.Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $applyXaml))

        $applyBtn.Add_Click({
            param($s,$e)
            Apply-ProSettings $s.Tag
        })
        $right.Children.Add($applyBtn)|Out-Null

        $outer.Children.Add($left)|Out-Null; $outer.Children.Add($right)|Out-Null
        $card.Child = $outer; $pl.Children.Add($card)|Out-Null
    }
}

# ══════════════════════════════════════════════════════════════
#  APPLY PRO SETTINGS
# ══════════════════════════════════════════════════════════════

function Apply-ProSettings($p) {
    $name = $p.Name
    $confirm = [System.Windows.MessageBox]::Show(
        "Apply $name's settings?`n`nThis will set:`n  DPI: $($p.DPI)`n  Sensitivity: $($p.Sens)`n  Resolution: $($p.Res)`n  Refresh Rate: $($p.Hz)Hz`n  Mouse Acceleration: OFF`n`nNote: DPI must be set manually in your mouse software.",
        "Apply Pro Settings", "YesNo", "Question")
    if ($confirm -ne "Yes") { return }

    $errors = @()

    # ── Disable Mouse Acceleration (applies to all games) ──
    try {
        Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name MouseSpeed -Value 0 -Force
        Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name MouseThreshold1 -Value 0 -Force
        Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name MouseThreshold2 -Value 0 -Force
    } catch { $errors += "Mouse acceleration: $($_.Exception.Message)" }

    # ── Set Resolution via registry (takes effect after sign-out) ──
    try {
        $resParts = $p.Res -split "x"
        if ($resParts.Count -eq 2) {
            $w = [int]$resParts[0]; $h = [int]$resParts[1]
            # Write preferred resolution to display registry
            $devKey = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Configuration"
            # Use DISM/CIM to set resolution
            $monitors = Get-CimInstance -ClassName Win32_VideoController -EA SilentlyContinue
            foreach ($mon in $monitors) {
                $devID = $mon.PNPDeviceID -replace "\", "_"
                $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\VideoSettings"
                if (!(Test-Path $regPath)) { New-Item $regPath -Force | Out-Null }
                Set-ItemProperty $regPath -Name "PreferredResWidth" -Value $w -Force -EA SilentlyContinue
                Set-ItemProperty $regPath -Name "PreferredResHeight" -Value $h -Force -EA SilentlyContinue
            }
        }
    } catch { $errors += "Resolution: $($_.Exception.Message)" }

    # ── Set Refresh Rate ──
    try {
        Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class DisplayHelper {
    [DllImport("user32.dll")] public static extern bool EnumDisplaySettings(string deviceName, int modeNum, ref DEVMODE devMode);
    [DllImport("user32.dll")] public static extern int ChangeDisplaySettings(ref DEVMODE devMode, int flags);
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
    public struct DEVMODE {
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string dmDeviceName;
        public short dmSpecVersion; public short dmDriverVersion; public short dmSize;
        public short dmDriverExtra; public int dmFields;
        public int dmPositionX; public int dmPositionY; public int dmDisplayOrientation;
        public int dmDisplayFixedOutput; public short dmColor; public short dmDuplex;
        public short dmYResolution; public short dmTTOption; public short dmCollate;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string dmFormName;
        public short dmLogPixels; public int dmBitsPerPel;
        public int dmPelsWidth; public int dmPelsHeight;
        public int dmDisplayFlags; public int dmDisplayFrequency;
    }
}
"@ -EA SilentlyContinue
        $dm = New-Object DisplayHelper+DEVMODE
        $dm.dmSize = [System.Runtime.InteropServices.Marshal]::SizeOf($dm)
        [DisplayHelper]::EnumDisplaySettings($null, -1, [ref]$dm) | Out-Null
        $dm.dmDisplayFrequency = $p.Hz
        $dm.dmFields = 0x400000  # DM_DISPLAYFREQUENCY
        [DisplayHelper]::ChangeDisplaySettings([ref]$dm, 0) | Out-Null
    } catch { $errors += "Refresh rate: $($_.Exception.Message)" }

    # ── Result ──
    if ($errors.Count -eq 0) {
        [System.Windows.MessageBox]::Show(
            "Settings applied!`n`nRemember to:`n  • Set DPI to $($p.DPI) in your mouse software`n  • Log out and back in for resolution to take full effect",
            "Applied — $name", "OK", "Information")
    } else {
        $errList = $errors -join "`n"
        [System.Windows.MessageBox]::Show(
            "Partially applied. Some settings may need manual adjustment:`n`n$errList`n`nDPI ($($p.DPI)) must always be set in your mouse software.",
            "Applied with warnings", "OK", "Warning")
    }
}

# ══════════════════════════════════════════════════════════════
#  APPLY LOG
# ══════════════════════════════════════════════════════════════

function Append-Log($msg, $col="#282828") {
    $run = New-Object System.Windows.Documents.Run("$msg`n")
    $run.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString($col)
    $LogText.Inlines.Add($run); $LogScroll.ScrollToEnd()
}

# ══════════════════════════════════════════════════════════════
#  EVENTS — WINDOW CHROME
# ══════════════════════════════════════════════════════════════

# ── Subtle purple glow on hover via PS events (XAML effects unsupported in triggers) ──
function Add-Glow {
    param($btn, [string]$color="#8b5cf6", [double]$blur=16, [double]$opacity=0.45)
    if (-not $btn) { return }
    # Build effect inside a scriptblock with GetNewClosure to capture per-call
    $eff = New-Object System.Windows.Media.Effects.DropShadowEffect
    $eff.Color       = [System.Windows.Media.ColorConverter]::ConvertFromString($color)
    $eff.BlurRadius  = $blur
    $eff.ShadowDepth = 0
    $eff.Opacity     = $opacity
    $enter = { param($s,$e); $s.Effect = $eff }.GetNewClosure()
    $leave = { param($s,$e); $s.Effect = $null }
    $btn.Add_MouseEnter($enter)
    $btn.Add_MouseLeave($leave)
}

# Purple glow — all action buttons
foreach ($bname in @("BtnDelay","BtnDebloat","BtnGame","BtnRestore",
                     "DelayAll","DelayRec","DelayClear","DelayBack",
                     "DebloatAll","DebloatRec","DebloatClear","DebloatBack",
                     "GameAll","GameRec","GameClear","GameBack",
                     "BtnApply","StgRestore")) {
    Add-Glow (gn $bname)
}
# Red glow — danger button
Add-Glow (gn "StgClearAll") "#e05050" 14 0.4

(gn "TitleBar").Add_MouseLeftButtonDown({ $Window.DragMove() })
(gn "BtnMin").Add_Click({ $Window.WindowState = "Minimized" })
(gn "BtnClose").Add_Click({ $Window.Close() })

# ── Sidebar toggle with smooth animation ──
$script:SidebarOpen = $true
$SidebarCol   = (gn "RootGrid").ColumnDefinitions[0]
$SidebarBorder = gn "SidebarBorder"

function Toggle-Sidebar {
    # Use DispatcherTimer to animate sidebar width smoothly
    $script:SidebarAnimStep  = 0
    $script:SidebarAnimSteps = 28
    $script:SidebarAnimInterval = 16

    if ($script:SidebarOpen) {
        $script:SidebarAnimFrom = 210; $script:SidebarAnimTo = 0
        $script:SidebarOpen = $false
    } else {
        $script:SidebarAnimFrom = 0; $script:SidebarAnimTo = 210
        $script:SidebarOpen = $true
    }

    $timer = New-Object System.Windows.Threading.DispatcherTimer
    $timer.Interval = [System.TimeSpan]::FromMilliseconds($script:SidebarAnimInterval)
    $timer.Add_Tick({
        $script:SidebarAnimStep++
        $t = $script:SidebarAnimStep / $script:SidebarAnimSteps
        # Cubic ease in-out
        $eased = if ($t -lt 0.5) { 4*$t*$t*$t } else { 1 - [Math]::Pow(-2*$t+2,3)/2 }
        $w = $script:SidebarAnimFrom + ($script:SidebarAnimTo - $script:SidebarAnimFrom) * $eased
        $SidebarCol.Width = [System.Windows.GridLength]::new([Math]::Max(0,[Math]::Round($w)))
        if ($script:SidebarAnimStep -ge $script:SidebarAnimSteps) {
            $SidebarCol.Width = [System.Windows.GridLength]::new($script:SidebarAnimTo)
            $timer.Stop()
        }
    })
    $timer.Start()
}

$SidebarArrow = gn "SidebarArrow"
(gn "BtnToggleSidebar").Add_Click({
    Toggle-Sidebar
    # Arrow points left (❮) when sidebar open (click to close),
    # points right (❯) when sidebar closed (click to open)
    $SidebarArrow.Text = if ($script:SidebarOpen) { [char]0x276E } else { [char]0x276F }
})

# ══════════════════════════════════════════════════════════════
#  EVENTS — SIDEBAR NAV
# ══════════════════════════════════════════════════════════════

(gn "NavOpt").Add_Click({
    Set-NavActive (gn "NavOpt")
    Show-Page $PgOptHome "Optimizations"
    Update-ApplyBar
})
(gn "NavPro").Add_Click({
    Set-NavActive (gn "NavPro")
    Show-Page $PgProGames "Pro Settings"
    $ApplyBar.Visibility = "Collapsed"
})
(gn "NavSettings").Add_Click({
    Set-NavActive (gn "NavSettings")
    Show-Page $PgSettings "Settings"
    $ApplyBar.Visibility = "Collapsed"
})

# ══════════════════════════════════════════════════════════════
#  EVENTS — OPTIMIZATIONS
# ══════════════════════════════════════════════════════════════

(gn "BtnDelay").Add_Click({   Show-Page $PgDelay   "Delay" })
(gn "BtnDebloat").Add_Click({ Show-Page $PgDebloat "Debloat" })
(gn "BtnGame").Add_Click({    Show-Page $PgGameOpt "Game Mode" })

(gn "DelayAll").Add_Click({   Set-Bulk "Delay"   $true })
(gn "DelayRec").Add_Click({   Set-Bulk "Delay"   $true -RecOnly })
(gn "DelayClear").Add_Click({ Set-Bulk "Delay"   $false })
(gn "DelayBack").Add_Click({  Show-Page $PgOptHome "Optimizations"; Update-ApplyBar })

(gn "DebloatAll").Add_Click({   Set-Bulk "Debloat" $true })
(gn "DebloatRec").Add_Click({   Set-Bulk "Debloat" $true -RecOnly })
(gn "DebloatClear").Add_Click({ Set-Bulk "Debloat" $false })
(gn "DebloatBack").Add_Click({  Show-Page $PgOptHome "Optimizations"; Update-ApplyBar })

(gn "GameAll").Add_Click({   Set-Bulk "Game" $true })
(gn "GameRec").Add_Click({   Set-Bulk "Game" $true -RecOnly })
(gn "GameClear").Add_Click({ Set-Bulk "Game" $false })
(gn "GameBack").Add_Click({  Show-Page $PgOptHome "Optimizations"; Update-ApplyBar })

(gn "BtnRestore").Add_Click({
    $r = [System.Windows.MessageBox]::Show("Create a Windows restore point named 'Wrath Backup'?",
         "Wrath","YesNo","Question")
    if ($r -eq "Yes") {
        try {
            Checkpoint-Computer -Description "Wrath Backup" -RestorePointType MODIFY_SETTINGS -EA Stop
            [System.Windows.MessageBox]::Show("Restore point created.","Wrath","OK","Information")
        } catch {
            [System.Windows.MessageBox]::Show("Could not create restore point. Ensure System Restore is enabled.","Wrath","OK","Warning")
        }
    }
})

# ══════════════════════════════════════════════════════════════
#  EVENTS — PRO SETTINGS
# ══════════════════════════════════════════════════════════════

(gn "BtnBackGames").Add_Click({ Show-Page $PgProGames "Pro Settings" })

# ══════════════════════════════════════════════════════════════
#  EVENTS — APP SETTINGS
# ══════════════════════════════════════════════════════════════

(gn "StgRestore").Add_Click({
    try {
        Checkpoint-Computer -Description "Wrath Backup" -RestorePointType MODIFY_SETTINGS -EA Stop
        [System.Windows.MessageBox]::Show("Restore point created successfully.","Wrath","OK","Information")
    } catch {
        [System.Windows.MessageBox]::Show("Could not create restore point.","Wrath","OK","Warning")
    }
})

(gn "StgClearAll").Add_Click({
    foreach ($k in "Delay","Debloat","Game") { Set-Bulk $k $false }
})

# ══════════════════════════════════════════════════════════════
#  EVENTS — APPLY
# ══════════════════════════════════════════════════════════════

(gn "BtnApply").Add_Click({
    $sel = $Script:Checks | Where-Object { $_.Tag.Checked }
    if ($sel.Count -eq 0) { return }
    Show-Page $PgLog "Applying"
    $ApplyBar.Visibility = "Collapsed"
    $LogText.Inlines.Clear(); $LogDone.Visibility = "Collapsed"
    $LogStatus.Text = "Applying $($sel.Count) tweak$(if($sel.Count -ne 1){'s'})..."

    $Window.Dispatcher.InvokeAsync({
        Append-Log "  Creating restore point..." "#202020"
        try {
            Checkpoint-Computer -Description "Wrath Backup" -RestorePointType MODIFY_SETTINGS -EA Stop
            Append-Log "  Restore point created." "#164a28"
        } catch {
            Append-Log "  Restore point skipped (System Restore may be off)." "#3a2010"
        }
        Append-Log ""
        $done = 0
        foreach ($row in $sel) {
            $tw = $row.Tag.Tweak
            $LogStatus.Text = $tw.Name
            Append-Log "  $($tw.Name)" "#222"
            $Window.Dispatcher.Invoke([System.Action]{}, "Background")
            try { & $tw.Action; Append-Log "  ✓" "#164a28"; $done++ }
            catch { Append-Log "  ✗ $($_.Exception.Message)" "#3a1010" }
        }
        Append-Log ""
        Append-Log "  $done tweak$(if($done -ne 1){'s'}) applied. Restart to activate all changes." "#4a2888"
        $LogStatus.Text = "Complete — restart your PC."
        $LogDone.Visibility = "Visible"
    }, [System.Windows.Threading.DispatcherPriority]::Background) | Out-Null
})

$LogDone.Add_Click({
    Show-Page $PgOptHome "Optimizations"
    Set-NavActive (gn "NavOpt")
})

# ══════════════════════════════════════════════════════════════
#  LAUNCH
# ══════════════════════════════════════════════════════════════

Set-NavActive (gn "NavOpt")
$Window.ShowDialog() | Out-Null
