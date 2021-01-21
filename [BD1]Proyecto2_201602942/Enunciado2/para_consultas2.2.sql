
CREATE DATABASE IF NOT EXISTS PY2_E2;
DROP DATABASE PY2_E2;

DROP TABLE IF EXISTS Temporal1;

-- *********************************************

USE PY2_E2;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Continente,Region,Pais,Frontera,Inventor,Invento,Inventado,Profesional,Area,Profesional_Area,Asigna_Invento,Encuesta,Pregunta
,Respuesta_Correcta,Respuesta,Pais_Respuesta;
SET FOREIGN_KEY_CHECKS = 1;

-- *********************************************
USE PY2_E2;

CREATE TABLE temporal1(
    invento TEXT,
    inventor TEXT,
    profesional_asignado_al_invento TEXT,
    el_profesional_es_jefe_de_area TEXT,
    fecha_contrato_profesional TEXT,
    salario TEXT,
    comision TEXT,
    area_invest_del_prof TEXT,
    renking TEXT,
    anio_del_invento TEXT,
    pais_del_invento TEXT,
    pais_del_inventor TEXT,
    region_del_pais TEXT,
    capital TEXT,
    poblacion_del_pais TEXT,
    area_en_km2 TEXT,
    frontera_con TEXT,
    norte TEXT,
    sur TEXT,
    este TEXT,
    oeste TEXT
);

CREATE TABLE temporal2(
    nombre_encuesta TEXT,
    pregunta TEXT,
    respuesta_posible TEXT,
    respuesta_correcta TEXT,
    pais TEXT,
    respuesta_pais TEXT,
    extra1 TEXT,
    extra2 TEXT,
    extra3 TEXT
);

CREATE TABLE temporal3(
    nombre_region TEXT,
    region_padre TEXT
);

-- **************************************************** LLENAR LAS TABLAS TEMPORALES ***************************************************

LOAD DATA LOCAL INFILE '/home/mario/Escritorio/Bases1/uno.csv'
REPLACE INTO TABLE temporal1
CHARACTER SET 'utf8'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\''
LINES TERMINATED BY '\n'
IGNORE 1 LINES
	(@invento1,
    @inventor2,
    @profesional_asignado_al_invento3,
    @el_profesional_es_jefe_de_area4,
    @fecha_contrato_profesional5,
    @salario6,
    @comision7,
    @area_invest_del_prof8,
    @renking9,
    @anio_del_invento10,
    @pais_del_invento11,
    @pais_del_inventor12,
    @region_del_pais13,
    @capital14,
    @poblacion_del_pais15,
    @area_en_km216,
    @frontera_con17,
    @norte18,
    @sur19,
    @este20,
    @oeste21)
SET
invento = nullif(@invento1,''),
inventor = nullif(@inventor2,''),
profesional_asignado_al_invento = nullif(@profesional_asignado_al_invento3,''),
el_profesional_es_jefe_de_area = nullif(@el_profesional_es_jefe_de_area4,''),
fecha_contrato_profesional = nullif(@fecha_contrato_profesional5,''),
salario = nullif(@salario6,''),
comision = nullif(@comision7,''),
area_invest_del_prof = nullif(@area_invest_del_prof8,''),
renking = nullif(@renking9,''),
anio_del_invento = nullif(@anio_del_invento10,''),
pais_del_invento = nullif(@pais_del_invento11,''),
pais_del_inventor = nullif(@pais_del_inventor12,''),
region_del_pais = nullif(@region_del_pais13,''),
capital = nullif(@capital14,''),
poblacion_del_pais = nullif(@poblacion_del_pais15,''),
area_en_km2 = nullif(@area_en_km216,''),
frontera_con = nullif(@frontera_con17,''),
norte = nullif(@norte18,''),
sur = nullif(@sur19,''),
este = nullif(@este20,''),
oeste = nullif(@oeste21,'')
;
-- ********************************************

LOAD DATA LOCAL INFILE '/home/mario/Escritorio/Bases1/dos.csv'
REPLACE INTO TABLE temporal2
CHARACTER SET 'utf8'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\''
LINES TERMINATED BY '\n'
IGNORE 1 LINES
	(@nombre_encuesta1,
    @pregunta2,
    @respuesta_posible3,
    @respuesta_correcta4,
    @pais5,
    @respuesta_pais6,
    @extra17,
    @extra28,
    @extra39)
