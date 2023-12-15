-----------------1------------------------
use ITI 
create proc NumberCountOfDetp 
as 
	begin 
		select count([St_Id]) AS 'Count Number',[Dept_Id]
		from [newschema].[Student]
		group by [Dept_Id]
	end 

exec NumberCountOfDetp
------------------2------------------
use [MyCompany]

create proc USP_CountP
as
	begin
	declare @n1 int 
		select @n1= count(*) 
		from [Hrs].[Employee] inner join [Com].[Departments]
		on [Com].[Departments].[Dnum] = [Hrs].[Employee].Dno and [Dname] = 'DP1'
		group by  [Dname]

		IF @n1>=3
		begin
		SELECT 'The number of employees in the project p1 is 3 or more'
		end
		ELSE 
		begin
		select 'The following employees work for the project p1'
		select [Fname]+ ' '+[Lname]
		from [Hrs].[Employee]
		where [Dno] = 10
		end
	end	

exec USP_CountP 

------------3------------------
go
create proc addnew_employee @oldemp_num int,@newemp_num int,@project_num int
as 
begin
update [dbo].[Works_for]
set [Pno]=@project_num,[ESSn]=@newemp_num
where [ESSn]=@oldemp_num
end

exec addnew_employee 5464864,112233,200
------------------4--------------------------
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
---------------------5---------------------
use ITI

create trigger insert_prev
on [dbo].[Department] instead of insert 
as 
begin
print 'you can not insert her'
end


insert into Department
values(8521,'fe','','',1,GETDATE())
----------------6-------------------------


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

---------------7----------------------------

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

-----------8---------------------
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


















