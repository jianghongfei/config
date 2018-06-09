--------------------------- PRIMARY KEY ----------------------------------------
-- DROP Indexes
DECLARE @index nvarchar(50);
DECLARE @table nvarchar(50);
  
DECLARE index_cursor CURSOR FOR   
SELECT idx.[Name], t.[Name]  
FROM sys.indexes idx
JOIN sys.tables t ON t.[object_id] = idx.[object_id]
WHERE idx.[name] LIKE 'IX%'

  
OPEN index_cursor  
  
FETCH NEXT FROM index_cursor   
INTO @index, @table  
  
WHILE @@FETCH_STATUS = 0  
BEGIN  
  EXEC('DROP INDEX [' + @index + '] ON [' + @table + ']');

  FETCH NEXT FROM index_cursor   
  INTO @index, @table  
END   
CLOSE index_cursor;  
DEALLOCATE index_cursor; 

-- level 1
-- Site
ALTER TABLE [Report] DROP CONSTRAINT [FK_dbo.Report_dbo.Site_SiteID];
ALTER TABLE [Machine] DROP CONSTRAINT [FK_dbo.Machine_dbo.Site_SiteID];
ALTER TABLE [Folder] DROP CONSTRAINT [FK_dbo.Folder_dbo.Site_SiteID];
ALTER TABLE [DataSource] DROP CONSTRAINT [FK_dbo.DataSource_dbo.Site_SiteID];
ALTER TABLE [UserSite] DROP CONSTRAINT [FK_dbo.UserSite_dbo.Site_SiteID];

ALTER TABLE [Site] ALTER COLUMN [SiteId2] tinyint NOT NULL;
ALTER TABLE [Site] DROP CONSTRAINT [PK_dbo.Site];
--ALTER TABLE [Site] DROP COLUMN [SiteId];
EXEC sp_rename 'Site.SiteID', 'UUID', 'COLUMN';
EXEC sp_rename 'Site.SiteId2', 'SiteId', 'COLUMN';
ALTER TABLE [Site] ADD CONSTRAINT [PK_Site] PRIMARY KEY CLUSTERED ([SiteID])
Go
CREATE TRIGGER [SiteUpdateTimeTrigger] ON [Site]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [Site] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId]
  END
END

-- DataSource
ALTER TABLE [Measurement] DROP CONSTRAINT [FK_dbo.Measurement_dbo.DataSource_DataSourceID];
ALTER TABLE [Alarm] DROP CONSTRAINT [FK_dbo.Alarm_dbo.DataSource_DataSourceID];

ALTER TABLE [DataSource] ALTER COLUMN [DataSourceId2] int NOT NULL;
ALTER TABLE [DataSource] ALTER COLUMN [SiteID2] tinyint NOT NULL;
ALTER TABLE [DataSource] DROP CONSTRAINT [PK_dbo.DataSource];
ALTER TABLE [DataSource] DROP COLUMN [DataSourceId];
ALTER TABLE [DataSource] DROP COLUMN [SiteID];
EXEC sp_rename 'DataSource.SiteId2', 'SiteId', 'COLUMN';
EXEC sp_rename 'DataSource.DataSourceId2', 'DataSourceId', 'COLUMN';
ALTER TABLE [DataSource] ADD CONSTRAINT [PK_DataSource] PRIMARY KEY CLUSTERED ([SiteId], [DataSourceId]);
ALTER TABLE [DataSource] ADD CONSTRAINT [FK_DataSource_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
GO
CREATE TRIGGER [DataSourceUpdateTimeTrigger] ON [DataSource]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime]) AND NOT UPDATE([LastRecording]) AND NOT UPDATE([RecordingCount])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [DataSource] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[DataSourceId] = t.[DataSourceId]
  END
END

-- FaultHandlingMethod
ALTER TABLE [Fault] DROP CONSTRAINT [FK_dbo.Fault_dbo.FaultHandlingMethod_FaultHandlingMethodID];