SET
nombre_encuesta = nullif(@nombre_encuesta1,''),
pregunta = nullif(@pregunta2,''),
respuesta_posible = nullif(@respuesta_posible3,''),
respuesta_correcta = nullif(@respuesta_correcta4,''),
pais = nullif(@pais5,''),
respuesta_pais = nullif(@respuesta_pais6,''),
extra1 = nullif(@extra17,''),
extra2 = nullif(@extra28,''),
extra3 = nullif(@extra39,'')
;

-- ********************************************

LOAD DATA LOCAL INFILE '/home/mario/Escritorio/Bases1/tres.csv'
REPLACE INTO TABLE temporal3
CHARACTER SET 'utf8'
FIELDS TERMINATED BY ','
OPTIONALLY  ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- ********************************************* CREACION DEL MODELO RELACIONAL ********************************************************

CREATE TABLE IF NOT EXISTS Continente (
ID_Continente INT NOT NULL AUTO_INCREMENT,
Nombre_Continente VARCHAR(50) NOT NULL,
PRIMARY KEY (ID_Continente)
)ENGINE=InnoDB DEFAULT CHARACTER SET=UTF8MB4;


CREATE TABLE IF NOT EXISTS Region (
ID_Region INT NOT NULL AUTO_INCREMENT,
Nombre_Region VARCHAR(50) NOT NULL,
ID_Continente INT NULL,
PRIMARY KEY (ID_Region),
CONSTRAINT regionContinente
FOREIGN KEY (ID_Continente) REFERENCES Continente (ID_Continente)
ON DELETE NO ACTION
)ENGINE=InnoDB DEFAULT CHARACTER SET=UTF8MB4;


CREATE TABLE IF NOT EXISTS Pais (
ID_Pais INT NOT NULL AUTO_INCREMENT,
Nombre_Pais VARCHAR(50) NOT NULL,
Poblacion_Pais INT NOT NULL,
AreaKm2 INT NULL,
Capital VARCHAR(40) NOT NULL,
ID_Region INT,
PRIMARY KEY (ID_Pais),
CONSTRAINT regionPais
FOREIGN KEY (ID_Region) REFERENCES Region (ID_Region)
ON DELETE NO ACTION
)ENGINE = InnoDB DEFAULT CHARACTER SET = UTF8MB4;


CREATE TABLE IF NOT EXISTS Frontera (
ID_Frontera INT NOT NULL AUTO_INCREMENT,
Norte VARCHAR(10),
Sur VARCHAR(10),
Este VARCHAR(10),
Oeste VARCHAR(10),
Nombre_Pais VARCHAR(50) NOT NULL,
Nombre_Pais_Frontera VARCHAR(50) NOT NULL,
ID_Pais INT NOT NULL,
ID_Pais_Frontera INT NOT NULL,
PRIMARY KEY (ID_Frontera),
CONSTRAINT paisFrontera FOREIGN KEY (ID_Pais) REFERENCES Pais (ID_Pais)
ON DELETE NO ACTION,
CONSTRAINT paisFrontera2 FOREIGN KEY (ID_Pais_Frontera) REFERENCES Pais (ID_Pais)
ON DELETE NO ACTION
)ENGINE = InnoDB DEFAULT CHARACTER SET = UTF8MB4;  


CREATE TABLE IF NOT EXISTS Inventor (
ID_Inventor INT NOT NULL AUTO_INCREMENT,
Nombre_Inventor VARCHAR(50) NOT NULL,
ID_Pais INT NOT NULL,
PRIMARY KEY (ID_Inventor),
CONSTRAINT paisInvento FOREIGN KEY (ID_Pais) REFERENCES Pais (ID_Pais)
ON DELETE NO ACTION
)ENGINE = InnoDB DEFAULT CHARACTER SET = UTF8MB4;


CREATE TABLE IF NOT EXISTS Invento (
ID_Invento INT NOT NULL AUTO_INCREMENT,
Nombre_Invento VARCHAR(60) NOT NULL,
Anio_Invento INT NOT NULL,
PRIMARY KEY (ID_Invento)
)ENGINE = InnoDB DEFAULT CHARACTER SET = UTF8MB4;


