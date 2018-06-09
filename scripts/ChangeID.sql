-- 1. Site Name
UPDATE [Site] set [Name] = 'xxx'
UPDATE [Site] SET [ShortName] = 'xxx'

-- 2. Machine Name
update [machine] set [name] =  'Y' + SUBSTRING([name], 2, 3) from [machine]
update [Machine] set [ShortName] = [Name]
update [Machine] set [Metadata] = null

-- 3. measurement
DELETE FROM [AlarmRecord];

ALTER TABLE [Recording] NOCHECK CONSTRAINT ALL;
  DECLARE @measurementId uniqueidentifier;

  DECLARE measurement_cursor CURSOR FOR   
  SELECT [MeasurementID] FROM [Measurement]  
  
  OPEN measurement_cursor  
  FETCH NEXT FROM measurement_cursor INTO @measurementId  
  
  WHILE @@FETCH_STATUS = 0  
  BEGIN
    DECLARE @newId uniqueidentifier = NEWID();
    UPDATE [Recording] SET [MeasurementID] = @newId WHERE [MeasurementID] = @measurementId;
    UPDATE [Measurement] SET [MeasurementID] = @newId WHERE [MeasurementID] = @measurementId;

    FETCH NEXT FROM measurement_cursor INTO @measurementId  
  END
  CLOSE measurement_cursor
  DEALLOCATE measurement_cursor
ALTER TABLE [Recording] WITH CHECK CHECK CONSTRAINT ALL

-- 4. sensor
ALTER TABLE [Measurement] NOCHECK CONSTRAINT ALL;
  DECLARE @sensorId uniqueidentifier;

  DECLARE sensor_cursor CURSOR FOR   
  SELECT [SensorId] FROM [Sensor]  
  
  OPEN sensor_cursor  
  FETCH NEXT FROM sensor_cursor INTO @sensorId  
  
  WHILE @@FETCH_STATUS = 0  
  BEGIN
    DECLARE @newId uniqueidentifier = NEWID();
    UPDATE [Measurement] SET [SensorID] = @newId WHERE [SensorID] = @sensorId;
    UPDATE [Sensor] SET [SensorID] = @newId WHERE [SensorID] = @sensorId;

    FETCH NEXT FROM sensor_cursor INTO @sensorId  
  END
  CLOSE sensor_cursor
  DEALLOCATE sensor_cursor
ALTER TABLE [Measurement] WITH CHECK CHECK CONSTRAINT ALL

-- 5. machine
ALTER TABLE [Sensor] NOCHECK CONSTRAINT ALL;
ALTER TABLE [Point] NOCHECK CONSTRAINT ALL;
  DECLARE @machineId uniqueidentifier;

  DECLARE machine_cursor CURSOR FOR   
  SELECT [MachineID] FROM [Machine]  
  
  OPEN machine_cursor  
  FETCH NEXT FROM machine_cursor INTO @machineId  
  
  WHILE @@FETCH_STATUS = 0  
  BEGIN
    DECLARE @newId uniqueidentifier = NEWID();
    UPDATE [Sensor] SET [MachineID] = @newId WHERE [MachineID] = @machineId;
    UPDATE [Point] SET [MachineID] = @newId WHERE [MachineID] = @machineId;
    UPDATE [Machine] SET [MachineID] = @newId WHERE [MachineID] = @machineId;

    FETCH NEXT FROM machine_cursor INTO @machineId  
  END
  CLOSE machine_cursor
  DEALLOCATE machine_cursor
ALTER TABLE [Sensor] WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE [Point] WITH CHECK CHECK CONSTRAINT ALL


-- 6. site
DECLARE @SiteID uniqueidentifier = NEWID()

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
--UPDATE [Alarm] SET [SiteID] = @SiteID
--UPDATE [AlarmDefinition] SET [SiteID] = @SiteID
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

UPDATE [Option] SET [Value] = @SiteID WHERE [OptionID] = 'OPTION_SITE_ID';
PRINT 'Change folders at binary base manully'