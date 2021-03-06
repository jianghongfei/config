/****** Script for SelectTopNRows command from SSMS  ******/
SELECT '{ "id": ' + CAST(ROW_NUMBER() OVER (order by r.[PublishDate]) AS nvarchar(4)) + ', "siteId": ' + cast(s.[Id] as nvarchar(5)) + ', "site": "' + s.[Name] + '", "machineId": ' + cast(m.[id] as nvarchar(5)) + ', "machine": "' + m.[Name] + '", "publish": "'
      + CONVERT(VARCHAR(33), r.[PublishDate], 126) + '", "state": ' + CONVERT(VARCHAR(2), e.[AlarmStatus]) + ' },'
      -- + ', "description": ' + 
      --case
      --  when e.[ShortDescription] IS NULL THEN 'null },'
      --  else '"' + REPLACE(REPLACE(e.ShortDescription, CHAR(13), ''), CHAR(10), '') + '" },'
      --end
FROM [ReportEntry] e
JOIN [Machine] m ON m.[MachineID] = e.[MachineID]
JOIN [Site] s on s.[SiteID] = m.[SiteID]
JOIN [Report] r ON r.[ReportID] = e.[ReportID]
ORDER BY s.[id], m.[id], r.[PublishDate]


