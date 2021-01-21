CREATE DATABASE Enunciado3;
USE Enunciado3;

CREATE TABLE IF NOT EXISTS Desaparicion(
ID_Desaparicion INT NOT NULL AUTO_INCREMENT,
Color_Piel_Desaparecido VARCHAR(20) NOT NULL,
Color_Cabello_Desaparecido VARCHAR(20) NOT NULL,
Profesion VARCHAR(40) NOT NULL,
Edad INT NOT NULL,
Altura INT NOT NULL,
Etnia VARCHAR(20) NOT NULL,
PRIMARY KEY(ID_Desaparicion)
)ENGINE=InnoDB;'sólo existe soporte para claves foráneas en tablas de tipo InnoDB.'


CREATE TABLE IF NOT EXISTS Victima(
ID_Victima INT NOT NULL AUTO_INCREMENT,
Nombre VARCHAR(40) NOT NULL,
Apellido VARCHAR(40) NOT NULL,
Edad INT NOT NULL,
Fecha_Nacimiento DATE NOT NULL,
Lugar_Nacimiento VARCHAR(40) NOT NULL,
Recidencia_Actual VARCHAR(40) NOT NULL,
Telefono INT NOT NULL,
PRIMARY KEY(ID_Victima)
)ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS No_Reconocido(
ID_No_Reconocido INT NOT NULL AUTO_INCREMENT,
Ubicacion_Hallazgo VARCHAR(40) NOT NULL,
Altura_Calculada INT NOT NULL,
Edad_Calculada INT NOT NULL,
Objetos_Poseidos VARCHAR(100) NOT NULL,
PRIMARY KEY(ID_No_Reconocido),
FOREIGN KEY(ID_Victima) REFERENCES Victima(ID_Victima)
ON DELETE NO ACTION
)ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS Denuncia(
ID_Denuncia INT NOT NULL AUTO_INCREMENT,
Fecha_Denuncia DATE NOT NULL,
Fecha_Ultimo _Conocimiento DATE NOT NULL,
Nombre_Denunciante VARCHAR(30) NOT NULL,
Apellido_Denunciante VARCHAR(30) NOT NULL,
ADN_Denunciante VARCHAR(30) NOT NULL,
PRIMARY KEY(ID_Denuncia),
FOREIGN KEY(ID_Victima) REFERENCES Victima(ID_Victima),
FOREIGN KEY(ID_Desaparicion) REFERENCES Desaparicion(ID_Desaparicion)
ON DELETE NO ACTION
)ENGINE=InnoDB;