CREATE TABLE IF NOT EXISTS Inventado (
ID_Inventado INT NOT NULL AUTO_INCREMENT,
ID_Invento INT NOT NULL,
ID_Inventor INT NOT NULL,
PRIMARY KEY (ID_Inventado),
CONSTRAINT inventoInventado FOREIGN KEY (ID_Invento) REFERENCES Invento (ID_Invento)
ON DELETE NO ACTION,
CONSTRAINT inventorInventado FOREIGN KEY (ID_Inventor) REFERENCES Inventor (ID_Inventor)
ON DELETE NO ACTION
)ENGINE = InnoDB DEFAULT CHARACTER SET = UTF8MB4;


CREATE TABLE IF NOT EXISTS Profesional (
ID_Profesional INT NOT NULL AUTO_INCREMENT,
Nombre_Profesional VARCHAR(60) NOT NULL,
Fecha_Contrato_Profesional DATE,
Salario INT NOT NULL,
Comision INT,
PRIMARY KEY (ID_Profesional)
)ENGINE = InnoDB DEFAULT CHARACTER SET = UTF8MB4;


CREATE TABLE IF NOT EXISTS Area (
ID_Area INT NOT NULL AUTO_INCREMENT,
Nombre_Area VARCHAR(60),
Ranking INT NOT NULL,
ID_Profesional INT NOT NULL,
PRIMARY KEY (ID_Area),
CONSTRAINT jefeArea FOREIGN KEY (ID_Profesional) REFERENCES Profesional (ID_Profesional)
ON DELETE NO ACTION
)ENGINE = InnoDB DEFAULT CHARACTER SET = UTF8MB4;


CREATE TABLE IF NOT EXISTS Profesional_Area (
ID_Profesional_Area INT NOT NULL AUTO_INCREMENT,
ID_Area INT NOT NULL,
ID_Profesional INT NOT NULL,
PRIMARY KEY (ID_Profesional_Area),
CONSTRAINT areaProfesionalArea FOREIGN KEY (ID_Area) REFERENCES Area (ID_Area)
ON DELETE NO ACTION,
CONSTRAINT profesionalProfesionalArea FOREIGN KEY (ID_Profesional) REFERENCES Profesional (ID_Profesional)
ON DELETE NO ACTION
)ENGINE = InnoDB DEFAULT CHARACTER SET = UTF8MB4;


CREATE TABLE IF NOT EXISTS Asigna_Invento (
ID_Asigna_Invento INT NOT NULL AUTO_INCREMENT,
ID_Profesional INT NOT NULL,
ID_Invento INT NOT NULL,
PRIMARY KEY (ID_Asigna_Invento),
CONSTRAINT profesionalAsignaInvento FOREIGN KEY (ID_Profesional) REFERENCES Profesional (ID_Profesional)
ON DELETE NO ACTION,
CONSTRAINT inventoAsignaInvento FOREIGN KEY (ID_Invento) REFERENCES Invento (ID_Invento)
ON DELETE NO ACTION
)ENGINE = InnoDB DEFAULT CHARACTER SET = UTF8MB4;


CREATE TABLE IF NOT EXISTS Encuesta (
ID_Encuesta INT NOT NULL AUTO_INCREMENT,
Nombre_Encuesta VARCHAR(80) NOT NULL,
PRIMARY KEY (ID_Encuesta)
)ENGINE = InnoDB DEFAULT CHARACTER SET = UTF8MB4;


CREATE TABLE IF NOT EXISTS Pregunta (
ID_Pregunta INT NOT NULL AUTO_INCREMENT,
Pregunta TEXT NOT NULL,
ID_Encuesta INT NOT NULL,
PRIMARY KEY (ID_Pregunta),
CONSTRAINT encuestaPregunta FOREIGN KEY (ID_Encuesta) REFERENCES Encuesta (ID_Encuesta)
ON DELETE NO ACTION
)ENGINE = InnoDB DEFAULT CHARACTER SET = UTF8MB4;


CREATE TABLE IF NOT EXISTS Respuesta_Correcta (
ID_Respuesta_Correcta INT NOT NULL AUTO_INCREMENT,
Respuesta_Correcta VARCHAR(122),
ID_Pregunta INT NOT NULL,
PRIMARY KEY (ID_Respuesta_Correcta),
CONSTRAINT preguntaRespuestaCOrrecta FOREIGN KEY (ID_Pregunta) REFERENCES Pregunta (ID_Pregunta)
ON DELETE NO ACTION
)ENGINE = InnoDB DEFAULT CHARACTER SET = UTF8MB4;


