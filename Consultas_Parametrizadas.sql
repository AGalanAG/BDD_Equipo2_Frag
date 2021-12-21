 --CONSULTAS EQUIPO 2

--1.Listar los productos más vendidos con un precio menor o igual a 100(n) y que el color sea amarillo(x).
--Enrique (Apoyo: Alan )
				go
				alter procedure consulta_p   
				@precio nvarchar(100),
				@color nvarchar(100)
				as
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
							where pp.ListPrice <= '+@precio+' and pp.Color = '''+@color+'''
							group by ss.ProductID, pp.Name, pp.ProductID, pp.ListPrice
							order by count(ss.ProductID) desc';

						 else 
		 					set @sql='select pp.ProductID, pp.Name, pp.ListPrice,
							count(ss.ProductID) as veces_vendido
							from '+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' pp
							inner join '+@servidor2+'.'+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' ss
							on pp.ProductID = ss.ProductID
							where pp.ListPrice <= '+@precio+' and pp.Color = '''+@color+'''
							group by ss.ProductID, pp.Name, pp.ProductID, pp.ListPrice
							order by count(ss.ProductID) desc';


					exec(@sql) ;
		

				end;

				exec consulta_p '100', 'blue';


				

--2.Listar los productos más vendidos con un precio mayor o igual a 600(n) y un nivel de seguridad del stock (SafetyStockLevel) igual a 500(m).
--Enrique (Apoyo: Alan )

go
alter procedure Productos_Vendidos 
@precio nvarchar(100),
@nivel nvarchar(100)
as
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
						where pp.ListPrice >= '+@precio+' and pp.SafetyStockLevel = '''+@nivel+'''
						group by ss.ProductID, pp.Name, pp.ProductID
						order by count(ss.ProductID) desc';

		  else
		  set @sql = 'select pp.ProductID, pp.Name, count(ss.ProductID) as veces_vendido
						from '+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' pp
						inner join '+@servidor2+'.'+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' ss
						on pp.ProductID = ss.ProductID
						where pp.ListPrice >='+@precio+' and pp.SafetyStockLevel = '''+@nivel+'''
						group by ss.ProductID, pp.Name, pp.ProductID
						order by count(ss.ProductID) desc';

exec(@sql);
end
exec Productos_Vendidos '600','500';


--3.Listar los productos más vendidos con un precio estándar menor o igual a 250(n) y el dia de manufactura sea igual a 1(m).
--Eli
go
alter procedure Productos_Vendidos2
@precio nvarchar (100),
@dia nvarchar (100)
as
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
						where pp.StandardCost <= '+@precio+' and pp.DaysToManufacture = '+@dia+' 
						group by ss.ProductID, pp.Name, pp.ProductID
						order by count(ss.ProductID) asc';

		  else
		  set @sql = 'select pp.ProductID, pp.Name, count(ss.ProductID) as veces_vendido
						from '+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' pp
						inner join '+@servidor2+'.'+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' ss
						on pp.ProductID = ss.ProductID
						where pp.StandardCost <= '+@precio+' and pp.DaysToManufacture = '+@dia+' 
						group by ss.ProductID, pp.Name, pp.ProductID
						order by count(ss.ProductID) asc';



exec(@sql);

end


exec Productos_Vendidos2 '250','1';
			
--4.Determinar el total vendido de las ventas en el territorio 3(n) 
--Eli

go
alter procedure ventas_territorio @territorio varchar(10) as
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


			  exec ventas_territorio '3'
			  exec ventas_territorio '4'

--Alan		
--5.Determinar el número  de ventas donde el total de la compra sea mayor a 0(n) y menor a 1000(m)
--6.Determinar el número  de ventas donde el total de la compra sea mayor a 1000(n) y menor a 2000(m)
--7.Determinar el número  de ventas donde el total de la compra sea mayor a 2000(n) 


				go;
				alter procedure consulta_d1   
				@rango1 int, @rango2 int as

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

				   create table #T1(id int ,Nombre varchar(100),total_vendido float)
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

					select  Nombre, count(total_vendido) as Cantidad from #T1
					where total_vendido >@rango1 and total_vendido <@rango2
					group by Nombre;
					
					end
					exec consulta_d1 0,100;



