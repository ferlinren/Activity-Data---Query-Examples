SELECT 
  DATE(a.ts) AS date, 
  JSON_EXTRACT_SCALAR(a.data, '$.userId') AS user_id, 
  u.email, 
  COUNT(*) AS created_maps
FROM `cartodb-on-gcp-cs-team.flinares.activity_data_cs` a
JOIN `cartodb-on-gcp-cs-team.flinares.user_list` u 
  ON JSON_EXTRACT_SCALAR(a.data, '$.userId') = u.user_id
WHERE a.type = 'MapCreated'
GROUP BY date, user_id, u.email
ORDER BY date, created_maps DESC
LIMIT 100