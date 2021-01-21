
CREATE DATABASE IF NOT EXISTS PY2_E1;
DROP DATABASE PY2_E1;

USE PY2_E1;
SELECT count(*) FROM Temporal;

-- ****************************************************************************************************************************

USE PY2_E1;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Region,Ciudad,Codigo_Postal,Persona,Tipo,Compania,Categoria,Producto,Transaccion;
SET FOREIGN_KEY_CHECKS = 1;

-- ********************************************** CREACION DE LA TABLA TEMPORAL ***********************************************
USE PY2_E1;
CREATE temporary TABLE Temporal(
nombre_compania VARCHAR(50) NOT NULL,
contacto_compania VARCHAR(50) NOT NULL,
correo_compania VARCHAR(50) NOT NULL,
telefono_compania VARCHAR(15) NOT NULL,
tipo VARCHAR(2) NOT NULL,
nombre VARCHAR(50) NOT NULL,
correo VARCHAR(50) NOT NULL,
telefono VARCHAR(15) NOT NULL,
fecha_registro VARCHAR(20) NOT NULL,
direccion VARCHAR(50) NOT NULL,
ciudad VARCHAR(50) NOT NULL,
codigo_postal INT(30) NOT NULL,
region VARCHAR(50) NOT NULL,
producto VARCHAR(50) NOT NULL,
categoria_producto VARCHAR(50) NOT NULL,
cantidad INT NOT NULL,
precio_unitario DECIMAL(19,2) NOT NULL
);
LOAD DATA LOCAL INFILE '/home/mario/Escritorio/Bases1/Enunciado1.csv'
INTO TABLE Temporal 
CHARACTER SET latin1 
FIELDS TERMINATED BY  ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(nombre_compania, contacto_compania, correo_compania, telefono_compania, tipo, nombre, correo, telefono, @var_fecha, direccion, ciudad, codigo_postal, region, producto, categoria_producto, cantidad, precio_unitario)
SET fecha_registro = STR_TO_DATE(@var_fecha, '%d/%m/%Y');


-- ********************************************* CONSULTAS PARA CREAR EL MODELO*************************************************

CREATE TABLE IF NOT EXISTS Region(
ID_Region INT NOT NULL AUTO_INCREMENT,
Nombre_Region VARCHAR(40) NOT NULL,
PRIMARY KEY(ID_Region)
)ENGINE=InnoDB CHARACTER SET latin1;

CREATE TABLE IF NOT EXISTS Tipo(
ID_Tipo INT NOT NULL AUTO_INCREMENT,
Nombre_Tipo VARCHAR(5) NOT NULL,
PRIMARY KEY(ID_Tipo)
)ENGINE=InnoDB CHARACTER SET latin1;


CREATE TABLE IF NOT EXISTS Categoria(
ID_Categoria INT NOT NULL AUTO_INCREMENT,
Nombre_Categoria VARCHAR(40) NOT NULL,
PRIMARY KEY(ID_Categoria)
)ENGINE=InnoDB CHARACTER SET latin1;


CREATE TABLE IF NOT EXISTS Compania(
ID_Compania INT NOT NULL AUTO_INCREMENT,
Nombre_Compania VARCHAR(50) NOT NULL,
Contacto_Compania VARCHAR(40) NOT NULL,
Correo_Compania VARCHAR(50) NOT NULL,
Telefono_Compania VARCHAR(20) NOT NULL,
PRIMARY KEY(ID_Compania) 
)ENGINE=InnoDB CHARACTER SET latin1;


CREATE TABLE IF NOT EXISTS Ciudad(
ID_Ciudad INT NOT NULL AUTO_INCREMENT,
Nombre_Ciudad VARCHAR(40) NOT NULL,
PRIMARY KEY(ID_Ciudad),
Id_Region INT NOT NULL,
CONSTRAINT fk_Ciudad_Region
FOREIGN KEY(ID_Region) REFERENCES Region (ID_Region)
ON DELETE NO ACTION
)ENGINE=InnoDB CHARACTER SET latin1;


CREATE TABLE IF NOT EXISTS Codigo_Postal(
ID_Codigo_Postal INT NOT NULL AUTO_INCREMENT,
Numero_Codigo_Postal INT NOT NULL,
PRIMARY KEY(ID_Codigo_Postal),
ID_Ciudad INT NOT NULL,
CONSTRAINT fk_CPostal_Ciudad
FOREIGN KEY(ID_Ciudad) REFERENCES Ciudad(ID_Ciudad)
ON DELETE NO ACTION
)ENGINE=InnoDB CHARACTER SET latin1;


