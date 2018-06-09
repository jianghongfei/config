----------------------------------- New Site -----------------------------------
DECLARE @SiteID uniqueidentifier = '11111111-1111-1111-1111-111111111111';
DECLARE @SiteName nvarchar(50) = N'Dummy Site';
DECLARE @BinaryBase nvarchar(256) = N'd:\site'

INSERT INTO [Site] ([SiteID], [Name]) VALUES (@SiteID, @SiteName)
INSERT [Option] ([OptionID], [Value]) VALUES (N'OPTION_SITE_ID', @SiteID)
INSERT [Option] ([OptionID], [Value]) VALUES (N'OPTION_BINARY_BASE', @BinaryBase)
INSERT [Option] ([OptionID], [Value]) VALUES (N'OPTION_IS_SITE', N'True')
INSERT [DataSource] ([DataSourceID], [CollectionInterval], [DriverID], [IsActived], [Name], [SiteID], [RecordingCount], [Metadata]) VALUES ('22222222-2222-2222-2222-222222222222', NULL, N'98831f7b-1b87-4661-90ea-8fe37e4ce25f', 1, N'm9000', @SiteID, 0, N'{"Port":5000}')
INSERT [DataSource] ([DataSourceID], [CollectionInterval], [DriverID], [IsActived], [Name], [SiteID], [RecordingCount], [Metadata]) VALUES ('33333333-3333-3333-3333-333333333333', NULL, N'82e6c4a0-a6fd-486a-b547-2c1532281dc7', 1, N'TCM', @SiteID, 0, N'{"Port":5000}')

INSERT [ReplicationTarget] ([ReplicationTargetID], [Approvedness], [Desc], [FromTime], [IP], [IsInitiative], [LastSuccessReplicationTime], [Name], [Port], [SiteID], [UploadInterval], [RecordingCount], [IsDisabled], [Metadata])
VALUES (N'44444444-4444-4444-4444-444444444444', 0, NULL, CAST(N'2016-04-12 00:00:00.0000000' AS DateTime2), N'192.168.100.2', 0, NULL, N'ToHQ1', 4096, @SiteID, 10, 0, 0, NULL)

INSERT [ReplicationTarget] ([ReplicationTargetID], [Approvedness], [Desc], [FromTime], [IP], [IsInitiative], [LastSuccessReplicationTime], [Name], [Port], [SiteID], [UploadInterval], [RecordingCount], [IsDisabled], [Metadata])
VALUES (N'55555555-5555-5555-5555-555555555555', 0, NULL, CAST(N'2016-04-12 00:00:00.0000000' AS DateTime2), N'192.168.100.3', 0, NULL, N'ToHQ2', 4096, @SiteID, 10, 0, 0, NULL)

------------------------------------ New HQ ------------------------------------
DECLARE @BinaryBase nvarchar(256) = N'd:\hq'
DECLARE @Port int = 4096

INSERT [Option] ([OptionID], [Value]) VALUES (N'OPTION_BINARY_BASE', @BinaryBase)
INSERT [Option] ([OptionID], [Value]) VALUES (N'OPTION_IS_SITE', N'False')
INSERT [Option] ([OptionID], [Value]) VALUES (N'OPTION_RECEIVER_WEB_PORT', @Port)

INSERT [ReplicationTarget] ([ReplicationTargetID], [Approvedness], [Desc], [FromTime], [IP], [IsInitiative], [LastSuccessReplicationTime], [Name], [Port], [SiteID], [UploadInterval], [IsDisabled], [RecordingCount], [Metadata]) 
VALUES (N'11111111-1111-1111-1111-111111111111', 1, NULL, NULL, NULL, 0, NULL, N'Dummy Site', 0, N'66666666-6666-6666-6666-666666666666', 0, 0, 0, NULL)

------------------------- Change SiteID --------------------------
DECLARE @SiteID uniqueidentifier = '66666666-6666-6666-6666-666666666666'