CREATE TABLE IF NOT EXISTS Respuesta (
ID_Respuesta INT NOT NULL AUTO_INCREMENT,
Respuesta TEXT NOT NULL,
ID_Pregunta INT NOT NULL,
PRIMARY KEY (ID_Respuesta),
CONSTRAINT preguntaRespuesta FOREIGN KEY (ID_Pregunta) REFERENCES Pregunta (ID_Pregunta)
ON DELETE NO ACTION
)ENGINE = InnoDB DEFAULT CHARACTER SET = UTF8MB4;


CREATE TABLE IF NOT EXISTS Pais_Respuesta (
ID_Pais_Respuesta INT NOT NULL AUTO_INCREMENT,
Respuesta_Pais VARCHAR(10) NOT NULL,
ID_Pais INT NOT NULL,
ID_Respuesta INT NOT NULL,
PRIMARY KEY (ID_Pais_Respuesta),
CONSTRAINT paisPaisRespuesta FOREIGN KEY (ID_Pais) REFERENCES Pais (ID_Pais)
ON DELETE NO ACTION,
CONSTRAINT respuestaPaisRespuesta FOREIGN KEY (ID_Respuesta) REFERENCES Respuesta (ID_Respuesta)
ON DELETE NO ACTION
)ENGINE = InnoDB DEFAULT CHARACTER SET = UTF8MB4;

-- ****************************** INSERCION DE REGISTROS DE TABLAS TEMPORALES AL MODELO RELACIONAL *********************************

USE PY2_E2;
DROP TABLE IF EXISTS Continente; 

INSERT INTO Continente(Nombre_Continente) SELECT DISTINCT region_padre FROM temporal3 WHERE region_padre IS NOT NULL;
select * from Continente ;

INSERT INTO Region(Nombre_Region,ID_Continente) SELECT DISTINCT nombre_region t3, ID_Continente c 
FROM temporal3 t3, Continente c WHERE c.Nombre_Continente = t3.region_padre;
select * from Region;

INSERT INTO Pais (Nombre_Pais,Poblacion_Pais,AreaKm2,Capital,ID_Region) SELECT DISTINCT(t1.pais_del_inventor), 
CAST(t1.poblacion_del_pais AS UNSIGNED),CAST(t1.area_en_km2 AS UNSIGNED),t1.capital,r.ID_Region FROM temporal1 t1
LEFT JOIN Region r on t1.region_del_pais = r.Nombre_Region;
select * from Pais ;

SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
INSERT INTO Frontera(Norte,Sur,Este,Oeste,Nombre_Pais,Nombre_Pais_Frontera,ID_Pais,ID_Pais_Frontera) 
SELECT  t1.norte,t1.sur,t1.este,t1.oeste,t1.pais_del_inventor,t1.frontera_con,p.ID_Pais,
(SELECT s.ID_Pais FROM Pais s,temporal1 t1 WHERE t1.frontera_con = s.Nombre_Pais  GROUP BY s.ID_Pais limit 1) AS idPaisFrontera 
FROM temporal1 t1 LEFT JOIN Pais p on t1.pais_del_inventor = p.Nombre_Pais 
WHERE t1.frontera_con IS NOT NULL 
GROUP BY t1.pais_del_inventor,t1.frontera_con;
select * From Frontera; 
-- GROUP BY t1.norte,t1.sur,t1.este,t1.oeste,t1.pais_del_inventor,t1.frontera_con,p.ID_Pais,idPaisFrontera;

INSERT INTO Inventor(Nombre_Inventor,ID_Pais) SELECT t1.inventor, p.ID_Pais FROM temporal1 t1 
LEFT JOIN Pais p ON t1.pais_del_inventor = p.Nombre_Pais WHERE t1.inventor IS NOT NULL GROUP BY t1.inventor;
select *from Inventor order by Inventor.Nombre_Inventor;

INSERT INTO Invento(Nombre_Invento,Anio_Invento) SELECT t1.invento,CAST(t1.anio_del_invento AS UNSIGNED) 
FROM temporal1 t1 WHERE t1.invento IS NOT NULL GROUP BY t1.invento, t1.anio_del_invento;
select *from Invento;

INSERT INTO Inventado(ID_Invento,ID_Inventor) SELECT i.ID_Invento,ir.ID_Inventor FROM temporal1 t1
JOIN Invento i ON t1.invento = i.Nombre_Invento JOIN Inventor ir ON t1.inventor = ir.Nombre_Inventor GROUP BY i.ID_Invento,ir.ID_Inventor;
select *from Inventado;

