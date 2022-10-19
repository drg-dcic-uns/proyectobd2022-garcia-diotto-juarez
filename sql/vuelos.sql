CREATE DATABASE vuelos;
USE vuelos;

CREATE TABLE ubicaciones (
pais VARCHAR(20) NOT NULL,
estado VARCHAR(20) NOT NULL,
ciudad VARCHAR(20) NOT NULL,
huso TINYINT NOT NULL,
CONSTRAINT chk_huso check(huso between -12 and 12),

CONSTRAINT pk_ubicaciones
PRIMARY KEY (pais,estado,ciudad)
) ENGINE=InnoDB;

CREATE TABLE modelos_avion (
modelo VARCHAR(20) NOT NULL,
fabricante VARCHAR(20) NOT NULL,
cabinas SMALLINT UNSIGNED NOT NULL,
cant_asientos SMALLINT UNSIGNED NOT NULL,

CONSTRAINT pk_modelos_avion 
PRIMARY KEY (modelo)
) ENGINE=InnoDB;

CREATE TABLE clases (
nombre VARCHAR(20) NOT NULL,
porcentaje DECIMAL(2,2) UNSIGNED NOT NULL, 
constraint chk_porcentaje check (porcentaje BETWEEN 0 AND 0.99),

CONSTRAINT pk_clases 
PRIMARY KEY (nombre)
) ENGINE=InnoDB;

