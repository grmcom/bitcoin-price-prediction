WITH
  -- Get all transaction outputs
  all_outputs AS (
    SELECT
      o.addresses[OFFSET(0)] AS address,
      t.block_timestamp AS timestamp,
      o.value / 100000000 AS value,
      t.hash AS transaction_id
    FROM
      `bigquery-public-data.crypto_bitcoin.transactions` AS t,
      UNNEST(t.outputs) AS o
  ),
  -- Get all spent transaction outputs
  spent_outputs AS (
    SELECT
      t.block_timestamp AS spent_timestamp,
      i.spent_transaction_hash AS transaction_id,
      i.addresses[OFFSET(0)] AS address
    FROM
      `bigquery-public-data.crypto_bitcoin.transactions` AS t,
      UNNEST(t.inputs) AS i
  ),
  -- Join spent_outputs with all_outputs
  spent_transactions AS (
    SELECT
      spent_outputs.transaction_id,
      spent_outputs.address,
      spent_outputs.spent_timestamp,
      all_outputs.timestamp AS acquisition_timestamp,
      all_outputs.value
    FROM
      spent_outputs
    INNER JOIN
      all_outputs
    ON
      spent_outputs.transaction_id = all_outputs.transaction_id
      AND spent_outputs.address = all_outputs.address
    WHERE
      spent_outputs.spent_timestamp >= '2022-06-01'
      AND spent_outputs.spent_timestamp <= '2022-09-01'
  ),
  -- Get USD price per day
  daily_price AS (
    SELECT
      Date,
      Close AS avg_daily_price
    FROM
      `bitcoin-368209.btcusd.btc`
  ),
  -- Calculate SOPR
  sopro_calculation AS (
    SELECT
      spent_transactions.transaction_id,
      spent_transactions.address,
      spent_transactions.value,
      spent_transactions.spent_timestamp,
      spent_transactions.acquisition_timestamp,
      spent_daily_price.avg_daily_price AS spent_price,
      acquisition_daily_price.avg_daily_price AS acquisition_price,
      (spent_transactions.value * spent_daily_price.avg_daily_price) / (spent_transactions.value * acquisition_daily_price.avg_daily_price) AS sopro
    FROM
      spent_transactions
    JOIN
      daily_price AS spent_daily_price
    ON
      DATE(TIMESTAMP_TRUNC(spent_transactions.spent_timestamp, DAY)) = spent_daily_price.Date
    JOIN
      daily_price AS acquisition_daily_price
    ON
      DATE(TIMESTAMP_TRUNC(spent_transactions.acquisition_timestamp, DAY)) = acquisition_daily_price.Date
  )
SELECT
  TIMESTAMP_TRUNC(spent_timestamp, DAY) AS date,
  AVG(sopro) AS avg_sopro
FROM
  sopro_calculation
GROUP BY
  date
ORDER BY
  date