CREATE TABLE IF NOT EXISTS Persona(
ID_Persona INT NOT NULL AUTO_INCREMENT,
Nombre_Persona VARCHAR(40) NOT NULL,
Correo_Persona VARCHAR(50) NOT NULL,
Telefono_Persona VARCHAR(20) NOT NULL,
Fecha_Registro VARCHAR(20) NOT NULL,
Direccion VARCHAR(50) NOT NULL,
PRIMARY KEY(ID_Persona),
ID_Codigo_Postal INT NOT NULL,
ID_Tipo INT NOT NULL,
CONSTRAINT fk_Persona_CPostal
FOREIGN KEY(ID_Codigo_Postal) REFERENCES Codigo_Postal(ID_Codigo_Postal) ON DELETE NO ACTION,
CONSTRAINT fk_Persona_Tipo
FOREIGN KEY(ID_Tipo) REFERENCES Tipo(ID_Tipo) ON DELETE NO ACTION
)ENGINE=InnoDB CHARACTER SET latin1;


CREATE TABLE IF NOT EXISTS Producto(
ID_Producto INT NOT NULL AUTO_INCREMENT,
Nombre_Producto VARCHAR(40) NOT NULL,
Precio_Producto DECIMAL(19,2) NOT NULL,
PRIMARY KEY(ID_Producto),
ID_Categoria INT NOT NULL,
CONSTRAINT fk_Producto_Categoria
FOREIGN KEY(ID_Categoria) REFERENCES Categoria(ID_Categoria)
ON DELETE NO ACTION
)ENGINE=InnoDB CHARACTER SET latin1;


CREATE TABLE IF NOT EXISTS Transaccion(
ID_Transaccion INT NOT NULL AUTO_INCREMENT,
Cantidad INT NOT NULL,
Total_Transaccion DECIMAL(19,2) NOT NULL,
PRIMARY KEY(ID_Transaccion),
ID_Compania INT NOT NULL,
ID_Persona INT NOT NULL,
ID_Producto INT NOT NULL,
CONSTRAINT fk_Transaccion_Compania
FOREIGN KEY(ID_Compania) REFERENCES Compania(ID_Compania)
ON DELETE NO ACTION,
CONSTRAINT fk_Transaccion_Persona
FOREIGN KEY(ID_Persona) REFERENCES Persona(ID_Persona)
ON DELETE NO ACTION,
CONSTRAINT fk_Transaccion_Producto
FOREIGN KEY(ID_Producto) REFERENCES Producto(ID_Producto)
ON DELETE NO ACTION
)ENGINE=InnoDB CHARACTER SET latin1;


-- ******************************************** CONSULTAS PARA LLENAR EL MODELO ***********************************************

INSERT INTO Region (Nombre_Region) SELECT DISTINCT region 
FROM Temporal WHERE region IS NOT NULL;

INSERT INTO Tipo (Nombre_Tipo) SELECT DISTINCT tipo 
FROM Temporal WHERE tipo IS NOT NULL;
                
INSERT INTO Categoria (Nombre_Categoria) SELECT DISTINCT categoria_producto 
FROM Temporal WHERE categoria_producto IS NOT NULL;

INSERT INTO Compania (Nombre_Compania,Contacto_Compania,Correo_Compania,Telefono_Compania)
SELECT DISTINCT nombre_compania,contacto_compania,correo_compania,telefono_compania 
FROM Temporal WHERE nombre_compania IS NOT NULL AND contacto_compania IS NOT NULL AND correo_compania 
IS NOT NULL AND telefono_compania IS NOT NULL;

INSERT INTO Ciudad (Nombre_Ciudad,Id_Region) SELECT DISTINCT T.ciudad, R.ID_Region 
FROM Temporal T LEFT JOIN Region R ON T.region = R.Nombre_Region WHERE T.ciudad IS NOT NULL;

INSERT INTO Codigo_Postal (Numero_Codigo_Postal,ID_Ciudad) SELECT DISTINCT T.codigo_postal, C.ID_Ciudad 
FROM Temporal T LEFT JOIN Ciudad C ON T.ciudad = C.Nombre_Ciudad WHERE T.codigo_postal IS NOT NULL; 

