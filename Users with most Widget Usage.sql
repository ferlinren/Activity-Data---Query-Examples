SELECT 
  u.email, 
  SUM(a.amount) AS widget_requests,
  SUM(a.amount * COALESCE(a.quota_usage_weight, 0)) AS quota_consumed
FROM `cartodb-on-gcp-cs-team.flinares.api_usage` a
JOIN `cartodb-on-gcp-cs-team.flinares.user_list` u 
  ON a.user_id = u.user_id
WHERE a.metric = 'widgets_api_req_builder'
GROUP BY u.email
ORDER BY quota_consumed DESC
LIMIT 5