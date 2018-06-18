-- *************create scripts*****************--
-- customer table 
create table customer (
customer_id varchar(50) PRIMARY KEY,
event_time datetime NOT NULL,
last_name varchar(50),
adr_city varchar(50),
adr_state varchar(50)
);

-- page table
create table pages(
page_id varchar(50) PRIMARY KEY,
contents varchar(100)
);

-- site table
-- assumption:- tags are specific to visit rather than pages.
create table site_visit (
visit_id INT IDENTITY(1,1) PRIMARY KEY,
page_id varchar(50), -- key value from json file
event_time datetime NOT NULL,
customer_id varchar(50) NOT NULL,
FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
FOREIGN KEY (page_id) REFERENCES pages(page_id),
);

-- tags table to store tags relatde to each page
create table tags(
tag_id INT IDENTITY(1,1) PRIMARY KEY,
tag_key varchar(50),
tag_value varchar(50)
);


--tags and pages reference table
create table tags_reference_tab(
ref_id INT IDENTITY(1,1) PRIMARY KEY,
visit_id INT,
tag_id INT,
FOREIGN KEY (visit_id) REFERENCES site_visit(visit_id),
FOREIGN KEY (tag_id) REFERENCES tags(tag_id)
);

--image table
create table image(
image_id varchar(50) PRIMARY KEY,
event_time datetime NOT NULL,
customer_id varchar(50) NOT NULL,
camera_make varchar(50),
camera_model varchar(50),
FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- order table
create table order_tbl(
order_id varchar(50) PRIMARY KEY,
event_time datetime NOT NULL,
customer_id varchar(50) NOT NULL,
total_amount float,
FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);


--****************insert scripts*************************--

-- for customer table
insert into customer values ('96f55c7d8f42','2017-01-06T12:46:46.384Z','Smith','Middletown','AK');
insert into customer values ('96f55c7d8f43','2017-01-05T12:46:46.384Z','Stephen','Colbert','NY');
insert into customer values ('96f55c7d8f44','2017-02-06T12:46:46.384Z','Jimmy','Kimmel','LA');
insert into customer values ('96f55c7d8f45','2017-01-12T12:46:46.384Z','James','Corden','LA');
insert into customer values ('96f55c7d8f46','2017-01-30T12:46:46.384Z','Ellen','Degeneres','LA');

-- for page table
insert into pages values ('ac05e815502f','content for ac05e815502f pages');
insert into pages values ('ac05e815502g','content for ac05e815502g pages');

-- for  site_visit table
insert into site_visit values ('ac05e815502f','2017-01-06T12:45:52.041Z','96f55c7d8f42');
insert into site_visit values ('ac05e815502f','2017-08-06T12:45:52.041Z','96f55c7d8f42');
insert into site_visit values ('ac05e815502f','2017-02-06T12:45:52.041Z','96f55c7d8f42');
insert into site_visit values ('ac05e815502g','2017-01-06T12:45:52.041Z','96f55c7d8f43');

-- for tags table
insert into tags values ('action','load');
insert into tags values ('activity','read');

-- for tags_reference_tab table
insert into tags_reference_tab values ('1','1');
insert into tags_reference_tab values ('1','2');

--for image table
insert into image values ('d8ede43b1d9f','2017-01-06T12:47:12.344Z','96f55c7d8f42','Canon','EOS 80D');
insert into image values ('d8ede43b1d9g','2017-01-06T12:47:12.344Z','96f55c7d8f42','Canon','EOS 80D');

-- for order table
insert into order_tbl values ('68d84e5d1a43','2017-01-06T12:55:55.555Z','96f55c7d8f42',12.34);
insert into order_tbl values ('68d84e5d1a44','2017-01-12T12:55:55.555Z','96f55c7d8f42',34.12);
insert into order_tbl values ('68d84e5d1a45','2017-01-01T12:55:55.555Z','96f55c7d8f42',12.34);
insert into order_tbl values ('68d84e5d1a46','2017-01-06T12:55:55.555Z','96f55c7d8f43',30.00);