ALTER TABLE [Site] NOCHECK CONSTRAINT ALL
ALTER TABLE [UserSite] NOCHECK CONSTRAINT ALL
ALTER TABLE [Alarm] NOCHECK CONSTRAINT ALL
ALTER TABLE [AlarmDefinition] NOCHECK CONSTRAINT ALL
ALTER TABLE [Folder] NOCHECK CONSTRAINT ALL
ALTER TABLE [Machine] NOCHECK CONSTRAINT ALL
ALTER TABLE [Report] NOCHECK CONSTRAINT ALL
ALTER TABLE [DataSource] NOCHECK CONSTRAINT ALL
ALTER TABLE [ReplicationTarget] NOCHECK CONSTRAINT ALL
UPDATE [Site] SET [SiteID] = @SiteID
UPDATE [UserSite] SET [SiteID] = @SiteID
UPDATE [Alarm] SET [SiteID] = @SiteID
UPDATE [AlarmDefinition] SET [SiteID] = @SiteID
UPDATE [Folder] SET [SiteID] = @SiteID
UPDATE [Machine] SET [SiteID] = @SiteID
UPDATE [Report] SET [SiteID] = @SiteID
UPDATE [DataSource] SET [SiteID] = @SiteID
UPDATE [ReplicationTarget] SET [SiteID] = @SiteID
ALTER TABLE [Site] WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE [UserSite] WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE [Alarm] WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE [AlarmDefinition] WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE [Folder] WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE [Machine] WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE [Report] WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE [DataSource] WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE [ReplicationTarget] WITH CHECK CHECK CONSTRAINT ALL

UPDATE [Option] SET [Value] = '66666666-6666-6666-6666-666666666666' WHERE [OptionID] = 'OPTION_SITE_ID';
PRINT 'Change folders at binary base manully'

------------------------- Backup and restore database --------------------------
-- Backup and restore database
BACKUP DATABASE [MDataPort] TO DISK='d:\mdataport\mdataport.bak'

USE MASTER
ALTER DATABASE [MDataPort] SET SINGLE_USER WITH ROLLBACK IMMEDIATE 
--do you stuff here
RESTORE DATABASE [MDataPort] FROM DISK='d:\mdataport\mdataport.bak'
ALTER DATABASE [MDataPort] SET MULTI_USER
USE [MDataPort]

-- With different names
-- Get file names
RESTORE FILELISTONLY FROM DISK='d:\MDataPort.bak'

-- Then
USE MASTER
ALTER DATABASE [MDataPort] SET SINGLE_USER WITH ROLLBACK IMMEDIATE 
RESTORE DATABASE [MDataPort] FROM DISK='d:\mdataport\mdataport.bak'
WITH REPLACE,
   MOVE 'MDataPort' TO 'd:\MDataPort\MDataPort.mdf',
   MOVE 'MDataPort_log' TO 'd:\MDataPort\MDataPort_log.ldf'

ALTER DATABASE [MDataPort] SET MULTI_USER
USE [MDataPort]

----------------------------- Disable packaging --------------------------------
INSERT INTO [Option] ([OptionID], [Value]) VALUES ('OPTION_DISABLE_PACKAGING', 'True')

----------------------------- Recording per second -----------------------------
DECLARE @Start datetime2(7) = '2016-03-25 16:16:30.000';
SELECT CONVERT(decimal(10,2), count(*)) / DATEDIFF(SECOND, @Start, GETDATE()) from [Recording]
SELECT count(*) , DATEDIFF(SECOND, @Start, GETDATE()) from [Recording]

select count(*), cast([timestamp] as date) as a from [recording] group by cast([timestamp] as date) order by a

