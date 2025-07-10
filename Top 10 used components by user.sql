SELECT 
  DATE(a.ts) AS date, 
  JSON_EXTRACT_SCALAR(a.data, '$.userId') AS user_id, 
  u.email, 
  JSON_EXTRACT_SCALAR(c, '$.name') AS component_name, 
  COUNT(*) AS component_usage
FROM `cartodb-on-gcp-cs-team.flinares.activity_data_cs` a
CROSS JOIN UNNEST(JSON_EXTRACT_ARRAY(a.data, '$.components')) AS c
JOIN `cartodb-on-gcp-cs-team.flinares.user_list` u 
  ON JSON_EXTRACT_SCALAR(a.data, '$.userId') = u.user_id
WHERE a.type = 'WorkflowExecutionComplete'
GROUP BY date, user_id, u.email, component_name
ORDER BY component_usage DESC
LIMIT 10