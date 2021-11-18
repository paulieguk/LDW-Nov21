# Find values from Excel spreadsheet
$file = "C:\Data\SampleSalesData.xlsx"
$excel = New-Object -ComObject Excel.Application
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.Sheets.Item(1)
$sum = $worksheet.Range('H46').Text
$sum = $sum.Replace(' ','')
$formula = $worksheet.Range('H46').Formula

# Get sum from worksheet cells and close workbook
$v=0
$range = $worksheet.Range("H4:H45")
$range = $range.Formula
$range | foreach {$v +=$_}
$v = '$' + '{0:N}' -f $v
$workbook.Close()
$excel.Quit()

# Evaluate
function scoredItem
{
   if ($formula -notlike '=*')
   {
       $evidence += "No formula found`n"
   }
   elseif ($sum -ne $v)
   {
       $evidence += "The formula found is incorrect. The formula returned a total cost of $sum but we're expecting $v`n"
   }
   if ($evidence.Length -gt 0)
   {
       throw $evidence
   }
}

function evaluate
{
   $result = $true
   $evidence = @()

   try
   {
       scoredItem
   }
   catch
   {
       $result = $false
       $evidence += $_.Exception.Message
   }

   if ($sum -eq $v)
   {
       $evidence = "Correct total cost!`nWe've found a formula that calculates the total cost and the total cost of $sum matches our calculation of $v"
       $baseURL = 'https://keepthescore.co/api/@lab.Variable(APIKey)/add_single_score'
## Powershell setup the API Call.
$Body = @{
   "player_name" = '@lab.User.FirstName@lab.User.LastName'
   "score" = 10
}

$JsonBody = $Body | ConvertTo-Json

$apiCall = @{
       Method = "Post"
       Uri =  "$($baseURL)"
       ContentType = "application/json"
       Body = $JsonBody
   }
## This is the actual API Call to get the class as it is currently.
$apiResponse = Invoke-RestMethod @apiCall

if ($apiResponse.message -eq "Success" ) {
   $LeaderboardStatus = 'Leaderboard update success'
   }
   else {
   $LeaderboardStatus = 'Leaderboard update failed'
   }
   }

   $evidence
   $result
}

evaluate
