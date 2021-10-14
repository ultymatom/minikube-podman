﻿# Register the HNetCfg library (once)
regsvr32 hnetcfg.dll

#Identify the used adapter
$MainAdapter = Get-NetAdapter | Where-Object {$_.MediaConnectionState -eq 'Connected' -and $_.PhysicalMediaType -ne 'Unspecified'} | Sort-Object LinkSpeed -Descending

# Create a NetSharingManager object
$m = New-Object -ComObject HNetCfg.HNetShare

# List connections
$m.EnumEveryConnection |% { $m.NetConnectionProps.Invoke($_) }

# Find connection
$c = $m.EnumEveryConnection |? { $m.NetConnectionProps.Invoke($_).Name -eq $MainAdapter.Name }

# Get sharing configuration
$config = $m.INetSharingConfigurationForINetConnection.Invoke($c)

# See if sharing is enabled
Write-Output $config.SharingEnabled

# See the role of connection in sharing
# 0 - public, 1 - private
# Only meaningful if SharingEnabled is True
Write-Output $config.SharingConnectionType

# Enable sharing
$config.EnableSharing(0)

#Select the connection
