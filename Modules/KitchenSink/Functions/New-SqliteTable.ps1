<#
.SYNOPSIS
Creates a new table in a SQLite database with optional primary key, foreign key, and auto-increment constraints.

.DESCRIPTION
The New-SqliteTable function creates a new table in a SQLite database. 
The table is defined by the provided column names and their types.
Each column can optionally be specified as a primary key, a foreign key, or an auto-increment column.

.PARAMETER DataSource
The path to the SQLite database file.

.PARAMETER TableName
The name of the table to create.

.PARAMETER Columns
An ordered dictionary of column names and their properties. The keys of the dictionary are the column names and the values are hashtables that include the column type and optionally the primary key, foreign key, and auto-increment constraints. 
Column names cannot contain spaces or special characters, and the column types must be one of the following SQLite data types:
NULL, INTEGER, REAL, TEXT, BLOB.

.EXAMPLE
$DataSource = "D:\Code\database000.db"
$TableName = "my_table"
$columns = [ordered]@{
    "TestColumn1" = @{ Type = "INTEGER"; PrimaryKey = $true; AutoIncrement = $true }
    "TestColumn2" = @{ Type = "TEXT"; ForeignKey = "TestColumn1" }
}
New-SqliteTable -DataSource $DataSource -TableName $TableName -Columns $columns

This example creates a new table named 'my_table' in the SQLite database at 'D:\Code\Repos\PowerShell\Dev\BleakWow\V1.1\database000.db'. 
The table has two columns: 'TestColumn1' and 'TestColumn2'. 'TestColumn1' is an INTEGER column that is a primary key and has the auto-increment constraint. 'TestColumn2' is a TEXT column that is a foreign key referencing 'TestColumn1'.

-- When building the $columns hashtable, the [ordered] type accelerator is used to ensure that the columns are created in the order they are defined.
-- When building the $columns hashtable, it is not required to specify the PrimaryKey, ForeignKey, or AutoIncrement properties.
    $columns = [ordered]@{
        "Column3" = @{ Type = "INTEGER"; PrimaryKey = $true; AutoIncrement = $true }
        "Column4" = @{ Type = "TEXT"; }
        "Column5" = @{ Type = "TEXT"; }
    }
    
.NOTES
Version: 1.1
Author: http://github.com/EReis0
Date: 02/22/2024
#>
function New-SqliteTable {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({
            $directory = Split-Path -Parent $_
            if (-not (Test-Path -Path $directory)) {
                throw "The directory '$directory' does not exist."
            }
            return $true
        })]
        [string] $DataSource,
        [Parameter(Mandatory=$true)]
        [string] $TableName,
        [Parameter(Mandatory=$true)]
        [ValidateScript({
            $validTypes = @('NULL', 'INTEGER', 'REAL', 'TEXT', 'BLOB')
            foreach ($column in $_.GetEnumerator()) {
                if ($column.Key -match '\s' -or $column.Key -match '[^a-zA-Z0-9_]') {
                    throw "Column names cannot contain spaces or special characters."
                }
                if ($validTypes -notcontains $column.Value.Type) {
                    throw "Invalid column type. Valid types are: $($validTypes -join ', ')"
                }
            }
            return $true
        })]
        [hashtable] $Columns
    )

    # Load the module
    Import-Module -Name PSSQLite

    # Connect to the database
    $connection = New-SqliteConnection -DataSource $DataSource

    # Generate the SQL query for creating the table
    $query = "CREATE TABLE $TableName ("
    foreach ($column in $Columns.GetEnumerator()) {
        $query += "`n    $($column.Key) $($column.Value.Type)"
        if ($column.Value.PrimaryKey) {
            $query += " PRIMARY KEY"
        }
        if ($column.Value.AutoIncrement) {
            $query += " AUTOINCREMENT"
        }
        if ($column.Value.ForeignKey) {
            $query += " REFERENCES $($column.Value.ForeignKey)"
        }
        $query += ","
    }
    $query = $query.TrimEnd(",") + "`n);"

    Invoke-SqliteQuery -Connection $connection -Query $query

    # Close the connection
    $connection.Close()
}
