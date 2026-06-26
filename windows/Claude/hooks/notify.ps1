param(
    [string]$Title = "Claude Code",
    [string]$Message = "Claudeが入力を待っています"
)

Import-Module BurntToast -ErrorAction Stop
New-BurntToastNotification -Text $Title, $Message -Sound Default
