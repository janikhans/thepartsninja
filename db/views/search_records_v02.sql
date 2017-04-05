SELECT ROW_NUMBER() OVER () AS id, *
  FROM (
  SELECT id as searchable_id, 'CheckSearch' as searchable_type, search_type, user_id, vehicle_id, comparing_vehicle_id, category_id, category_name, fitment_note_id, results_count, created_at, updated_at
  FROM
    check_searches
  UNION
  SELECT id as searchable_id, 'CompatibilitySearch' as searchable_type, search_type, user_id, vehicle_id, NULL as comparing_vehicle_id, category_id, category_name, fitment_note_id, results_count, created_at, updated_at
  FROM
    compatibility_searches
  ORDER BY created_at ASC
) AS t
