--part1

--1
/*
An object is any SQL server resource, such as a sql server lock or windows process. Each object 
contains one or more counters that determines various aspects of the objects to monitor.
*/

--2
/*
(1) An index is an on-desk structure associated with a table or view that speeds retrieval of rows form
the table or view. An index contains keys built from one or more columns in the table or view. These
keys are stored in a structure(B-tree) that enables SQL server to find the row or rows associated with 
the key values quickly and efficiently.
(2) advantages: 
read speed: faster select when the index columns are in where clause
disadvantages:
space: additional disk/memory space needed
write speed: slower insert/update/delete
*/

--3
/*
Clustered and non-clustered
Clustered: clustered indexes sort and store the data rows in the table or views based on their key values.
These are the columns included in the index definition. There can only be one clustered inder per table,
because the data rows themselves can be stored in only one order.
Nonclustered: nonclustered indexes have a structure seperated from the data rows. A nonclustered
index contains the nonclusted index key values and each key value entry has a pointer to the data 
row that contains the key value.
*/

--4
/*
yes.
Indexes are automatically created when PRIMARY KEY and UNIQUE constraints are defined on table column.
*/

--5
/*
No, There can only be one clustered inder per table, because the data rows themselves can be 
stored in only one order.
*/

--6
/*
Yes. And the order of columns in indexes matteres, it will affect the performance of queries.
*/

--7
/*
Yes. The first index created on a view must be a unique clusted index. After the unique index has
been created, you can create more nonclustered indexes. Creating a unique clustered index on a view
improves query performance because the view is stored in database in the same way a table with a 
clustered index is stored.
*/

--8
/*
Database normalization is a process of organizing data to minimize redundacncy, which in turn ensures
data consistency. 
-First normal form: Data each column should be atomic, no multiples values seperated by comma. The 
table does not contain any repeating column groups. Identify each record using primary key.
-Second normal form: The table must meet all the conditions of 1NF. Move redundant data to seperate
table. Create relationships between these tables using foreign key.
-Third normal form: Table must meet all the conditions of 1NF and 2NF. Does not contain columns that 
are not fully dependent on primary key.
*/

--9
/*
Denormalization is database toptimization technique in which we add redundant data to one or more
tables. This can help us avoid costly joins in a relational database.
*/

--10
/*
- Referential integrity: foreign key constraints enforces referential integrity by guraranteeing that 
changes cannot be made to data in the primary key table of those changes invalidate the link to data
in the foreign key table.
- Domain integrity: it specifies that all columns in a relational database must be declared upon a 
a defined domain. The primary unit of data in the relational data model is the data item. such data
items are said to be nondecomposable or atomic. A domian is a set of values of same data type.
Domains are therefore pools of values from which actual values appearing in the columns of a table 
are drawn.
Entity integrity: it concerns the concept of primary key. Entity integrity is an integrity rule which
states that every table must have a primary key and that the column or columns chosen to be the primary
key should be unique and not null. 
*/

--11
/*
not null, unique, primary key, foreign key, check constraint
- not null:column does not accept NULL values.
- unique: enforce the uniqueness of the values in a set of columns 
- primary key: identify the column or set of columns that have values that uniquely identify a row
in a table.
- foreign key: obtain the list of valid values from another table to determain which values are valid
- check constraints: enforce domain integrity by limiting the values that are accepted by a column 
*/

--12
/*
- primary key will not accept null values whereas unique key can accept one null value
- a table can only have one primary key, whereas there can be multiple unique keys on a table
- a clustered index automatically created when a primary key is defined, whereas unique key 
generates the non-clustered index
*/

--13
/*
A foreign key is a column or combination of columns that is used to establish and enforce a link
between the data in two tables. 
*/

--14
/*
Yes
*/

--15
/*
no, it can be null or duplicated. A Foreign key simply requires that the value in that field must
exist first in a different table. Null means that we do not yet know what the value is.
*/

--16
/*
yes. SQL temp tables support adding clustered and non-clustered indexes after the SQL Server 
temp table creation and implicitly by defining Primary key constraint or Unique Key constraint 
during the tables creation, but table variables support only adding such indexes implicitly 
by defining Primary key constraint or Unique key constraint during tables creation.
*/

--17
/*
transactions are a logical unit of work. transaction is a single recoverabl unit of work that
executes either completely or not at all.
isolation levels of transaction:
  Read Uncommitted (Lowest level)
  Read Committed
  Repeatable Read
  Serializable (Highest Level)
  Snapshot Isolation
*/

--part2

--1
Create table customer(cust_id int,  iname varchar (50)) 
create table orders(order_id int, cust_id int,amount money,order_date smalldatetime)

select c.cust_id, c.iname, sum(o.amount)
from customer c inner join orders o
on c.cust_id = o.cust_id
where o.order_date between '2002-01-01' and '2002-12-31'
group by c.cust_id, c.iname

--2
Create table person (id int, firstname varchar(100), lastname varchar(100)) 

select p.id, p.firstname, p.lastname
from person p
where p.lastname like 'A%'

--3
Create table person1 (person_id int primary key, manager_id int null, name varchar(100)not null) 

select p.person_id, p.name, count(s.person_id) as "NumberOfPeople"
from person1 p left join person1 s
on p.person_id = s.manager_id
where p.manager_id is null
group by p.person_id, p.name

--4
/*
DML triggers run when a user tries to modify data through a data manipulation language (DML) event. 
DDL triggers run in response to a variety of data definition language (DDL) events. 
Logon triggers fire in response to the LOGON event that's raised when a user's session is being established. 
*/

--5
create table Company (CompanyId int primary key identity(1,1),
CompanyName varchar(40) not null)

create table DivisionLocation (LocationId int primary key identity(1,1), City varchar(40) not null,
Country varchar(40) not null)

create table Division (DivisionId int primary key identity(1,1), DivisionName varchar(40) not null,
LocationId int foreign key references DivisionLocation(LocationId) on delete set null)

create table CompanyDivision ( CompanyId int foreign key references Company(CompanyId) on delete set null,
DivisionId int foreign key references Division(DivisionId) on delete set null)

create table Contacts (ContactId int identity(1,1) unique not null, ContactName varchar(40) not null,
Suite varchar(40) not null, MailDrop varchar(40) not null, 
CONSTRAINT PK_Contacts PRIMARY KEY (Suite, mailDrop))

create table DivisionContacts ( DivisionId int foreign key references Division(DivisionId) on delete set null,
ContactId int foreign key references Contacts(ContactId) on delete set null)

