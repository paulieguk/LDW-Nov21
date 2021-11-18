# Find values from Excel spreadsheet
$file = "C:\Data\SampleSalesData.xlsx"
$excel = New-Object -ComObject Excel.Application
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.Sheets.Item(1)
$sum = $worksheet.Range('F46').Text
$formula = $worksheet.Range('F46').Formula

# Get sum from worksheet cells and close workbook
$v=0
$range = $worksheet.Range("F4:F45")
$range = $range.Formula
$range | foreach {$v +=$_}
$workbook.Close()
$excel.Quit()

# Evaluate
function scoredItem
{
   if ($formula -notlike '=*')
   {
       $evidence += "No formula found.`nPlease make sure you saved your work.`nThe formula must be located in cell F46`n"
   }
   elseif ($sum -ne $v)
   {
       [Int]$sum1 = $sum
       $sum2 = $sum1.ToString('N0')
       $v1 = $v.ToString('N0')
       $evidence += "The formula found is incorrect. The formula returned a total of $sum2 units but we're expecting $v1 units`n"
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
       [Int]$sum1 = $sum
       $sum2 = $sum1.ToString('N0')
       $v1 = '{0:N0}' -f $v
       $evidence = "Correct sum!`nWe've found a formula that calculates the total amount of units and the sum of $sum2 units matches our calculation of $v1 units"
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
