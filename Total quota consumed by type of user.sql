SELECT 
  CASE WHEN a.user_id = 'public' THEN 'Public' ELSE 'Authenticated' END AS user_type,
  SUM(a.amount * COALESCE(a.quota_usage_weight, 0)) AS total_quota_consumed
FROM `cartodb-on-gcp-cs-team.flinares.api_usage` a
WHERE a.quota_usage_weight IS NOT NULL
GROUP BY user_type
ORDER BY total_quota_consumed DESC