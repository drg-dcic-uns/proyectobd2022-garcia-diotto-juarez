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

GRANT execute on procedure vuelos.reservaSoloIda to 'empleado'@'%';
GRANT execute on procedure vuelos.reservaIdaVuelta to 'empleado'@'%';


#----------------------------------------------------------------------------------------------------------------
#Stored Procedures

delimiter !
create procedure reservaSoloIda(IN nro_vuelo VARCHAR(10), IN fecha_vuelo DATE, IN clase VARCHAR(20), IN doc_tipo VARCHAR(45), IN doc_nro INT UNSIGNED, IN legajo INT UNSIGNED, OUT resultado INT)
begin
	DECLARE a_disponibles SMALLINT UNSIGNED;
	DECLARE a_reservados SMALLINT UNSIGNED;
	DECLARE cant_brinda SMALLINT UNSIGNED;
	DECLARE estadoR VARCHAR(15);
	DECLARE fecha_hoy DATE;
	DECLARE fecha_vencimiento DATE;
	DECLARE id_reserva INT;

	#Manejo de excepciones
	DECLARE codigo_SQL CHAR(5) DEFAULT '00000';
	DECLARE codigo_MYSQL INT DEFAULT 0;
	DECLARE mensaje_error TEXT;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1 codigo_MYSQL= MYSQL_ERRNO,
		codigo_SQL= RETURNED_SQLSTATE,
		mensaje_error= MESSAGE_TEXT;
		SELECT 'SQLEXCEPTION!, transaccion abortada' AS 'resultado',
		codigo_MySQL, codigo_SQL, mensaje_error;
		ROLLBACK;
	END;
	
	START TRANSACTION;
	SET resultado = -1;
	IF EXISTS (SELECT * FROM vuelos_disponibles vuelos WHERE nro_vuelo=vuelos.nro_vuelo AND fecha_vuelo=vuelos.fecha AND clase=vuelos.clase) THEN 	#Nos fijamos que exista el vuelo
		IF EXISTS (SELECT * FROM pasajeros p WHERE doc_tipo=p.doc_tipo AND doc_nro=p.doc_nro) THEN		#Nos fijamos que exista el pasajero
			SELECT cantidad INTO a_reservados 
			FROM asientos_reservados a_r WHERE nro_vuelo=a_r.vuelo AND clase=a_r.clase AND fecha_vuelo=a_r.fecha FOR UPDATE;		#Obtenemos los asientos reservados y bloqueamos la fila correspondiente
			SELECT asientos_disponibles INTO a_disponibles
			FROM vuelos_disponibles v_d WHERE nro_vuelo=v_d.nro_vuelo AND fecha_vuelo=v_d.fecha AND clase=v_d.clase;	#Obtenemos los asientos disponibles
			IF (a_disponibles>0) THEN
				SET fecha_hoy = CURDATE();
				SET fecha_vencimiento = DATE_SUB(fecha_vuelo, INTERVAL 15 DAY);		 
				SELECT cant_asientos INTO cant_brinda FROM brinda b WHERE nro_vuelo=b.vuelo AND clase=b.clase;
				IF(a_reservados<cant_brinda) THEN		#Determinamos el estado que corresponde, fijandonos si la cantidad de reservas es menor a la cantida de asientos que brinda
					SET estadoR = 'confirmada';
				ELSE
					SET estadoR = 'en espera';
				END IF;
				INSERT INTO reservas (fecha,vencimiento,estado,legajo,doc_tipo,doc_nro) VALUES (fecha_hoy,fecha_vencimiento,estadoR,legajo,doc_tipo,doc_nro);	#Realizamos la reserva
				SELECT DISTINCT last_insert_id() INTO id_reserva from reservas;
				INSERT INTO reserva_vuelo_clase VALUES (id_reserva,nro_vuelo,fecha_vuelo,clase);		#Asociamos la reserva a la instancia de vuelo
				UPDATE asientos_reservados a_r SET cantidad = cantidad + 1 WHERE nro_vuelo=a_r.vuelo AND fecha_vuelo=a_r.fecha AND clase=a_r.clase; #Aumentar la cantida de asientos reservados para la clase del vuelo en la fecha indicada
				SELECT 'La reserva se realizo con exito' AS 'resultado';
				SET resultado = id_reserva;
			ELSE
				SELECT 'Error: No hay lugares disponibles' AS 'resultado';
			END IF;
		ELSE
			SELECT 'Error: No existe un pasajero para los datos indicados' AS 'resultado';
		END IF;
	ELSE 
		SELECT 'Error: No existe un vuelo para los datos indicados' AS 'resultado';
	END IF;
	COMMIT;
