 --CONSULTAS EQUIPO 2

--DICCIONARIO DE FRAGMENTACION
		CREATE TABLE diccionario_dist (
		  id_dic tinyint primary key, -- identificador 
		  servidor varchar(30), -- nombre del servidor vinculado
		  bd varchar(30), -- nombre de la base
		  esquema varchar(30), -- nombre del esquema
		  ntabla varchar(30) -- nombre de la tabla 
		)
		insert into diccionario_dist values (1,'[LINKSERVER1]','Adventure','Production','Product');
		insert into diccionario_dist values (2,'[LINKSERVER2]','AdventureSales','Sales','SalesOrderDetail');
		insert into diccionario_dist values (3,'[LINKSERVER2]','AdventureSales','Sales','SalesTerritory');
		insert into diccionario_dist values (4,'[LINKSERVER2]','AdventureSales','Sales','SalesOrderHeader');
		select * from diccionario_dist; 
		go;

--INDICES OPTIMIZACION DE CONSULTAS
--FRAGMENTO 1
create NONCLUSTERED INDEX inc_Product_ProductID   
    ON Production.Product (ProductID) 
	include (Name , ProductNumber, ListPrice, Color, SafetyStockLevel,StandardCost,DaysToManufacture);   
GO  
--FRAGMENTO 2
create NONCLUSTERED INDEX inc_Sales_SalesOrderDetail 
ON Sales.SalesOrderDetail (SalesOrderID) include (ProductID,OrderQty, UnitPrice);   

create NONCLUSTERED INDEX inc_Sales_SalesOrderHeader
ON Sales.SalesOrderHeader(SalesOrderID) include (TerritoryID,DueDate,TaxAmt);   

create NONCLUSTERED INDEX inc_Sales_Territory 
ON Sales.SalesTerritory (TerritoryID) include (Name,rowguid);   

create NONCLUSTERED INDEX inc_Sales_Descuenyo 
ON Sales.SalesOrderDetail (SalesOrderDetailID) include 
(UnitPriceDiscount,SpecialOfferID, ModifiedDate); 

