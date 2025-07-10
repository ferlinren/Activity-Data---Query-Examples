SELECT 
  
  JSON_EXTRACT_SCALAR(a.data, '$.userId') AS user_id, 
  u.email, 
  COUNT(*) AS invalidation_count
FROM `cartodb-on-gcp-cs-team.flinares.activity_data_cs` a
JOIN `cartodb-on-gcp-cs-team.flinares.user_list` u 
  ON JSON_EXTRACT_SCALAR(a.data, '$.userId') = u.user_id
WHERE a.type = 'MapInstantiationInvalidated'
GROUP BY user_id, u.email
ORDER BY invalidation_count DESC
LIMIT 5