-- OBJECT: metadata.address
-- ISSUE: postal_code DROP NOT NULL


ALTER TABLE IF EXISTS metadata.address
    ALTER COLUMN postal_code DROP NOT NULL;
