-- Site
IF EXISTS (SELECT * FROM [Option] WHERE [OptionID] = 'OPTION_SITE_ID')
BEGIN
  DECLARE @SiteId uniqueidentifier;
  SELECT @SiteId = [Value] FROM [Option] WHERE [OptionID] = 'OPTION_SITE_ID';
  UPDATE [Site] SET [SiteId2] = 0, [UpdateTime] = GETUTCDATE() WHERE [SiteID] = @SiteID;

  UPDATE e
  SET e.[SiteId2] = v.[Id], e.[UpdateTime] = GETUTCDATE()
  FROM [Site] e
  JOIN (
    SELECT [SiteID], NEXT VALUE FOR [SiteIdSequence] AS [Id]
    FROM [Site]
  ) v ON v.[SiteID] = e.[SiteID]
  WHERE e.[SiteID] != @SiteID
END
ELSE
  UPDATE e
  SET e.[SiteId2] = v.[Id]
    , e.[UpdateTime] = GETUTCDATE()
  FROM [Site] e
  JOIN (
    SELECT [SiteID], NEXT VALUE FOR [SiteIdSequence] AS [Id]
    FROM [Site]
  ) v ON v.[SiteID] = e.[SiteID]

-- DataSource
UPDATE e
SET e.[DataSourceId2] = v.[Id]
  , e.[SiteId2] = v.[SiteId2]
  , e.[UpdateTime] = GETUTCDATE()
FROM [DataSource] e
JOIN (
  SELECT ei.[DataSourceID], s.[SiteId2], NEXT VALUE FOR [DataSourceIdSequence] OVER (ORDER BY ei.[Name]) AS [Id]
  FROM [DataSource] ei
  JOIN [Site] s ON s.[SiteID] = ei.[SiteID]
) v ON v.[DataSourceID] = e.[DataSourceID];

-- FaultHandlingMethod
UPDATE e
SET e.[SiteId] = 0
  , e.[FaultHandlingMethodId2] = v.[Id]
  , e.[UpdateTime] = GETUTCDATE()
FROM [FaultHandlingMethod] e
JOIN (
  SELECT ei.[FaultHandlingMethodId], NEXT VALUE FOR [FaultHandlingMethodIdSequence] OVER (ORDER BY ei.[FaultHandlingMethodId]) AS [Id]
  FROM [FaultHandlingMethod] ei
) v ON v.[FaultHandlingMethodId] = e.[FaultHandlingMethodID]


-- FaultLocation
UPDATE e
SET e.[SiteId] = 0
  , e.[FaultLocationId2] = v.[Id]
  , e.[UpdateTime] = GETUTCDATE()
FROM [FaultLocation] e
JOIN (
  SELECT ei.[FaultLocationId], NEXT VALUE FOR [FaultLocationIdSequence] OVER (ORDER BY ei.[FaultLocationId]) AS [Id]
  FROM [FaultLocation] ei
) v ON v.[FaultLocationId] = e.[FaultLocationId]


-- FaultType
UPDATE e
SET e.[SiteId] = 0
  , e.[FaultTypeId2] = v.[Id]
  , e.[UpdateTime] = GETUTCDATE()
FROM [FaultType] e
JOIN (
  SELECT ei.[FaultTypeId], NEXT VALUE FOR [FaultTypeIdSequence] OVER (ORDER BY ei.[FaultTypeId]) AS [Id]
  FROM [FaultType] ei
) v ON v.[FaultTypeId] = e.[FaultTypeId]

-- Folder
UPDATE e
SET e.[SiteId2] = v.[SiteId2]
  , e.[FolderId2] = v.[Id]
  , e.[UpdateTime] = GETUTCDATE()
FROM [Folder] e
JOIN (
  SELECT ei.[FolderId], s.[SiteId2], NEXT VALUE FOR [FolderIdSequence] OVER (ORDER BY ei.[FolderId]) AS [Id]
  FROM [Folder] ei
  JOIN [Site] s ON s.[SiteId] = ei.[SiteId]
) v ON v.[FolderId] = e.[FolderId]

-- MachineType
UPDATE e
SET e.[SiteId] = 0
  , e.[MachineTypeId2] = v.[Id]
  , e.[UpdateTime] = GETUTCDATE()
