CREATE TABLE ingredients (
  objectId VARCHAR,
  createdAt TIMESTAMP,
  updatedAt TIMESTAMP,
  ACL JSON,
  ingrediente VARCHAR NOT NULL
);
CREATE INDEX _id_ on ingredients(objectId);