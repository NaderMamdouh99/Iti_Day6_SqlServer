
----------11111111111----------
--Create a stored procedure to show the number of students per department.[use ITI DB] 
use iti
create proc student_number
as
begin
select d.Dept_Name, COUNT(*)as student from [newschema].[Student] s join [dbo].[Department] d
on s.Dept_Id=d.Dept_Id
group by d.Dept_Name
end

exec student_number


--------22222222222---------
--Create a stored procedure that will check for the number of employees in the project p1
--if they are more than 3 print message to the user “'The number of employees in the project p1 is 3 or more'” 
--if they are less display a message to the user “'The following employees work for the project p1'” 
--in addition to the first name and last name of each one
use MyCompany
go
create proc check_number
as
begin
declare @counting int

set @counting= (select COUNT(*) from  [dbo].[Employee] e join  [dbo].[Departments] d
on d.[Dnum]=e.[Dno] and d.[Dname]='DP1'
group by d.[Dname])
if @counting >=3
    select 'The number of employees in the project p1 is 3 or more'
else
   begin
   select 'The following employees work for the project p1'
   select Concat(e.fname,' ',e.lname) from  [dbo].[Employee] e join  [dbo].[Departments] d
     on d.[Dnum]=e.[Dno] and d.[Dname]='DP1'
   end

end

exec check_number

---------------3333333333333-----------------
--Create a stored procedure that will be used in case there is an old employee has left the project and
--a new one become instead of him. The procedure should take 3 parameters 
--(old Emp. number, new Emp. number and the project number)
--and it will be used to update works_on table

go
create proc addnew_employee @oldemp_num int,@newemp_num int,@project_num int
as 
begin
update [dbo].[Works_for]
set [Pno]=@project_num,[ESSn]=@newemp_num
where [ESSn]=@oldemp_num
end

exec addnew_employee 5464864,112233,200

-----------------444444444444-------------
--Create a trigger that prevents the insertion Process for Employee table in March 
go
alter trigger preventadd_in_march
on [dbo].[Employee] instead of insert
as
begin
	declare @Fname nvarchar(50),@Lname nvarchar(50),@ssn int,@bdate datetime,@address nvarchar(50),@sex nvarchar(50),@salary int,@sup int,@dno int
	select @Fname =[Fname],@Lname =[Lname],@ssn =[SSN],@bdate =[Bdate],@address=[Address],@sex =[Sex],@salary= [Salary],@sup =[Superssn],@dno =[Dno]
	from inserted
	if MONTH(GETDATE()) !=3
	  begin
	  insert into employee
	  values (@Fname ,@Lname,@ssn,@bdate ,@address ,@sex ,@salary,@sup,@dno)
	 end
	 else 
	 select 'you can not insert in March'
	
end

--------------555555555555555----------------------

--Create a trigger to prevent anyone from inserting a new record in the Department table
use ITI

create trigger insert_prev
on [dbo].[Department] instead of insert 
as 
begin
print 'you can not insert her'
end


insert into Department
values(8521,'fe','','',1,GETDATE())






-------66666666666---------------
--6.	Create a trigger on student table after insert to add Row in Student Audit table (Server User Name, Date, Note) 
--where note will be “[username] Insert New Row with ID=[ID Value] in table Student”
go
create trigger after_insert_student
on [newschema].[Student] after insert 
as 
begin
declare @id int

select @id=St_Id from inserted

SELECT USER_NAME() as Server_User_Name,GETDATE()as Date,concat(USER_NAME(),' Insert New Row with ID=',@id,' in table Student') as Note;
end

insert into newschema.Student
values(14,	'Said',	'NULL',	'Alex',	24,	40,	12)

---------------77777777777777-------------------
--Create a trigger on student table instead of delete to add Row in Student Audit table (Server User Name, Date, Note) 
--where note will be“[username]  try to delete Row with ID=[ID Value]”
go
create trigger instead_delete_student
on [newschema].[Student] after insert 
as 
begin
declare @id int

select @id=St_Id from deleted

SELECT USER_NAME() as Server_User_Name,GETDATE()as Date,concat(USER_NAME(),' try to delete Row with ID=',@id) as Note;
end

delete from newschema.Student
where St_Id=1
select * from deleted

-----------8888888888888-------------
use iti
begin tran print_tran
	declare @r2 int, @r1 int
	select *from [newschema].[Student] where St_Id=1
	save tran save1		
	set @r1=@@error	
	select *from [dbo].[Instructor] where [Ins_Id]=100
		save tran save2	
	set @r2=@@error			
    select *from [dbo].[Department] where[Dept_Id] ='1f'
	                                
	if @r1=0 
	    	begin
		    rollback tran print_tran
			commit tran
		end
	else if  @r2 = 0
		begin
			rollback tran save1		
			commit tran						
		end
		else 
		rollback tran save2

