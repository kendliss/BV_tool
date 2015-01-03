﻿CREATE PROCEDURE sp_ReplaceStringInTable @stringToFind VARCHAR(100), @stringToReplace varchar(100), @schema sysname, @table sysname
AS 

DECLARE @sqlCommand VARCHAR(8000) 
DECLARE @where VARCHAR(8000) 
DECLARE @columnName sysname 
DECLARE @cursor VARCHAR(8000) 
DECLARE @count INT 

BEGIN TRY 
   SET @sqlCommand = 'SELECT * FROM ' + @schema + '.' + @table + ' WHERE' 
   SET @where = '' 

   SET @cursor = 'DECLARE col_cursor CURSOR FOR SELECT COLUMN_NAME 
   FROM ' + DB_NAME() + '.INFORMATION_SCHEMA.COLUMNS 
   WHERE TABLE_SCHEMA = ''' + @schema + ''' 
   AND TABLE_NAME = ''' + @table + ''' 
   AND DATA_TYPE IN (''char'',''nchar'',''ntext'',''nvarchar'',''text'',''varchar'')' 

   EXEC (@cursor) 

   OPEN col_cursor    
   FETCH NEXT FROM col_cursor INTO @columnName    

   WHILE @@FETCH_STATUS = 0    
   BEGIN 
        SET @sqlCommand = 'UPDATE ' + @schema + '.' + @table + ' SET [' + @columnName + '] = REPLACE([' + @columnName + '],''' + @stringToFind + ''',''' + @stringToReplace + ''')' 
         
        SET @where = ' WHERE [' + @columnName + '] LIKE ''%' + @stringToFind + '%''' 
         
        EXEC( @sqlCommand + @where) 
         
        SET @count = @@ROWCOUNT 
         
        IF @count > 0 
          BEGIN 
            PRINT @sqlCommand + @where 
            PRINT 'Updated: ' + CONVERT(VARCHAR(10),@count) 
            PRINT '----------------------------------------------------' 
          END 
         
        FETCH NEXT FROM COL_CURSOR 
        INTO @columnName 
      END     

   CLOSE col_cursor    
   DEALLOCATE col_cursor  

   SET @sqlCommand = @sqlCommand + @where 
   --PRINT @sqlCommand 
   EXEC (@sqlCommand)  
END TRY 
BEGIN CATCH 
   PRINT 'There was an error' 
   IF CURSOR_STATUS('variable', 'col_cursor') <> -3 
   BEGIN 
       CLOSE col_cursor    
       DEALLOCATE col_cursor  
   END 
END CATCH
