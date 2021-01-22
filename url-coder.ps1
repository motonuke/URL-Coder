[CmdletBinding()]
	param (
	
		[Parameter(
			Mandatory=$false,
			Position = 3,
			HelpMessage = "Please provide a string to decode or URL to encode"
		)]
		[string]$String= $(),
		
		[Parameter(
			Mandatory=$false,
			Position = 2,
			HelpMessage = "Open URL in browser?"
		)]
		[switch]$OpenURL= $(),
		
		[Parameter(
			Mandatory=$false,
			Position = 4,
			HelpMessage = "Double Decode/Encode string?"
		)]
		[switch]$Double= $(),		
		
		[Parameter(
			Mandatory=$true,
			Position = 1,
			HelpMessage = "Please provide a an action"
		)]
		[ValidateSet("Decode","Encode")]
		[string]$Action= $()
	)

switch ($Action)
			{
			Decode {
				write-host "Decoding String..."
				if (!$String) {
					write-host "Attempting to read from clipboard buffer..."
					if ($(get-clipboard).count -eq 1 ) {
						$String = $(get-clipboard)
						} 
					else {throw "Clipboard buffer impcompatible, please recopy your string"}
				}
				$decode = [Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($String))
				if ($Double) {$decode = [Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($decode)) }
				if ($OpenURL) {
					write-host "Opening Browser..."
					& "C:\Program Files\Mozilla Firefox\firefox.exe" -new-tab -url "$decode"
				} else {$decode}
			}
			Encode {
				# write-host "Encoding URL"
				$encode = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($String))
				if ($double) {$encode = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($encode)) }
				If ($double) {write-host "Double Encoded URL String: `n$encode"} else {write-host "Encoded URL String: `n$encode"}
				write-host "Encoded String has been copied to the clipboard..."
				set-clipboard $encode
				# $Bytes = [System.Text.Encoding]::Unicode.GetBytes($String)
				# [Convert]::ToBase64String($Bytes)
				}
			}
