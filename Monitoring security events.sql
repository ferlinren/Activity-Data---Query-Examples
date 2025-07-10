SELECT 
  a.type, 
  JSON_EXTRACT_SCALAR(a.data, '$.userId') AS user_id, 
  u.email, 
  COUNT(*) AS event_count
FROM `cartodb-on-gcp-cs-team.flinares.activity_data_cs` a
JOIN `cartodb-on-gcp-cs-team.flinares.user_list` u 
  ON JSON_EXTRACT_SCALAR(a.data, '$.userId') = u.user_id
WHERE a.type IN ('UserLogins', 'TokenUpdated')
GROUP BY a.type, user_id, u.email
ORDER BY event_count DESC
LIMIT 5