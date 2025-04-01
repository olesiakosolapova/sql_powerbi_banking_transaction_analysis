-- DATA CLEANING SCRIPT FOR TRANSACTIONS TABLE
-- ==========================================

-- STEP 1: Check for missing values in critical columns
SELECT * FROM transactions WHERE "TransactionID" IS NULL;
SELECT * FROM transactions WHERE "TransactionAmount" IS NULL;
SELECT * FROM transactions WHERE "TransactionDate" IS NULL;

-- STEP 2: Remove rows with NULL values in essential fields
DELETE FROM transactions WHERE "TransactionID" IS NULL OR "TransactionAmount" IS NULL OR "TransactionDate" IS NULL;

-- STEP 3: Standardize data formats
UPDATE transactions SET "TransactionAmount" = ROUND("TransactionAmount", 2);
UPDATE transactions SET "AccountBalance" = ROUND("AccountBalance", 2);

-- STEP 4: Remove duplicate transactions
DELETE FROM transactions
WHERE ctid IN (
    SELECT ctid FROM (
        SELECT ctid, ROW_NUMBER() OVER (
            PARTITION BY "TransactionID", "TransactionAmount", "TransactionDate", "MerchantID"
            ORDER BY "TransactionDate" DESC
        ) AS row_num FROM transactions
    ) t WHERE row_num > 1
);

-- STEP 5: Validate numerical values
SELECT * FROM transactions WHERE "TransactionAmount" < 0;
SELECT * FROM transactions WHERE "CustomerAge" < 18 OR "CustomerAge" > 100;

-- STEP 6: Trim unnecessary whitespace from text fields
UPDATE transactions SET "TransactionType" = TRIM("TransactionType");
UPDATE transactions SET "Location" = TRIM("Location");
UPDATE transactions SET "CustomerOccupation" = TRIM("CustomerOccupation");

-- STEP 7: Retrieve unique values from TransactionType, Channel, and CustomerOccupation to check for inconsistencies  
SELECT DISTINCT "TransactionType" FROM transactions;  
SELECT DISTINCT "Channel" FROM transactions;  
SELECT DISTINCT "CustomerOccupation" FROM transactions; 

-- STEP 8: Verify changes
SELECT * FROM transactions;