CREATE TABLE comodidades (
codigo INT UNSIGNED NOT NULL,
descripcion TEXT NOT NULL,

CONSTRAINT pk_comodidades
PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE aeropuertos (
codigo VARCHAR(45) NOT NULL,
nombre VARCHAR(40) NOT NULL,
telefono VARCHAR(15) NOT NULL,
direccion VARCHAR(30) NOT NULL,
pais VARCHAR(20) NOT NULL,
estado VARCHAR(20) NOT NULL,
ciudad VARCHAR(20) NOT NULL,

CONSTRAINT pk_aeropuertos 
PRIMARY KEY (codigo),

CONSTRAINT FK_aeropuertos_ubicaciones 
FOREIGN KEY (pais,estado,ciudad) REFERENCES ubicaciones (pais,estado,ciudad)
ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE vuelos_programados (
numero VARCHAR(10) NOT NULL,
aeropuerto_salida VARCHAR(45) NOT NULL,
aeropuerto_llegada VARCHAR(45) NOT NULL,

CONSTRAINT pk_vuelos_programados 
PRIMARY KEY (numero),

CONSTRAINT FK_vuelos_programados_salida_aeropuertos 
FOREIGN KEY (aeropuerto_salida) REFERENCES aeropuertos (codigo)
ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT FK_vuelos_programados_llegada_aeropuertos 
FOREIGN KEY (aeropuerto_llegada) REFERENCES aeropuertos (codigo)
ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE pasajeros (
doc_tipo VARCHAR(45) NOT NULL,
apellido VARCHAR(20) NOT NULL,
nombre VARCHAR(20) NOT NULL,
direccion VARCHAR(40) NOT NULL,
telefono VARCHAR(15) NOT NULL,
nacionalidad VARCHAR(20) NOT NULL,
doc_nro INT UNSIGNED NOT NULL,

CONSTRAINT pk_pasajeros
PRIMARY KEY (doc_tipo,doc_nro)
) ENGINE=InnoDB;

CREATE TABLE empleados(
legajo INT unsigned NOT NULL,
password VARCHAR(32) NOT NULL,
doc_tipo VARCHAR(45) NOT NULL,
doc_nro INT unsigned NOT NULL,
apellido VARCHAR(20) NOT NULL,
nombre VARCHAR(20) NOT NULL,
direccion VARCHAR(40) NOT NULL,
telefono VARCHAR(15) NOT NULL,

CONSTRAINT pk_empleados
PRIMARY KEY(legajo)
) ENGINE=InnoDB;

CREATE TABLE salidas (
dia ENUM('Do','Lu','Ma','Mi','Ju','Vi','Sa'),
vuelo VARCHAR(10) NOT NULL,
hora_llega TIME NOT NULL,
hora_sale TIME NOT NULL,
modelo_avion VARCHAR(20) NOT NULL,

CONSTRAINT pk_salidas
PRIMARY KEY(dia,vuelo),

CONSTRAINT FK_salidas_vuelos_programados
FOREIGN KEY (vuelo) references vuelos_programados(numero)
	ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT FK_salidas_modelos_avion
FOREIGN KEY (modelo_avion) references modelos_avion(modelo)
	ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE brinda (
dia ENUM('Do','Lu','Ma','Mi','Ju','Vi','Sa'),
vuelo VARCHAR(10) NOT NULL,
clase VARCHAR(20) NOT NULL,
precio DECIMAL (7,2) UNSIGNED NOT NULL, 
cant_asientos SMALLINT UNSIGNED NOT NULL,

CONSTRAINT pk_brinda
PRIMARY KEY (vuelo,dia,clase),

CONSTRAINT FK_brinda_salidas
FOREIGN KEY(dia,vuelo) references salidas(dia,vuelo)
ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT FK_brinda_clases
FOREIGN KEY(clase) references clases(nombre)
ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE instancias_vuelo(
dia ENUM('Do','Lu','Ma','Mi','Ju','Vi','Sa') NOT NULL,
vuelo VARCHAR(10) NOT NULL,
fecha DATE NOT NULL,
estado VARCHAR(15),

CONSTRAINT pk_instancias_vuelo
PRIMARY KEY(vuelo,fecha),

CONSTRAINT FK_instancias_vuelo_salidas
FOREIGN KEY (dia,vuelo) references salidas(dia,vuelo)
	ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE reservas ( 
numero INT unsigned NOT NULL AUTO_INCREMENT,
fecha DATE NOT NULL,
vencimiento DATE NOT NULL, 
estado VARCHAR(15) NOT NULL,
legajo INT unsigned NOT NULL,
doc_tipo VARCHAR(45) NOT NULL,
doc_nro INT unsigned NOT NULL,

CONSTRAINT pk_reservas
PRIMARY KEY(numero),

CONSTRAINT FK_reservas_pasajeros
FOREIGN KEY(doc_tipo,doc_nro) references pasajeros(doc_tipo,doc_nro)
	ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FK_reservas_empleados
FOREIGN KEY(legajo) references empleados(legajo)
	ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE asientos_reservados(
vuelo VARCHAR(10) NOT NULL,
fecha DATE NOT NULL,
clase VARCHAR(20) NOT NULL,
cantidad SMALLINT UNSIGNED NOT NULL,

CONSTRAINT pk_asientos_reservados
PRIMARY KEY(vuelo,fecha,clase),

CONSTRAINT FK_asientos_reservados_instancias_vuelo
FOREIGN KEY(vuelo,fecha) references instancias_vuelo(vuelo,fecha)
ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT FK_asientos_reservados_clases
FOREIGN KEY(clase) references clases(nombre)
ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;


CREATE TABLE posee (
clase VARCHAR(20) NOT NULL,
comodidad INT unsigned NOT NULL,

CONSTRAINT pk_posee
PRIMARY KEY(clase, comodidad),

CONSTRAINT FK_posee_clases
FOREIGN KEY(clase) references clases(nombre)
	ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT FK_posee_comodidades
FOREIGN KEY(comodidad) references comodidades(codigo)
	ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;


CREATE TABLE reserva_vuelo_clase (
numero INT unsigned NOT NULL,
vuelo VARCHAR(10) NOT NULL,
fecha_vuelo DATE NOT NULL,
clase VARCHAR(20) NOT NULL,

CONSTRAINT pk_reserva_vuelo_clase
PRIMARY KEY(numero,vuelo,fecha_vuelo),

CONSTRAINT FK_reserva_vuelo_clase_reservas
FOREIGN KEY(numero) references reservas(numero)
	ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FK_reserva_vuelo_clase_instancias_vuelo
FOREIGN KEY(vuelo,fecha_vuelo) references instancias_vuelo(vuelo,fecha)
	ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT FK_reserva_vuelo_clase_clases
FOREIGN KEY(clase) references clases(nombre)
	ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;


#------------------------------------------------------------------------------
#Usuarios

CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';

GRANT ALL PRIVILEGES ON vuelos.* TO 'admin'@'localhost' WITH GRANT OPTION;


CREATE USER 'empleado'@'%' IDENTIFIED BY 'empleado';
 
GRANT SELECT ON vuelos.* TO 'empleado'@'%';
GRANT INSERT,UPDATE,DELETE ON vuelos.reservas TO 'empleado'@'%';
GRANT INSERT,UPDATE,DELETE ON vuelos.pasajeros TO 'empleado'@'%';
GRANT INSERT,UPDATE,DELETE ON vuelos.reserva_vuelo_clase TO 'empleado'@'%';


CREATE USER 'cliente'@'%' IDENTIFIED BY 'cliente';

CREATE VIEW vuelos_disponibles AS 
 SELECT 
s.vuelo AS 'nro_vuelo',s.modelo_avion AS 'modelo',i_v.fecha AS 'fecha',s.dia AS 'dia_sale',s.hora_sale AS 'hora_sale',s.hora_llega AS 'hora_llega',
SUBTIME (s.hora_llega ,s.hora_sale) AS 'tiempo_estimado',
aSale.codigo AS 'codigo_aero_sale',aLlega.codigo AS 'codigo_aero_llega',
aSale.nombre AS 'nombre_aero_sale',aLlega.nombre AS 'nombre_aero_llega',
aSale.ciudad AS 'ciudad_sale',aLlega.ciudad AS 'ciudad_llega',
aSale.estado AS 'estado_sale',aLlega.estado AS 'estado_llega',
aSale.pais AS 'pais_sale',aLlega.pais AS 'pais_llega',
b.precio AS 'precio',(round(b.cant_asientos + (c.porcentaje * b.cant_asientos)) - a_r.cantidad) AS 'asientos_disponibles',b.clase AS 'clase'

 FROM 
   (((((instancias_vuelo i_v JOIN salidas s ON (i_v.vuelo=s.vuelo AND i_v.dia=s.dia))
   JOIN vuelos_programados v_p ON (s.vuelo=v_p.numero))
   JOIN aeropuertos aSale ON (v_p.aeropuerto_salida=aSale.codigo)) 
   JOIN aeropuertos aLlega ON (v_p.aeropuerto_llegada=aLlega.codigo)
   JOIN brinda b ON (s.vuelo=b.vuelo AND s.dia=b.dia)) 
   JOIN clases c ON (b.clase=c.nombre))
   JOIN asientos_reservados a_r ON (i_v.fecha=a_r.fecha AND i_v.vuelo=a_r.vuelo AND a_r.clase=c.nombre);

GRANT SELECT ON vuelos.vuelos_disponibles TO 'cliente'@'%';




