SELECT ROW_NUMBER() OVER () AS id, *
  FROM (
  SELECT
    id AS searchable_id, 'CheckSearch' AS searchable_type,
    search_type,
    user_id,
    vehicle_id,
    comparing_vehicle_id,
    category_id,
    category_name,
    fitment_note_id,
    results_count,
    grouped_count,
    NULL AS max_score,
    NULL AS above_threshold_count,
    created_at, updated_at
  FROM
    check_searches
  UNION
  SELECT
    id AS searchable_id, 'CompatibilitySearch' AS searchable_type,
    search_type,
    user_id,
    vehicle_id,
    NULL AS comparing_vehicle_id,
    category_id,
    category_name,
    fitment_note_id,
    results_count,
    grouped_count,
    max_score,
    above_threshold_count,
    created_at, updated_at
  FROM
    compatibility_searches
  ORDER BY created_at ASC
) AS t
