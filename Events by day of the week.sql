SELECT 
  EXTRACT(DAYOFWEEK FROM a.ts) AS day_of_week,
  CASE EXTRACT(DAYOFWEEK FROM a.ts)
    WHEN 1 THEN 'Sunday'
    WHEN 2 THEN 'Monday'
    WHEN 3 THEN 'Tuesday'
    WHEN 4 THEN 'Wednesday'
    WHEN 5 THEN 'Thursday'
    WHEN 6 THEN 'Friday'
    WHEN 7 THEN 'Saturday'
  END AS day_name,
  u.email,
  COUNT(*) AS event_count
FROM `cartodb-on-gcp-cs-team.flinares.activity_data_cs` a
JOIN `cartodb-on-gcp-cs-team.flinares.user_list` u 
  ON JSON_EXTRACT_SCALAR(a.data, '$.userId') = u.user_id
WHERE a.type IN ('MapCreated', 'WorkflowExecutionComplete')
GROUP BY day_of_week, day_name, u.email
ORDER BY day_of_week, event_count DESC
