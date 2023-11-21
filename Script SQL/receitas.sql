CREATE TABLE receitas (
  objectId VARCHAR,
  createdAt TIMESTAMP,
  updatedAt TIMESTAMP,
  ACL JSON,
  title_receita VARCHAR NOT NULL,
  sugestao_chef VARCHAR,
  user RELATION(_User),
  categorie RELATION(categories),
  ingredients RELATION(ingredients)
);
CREATE INDEX _id_ on receitas(objectId);