--1.Listar los productos más vendidos con un precio menor o igual a 100 y que el color sea amarillo.

		select pp.ProductID, pp.Name,pp.ProductNumber, pp.ListPrice, 
		count(ss.ProductID) as veces_vendido
		from Adventure.Production.Product pp
		inner join SQLS2.AdventureSales.Sales.SalesOrderDetail ss
		on pp.ProductID = ss.ProductID
		where pp.ListPrice <=100 and pp.Color = 'Yellow'
		group by ss.ProductID, pp.Name, pp.ProductID,pp.ProductNumber, pp.ListPrice
		order by count(ss.ProductID) desc;

		--select * from SQL.Test.dbo.Table_1;

		create procedure consulta_p as

			begin

			  declare @servidor nvarchar(100);
			  declare @nom_bd nvarchar(100);
			  declare @nom_tabla nvarchar(100);
			  declare @esquema nvarchar(100);
			  declare @servidor2 nvarchar(100);
			  declare @nom_bd2 nvarchar(100);
			  declare @nom_tabla2 nvarchar(100);
			  declare @esquema2 nvarchar(100);
			  declare @sql nvarchar(1000);
			  declare @id int;


			 set @id = 1;

 					  select @nom_bd = bd, @nom_tabla = ntabla, @esquema= esquema
					  from dbo.diccionario_dist
					  where id_dic = @id

			set @id= 2;
 
  					  select @servidor2 = servidor, @nom_bd2 = bd, @nom_tabla2 = ntabla, @esquema2= esquema
					  from diccionario_dist
					  where id_dic = @id

			set @sql='select pp.ProductID, pp.Name,pp.ProductNumber, pp.ListPrice,
			count(ss.ProductID) as veces_vendido
			from '+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' pp
			inner join '+@servidor2+'.'+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' ss
			on pp.ProductID = ss.ProductID
			where pp.ListPrice <=100 and pp.Color = ''Yellow''
			group by ss.ProductID, pp.Name, pp.ProductID,pp.ProductNumber, pp.ListPrice
			order by count(ss.ProductID) desc';

			exec (@sql);

			end
			exec consulta_p;
			go;



			--Productos mas vendidos con un precio menor o igual a 100
				select pp.ProductID, pp.Name,pp.ProductNumber, pp.ListPrice,
				count(ss.ProductID) as veces_vendido
				from SQLS2.Adventure.Production.Product pp
				inner join Sales.SalesOrderDetail ss
				on pp.ProductID = ss.ProductID
				where pp.ListPrice <=100 and pp.Color = 'Yellow'
				group by ss.ProductID, pp.Name, pp.ProductID,pp.ProductNumber, pp.ListPrice
				order by count(ss.ProductID) desc;

				--select * from SQL.Test.dbo.Table_1;

				go
				alter procedure consulta_p   as

				begin

				  declare @servidor nvarchar(100);
				  declare @nom_bd nvarchar(100);
				  declare @nom_tabla nvarchar(100);
				  declare @esquema nvarchar(100);
				  declare @servidor2 nvarchar(100);
				  declare @nom_bd2 nvarchar(100);
				  declare @nom_tabla2 nvarchar(100);
				  declare @esquema2 nvarchar(100);
				  declare @sql nvarchar(1000);
				  declare @id int;


				 set @id = 1;

 						  select @servidor = servidor, @nom_bd = bd, @nom_tabla = ntabla, @esquema= esquema
						  from diccionario_dist
						  where id_dic = @id

				set @id= 2;
 
  						  select @servidor2 = servidor, @nom_bd2 = bd, @nom_tabla2 = ntabla, @esquema2= esquema
						  from diccionario_dist
						  where id_dic = @id

						 if (@servidor2='local')

							set @sql='select pp.ProductID, pp.Name, pp.ListPrice,
							count(ss.ProductID) as veces_vendido
							from '+@servidor+'.'+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' pp
							inner join '+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' ss
							on pp.ProductID = ss.ProductID
							where pp.ListPrice <=100 and pp.Color = ''Yellow''
							group by ss.ProductID, pp.Name, pp.ProductID, pp.ListPrice
							order by count(ss.ProductID) desc';

						 else 
		 					set @sql='select pp.ProductID, pp.Name, pp.ListPrice,
							count(ss.ProductID) as veces_vendido
							from '+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' pp
							inner join '+@servidor2+'.'+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' ss
							on pp.ProductID = ss.ProductID
							where pp.ListPrice <=100 and pp.Color = ''Yellow''
							group by ss.ProductID, pp.Name, pp.ProductID, pp.ListPrice
							order by count(ss.ProductID) desc';


					exec(@sql) ;
		

				end

				exec consulta_p;
				go;

--2.Listar los productos más vendidos con un precio mayor o igual a 600 y un nivel de cuidado del stock igual a 500.

			select pp.ProductID, pp.Name, count(ss.ProductID) as veces_vendido
			from Production.Product pp
			inner join [SQL].AdventureSales.Sales.SalesOrderDetail ss
			on pp.ProductID = ss.ProductID
			where pp.ListPrice >= 600 and pp.SafetyStockLevel = 500
			group by ss.ProductID, pp.Name, pp.ProductID
			order by count(ss.ProductID) desc;

go
alter procedure Productos_Vendidos as

begin
	
  declare @servidor nvarchar(100);
  declare @nom_bd nvarchar(100);
  declare @nom_tabla nvarchar(100);
  declare @esquema nvarchar(100);
   declare @servidor2 nvarchar(100);
  declare @nom_bd2 nvarchar(100);
  declare @nom_tabla2 nvarchar(100);
  declare @esquema2 nvarchar(100);
  declare @sql nvarchar(1000);
  declare @id int;


 set @id = 1;

 		  select @servidor = servidor,@nom_bd = bd, @nom_tabla = ntabla, @esquema= esquema
		  from diccionario_dist
		  where id_dic = @id

