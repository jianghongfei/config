ALTER TABLE [Site] ADD [SiteId2] tinyint;
ALTER TABLE [Site] ADD [UpdateTime] datetime2(7);
CREATE SEQUENCE [SiteIdSequence] AS tinyint START WITH 1;


ALTER TABLE [DataSource] ADD [DataSourceId2] int;
ALTER TABLE [DataSource] ADD [SiteID2] tinyint;
ALTER TABLE [DataSource] ADD [UpdateTime] datetime2(7);
CREATE SEQUENCE [DataSourceIdSequence] AS int START WITh 1;


ALTER TABLE [FaultHandlingMethod] ADD [SiteId] tinyint;
ALTER TABLE [FaultHandlingMethod] ADD [FaultHandlingMethodId2] int;
ALTER TABLE [FaultHandlingMethod] ADD [UpdateTime] datetime2(7);
CREATE SEQUENCE [FaultHandlingMethodIdSequence] AS int START WITH 1;


ALTER TABLE [FaultLocation] ADD [SiteId] tinyint;
ALTER TABLE [FaultLocation] ADD [FaultLocationId2] int;
ALTER TABLE [FaultLocation] ADD [UpdateTime] datetime2(7);
CREATE SEQUENCE [FaultLocationIdSequence] AS int START WITH 1;


ALTER TABLE [FaultType] ADD [SiteId] tinyint;
ALTER TABLE [FaultType] ADD [FaultTypeId2] int;
ALTER TABLE [FaultType] ADD [UpdateTime] datetime2(7);
CREATE SEQUENCE [FaultTypeIdSequence] AS int START WITh 1;


ALTER TABLE [Folder] ADD [FolderId2] int;
ALTER TABLE [Folder] ADD [SiteID2] int;
ALTER TABLE [Folder] ADD [UpdateTime] datetime2(7);
CREATE SEQUENCE [FolderIdSequence] AS int START WITH 1;


ALTER TABLE [MachineType] ADD [SiteID] tinyint;
ALTER TABLE [MachineType] ADD [MachineTypeId2] int;
ALTER TABLE [MachineType] ADD [UpdateTime] datetime2(7);
CREATE SEQUENCE [MachineTypeIdSequence] AS int START WITh 1;


ALTER TABLE [Machine] ADD [MachineId2] int;
ALTER TABLE [Machine] ADD [SiteID2] tinyint;
ALTER TABLE [Machine] ADD [FolderID2] int;
ALTER TABLE [Machine] ADD [UpdateTime] datetime2(7);
CREATE SEQUENCE [MachineIdSequence] AS int START WITh 1;


ALTER TABLE [MachineMetadata] ADD [MachineId2] int;
ALTER TABLE [MachineMetadata] ADD [SiteId] tinyint;
ALTER TABLE [MachineMetadata] ADD [MachineTypeId2] int;
ALTER TABLE [MachineMetadata] ADD [UpdateTime] datetime2(7);


EXEC sp_rename 'ReplicationTarget', 'Replication';
EXEC sp_rename 'Replication.ReplicationTargetId', 'ReplicationId', 'COLUMN';
ALTER TABLE [Replication] ADD [SiteId2] tinyint;
ALTER TABLE [Replication] ADD [UpdateTime] datetime2(7);


ALTER TABLE [PartType] ADD [PartTypeId2] int;
ALTER TABLE [PartType] ADD [SiteID] tinyint;
ALTER TABLE [PartType] ADD [MachineTypeID2] int;
ALTER TABLE [PartType] ADD [UpdateTime] datetime2(7);
CREATE SEQUENCE [PartTypeIdSequence] AS int START WITH 1;


ALTER TABLE [Report] ADD [ReportId2] int;
ALTER TABLE [Report] ADD [SiteID2] tinyint;
ALTER TABLE [Report] ADD [UpdateTime] datetime2(7);
CREATE SEQUENCE [ReportIdSequence] AS int START WITh 1;

-- level 2

-- datasource
ALTER TABLE [Alarm] ADD [AlarmId2] int;
ALTER TABLE [Alarm] ADD [SiteID] tinyint;
ALTER TABLE [Alarm] ADD [DataSourceID2] int;
ALTER TABLE [Alarm] ADD [UpdateTime] datetime2(7);
CREATE SEQUENCE [AlarmIdSequence] AS int START WITH 1;


-- machine
ALTER TABLE [Fault] ADD [FaultId2] int;
ALTER TABLE [Fault] ADD [SiteId] tinyint;
ALTER TABLE [Fault] ADD [MachineId2] int;
ALTER TABLE [Fault] ADD [UpdateTime] datetime2(7);
CREATE SEQUENCE [FaultIdSequence] AS int START WITh 1;