INSERT INTO Persona (Nombre_Persona,Correo_Persona,Telefono_Persona,Fecha_Registro,Direccion,ID_Codigo_Postal,ID_Tipo) 
SELECT DISTINCT T.nombre, T.correo, T.telefono, T.fecha_registro, T.direccion, p.ID_Codigo_Postal,tip.ID_Tipo 
FROM Temporal T 
LEFT JOIN Tipo tip ON T.tipo = tip.Nombre_Tipo LEFT JOIN Codigo_Postal p 
ON T.codigo_postal = p.Numero_Codigo_Postal
WHERE T.nombre IS NOT NULL AND T.telefono IS NOT NULL AND T.fecha_registro IS NOT NULL AND T.correo 
IS NOT NULL AND T.direccion IS NOT NULL;
-- WHERE T.codigo_postal=p.Numero_Codigo_Postal AND T.tipo='C' OR T.tipo='P';

INSERT INTO Producto (Nombre_Producto,Precio_Producto,ID_Categoria) 
SELECT DISTINCT T.producto, T.precio_unitario, C.ID_Categoria 
FROM Temporal T LEFT JOIN Categoria C ON T.categoria_producto = C.Nombre_Categoria
WHERE T.producto IS NOT NULL AND T.precio_unitario IS NOT NULL;

INSERT INTO Transaccion (Cantidad,Total_Transaccion,ID_Compania,ID_Persona,ID_Producto)
SELECT DISTINCT T.cantidad,(P1.Precio_Producto)*(T.cantidad),C.ID_Compania,P2.ID_Persona,P1.ID_Producto 
FROM Temporal T LEFT JOIN Producto P1 ON T.producto = P1.Nombre_Producto LEFT JOIN Persona P2 ON T.nombre = P2.Nombre_Persona 
LEFT JOIN Compania C ON T.nombre_compania = C.Nombre_Compania WHERE T.cantidad IS NOT NULL AND T.precio_unitario IS NOT NULL;


SELECT count(*) FROM Region;
SELECT count(*) FROM Tipo;
SELECT count(*) FROM Categoria;
SELECT count(*) FROM Compania;
SELECT count(*) FROM Ciudad;
SELECT count(*) FROM Codigo_Postal;
SELECT count(*) FROM Persona;
SELECT count(*) FROM Producto;
SELECT count(*) FROM Transaccion;

SELECT count(*) FROM Temporal;
SELECT * FROM Categoria;
SELECT * FROM Producto;

-- ******************************************************** REPORTES *******************************************************

-- (1) Mostrar el número de cliente, nombre, apellido y total del cliente que más productos ha comprado.

SELECT per.Telefono_Persona,per.Nombre_Persona,COUNT(tra.Cantidad) AS CantidadP,SUM(tra.Total_Transaccion) AS Total
FROM Persona per,Transaccion tra,Tipo t
-- INNER JOIN Transaccion tra ON per.ID_Persona= tra.ID_Persona
-- INNER JOIN Tipo t on per.ID_Tipo=t.ID_Tipo
WHERE per.ID_Persona= tra.ID_Persona AND t.ID_Tipo=per.ID_Tipo AND t.Nombre_Tipo='C'
GROUP BY per.Telefono_Persona,per.Nombre_Persona
ORDER BY CantidadP desc
limit 1;


SELECT p.Telefono_Persona AS Telefono_Cliente,COUNT(tr.Cantidad) AS CantidadP,
SUBSTR(p.Nombre_Persona, 1, INSTR(p.Nombre_Persona, ' ')-1) AS Nombre,
SUBSTR(p.Nombre_Persona, INSTR(p.Nombre_Persona, ' ')+1) AS Apellido,
SUM(tr.Total_Transaccion) AS Total_pedidos
FROM Persona p
INNER JOIN Transaccion tr ON p.ID_Persona= tr.ID_Persona
INNER JOIN Tipo t on p.ID_Tipo =t.ID_Tipo
GROUP BY p.Telefono_Persona, 
SUBSTR(p.Nombre_Persona, 1, INSTR(p.Nombre_Persona, ' ')-1),
SUBSTR(p.Nombre_Persona, INSTR(p.Nombre_Persona, ' ')+1),
t.Nombre_Tipo
HAVING t.Nombre_Tipo='C'
ORDER BY count(tr.Cantidad) DESC
limit 1;


