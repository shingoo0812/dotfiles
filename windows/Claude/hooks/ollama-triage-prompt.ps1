# UserPromptSubmit hook: 長いユーザー入力を自動でOllamaに要約させる
# 80行または400語を超えたときにトリアージを実行
param()
$ErrorActionPreference = "SilentlyContinue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8

try {
    $raw = [Console]::In.ReadToEnd()
    $data = $raw | ConvertFrom-Json -ErrorAction Stop
    $prompt = $data.prompt
    if (-not $prompt) { exit 0 }

    $lines = ($prompt -split "`n").Count
    $words = ($prompt -split '\s+' | Where-Object { $_ -ne "" }).Count

    if ($lines -lt 80 -and $words -lt 400) { exit 0 }

    $escPrompt = $prompt -replace '\\', '\\\\' -replace '"', '\"' -replace "`n", '\n' -replace "`r", ''

    $body = [System.Text.Encoding]::UTF8.GetBytes("{`"model`":`"qwen2.5:latest`",`"prompt`":`"次のテキストのキーポイント・エラー・問題点を日本語で箇条書き5行以内で簡潔にまとめてください:\n\n$escPrompt`",`"stream`":false}")

    $req = [System.Net.HttpWebRequest]::Create("http://localhost:11434/api/generate")
    $req.Method = "POST"
    $req.ContentType = "application/json; charset=utf-8"
    $req.Timeout = 30000
    $req.ContentLength = $body.Length
    $reqStream = $req.GetRequestStream()
    $reqStream.Write($body, 0, $body.Length)
    $reqStream.Close()

    $res = $req.GetResponse()
    $reader = New-Object System.IO.StreamReader($res.GetResponseStream(), [System.Text.Encoding]::UTF8)
    $json = $reader.ReadToEnd() | ConvertFrom-Json
    $reader.Close()

    if ($json.response) {
        Write-Output "[Ollama自動トリアージ] 入力が長いため自動要約しました ($lines 行 / $words 語):"
        Write-Output $json.response
    }
} catch {
    # Ollamaが起動していない場合などは静かにスキップ
}
exit 0