--8.Determinar las ventas donde los impuestos aplicados sean mayor o igual a los 500(n) y el territorio sea el 3(m)
--Alan 
				go;
				alter procedure consulta_d2 
				@impuesto nvarchar(100),
				@territorio nvarchar(100)
				as

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
										where TaxAmt >='+@impuesto+' and st.TerritoryID = '+@territorio+'
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
										where TaxAmt >='+@impuesto+' and st.TerritoryID = '+@territorio+'
										group by sh.SalesOrderID,st.TerritoryID, pp.Name,TaxAmt';


					exec(@sql) ;

				end
				exec consulta_d2 '500','3';

--9.Listar las ordenes del territorio 9(n) con fecha de modificacion del 2011-06-30 00:00:00.000(x)
--Gali
				go;
				alter procedure consulta_d3
				@territorio nvarchar(10),
				@fecha nvarchar(1000)
				as

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
										where DueDate ='''+@fecha+''' and st.TerritoryID = '+@territorio+' ' ;


						 else 
							set @sql='select sh.SalesOrderID,st.TerritoryID,  pp.Name,sh.DueDate 
										from '+@servidor4+'.'+@nom_bd4+'.'+@esquema4+'.'+@nom_tabla4+' sh
										inner join '+@servidor2+'.'+@nom_bd2+'.'+@esquema2+'.'+@nom_tabla2+' so
										on sh.SalesOrderID = so.SalesOrderID
										inner join '+@nom_bd+'.'+@esquema+'.'+@nom_tabla+' pp
										on pp.ProductID = so.ProductID
										inner join '+@servidor3+'.'+@nom_bd3+'.'+@esquema3+'.'+@nom_tabla3+'  st
										on st.TerritoryID = sh.TerritoryID
										where DueDate ='+@fecha+' and st.TerritoryID = '+@territorio+' ';

					exec(@sql) ;

				end
				exec consulta_d3 '9','2011-06-30 00:00:00.000';


--10.Actualizar el nivel de existencias de seguridad y el color (SafetyStockLevel) del producto indicado, asi como la fecha de modificacion
--Gali			go
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
			
			exec Actualizar_Nivel '707', '4','Yellow'



--11.-Insertar una nueva oferta especial
--Maite
			go
      SET IDENTITY_INSERT Sales.SpecialOffer ON ;
      alter procedure ingrear_oferta
			      
				  @SpecialOfferIDX int,
				  @Descripcionx nvarchar(50),
				  @Descuentox smallmoney,
				  @Tipox nvarchar(50),
				  @Categoriax nvarchar(50),
				  @FechaIniciox datetime,
				  @FechaTerx datetime,
				  @MinQx int,
				  @MaxQx int,
				  @rowguidx uniqueidentifier

				as
				begin TRANSACTION
				BEGIN TRY
				insert into Sales.SpecialOffer([SpecialOfferID]
				  ,[Description]
				  ,[DiscountPct]
				  ,[Type]
				  ,[Category]
				  ,[StartDate]
				  ,[EndDate]
				  ,[MinQty]
				  ,[MaxQty]
				  ,[rowguid]
				  ,[ModifiedDate])

				  
		Values (  				  
		          				  @SpecialOfferIDX ,
				  @Descripcionx ,
				  @Descuentox ,
				  @Tipox ,
				  @Categoriax ,
				  @FechaIniciox,
				  @FechaTerx ,
				  @MinQx ,
				  @MaxQx ,
				  @rowguidx ,
				   GETDATE());
				commit transaction
				end try
				
				begin catch
				rollback transaction
				print 'Ocurrio un error'
				select ERROR_MESSAGE()
				end catch
				select SpecialOfferID,Description,DiscountPct,ModifiedDate from Sales.SpecialOffer where SpecialOfferID = @SpecialOfferIDX;
		

	exec ingrear_oferta 
	'17',
	'BuenFin',
	'0.30',
	'New Product',
	'Customer',
	'2011-05-01 00:00:00.000',
	'2014-05-30 00:00:00.000',
	'11',
	'40',	
	'75752E26-A3B6-4264-9B06-F23A4FBDC5A0'

--12.Actualizar el descuento del detalle de la orden de compra y el ID de oferta
--Maite
					
					go
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
	
			exec Actualizar_descuento '1', '0.00'