set @id= 2;
 
  		  select @servidor2 = servidor, @nom_bd2 = bd, @nom_tabla2 = ntabla, @esquema2= esquema
		  from diccionario_dist
		  where id_dic = @id


		  if(@servidor2='local')
		  set @sql = 'select pp.ProductID, pp.Name, count(ss.ProductID) as veces_vendido
						from '+@servidor+'.'+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' pp
						inner join '+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' ss
						on pp.ProductID = ss.ProductID
						where pp.ListPrice >= 600 and pp.SafetyStockLevel = 500
						group by ss.ProductID, pp.Name, pp.ProductID
						order by count(ss.ProductID) desc';

		  else
		  set @sql = 'select pp.ProductID, pp.Name, count(ss.ProductID) as veces_vendido
						from '+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' pp
						inner join '+@servidor2+'.'+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' ss
						on pp.ProductID = ss.ProductID
						where pp.ListPrice >= 600 and pp.SafetyStockLevel = 500
						group by ss.ProductID, pp.Name, pp.ProductID
						order by count(ss.ProductID) desc';

exec(@sql);
end
exec Productos_Vendidos;
			go;

--3.Listar los productos más vendidos con un precio estándar menor o igual a 250 y el dia de manufactura sea igual a 1.

			select pp.ProductID, pp.Name, count(ss.ProductID) as veces_vendido
			from Production.Product pp
			inner join SQLS2.AdventureSales.Sales.SalesOrderDetail ss
			on pp.ProductID = ss.ProductID
			where pp.StandardCost <= 250 and pp.DaysToManufacture = 1 
			group by ss.ProductID, pp.Name, pp.ProductID
			order by count(ss.ProductID) asc;

create procedure Productos_Vendidos2 as
begin
	declare @servidor nvarchar(100);
  declare @nom_bd nvarchar(100);
  declare @nom_tabla nvarchar(100);
  declare @esquema nvarchar(100);
   declare @servidor2 nvarchar(100);
  declare @nom_bd2 nvarchar(100);
  declare @nom_tabla2 nvarchar(100);
  declare @esquema2 nvarchar(100);
  declare @sql nvarchar(1000);
  declare @id int;


 set @id = 1;

 		  select @servidor = servidor, @nom_bd = bd, @nom_tabla = ntabla, @esquema= esquema
		  from diccionario_dist
		  where id_dic = @id;

set @id= 2;
 
  		  select @servidor2 = servidor, @nom_bd2 = bd, @nom_tabla2 = ntabla, @esquema2= esquema
		  from diccionario_dist
		  where id_dic = @id;

		  if(@servidor2='local')

		  set @sql = 'select pp.ProductID, pp.Name, count(ss.ProductID) as veces_vendido
						from '+@servidor+'.'+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' pp
						inner join '+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' ss
						on pp.ProductID = ss.ProductID
						where pp.StandardCost <= 250 and pp.DaysToManufacture = 1 
						group by ss.ProductID, pp.Name, pp.ProductID
						order by count(ss.ProductID) asc';

		  else
		  set @sql = 'select pp.ProductID, pp.Name, count(ss.ProductID) as veces_vendido
						from '+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' pp
						inner join '+@servidor2+'.'+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' ss
						on pp.ProductID = ss.ProductID
						where pp.StandardCost <= 250 and pp.DaysToManufacture = 1 
						group by ss.ProductID, pp.Name, pp.ProductID
						order by count(ss.ProductID) asc';



exec(@sql);

end
			go;
--4.Determinar el total vendido de las ventas en el territorio 3 

			select st.Name, sum(so.OrderQty * so.UnitPrice) as total_vendido
			from SQLS2.AdventureSales.Sales.SalesOrderHeader sh
			inner join SQLS2.AdventureSales.Sales.SalesOrderDetail so
			on sh.SalesOrderID = so.SalesOrderID
			inner join SQLS2.AdventureSales.Sales.SalesTerritory st
			on st.TerritoryID = sh.TerritoryID
			where st.TerritoryID = 3
			group by st.TerritoryID, st.Name;

create procedure ventas_territorio @territorio varchar(10) as
begin
	declare @servidor nvarchar(100);
  declare @nom_bd nvarchar(100);
  declare @nom_tabla nvarchar(100);
  declare @esquema nvarchar(100);
   declare @servidor2 nvarchar(100);
  declare @nom_bd2 nvarchar(100);
  declare @nom_tabla2 nvarchar(100);
  declare @esquema2 nvarchar(100);
  declare @servidor3 nvarchar(100);
  declare @nom_bd3 nvarchar(100);
  declare @nom_tabla3 nvarchar(100);
  declare @esquema3 nvarchar(100);
  declare @sql nvarchar(1000);
  declare @id int;