ALTER TABLE [FaultHandlingMethod] ALTER COLUMN [SiteId] tinyint NOT NULL;
ALTER TABLE [FaultHandlingMethod] ALTER COLUMN [FaultHandlingMethodId2] int NOT NULL;
ALTER TABLE [FaultHandlingMethod] DROP CONSTRAINT [PK_dbo.FaultHandlingMethod];
ALTER TABLE [FaultHandlingMethod] DROP COLUMN [FaultHandlingMethodId];
EXEC sp_rename 'FaultHandlingMethod.FaultHandlingMethodId2', 'FaultHandlingMethodId', 'COLUMN';
ALTER TABLE [FaultHandlingMethod] ADD CONSTRAINT [PK_FaultHandlingMethod] PRIMARY KEY CLUSTERED ([SiteId], [FaultHandlingMethodId]);
ALTER TABLE [FaultHandlingMethod] ADD CONSTRAINT [FK_FaultHandlingMethod_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
GO
CREATE TRIGGER [FaultHandlingMethodUpdateTimeTrigger] ON [FaultHandlingMethod]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [FaultHandlingMethod] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[FaultHandlingMethodId] = t.[FaultHandlingMethodId]
  END
END

-- FaultLocation
ALTER TABLE [Fault] DROP CONSTRAINT [FK_dbo.Fault_dbo.FaultLocation_FaultLocationID];

ALTER TABLE [FaultLocation] ALTER COLUMN [SiteId] tinyint NOT NULL;
ALTER TABLE [FaultLocation] ALTER COLUMN [FaultLocationId2] int NOT NULL;
ALTER TABLE [FaultLocation] DROP CONSTRAINT [PK_dbo.FaultLocation];
ALTER TABLE [FaultLocation] DROP COLUMN [FaultLocationId];
EXEC sp_rename 'FaultLocation.FaultLocationId2', 'FaultLocationId', 'COLUMN';
ALTER TABLE [FaultLocation] ADD CONSTRAINT [PK_FaultLocation] PRIMARY KEY CLUSTERED ([SiteId], [FaultLocationId]);
ALTER TABLE [FaultLocation] ADD CONSTRAINT [FK_FaultLocation_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
GO
CREATE TRIGGER [FaultLocationUpdateTimeTrigger] ON [FaultLocation]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [FaultLocation] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[FaultLocationId] = t.[FaultLocationId]
  END
END

-- FaultType
ALTER TABLE [Fault] DROP CONSTRAINT [FK_dbo.Fault_dbo.FaultType_FaultTypeID];

ALTER TABLE [FaultType] ALTER COLUMN [SiteId] tinyint NOT NULL;
ALTER TABLE [FaultType] ALTER COLUMN [FaultTypeId2] int NOT NULL;
ALTER TAblE [FaultType] DROP COnSTRAINT [PK_dbo.FaultType];
ALTER TABLE [FaultType] DROP COLUMN [FaultTypeId];
EXEC sp_rename 'FaultType.FaultTypeId2', 'FaultTypeId', 'COLUMN';
ALTER TABLE [FaultType] ADD CONSTRAINT [PK_FaultType] PRIMARY KEY CLUSTERED ([SiteId], [FaultTypeId]);
ALTER TABLE [FaultType] ADD CONSTRAINT [FK_FaultType_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
GO
CREATE TRIGGER [FaultTypeUpdateTimeTrigger] ON [FaultType]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [FaultType] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[FaultTypeId] = t.[FaultTypeId]
  END
END

-- Folder
ALTER TABLE [Machine] DROP CONSTRAINT [FK_dbo.Machine_dbo.Folder_FolderID];

ALTER TABLE [Folder] ALTER COLUMN [FolderId2] int NOT NULL;
ALTER TABLE [Folder] ALTER COLUMN [SiteID2] tinyint NOT NULL;
ALTER TABLE [Folder] DROP CONSTRAINT [PK_dbo.Folder];
ALTER TABLE [Folder] DROP COLUMN [FolderId];
ALTER TABLE [Folder] DROP COLUMN [SiteID];
EXEC sp_rename 'Folder.FolderId2', 'FolderId', 'COLUMN';
EXEC sp_rename 'Folder.SiteId2', 'SiteId', 'COLUMN';
ALTER TABLE [Folder] ADD CONSTRAINT [PK_Folder] PRImARY KEY CLUSTERED ([SiteId], [FolderId]);
ALTER TABLE [Folder] ADD CONSTRAINT [FK_Folder_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
GO
CREATE TRIGGER [FolderUpdateTimeTrigger] ON [Folder]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [Folder] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[FolderId] = t.[FolderId]
  END
END

-- MachineType
ALTER TABLE [PartType] DROP CONSTRAINT [FK_dbo.PartType_dbo.MachineType_MachineTypeID];
ALTER TABLE [MachineMetadata] DROP CONSTRAINT [FK_dbo.MachineMetadata_dbo.MachineType_MachineTypeID];

ALTER TABLE [MachineType] ALTER COLUMN [SiteID] tinyint NOT NULL;
ALTER TABLE [MachineType] ALTER COLUMN [MachineTypeId2] int NOT NULL;
ALTER TABLE [MachineType] DROP CONSTRAINT [PK_dbo.MachineType];
ALTER TABLE [MachineType] DROP COLUMN [MachineTypeId];
EXEC sp_rename 'MachineType.MachineTypeId2', 'MachineTypeId', 'COLUMN';
ALTER TABLE [MachineType] ADD CONSTRAINT [PK_MachineType] PRImARY KEY CLUSTERED ([SiteId], [MachineTypeId]);
ALTER TABLE [MachineType] ADD CONSTRAINT [FK_MachineType_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
GO
CREATE TRIGGER [MachineTypeUpdateTimeTrigger] ON [MachineType]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [MachineType] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[MachineTypeId] = t.[MachineTypeId]
  END
END

-- Machine
ALTER TABLE [ReportEntry] DROP CONSTRAINT [FK_dbo.ReportEntry_dbo.Machine_MachineID];
ALTER TABLE [RepireRecord] DROP CONSTRAINT [FK_dbo.RepaireRecord_dbo.Machine_MachineID];
ALTER TABLE [Point] DROP CONSTRAINT [FK_dbo.Point_dbo.Machine_MachineID];
ALTER TABLE [MachinePart] DROP CONSTRAINT [FK_dbo.MachinePart_dbo.Machine_MachineID];
ALTER TABLE [MachineMetadata] DROP CONSTRAINT [FK_dbo.MachineMetadata_dbo.Machine_MachineID];
ALTER TABLE [Fault] DROP CONSTRAINT [FK_dbo.Fault_dbo.Machine_MachineID];
ALTER TABLE [Sensor] DROP CONSTRAINT [FK_dbo.Sensor_dbo.Machine_MachineID];

ALTER TABLE [Machine] ALTER COLUMN [MachineId2] int NOT NULL;
ALTER TABLE [Machine] ALTER COLUMN [SiteID2] tinyint NOT NULL;
ALTER TABLE [Machine] ALTER COLUMN [FolderID2] int;
ALTER TABLE [Machine] DROP CONSTRAINT [PK_dbo.Machine];
ALTER TABLE [Machine] DROP COLUMN [MachineId];
ALTER TABLE [Machine] DROP COLUMN [SiteID];
ALTER TABLE [Machine] DROP COLUMN [FolderID];
EXEC sp_rename 'Machine.MachineId2', 'MachineId', 'COLUMN';
EXEC sp_rename 'Machine.SiteId2', 'SiteId', 'COLUMN';
EXEC sp_rename 'Machine.FolderId2', 'FolderId', 'COLUMN';
ALTER TABLE [Machine] ADD CONSTRAINT [PK_Machine] PRIMARY KEY CLUSTERED ([SiteId], [MachineId]);
ALTER TABLE [Machine] ADD CONSTRAINT [FK_Machine_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
ALTER TABLE [Machine] ADD CONSTRAINT [FK_Machine_Folder] FOREIGN KEY ([SiteId], [FolderId]) REFERENCES [Folder] ([SiteId], [FolderId]);
GO
CREATE TRIGGER [MachineUpdateTimeTrigger] ON [Machine]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [Machine] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[MachineId] = t.[MachineId]
  END
END

-- MachineMetadata
ALTER TABLE [MachineMetadata] ALTER COLUMN [MachineId2] int NOT NULL;
ALTER TABLE [MachineMetadata] ALTER COLUMN [SiteID] tinyint NOT NULL;
ALTER TABLE [MachineMetadata] ALTER COLUMN [MachineTypeId2] int NOT NULL;
ALTER TABLE [MachineMetadata] DROP CONSTRAINT [PK_dbo.MachineMetadata];
ALTER TABLE [MachineMetadata] DROP COLUMN [MachineId];
ALTER TABLE [MachineMetadata] DROP COLUMN [MachineTypeId];
EXEC sp_rename 'MachineMetadata.MachineId2', 'MachineId', 'COLUMN';
EXEC sp_rename 'MachineMetadata.MachineTypeId2', 'MachineTypeId', 'COLUMN';
ALTER TABLE [MachineMetadata] ADD CONSTRAINT [PK_MachineMetadata] PRIMARY KEY CLUSTERED ([SiteId], [MachineId]);
--ALTER TABLE [MachineMetadata] ADD CONSTRAINT [FK_MachineMetadata_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
ALTER TABLE [MachineMetadata] ADD CONSTRAINT [FK_MachineMetadata_Machine] FOREIGN KEY ([SiteID], [MachineID]) REFERENCES [Machine] ([SiteId], [MachineId]);
GO
CREATE TRIGGER [MachineMetadataUpdateTimeTrigger] ON [MachineMetadata]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [MachineMetadata] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[MachineId] = t.[MachineId]
  END
END

-- Replication
ALTER TABLE [Removed] DROP CONSTRAINT [FK_Removed_TargetID_ReplicationTarget_ReplicationTargetID];

ALTER TABLE [ReplicationLog] DROP CONSTRAINT [FK_dbo.ReplicationLog_dbo.ReplicationTarget_ReplicationTargetID];
ALTER TABLE [RecordingReplicationLog] DROP CONSTRAINT [FK_dbo.RecordingReplicationLog_dbo.ReplicationTarget_ReplicationTargetID];

ALTER TABLE [Replication] ALTER COLUMN [SiteId2] tinyint NOT NULL;
ALTER TABLE [Replication] DROP CONSTRAINT [PK_dbo.ReplicationTarget];
ALTER TABLE [Replication] DROP COLUMN [SiteID];
EXEC sp_rename 'Replication.SiteId2', 'SiteId', 'COLUMN';
ALTER TABLE [Replication] ADD CONSTRAINT [PK_Replication] PRIMARY KEY CLUSTERED ([ReplicationId]);
ALTER TABLE [Replication] ADD CONSTRAINT [FK_Replication_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
GO
CREATE TRIGGER [ReplicationUpdateTimeTrigger] ON [Replication]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [Replication] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[ReplicationId] = t.[ReplicationId]
  END
END

-- Removed
EXEC sp_rename 'Removed.TargetId', 'ReplicationId', 'COLUMN';
ALTER TABLE [Removed] DROP CONSTRAINT [PK_dbo.Removed];
ALTER TABLE [Removed] ADD CONSTRAINT [PK_Removed] PRIMARY KEY CLUSTERED ([ReplicationId], [Type], [Key]);
ALTER TABLE [Removed] ADD CONSTRAINT [FK_Removed_Replication] FOREIGN KEY ([ReplicationId]) REFERENCES [Replication] ([ReplicationId]);

-- PartType
ALTER TABLE [MachinePart] DROP CONSTRAINT [FK_dbo.MachinePart_dbo.PartType_PartTypeID];

ALTER TABLE [PartType] ALTER COLUMN [PartTypeId2] int NOT NULL;
ALTER TABLE [PartType] ALTER COLUMN [SiteID] tinyint NOT NULL;
ALTER TABLE [PartType] ALTER COLUMN [MachineTypeID2] int NOT NULL;
ALTER TABLE [PartType] DROP CONSTRAINT [PK_dbo.PartType];
ALTER TABLE [PartType] DROP COLUMN [PartTypeId];
ALTER TABLE [PartType] DROP COLUMN [MachineTypeId];
EXEC sp_rename 'PartType.PartTypeId2', 'PartTypeId', 'COLUMN';
EXEC sp_rename 'PartType.MachineTypeID2', 'MachineTypeId', 'COLUMN';
ALTER TABLE [PartType] ADD CONSTRAINT [PK_PartType] PRIMARY KEY CLUSTERED ([SiteId], [PartTypeId]);
--ALTER TABLE [PartType] ADD CONSTRAINT [FK_PartType_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
ALTER TABLE [PartType] ADD CONSTRAINT [FK_PartType_MachineType] FOREIGN KEy ([SiteId], [MachineTypeId]) REFERENCES [MachineType] ([SiteId], [MachineTypeId]);
GO
CREATE TRIGGER [PartTypeUpdateTimeTrigger] ON [PartType]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [PartType] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[PartTypeId] = t.[PartTypeId]
  END
END

-- Report
ALTER TABLE [ReportEntry] DROP CONSTRAINT [FK_dbo.ReportEntry_dbo.Report_ReportID];

ALTER TABLE [Report] ALTER COLUMN [ReportId2] int NOT NULL;
ALTER TABLE [Report] ALTER COLUMN [SiteID2] tinyint NOT NULL;
ALTER TABLE [Report] DROP CONSTRAINT [PK_dbo.Report];
ALTER TABLE [Report] DROP COLUMN [ReportID];
ALTER TABLE [Report] DROP COLUMN [SiteID];
EXEC sp_rename 'Report.ReportId2', 'ReportId', 'COLUMN';
EXEC sp_rename 'Report.SiteId2', 'SiteId', 'COLUMN';
ALTER TABLE [Report] ADD CONSTRAINT [PK_Report] PRIMARY KEY CLUSTERED ([SiteId], [ReportId]);
ALTER TABLE [Report] ADD CONSTRAINT [FK_Report_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
GO
CREATE TRIGGER [ReportUpdateTimeTrigger] ON [Report]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [Report] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[ReportId] = t.[ReportId]
  END
END

-- level 2

-- alarm
ALTER TABLE [AlarmRecord] DROP CONSTRAINT [FK_dbo.AlarmRecord_dbo.Alarm_AlarmID];

ALTER TABLE [Alarm] ALTER COLUMN [AlarmId2] int NOT NULL;
ALTER TABLE [Alarm] ALTER COLUMN [SiteID] tinyint NOT NULL;
ALTER TABLE [Alarm] ALTER COLUMN [DataSourceID2] int NOT NULL;
ALTER TABLE [Alarm] DROP CONSTRAINT [PK_dbo.Alarm];
ALTER TABLE [Alarm] DROP COLUMN [AlarmID];
ALTER TABLE [Alarm] DROP COLUMN [DataSourceID];
EXEC sp_rename 'Alarm.AlarmId2', 'AlarmId', 'COLUMN';
EXEC sp_rename 'Alarm.DataSourceID2', 'DataSourceId', 'COLUMN';
ALTER TABLE [Alarm] ADD CONSTRAINT [PK_Alarm] PRIMARY KEY CLUSTERED ([SiteId], [AlarmId]);
--ALTER TABLE [Alarm] ADD CONSTRAINT [FK_Alarm_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
ALTER TABLE [Alarm] ADD CONSTRAINT [FK_Alarm_DataSource] FOREIGN KEY ([SiteId], [DataSourceId]) REFERENCES [DataSource] ([SiteId], [DataSourceId]);
GO
CREATE TRIGGER [AlarmUpdateTimeTrigger] ON [Alarm]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [Alarm] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[AlarmId] = t.[AlarmId]
  END
END

-- Fault
ALTER TABLE [Fault] ALTER COLUMN [FaultId2] int NOT NULL;
ALTER TABLE [Fault] ALTER COLUMN [MachineId2] int NOT NULL;
ALTER TABLE [Fault] ALTER COLUMN [SiteId] tinyint NOT NULL;
ALTER TABLE [Fault] DROP CONSTRAINT [PK_dbo.Fault];
ALTER TABLE [Fault] DROP COLUMN [FaultID];
ALTER TABLE [Fault] DROP COLUMN [MachineID];
EXEC sp_rename 'Fault.FaultId2', 'FaultId', 'COLUMN';
EXEC sp_rename 'Fault.MachineId2', 'MachineId', 'COLUMN';
ALTER TABLE [Fault] ADD CONSTRAINT [PK_Fault] PRIMARY KEY CLUSTERED ([SiteId], [FaultId]);
--ALTER TABLE [Fault] ADD CONSTRAINT [FK_Fault_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
ALTER TABLE [Fault] ADD CONSTRAINT [FK_Fault_Machine] FOREIGN KEY ([SiteId], [MachineId]) REFERENCES [Machine] ([SiteId], [MachineId]);
ALTER TABLE [Fault] ADD CONSTRAINT [FK_Fault_FaulHandlingMethod] FOREIGN KEY ([SiteId], [FaultHandlingMethodId]) REFERENCES [FaultHandlingMethod] ([SiteId], [FaultHandlingMethodId]);
ALTER TABLE [Fault] ADD CONSTRAINT [FK_Fault_FaultLocation] FOREIGN KEY ([SiteId], [FaultLocationId]) REFERENCES [FaultLocation] ([SiteId], [FaultLocationId]);
ALTER TABLE [Fault] ADD CONSTRAINT [FK_Fault_FaultType] FOREIGN KEY ([SiteId], [FaultTypeId]) REFERENCES [FaultType] ([SiteId], [FaultTypeId]);
GO
CREATE TRIGGER [FaultUpdateTimeTrigger] ON [Fault]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [Fault] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[FaultId] = t.[FaultId]
  END
END

-- MachinePart
ALTER TABLE [MachinePart] ALTER COLUMN [MachinePartId2] int NOT NULL;
ALTER TABLE [MachinePart] ALTER COLUMN [MachineId2] int NOT NULL;
ALTER TABLE [MachinePart] ALTER COLUMN [SiteId] tinyint NOT NULL;
ALTER TABLE [MachinePart] DROP CONSTRAINT [PK_dbo.MachinePart];
ALTER TABLE [MachinePart] DROP COLUMN [MachinePartID];
ALTER TABLE [MachinePart] DROP COLUMN [MachineID];
ALTER TABLE [MachinePart] DROP COLUMN [PartTypeID];
EXEC sp_rename 'MachinePart.MachinePartId2', 'MachinePartId', 'COLUMN';
EXEC sp_rename 'MachinePart.MachineId2', 'MachineId', 'COLUMN';
EXEC sp_rename 'MachinePart.PartTypeId2', 'PartTypeId', 'COLUMN';
ALTER TABLE [MachinePart] ADD CONSTRAINT [PK_MachinePart] PRIMARY KEY CLUSTERED ([SiteId], [MachinePartId]);
ALTER TABLE [MachinePart] ADD CONSTRAINT [FK_MachinePart_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
ALTER TABLE [MachinePart] ADD CONSTRAINT [FK_MachinePart_PartType] FOREIGN KEY ([SiteId], [PartTypeId]) REFERENCES [PartType] ([SiteId], [PartTypeId]);
ALTER TABLE [MachinePart] ADD CONSTRAINT [FK_MachinePart_Machine] FOREIGN KEY ([SiteId], [MachineId]) REFERENCES [Machine] ([SiteId], [MachineId]);
GO
CREATE TRIGGER [MachinePartUpdateTimeTrigger] ON [MachinePart]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [MachinePart] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[MachinePartId] = t.[MachinePartId]
  END
END

-- Point
ALTER TABLE [GearInfo] DROP CONSTRAINT [FK_dbo.GearInfo_dbo.Point_PointID];
ALTER TABLE [BearingInfo] DROP CONSTRAINT [FK_dbo.BearingInfo_dbo.Point_PointID];
ALTER TABLE [Sensor] DROP CONSTRAINT [FK_dbo.Sensor_dbo.Point_PointID];

ALTER TABLE [Point] ALTER COLUMN [PointId2] int NOT NULL;
ALTER TABLE [Point] ALTER COLUMN [MachineId2] int NOT NULL;
ALTER TABLE [Point] ALTER COLUMN [SiteId] tinyint NOT NULL;
ALTER TABLE [Point] DROP CONSTRAINT [PK_dbo.Point];
ALTER TABLE [Point] DROP COLUMN [PointID];
ALTER TABLE [Point] DROP COLUMN [MachineID];
EXEC sp_rename 'Point.PointId2', 'PointId', 'COLUMN';
EXEC sp_rename 'Point.MachineId2', 'MachineId', 'COLUMN';
ALTER TABLE [Point] ADD CONSTRAINT [PK_Point] PRIMARY KEY CLUSTERED ([SiteId], [PointId]);
--ALTER TABLE [Point] ADD CONSTRAINT [FK_Point_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
ALTER TABLE [Point] ADD CONSTRAINT [FK_Point_Machine] FOREIGN KEY ([SiteId], [MachineId]) REFERENCES [Machine] ([SiteId], [MachineId]);
GO
CREATE TRIGGER [PointUpdateTimeTrigger] ON [Point]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [Point] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[PointId] = t.[PointId]
  END
END

-- RepaireRecord
ALTER TABLE [RepireRecord] ALTER COLUMN [RepireRecordId] int NOT NULL;
ALTER TABLE [RepireRecord] ALTER COLUMN [MachineID2] int NOT NULL;
ALTER TABLE [RepireRecord] ALTER COLUMN [SiteID] tinyint NOT NULL;
ALTER TABLE [RepireRecord] DROP CONSTRAINT [PK_dbo.RepaireRecord];
ALTER TABLE [RepireRecord] DROP COLUMN [RepairRecordID];
ALTER TABLE [RepireRecord] DROP COLUMN [MachineID];
EXEC sp_rename 'RepireRecord.MachineId2', 'MachineId', 'COLUMN';
ALTER TABLE [RepireRecord] ADD CONSTRAINT [PK_RepireRecord] PRIMARY KEY CLUSTERED ([SiteId], [RepireRecordId]);
ALTER TABLE [RepireRecord] ADD CONSTRAINT [FK_RepireRecord_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
ALTER TABLE [RepireRecord] ADD CONSTRAINT [FK_RepireRecord_Machine] FOREIGN KEY ([SiteId], [MachineId]) REFERENCES [Machine] ([SiteId], [MachineId]);
GO
CREATE TRIGGER [RepireRecordUpdateTimeTrigger] ON [RepireRecord]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [RepireRecord] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[RepireRecordId] = t.[RepireRecordId]
  END
END

-- ReportEntry
ALTER TABLE [ReportEntry] ALTER COLUMN [ReportEntryId2] int NOT NULL;
ALTER TABLE [ReportEntry] ALTER COLUMN [ReportId2] int NOT NULL;
ALTER TABLE [ReportEntry] ALTER COLUMN [MachineId2] int NOT NULL;
ALTER TABLE [ReportEntry] ALTER COLUMN [SiteId] tinyint NOT NULL;
ALTER TABLE [ReportEntry] DROP CONSTRAINT [PK_dbo.ReportEntry];
ALTER TABLE [ReportEntry] DROP COLUMN [ReportEntryID];
ALTER TABLE [ReportEntry] DROP COLUMN [MachineID];
ALTER TABLE [ReportEntry] DROP COLUMN [ReportID];
EXEC sp_rename 'ReportEntry.ReportEntryId2', 'ReportEntryId', 'COLUMN';
EXEC sp_rename 'ReportEntry.MachineId2', 'MachineId', 'COLUMN';
EXEC sp_rename 'ReportEntry.ReportId2', 'ReportId', 'COLUMN';
ALTER TABLE [ReportEntry] ADD CONSTRAINT [PK_ReportEntry] PRIMARY KEY CLUSTERED ([SiteId], [ReportEntryId]);
--ALTER TABLE [ReportEntry] ADD CONSTRAINT [FK_ReportEntry_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
ALTER TABLE [ReportEntry] ADD CONSTRAINT [FK_ReportEntry_Report] FOREIGN KEY ([SiteId], [ReportId]) REFERENCES [Report] ([SiteId], [ReportId]);
ALTER TABLE [ReportEntry] ADD CONSTRAINT [FK_ReportEntry_Machine] FOREIGN KEY ([SiteId], [MachineId]) REFERENCES [Machine] ([SiteId], [MachineId]);
GO
CREATE TRIGGER [ReportEntryUpdateTimeTrigger] ON [ReportEntry]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [ReportEntry] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[ReportEntryId] = t.[ReportEntryId]
  END
END

-- Sensor
ALTER TABLE [Measurement] DROP CONSTRAINT [FK_dbo.Measurement_dbo.Sensor_SensorID];

ALTER TABLE [Sensor] ALTER COLUMN [SensorId2] int NOT NULL;
ALTER TABLE [Sensor] ALTER COLUMN [PointId2] int NOT NULL;
ALTER TABLE [Sensor] ALTER COLUMN [MachineId2] int NOT NULL;
ALTER TABLE [Sensor] ALTER COLUMN [SiteId] tinyint NOT NULL;
ALTER TABLE [Sensor] DROP CONSTRAINT [PK_dbo.Sensor];
ALTER TABLE [Sensor] DROP COLUMN [SensorID];
ALTER TABLE [Sensor] DROP COLUMN [MachineID];
ALTER TABLE [Sensor] DROP COLUMN [PointID];
EXEC sp_rename 'Sensor.MachineId2', 'MachineId', 'COLUMN';
EXEC sp_rename 'Sensor.PointId2', 'PointId', 'COLUMN';
EXEC sp_rename 'Sensor.SensorId2', 'SensorId', 'COLUMN';
ALTER TABLE [Sensor] ADD CONSTRAINT [PK_Sensor] PRIMARY KEY CLUSTERED ([SiteId], [SensorId]);
--ALTER TABLE [Sensor] ADD CONSTRAINT [FK_Sensor_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
ALTER TABLE [Sensor] ADD CONSTRAINT [FK_Sensor_Machine] FOREIGN KEY ([SiteId], [MachineId]) REFERENCES [Machine] ([SiteId], [MachineId]);
ALTER TABLE [Sensor] ADD CONSTRAINT [FK_Sensor_Point] FOREIGN KEY ([SiteId], [PointId]) REFERENCES [Point] ([SiteId], [PointId]);
GO
CREATE TRIGGER [SensorUpdateTimeTrigger] ON [Sensor]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [Sensor] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[SensorId] = t.[SensorId]
  END
END

-- BearingInfo
ALTER TABLE [BearingInfo] DROP CONSTRAINT [FK_dbo.BearingInfo_dbo.Bearing_BearingID];

ALTER TABLE [BearingInfo] ALTER COLUMN [SiteId] tinyint NOT NULL;
ALTER TABLE [BearingInfo] ALTER COLUMN [PointId2] int NOT NULL;
ALTER TABLE [BearingInfo] DROP CONSTRAINT [PK_dbo.BearingInfo];
ALTER TABLE [BearingInfo] DROP COLUMN [PointID];
EXEC sp_rename 'BearingInfo.PointId2', 'PointId', 'COLUMN';
EXEC sp_rename 'BearingInfo.BearingID', 'BearingId', 'COLUMN';
ALTER TABLE [BearingInfo] ADD CONSTRAINT [PK_BearingInfo] PRIMARY KEY CLUSTERED ([SiteId], [PointId], [BearingId]);
ALTER TABLE [BearingInfo] ADD CONSTRAINT [FK_BearingInfo_Bearing] FOREIGN KEY ([BearingId]) REFERENCES [Bearing] ([BearingId]);
ALTER TABLE [BearingInfo] ADD CONSTRAINT [FK_BearingInfo_Point] FOREIGN KEY ([SiteId], [PointId]) REFERENCES [Point] ([SiteId], [PointId]);
GO
CREATE TRIGGER [BearingInfoUpdateTimeTrigger] ON [BearingInfo]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [BearingInfo] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[PointId] = t.[PointId] AND i.[BearingId] = t.[BearingId];
  END
END

-- GearInfo
ALTER TABLE [GearInfo] ALTER COLUMN [SiteId] tinyint NOT NULL;
ALTER TABLE [GearInfo] ALTER COLUMN [PointId2] int NOT NULL;
ALTER TABLE [GearInfo] ALTER COLUMN [GearInfoId2] int NOT NULL;
ALTER TABLE [GearInfo] DROP CONSTRAINT [PK_dbo.GearInfo];
ALTER TABLE [GearInfo] DROP COLUMN [GearInfoID];
ALTER TABLE [GearInfo] DROP COLUMN [PointID];
EXEC sp_rename 'GearInfo.GearInfoId2', 'GearInfoId', 'COLUMN';
EXEC sp_rename 'GearInfo.PointId2', 'PointId', 'COLUMN';
ALTER TABLE [GearInfo] ADD CONSTRAINT [PK_GearInfo] PRIMARY KEY CLUSTERED ([SiteId], [GearInfoId]);
ALTER TABLE [GearInfo] ADD CONSTRAINT [FK_GearInfo_Point] FOREIGN KEY ([SiteId], [PointId]) REFERENCES [Point] ([SiteId], [PointId]);
GO
CREATE TRIGGER [GearInfoUpdateTimeTrigger] ON [GearInfo]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [GearInfo] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[GearInfoId] = t.[GearInfoId]
  END
END

-- Measurement
ALTER TABLE [Recording] DROP CONSTRAINT [FK_dbo.Recording_dbo.Measurement_MeasurementID];
ALTER TABLE [AlarmDefinition] DROP CONSTRAINT [FK_dbo.AlarmDefinition_dbo.Measurement_MeasurementID];

ALTER TABLE [Measurement] ALTER COLUMN [DataSourceID2] int NOT NULL;
ALTER TABLE [Measurement] ALTER COLUMN [MeasurementId2] int NOT NULL;
ALTER TABLE [Measurement] ALTER COLUMN [SensorId2] int NOT NULL;
ALTER TABLE [Measurement] ALTER COLUMN [SiteId] tinyint NOT NULL;
ALTER TABLE [Measurement] DROP CONSTRAINT [PK_dbo.Measurement];
ALTER TABLE [Measurement] DROP COLUMN [MeasurementID];
ALTER TABLE [Measurement] DROP COLUMN [SensorID];
ALTER TABLE [Measurement] DROP COLUMN [DataSourceID];
EXEC sp_rename 'Measurement.SensorId2', 'SensorId', 'COLUMN';
EXEC sp_rename 'Measurement.MeasurementId2', 'MeasurementId', 'COLUMN';
EXEC sp_rename 'Measurement.DataSourceId2', 'DataSourceId', 'COLUMN';
ALTER TABLE [Measurement] ADD CONSTRAINT [PK_Measurement] PRIMARY KEY CLUSTERED ([SiteId], [MeasurementId]);
--ALTER TABLE [Measurement] ADD CONSTRAINT [FK_Measurement_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
ALTER TABLE [Measurement] ADD CONSTRAINT [FK_Measurement_DataSource] FOREIGN KEY ([SiteId], [DataSourceId]) REFERENCES [DataSource] ([SiteId], [DataSourceId]);
ALTER TABLE [Measurement] ADD CONSTRAInT [FK_Measurement_Sensor] FOREIGN KEY ([SiteId], [SensorId]) REFERENCES [Sensor] ([SiteId], [SensorId]);
GO
CREATE TRIGGER [MeasurementUpdateTimeTrigger] ON [Measurement]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [Measurement] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[MeasurementId] = t.[MeasurementId]
  END
END

-- AlarmDefinition
ALTER TABLE [AlarmThreshold] DROP CONSTRAINT [FK_dbo.AlarmThreshold_dbo.AlarmDefinition_AlarmDefinitionID];

ALTER TABLE [AlarmDefinition] ALTER COLUMN [AlarmDefinitionId2] int NOT NULL;
ALTER TABLE [AlarmDefinition] ALTER COLUMN [MeasurementID2] int NOT NULL;
ALTER TABLE [AlarmDefinition] ALTER COLUMN [SiteId] tinyint NOT NULL;
ALTER TABLE [AlarmDefinition] DROP CONSTRAINT [PK_dbo.AlarmDefinition];
ALTER TABLE [AlarmDefinition] DROP COLUMN [AlarmDefinitionID];
ALTER TABLE [AlarmDefinition] DROP COLUMN [MeasurementID];
EXEC sp_rename 'AlarmDefinition.AlarmDefinitionId2', 'AlarmDefinitionId', 'COLUMN';
EXEC sp_rename 'AlarmDefinition.MeasurementId2', 'MeasurementId', 'COLUMN';
ALTER TABLE [AlarmDefinition] ADD CONSTRAINT [PK_AlarmDefinition] PRIMARY KEY CLUSTERED ([SiteId], [AlarmDefinitionId]);
--ALTER TABLE [AlarmDefinition] ADD CONSTRAINT [FK_AlarmDefinition_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
ALTER TABLE [AlarmDefinition] ADD CONSTRAINT [FK_AlarmDefinition_Measurement] FOREIGN KEY ([SiteId], [MeasurementId]) REFERENCES [Measurement] ([SiteId], [Measurementid]);
GO
CREATE TRIGGER [AlarmDefinitionUpdateTimeTrigger] ON [AlarmDefinition]
AFTER UPDATE 
AS
BEGIN
  IF NOT UPDATE([UpdateTime])
  BEGIN
    UPDATE t
    SET t.[UpdateTime] = GETUTCDATE()
    FROM [AlarmDefinition] AS t
    JOIN inserted AS i ON i.[SiteId] = t.[SiteId] AND i.[AlarmDefinitionId] = t.[AlarmDefinitionId]
  END
END

-- Recording
ALTER TABLE [RecordingReplicationLog] DROP CONSTRAINT [FK_dbo.RecordingReplicationLog_dbo.Recording_MeasurementID_Timestamp_Type];
ALTER TABLE [AlarmRecord] DROP CONSTRAINT [FK_dbo.AlarmRecord_dbo.Recording_MeasurementID_Timestamp_Type];

ALTER TABLE [Recording] ALTER COLUMN [MeasurementId2] int NOT NULL;
ALTER TABLE [Recording] ALTER COLUMN [SiteId] tinyint NOT NULL;
ALTER TABLE [Recording] DROP CONSTRAINT [PK_dbo.Recording];
ALTER TABLE [Recording] DROP COLUMN [MeasurementID];
EXEC sp_rename 'Recording.MeasurementId2', 'MeasurementId', 'COLUMN';
ALTER TABLE [Recording] ADD CONSTRAINT [PK_Recording] PRIMARY KEY CLUSTERED ([SiteId], [MeasurementId], [Timestamp], [Type]);
--ALTER TABLE [Recording] ADD CONSTRAINT [FK_Recording_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
ALTER TABLE [Recording] ADD CONSTRAINT [FK_Recording_Measurement] FOREIGN KEY ([SiteId], [MeasurementId]) REFERENCES [Measurement] ([SiteId], [MeasurementId]);

-- AlarmThreshold
ALTER TABLE [AlarmRecord] DROP CONSTRAINT [FK_dbo.AlarmRecord_dbo.AlarmThreshold_ThresholdID];

ALTER TABLE [AlarmThreshold] ALTER COLUMN [AlarmThresholdId2] int NOT NULL;
ALTER TABLE [AlarmThreshold] ALTER COLUMN [AlarmDefinitionId2] int NOT NULL;
ALTER TABLE [AlarmThreshold] ALTER COLUMN [SiteId] tinyint NOT NULL;
ALTER TABLE [AlarmThreshold] DROP CONSTRAINT [PK_dbo.AlarmThreshold];
ALTER TABLE [AlarmThreshold] DROP COLUMN [AlarmThresholdID];
ALTER TABLE [AlarmThreshold] DROP COLUMN [AlarmDefinitionID];
EXEC sp_rename 'AlarmThreshold.AlarmThresholdId2', 'AlarmThresholdId', 'COLUMN';
EXEC sp_rename 'AlarmThreshold.AlarmDefinitionId2', 'AlarmDefinitionId', 'COLUMN';
ALTER TABLE [AlarmThreshold] ADD CONSTRAINT [PK_AlarmThreshold] PRIMARY KEY CLUSTERED ([SiteId], [AlarmThresholdId]);
--ALTER TABLE [AlarmThreshold] ADD CONSTRAINT [FK_AlarmThreshold_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
ALTER TABLE [AlarmThreshold] ADD CONSTRAINT [FK_AlarmThreshold_AlarmDefinition] FOREIGN KEY ([SiteId], [AlarmDefinitionId]) REFERENCES [AlarmDefinition] ([SiteId], [AlarmDefinitionId]);

-- AlarmRecord
ALTER TABLE [AlarmRecord] ALTER COLUMN [MeasurementId2] int NOT NULL;
ALTER TABLE [AlarmRecord] ALTER COLUMN [AlarmId2] int NOT NULL;
ALTER TABLE [AlarmRecord] ALTER COLUMN [SiteId] tinyint NOT NULL;
ALTER TABLE [AlarmRecord] ALTER COLUMN [AlarmThresholdId] int NOT NULL;
ALTER TABLE [AlarmRecord] DROP CONSTRAINT [PK_dbo.AlarmRecord];
ALTER TABLE [AlarmRecord] DROP COLUMN [AlarmRecordID];
ALTER TABLE [AlarmRecord] DROP COLUMN [MeasurementID];
ALTER TABLE [AlarmRecord] DROP COLUMN [AlarmID];
ALTER TABLE [AlarmRecord] DROP COLUMN [ThresholdID];
EXEC sp_rename 'AlarmRecord.MeasurementId2', 'MeasurementId', 'COLUMN';
EXEC sp_rename 'AlarmRecord.AlarmId2', 'AlarmId', 'COLUMN';
ALTER TABLE [AlarmRecord] ADD CONSTRAINt [PK_AlarmRecord] PRIMARY KEY CLUSTERED ([SiteId], [MeasurementId], [Timestamp], [Type], [AlarmThresholdId]);
--ALTER TABLE [AlarmRecord] ADD CONSTRAINT [FK_AlarmRecord_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);
ALTER TABLE [AlarmRecord] ADD CONSTRAINT [FK_AlarmRecord_Recording] FOREIGN KEY ([SiteId], [MeasurementId], [Timestamp], [Type]) REFERENCES [Recording] ([SiteId], [MeasurementId], [Timestamp], [Type]);
ALTER TABLE [AlarmRecord] ADD CONSTRAINT [FK_AlarmRecord_Alarm] FOREIGN KEY ([SiteId], [AlarmId]) REFERENCES [Alarm] ([SiteId], [AlarmId]);
ALTER TABLE [AlarmRecord] ADD CONSTRAINT [FK_AlarmRecord_AlarmTheshold] FOREIGN KEY ([SiteId], [AlarmThresholdId]) REFERENCES [AlarmThreshold] ([SiteId], [AlarmThresholdId]);

-- Usersite
ALTER TABLE [UserSite] ALTER COLUMN [SiteId2] tinyint NOT NULL;
ALTER TABLE [UserSite] DROP CONSTRAINt [PK_dbo.UserSite];
ALTER TABLE [UserSite] DROP COLUMN [SiteID];
EXEC sp_rename 'UserSite.SiteId2', 'SiteId', 'COLUMN';
ALTER TABLE [UserSite] ADD CONSTRAINT [PK_UserSite] PRIMARY KEY CLUSTERED ([SiteId], [UserId]);
ALTER TABLE [UserSite] ADD CONSTRAINT [FK_UserSite_Site] FOREIGN KEY ([SiteId]) REFERENCES [Site] ([SiteId]);

GO












