--- 10
USE [AdventureSales]
GO
/****** Object:  StoredProcedure [dbo].[Actualizar_Nivel]    Script Date: 14/12/2021 11:27:59 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	ALTER procedure [dbo].[Actualizar_Nivel]
			
				@ID varchar(5),
				@Nivel smallint,
				@Col nvarchar(15)

				as
				begin 

			 declare @servidor nvarchar(100);
			  declare @servidor2 nvarchar(100);
			  declare @id2 int;


			 set @id2 = 1;

 					  select @servidor = servidor
					  from diccionario_dist
					  where id_dic = @id2

			set @id2= 2;
 
  					  select @servidor2 = servidor
					  from diccionario_dist
					  where id_dic = @id2


				 if(@servidor2 = 'local')
					 BEGIN

						BEGIN TRY
						SET XACT_ABORT ON ;
							BEGIN TRANSACTION;
								UPDATE SQL.Adventure.Production.Product set SafetyStockLevel = @Nivel where ProductID = @ID;
								UPDATE SQL.Adventure.Production.Product set Color = @Col where ProductID= @ID;
								UPDATE SQL.Adventure.Production.Product set ModifiedDate = getdate() where ProductID= @ID;
							commit transaction;
							SET XACT_ABORT OFF ;
						end try 
							begin catch
								rollback transaction
								print 'Ocurrio un error'
						end catch
						select pp.ProductID, pp.Name, pp.Color, pp.SafetyStockLevel, pp.ModifiedDate 
						from SQL.Adventure.Production.Product pp where ProductID = @ID;

					 END
					else
					BEGIN
						BEGIN TRY
						SET XACT_ABORT ON ;
							BEGIN TRANSACTION;				
								UPDATE Production.Product set SafetyStockLevel = @Nivel where ProductID = @ID;
								UPDATE Production.Product set Color = @Col where ProductID= @ID;
								UPDATE Production.Product set ModifiedDate = getdate() where ProductID= @ID;
							commit transaction;
							SET XACT_ABORT OFF ;
						end try
						begin catch
							rollback transaction
							print 'Ocurrio un error'
						end catch

						select pp.ProductID, pp.Name, pp.Color, pp.SafetyStockLevel, pp.ModifiedDate 
						from Production.Product pp where ProductID = @ID;
					END;

					

		END

		--11
		USE [AdventureSales]
GO
/****** Object:  StoredProcedure [dbo].[ingrear_oferta]    Script Date: 14/12/2021 11:28:05 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER procedure [dbo].[ingrear_oferta]
			      
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
--12
USE [AdventureSales]
GO
/****** Object:  StoredProcedure [dbo].[Actualizar_descuento]    Script Date: 14/12/2021 11:27:52 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[Actualizar_descuento]

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
				select SalesOrderDetailID,UnitPriceDiscount,ModifiedDate from Sales.SalesOrderDetail where SalesOrderDetailID = @SalesOrderDetailIDx;

				--exec Actualizar_descuento '1', '0.00'