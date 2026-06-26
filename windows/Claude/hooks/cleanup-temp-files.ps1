# Deletes temp files Claude writes (system temp dir, *.tmp, temp_*, tmp_*)
$json = [Console]::In.ReadToEnd() | ConvertFrom-Json
$f = $json.tool_input.file_path
if (-not $f) { exit 0 }

$isTempDir = ($env:TEMP -and $f.StartsWith($env:TEMP, [System.StringComparison]::OrdinalIgnoreCase)) -or
             ($env:TMP  -and $f.StartsWith($env:TMP,  [System.StringComparison]::OrdinalIgnoreCase))
$name = [IO.Path]::GetFileName($f)
$isTempName = $f -match '\.(tmp|temp)$' -or $name -match '^(tmp_|temp_)'

if ($isTempDir -or $isTempName) {
    Remove-Item -LiteralPath $f -Force -ErrorAction SilentlyContinue
}