INSERT INTO Profesional(Nombre_Profesional,Fecha_Contrato_Profesional,Salario,Comision) 
SELECT t1.profesional_asignado_al_invento,CAST(t1.fecha_contrato_profesional AS DATE),CAST(t1.salario AS UNSIGNED),CAST(t1.comision AS UNSIGNED)
FROM temporal1 t1 WHERE t1.profesional_asignado_al_invento IS NOT NULL GROUP BY t1.profesional_asignado_al_invento;
select *from Profesional;

INSERT INTO Area(Nombre_Area,Ranking,ID_Profesional)
SELECT t1.area_invest_del_prof,CAST(t1.renking AS UNSIGNED),p.ID_Profesional FROM temporal1 t1
JOIN Profesional p ON t1.profesional_asignado_al_invento = p.Nombre_Profesional
WHERE t1.area_invest_del_prof IS NOT NULL
GROUP BY t1.area_invest_del_prof;
select * from Area;

INSERT INTO Profesional_Area(ID_Area,ID_Profesional) SELECT a.ID_Area,p.ID_Profesional FROM temporal1 t1
JOIN Area a ON t1.area_invest_del_prof=a.Nombre_Area JOIN Profesional p ON t1.profesional_asignado_al_invento = p.Nombre_Profesional
GROUP BY a.ID_Area,p.ID_Profesional;
select *from Profesional_Area;

INSERT INTO Asigna_Invento(ID_Profesional,ID_Invento)
SELECT p.ID_Profesional,i.ID_Invento FROM temporal1 t1
JOIN Profesional p ON t1.profesional_asignado_al_invento = p.Nombre_Profesional
JOIN Invento i ON  t1.invento = i.Nombre_Invento  GROUP BY p.ID_Profesional,i.ID_Invento;
select *from Asigna_Invento;

INSERT INTO Encuesta(Nombre_Encuesta) SELECT t2.nombre_encuesta FROM temporal2 t2 GROUP BY t2.nombre_encuesta;
select *from Encuesta;

INSERT INTO Pregunta(Pregunta,ID_Encuesta) SELECT t2.pregunta,e.ID_Encuesta FROM temporal2 t2
LEFT JOIN Encuesta e ON t2.nombre_encuesta = e.Nombre_Encuesta WHERE t2.pregunta IS NOT NULL GROUP BY t2.pregunta;
select *from Pregunta;

INSERT INTO Respuesta_Correcta(Respuesta_Correcta,ID_Pregunta) SELECT t2.respuesta_correcta, p.ID_Pregunta FROM temporal2 t2
LEFT JOIN Pregunta p ON t2.pregunta = p.Pregunta WHERE t2.respuesta_correcta IS NOT NULL GROUP BY t2.respuesta_correcta;
select *from Respuesta_Correcta;

INSERT INTO Respuesta(Respuesta,ID_Pregunta) SELECT t2.respuesta_posible, p.ID_Pregunta FROM temporal2 t2
LEFT JOIN Pregunta p ON t2.pregunta = p.Pregunta WHERE t2.respuesta_posible IS NOT NULL GROUP BY t2.respuesta_posible;
select *from Respuesta;

INSERT INTO Pais_Respuesta(Respuesta_Pais,ID_Pais,ID_Respuesta) SELECT t2.respuesta_pais,p.ID_Pais,r.ID_Respuesta FROM temporal2 t2
JOIN Pais p ON LTRIM(RTRIM(t2.pais)) = LTRIM(RTRIM(p.Nombre_Pais))
JOIN Respuesta r ON LTRIM(RTRIM(SUBSTRING(r.Respuesta,1,1))) = LTRIM(RTRIM(t2.respuesta_pais)) group by t2.respuesta_pais,p.ID_Pais, r.ID_Respuesta;
select * from Pais_Respuesta;

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
    
-- (6) Desplegar el nombre del profesional, su salario, su comisión y el total de salario 
-- (sueldo mas comisión) de todos los profesionales con comisión mayor que el 25% de su salario.(HACERLO EN CONSOLA)
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

-- (10) Desplegar el nombre del profesional su salario y su comisión de los empleados cuyo 
-- salario es mayor que el doble de su comisión.(HACERLO EN CONSOLA)
SELECT p.Nombre_Profesional,p.Salario,IFNULL(p.Comision, 0) Comision FROM Profesional p
WHERE IFNULL(p.Salario, 0) > IFNULL(p.Comision, 0)*2
GROUP BY p.Nombre_Profesional;


