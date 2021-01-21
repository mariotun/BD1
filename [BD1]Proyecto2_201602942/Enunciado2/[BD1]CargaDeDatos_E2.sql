

-- ************************************************* CREACION DE LAS TABLAS TEMPORALES ***************************************************

CREATE DATABASE IF NOT EXISTS PY2_E2;

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

-- ******************************************************

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

-- ******************************************************


CREATE TABLE temporal3(
    nombre_region TEXT,
    region_padre TEXT
);

LOAD DATA LOCAL INFILE '/home/mario/Escritorio/Bases1/tres.csv'
REPLACE INTO TABLE temporal3
CHARACTER SET 'utf8'
FIELDS TERMINATED BY ','
OPTIONALLY  ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- ****************************** INSERCION DE REGISTROS DE TABLAS TEMPORALES AL MODELO RELACIONAL ***************************************

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




