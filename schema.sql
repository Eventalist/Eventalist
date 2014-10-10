CREATE DATABASE eventalist;


\c eventalist

CREATE TABLE events (
  id serial primary key,
  category_id integer,
  address varchar(255),
  price varchar(255),
  link text,
  title varchar(255),
  description text
  );

CREATE TABLE categories (
  id serial primary key,
  name varchar(255)
  );

CREATE TABLE subscriptions(
 id serial primary key,
 user_id integer,
 category_id integer
 );

CREATE TABLE users (
  id serial primary key,
  name varchar(255),
  email varchar(255)
);