end; !
delimiter ;

delimiter !
create procedure reservaIdaVuelta(IN nro_vueloIda VARCHAR(10), IN fecha_vueloIda DATE, IN claseIda VARCHAR(20), IN nro_vueloVuelta VARCHAR(10), IN fecha_vueloVuelta DATE, IN claseVuelta VARCHAR(20), IN doc_tipo VARCHAR(45), IN doc_nro INT UNSIGNED, IN legajo INT UNSIGNED, OUT resultado VARCHAR(50))
begin
    DECLARE a_disponiblesIda SMALLINT UNSIGNED;
    DECLARE a_disponiblesVuelta SMALLINT UNSIGNED;
	DECLARE a_reservadosIda SMALLINT UNSIGNED;
    DECLARE a_reservadosVuelta SMALLINT UNSIGNED;
	DECLARE cant_brindaIda SMALLINT UNSIGNED;
	DECLARE cant_brindaVuelta SMALLINT UNSIGNED;
	DECLARE estadoR VARCHAR(15);
	DECLARE fecha_hoy DATE;
	DECLARE fecha_vencimiento DATE;
	DECLARE id_reserva INT;

	#Manejo de excepciones
	DECLARE codigo_SQL CHAR(5) DEFAULT '00000';
	DECLARE codigo_MYSQL INT DEFAULT 0;
	DECLARE mensaje_error TEXT;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1 codigo_MYSQL= MYSQL_ERRNO,
		codigo_SQL= RETURNED_SQLSTATE,
		mensaje_error= MESSAGE_TEXT;
		SELECT 'SQLEXCEPTION!, transaccion abortada' AS 'resultado',
		codigo_MySQL, codigo_SQL, mensaje_error;
		ROLLBACK;
	END;
	
	START TRANSACTION;
	SET resultado = -1;
	IF EXISTS (SELECT * FROM vuelos_disponibles vuelos WHERE nro_vueloIda=vuelos.nro_vuelo AND fecha_vueloIda=vuelos.fecha AND claseIda=vuelos.clase) THEN 	#Nos fijamos que exista el vuelo de ida
	IF EXISTS (SELECT * FROM vuelos_disponibles vuelos WHERE nro_vueloVuelta=vuelos.nro_vuelo AND fecha_vueloVuelta=vuelos.fecha AND claseVuelta=vuelos.clase) THEN  #Nos fijamos que exista el vuelo de vuelta
		IF EXISTS (SELECT * FROM pasajeros p WHERE doc_tipo=p.doc_tipo AND doc_nro=p.doc_nro) THEN		#Nos fijamos que exista el pasajero
			SELECT cantidad INTO a_reservadosIda FROM asientos_reservados a_r WHERE nro_vueloIda=a_r.vuelo AND claseIda=a_r.clase AND fecha_vueloIda=a_r.fecha FOR UPDATE;			#Obtenemos los asientos reservados para la ida y vuelta y bloqueamos las filas
			SELECT cantidad INTO a_reservadosVuelta FROM asientos_reservados a_r WHERE nro_vueloVuelta=a_r.vuelo AND claseVuelta=a_r.clase AND fecha_vueloVuelta=a_r.fecha FOR UPDATE;
			SELECT asientos_disponibles INTO a_disponiblesIda
			FROM vuelos_disponibles v_d WHERE nro_vueloIda=v_d.nro_vuelo AND fecha_vueloIda=v_d.fecha AND claseIda=v_d.clase;	#Obtenemos los asientos disponibles en la ida
			SELECT asientos_disponibles INTO a_disponiblesVuelta
			FROM vuelos_disponibles v_d WHERE nro_vueloVuelta=v_d.nro_vuelo AND fecha_vueloVuelta=v_d.fecha AND claseVuelta=v_d.clase;	#Obtenemos los asientos disponibles en la vuelta
			IF (a_disponiblesIda>0) THEN
			IF (a_disponiblesVuelta>0) THEN
				SET fecha_hoy = CURDATE();
				SET fecha_vencimiento = DATE_SUB(fecha_vueloIda, INTERVAL 15 DAY);
				
				SELECT cant_asientos INTO cant_brindaIda FROM brinda b WHERE nro_vueloIda=b.vuelo AND claseIda=b.clase;
				SELECT cant_asientos INTO cant_brindaVuelta FROM brinda b WHERE nro_vueloVuelta=b.vuelo AND claseVuelta=b.clase;

				IF(a_reservadosIda<cant_brindaIda and a_reservadosVuelta<cant_brindaVuelta) THEN #Determinamos el estado que corresponde, fijandonos si la cantidad de reservas es menor a la cantida de asientos que brinda la ida y la vuelta
					SET estadoR = 'confirmada';
				ELSE
					SET estadoR = 'en espera';
				END IF;
				INSERT INTO reservas (fecha,vencimiento,estado,legajo,doc_tipo,doc_nro) VALUES (fecha_hoy,fecha_vencimiento,estadoR,legajo,doc_tipo,doc_nro);		#Relizamos la reserva
				SELECT DISTINCT last_insert_id() INTO id_reserva from reservas;
				INSERT INTO reserva_vuelo_clase VALUES (id_reserva,nro_vueloIda,fecha_vueloIda,claseIda);		#Asociamos la reserva a la instancia de vuelo de ida
				INSERT INTO reserva_vuelo_clase VALUES (id_reserva,nro_vueloVuelta,fecha_vueloVuelta,claseVuelta); #Asociamos la reserva a la instancia de vuelo de vuelta
				UPDATE asientos_reservados a_r SET cantidad = cantidad + 1 WHERE nro_vueloIda=a_r.vuelo AND fecha_vueloIda=a_r.fecha AND claseIda=a_r.clase; #Aumentar la cantida de asientos reservados para la clase del vuelo en la fecha indicada de ida
				UPDATE asientos_reservados a_r SET cantidad = cantidad + 1 WHERE nro_vueloVuelta=a_r.vuelo AND fecha_vueloVuelta=a_r.fecha AND claseVuelta=a_r.clase; #Aumentar la cantida de asientos reservados para la clase del vuelo en la fecha indicada de vuelta
				SELECT 'La reserva se realizo con exito' AS 'resultado';
				SET resultado = id_reserva;
			ELSE
				SELECT 'Error: No hay lugares disponibles en la vuelta' AS 'resultado';
			END IF;	
			ELSE
				SELECT 'Error: No hay lugares disponibles en la ida' AS 'resultado';
			END IF;
		ELSE
			SELECT 'Error: No existe un pasajero para los datos indicados' AS 'resultado';
		END IF;
	ELSE 
		SELECT 'Error: No existe un vuelo de vuelta para los datos indicados' AS 'resultado';
	END IF;
	ELSE 
		SELECT 'Error: No existe un vuelo de ida para los datos indicados' AS 'resultado';
	END IF;
	COMMIT;
end; !
delimiter ;

#---------------------------------------------------------------------------------------------------
#Trigger

delimiter !
CREATE TRIGGER inicializarReservas
	AFTER INSERT ON instancias_vuelo
	FOR EACH ROW
	BEGIN
		declare fin boolean default false;
		declare claseBrinda VARCHAR(20);
		declare C cursor for SELECT clase FROM brinda WHERE vuelo=NEW.vuelo;
		declare continue handler for not found set fin = true;
		open C;
		fetch C into claseBrinda;
		while not fin do
			INSERT INTO asientos_reservados(vuelo,fecha,clase,cantidad)
			VALUES(NEW.vuelo,NEW.fecha,claseBrinda,0);
			fetch C into claseBrinda;
		end while;
	close C;
END; !
delimiter ;
