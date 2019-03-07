#Requires -Module SqlServer
#Requires -Module ActiveDirectory
class AeriesDatabase {
	[string]$Server
	[string]$Database
    [pscredential]$Credential
    [int]$QueryTimeout = 65535
    [int]$ConnectionTimeout = 65534
    [SqlOutputType]$OutputAs = 'DataRows'
    AeriesDatabase([string]$Server,[string]$Database,[pscredential]$Credential){
        $this.Server = $Server
        $this.Database = $Database
        $this.Credential = $Credential
    }
    AeriesDatabase([string]$Server,[string]$Database,[string]$Username,[string]$Password){
        $this.Server = $Server
        $this.Database = $Database
        $SecureString = ConvertTo-SecureString $this.Password -AsPlainText -Force
        $this.Credential = [System.Management.Automation.PSCredential]::new($this.Username, $SecureString)
    }
    AeriesDatabase([string]$Server,[string]$Database,[string]$Username,[SecureString]$Password){
        $this.Server = $Server
        $this.Database = $Database
        $this.Credential = [System.Management.Automation.PSCredential]::new($this.Username, $Password)
    }
	[object] Query ([string]$SQL) {
		$Params = @{
			Query             = $SQL
            ErrorAction       = 'stop'
            DisableVariables  = $true
        }
        $DB = $this.ToQuerySplat()
		try {
            $results = Invoke-Sqlcmd @DB @Params
            return $results
		}
		catch {
			throw $psitem
		}
    }
    [hashtable] ToQuerySplat(){
        $splat = @{
            ServerInstance    = $this.Server
			Database          = $this.Database
			ConnectionTimeout = $this.ConnectionTimeout
            QueryTimeout      = $this.QueryTimeout
            OutputAs          = $this.OutputAs
        }
        if ($this.Credential) {
			$splat.Credential = $this.Credential
		}
        return $splat
    }
    CreateUGN(){

    }

    CreateUser(){}
    CreateTeacher(){}
}
enum SqlOutputType {
    DataSet
    DataTables 
    DataRows
}
enum UgnUserTypes {
    User
    Admin 
    Teacher
    SubstituteTeacher
    ActiveDirectoryUser
    ActiveDirectoryAdmin
    ActiveDirectoryTeacher
}
enum UgnTypes {
    Group #= ?
    User = 1
}
enum UgnIdentityProvider {
    Aeries
    Google
}

enum UgnStatus {
    Active
    Locked
    Disabled
    Pending
}

class UGN {
    [int]$ID
    [int]$StaffID
    [int]$StudentID
    [string]$Username
    [int]$IdentityProvider
    [string]$System
    [int]$RowType
    [string]$UserType
    [int]$Status
    [int]$LoginCount
    [string]$EmailAddress
    [string]$Firstname
    [string]$Lastname
    [string]$Comment
    [string]$Password
    [int]$HashType
    [string]$PasswordSalt
    [nullable[datetime]]$PasswordSet
    [bool]$PromtPasswordSet
    [nullable[datetime]]$LastLogin
    [nullable[datetime]]$CurrentLogin
    [nullable[datetime]]$LastPageRequest
    [string]$LastIPAddress
    [string]$IPAddress
    [nullable[datetime]]$Expiration
    [nullable[datetime]]$Created
    [nullable[datetime]]$Modified
    [bool]$Deleted

    hidden [AeriesDatabase]$DB
    UGN([System.Data.DataRow]$Source,[AeriesDatabase]$DB){
        $this.DB = $DB
        foreach($Prop in $this.Properties()){
            $col = $this.PropertyToColumn($Prop)
            $this."$Prop" = $this."$col"
        }
    }
    hidden [string] ColumnToProperty([string[]]$Property){
        $Column = ''
        switch ($Property){
            'UID'               {$Column = 'ID'}
            'UN'         {$Column = 'Username' }
            'SY'           {$Column = 'System' }
            'TY'          {$Column = 'RowType' }
            'UTY'         {$Column = 'UserType'}
            'HT'         {$Column = 'HashType' }
            'PW'         {$Column = 'Password' }
            'CD'          {$Column = 'Created' }
            'XD'       {$Column = 'Expiration' }
            'ST'           {$Column = 'Status' }
            'LDT'        {$Column = 'LastLogin'}
            'LC'       {$Column = 'LoginCount' }
            'IP'        {$Column = 'IPAddress' }
            'EM'     {$Column = 'EmailAddress' }
            'FN'        {$Column = 'Firstname' }
            'LN'         {$Column = 'Lastname' }
            'CM'          {$Column = 'Comment' }
            'LIP'    {$Column = 'LastIPAddress'}
            'CDT'     {$Column = 'CurrentLogin'}
            'LPR'  {$Column = 'LastPageRequest'}
            'ID'        {$Column = 'StudentID' }
            'SID'          {$Column = 'StaffID'}
            'PLC'      {$Column = 'PasswordSet'}
            'SLT'     {$Column = 'PasswordSalt'}
            'IDP' {$Column = 'IdentityProvider'}
            'CPW' {$Column = 'PromtPasswordSet'}
            'DEL'          {$Column = 'Deleted'}
            'DTS'         {$Column = 'Modified'}
        }
        return $Column
    }
    hidden [string] PropertyToColumn([string[]]$Property){
        $Column = ''
        switch ($Property){
            'ID'               {$Column = 'UID'}
            'Username'         {$Column = 'UN' }
            'System'           {$Column = 'SY' }
            'RowType'          {$Column = 'TY' }
            'UserType'         {$Column = 'UTY'}
            'HashType'         {$Column = 'HT' }
            'Password'         {$Column = 'PW' }
            'Created'          {$Column = 'CD' }
            'Expiration'       {$Column = 'XD' }
            'Status'           {$Column = 'ST' }
            'LastLogin'        {$Column = 'LDT'}
            'LoginCount'       {$Column = 'LC' }
            'IPAddress'        {$Column = 'IP' }
            'EmailAddress'     {$Column = 'EM' }
            'Firstname'        {$Column = 'FN' }
            'Lastname'         {$Column = 'LN' }
            'Comment'          {$Column = 'CM' }
            'LastIPAddress'    {$Column = 'LIP'}
            'CurrentLogin'     {$Column = 'CDT'}
            'LastPageRequest'  {$Column = 'LPR'}
            'StudentID'        {$Column = 'ID' }
            'StaffID'          {$Column = 'SID'}
            'PasswordSet'      {$Column = 'PLC'}
            'PasswordSalt'     {$Column = 'SLT'}
            'IdentityProvider' {$Column = 'IDP'}
            'PromtPasswordSet' {$Column = 'CPW'}
            'Deleted'          {$Column = 'DEL'}
            'Modified'         {$Column = 'DTS'}
        }
        return $Column
    }
    hidden UpdateRow([string]$Column,$Value){
        $SQL = "UPDATE [dbo].[UGN] SET [$Column] = '$Value' WHERE [UID] = '$($this.ID);"
        $this.DB.Query($SQL)
    }
    hidden UpdateProperty ([string]$Property,$Value){
        $col = $this.PropertyToColumn($Property)
        $this.UpdateRow($col,$Value)
        $this."$Property" = $Value
    }
    [string[]]Properties(){
        $filter = {
            $psitem.MemberType -like '*Prop*' -and 
            $psitem.Definition -like '*set;*'
        }
        $members = $this | Get-Member  | Where-Object $filter
        return $members.Name
    }
    [hashtable] ToHashtable(){
        [hashtable]$table = @{}
        foreach ( $Prop in $this.Properties() ) {
            $col = $this.PropertyToColumn($Prop)
            $table.Add($col,$this."$Prop")
        }
        return $table
    }

