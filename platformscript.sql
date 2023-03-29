create table if not exists users (
	  user_id integer primary key auto_increment,
    fullname varchar(128) not null,
    country varchar(128) not null,
    created_at datetime default current_timestamp,
    is_blocked bool default false
);
INSERT INTO users(fullname, country)
VALUE
	  ('Andrey Popovics', 'USA'),
    ('Milana Popovics', 'Germany'),
    ('Dilen Popovics', 'France'),
    ('Olga Popovics', 'France')
    ;
    create table if not exists streams(
	  stream_id integer primary key auto_increment,
    user_id integer,
    title varchar(256) not null,
    created_at datetime default current_timestamp,
    is_completed bool default false,
    FOREIGN KEY (user_id) REFERENCES users(user_id) -- добавить привязку к users
);
insert into streams (user_id, title)
values
(1, 'Sream from USA'),
(2, 'Sream from Germany'),
(3, 'Sream from France')
;
create table if not exists reactions (
	reaction_id integer primary key auto_increment,
	user_id integer, -- автор реакции
	stream_id integer, -- на какой стрим реакция
	created_at datetime default current_timestamp,
	value integer check(value between 1 and 5), -- значение реакции
  FOREIGN KEY (user_id) REFERENCES users(user_id), -- проверка на сущ. ПОЛЬЗОВАТЕЛЯ
	FOREIGN KEY (stream_id) REFERENCES streams(stream_id) -- проверка сущ. СТРИМА
);
insert into reactions (user_id, stream_id, value)
values
(3, 2, 5),
(1, 2, 4),
(2, 3, 5)
;

create table if not exists donations (
	donation_id integer primary key auto_increment,
	created_at datetime default current_timestamp,
	donator_id integer,
	stream_id integer,
	amount decimal(10, 2) check (amount > 0),
	FOREIGN KEY (donator_id) REFERENCES users(user_id), -- проверка на сущ. ПОЛЬЗОВАТЕЛЯ
	FOREIGN KEY (stream_id) REFERENCES streams(stream_id) -- проверка сущ. СТРИМА
);
insert into donations (donation_id, stream_id, amount)
values
(1, 1, 15),
(2, 2, 23),
(3, 3, 10)
;


SELECT *
FROM donations
ORDER BY amount DESC -- три самых большых пожертвований
LIMIT 3;

SELECT
		amount AS amount_eur,
    amount*1.05 AS amount_usd -- Вывести размеры пожертвований в долларах и евро
FROM donations;

SELECT 
		users.fullname AS donator_fullname,
    donations.amount AS amount_eur,
    donations.amount*1.05 AS amount_usd  -- Вывести размеры пожертвований в долларах и евро, а также имя того, кто его сделал
FROM donations
JOIN users ON donations.donator_id=users.user_id;

SELECT 
		users.fullname AS donator_fullname,
    donations.amount AS amount_eur,
    donations.amount*1.05 AS amount_usd, -- Вывести данные о пожертвованиях
    streams.title AS stream_title
FROM donations
JOIN users ON donations.donator_id=users.user_id
JOIN streams ON donations.stream_id=streams.stream_id;

SELECT 
	streams.title AS stream_title,
    users.fullname AS streamer_fullname  -- Вывести информацию о стримах
FROM streams
JOIN users ON streams.user_id=users.user_id;

SELECT
		donations.amount,
    users.fullname AS donator_fullname,
    streams.title AS stream_title -- Вывести пожертвования  имя_донатора  размер_пожертвования название_стрима
FROM donations
JOIN users ON donations.donator_id=users.user_id
JOIN streams ON donations.stream_id=streams.stream_id;

SELECT 
		reactions.value,
    users.fullname AS user_fullname,
    streams.title AS stream_title  -- Вывести реакции со значением 4 и 5  кто_поставил_оценку  оценка название_стрима
FROM reactions
JOIN users ON reactions.user_id=users.user_id
JOIN streams ON reactions.stream_id=streams.stream_id
WHERE reactions.value IN (4, 5);

ALTER TABLE users -- добавление поля в таблицу
ADD email varchar(64);

ALTER TABLE users  -- удаление поля в таблице
DROP COLUMN email;

ALTER TABLE users
RENAME COLUMN email TO e_mail;

SELECT * from users  -- Вывести пользователей, у которых не указан email-адрес
WHERE e_mail is null;

SELECT * from users
WHERE country = 'Germany' -- Вывести незаблокированных пользователей из Германии
and is_blocked = false;

SELECT *
from streams
join users on streams.user_id=users.user_id  -- Вывести стримы, авторы которых заблокированы
where is_blocked = true;

SELECT *
from reactions
join users on reactions.user_id=users.user_id  -- Вывести три последних реакции (включая имя_пользователя)
join streams on reactions.stream_id=streams.stream_id
limit 3;

SELECT * from donations
join users on donations.donator_id=users.user_id  -- Вывести пожертвования заблокированных пользователей
where is_blocked = true;









