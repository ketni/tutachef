CREATE TABLE categories (
  objectId VARCHAR,
  createdAt TIMESTAMP,
  updatedAt TIMESTAMP,
  ACL JSON,
  categorie VARCHAR NOT NULL
);
CREATE INDEX _id_ on categories(objectId);