    # updates entire table
    Sync(){
        [System.Collections.ArrayList]$SQL = @()
        $SQL.Add("UPDATE [dbo].[UGN]`n")
        $i = 0
        $Properties = $this.Properties() 
        foreach ( $Prop in $Properties) {
            $Value = $this."$Prop"
            $Column = $this.PropertyToColumn($prop)
            $SQL.Add("SET [$Column] = '$Value'")
            if($i -lt $Properties.Count){
                $SQL.Add(",`n")
            }
        }
        $SQL.Add("`nWHERE [UID] = '$($this.ID);")
        $this.DB.Query($SQL.ToString())#----------------test
    }

    SetID([int]$Value){$this.UpdateProperty('ID',$Value)}
    SetUsername([string]$Value){$this.UpdateProperty('Username',$Value)}
    SetSystem([string]$Value){$this.UpdateProperty('System',$Value)}
    SetRowType([int]$Value){$this.UpdateProperty('RowType',$Value)}
    SetUserType([string]$Value){$this.UpdateProperty('UserType',$Value)}
    SetHashType([int]$Value){$this.UpdateProperty('HashType',$Value)}
    SetPassword([string]$Value){$this.UpdateProperty('Password',$Value)}
    SetCreated([nullable[datetime]]$Value){$this.UpdateProperty('Created',$Value)}
    SetExpiration([nullable[datetime]]$Value){$this.UpdateProperty('Expiration',$Value)}
    SetStatus([int]$Value){$this.UpdateProperty('Status',$Value)}
    SetLastLogin([nullable[datetime]]$Value){$this.UpdateProperty('LastLogin',$Value)}
    SetLoginCount([int]$Value){$this.UpdateProperty('LoginCount',$Value)}
    SetIPAddress([string]$Value){$this.UpdateProperty('IPAddress',$Value)}
    SetEmailAddress([string]$Value){$this.UpdateProperty('EmailAddress',$Value)}
    SetFirstname([string]$Value){$this.UpdateProperty('Firstname',$Value)}
    SetLastname([string]$Value){$this.UpdateProperty('Lastname',$Value)}
    SetComment([string]$Value){$this.UpdateProperty('Comment',$Value)}
    SetLastIPAddress([string]$Value){$this.UpdateProperty('LastIPAddress',$Value)}
    SetCurrentLogin([nullable[datetime]]$Value){$this.UpdateProperty('CurrentLogin',$Value)}
    SetLastPageRequest([nullable[datetime]]$Value){$this.UpdateProperty('LastPageRequest',$Value)}
    SetStudentID([int]$Value){$this.UpdateProperty('StudentID',$Value)}
    SetStaffID([int]$Value){$this.UpdateProperty('StaffID',$Value)}
    SetPasswordSet([nullable[datetime]]$Value){$this.UpdateProperty('PasswordSet',$Value)}
    SetPasswordSalt([string]$Value){$this.UpdateProperty('PasswordSalt',$Value)}
    SetIdentityProvider([int]$Value){$this.UpdateProperty('IdentityProvider',$Value)}
    SetPromtPasswordSet([bool]$Value){$this.UpdateProperty('PromtPasswordSet',$Value)}
    SetDeleted([bool]$Value){$this.UpdateProperty('Deleted',$Value)}
    SetModified([nullable[datetime]]$Value){$this.UpdateProperty('Modified',$Value)}
}