-- (2) Mostrar el número de mes de la fecha de registro, nombre y apellido de todos los clientes que más han comprado
-- y los que menos han comprado (en dinero) utilizando una sola consulta.
(SELECT MONTH(per.Fecha_Registro) AS Mes,per.Fecha_Registro,per.Nombre_Persona,sum(tr.Total_Transaccion) AS Total ,'+ compra' AS Tipo 
FROM Persona per,Transaccion tr,Tipo tip
WHERE per.ID_Persona=tr.ID_Persona AND per.ID_Tipo=tip.ID_Tipo AND tip.Nombre_Tipo='C'
GROUP BY per.Nombre_Persona,per.Fecha_Registro 
ORDER BY total DESC
LIMIT 5)
UNION
(SELECT MONTH(per.Fecha_Registro) AS Mes,per.Fecha_Registro,per.Nombre_Persona,sum(tr.Total_Transaccion) AS Total ,'- compra' AS Tipo 
FROM Persona per,Transaccion tr,Tipo tip
WHERE per.ID_Persona=tr.ID_Persona AND per.ID_Tipo=tip.ID_Tipo AND tip.Nombre_Tipo='C'
GROUP BY per.Nombre_Persona,per.Fecha_Registro 
ORDER BY total ASC
LIMIT 5);

-- (3) Mostrar el top 5 de proveedores que más productos han vendido (en dinero) de la categoría de productos ‘Fresh Vegetables’.
SELECT  per.Nombre_Persona ,cat.Nombre_Categoria ,sum(tr.Total_Transaccion) AS Total_Vendido 
FROM Persona per,Categoria cat,Producto prod,Transaccion tr
WHERE per.ID_Persona=tr.ID_Persona AND tr.ID_Producto=prod.ID_Producto 
AND prod.Id_Categoria=cat.Id_Categoria and cat.Nombre_Categoria="Fresh Vegetables"
group by per.Nombre_Persona,cat.Nombre_Categoria
order by Total_Vendido desc
limit 5;

-- (4) Mostrar el nombre del proveedor, número de teléfono, número de orden, total de la orden por la cual se haya
-- obtenido la menor cantidad de producto.
select per.Nombre_Persona,per.Telefono_Persona,tr.ID_Transaccion,sum(tr.Total_Transaccion)as Total_Orden, tr.Cantidad as Cant_Orden
from Persona per,Transaccion tr,Producto prod,Categoria cat,Tipo tip
where per.ID_Persona=tr.ID_Persona and prod.Id_Producto=tr.Id_Producto
and cat.Id_Categoria=prod.Id_Categoria AND tip.ID_Tipo=per.ID_Tipo AND tip.Nombre_Tipo='P'
group by per.Telefono_Persona,per.Nombre_Persona, tr.Id_Transaccion,Cant_Orden
order by Cant_Orden asc 
limit 20;

select per.Nombre_Persona,per.Telefono_Persona,tr.ID_Transaccion,sum(tr.Total_Transaccion)as Total_Orden,MIN(tr.Cantidad) as Cant_Orden
from Persona per,Transaccion tr,Tipo tip
where per.ID_Persona=tr.ID_Persona AND tip.ID_Tipo=per.ID_Tipo AND tip.Nombre_Tipo='P'
group by tip.Nombre_Tipo,per.Telefono_Persona,per.Nombre_Persona, tr.Id_Transaccion,tr.Total_Transaccion
order by MIN(tr.Cantidad) asc 
limit 20;

SELECT p.Nombre_Persona AS PROVEEDOR , p.Telefono_Persona AS Telefono, tr.ID_Transaccion AS No_Orden, tr.Total_Transaccion AS Total_Orden,
MIN(tr.Cantidad) AS Cantidad 
FROM Persona p
INNER JOIN Transaccion tr on p.ID_Persona=tr.ID_Persona
INNER JOIN Tipo tip on p.ID_Tipo =tip.ID_Tipo
GROUP BY tip.Nombre_Tipo, p.Nombre_Persona , p.Telefono_Persona, tr.ID_Transaccion, tr.Total_Transaccion
HAVING tip.Nombre_Tipo='P'
ORDER BY tr.Total_Transaccion,MIN(tr.Cantidad)  ASC
limit 20;

-- (5) Mostrar el top 10 de los clientes que más productos han comprado de la categoría ‘Seafood’.

