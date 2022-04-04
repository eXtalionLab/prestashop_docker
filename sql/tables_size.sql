
SELECT
    table_name AS 'Table Name',
    (data_length + index_length) AS 'Size in Bytes',
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS 'Size in MiB'
FROM information_schema.tables
WHERE table_schema = 'prestashop'
GROUP BY table_name
ORDER BY (data_length + index_length) DESC
