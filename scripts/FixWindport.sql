UPDATE r
SET [SiteID] = v.[SiteID]
FROM [Report] r
JOIN (
  SELECT [ReportID], [SiteID]
  FROM [ReportEntry] e
  JOIN [Machine] m ON m.[MachineID] = e.[MachineID]
) v ON v.[ReportID] = r.[ReportID]