Connect-AzureAD
$roles = Get-AzureADDirectoryRole | Where-Object {$_.DisplayName -like "Privileged Role*"}
$results = @()
# Loop through each role and get its assignments
foreach ($role in $roles) {
    $pimassignments = Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId
    $roleResults = [PSCustomObject]@{
	RoleName = $role.DisplayName
	ActiveAssignments = @()
	NonActiveAssignments = @()
	}
    
    # Output the role name and assignments
    Write-Host "Role Name: $($role.DisplayName)"
    Write-Host "Active PIM Assignments:"
    # Add Active Assignments to the Object
    foreach ($pimassignment in $pimassignments) {
        if ($pimassignment.State -eq "Active") {
           	$roleResults.ActiveAssignments += $pimassignment.UserPrincipalName
		 Write-Host " - $($pimassignment.UserPrincipalName)"
        }
    }
    # Add Non-Active Assignments to the Object
    Write-Host "Non-Active PIM Assignments:"

    foreach ($pimassignment in $pimassignments) {
        if ($pimassignment.State -ne "Active") {
                $roleResults.NonActiveAssignments += $pimassignment.UserPrincipalName
                Write-Host " - $($pimassignment.UserPrincipalName)"  
	   }
	}
    # Add role results object to the array
     $results += $roleResults
  }
$results
  #Export the results to a csv file
  $results | Export-Csv -Path "pimRoleAssignments.csv" -NoTypeInformation