class DatabaseConnection {
	[string]$Server
	[string]$Database
	[pscredential]$Credential
	test() {
		$Params = @{
			ServerInstance    = $this.Server
			Credential        = $this.Credential
			Name              = $this.Database
			ConnectionTimeout = 0
			ErrorAction       = 'stop'
		}
		try {
			Get-SqlDatabase @Params | Out-Null
		}
		catch {
			throw "Could Not Connect to Server:'$($this.Server)' Database:'$($this.Database)'"
		}
	}
	[object] Query ([string]$SQL) {
		$Params = @{
			ServerInstance    = $this.Server
			Database          = $this.Database
			ConnectionTimeout = 0
			QueryTimeout      = 0
			Query             = $SQL
			ErrorAction       = 'stop'
		}
		if ($this.Credential) {
			$Params.Credential = $this.Credential
		}
		try {
			$results = Invoke-Sqlcmd @Params
		}
		catch {
			throw $psitem
		}
		if ($results) {
			return $results
		}
		return $null
	}
}
function New-DatabaseConnection {
	param(
		[string]$Server,
		[string]$Database,
		[pscredential]$Credential,
		[switch]$Force
	)
	$db = [DatabaseConnection]::new()
	$db.Server = $Server
	$db.Database = $Database
	$db.Credential = $Credential
	if (!$Force) {
		# throws error is fails
		$db.test()
	}
	return $db
}