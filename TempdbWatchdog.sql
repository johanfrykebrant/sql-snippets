--Run this code to see file size changes in the tempDB
DECLARE @TraceFileLocation NVARCHAR(255) = N'<database location>\Temp\Database_Growth_Wathdog*.xel';

WITH FileSizeChangedEvent
AS (
	SELECT object_name AS Event
		,CONVERT(XML, event_data) AS Data
	FROM sys.fn_xe_file_target_read_file(@TraceFileLocation, NULL, NULL, NULL)
	)
SELECT FileSizeChangedEvent.Data.value('(/event/@timestamp)[1]', 'DATETIME') AS EventTime
	,FileSizeChangedEvent.Data.value('(/event/data/value)[7]', 'BIGINT') AS GrowthInKB
	,FileSizeChangedEvent.Data.value('(/event/action/value)[2]', 'VARCHAR(MAX)') AS ClientUsername
	,FileSizeChangedEvent.Data.value('(/event/action/value)[4]', 'VARCHAR(MAX)') AS ClientHostname
	,FileSizeChangedEvent.Data.value('(/event/action/value)[5]', 'VARCHAR(MAX)') AS ClientAppName
	,FileSizeChangedEvent.Data.value('(/event/action/value)[3]', 'VARCHAR(MAX)') AS ClientAppDBName
	,FileSizeChangedEvent.Data.value('(/event/action/value)[1]', 'VARCHAR(MAX)') AS SQLCommandText
	,FileSizeChangedEvent.Data.value('(/event/data/value)[1]', 'BIGINT') AS SystemDuration
	,FileSizeChangedEvent.Data.value('(/event/data/value)[2]', 'BIGINT') AS SystemDatabaseId
	,FileSizeChangedEvent.Data.value('(/event/data/value)[8]', 'VARCHAR(MAX)') AS SystemDatabaseFileName
	,FileSizeChangedEvent.Data.value('(/event/data/text)[1]', 'VARCHAR(MAX)') AS SystemDatabaseFileType
	,FileSizeChangedEvent.Data.value('(/event/data/value)[5]', 'VARCHAR(MAX)') AS SystemIsAutomaticGrowth
	,FileSizeChangedEvent.Data
FROM FileSizeChangedEvent
ORDER BY EventTime DESC;