FROM [MachineType] e
JOIN (
  SELECT ei.[MachineTypeId], NEXT VALUE FOR [MachineTypeIdSequence] OVER (ORDER BY ei.[Name]) AS [Id]
  FROM [MachineType] ei
) v ON v.[MachineTypeId] = e.[MachineTypeId]

-- Machine
UPDATE e
SET e.[SiteId2] = v.[SiteId2]
  , e.[MachineId2] = v.[Id]
  , e.[UpdateTime] = GETUTCDATE()
FROM [Machine] e
JOIN (
  SELECT ei.[MachineId], s.[SiteId2], NEXT VALUE FOR [MachineIdSequence] OVER (ORDER BY ei.[Name]) AS [Id]
  FROM [Machine] ei
  JOIN [Site] s ON s.[SiteId] = ei.[SiteId]
) v ON v.[MachineId] = e.[MachineId]

-- MachineMetadata
UPDATE e
SET e.[SiteId] = v.[SiteId2]
  , e.[MachineId2] = v.[Id]
  , e.[UpdateTime] = GETUTCDATE()
FROM [MachineMetadata] e
JOIN (
  SELECT ei.[MachineId], ei.[MachineId2] AS [Id], ei.[SiteId2]
  FROM [Machine] ei
) v ON v.[MachineId] = e.[MachineId]

-- Replication
UPDATE e
SET e.[SiteId2] = v.[SiteId2]
  , e.[UpdateTime] = GETUTCDATE()
FROM [Replication] e
JOIN (
  SELECT ei.[ReplicationId], s.[SiteId2]
  FROM [Replication] ei
  JOIN [Site] s ON s.[SiteID] = ei.[SiteID]
) v ON v.[ReplicationId] = e.[ReplicationId]

-- PartType
UPDATE e
SET e.[SiteId] = 0
  , e.[PartTypeId2] = v.[Id]
  , e.[UpdateTime] = GETUTCDATE()
FROM [PartType] e
JOIN (
  SELECT ei.[PartTypeId]
	   , mt.[MachineTypeID2]
	   , NEXT VALUE FOR [PartTypeIdSequence] OVER (ORDER BY ei.[PartTypeId]) AS [Id]
  FROM [PartType] ei
  JOIN [MachineType] mt ON mt.[MachineTypeID] = ei.[MachineTypeID]
) v ON v.[PartTypeId] = e.[PartTypeId]

-- Report
UPDATE e
SET e.[SiteId2] = v.[SiteId2]
  , e.[ReportId2] = v.[Id]
  , e.[UpdateTime] = GETUTCDATE()
FROM [Report] e
JOIN (
  SELECT ei.[ReportId]
       , s.[SiteId2]
       , NEXT VALUE FOR [ReportIdSequence] OVER (ORDER BY ei.[ReportSN]) AS [Id]
  FROM [Report] ei
  JOIN [Site] s ON s.[SiteId] = ei.[SiteId]
) v ON v.[ReportId] = e.[ReportId]

-- Alarm
UPDATE e
SET e.[SiteId] = v.[SiteId2]
  , e.[AlarmId2] = v.[Id]
  , e.[UpdateTime] = GETUTCDATE()
FROM [Alarm] e
JOIN (
  SELECT ei.[AlarmId]
       , ds.[SiteId2]
       , NEXT VALUE FOR [AlarmIdSequence] OVER (ORDER BY ei.[FromTime]) AS [Id]
  FROM [Alarm] ei
  JOIN [DataSource] ds ON ds.[DataSourceID] = ei.[DataSourceID]
) v ON v.[AlarmId] = e.[AlarmId]

-- Fault
UPDATE e
SET e.[SiteId] = v.[SiteId2]
  , e.[MachineId2] = v.[MachineId2]
  , e.[FaultId2] = v.[Id]
  , e.[UpdateTime] = GETUTCDATE()
FROM [Fault] e
JOIN (
  SELECT ei.[FaultId]
       , m.[SiteId2]
	   , m.[MachineId2]
       , NEXT VALUE FOR [FaultIdSequence] OVER (ORDER BY ei.[FaultStartDate]) AS [Id]
  FROM [Fault] ei
  JOIN [Machine] m ON m.[MachineID] = ei.[MachineID]
) v ON v.[FaultId] = e.[FaultId]

