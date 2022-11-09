--DROP TABLE items, purchases, users
CREATE TABLE users(
  userId serial PRIMARY KEY,
  age integer NOT NULL CHECK (age > 0)
);

CREATE TABLE items(
  itemId serial PRIMARY KEY,
  price double precision  NOT NULL CHECK (price > 0)
);

CREATE TABLE purchases(
  purchaseId serial PRIMARY KEY,
  userId integer NOT NULL REFERENCES Users (userId),
  itemId integer NOT NULL REFERENCES Items (itemId),
  purchase_date date NOT NULL
);