SELECT per.Nombre_Persona,cat.Nombre_Categoria,SUM(tr.Cantidad) AS Cantidad_Compra
FROM Persona per,Transaccion tr,Producto prod,Categoria cat,Tipo tip
WHERE per.ID_Persona=tr.ID_Persona AND tip.ID_Tipo=per.ID_Tipo AND cat.ID_Categoria=prod.ID_Categoria
AND prod.ID_Producto=tr.ID_Producto AND tip.Nombre_Tipo='C' AND cat.Nombre_Categoria='Seafood'
GROUP BY per.Nombre_Persona,cat.Nombre_Categoria
ORDER BY Cantidad_Compra desc
LIMIT 10;

-- (6) Mostrar el porcentaje de clientes que le corresponden a cada región.

DELIMITER $$
CREATE PROCEDURE simple_loop ( )
BEGIN
  DECLARE counter BIGINT DEFAULT 0;
 
  my_loop: LOOP
    SET counter=counter+1;

    IF counter=20 THEN
      LEAVE my_loop;
    END IF;

    (SELECT reg.Nombre_Region, count(per.Nombre_Persona) AS Cantidad_Personas ,(count(per.Nombre_Persona)*100/99) AS Porcentaje
FROM Persona per,Tipo tip,Region reg,Ciudad cui,Codigo_Postal codp
WHERE reg.ID_Region=cui.ID_Region AND cui.ID_Ciudad=codp.ID_Ciudad 
AND codp.ID_Codigo_Postal=per.ID_Codigo_Postal AND tip.ID_Tipo=per.ID_Tipo AND reg.ID_Region=counter AND tip.Nombre_Tipo='C'
GROUP BY reg.Nombre_Region
ORDER BY Cantidad_Personas)union

  END LOOP my_loop;
END$$
DELIMITER ;

CALL simple_loop();
DROP PROCEDURE simple_loop;

SELECT reg.Nombre_Region, count(per.Nombre_Persona) AS Cantidad_Personas ,(count(per.Nombre_Persona)*100/
 ( select count(per.Nombre_Persona) as Nombre from Persona per,Tipo tip
where tip.ID_Tipo=per.ID_Tipo AND tip.Nombre_Tipo='C')
 ) AS Porcentaje
FROM Persona per,Tipo tip,Region reg,Ciudad cui,Codigo_Postal codp
WHERE reg.ID_Region=cui.ID_Region AND cui.ID_Ciudad=codp.ID_Ciudad 
AND codp.ID_Codigo_Postal=per.ID_Codigo_Postal AND tip.ID_Tipo=per.ID_Tipo AND tip.Nombre_Tipo='C'
GROUP BY reg.Nombre_Region
ORDER BY reg.Nombre_Region;

select count(per.Nombre_Persona) as Nombre from Persona per,Tipo tip
where tip.ID_Tipo=per.ID_Tipo AND tip.Nombre_Tipo='C';

-- (7) Mostrar las ciudades en donde más se consume el producto “Tortillas” de la categoría “Refrigerated Items”.

SELECT ciu.Nombre_Ciudad,SUM(tr.Cantidad) AS Cantidad,pro.Nombre_Producto AS Producto
FROM Ciudad ciu,Codigo_Postal codp,Persona per,Transaccion tr,Producto pro,Categoria cat,Tipo tip
WHERE ciu.ID_Ciudad=codp.ID_Ciudad AND codp.ID_Codigo_Postal=per.ID_Codigo_Postal AND tip.ID_Tipo=per.ID_Tipo
AND per.ID_Persona=tr.ID_Persona  AND cat.ID_Categoria=pro.ID_Categoria AND pro.ID_Producto =tr.ID_Producto
AND pro.Nombre_Producto='Tortillas' AND cat.Nombre_Categoria='Refrigerated Items' and tip.Nombre_Tipo='C'
GROUP BY ciu.Nombre_Ciudad
ORDER BY Cantidad desc;

-- (8) Mostrar la cantidad de clientes que hay en las ciudades agrupadas por su letra inicial, 
-- es decir, agrupar las ciudades con A y mostrar la cantidad de clientes, lo mismo para las que inicien con B y así sucesivamente.