-- MachinePart
UPDATE e
SET e.[SiteId] = v.[SiteId2]
  , e.[MachineId2] = v.[MachineId2]
  , e.[MachinePartId2] = v.[Id]
  , e.[PartTypeId2] = v.[PartTypeId2]
FROM [MachinePart] e
JOIN (
  SELECT ei.[MachinePartId]
       , m.[SiteId2]
	   , m.[MachineId2]
	   , pt.[PartTypeId2]
       , NEXT VALUE FOR [MachinePartIdSequence] OVER (ORDER BY ei.UpdateTime) AS [Id]
  FROM [MachinePart] ei
  JOIN [Machine] m ON m.[MachineID] = ei.[MachinePartID]
  JOIN [PartType] pt ON pt.[PartTypeID] = ei.[PartTypeID]
) v ON v.[MachinePartId] = e.[MachinePartId]

-- Point
UPDATE e
SET e.[SiteId] = v.[SiteId2]
  , e.[MachineId2] = v.[MachineId2]
  , e.[PointId2] = v.[Id]
  , e.[UpdateTime] = GETUTCDATE()
FROM [Point] e
JOIN (
  SELECT ei.[PointId]
       , m.[SiteId2]
	   , m.[MachineId2]
       , NEXT VALUE FOR [PointIdSequence] OVER (ORDER BY m.[Name], ei.[Name]) AS [Id]
  FROM [Point] ei
  JOIN [Machine] m ON m.[MachineID] = ei.[MachineID]
) v ON v.[PointId] = e.[PointId]

-- RepireRecord
UPDATE e
SET e.[SiteId] = v.[SiteId2]
  , e.[MachineId2] = v.[MachineId2]
  , e.[RepireRecordId] = v.[Id]
FROM [RepireRecord] e
JOIN (
  SELECT ei.[RepairRecordID]
       , m.[SiteId2]
       , m.[MachineId2]
       , NEXT VALUE FOR [RepireRecordIdSequence] OVER (ORDER BY ei.[UpdateTime]) AS [Id]
  FROM [RepireRecord] ei
  JOIN [Machine] m ON m.[MachineID] = ei.[MachineID]
) v ON v.[RepairRecordID] = e.[RepairRecordID]

-- ReportEntry
UPDATE e
SET e.[SiteId] = v.[SiteId2]
  , e.[MachineId2] = v.[MachineId2]
  , e.[ReportId2] = v.[ReportId2]
  , e.[ReportEntryId2] = v.[Id]
  , e.[UpdateTime] = GETUTCDATE()
FROM [ReportEntry] e
JOIN (
  SELECT ei.[ReportEntryId]
       , m.[SiteId2]
       , m.[MachineId2]
	   , r.[ReportId2]
       , NEXT VALUE FOR [ReportEntryIdSequence] OVER (ORDER BY r.[ReportSN], m.[Name]) AS [Id]
  FROM [ReportEntry] ei
  JOIN [Machine] m ON m.[MachineID] = ei.[MachineID]
  JOIN [Report] r ON r.[ReportID] = ei.[ReportEntryID]
) v ON v.[ReportEntryId] = e.[ReportEntryId]

-- Sensor
UPDATE e
SET e.[SiteId] = v.[SiteId2]
  , e.[MachineId2] = v.[MachineId2]
  , e.[PointId2] = v.[PointId2]
  , e.[SensorId2] = v.[Id]
  , e.[UpdateTime] = GETUTCDATE()
FROM [Sensor] e
JOIN (
  SELECT ei.[SensorId]
       , m.[SiteId2]
       , m.[MachineId2]
	   , p.[PointId2]
       , NEXT VALUE FOR [SensorIdSequence] OVER (ORDER BY m.[Name], ei.[Name]) AS [Id]
  FROM [Sensor] ei
  JOIN [Machine] m ON m.[MachineID] = ei.[MachineID]
  JOIN [Point] p ON p.[PointID] = ei.[PointID]
) v ON v.[SensorId] = e.[SensorId]

-- BearingInfo
UPDATE e
SET e.[SiteId] = v.[SiteId]
  , e.[PointId2] = v.[PointId2]
  , e.[UpdateTime] = GETUTCDATE()
FROM [BearingInfo] e
JOIN (
  SELECT ei.[PointID], ei.[PointId2], ei.[SiteId]
  FROM [Point] ei
) v ON v.[PointId] = e.PointID