set @id= 2;
 
  		  select @servidor = servidor, @nom_bd = bd, @nom_tabla = ntabla, @esquema= esquema
		  from diccionario_dist
		  where id_dic = @id
set @id= 3;
 
  		  select @servidor2 = servidor, @nom_bd2 = bd, @nom_tabla2 = ntabla, @esquema2= esquema
		  from diccionario_dist
		  where id_dic = @id
set @id= 4;
 
  		  select @servidor3 = servidor, @nom_bd3 = bd, @nom_tabla3 = ntabla, @esquema3= esquema
		  from diccionario_dist
		  where id_dic = @id

		  if(@servidor = 'local')

			set @sql= 'select st.Name, sum(so.OrderQty * so.UnitPrice) as total_vendido
						from '+@nom_bd3+'.'+@esquema3+'.'+@nom_tabla3+' sh
						inner join '+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' so
						on sh.SalesOrderID = so.SalesOrderID
						inner join '+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' st
						on st.TerritoryID = sh.TerritoryID where st.TerritoryID ='+@territorio+'
						group by st.TerritoryID, st.Name';
		 else
		    set @sql= 'select st.Name, sum(so.OrderQty * so.UnitPrice) as total_vendido
						from '+@servidor3+'.'+@nom_bd3+'.'+@esquema3+'.'+@nom_tabla3+' sh
						inner join '+@servidor+'.'+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' so
						on sh.SalesOrderID = so.SalesOrderID
						inner join '+@servidor2+'.'+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' st
						on st.TerritoryID = sh.TerritoryID where st.TerritoryID ='+@territorio+'
						group by st.TerritoryID, st.Name';
			

exec (@sql);

  end

			  exec ventas_territorio @territorio = '1'
			  exec ventas_territorio @territorio = '2'
			  exec ventas_territorio @territorio = '3'
			  exec ventas_territorio @territorio = '4'
			  exec ventas_territorio @territorio = '5'
			  exec ventas_territorio @territorio = '6'
			  exec ventas_territorio @territorio = '7'
			go;
		
