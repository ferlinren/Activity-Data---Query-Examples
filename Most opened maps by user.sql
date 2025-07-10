SELECT 
  JSON_EXTRACT_SCALAR(a.data, '$.mapId') AS map_id,
  u.email,
  COUNT(*) AS map_opens
FROM `cartodb-on-gcp-cs-team.flinares.activity_data_cs` a
JOIN `cartodb-on-gcp-cs-team.flinares.user_list` u 
  ON JSON_EXTRACT_SCALAR(a.data, '$.userId') = u.user_id
WHERE a.type = 'OpenBuilderMap'
GROUP BY map_id, u.email
ORDER BY map_opens DESC
LIMIT 20

--not available for now for public maps
--usage per unique MapID is not possible