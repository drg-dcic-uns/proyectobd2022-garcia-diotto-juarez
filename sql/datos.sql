USE vuelos;

INSERT INTO modelos_avion VALUES ("modelo1","FADEA",1,200);
INSERT INTO modelos_avion VALUES ("modelo2","FADEA",1,220);
INSERT INTO modelos_avion VALUES ("modelo3","FADEA",1,256);

INSERT INTO ubicaciones VALUES ("Argentina","Buenos Aires","Bahia Blanca",-3);
INSERT INTO ubicaciones VALUES ("Argentina","Buenos Aires","Buenos Aires",-3);
INSERT INTO ubicaciones VALUES ("Bolivia","La Paz","La Paz",-4);

INSERT INTO comodidades VALUES (1000,"semicama");
INSERT INTO comodidades VALUES (2000,"cama");
INSERT INTO comodidades VALUES (3000,"cama+television");

INSERT INTO clases VALUES ("Turista",0.6);
INSERT INTO clases VALUES ("Ejecutiva",0.2);
INSERT INTO clases VALUES ("Primera",0.1);

INSERT INTO aeropuertos VALUES ("BHI","Comandante Espora","0291 486-0319","Ex Ruta 3 Norte KM 675","Argentina","Buenos Aires","Bahia Blanca");
INSERT INTO aeropuertos VALUES ("AEP","Jorge Newbery","011 5480-6111","Av. Costanera Rafael Obligado","Argentina","Buenos Aires","Buenos Aires");
INSERT INTO aeropuertos VALUES ("LPB","El Alto","591 2 2157300","Huascar 204","Bolivia","La Paz","La Paz");

INSERT INTO vuelos_programados VALUES ("10000","BHI","AEP");
INSERT INTO vuelos_programados VALUES ("20000","AEP","LPB");
INSERT INTO vuelos_programados VALUES ("30000","LPB","AEP");

INSERT INTO empleados VALUES (100,MD5("12345"),"DNI",22900143,"Sanchez","Carlos","Av.Colon 100","291 123-4567");
INSERT INTO empleados VALUES (101,MD5("123456"),"DNI",22057189,"Rafael","Jorge","San Martin 514","291 872-9259"); /*Empleado pasajero*/
INSERT INTO empleados VALUES (102,MD5("1234567"),"DNI",43179965,"Pereyra","Roberto","Sarratea 1054","291 875-9260");

INSERT INTO pasajeros VALUES ("DNI","Rafael","Jorge","San Martin 514","291 872-9259","Argentina",22057189);
INSERT INTO pasajeros VALUES ("DNI","Garcia","Tomas","Dragado 1875","291 590-1453","Argentina",49210982);
INSERT INTO pasajeros VALUES ("DNI","Peralta","Maria","Alem 1290","291 289-7204","Argentina",18390876);

INSERT INTO salidas VALUES ("Do","10000","09:10","08:00","modelo1");
INSERT INTO salidas VALUES ("Mi","20000","20:00","15:00","modelo2");
INSERT INTO salidas VALUES ("Vi","30000","23:00","18:00","modelo3"); 

INSERT INTO brinda VALUES ("Vi","30000","Turista",10000.99,256);
INSERT INTO brinda VALUES ("Do","10000","Ejecutiva",25600.01,200);
INSERT INTO brinda VALUES ("Mi","20000","Turista",12000.50,220);

INSERT INTO reservas(fecha,vencimiento,estado,legajo,doc_tipo,doc_nro) VALUES ("2022-04-22","2023-12-04","confirmada",100,"DNI",22057189);
INSERT INTO reservas(fecha,vencimiento,estado,legajo,doc_tipo,doc_nro) VALUES ("2022-01-22","2023-07-12","en espera",101,"DNI",49210982);
INSERT INTO reservas(fecha,vencimiento,estado,legajo,doc_tipo,doc_nro) VALUES ("2021-09-22","2022-11-29","pagada",102,"DNI",18390876);

INSERT INTO instancias_vuelo VALUES("Do","10000","2022-12-10","a tiempo");
INSERT INTO instancias_vuelo VALUES("Mi","20000","2022-12-10","cancelado");
INSERT INTO instancias_vuelo (dia,vuelo,fecha) VALUES("Vi","30000","2022-12-10"); /*Estado nulo*/

INSERT INTO asientos_reservados VALUES("10000","2022-12-10","Ejecutiva",100);
INSERT INTO asientos_reservados VALUES("20000","2022-12-10","Turista",120); 
INSERT INTO asientos_reservados VALUES("30000","2022-12-10","Turista",256); /*Misma cantidad de asientos reservados que los que tiene el avión*/

INSERT INTO posee VALUES ("Turista",1000);
INSERT INTO posee VALUES ("Ejecutiva",2000);
INSERT INTO posee VALUES ("Primera",3000);

INSERT INTO reserva_vuelo_clase VALUES (1,"10000","2022-12-10","Ejecutiva");
INSERT INTO reserva_vuelo_clase VALUES (2,"20000","2022-12-10","Turista");
INSERT INTO reserva_vuelo_clase VALUES (3,"20000","2022-12-10","Turista");
