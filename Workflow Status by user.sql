SELECT 
  u.email,
  SUM(CASE WHEN JSON_EXTRACT_SCALAR(a.data, '$.batchAPIResponse.status') = 'success' THEN 1 ELSE 0 END) AS successful_workflows,
  SUM(CASE WHEN JSON_EXTRACT_SCALAR(a.data, '$.batchAPIResponse.status') = 'failure' THEN 1 ELSE 0 END) AS failed_workflows
FROM `cartodb-on-gcp-cs-team.flinares.activity_data_cs` a
LEFT JOIN `cartodb-on-gcp-cs-team.flinares.user_list` u 
  ON JSON_EXTRACT_SCALAR(a.data, '$.userId') = u.user_id
WHERE a.type = 'WorkflowExecutionComplete'
GROUP BY u.email
ORDER BY successful_workflows DESC