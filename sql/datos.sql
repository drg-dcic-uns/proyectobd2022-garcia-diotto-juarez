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
INSERT INTO vuelos_programados VALUES ("15000","AEP","BHI");
INSERT INTO vuelos_programados VALUES ("20000","AEP","LPB");
INSERT INTO vuelos_programados VALUES ("30000","LPB","AEP");
INSERT INTO vuelos_programados VALUES ("35000","BHI","AEP");
INSERT INTO vuelos_programados VALUES ("40000","AEP","BHI");

INSERT INTO empleados VALUES (100,MD5("12345"),"DNI",22900143,"Sanchez","Carlos","Av.Colon 100","291 123-4567");
INSERT INTO empleados VALUES (101,MD5("123456"),"DNI",22057189,"Rafael","Jorge","San Martin 514","291 872-9259"); /*Empleado pasajero*/
INSERT INTO empleados VALUES (102,MD5("1234567"),"DNI",43179965,"Pereyra","Roberto","Sarratea 1054","291 875-9260");

INSERT INTO pasajeros VALUES ("DNI","Rafael","Jorge","San Martin 514","291 872-9259","Argentina",22057189);
INSERT INTO pasajeros VALUES ("DNI","Garcia","Tomas","Dragado 1875","291 590-1453","Argentina",49210982);
INSERT INTO pasajeros VALUES ("DNI","Peralta","Maria","Alem 1290","291 289-7204","Argentina",18390876);

INSERT INTO salidas VALUES ("Do","10000","09:10","08:00","modelo1");
INSERT INTO salidas VALUES ("Mi","20000","20:00","15:00","modelo2");
INSERT INTO salidas VALUES ("Vi","30000","23:00","18:00","modelo3"); 
INSERT INTO salidas VALUES ("Ma","15000","15:00","17:00","modelo1");
INSERT INTO salidas VALUES ("Ju","35000","12:00","17:00","modelo2");
INSERT INTO salidas VALUES ("Lu","40000","07:00","10:15","modelo2");

INSERT INTO brinda VALUES ("Do","10000","Turista",9999,200);
INSERT INTO brinda VALUES ("Do","10000","Ejecutiva",15000.01,59);
INSERT INTO brinda VALUES ("Do","10000","Primera",25600.01,40);
INSERT INTO brinda VALUES ("Mi","20000","Turista",12000.50,220);
INSERT INTO brinda VALUES ("Mi","20000","Ejecutiva",18000.50,90);
INSERT INTO brinda VALUES ("Mi","20000","Primera",22000.50,30);
INSERT INTO brinda VALUES ("Vi","30000","Ejecutiva",20000,50);
INSERT INTO brinda VALUES ("Vi","30000","Primera",30000,10);
INSERT INTO brinda VALUES ("Vi","30000","Turista",10000.99,256);
INSERT INTO brinda VALUES ("Ju","35000","Ejecutiva",18000,20);
INSERT INTO brinda VALUES ("Ju","35000","Primera",35000,5);
INSERT INTO brinda VALUES ("Ju","35000","Turista",999.99,200);
INSERT INTO brinda VALUES ("Lu","40000","Ejecutiva",99999,55);
INSERT INTO brinda VALUES ("Lu","40000","Primera",30001,17);
INSERT INTO brinda VALUES ("Lu","40000","Turista",10099.99,150);


INSERT INTO reservas(fecha,vencimiento,estado,legajo,doc_tipo,doc_nro) VALUES ("2022-04-22","2023-12-04","confirmada",100,"DNI",22057189);
INSERT INTO reservas(fecha,vencimiento,estado,legajo,doc_tipo,doc_nro) VALUES ("2022-01-22","2023-07-12","en espera",101,"DNI",49210982);
INSERT INTO reservas(fecha,vencimiento,estado,legajo,doc_tipo,doc_nro) VALUES ("2021-09-22","2022-11-29","pagada",102,"DNI",18390876);

INSERT INTO instancias_vuelo VALUES("Do","10000","2022-12-10","a tiempo");
INSERT INTO instancias_vuelo VALUES("Mi","20000","2022-12-10","cancelado");
INSERT INTO instancias_vuelo (dia,vuelo,fecha) VALUES("Vi","30000","2022-12-10"); /*Estado nulo*/
INSERT INTO instancias_vuelo VALUES("Ma","15000","2022-12-20","a tiempo");
INSERT INTO instancias_vuelo VALUES("Ju","35000","2022-12-20","a tiempo");
INSERT INTO instancias_vuelo VALUES("Lu","40000","2022-12-20","demorado");

INSERT INTO asientos_reservados VALUES("10000","2022-12-10","Turista",100);
INSERT INTO asientos_reservados VALUES("10000","2022-12-10","Ejecutiva",19);
INSERT INTO asientos_reservados VALUES("10000","2022-12-10","Primera",8);
INSERT INTO asientos_reservados VALUES("20000","2022-12-10","Turista",120); 
INSERT INTO asientos_reservados VALUES("20000","2022-12-10","Ejecutiva",30); 
INSERT INTO asientos_reservados VALUES("20000","2022-12-10","Primera",15); 
INSERT INTO asientos_reservados VALUES("30000","2022-12-10","Turista",256); /*Misma cantidad de asientos reservados que los que tiene el avión*/
INSERT INTO asientos_reservados VALUES("30000","2022-12-10","Ejecutiva",50);
INSERT INTO asientos_reservados VALUES("30000","2022-12-10","Primera",10);
INSERT INTO asientos_reservados VALUES("15000","2022-12-20","Turista",50);
INSERT INTO asientos_reservados VALUES("15000","2022-12-20","Ejecutiva",20);
INSERT INTO asientos_reservados VALUES("15000","2022-12-20","Primera",5);
INSERT INTO asientos_reservados VALUES("35000","2022-12-20","Turista",100);
INSERT INTO asientos_reservados VALUES("35000","2022-12-20","Ejecutiva",25);
INSERT INTO asientos_reservados VALUES("35000","2022-12-20","Primera",15);
INSERT INTO asientos_reservados VALUES("40000","2022-12-20","Turista",200);
INSERT INTO asientos_reservados VALUES("40000","2022-12-20","Ejecutiva",90);
INSERT INTO asientos_reservados VALUES("40000","2022-12-20","Primera",50);

INSERT INTO posee VALUES ("Turista",1000);
INSERT INTO posee VALUES ("Ejecutiva",2000);
INSERT INTO posee VALUES ("Primera",3000);

INSERT INTO reserva_vuelo_clase VALUES (1,"10000","2022-12-10","Ejecutiva");
INSERT INTO reserva_vuelo_clase VALUES (2,"20000","2022-12-10","Turista");
INSERT INTO reserva_vuelo_clase VALUES (3,"20000","2022-12-10","Turista");