ALTER TABLE [MachinePart] ADD [MachinePartId2] int;
ALTER TABLE [MachinePart] ADD [SiteId] tinyint;
ALTER TABLE [MachinePart] ADD [PartTypeId2] int;
ALTER TABLE [MachinePart] ADD [MachineId2] int;
EXEC sp_rename 'MachinePart.ModifiedDate', 'UpdateTime', 'COLUMN';
CREATE SEQUENCE [MachinePartIdSequence] AS int START WITH 1;


ALTER TABLE [Point] ADD [PointId2] int;
ALTER TABLE [Point] ADD [MachineId2] int;
ALTER TABLE [Point] ADD [SiteId] tinyint;
ALTER TABLE [Point] ADD [UpdateTime] datetime2(7);
CREATE SEQUENCE [PointIdSequence] AS int START WITh 1;


EXEC sp_rename 'RepaireRecord', 'RepireRecord';
ALTER TABLE [RepireRecord] ADD [RepireRecordId] int;
ALTER TABLE [RepireRecord] ADD [MachineID2] int;
ALTER TABLE [RepireRecord] ADD [SiteID] tinyint;
EXEC sp_rename 'RepireRecord.Timestamp', 'UpdateTime', 'COLUMN';
CREATE SEQUENCE [RepireRecordIdSequence] AS int START WITH 1;


ALTER TABLE [ReportEntry] ADD [ReportEntryId2] int;
ALTER TABLE [ReportEntry] ADD [ReportId2] int;
ALTER TABLE [ReportEntry] ADD [MachineId2] int;
ALTER TABLE [ReportEntry] ADD [SiteId] tinyint;
ALTER TABLE [ReportEntry] ADD [UpdateTime] datetime2(7);
CREATE SEQUENCE [ReportEntryIdSequence] AS int START WITH 1;


ALTER TABLE [Sensor] ADD [SensorId2] int;
ALTER TABLE [Sensor] ADD [PointId2] int;
ALTER TABLE [Sensor] ADD [MachineId2] int;
ALTER TABLE [Sensor] ADD [SiteId] tinyint;
ALTER TABLE [Sensor] ADD [UpdateTime] datetime2(7);
CREATE SEQUENCE [SensorIdSequence] AS int START WITh 1;


-- level 3
ALTER TABLE [BearingInfo] ADD [SiteId] tinyint;
ALTER TABLE [BearingInfo] ADD [PointId2] int;
ALTER TABLE [BearingInfo] ADD [UpdateTime] datetime2(7);


ALTER TABLE [GearInfo] ADD [SiteId] tinyint;
ALTER TABLE [GearInfo] ADD [PointId2] int;
ALTER TABLE [GearInfo] ADD [GearInfoId2] int;
ALTER TABLE [GearInfo] ADD [UpdateTime] datetime2(7);
CREATE SEQUENCE [GearInfoIdSequence] AS int START WITh 1;


ALTER TABLE [Measurement] ADD [MeasurementId2] int;
ALTER TABLE [Measurement] ADD [SensorId2] int;
ALTER TABLE [Measurement] ADD [SiteId] tinyint;
ALTER TABLE [Measurement] ADD [DataSourceID2] int;
ALTER TABLE [Measurement] ADD [UpdateTime] datetime2(7);
CREATE SEQUENCE [MeasurementIdSequence] AS int START WITH 1;


-- level 4
ALTER TABLE [AlarmDefinition] ADD [AlarmDefinitionId2] int;
ALTER TABLE [AlarmDefinition] ADD [MeasurementID2] int;
ALTER TABLE [AlarmDefinition] ADD [SiteId] int;
EXEC sp_rename 'AlarmDefinition.ModifiedDate', 'UpdateTime', 'COLUMN';
CREATE SEQUENCE [AlarmDefinitionIdSequence] AS int START WITH 1;


ALTER TABLE [Recording] ADD [MeasurementId2] int;
ALTER TABLE [Recording] ADD [SiteId] tinyint;

-- level 5
ALTER TABLE [AlarmThreshold] ADD [AlarmThresholdId2] int;
ALTER TABLE [AlarmThreshold] ADD [AlarmDefinitionId2] int;
ALTER TABLE [AlarmThreshold] ADD [SiteId] tinyint;
EXEC sp_rename 'AlarmThreshold.Timestamp', 'InsertTime', 'COLUMN';
CREATE SEQUENCE [AlarmThresholdIdSequence] AS int START WITH 1;

-- level 6
ALTER TABLE [AlarmRecord] ADD [MeasurementId2] int;
ALTER TABLE [AlarmRecord] ADD [AlarmId2] int;
ALTER TABLE [AlarmRecord] ADD [SiteId] tinyint;
ALTER TABLE [AlarmRecord] ADD [AlarmThresholdId] int;

ALTER TABLE [UserSite] ADD [SiteId2] tinyint;

GO








