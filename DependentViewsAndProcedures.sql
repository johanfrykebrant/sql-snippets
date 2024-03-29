DECLARE @SearchString AS VARCHAR(100)='<Enter Searchstring here>'

SELECT 
referencing_object_name = o.name
,referencing_object_type_desc = o.type_desc
,referenced_object_name = referenced_entity_name
FROM sys.sql_expression_dependencies sed 
	INNER JOIN sys.views o ON sed.referencing_id = o.object_id 
WHERE referenced_entity_name LIKE @SearchString

UNION ALL

SELECT
referencing_object_name = o.name
,referencing_object_type_desc = o.type_desc
,referenced_object_name = referenced_entity_name
FROM sys.sql_expression_dependencies sed 
	INNER JOIN sys.procedures o ON sed.referencing_id = o.object_id 
WHERE referenced_entity_name LIKE @SearchString