--5.Determinar el número  de ventas donde el total de la compra sea mayor a 0 y menor a 1000
--6.Determinar el número  de ventas donde el total de la compra sea mayor a 1000 y menor a 2000
--7.Determinar el número  de ventas donde el total de la compra sea mayor a 2000 

				select sh.SalesOrderID,  pp.Name,sum(so.OrderQty * so.UnitPrice) as total_vendido into #T1
				from SQLS2.AdventureSales.Sales.SalesOrderHeader sh
				inner join SQLS2.AdventureSales.Sales.SalesOrderDetail so
				on sh.SalesOrderID = so.SalesOrderID
				inner join Production.Product pp
				on pp.ProductID = so.ProductID
				group by sh.SalesOrderID, pp.Name
				order by sum(so.OrderQty * so.UnitPrice) asc;

					select * from #T1
					where total_vendido <1000;

				    select * from #T1
				    where total_vendido >1000 and total_vendido <2000;

				select * from #T1
				where total_vendido >1000 and total_vendido >=2000;

				alter procedure consulta_d1   @tipo int as

				begin

				  declare @servidor nvarchar(100);
				  declare @nom_bd nvarchar(100);
				  declare @nom_tabla nvarchar(100);
				  declare @esquema nvarchar(100);
				   declare @servidor2 nvarchar(100);
				  declare @nom_bd2 nvarchar(100);
				  declare @nom_tabla2 nvarchar(100);
				  declare @esquema2 nvarchar(100);
				  declare @servidor3 nvarchar(100);
				  declare @nom_bd3 nvarchar(100);
				  declare @nom_tabla3 nvarchar(100);
				  declare @esquema3 nvarchar(100);
				  declare @sql nvarchar(1000);
				  declare @sql2 nvarchar(1000);
				  declare @id int;

				 --  create table #T1(id int ,Nombre varchar(100),total_vendido float)
				 set @id = 1;

 						  select @servidor = servidor, @nom_bd = bd, @nom_tabla = ntabla, @esquema= esquema
						  from diccionario_dist
						  where id_dic = @id

				set @id= 2;
 
  						  select @servidor2 = servidor, @nom_bd2 = bd, @nom_tabla2 = ntabla, @esquema2= esquema
						  from diccionario_dist
						  where id_dic = @id

				set @id= 4;
 
  						  select @servidor3 = servidor, @nom_bd3 = bd, @nom_tabla3 = ntabla, @esquema3= esquema
						  from diccionario_dist
						  where id_dic = @id

						 if (@servidor2='local')
			set @sql='insert into #T1 select sh.SalesOrderID,  pp.Name,sum(so.OrderQty * so.UnitPrice) as total_vendido 
						from '+@nom_bd3+'.'+@esquema3+'.'+@nom_tabla3+' sh
						inner join '+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' so
						on sh.SalesOrderID = so.SalesOrderID
						inner join '+@servidor+'.'+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' pp
						on pp.ProductID = so.ProductID
						group by sh.SalesOrderID, pp.Name
						order by sum(so.OrderQty * so.UnitPrice) asc;';

		 else 
			set @sql='insert into #T1 select sh.SalesOrderID,  pp.Name,sum(so.OrderQty * so.UnitPrice) as total_vendido 
						from '+@servidor3+'.'+@nom_bd3+'.'+@esquema3+'.'+@nom_tabla3+' sh
						inner join '+@servidor2+'.'+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' so
						on sh.SalesOrderID = so.SalesOrderID
						inner join '+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' pp
						on pp.ProductID = so.ProductID
						group by sh.SalesOrderID, pp.Name
						order by sum(so.OrderQty * so.UnitPrice) asc;';


					exec(@sql) ;

					if(@tipo=1)
					select Nombre,count(total_vendido) as Cantidad from #T1
					where total_vendido <1000
					group by Nombre;
					else if(@tipo=2)
					select  Nombre, count(total_vendido) as Cantidad from #T1
					where total_vendido >1000 and total_vendido <2000
					group by Nombre;
					else if(@tipo=3)
					select  Nombre,count(total_vendido) as Cantidad from #T1
					where total_vendido >1000 and total_vendido >=2000
					group by Nombre;
	
				end
				  --Determinar el numero  de ventas donde el total de la compra sea mayor a 0 y menor a 1000
				  exec consulta_d1 @tipo=1;
				  --Determinar el numero  de ventas donde el total de la compra sea mayor a 1000 y menor a 2000
				  exec consulta_d1 @tipo=2;
				  --Determinar el numero  de ventas donde el total de la compra sea mayor a 2000 
				  exec consulta_d1 @tipo=3;

				  go;


