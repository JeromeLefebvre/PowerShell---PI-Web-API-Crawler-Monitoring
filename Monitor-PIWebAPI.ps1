# Retrive the last crawl date of a PI Data Archive
function Get-Data([string]$username, [string]$password, [string]$url) {
  $credPair = "$($username):$($password)"
  $encodedCredentials = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($credPair))
  $headers = @{ Authorization = "Basic $encodedCredentials" }
  $responseData = Invoke-WebRequest -Uri $url -Method Get -Headers $headers -UseBasicParsing
  return $responseData
}
$piwebapihost = "https://devdata.osisoft.com/"
$pi = "PISRV1"

$url = $piwebapihost + "piwebapi/search/sources?name=pi:" + $piwebapihost
$dataRaw = Get-Data -username webapiuser -password !try3.14webapi! -url https://devdata.osisoft.com/piwebapi/search/sources?name=pi:PISRV1

$json = $dataRaw | ConvertFrom-Json
$lastCrawl = $json.Items[0].LastCrawl

Write-Host Last crawl date: $lastCrawl

#Convert and store the value to store in tag with datetime type
$format = 'yyyy-MM-ddThh:mm:ss.fffffffZ'
$value = ([datetime]::parseexact($lastCrawl, 'yyyy-MM-ddThh:mm:ss.fffffffZ', $null)).ToUniversalTime()

$pi = Connect-PIDataArchive -PIDataArchiveMachineName masterpi
$tag = Get-PIPoint -Connection $pi -Name PIWebAPIStatus2
Add-PIValue -PIPoint $tag -Value $value -Time (ConvertFrom-AFRelativeTime -RelativeTime *)