---------------------------- re-calculate severity -----------------------------
MERGE [Measurement] AS tgt
USING (
    SELECT [MeasurementId],
           [Severity]
    FROM (
        SELECT [MeasurementId],
               CASE [Alarmstatus]
                WHEN 0 THEN 8 -- Alarmstatus.None -> Severity.Green
                WHEN 1 THEN 8 -- Alarmstatus.OK -> Severity.Green
                WHEN 2 THEN 6 -- Alarmstatus.Warning -> Severity.Yellow
                WHEN 3 THEN 9 -- Alarmstatus.Alert -> Severity.Orange
                WHEN 4 THEN 5 -- Alarmstatus.Danger -> Severity.Danger
                WHEN 5 THEN 6 -- Alarmstatus.NWarning -> Severity.Yellow
                WHEN 6 THEN 9 -- Alarmstatus.NAlert -> Severity.Orange
                WHEN 7 THEN 5 -- Alarmstatus.NDanger -> Severity.Danger
                ELSE 0 
               END AS [Severity]
            , ROW_NUMBER() OVER (PARTITION BY [MeasurementID] ORDER BY [Timestamp] DESC) AS RowNumber
        FROM [Recording] WHERE [Alarmstatus] != 3 AND [Timestamp] > '2016-03-25'
    ) as rowed
    WHERE rowed.RowNumber = 1
) AS src ([MeasurementId], [Severity])
ON tgt.[MeasurementId] = src.[MeasurementId]
WHEN MATCHED THEN
    UPDATE SET tgt.[Severity] = src.[Severity];

MERGE [Sensor] AS tgt
USING (
	SELECT [SensorID],
		    CASE MAX(CASE [Severity]
    			WHEN 0 THEN 0 /* SystemLogIssue */
    			WHEN 3 THEN 0 /* BlueUnacknowledged */
    			WHEN 7 THEN 0 /* Blue */
    			WHEN 8 THEN 0 /* Green */
    			WHEN 4 THEN 1 /* GreenUnacknowledged */ 
    			WHEN 6 THEN 2 /* Yellow */
    			WHEN 2 THEN 3 /* YellowUnacknowledged */
    			WHEN 9 THEN 4 /* Orange */
    			WHEN 10 THEN 5 /* OrangeUnacknowledged */
    			WHEN 5 THEN 6 /* Red */
    			WHEN 1 THEN 7 /* RedUnacknowledged */
    			ELSE 0
    		END)
    		WHEN 0 THEN 8
    		WHEN 1 THEN 4
    		WHEN 2 THEN 6
    		WHEN 3 THEN 2
    		WHEN 4 THEN 9
    		WHEN 5 THEN 10
    		WHEN 6 THEN 5
            WHEN 7 THEN 1
			END AS [Severity]
	FROM [Measurement] meas
    GROUP BY [SensorID]
) AS src ([SensorId], [Severity])
ON tgt.[SensorID] = src.[SensorID]
WHEN MATCHED THEN
    UPDATE SET tgt.[Severity] = src.[Severity];
    
MERGE [Machine] AS tgt
USING (
	SELECT [MachineID],
		    CASE MAX(CASE [Severity]
    			WHEN 0 THEN 0 /* SystemLogIssue */
    			WHEN 3 THEN 0 /* BlueUnacknowledged */
    			WHEN 7 THEN 0 /* Blue */
    			WHEN 8 THEN 0 /* Green */
    			WHEN 4 THEN 1 /* GreenUnacknowledged */ 
    			WHEN 6 THEN 2 /* Yellow */
    			WHEN 2 THEN 3 /* YellowUnacknowledged */
    			WHEN 9 THEN 4 /* Orange */
    			WHEN 10 THEN 5 /* OrangeUnacknowledged */
    			WHEN 5 THEN 6 /* Red */
    			WHEN 1 THEN 7 /* RedUnacknowledged */
    			ELSE 0
    		END)
    		WHEN 0 THEN 8
    		WHEN 1 THEN 4
    		WHEN 2 THEN 6
    		WHEN 3 THEN 2
    		WHEN 4 THEN 9
    		WHEN 5 THEN 10
    		WHEN 6 THEN 5
            WHEN 7 THEN 1
			END AS [Severity]
	FROM [Sensor] s
    GROUP BY [MachineID]
) AS src ([MachineID], [Severity])
ON src.[MachineID] = tgt.[MachineID]
WHEN MATCHED THEN
	UPDATE SET tgt.[Severity] = src.[Severity];
    
