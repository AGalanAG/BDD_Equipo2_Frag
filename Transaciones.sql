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
			from SQLS1.Adventure.Production.Product pp where ProductID = '707';

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
