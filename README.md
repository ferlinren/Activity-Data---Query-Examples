# CARTO Activity Data Analysis

## Repository Purpose

This repository stores SQL queries to analyze CARTO activity data in BigQuery (`cartodb-on-gcp-cs-team.flinares`). This table can be accessed by everyone inside of our org. The goal is to extract metrics on platform usage —such as workflows, maps, and API calls— to identify patterns, troubleshoot issues, and optimize resources. The queries join activity data with user information and parse JSON fields to produce user-friendly reports.

---

## Data Structure

The queries use the following BigQuery tables:

### `activity_data_cs`
- **Description**: Logs all platform events (e.g., workflow executions, map creations).
- **Columns**:
  - `ts`: Timestamp of the event (UTC).
  - `type`: Event type (e.g., `WorkflowExecutionComplete`, `MapCreated`).
  - `data`: JSON with event details (e.g., `userId`, `batchAPIResponse.status`, `workflowId`).

### `api_usage`
- **Description**: Daily aggregation of API usage by user, API, and component for quota tracking.
- **Columns**:
  - `ts`: Timestamp of usage (daily, UTC).
  - `user_id`: User who triggered the API call (or `public` for unauthenticated users).
  - `metric`: API + method + client combination.
  - `amount`: Number of API requests.
  - `quota_usage_weight`: Weight for quota calculations.

### `user_list`
- **Description**: Maps user IDs to emails and roles.
- **Columns**:
  - `user_id`: Unique identifier (e.g., `auth0|xxx`, `google-oauth|xxx`).
  - `email`: User’s email.
  - `created_at`: User creation timestamp.
  - `role`: User role (`Admin`, `Editor`, `Viewer`).
  - `group_ids`: Array of group IDs the user belongs to.

### `group_list`
- **Description**: Maps group IDs to group names.
- **Columns**:
  - `group_id`: Unique group identifier.
  - `group_alias`: User-facing group name.

---

## Understanding the Queries

The 10 queries in this repository analyze events from `activity_data_cs`, often joining with `user_list` to show emails instead of `user_id`. They use `JSON_EXTRACT_SCALAR` to extract data from the JSON `data` field in `activity_data_cs`.

### Using `JSON_EXTRACT_SCALAR`

The `data` column in `activity_data_cs` is a JSON string containing event-specific details. `JSON_EXTRACT_SCALAR` extracts a single value (string or number) from a specified path.

- **Syntax**:
  ```sql
  JSON_EXTRACT_SCALAR(data, '$.path.to.field')
  ```

- **Example JSON**:
  ```json
  {
    "userId": "auth0|671aab24d818d241c729431a",
    "batchAPIResponse": {"status": "success"},
    "workflowId": "adaa925a-76ad-4ffa-8a9f-81f2937c5e6d"
  }
  ```

- **Example SQL usage**:
  ```sql
  JSON_EXTRACT_SCALAR(data, '$.userId')                  -- "auth0|671aab24d818d241c729431a"
  JSON_EXTRACT_SCALAR(data, '$.batchAPIResponse.status') -- "success"
  ```

---

## Query Structure

Most queries follow this general structure:

1. **Filter**  
   Use `WHERE` to select events by type (e.g., `WorkflowExecutionComplete`, `MapCreated`) or other conditions.

2. **Join**  
   Use `LEFT JOIN` with `user_list` to map `userId` from `data` to `email`.

3. **JSON Extraction**  
   Use `JSON_EXTRACT_SCALAR` to access fields like `userId`, `status`, or `workflowId`.

4. **Aggregation**  
   Use `COUNT`, `SUM`, or `GROUP BY` to summarize metrics (e.g., number of events per user).

5. **Sort**  
   Use `ORDER BY` to sort results (e.g., by count descending).

### Generic Query Example

```sql
SELECT 
  u.email,
  COUNT(*) AS event_count
FROM `cartodb-on-gcp-cs-team.flinares.activity_data_cs` a
LEFT JOIN `cartodb-on-gcp-cs-team.flinares.user_list` u 
  ON JSON_EXTRACT_SCALAR(a.data, '$.userId') = u.user_id
WHERE a.type = 'some_event_type'
GROUP BY u.email
ORDER BY event_count DESC
```

---

## How to Use the Queries

1. **Run in BigQuery**  
   Copy the query into the BigQuery SQL editor and run it.

2. **Customize**  
   Adjust the event type or JSON paths based on the specific analysis needed (refer to CARTO Documentation for available event types and structure).

3. **Interpret the Results**  
   Output tables will include user emails and metrics (counts, statuses, etc.) to support reporting or deeper investigation.

---

## Notes

- The structure of the `data` field varies depending on the event type. Always check the CARTO event documentation for field availability (e.g., `$.workflowId`, `$.batchAPIResponse.error`).
- `LEFT JOIN` ensures events are included even if there's no match in `user_list` (email will be `NULL` in such cases).
- Use `api_usage` for quota-related metrics and `group_list` to break down data by user groups.