SELECT substring(ciu.Nombre_Ciudad,1,1) as Letra,COUNT(per.Nombre_Persona) as Cantidad_Clientes
FROM Persona per,Ciudad ciu,Codigo_Postal codp,Tipo tip
WHERE ciu.ID_Ciudad=codp.ID_Ciudad AND codp.ID_Codigo_Postal=per.ID_Codigo_Postal 
AND tip.ID_Tipo=per.ID_Tipo AND tip.Nombre_Tipo='C'
GROUP BY ciu.Nombre_Ciudad
ORDER BY Letra ASC;

SELECT ciu.Nombre_Ciudad ,COUNT(per.Nombre_Persona) as Cantidad_Clientes
FROM Persona per,Ciudad ciu,Codigo_Postal codp,Tipo tip
WHERE ciu.ID_Ciudad=codp.ID_Ciudad AND codp.ID_Codigo_Postal=per.ID_Codigo_Postal 
AND tip.ID_Tipo=per.ID_Tipo AND tip.Nombre_Tipo='C'
GROUP BY ciu.Nombre_Ciudad
ORDER BY ciu.Nombre_Ciudad ASC;

-- (9) Mostrar el porcentaje de las categorías más vendidas de cada ciudad de la siguiente manera: Ciudad, Categoría,    
-- Porcentaje De Mercado
SELECT ciu.Nombre_Ciudad,cat.Nombre_Categoria ,COUNT(tr.Cantidad) AS Cantidad
FROM Ciudad ciu,Codigo_Postal codp,Persona per,Transaccion tr,Categoria cat,Producto prod
WHERE ciu.ID_Ciudad=codp.ID_Ciudad AND codp.ID_Codigo_Postal=per.ID_Codigo_Postal
AND per.ID_Persona=tr.ID_Persona AND cat.ID_Categoria=prod.ID_Categoria AND prod.ID_Producto=tr.ID_Producto
GROUP BY  ciu.Nombre_Ciudad,cat.Nombre_Categoria
HAVING Max(tr.Cantidad)
ORDER BY ciu.Nombre_Ciudad,Cantidad DESC;

select cat.Nombre_Categoria,count(tr.Cantidad) as Cantidad
from Transaccion tr,Categoria cat,Producto prod
where cat.ID_Categoria=prod.ID_Categoria and prod.ID_Producto=tr.ID_Producto
group by cat.Nombre_Categoria
order by Cantidad asc;

-- (10) Mostrar los clientes que hayan consumido más que el promedio que consume la ciudad de Frankfort.

SELECT per.Nombre_Persona,sum(tr.Cantidad) as Cantidad
FROM Ciudad ciu,Codigo_Postal codp,Persona per,Tipo tip,Transaccion tr,Producto prod
WHERE ciu.ID_Ciudad=codp.ID_Ciudad AND codp.ID_Codigo_Postal=per.ID_Codigo_Postal
AND tip.ID_Tipo=per.ID_Tipo AND per.ID_Persona =tr.ID_Persona AND prod.ID_Producto=tr.ID_Producto
AND tip.Nombre_Tipo='C' AND ciu.Nombre_Ciudad='Frankfort'
GROUP BY per.Nombre_Persona
ORDER BY Cantidad;

(SELECT per.Nombre_Persona,sum(tr.Cantidad) as Cantidad
FROM Ciudad ciu,Codigo_Postal codp,Persona per,Tipo tip,Transaccion tr,Producto prod
WHERE ciu.ID_Ciudad=codp.ID_Ciudad AND codp.ID_Codigo_Postal=per.ID_Codigo_Postal
AND tip.ID_Tipo=per.ID_Tipo AND per.ID_Persona =tr.ID_Persona AND prod.ID_Producto=tr.ID_Producto
AND tip.Nombre_Tipo='C' 
GROUP BY per.Nombre_Persona
ORDER BY Cantidad)
union

select ciu.Nombre_Ciudad,sum(tr.Cantidad) as Total,per.Nombre_Persona as Cant_Cliente
from Ciudad ciu,Codigo_Postal codp,Transaccion tr,Persona per,Tipo tip
where ciu.ID_Ciudad=codp.ID_Ciudad AND codp.ID_Codigo_Postal=per.ID_Codigo_Postal
AND per.ID_Persona =tr.ID_Persona AND tip.ID_Tipo=per.ID_Tipo AND tip.Nombre_Tipo='C' AND ciu.Nombre_Ciudad='Frankfort'
group by ciu.Nombre_Ciudad,per.Nombre_Persona
order by Total desc ;


