
Add-PSSnapIn BizTalkFactory.PowerShell.Extensions

Function Biztalk: { Set-Location Biztalk: }
Function Biztalk:\ { Set-Location Biztalk:\ }
Set-Alias Enlist-SendPort Stop-SendPort

Function Get-Command-BTS
{
	$scriptPath = (Get-Location).Path
	cd c:
	
Get-Command | where { $_.ModuleName -like "BizTalk*" }

	cd $scriptPath
}

function Start-Applications
{
	# Get list of all the applications except System and Default.
	$Applications = @(Get-ChildItem -Path BizTalk:\Applications | 
						Where-Object {$_.IsDefaultApplication -eq $false -and $_.IsSystem -eq $false})

	Set-Location -Path BizTalk:\Applications

	Write-Host "Start Starting applications....." 

	while ($Applications -ne $null -and $Applications.length -ne 0)
	{
		# Errorhandling here
		trap [BizTalkFactory.Management.Automation.BtsException]
		{
			# Set parent variable to indicate an error has occured.
			Write-Host "Failed to start application"
			Set-Variable -Name ErrorOccured -Value  $true -Scope 1
			continue;
		}
	   
		$ErrorOccured = $false
		
		# Start the first item from the array.
		Write-Host "Trying to start application: "  $Applications[0].Name
		Start-Application -Path  $Applications[0].Name
		
		# Check if an error has occured.    
		if ($ErrorOccured)
		{
			# An error has occured. Put failed BtsApplication at the end of the array.
			$Applications = $Applications[1..($Applications.length - 1) + 0]
		}
		else
		{
			# Start-Application was ok. Remove BtsApplication now also from the array or
			# if this was the last item set the array to null.
			if ($Applications.length -eq 1)
			{
				# Set the array to null.
				$Applications = $null
			}
			else
			{
				# Remove the item from the array.
				$Applications = $Applications[1..($Applications.length - 1)]
			}
		}
	}

	Write-Host "Finished starting applications." 
}


function Stop-Applications
{
	# Get list of all the applications except System and Default.
	$Applications = @(Get-ChildItem -Path BizTalk:\Applications | 
						Where-Object {$_.IsDefaultApplication -eq $false -and $_.IsSystem -eq $false})

	Set-Location -Path BizTalk:\Applications

	Write-Host "Start stopping applications....." 

	while ($Applications -ne $null -and $Applications.length -ne 0)
	{
		# Errorhandling here
		trap [BizTalkFactory.Management.Automation.BtsException]
		{
			# Set parent variable to indicate an error has occured.
			Write-Host "Failed to stop application"
			Set-Variable -Name ErrorOccured -Value  $true -Scope 1
			continue;
		}
	   
		$ErrorOccured = $false
		
		# Stop the first item from the array.
		Write-Host "Trying to stop application: "  $Applications[0].Name
		Stop-Application -Path  $Applications[0].Name
		
		# Check if an error has occured.    
		if ($ErrorOccured)
		{
			# An error has occured. Put failed BtsApplication at the end of the array.
			$Applications = $Applications[1..($Applications.length - 1) + 0]
		}
		else
		{
			# Stop-Application was ok. Remove BtsApplication now also from the array or
			# if this was the last item set the array to null.
			if ($Applications.length -eq 1)
			{
				# Set the array to null.
				$Applications = $null
			}
			else
			{
				# Remove the item from the array.
				$Applications = $Applications[1..($Applications.length - 1)]
			}
		}
	}

	Write-Host "Finished stopping applications." 
}

function Remove-Applications
{
	# Get list of all the applications except System and Default.
	$Applications = @(Get-ChildItem -Path BizTalk:\Applications | 
						Where-Object {$_.IsDefaultApplication -eq $false -and $_.IsSystem -eq $false})

	Set-Location -Path BizTalk:\Applications

	Write-Host "Start removing applications....." 

	while ($Applications -ne $null -and $Applications.length -ne 0)
	{
		# Errorhandling here
		trap [BizTalkFactory.Management.Automation.BtsException]
		{
			# Set parent variable to indicate an error has occured.
			Write-Host "Failed to delete application"
			Set-Variable -Name ErrorOccured -Value  $true -Scope 1
			continue;
		}
	   
		$ErrorOccured = $false
		
		# Remove the first item from the array.
		Write-Host "Trying to remove application: "  $Applications[0].Name
		Remove-Item -Path  $Applications[0].Name -recurse
		
		# Check if an error has occured.    
		if ($ErrorOccured)
		{
			# An error has occured. Put failed BtsApplication at the end of the array.
			$Applications = $Applications[1..($Applications.length - 1) + 0]
		}
		else
		{
			# Remove-Item was ok. Remove BtsApplication now also from the array or
			# if this was the last item set the array to null.
			if ($Applications.length -eq 1)
			{
				# Set the array to null.
				$Applications = $null
			}
			else
			{
				# Remove the item from the array.
				$Applications = $Applications[1..($Applications.length - 1)]
			}
		}
	}

	Write-Host "Finished removing applications." 
}

function Stop-HostInstances
{
	$scriptPath = (Get-Location).Path
	cd 'BizTalk:\Platform Settings\Host Instances'
	$objHostInstances = Get-ChildItem *
	foreach ($objHostInstance in $objHostInstances)
	{
		$i++
		Write-Progress -Activity "Stopping host instance" -status $objHostInstance.HostName -PercentComplete (($i / $objHostInstances.length) * 100)
		Stop-HostInstance $objHostInstance
	}
	cd $scriptPath
}

function Start-HostInstances
{
	$scriptPath = (Get-Location).Path
	cd 'BizTalk:\Platform Settings\Host Instances'
	$objHostInstances = Get-ChildItem *
	foreach ($objHostInstance in $objHostInstances)
	{
		$i++
		Write-Progress -Activity "Starting host instance" -status $objHostInstance.HostName -PercentComplete (($i / $objHostInstances.length) * 100)
		Start-HostInstance $objHostInstance
	}
	cd $scriptPath
}

function Restart-HostInstances
{
	$scriptPath = (Get-Location).Path
	cd 'BizTalk:\Platform Settings\Host Instances'
	$objHostInstances = Get-ChildItem *
	foreach ($objHostInstance in $objHostInstances)
	{
		$i++
		Write-Progress -Activity "Stopping host instance" -status $objHostInstance.HostName -PercentComplete (($i / ($objHostInstances.length*2)) * 100)
		Stop-HostInstance $objHostInstance
		$i++
		Write-Progress -Activity "Starting host instance" -status $objHostInstance.HostName -PercentComplete (($i / ($objHostInstances.length*2)) * 100)
		Start-HostInstance $objHostInstance
	}
	cd $scriptPath
}

cd BizTalk:
ls

" "
" "
"Use 'Get-Command-BTS' to see all commands for BizTalk"
"Use 'Start-Applications' to start all BizTalk applications"
"Use 'Stop-Applications' to stop all BizTalk applications"
"Use 'Remove-Applications' to remove all BizTalk applications"
"Use 'Stop-HostInstances' to stop all Host Instances"
"Use 'Start-HostInstances' to start all Host Instances"
"Use 'Restart-HostInstances' to restart all Host Instances"