--8.Determinar las ventas donde los impuestos aplicados sean mayor o igual a los 500 y el territorio sea el 3

				select sh.SalesOrderID,  pp.Name,sh.TaxAmt 
				from SQLS2.AdventureSales.Sales.SalesOrderHeader sh
				inner join SQLS2.AdventureSales.Sales.SalesOrderDetail so
				on sh.SalesOrderID = so.SalesOrderID
				inner join Production.Product pp
				on pp.ProductID = so.ProductID
				inner join SQLS2.AdventureSales.Sales.SalesTerritory st
				on st.TerritoryID = sh.TerritoryID
				where TaxAmt >=500 and st.TerritoryID = 3
				group by sh.SalesOrderID, pp.Name,TaxAmt

				--order by sum(so.OrderQty * so.UnitPrice) asc;
				
				alter procedure consulta_d2 as

				begin

				  declare @servidor nvarchar(100);
				  declare @nom_bd nvarchar(100);
				  declare @nom_tabla nvarchar(100);
				  declare @esquema nvarchar(100);
				   declare @servidor2 nvarchar(100);
				  declare @nom_bd2 nvarchar(100);
				  declare @nom_tabla2 nvarchar(100);
				  declare @esquema2 nvarchar(100);
				  declare @servidor3 nvarchar(100);
				  declare @nom_bd3 nvarchar(100);
				  declare @nom_tabla3 nvarchar(100);
				  declare @esquema3 nvarchar(100);
					declare @servidor4 nvarchar(100);
				  declare @nom_bd4 nvarchar(100);
				  declare @nom_tabla4 nvarchar(100);
				  declare @esquema4 nvarchar(100);
				  declare @sql nvarchar(1000);
				  declare @id int;


				 set @id = 1;

 						  select @servidor = servidor, @nom_bd = bd, @nom_tabla = ntabla, @esquema= esquema
						  from diccionario_dist
						  where id_dic = @id

				set @id= 2;
 
  						  select @servidor2 = servidor, @nom_bd2 = bd, @nom_tabla2 = ntabla, @esquema2= esquema
						  from diccionario_dist
						  where id_dic = @id

				set @id= 3;
 
  						  select @servidor3 = servidor, @nom_bd3 = bd, @nom_tabla3 = ntabla, @esquema3= esquema
						  from diccionario_dist
						  where id_dic = @id

				set @id= 4;
 
  						  select @servidor4 = servidor, @nom_bd4 = bd, @nom_tabla4 = ntabla, @esquema4= esquema
						  from diccionario_dist
						  where id_dic = @id

						 if (@servidor2='local')
							set @sql='select sh.SalesOrderID,st.TerritoryID,  pp.Name,sh.TaxAmt 
										from '+@nom_bd4+'.'+@esquema4+'.'+@nom_tabla4+' sh
										inner join '+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' so
										on sh.SalesOrderID = so.SalesOrderID
										inner join '+@servidor+'.'+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' pp
										on pp.ProductID = so.ProductID
										inner join '+@nom_bd3+'.'+@esquema3+'.'+@nom_tabla3+'  st
										on st.TerritoryID = sh.TerritoryID
										where TaxAmt >=500 and st.TerritoryID = 3
										group by sh.SalesOrderID,st.TerritoryID, pp.Name,TaxAmt';

						 else 
							set @sql='select sh.SalesOrderID,st.TerritoryID,  pp.Name,sh.TaxAmt 
										from '+@servidor4+'.'+@nom_bd4+'.'+@esquema4+'.'+@nom_tabla4+' sh
										inner join '+@servidor2+'.'+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' so
										on sh.SalesOrderID = so.SalesOrderID
										inner join '+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' pp
										on pp.ProductID = so.ProductID
										inner join '+@servidor3+'.'+@nom_bd3+'.'+@esquema3+'.'+@nom_tabla3+'  st
										on st.TerritoryID = sh.TerritoryID
										where TaxAmt >=500 and st.TerritoryID = 3
										group by sh.SalesOrderID,st.TerritoryID, pp.Name,TaxAmt';


					exec(@sql) ;

				end
				exec consulta_d2;
				go;