-- GearInfo
UPDATE e
SET e.[SiteId] = v.[SiteId]
  , e.[PointId2] = v.[PointId2]
  , e.[GearInfoId2] = v.[Id]
  , e.[UpdateTime] = GETUTCDATE()
FROM [GearInfo] e
JOIN (
  SELECT ei.[PointID]
       , ei.[PointId2]
	   , ei.[SiteId]
       , NEXT VALUE FOR [GearInfoIdSequence] OVER (ORDER BY ei.[Name]) AS [Id]
  FROM [GearInfo] ei
  JOIN [Point] p ON p.[PointID] = ei.[PointID]
) v ON v.[PointId] = e.PointID

-- Measurement
UPDATE e
SET e.[SiteId] = v.[SiteId]
  , e.[SensorId2] = v.[SensorId2]
  , e.[MeasurementId2] = v.[Id]
  , e.[UpdateTime] = GETUTCDATE()
FROM [Measurement] e
JOIN (
  SELECT ei.[MeasurementId]
       , s.[SiteId]
       , s.[SensorId2]
       , NEXT VALUE FOR [MeasurementIdSequence] OVER (ORDER BY s.[Name], ei.[Name]) AS [Id]
  FROM [Measurement] ei
  JOIN [Sensor] s ON s.[SensorID] = ei.[SensorID]
) v ON v.[MeasurementId] = e.[MeasurementId]

-- AlarmDefinition
UPDATE e
SET e.[SiteId] = v.[SiteId]
  , e.[AlarmDefinitionId2] = v.[Id]
  , e.[UpdateTime] = GETUTCDATE()
FROM [AlarmDefinition] e
JOIN (
  SELECT ei.[AlarmDefinitionId]
       , m.[SiteId]
       , NEXT VALUE FOR [AlarmDefinitionIdSequence] OVER (ORDER BY ei.[UpdateTime]) AS [Id]
  FROM [AlarmDefinition] ei
  JOIN [Measurement] m ON m.[MeasurementID] = ei.[MeasurementID]
) v ON v.[AlarmDefinitionId] = e.[AlarmDefinitionId]

-- Recording
UPDATE e
SET e.[SiteId] = m.[SiteId]
  , e.[MeasurementId2] = m.[MeasurementId2]
FROM [Recording] e
JOIN [Measurement] m ON m.[MeasurementID] = e.[MeasurementID]

-- AlarmThreshold
UPDATE e
SET e.[SiteId] = v.[SiteId]
  , e.[AlarmThresholdId2] = v.[Id]
FROM [AlarmThreshold] e
JOIN (
  SELECT m.[SiteId]
       , m.[AlarmDefinitionId2]
	   , ei.[AlarmThresholdID]
       , NEXT VALUE FOR [AlarmThresholdIdSequence] OVER (ORDER BY m.[AlarmDefinitionId2], ei.[InsertTime]) AS [Id]
  FROM [AlarmThreshold] ei
  JOIN [AlarmDefinition] m ON m.[AlarmDefinitionID] = ei.[AlarmDefinitionId]
) v ON v.[AlarmThresholdId] = e.[AlarmThresholdId]

-- AlarmRecord
UPDATE e
SET e.[SiteId] = v.[SiteId]
  , e.[MeasurementId2] = v.[MeasurementId2]
  , e.[AlarmId2] = v.[AlarmId2]
  , e.[AlarmThresholdId] = v.[AlarmThresholdId2]
FROM [AlarmRecord] e
JOIN (
  SELECT ei.[AlarmRecordId]
       , m.[SiteId]
	   , a.[AlarmId2]
	   , r.[MeasurementId2]
       , m.[AlarmThresholdId2]
  FROM [AlarmRecord] ei
  JOIN [Recording] r ON r.[MeasurementID] = ei.[MeasurementID]
  JOIN [AlarmThreshold] m ON m.[AlarmThresholdID] = ei.[ThresholdId]
  JOIN [Alarm] a ON a.[AlarmID] = ei.[AlarmID]
) v ON v.[AlarmRecordId] = e.[AlarmRecordId]

-- UserSite
UPDATE e
SET e.[SiteId2] = s.[SiteId2]
FROM [UserSite] e
JOIN [Site] s ON s.[SiteID] = e.[SiteID]