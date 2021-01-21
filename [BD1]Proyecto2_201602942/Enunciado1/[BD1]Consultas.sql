
-- (1) Mostrar el número de cliente, nombre, apellido y total del cliente que más productos ha comprado.
SELECT per.Telefono_Persona,per.Nombre_Persona,COUNT(tra.Cantidad) AS CantidadP,SUM(tra.Total_Transaccion) AS Total
FROM Persona per,Transaccion tra,Tipo t
WHERE per.ID_Persona= tra.ID_Persona AND t.ID_Tipo=per.ID_Tipo AND t.Nombre_Tipo='C'
GROUP BY per.Telefono_Persona,per.Nombre_Persona
ORDER BY CantidadP desc
limit 1;


-- (2) Mostrar el número de mes de la fecha de registro, nombre y apellido de todos los clientes que más han comprado y los que menos han comprado (en dinero) utilizando una sola consulta.

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

-- (4) Mostrar el nombre del proveedor, número de teléfono, número de orden, total de la orden por la cual se haya obtenido la menor cantidad de producto. DUDA DE QUE ES NECESARIO PONER CATEGORIA? 
select per.Nombre_Persona,per.Telefono_Persona,tr.ID_Transaccion,sum(tr.Total_Transaccion)as Total_Orden, tr.Cantidad as Cant_Orden
from Persona per,Transaccion tr,Producto prod,Categoria cat,Tipo tip
where per.ID_Persona=tr.ID_Persona and prod.Id_Producto=tr.Id_Producto
and cat.Id_Categoria=prod.Id_Categoria AND tip.ID_Tipo=per.ID_Tipo AND tip.Nombre_Tipo='P'
group by per.Telefono_Persona,per.Nombre_Persona, tr.Id_Transaccion,Cant_Orden
order by Cant_Orden asc 
limit 20;

-- (5) Mostrar el top 10 de los clientes que más productos han comprado de la categoría ‘Seafood’.
SELECT per.Nombre_Persona,cat.Nombre_Categoria,SUM(tr.Cantidad) as Cantidad_Compra
FROM Persona per,Transaccion tr,Producto prod,Categoria cat,Tipo tip
WHERE per.ID_Persona=tr.ID_Persona AND tip.ID_Tipo=per.ID_Tipo AND cat.ID_Categoria=prod.ID_Categoria
AND prod.ID_Producto=tr.ID_Producto AND tip.Nombre_Tipo='C' AND cat.Nombre_Categoria='Seafood'
GROUP BY per.Nombre_Persona,cat.Nombre_Categoria
ORDER BY Cantidad_Compra desc
LIMIT 10;

-- (6) Mostrar el porcentaje de clientes que le corresponden a cada región.
SELECT reg.Nombre_Region, count(per.Nombre_Persona) AS Cantidad_Personas ,(count(per.Nombre_Persona)*100/
 ( select count(per.Nombre_Persona) as Nombre from Persona per,Tipo tip
where tip.ID_Tipo=per.ID_Tipo AND tip.Nombre_Tipo='C')
 ) AS Porcentaje
FROM Persona per,Tipo tip,Region reg,Ciudad cui,Codigo_Postal codp
WHERE reg.ID_Region=cui.ID_Region AND cui.ID_Ciudad=codp.ID_Ciudad 
AND codp.ID_Codigo_Postal=per.ID_Codigo_Postal AND tip.ID_Tipo=per.ID_Tipo AND tip.Nombre_Tipo='C'
GROUP BY reg.Nombre_Region
ORDER BY reg.Nombre_Region;


-- (7) Mostrar las ciudades en donde más se consume el producto “Tortillas” de la categoría “Refrigerated Items”.
SELECT ciu.Nombre_Ciudad,SUM(tr.Cantidad) AS Cantidad,pro.Nombre_Producto AS Producto
FROM Ciudad ciu,Codigo_Postal codp,Persona per,Transaccion tr,Producto pro,Categoria cat,Tipo tip
WHERE ciu.ID_Ciudad=codp.ID_Ciudad AND codp.ID_Codigo_Postal=per.ID_Codigo_Postal AND tip.ID_Tipo=per.ID_Tipo
AND per.ID_Persona=tr.ID_Persona  AND cat.ID_Categoria=pro.ID_Categoria AND pro.ID_Producto =tr.ID_Producto
AND pro.Nombre_Producto='Tortillas' AND cat.Nombre_Categoria='Refrigerated Items' and tip.Nombre_Tipo='C'
GROUP BY ciu.Nombre_Ciudad
ORDER BY Cantidad desc;


-- (8) Mostrar la cantidad de clientes que hay en las ciudades agrupadas por su letra inicial, es decir, agrupar las ciudades con A y mostrar la cantidad de clientes, lo mismo para las que inicien con B y así sucesivamente.
SELECT ciu.Nombre_Ciudad ,COUNT(per.Nombre_Persona) as Cantidad_Clientes
FROM Persona per,Ciudad ciu,Codigo_Postal codp,Tipo tip
WHERE ciu.ID_Ciudad=codp.ID_Ciudad AND codp.ID_Codigo_Postal=per.ID_Codigo_Postal 
AND tip.ID_Tipo=per.ID_Tipo AND tip.Nombre_Tipo='C'
GROUP BY ciu.Nombre_Ciudad
ORDER BY ciu.Nombre_Ciudad ASC;


-- (9) Mostrar el porcentaje de las categorías más vendidas de cada ciudad de la siguiente manera: Ciudad, Categoría,              Porcentaje De Mercado

SELECT ciu.Nombre_Ciudad,cat.Nombre_Categoria ,COUNT(tr.Cantidad) AS Cantidad
FROM Ciudad ciu,Codigo_Postal codp,Persona per,Transaccion tr,Categoria cat,Producto prod
WHERE ciu.ID_Ciudad=codp.ID_Ciudad AND codp.ID_Codigo_Postal=per.ID_Codigo_Postal
AND per.ID_Persona=tr.ID_Persona AND cat.ID_Categoria=prod.ID_Categoria AND prod.ID_Producto=tr.ID_Producto
GROUP BY  ciu.Nombre_Ciudad,cat.Nombre_Categoria
HAVING Max(tr.Cantidad)
ORDER BY ciu.Nombre_Ciudad,Cantidad DESC;


-- (10) Mostrar los clientes que hayan consumido más que el promedio que consume la ciudad de Frankfort.
select ciu.Nombre_Ciudad,sum(tr.Cantidad) as Total,per.Nombre_Persona as Cant_Cliente
from Ciudad ciu,Codigo_Postal codp,Transaccion tr,Persona per,Tipo tip
where ciu.ID_Ciudad=codp.ID_Ciudad AND codp.ID_Codigo_Postal=per.ID_Codigo_Postal
AND per.ID_Persona =tr.ID_Persona AND tip.ID_Tipo=per.ID_Tipo AND tip.Nombre_Tipo='C' AND ciu.Nombre_Ciudad='Frankfort'
group by ciu.Nombre_Ciudad,per.Nombre_Persona
order by Total desc ;



















