-- 1. 创建全新的MDataPort数据库temp，并配置成HQ，设置好inarybase和Web Port。注意：temp数据库的collation必须和老数据库的保持一致
-- 2. 用MDataPort数据管理工具，将新数据导入temp数据库
-- 3. 执行下列脚本，在temp数据库中创建Recording2表
USE [temp]
GO
CREATE TABLE [dbo].[Recording2](
  [MeasurementID] [uniqueidentifier] NOT NULL,
  [Timestamp] [datetime2](7) NOT NULL,
  [Type] [tinyint] NOT NULL,
  [MeasurementType] [nvarchar](50) NULL,
  [AlarmCalculated] [bit] NOT NULL,
  [Hash] [nvarchar](256) NULL,
  [AlarmStatus] [tinyint] NOT NULL,
  [BiasVoltage] [real] NOT NULL,
  [Overall] [real] NOT NULL,
  [RPM] [real] NOT NULL,
  [Offset] [real] NOT NULL,
  [Delta] [real] NOT NULL,
  [XUnit] [nvarchar](50) NULL,
  [YUnit] [nvarchar](50) NULL,
  [Count] [int] NOT NULL,
  [YValue] [real] NOT NULL,
  [Metadata] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
-- NOTE： 该表无主键，但是有一个unique索引，在该索引上，忽略duplication
CREATE UNIQUE CLUSTERED INDEX [IX_Recording2] ON [dbo].[Recording2]
(
  [MeasurementID] ASC,
  [Timestamp] ASC,
  [Type] ASC
)WITH (IGNORE_DUP_KEY = ON) ON [PRIMARY]
GO

-- 4. 执行下列脚本，将旧数据库中的recording，按照Measurement name，sensor name，machine name和temp数据库中的Measurement/Sensor/Machine对应起来，并保存到temp数据库的Recording2表
use master;
GO

INSERT INTO [temp].[dbo].[Recording2]
  ([Timestamp]
  ,[MeasurementId]
  ,[Type]
  ,[AlarmStatus]
  ,[BiasVoltage]
  ,[Hash]
  ,[MeasurementType]
  ,[Overall]
  ,[RPM]
  ,[Delta]
  ,[Offset]
  ,[XUnit]
  ,[Count]
  ,[YValue]
  ,[YUnit]
  ,[AlarmCalculated]
  ,[Metadata])
SELECT r.[Timestamp]
      ,t.[MeasurementID]
      ,r.[Type]
      ,r.[AlarmStatus]
      ,r.[BiasVoltage]
      ,r.[Hash]
      ,r.[MeasurementType]
      ,r.[Overall]
      ,r.[RPM]
      ,r.[Delta]
      ,r.[Offset]
      ,r.[XUnit]
      ,r.[Count]
      ,r.[YValue]
      ,r.[YUnit]
      ,r.[AlarmCalculated]
      ,r.[Metadata]
FROM [MDataPort].[dbo].[Recording] r
LEFT JOIN (
  SELECT meas.[MeasurementID], meas.[Name] AS [Measurement], s.[Name] AS [Sensor], m.[Name] AS [Machine]
  FROM [MDataPort].dbo.[Measurement] meas
  LEFT JOIN [MDataPort].[dbo].Sensor s ON s.[SensorID] = meas.[SensorID]
  LEFT JOIN [MDataPort].[dbo].Machine m ON m.[MachineID] = s.[MachineID]
) s ON s.[MeasurementID] = r.[MeasurementID]
LEFT JOIN (
  SELECT meas.[MeasurementID], meas.[Name] AS [Measurement], s.[Name] AS [Sensor], m.[Name] AS [Machine]
  FROM [Temp].dbo.[Measurement] meas
  LEFT JOIN [Temp].[dbo].Sensor s ON s.[SensorID] = meas.[SensorID]
  LEFT JOIN [Temp].[dbo].Machine m ON m.[MachineID] = s.[MachineID]
) t ON t.[Measurement] = s.[Measurement] AND t.[Sensor] = s.[Sensor] AND t.[Machine] = s.[Machine]

-- 5. 执行下列脚本，将的Recording也导入到Recording2表中。
use [temp];
GO

INSERT INTO [Recording2]
      ([Timestamp]
      ,[MeasurementId]
      ,[Type]
      ,[AlarmStatus]
      ,[BiasVoltage]
      ,[Hash]
      ,[MeasurementType]
      ,[Overall]
      ,[RPM]
      ,[Delta]
      ,[Offset]
      ,[XUnit]
      ,[Count]
      ,[YValue]
      ,[YUnit]
      ,[AlarmCalculated]
      ,[Metadata])
SELECT [Timestamp]
      ,[MeasurementId]
      ,[Type]
      ,[AlarmStatus]
      ,[BiasVoltage]
      ,[Hash]
      ,[MeasurementType]
      ,[Overall]
      ,[RPM]
      ,[Delta]
      ,[Offset]
      ,[XUnit]
      ,[Count]
      ,[YValue]
      ,[YUnit]
      ,[AlarmCalculated]
      ,[Metadata]
  FROM [Recording]

-- 6. 如有必要，可执行下列语句，清空temp中，已经导入的recording
use [temp];
GO

DELETE FROM [Recording];

-- 7. 用下列脚本，将temp中recording2的数据，迁移到recording表中
use [temp];
GO

INSERT INTO [Recording]
      ([Timestamp]
      ,[MeasurementId]
      ,[Type]
      ,[AlarmStatus]
      ,[BiasVoltage]
      ,[Hash]
      ,[MeasurementType]
      ,[Overall]
      ,[RPM]
      ,[Delta]
      ,[Offset]
      ,[XUnit]
      ,[Count]
      ,[YValue]
      ,[YUnit]
      ,[AlarmCalculated]
      ,[Metadata])
SELECT [Timestamp]
      ,[MeasurementId]
      ,[Type]
      ,[AlarmStatus]
      ,[BiasVoltage]
      ,[Hash]
      ,[MeasurementType]
      ,[Overall]
      ,[RPM]
      ,[Delta]
      ,[Offset]
      ,[XUnit]
      ,[Count]
      ,[YValue]
      ,[YUnit]
      ,[AlarmCalculated]
      ,[Metadata]
  FROM [Recording2]

-- 8. 为什么要用Recording2作为中间的缓冲呢？
-- 貌似INSERT INTO SELECT语句，在跨数据库的情况下，不能很好的处理duplication，如果直接插入到recording表，会因为recording表上的主键，而导致插入失败。而recording2表上的忽略重复主键，能很好的解决这个问题。第四部中，因为是在同一个数据库里面，就不会因为recording表上的主键而失败了。
