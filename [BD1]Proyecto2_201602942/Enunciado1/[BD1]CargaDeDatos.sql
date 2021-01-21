
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

-- ********************************************* CONSULTAS PARA LLENAR EL MODELO *******************************************************

USE PY2_E1;

INSERT INTO Region (Nombre_Region) SELECT DISTINCT region FROM Temporal WHERE region IS NOT NULL;


INSERT INTO Tipo (Nombre_Tipo) SELECT DISTINCT tipo FROM Temporal WHERE tipo IS NOT NULL;
        
        
INSERT INTO Categoria (Nombre_Categoria) SELECT DISTINCT categoria_producto FROM Temporal WHERE categoria_producto IS NOT NULL;


INSERT INTO Compania (Nombre_Compania,Contacto_Compania,Correo_Compania,Telefono_Compania)
SELECT DISTINCT nombre_compania,contacto_compania,correo_compania,telefono_compania FROM Temporal
WHERE nombre_compania IS NOT NULL AND contacto_compania IS NOT NULL AND correo_compania IS NOT NULL AND telefono_compania IS NOT NULL;


INSERT INTO Ciudad (Nombre_Ciudad,Id_Region) SELECT DISTINCT T.ciudad, R.ID_Region FROM Temporal T LEFT JOIN Region R ON T.region = R.Nombre_Region WHERE T.ciudad IS NOT NULL;


INSERT INTO Codigo_Postal (Numero_Codigo_Postal,ID_Ciudad) SELECT DISTINCT T.codigo_postal, C.ID_Ciudad FROM Temporal T LEFT JOIN Ciudad C ON T.ciudad = C.Nombre_Ciudad WHERE T.codigo_postal IS NOT NULL; 


INSERT INTO Persona (Nombre_Persona,Correo_Persona,Telefono_Persona,Fecha_Registro,Direccion,ID_Codigo_Postal,ID_Tipo) SELECT DISTINCT T.nombre, T.correo, T.telefono, T.fecha_registro, T.direccion, tipo.ID_Tipo, p.ID_Codigo_Postal FROM Temporal T LEFT JOIN Tipo tipo ON T.tipo = tipo.Nombre_Tipo LEFT JOIN Codigo_Postal p ON T.codigo_postal = p.Numero_Codigo_Postal WHERE T.nombre IS NOT NULL AND T.telefono IS NOT NULL AND T.fecha_registro IS NOT NULL AND T.correo IS NOT NULL AND T.direccion IS NOT NULL;


INSERT INTO Producto (Nombre_Producto,Precio_Producto,ID_Categoria) SELECT DISTINCT T.producto, T.precio_unitario, c.id_categoria FROM Temporal T LEFT JOIN Categoria C ON T.categoria_producto = C.Nombre_Categoria WHERE T.producto IS NOT NULL AND T.precio_unitario IS NOT NULL;


INSERT INTO Transaccion (Cantidad,Total_Transaccion,ID_Compania,ID_Persona,ID_Producto) SELECT T.cantidad, (TO_NUMBER(p1.Precio_Producto)*TO_NUMBER(T.cantidad)),P1.ID_Producto,C.ID_Compania,P2.ID_Persona FROM Temporal T LEFT JOIN Producto P1 ON T.producto = P1.Nombre_Producto LEFT JOIN Persona P2 ON T.nombre = P2.Nombre_Persona LEFT JOIN Compania C ON T.nombre_compania = C.Nombre_Compania WHERE T.cantidad IS NOT NULL AND T.precio_unitario IS NOT NULL;








































