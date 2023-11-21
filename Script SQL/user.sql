CREATE TABLE _User (
  objectId VARCHAR,
  createdAt TIMESTAMP,
  updatedAt TIMESTAMP,
  ACL JSON,
  username VARCHAR,
  password VARCHAR,
  email VARCHAR,
  emailVerified BOOLEAN,
  authData JSON
);
CREATE INDEX _id_ on _User(objectId);
CREATE INDEX username_1 on _User(username);
CREATE INDEX case_insensitive_username on _User(username);
CREATE INDEX email_1 on _User(email);
CREATE INDEX case_insensitive_email on _User(email);