------------------------------ Cleanup mdataport -------------------------------
--DELETE FROM [AlarmRecord]
--DELETE FROM [AlarmDefinition]
--DELETE FROM [Machine]
--DELETE FROM [Alarm]

SELECT * FROM [AlarmDefinition] ORDER BY [Name], [ModifiedDate]
SELECT * FROM [AlarmThreshold] ORDER BY [AlarmDefinitionID], [Timestamp], [Level]
SELECT * FROM [AlarmRecord] ORDER BY [Timestamp]
SELECT * FROM [Alarm] ORDER BY [FromTime]

SELECT * FROM [Recording] ORDER BY CAST([Timestamp] AS date) AS [Date], [MeasurementID], CAST([Timestamp] AS time) AS [Time]


-- Get recording path
SELECT si.[SiteID]
      ,si.[Name] AS [SiteName]
      ,m.[MachineID]
      ,m.[Name] AS [MachineName]
      ,s.[SensorID]
      ,s.[Name] AS [SensorName]
      ,meas.[MeasurementID]
      ,meas.[Name] AS [MeasurementName]
      ,meas.[Type] AS [MeasurementType]
	  ,[Timestamp]
      ,r.[Type]
      ,[AlarmStatus]
      ,[BiasVoltage]
      ,[Hash]
      ,[Overall]
      ,[RPM]
      ,[Offset]
      ,[Delta]
      ,[XUnit]
      ,[YUnit]
      ,[Count]
      ,[YValue]
FROM [Recording] r
LEFT JOIN [Measurement] meas ON meas.[MeasurementID] = r.[MeasurementID]
LEFT JOIN [Sensor] s ON s.[SensorID] = meas.[SensorID]
LEFT JOIN [Machine] m ON m.[MachineID] = s.[MachineID]
LEFT JOIN [Site] si ON si.[SiteID] = m.[SiteID]
WHERE s.[SensorID] = @SensorID AND r.[Timestamp] BETWEEN @From AND DATEADD(DAY, 1, @From) AND [Hash] IS NOT NULL AND [Hash] NOT LIKE '%[_]%'
ORDER BY [SensorName], [MeasurementName], [Timestamp], [Type]




SELECT r.[MeasurementID], r.[Timestamp], r.[Type], r.[Hash]
FROM [Recording] r
LEFT JOIN [Measurement] meas ON meas.[MeasurementID] = r.[MeasurementID]
LEFT JOIN [Sensor] s ON s.[SensorID] = meas.[SensorID]
LEFT JOIN [Machine] m ON m.[MachineID] = s.[MachineID]
LEFT JOIN [Site] si ON si.[SiteID] = m.[SiteID]
WHERE r.[Hash] IS NOT NULL
ORDER BY CAST(r.[Timestamp] AS DATE), m.[Name], s.[Name], meas.[Name]



SQLCMD -S .\sqlexpress -d MDataPort_TaoHuaShan -Q "SELECT 'SELECT ''' + CAST(DATEPART(YEAR, [Timestamp]) AS nvarchar(4)) + '\' + CAST(DATEPART(MONTH, [Timestamp]) AS nvarchar(2))  + '\' + CAST(DATEPART(DAY, [Timestamp]) AS nvarchar(2)) + '\'' + [Hash] FROM [Recording] WHERE [MeasurementID] = ''' + CAST([MeasurementID] AS nvarchar(100)) + ''' AND [Timestamp] = ''' + CAST([Timestamp] AS nvarchar(50)) + ''' AND [Type] = ' + CAST([TYPE] AS nvarchar(2)) FROM [Recording] WHERE [Hash] IN ('-208580912714918604680','207775097712633237040','-19517735548684703240','-1150110698-20840462260','141836828614542383600','-1284439667-11775216660','3685976816737699330','207281685414535981930','107380298014535981930','75261228712123988470','-905785279-13902942200','180040424320962533470','11015000015323586560','11657341299359927600','6166841411063913890','-76969051214287606990','339397819-15544969640','560813394-10048939100','90609893011590746050','791598578-17371115370','-52008788811153287790','643180482-18057778310','-1295575148-2248794500','1101500001-2870641100','-87886913321348988590','-1550508255-20814070740','-1010469435-20814070740','25293840719512049090','-1511405067-3102708330','-233311142-20087439820','-21112067597875355200','846217279-5614104230','1454211863-10833785990','2102527557-16693532660','-640851081-16693532660','1356060014-5993931270','-89947880619194039600','-1660227616638138080','51749182513467818780','4726573116270436050','184162904318807272760','1250596854-20390044160','-1527887972214171580','18323727204725691780','5121713284174652650','1119085193214295360','-1245978435-6505757620','-123012072510956471280','199783570917200753710','-1491964398-20545355080','-101806466617471328570','1524290189-16202198390','13276849110782216200','-51348183316210418980','3488856638227533100','20833909818435363170','-7127712318435363170','161200630-6483477930','-49917620614522207630','812138057-12562051580','1553925533-12562051580','961081049-14967087320')"

