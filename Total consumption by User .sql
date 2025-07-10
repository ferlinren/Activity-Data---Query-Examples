SELECT 
  u.email, 
  SUM(a.amount * a.quota_usage_weight) AS final_usage_quota_consumed
FROM `cartodb-on-gcp-cs-team.flinares.api_usage` a
JOIN `cartodb-on-gcp-cs-team.flinares.user_list` u 
  ON a.user_id = u.user_id
GROUP BY u.email
ORDER BY final_usage_quota_consumed DESC
LIMIT 5