--9.Listar las ordenes del territorio 9 con fecha de modificacion del 2011-06-30 00:00:00.000

		select sh.SalesOrderID,st.TerritoryID,  pp.Name,sh.DueDate 
				from AdventureSales.Sales.SalesOrderHeader sh
				inner join AdventureSales.Sales.SalesOrderDetail so
				on sh.SalesOrderID = so.SalesOrderID
				inner join SQL.Adventure.Production.Product pp
				on pp.ProductID = so.ProductID
				inner join AdventureSales.Sales.SalesTerritory st
				on st.TerritoryID = sh.TerritoryID
				where DueDate ='2011-06-30 00:00:00.000' and st.TerritoryID = 9;


				create procedure consulta_d3 as

				begin

				  declare @servidor nvarchar(100);
				  declare @nom_bd nvarchar(100);
				  declare @nom_tabla nvarchar(100);
				  declare @esquema nvarchar(100);
				   declare @servidor2 nvarchar(100);
				  declare @nom_bd2 nvarchar(100);
				  declare @nom_tabla2 nvarchar(100);
				  declare @esquema2 nvarchar(100);
				  declare @servidor3 nvarchar(100);
				  declare @nom_bd3 nvarchar(100);
				  declare @nom_tabla3 nvarchar(100);
				  declare @esquema3 nvarchar(100);
					declare @servidor4 nvarchar(100);
				  declare @nom_bd4 nvarchar(100);
				  declare @nom_tabla4 nvarchar(100);
				  declare @esquema4 nvarchar(100);
				  declare @sql nvarchar(1000);
				  declare @id int;


				 set @id = 1;

 						  select @servidor = servidor, @nom_bd = bd, @nom_tabla = ntabla, @esquema= esquema
						  from diccionario_dist
						  where id_dic = @id

				set @id= 2;
 
  						  select @servidor2 = servidor, @nom_bd2 = bd, @nom_tabla2 = ntabla, @esquema2= esquema
						  from diccionario_dist
						  where id_dic = @id

				set @id= 3;
 
  						  select @servidor3 = servidor, @nom_bd3 = bd, @nom_tabla3 = ntabla, @esquema3= esquema
						  from diccionario_dist
						  where id_dic = @id

				set @id= 4;
 
  						  select @servidor4 = servidor, @nom_bd4 = bd, @nom_tabla4 = ntabla, @esquema4= esquema
						  from diccionario_dist
						  where id_dic = @id

						 if (@servidor2='local')
							set @sql='select sh.SalesOrderID,st.TerritoryID,  pp.Name,sh.DueDate 
										from '+@nom_bd4+'.'+@esquema4+'.'+@nom_tabla4+' sh
										inner join '+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' so
										on sh.SalesOrderID = so.SalesOrderID
										inner join '+@servidor+'.'+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' pp
										on pp.ProductID = so.ProductID
										inner join '+@nom_bd3+'.'+@esquema3+'.'+@nom_tabla3+'  st
										on st.TerritoryID = sh.TerritoryID
										where DueDate =''2011-06-30 00:00:00.000'' and st.TerritoryID = 9';


						 else 
							set @sql='select sh.SalesOrderID,st.TerritoryID,  pp.Name,sh.DueDate 
										from '+@servidor4+'.'+@nom_bd4+'.'+@esquema4+'.'+@nom_tabla4+' sh
										inner join '+@servidor2+'.'+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' so
										on sh.SalesOrderID = so.SalesOrderID
										inner join '+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' pp
										on pp.ProductID = so.ProductID
										inner join '+@servidor3+'.'+@nom_bd3+'.'+@esquema3+'.'+@nom_tabla3+'  st
										on st.TerritoryID = sh.TerritoryID
										where DueDate =''2011-06-30 00:00:00.000'' and st.TerritoryID = 9';

					exec(@sql) ;

				end
				exec consulta_d3;
				go;


--10.Actualizar el nivel de existencias de seguridad y el color (SafetyStockLevel) del producto indicado, asi como la fecha de modificacion
			
			alter procedure Actualizar_Nivel
			
				@ID varchar(5),
				@Nivel smallint,
				@Col nvarchar(15)

				as
				begin TRANSACTION
				BEGIN TRY
				UPDATE Production.Product set SafetyStockLevel = @Nivel where ProductID = @ID;
				UPDATE Production.Product set Color = @Col where ProductID= @ID;
				UPDATE Production.Product set ModifiedDate = getdate() where ProductID= @ID;
				commit transaction
				end try
				
				begin catch
				rollback transaction
				print 'Ocurrio un error'
				end catch
			go
			exec Actualizar_Nivel '707', '4','Yellow'

			select pp.ProductID, pp.Name, pp.Color, pp.SafetyStockLevel, pp.ModifiedDate 
			from Production.Product pp where ProductID = '707';

