--
-- Name: bookstore, Type: SCHEMA, Schema: -, Database: postgres
--

DROP SCHEMA IF EXISTS bookstore CASCADE;

CREATE SCHEMA bookstore;

--
-- Name: author, Type: TABLE, Schema: bookstore
--

CREATE TABLE bookstore.author (
    name            varchar(50) NOT NULL,
    birthdate       date,
    country         varchar(50)
);

--
-- Name: book, Type: TABLE, Schema: bookstore
--

CREATE TABLE bookstore.book (
    title           varchar(50),
    author          varchar(50),
    date            date,
    isbn            varchar(50) NOT NULL,
    publisher       varchar(50)
);

--
-- Name: publisher, Type: TABLE, Schema: bookstore
--

CREATE TABLE bookstore.publisher (
    name            varchar(50) NOT NULL,
    streetaddress   varchar(50),
    cityzipcode     varchar(50),
    country         varchar(50)
);

--
-- Name: author, Type: TABLE_DATA, Schema: bookstore
--

INSERT INTO bookstore.author (name, birthdate, country) VALUES ('Erik Ray', '1969-04-23', 'U.S.A.');
INSERT INTO bookstore.author (name, birthdate, country) VALUES ('Jiddu Krishnamurti', '1895-05-12', 'India');
INSERT INTO bookstore.author (name, birthdate, country) VALUES ('Paul Litwin', '1960-04-04', 'U.S.A.');
INSERT INTO bookstore.author (name, birthdate, country) VALUES ('Paul McCartney', '1942-06-18', 'U.K.');
INSERT INTO bookstore.author (name, birthdate, country) VALUES ('Richard Bach', '1936-06-23', 'U.S.A.');

--
-- Name: book, Type: TABLE_DATA, Schema: bookstore
--

INSERT INTO bookstore.book (title, author, date, isbn, publisher) VALUES ('The First and Last Freedom', 'Jiddu Krishnamurti', '1954-01-10', '0-06-064831-7', 'Harper &amp; Row');
INSERT INTO bookstore.book (title, author, date, isbn, publisher) VALUES ('A Gift of Wings', 'Richard Bach', '1975-03-08', '0-33030-421-6', 'Dell Publishing Co.');
INSERT INTO bookstore.book (title, author, date, isbn, publisher) VALUES ('Jonathan Livingston Seagull: A Story', 'Richard Bach', '1970-06-17', '0-38001-286-3', 'Avon');
INSERT INTO bookstore.book (title, author, date, isbn, publisher) VALUES ('Illusions: The Adventures of a Reluctant Messiah', 'Richard Bach', '1977-07-22', '0-440-34319-4', 'Dell Publishing Co.');
INSERT INTO bookstore.book (title, author, date, isbn, publisher) VALUES ('Learning XML', 'Erik Ray', '2001-02-01', '0-59600-046-4', 'O''Reilly & Associates');
INSERT INTO bookstore.book (title, author, date, isbn, publisher) VALUES ('Access 2002 Developer''s Handbook', 'Paul Litwin', '2001-12-14', '0-78214011-4', 'Sybex');
INSERT INTO bookstore.book (title, author, date, isbn, publisher) VALUES ('The Beatles Anthology', 'Paul McCartney', '2000-10-05', '0-81182-684-8', 'Chronicle Books');
INSERT INTO bookstore.book (title, author, date, isbn, publisher) VALUES ('Wingspan: Paul McCartney''s Band on the Run', 'Paul McCartney', '2002-10-01', '0-82122-793-9', 'Bulfinch Press');
INSERT INTO bookstore.book (title, author, date, isbn, publisher) VALUES ('My Life and Times', 'Paul McCartney', '1998-01-31', '1-56592-235-2', 'McMillin Publishing');

--
-- Name: publisher, Type: TABLE_DATA, Schema: bookstore
--

INSERT INTO bookstore.publisher (name, streetaddress, cityzipcode, country) VALUES ('Avon', '10 East 53rd Street', 'New York, NY 10022', 'U.S.A.');
INSERT INTO bookstore.publisher (name, streetaddress, cityzipcode, country) VALUES ('Bulfinch Press', '1271 Avenue of the Americas', 'New York, NY 10020', 'U.S.A.');
INSERT INTO bookstore.publisher (name, streetaddress, cityzipcode, country) VALUES ('Chronicle Books', '85 Second Street', 'San Francisco 94105', 'U.S.A.');
INSERT INTO bookstore.publisher (name, streetaddress, cityzipcode, country) VALUES ('Dell Publishing Co.', '1745 Broadway, 10th Floor', 'New York, NY 10019', 'U.S.A.');
INSERT INTO bookstore.publisher (name, streetaddress, cityzipcode, country) VALUES ('Harper &amp; Row', '10 East 53rd Street', 'New York, NY 10022', 'U.S.A.');
INSERT INTO bookstore.publisher (name, streetaddress, cityzipcode, country) VALUES ('McMillin Publishing', '20 New Wharf Road', 'London, N1 9RR', 'U.K.');
INSERT INTO bookstore.publisher (name, streetaddress, cityzipcode, country) VALUES ('O''Reilly & Associates', '1005 Gravenstein Highway North', 'Sebastopol, CA 95472', 'U.S.A.');
INSERT INTO bookstore.publisher (name, streetaddress, cityzipcode, country) VALUES ('Sybex', '1-3 Canfield Place', 'London NW6 3BT', 'U.K.');

--
-- Name: author.pk_author, Type: PK_CONSTRAINT, Schema: bookstore
--

ALTER TABLE ONLY bookstore.author ADD CONSTRAINT pk_author PRIMARY KEY (name);

--
-- Name: book.pk_book, Type: PK_CONSTRAINT, Schema: bookstore
--

ALTER TABLE ONLY bookstore.book ADD CONSTRAINT pk_book PRIMARY KEY (isbn);

--
-- Name: publisher.pk_publisher, Type: PK_CONSTRAINT, Schema: bookstore
--

ALTER TABLE ONLY bookstore.publisher ADD CONSTRAINT pk_publisher PRIMARY KEY (name);

--
-- Name: book.fk_author, Type: FK_CONSTRAINT, Schema: bookstore
--

ALTER TABLE ONLY bookstore.book ADD CONSTRAINT fk_author FOREIGN KEY (author) REFERENCES bookstore.author(name);

--
-- Name: book.fk_publisher, Type: FK_CONSTRAINT, Schema: bookstore
--

ALTER TABLE ONLY bookstore.book ADD CONSTRAINT fk_publisher FOREIGN KEY (publisher) REFERENCES bookstore.publisher(name);
