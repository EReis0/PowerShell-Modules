<#
.SYNOPSIS
Parse a streamed Ollama JSON response into fragments and combined text.

.DESCRIPTION
`Parse-OllamaResponse` accepts the raw text returned from Ollama (often a stream
of JSON objects) and parses it into an object containing the combined `response` text
and an indexed list of `fragments` with metadata (`Index`, `Created`, `Done`, `Response`).

.PARAMETER rawResponse
Raw string output from the Ollama API, typically the body returned by `Invoke-RestMethod`.

.EXAMPLE
PS C:\> $parsed = Parse-OllamaResponse -rawResponse $raw
PS C:\> $parsed.response

.EXAMPLE
PS C:\> $parsed = Parse-OllamaResponse -rawResponse $raw
PS C:\> $parsed.fragments | Format-Table -AutoSize

.NOTES
This function tolerates multiple JSON objects per-line and non-JSON lines. It
returns `$null` when no valid JSON objects are found.
#>
function Parse-OllamaResponse {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true)][string]$rawResponse
	)

	$resObjs = @()

	$rawResponse -split "[\r\n]+" | ForEach-Object {
		$line = $_.Trim()
		if ([string]::IsNullOrWhiteSpace($line)) { return }

		# Extract JSON object(s) in the line (handles multiple objects on one line)
		$matches = [regex]::Matches($line, '\{.*?\}')
		if ($matches.Count -gt 0) {
			foreach ($m in $matches) {
				try {
					$obj = $m.Value | ConvertFrom-Json
					if ($obj) { $resObjs += $obj }
				} catch {
					Write-Verbose "Invalid JSON chunk skipped: $($m.Value)"
				}
			}
		} else {
			# Fallback: try converting the whole line
			try {
				$obj = $line | ConvertFrom-Json
				if ($obj) { $resObjs += $obj }
			} catch {
				Write-Verbose "No JSON on line: $line"
			}
		}
	}

	if ($resObjs.Count -eq 0) {
		return $null
	}

	# Combine all 'response' fragments into the full reply text
	$fullText = ($resObjs | ForEach-Object { $_.response }) -join ''

	# Build a fragments array with Index/Created/Done/Response for easy viewing
	$fragments = $resObjs | ForEach-Object -Begin { $idx = 1 } -Process {
		[PSCustomObject]@{
			Index    = $idx
			Created  = $_.created_at
			Done     = $_.done
			Response = $_.response
		}
		$idx++
	}

	# Return a convenient wrapper: .response => full text, .fragments => list
	return [PSCustomObject]@{
		response  = $fullText
		fragments = $fragments
		raw       = $rawResponse
	}
}

# Note: This file defines Parse-OllamaResponse. Call the function from scripts
# when you have a $rawResponse string, for example:
# $parsed = Parse-OllamaResponse -rawResponse $rawResponse