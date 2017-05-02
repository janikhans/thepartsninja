SELECT ROW_NUMBER() OVER () AS id, categories.id AS category_id, fitment_notes.id AS fitment_note_id
FROM categories
INNER JOIN products ON products.category_id = categories.id
INNER JOIN parts ON parts.product_id = products.id
INNER JOIN fitments ON fitments.part_id = parts.id
INNER JOIN fitment_notations ON fitment_notations.fitment_id = fitments.id
INNER JOIN fitment_notes ON fitment_notes.id = fitment_notations.fitment_note_id
WHERE fitment_notes.used_for_search IS TRUE
GROUP BY fitment_notes.id, categories.id
