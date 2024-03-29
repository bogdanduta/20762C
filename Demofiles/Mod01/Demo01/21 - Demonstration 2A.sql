--10776A Module 2 Demonstration 2A: Working with Character Data

-- Step 1: Open a new query window to the tempdb database

USE tempdb;
GO

-- Step 2: Retrieve and discuss the collation of the system and tempdb

SELECT SERVERPROPERTY('Collation') as SystemCollation,
       DATABASEPROPERTYEX('tempdb','Collation') as DatabaseCollation;

-- Step 3: Create and populate a table without specifying collations

CREATE TABLE dbo.TestCharacter
(
  id int NOT NULL IDENTITY(1,1),
  NonUnicodeData varchar(10),
  UnicodeData nvarchar(10)
);
	
INSERT dbo.TestCharacter (NonUnicodeData,UnicodeData)
VALUES ('Hello',N'Hello'),
       ('你好',N'你好'),
       ('こんにちは',N'こんにちは');

-- Step 4: Check the data that was inserted 

SELECT * FROM dbo.TestCharacter;

-- Step 5: Create and populate a table with different column collations

CREATE TABLE dbo.TestCharacter2
(
  id int NOT NULL IDENTITY(1,1),
  CIData varchar(10) COLLATE Latin1_General_CI_AS,
  CSData varchar(10) COLLATE Latin1_General_CS_AS
);

INSERT INTO dbo.TestCharacter2 (CIData,CSData)
VALUES ('Test Data','Test Data');

-- Step 6: Execute queries that try to match the same
--         values from each column with all lower case

SELECT * FROM dbo.TestCharacter2
WHERE CIData = 'test data';

SELECT * FROM dbo.TestCharacter2
WHERE CSData = 'test data';

-- Step 7: Execute a query to perform a case-insensitive
--         search on the case-sensitive data

SELECT * FROM dbo.TestCharacter2
WHERE CSData = 'test data' COLLATE Latin1_General_CI_AS;

-- Step 8: Try to execute a query that compares the two columns
--         that have different collations. This will fail
--         as the collation conflict cannot be resolved.

SELECT * FROM dbo.TestCharacter2
WHERE CIData = CSData;

-- Step 9: Execute the query while specifying a collation

SELECT * FROM dbo.TestCharacter2
WHERE CIData = CSData COLLATE Latin1_General_CI_AS;