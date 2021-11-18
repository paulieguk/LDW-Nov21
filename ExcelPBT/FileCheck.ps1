$result = $false
$File = 'C:\Data\SampleSalesData.xlsx'

if (Test-Path -Path $File) {
     $result = $true
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
else {
    $result = $false
}

$result
