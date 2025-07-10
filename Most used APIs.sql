SELECT 
  a.metric, 
  SUM(a.amount * COALESCE(a.quota_usage_weight, 0)) AS total_quota_consumed
FROM `cartodb-on-gcp-cs-team.flinares.api_usage` a
WHERE a.quota_usage_weight IS NOT NULL
GROUP BY a.metric
ORDER BY total_quota_consumed DESC
LIMIT 5