SQLCMD -S .\sqlexpress -d MDataPort_taohuashan -Q "SELECT 'D:\Data_TaoHuaShan\Recordings\e99f56d1-d569-4d2e-bd77-13fce37e077f\' + CAST(DATEPART(YEAR, [Timestamp]) AS nvarchar(4)) + '\' + CAST(DATEPART(MONTH, [Timestamp]) AS nvarchar(2)) + '\' + CAST(DATEPART(DAY, [Timestamp]) AS nvarchar(4)) + '\' + [Hash] FROM [Recording] WHERE [Hash] is not null and [Hash] not like '%[_]%'"

'


SELECT m.[Name], ISNULL(t.NUMBER, 0)
FROM [Machine] m
  LEFT JOIN (
    SELECT s.[MachineID], COUNT(*) AS NUMBER
    FROM [Recording] r
    LEFT JOIN [Measurement] meas ON meas.[MeasurementID] = r.[MeasurementID]
    LEFT JOIN [Sensor] s ON s.[SensorID] = meas.[SensorID]
    GROUP BY s.[MachineID]
  ) AS t on t.[MachineID] = m.[MachineID]
ORDER BY m.[Name]


SELECT m.[Name], s.[Name], ISNULL(t.NUMBER, 0)
FROM [Sensor] s
  LEFT JOIN [Machine] m on m.[MachineID] = s.[MachineID]
  LEFT JOIN (
    SELECT meas.[SensorID], COUNT(*) AS NUMBER
    FROM [Recording] r
    LEFT JOIN [Measurement] meas ON meas.[MeasurementID] = r.[MeasurementID]
    GROUP BY meas.[SensorID]
  ) AS t on t.[sensorid] = s.[sensorid]
ORDER BY m.[Name], s.[Name]


SELECT m.[Name], s.[Name], meas.[Name], ISNULL(t.NUMBER, 0)
FROM [Measurement] meas 
  LEFT JOIN [Sensor] s on s.[SensorID] = meas.[SensorID]
  LEFT JOIN [Machine] m on m.[MachineID] = s.[MachineID]
  LEFT JOIN (
    SELECT meas.[MeasurementID], COUNT(*) AS NUMBER
    FROM [Recording] r
    LEFT JOIN [Measurement] meas ON meas.[MeasurementID] = r.[MeasurementID]
    GROUP BY meas.[MeasurementID]
  ) AS t on t.[MeasurementID] = meas.[MeasurementID]
ORDER BY m.[Name], s.[Name], meas.[Name]


SELECT [MeasurementID], [timestamp], cast([timestamp] as date), substring(CONVERT(VARCHAR(8), [timestamp], 108), 1, 2)
      ,[AlarmStatus]
      ,[BiasVoltage]
      ,[Overall]
      ,[RPM]
      ,[YValue]
      ,[Metadata]
  FROM [dbo].[Recording]
where [Count] = 1
order by [MeasurementID], cast([timestamp] as date), substring(CONVERT(VARCHAR(8), [timestamp], 108), 1, 2)



