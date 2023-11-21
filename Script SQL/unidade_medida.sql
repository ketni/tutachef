CREATE TABLE unidade_medida (
  objectId VARCHAR,
  createdAt TIMESTAMP,
  updatedAt TIMESTAMP,
  ACL JSON,
  medida VARCHAR NOT NULL
);
CREATE INDEX _id_ on unidade_medida(objectId);