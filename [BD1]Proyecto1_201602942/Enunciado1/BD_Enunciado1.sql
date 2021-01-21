CREATE DATABASE Enunciado1;
USE Enunciado1;

CREATE TABLE IF NOT EXISTS Aseguradora(
ID_Aseguradora INT NOT NULL AUTO_INCREMENT,
Nombre_Aseguradora VARCHAR(40) NOT NULL,
Hora_de_Apertura VARCHAR(20) NOT NULL,
Hora_de_Cierre VARCHAR(20) NOT NULL,
PRIMARY KEY(ID_Aseguradora)
)ENGINE=InnoDB;'sólo existe soporte para claves foráneas en tablas de tipo InnoDB.'


CREATE TABLE IF NOT EXISTS Area(
ID_Area INT NOT NULL AUTO_INCREMENT,
Nombre_Area VARCHAR(30) NOT NULL,
Ubicacion_Aseguradora VARCHAR(30) NOT NULL,
PRIMARY KEY(ID_Area),
FOREIGN KEY(ID_Aseguradora) REFERENCES Aseguradora(ID_Aseguradora)
ON DELETE NO ACTION
)ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS Empleado(
ID_Empleado INT NOT NULL AUTO_INCREMENT,
DPI INT NOT NULL,
Nombre_Empleado VARCHAR(35) NOT NULL,
Apellido VARCHAR(35) NOT NULL,
Fecha_Nacimiento DATE NOT NULL, 
Fecha_Contratacion DATE NOT NULL,
Edad INT NOT NULL,
Telefono INT NOT NULL,
Salario INT NOT NULL,
Direccion VARCHAR(40) NOT NULL,
PRIMARY KEY(ID_Empleado),
FOREIGN KEY(ID_Area) REFERENCES Area(ID_Area)
)ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS Puesto_Empleado(
ID_Puesto INT NOT NULL AUTO_INCREMENT,
Nombre_Puesto VARCHAR(30) NOT NULL,
PRIMARY KEY(ID_Puesto),
FOREIGN KEY(ID_EMPLEADO) REFERENCES Empleado(ID_Empleado)
)ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS Departamento(
ID_Departamento INT NOT NULL AUTO_INCREMENT,
Nombre_Departamento VARCHAR(40) NOT NULL,
PRIMARY KEY(ID_Departamento),
FOREIGN KEY(ID_Area) REFERENCES Area(ID_Area)
ON DELETE NO ACTION
)ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS Funcion(
ID_Funcion INT NOT NULL AUTO_INCREMENT,
Nombre_Funcion VARCHAR(40) NOT NULL,
PRIMARY KEY(ID_Funcion),
FOREIGN KEY(ID_Departamento) REFERENCES Departamento(ID_Departamento)
)ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS Historial_Llamada(
ID_Historial INT NOT NULL AUTO_INCREMENT,
Nombre_Empleado VARCHAR(30) NOT NULL,
Nombre_Cliente VARCHAR(30) NOT NULL,
Telefono_Cliente INT NOT NULL,
Nombre_Seguro_Interesado VARCHAR(30) NOT NULL,
Fecha_Llamada DATE NOT NULL,
Hora_Llamada TIME NOT NULL,
Duracion_Llamada TIME NOT NULL
PRIMARY KEY(ID_Historial),
FOREIGN KEY(ID_Departamento) REFERENCE Departamento(ID_Departamento)
)ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS Cliente(
ID_Cliente INT NOT NULL AUTO_INCREMENT,
CUI INT NOT NULL,
Nombre_Cliente VARCHAR(35) NOT NULL,
Apellido_Cliente VARCHAR(35) NOT NULL,
Fecha_Nacimiento DATE NOT NULL,
Edad INT NOT NULL,
Telefono INT NOT NULL,
Correo VARCHAR(40) NOT NULL,
Direccion VARCHAR(40) NOT NULL,
PRIMARY KEY(ID_Cliente),
FOREIGN KEY(ID_Aseguradora) REFERENCES Aseguradora(ID_Aseguradora)
)ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS Seguro(
ID_Seguro INT NOT NULL AUTO_INCREMENT,
Nombre_Seguro VARCHAR(30) NOT NULL,
PRIMARY KEY(ID_Seguro),
FOREIGN KEY(ID_Aseguradora) REFERENCES Aseguradora(ID_Aseguradora)
)ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS Poliza(
ID_Poliza INT NOT NULL AUTO_INCREMENT,
Codigo_Poliza INT NOT NULL,
Empleado_Encargado_Proceso VARCHAR(35) NOT NULL,
Cliente_Adquirio_Seguro VARCHAR(35) NOT NULL, 
Monto_Poliza INT NOT NULL,
Tiempo_de_Pago VARCHAR(30) NOT NULL,'mes,trimeste,semestre,año'
Fecha_Inicio_Seguro DATE NOT NULL,
Fecha_Fin_Seguro DATE NOT NULL,
PRIMARY KEY(ID_Poliza),
FOREIGN KEY(ID_Seguro) REFERENCES Seguro(ID_Seguro)
)ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS Registro_Pago(
ID_Registro INT NOT NULL AUTO_INCREMENT,
Tarifa_Pagar INT NOT NULL,
Mora INT,'opcional, puede ser nulo'
Monto INT NOT NULL,
Forma_de_Pago VARCHAR(30) NOT NULL,'cheque,efectivo,tarjeta'
Fecha_de_Pago DATE NOT NULL,
Nombre_Cliente_Pago VARCHAR(35) NOT NULL,
Nombre_Empleado_Recibido_Pago VARCHAR(35) NOT NULL,
PRIMARY KEY(ID_Registro),
FOREIGN KEY(ID_Seguro) REFERENCES Seguro(ID_Seguro)
)ENGINE=InnoDB;



