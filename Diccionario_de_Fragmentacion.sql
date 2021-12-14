--DICCIONARIO DE DISTRIBUCION
--En el presente proyecto se ocuparon dos instancias SQL Y Local en donde se cuenta con el siguiente fragmento por esquemas, 
--el primer esquema corresponde al esquema de produccion y el segundo al esquema de centas.
--Del esquema de produccion unicamente se cuenta con la tabla Product
--En el esquema de ventas se tomaron las tablas SalesOrderDetail,Sales Territory y SalesOrderHeader

CREATE TABLE diccionario_dist (
  id_dic tinyint primary key, -- identificador 
  servidor varchar(30), -- nombre del servidor vinculado
  bd varchar(30), -- nombre de la base
  esquema varchar(30), -- nombre del esquema
  ntabla varchar(30) -- nombre de la tabla 
)

insert into diccionario_dist values (1,'local','Adventure','Production','Product');
insert into diccionario_dist values (2,'SQL','AdventureSales','Sales','SalesOrderDetail');
insert into diccionario_dist values (3,'SQL','AdventureSales','Sales','Sales Territory');
insert into diccionario_dist values (4,'SQL','AdventureSales','Sales','SalesOrderHeader');

select * from diccionario_dist