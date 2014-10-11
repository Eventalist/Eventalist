CREATE DATABASE eventalist;

\c eventalist

CREATE TABLE events (
  id serial primary key,
  category_id integer,
  date varchar(255),
  title varchar(255),
  description text,
  venue varchar(255),
  venue_website varchar(255),
  address varchar(255),
  latitude varchar(255),
  longitude varchar(255),
  price varchar(255),
  link text,
  created_at timestamp
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
