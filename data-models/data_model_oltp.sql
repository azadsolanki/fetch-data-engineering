-- normalized relational model ( 3NF )
CREATE TABLE users (
    user_id         VARCHAR PRIMARY KEY,
    active          BOOLEAN,
    created_date    TIMESTAMP,
    last_login      TIMESTAMP,
    role            VARCHAR,
    signup_source   VARCHAR,
    state           VARCHAR
);


CREATE TABLE receipts (
    receipt_id          VARCHAR PRIMARY KEY,
    user_id             VARCHAR REFERENCES users(user_id),
    bonus_points_earned INT,
    bonus_points_flag   BOOLEAN,
    date_scanned        TIMESTAMP,
    finished_date       TIMESTAMP,
    modified_date       TIMESTAMP,
    purchased_date      TIMESTAMP,
    points_awarded_date TIMESTAMP,
    points_earned       INT,
    purchase_location   VARCHAR,
    status              VARCHAR
);


CREATE TABLE receipt_items (
    item_id         VARCHAR PRIMARY KEY,
    receipt_id      VARCHAR REFERENCES receipts(receipt_id),
    barcode         VARCHAR,
    description     TEXT,
    item_price      FLOAT,
    needs_fetch     BOOLEAN,
    partner_item_id VARCHAR,
    prevent_target  BOOLEAN,
    quantity_purchased INT,
    user_flagged_barcode    BOOLEAN,
    user_flagged_description BOOLEAN,
    needs_fetch_review      BOOLEAN,
    brand_id        VARCHAR REFERENCES brands(brand_id)
);


CREATE TABLE brands (
    brand_id        VARCHAR PRIMARY KEY,
    barcode         VARCHAR,
    brand_code      VARCHAR,
    category        VARCHAR,
    category_code   VARCHAR,
    name            VARCHAR,
    top_brand       BOOLEAN
);