--11.Registrar un nuevo prodcuto

      SET IDENTITY_INSERT Production.Product ON ;
      alter procedure Registrar_nuevo_producto
			      
				  @ProductIDx int,
				  @Namex nvarchar(50),
				  @ProductNumberx nvarchar(25),
				  @MakeFlagx bit,
				  @FinishedGoodsFlagx bit,
				  @Colorx nvarchar(50),
				  @SafetyStockLevelx smallint,
				  @ReorderPointx smallint,
				  @StandardCostx money,
				  @ListPricex money,
				  @Sizex nvarchar(5),
				  @SizeUnitMeasureCodex nchar(3),
				  @WeightUnitMeasureCodex nchar(3),
				  @Weightx decimal(8,2),
				  @DaysToManufacturex int,
				  @ProductLinex nchar(2),
				  @Classx nchar(2),
				  @Stylex nchar(2),
				  @ProductSubcategoryIDx int,
				  @ProductModelIDx int,
				  @rowguidx uniqueidentifier

				as
				begin TRANSACTION
				BEGIN TRY
				insert into Production.Product(
				   [ProductID]
				  ,[Name]
				  ,[ProductNumber]
				  ,[MakeFlag]
				  ,[FinishedGoodsFlag]
				  ,[Color]
				  ,[SafetyStockLevel]
				  ,[ReorderPoint]
				  ,[StandardCost]
				  ,[ListPrice]
				  ,[Size]
				  ,[SizeUnitMeasureCode]
				  ,[WeightUnitMeasureCode]
				  ,[Weight]
				  ,[DaysToManufacture]
				  ,[ProductLine]
				  ,[Class]
				  ,[Style]
				  ,[ProductSubcategoryID]
				  ,[ProductModelID]
				  ,[SellStartDate]
				  ,[SellEndDate]
				  ,[DiscontinuedDate]
				  ,[rowguid]
				  ,[ModifiedDate])

				  
		Values (  				  
		          @ProductIDx, 
				  @Namex ,
				  @ProductNumberx ,
				  @MakeFlagx ,
				  @FinishedGoodsFlagx,
				  @Colorx ,
				  @SafetyStockLevelx,
				  @ReorderPointx ,
				  @StandardCostx ,
				  @ListPricex ,
				  @Sizex ,
				  @SizeUnitMeasureCodex ,
				  @WeightUnitMeasureCodex ,
				  @Weightx ,
				  @DaysToManufacturex ,
				  @ProductLinex ,
				  @Classx ,
				  @Stylex ,
				  @ProductSubcategoryIDx ,
				  @ProductModelIDx ,
				  GETDATE(),
				  NULL ,
				  NULL ,
				  @rowguidx ,
				   GETDATE());
				commit transaction
				end try
				
				begin catch
				rollback transaction
				print 'Ocurrio un error'
				select ERROR_MESSAGE()
				end catch
			go

	exec Registrar_nuevo_producto 
	'1000',
	'Nuevo2',
	'AR-5382',
	'0',
	'0',
	'black',
	'1000',
	'600',
	'98.7700',
	'147.1400',
	'G',
	'G',
	'G',
	'445.00',
	'1',
	'M',
	'L',
	'U',
	'1',
	'23',
	'75752E26-A3B6-4264-9B06-F23A4FBDC5A0'

	Select * from Production.Product where rowguid='75752E26-A3B6-4264-9B06-F23A4FBDC5A0'

--12.Actualizar el descuento del detalle de la orden de compra y el ID de oferta
			
				
			alter procedure Actualizar_descuento

				@SalesOrderDetailIDx tinyint,
				@UnitPriceDiscountx money
				
			as
				begin TRANSACTION 
				BEGIN TRY
				UPDATE Sales.SalesOrderDetail set UnitPriceDiscount = @UnitPriceDiscountx  where SalesOrderDetailID = @SalesOrderDetailIDx;
				UPDATE Sales.SalesOrderDetail set ModifiedDate = getdate() where SalesOrderDetailID = @SalesOrderDetailIDx;
				if(@UnitPriceDiscountx = 0.00)
				UPDATE Sales.SalesOrderDetail set SpecialOfferID = '1' where SalesOrderDetailID = @SalesOrderDetailIDx;
				else 
				UPDATE Sales.SalesOrderDetail set SpecialOfferID = '17' where SalesOrderDetailID = @SalesOrderDetailIDx;
				commit transaction
				end try
				begin catch
				rollback transaction
				print 'Ocurrio un error'
				select ERROR_MESSAGE()

				end catch
			go

			exec Actualizar_descuento '1', '0.00'
			select * from Sales.SalesOrderDetail where SalesOrderDetailID = 1;
