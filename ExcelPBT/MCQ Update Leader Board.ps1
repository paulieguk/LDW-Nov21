$result = $false
$Score = 0
$q1 = '@lab.Variable(Q1)'
$q2 = '@lab.Variable(Q2)'

if ($q1 -eq 'Correct') {    
   $result = $true
   $Score = $Score + 10
   }
if ($q2 -eq 'Correct') {    
   $result = $true
   $Score = $Score + 10
   }

if ($Score -gt 0){
   ##Leaderboard Script here
$baseURL = 'https://keepthescore.co/api/@lab.Variable(APIKey)/add_single_score'
## Powershell setup the API Call.
$Body = @{
   "player_name" = '@lab.User.FirstName@lab.User.LastName'
   "score" = $Score
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

$Result
