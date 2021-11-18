# Find values from Excel spreadsheet
$file = "C:\Data\SampleSalesData.xlsx"
$excel = New-Object -ComObject Excel.Application
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.Sheets.Item(1)
$average = $worksheet.Range('G46').Text
$average = $average.Replace(' ','')
$formula = $worksheet.Range('G46').Formula

# Get sum from worksheet cells and close workbook
$avg=0
$range = $worksheet.Range("G4:G45")
$range = $range.Formula
$range | foreach {$avg +=$_}
$workbook.Close()
$excel.Quit()
$avg = $avg/$range.count
$avg = '$' + [math]::Round($avg,2)

# Evaluate
function scoredItem
{
   if ($formula -notlike '=*')
   {
       $evidence += "No formula found`n"
   }
   elseif ($average -ne $avg)
   {
       $evidence += "The formula found is incorrect.`nThe formula returned an average value of $average but we're expecting an avaerage of $avg`n"
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

   if ($average -eq $avg)
   {
       $evidence = "Correct!`nWe've found a formula that averages unit costs and the average value $average equals our calculation of $avg"
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
