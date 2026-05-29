-- Docker-only: create the 'test' login and user that Spiracle.properties expects.
-- setupdb_mssql.sql does not create this login; run this first.
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'test')
BEGIN
    CREATE LOGIN [test] WITH PASSWORD = 'Mssql1234', CHECK_POLICY = OFF;
END
GO

USE spiracle;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'test')
BEGIN
    CREATE USER [test] FOR LOGIN [test];
    ALTER ROLE db_owner ADD MEMBER [test];
END
GO
