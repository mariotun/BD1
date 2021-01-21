

-- ************************************************* REPORTES************************************************************

-- (1) Desplegar el nombre de cada jefe seguido de todos sus subalternos, para todos los profesionales ordenados
-- por el jefe alfabéticamente
SELECT ass.Nombre_Area, ass.Nombre_Profesional, (CASE WHEN COUNT(*) = 2 THEN 1 ELSE 0 END) AS Jefe FROM (
SELECT a.Nombre_Area, p.Nombre_Profesional 
FROM Profesional p
JOIN Profesional_Area pa ON p.ID_Profesional = pa.ID_Profesional
JOIN Area a ON a.ID_Area = pa.ID_Area AND a.ID_Profesional = p.ID_Profesional
UNION ALL
SELECT a.Nombre_Area, p.Nombre_Profesional 
FROM Profesional p
JOIN Profesional_Area pa ON p.ID_Profesional = pa.ID_Profesional
JOIN Area a ON a.ID_Area = pa.ID_Area) AS ass 
GROUP BY ass.Nombre_Area, ass.Nombre_Profesional 
ORDER BY ass.Nombre_Area;

-- (2) Desplegar todos los profesionales, y su salario cuyo salario es mayor al promedio del salario de los
-- profesionales en su misma área.

SELECT a.Nombre_Area, a.Nombre_Profesional,a.ID_Area,a.Salario,b.Promedio 
FROM (SELECT a.Nombre_Area,p.Nombre_Profesional,a.ID_Area,p.Salario FROM Profesional p
JOIN Profesional_Area pa ON p.ID_Profesional = pa.ID_Profesional
JOIN Area a ON a.ID_Area = pa.ID_Area ) as a, (SELECT a.ID_Area, SUM(p.Salario)/COUNT(p.Salario) as promedio FROM Profesional p
JOIN Profesional_Area pa ON p.ID_Profesional = pa.ID_Profesional
JOIN Area a ON a.ID_Area = pa.ID_Area GROUP BY a.ID_Area) as  b
where a.ID_Area = b.ID_Area
and a.Salario > b.Promedio;

-- (3) Desplegar la suma del área de todos los países agrupados por la inicial de su nombre.*/
SELECT substring(Nombre_Pais, 1,1) Letra_Paises, SUM(AreaKm2) Suma_Areas FROM Pais
GROUP BY substring(Nombre_Pais, 1,1)
ORDER BY substring(Nombre_Pais, 1,1);

-- (4) Desplegar el nombre de todos los inventores que Inicien con B y terminen con r o con n que tengan inventos del siglo 19
SELECT i.Nombre_Inventor, inven.Nombre_Invento, inven.Anio_Invento FROM Inventor i
JOIN Inventado inv ON i.ID_Inventor = inv.ID_Inventor
JOIN Invento inven ON inv.ID_Invento = inven.ID_Invento
WHERE upper( substring(i.Nombre_Inventor, 1,1)) = 'B'and (upper(substring(i.Nombre_Inventor, length(i.Nombre_Inventor),1)) = 'R'
OR upper(substring(i.Nombre_Inventor, length(i.Nombre_Inventor),1)) = 'N') AND substring(inven.Anio_Invento, 1,2)  = 18;

-- (5) Desplegar el nombre del país y el área de todos los países que tienen mas de siete
-- fronteras ordenarlos por el de mayor área
SELECT p.Nombre_Pais,p.AreaKm2, count(f.ID_Frontera) AS No_Fronteras FROM Frontera f
JOIN Pais p on f.ID_Pais = p.ID_Pais group by p.Nombre_Pais, p.AreaKm2
having count(f.ID_Frontera) > 7 order by p.AreaKm2 desc;

-- (6) (HACERLO EN CONSOLA) Desplegar el nombre del profesional, su salario, su comisión y el total de salario 
-- (sueldo mas comisión) de todos los profesionales con comisión mayor que el 25% de su salario.
SELECT p.Nombre_Profesional,p.Salario,IFNULL(p.Comision, 0) Comision, sum(p.Salario+ IFNULL(p.Comision, 0) ) total 
FROM Profesional p WHERE IFNULL(p.Comision, 0) > IFNULL(p.Salario, 0)*0.25
group by p.Nombre_Profesional;

-- (7) Desplegar los países cuya población sea mayor a la población de los países centroamericanos juntos.
SELECT p1.Nombre_Pais,p1.Poblacion_Pais from Pais p1  
WHERE  p1.Poblacion_Pais > 
(SELECT  sum(p.Poblacion_Pais) as Poblacion FROM Pais p JOIN Region r ON p.ID_Region = r.ID_Region
WHERE r.Nombre_Region = 'Centro America');

-- (8) Desplegar el nombre de todos los inventos inventados el mismo año que BENZ invento algún invento.
SELECT inven1.Nombre_Inventor,i1.Nombre_Invento,i1.Anio_Invento FROM Invento i1
JOIN Inventado inv1 ON i1.ID_Invento = inv1.ID_Invento 
JOIN Inventor inven1 ON inv1.ID_Inventor = inven1.ID_Inventor
WHERE i1.Anio_Invento  IN (SELECT i.Anio_Invento FROM Invento i
JOIN Inventado inv ON i.ID_Invento = inv.ID_Invento 
JOIN Inventor inven ON inv.ID_Inventor = inven.ID_Inventor
WHERE upper(inven.Nombre_Inventor) = 'BENZ');

-- (10) (HACERLO EN CONSOLA) Desplegar el nombre del profesional su salario y su comisión de los empleados cuyo 
-- salario es mayor que el doble de su comisión.
SELECT p.Nombre_Profesional,p.Salario,IFNULL(p.Comision, 0) Comision FROM Profesional p
WHERE IFNULL(p.Salario, 0) > IFNULL(p.Comision, 0)*2
GROUP BY p.Nombre_Profesional;



