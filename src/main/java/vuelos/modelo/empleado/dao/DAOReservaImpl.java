package vuelos.modelo.empleado.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vuelos.modelo.empleado.beans.AeropuertoBean;
import vuelos.modelo.empleado.beans.AeropuertoBeanImpl;
import vuelos.modelo.empleado.beans.DetalleVueloBean;
import vuelos.modelo.empleado.beans.DetalleVueloBeanImpl;
import vuelos.modelo.empleado.beans.EmpleadoBean;
import vuelos.modelo.empleado.beans.EmpleadoBeanImpl;
import vuelos.modelo.empleado.beans.InstanciaVueloBean;
import vuelos.modelo.empleado.beans.InstanciaVueloBeanImpl;
import vuelos.modelo.empleado.beans.InstanciaVueloClaseBean;
import vuelos.modelo.empleado.beans.InstanciaVueloClaseBeanImpl;
import vuelos.modelo.empleado.beans.PasajeroBean;
import vuelos.modelo.empleado.beans.PasajeroBeanImpl;
import vuelos.modelo.empleado.beans.ReservaBean;
import vuelos.modelo.empleado.beans.ReservaBeanImpl;
import vuelos.modelo.empleado.beans.UbicacionesBean;
import vuelos.modelo.empleado.beans.UbicacionesBeanImpl;
import vuelos.modelo.empleado.dao.datosprueba.DAOReservaDatosPrueba;
import vuelos.utils.Fechas;

public class DAOReservaImpl implements DAOReserva {

	private static Logger logger = LoggerFactory.getLogger(DAOReservaImpl.class);
	
	//conexión para acceder a la Base de Datos
	private Connection conexion;
	
	public DAOReservaImpl(Connection conexion) {
		this.conexion = conexion;
	}
		
	
	@Override
	public int reservarSoloIda(PasajeroBean pasajero, 
							   InstanciaVueloBean vuelo, 
							   DetalleVueloBean detalleVuelo,
							   EmpleadoBean empleado) throws Exception {
		logger.info("Realiza la reserva de solo ida con pasajero {}", pasajero.getNroDocumento());
		
		/**
		 * TODO (parte 2) Realizar una reserva de ida solamente llamando al Stored Procedure (S.P.) correspondiente. 
		 *      Si la reserva tuvo exito deberá retornar el número de reserva. Si la reserva no tuvo éxito o 
		 *      falla el S.P. deberá propagar un mensaje de error explicativo dentro de una excepción.
		 *      La demás excepciones generadas automáticamente por algun otro error simplemente se propagan.
		 *      
		 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
		 *      establecida con el servidor de B.D. (inicializada en el constructor DAOReservaImpl(...)).
		 *		
		 * 
		 * @throws Exception. Deberá propagar la excepción si ocurre alguna. Puede capturarla para loguear los errores
		 *		   pero luego deberá propagarla para que el controlador se encargue de manejarla.
		 *
		 * try (CallableStatement cstmt = conexion.prepareCall("CALL PROCEDURE reservaSoloIda(?, ?, ?, ?, ?, ?, ?)"))
		 * {
		 *  ...
		 * }
		 * catch (SQLException ex){
		 * 			logger.debug("Error al consultar la BD. SQLException: {}. SQLState: {}. VendorError: {}.", ex.getMessage(), ex.getSQLState(), ex.getErrorCode());
		 *  		throw ex;
		 * } 
		 */
		
		int resultado;
		try (CallableStatement cstmt = conexion.prepareCall("CALL reservaSoloIda(?, ?, ?, ?, ?, ?, ?)"))
		{
			cstmt.setString(1,vuelo.getNroVuelo());
			cstmt.setDate(2, Fechas.convertirDateADateSQL(vuelo.getFechaVuelo()));
			cstmt.setString(3, detalleVuelo.getClase());
			cstmt.setString(4, pasajero.getTipoDocumento());
			cstmt.setInt(5, pasajero.getNroDocumento());
			cstmt.setInt(6, empleado.getLegajo());
			cstmt.registerOutParameter(7, java.sql.Types.INTEGER);
			cstmt.execute();
			ResultSet rs = cstmt.getResultSet();
			if(rs.next()) {
				resultado = cstmt.getInt(7);
				if(resultado==-1) {
					throw new Exception(rs.getString("resultado"));
				}	
			}
			else throw new Exception("No se pudo realizar la reserva");
			cstmt.close();
		}
		catch (SQLException ex){
		  		logger.debug("Error al consultar la BD. SQLException: {}. SQLState: {}. VendorError: {}.", ex.getMessage(), ex.getSQLState(), ex.getErrorCode());
		  		throw ex;
		}
		return resultado;
	}
	
	@Override
	public int reservarIdaVuelta(PasajeroBean pasajero, 
				 				 InstanciaVueloBean vueloIda,
				 				 DetalleVueloBean detalleVueloIda,
				 				 InstanciaVueloBean vueloVuelta,
				 				 DetalleVueloBean detalleVueloVuelta,
				 				 EmpleadoBean empleado) throws Exception {
		
		logger.info("Realiza la reserva de ida y vuelta con pasajero {}", pasajero.getNroDocumento());
		/**
		 * TODO (parte 2) Realizar una reserva de ida y vuelta llamando al Stored Procedure (S.P.) correspondiente. 
		 *      Si la reserva tuvo exito deberá retornar el número de reserva. Si la reserva no tuvo éxito o 
		 *      falla el S.P. deberá propagar un mensaje de error explicativo dentro de una excepción.
		 *      La demás excepciones generadas automáticamente por algun otro error simplemente se propagan.
		 *      
		 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
		 *      establecida con el servidor de B.D. (inicializada en el constructor DAOReservaImpl(...)).
		 * 
		 * @throws Exception. Deberá propagar la excepción si ocurre alguna. Puede capturarla para loguear los errores
		 *		   pero luego deberá propagarla para que se encargue el controlador.
		 *
		 */
		int resultado;
		try (CallableStatement cstmt = conexion.prepareCall("CALL PROCEDURE reservarIdaVuelta(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"))
		{
			cstmt.setString(1,vueloIda.getNroVuelo());
			cstmt.setDate(2, Fechas.convertirDateADateSQL(vueloIda.getFechaVuelo()));
			cstmt.setString(3, detalleVueloIda.getClase());
			cstmt.setString(4,vueloVuelta.getNroVuelo());
			cstmt.setDate(5, Fechas.convertirDateADateSQL(vueloVuelta.getFechaVuelo()));
			cstmt.setString(6, detalleVueloVuelta.getClase());
			cstmt.setString(7, pasajero.getTipoDocumento());
			cstmt.setInt(8, pasajero.getNroDocumento());
			cstmt.setInt(9, empleado.getLegajo());
			cstmt.registerOutParameter(10, java.sql.Types.INTEGER);
			cstmt.executeUpdate();
			ResultSet rs = cstmt.getResultSet();
			if(rs.next()) {
				resultado = cstmt.getInt(10);
				if(resultado==-1) {
					throw new Exception(rs.getString("resultado"));
				}	
			}
			else throw new Exception("No se pudo realizar la reserva");
		}
		catch (SQLException ex){
		  		logger.debug("Error al consultar la BD. SQLException: {}. SQLState: {}. VendorError: {}.", ex.getMessage(), ex.getSQLState(), ex.getErrorCode());
		  		throw ex;
		}
		return resultado;
	}
	
	@Override
	public ReservaBean recuperarReserva(int codigoReserva) throws Exception {
		
		logger.info("Solicita recuperar información de la reserva con codigo {}", codigoReserva);
		
		/**
		 * TODO (parte 2) Debe realizar una consulta que retorne un objeto ReservaBean donde tenga los datos de la
		 *      reserva que corresponda con el codigoReserva y en caso que no exista generar una excepción.
		 *
		 * 		Debe poblar la reserva con todas las instancias de vuelo asociadas a dicha reserva y 
		 * 		las clases correspondientes.
		 * 
		 * 		Los objetos ReservaBean además de las propiedades propias de una reserva tienen un arraylist
		 * 		con pares de instanciaVuelo y Clase. Si la reserva es solo de ida va a tener un unico
		 * 		elemento el arreglo, y si es de ida y vuelta tendrá dos elementos. 
		 * 
		 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
		 *      establecida con el servidor de B.D. (inicializada en el constructor DAOReservaImpl(...)).
		 */
		/*
		 * Importante, tenga en cuenta de setear correctamente el atributo IdaVuelta con el método setEsIdaVuelta en la ReservaBean
		 */
		String sql0= "SELECT count(numero) FROM reservas WHERE numero="+codigoReserva;
		int cantidad=0;
		Statement stmt0= conexion.createStatement();
		ResultSet rs0= stmt0.executeQuery(sql0);
		while(rs0.next()) {
			cantidad= rs0.getInt("count(numero)");
		}
		if(cantidad==0)
			throw new Exception("No se encuentraron reservas con ese código");
		ReservaBean reserva = new ReservaBeanImpl();
		String sql= "SELECT * FROM reservas WHERE numero="+codigoReserva;
		Statement stmt= conexion.createStatement();
		ResultSet rs= stmt.executeQuery(sql);
		while(rs.next()) {
			EmpleadoBean empleado= new EmpleadoBeanImpl();
			int legajo= rs.getInt("legajo");
			String sql2= "SELECT * FROM empleados WHERE legajo="+legajo;
			Statement stmt2= conexion.createStatement();
			ResultSet rs2= stmt2.executeQuery(sql2);
			while(rs2.next()) {
				empleado.setApellido(rs2.getString("apellido"));
				empleado.setDireccion(rs2.getString("direccion"));
				empleado.setLegajo(legajo);
				empleado.setNombre(rs2.getString("nombre"));
				empleado.setNroDocumento(rs2.getInt("doc_nro"));
				empleado.setPassword(rs2.getString("password"));
				empleado.setTelefono(rs2.getString("telefono"));
				empleado.setTipoDocumento(rs2.getString("doc_tipo"));
			}
			PasajeroBean pasajero= new PasajeroBeanImpl();
			String doc_tipo= rs.getString("doc_tipo");
			int doc_nro= rs.getInt("doc_nro");
			String sql3= "SELECT * FROM pasajeros WHERE doc_tipo='"+doc_tipo+"' AND doc_nro="+doc_nro;
			Statement stmt3= conexion.createStatement();
			ResultSet rs3= stmt3.executeQuery(sql3);
			while(rs3.next()) {
				pasajero.setApellido(rs3.getString("apellido"));
				pasajero.setDireccion(rs3.getString("direccion"));
				pasajero.setNacionalidad(rs3.getString("nacionalidad"));
				pasajero.setNombre(rs3.getString("nombre"));
				pasajero.setNroDocumento(doc_nro);
				pasajero.setTelefono(rs3.getString("telefono"));
				pasajero.setTipoDocumento(doc_tipo);
			}
			reserva.setEmpleado(empleado);
			if(cantidad==1)
		    	reserva.setEsIdaVuelta(false);
			else
				reserva.setEsIdaVuelta(true);
			reserva.setEstado(rs.getString("estado"));
			reserva.setFecha(rs.getDate("fecha"));
			reserva.setNumero(codigoReserva);
			reserva.setPasajero(pasajero);
			reserva.setVencimiento(rs.getDate("vencimiento"));
			reserva.setVuelosClase(obtenerVCList(codigoReserva));
			stmt2.close();
			rs2.close();
			stmt3.close();
			rs3.close();
		}
		stmt0.close();
		rs0.close();
		stmt.close();
		rs.close();
		return reserva;
	}
	
	private ArrayList<InstanciaVueloClaseBean> obtenerVCList(int codigoReserva) throws Exception {
		ArrayList<InstanciaVueloClaseBean> vcList= new ArrayList<InstanciaVueloClaseBean>();
		String sql0= "SELECT * from reserva_vuelo_clase WHERE numero="+codigoReserva;
		Statement stmt0= conexion.createStatement();
		ResultSet rs0= stmt0.executeQuery(sql0);
		while(rs0.next()) {
			InstanciaVueloClaseBean vc= new InstanciaVueloClaseBeanImpl();
			InstanciaVueloBean v= new InstanciaVueloBeanImpl();
			DetalleVueloBean c= new DetalleVueloBeanImpl();
			String vuelo= rs0.getString("vuelo");
			String clase= rs0.getString("clase");
			String sql= "SELECT * from vuelos_disponibles WHERE nro_vuelo='"+vuelo+"' AND clase='"+clase+"'";
			Statement stmt= conexion.createStatement();
			ResultSet rs= stmt.executeQuery(sql);
			while(rs.next()) {
				String codigo_aero_sale= rs.getString("codigo_aero_sale");
				String sql2= "SELECT * FROM aeropuertos WHERE codigo='"+codigo_aero_sale+"'";
				Statement stmt2= conexion.createStatement();
				ResultSet rs2= stmt2.executeQuery(sql2);
		        rs2.next();
				AeropuertoBean aeropuerto_salida= new AeropuertoBeanImpl();
				String paisS= rs2.getString("pais");
				String estadoS= rs2.getString("estado");
				String ciudadS= rs2.getString("ciudad");
				UbicacionesBean ubicacionS= new UbicacionesBeanImpl();
				String sql2aux= "SELECT huso FROM ubicaciones WHERE pais='"+paisS+"' AND estado='"+estadoS+"' AND ciudad='"+ciudadS+"'";
				Statement stmt2aux= conexion.createStatement();
				ResultSet rs2aux= stmt2aux.executeQuery(sql2aux);
				while(rs2aux.next()) {
				ubicacionS.setCiudad(ciudadS);
				ubicacionS.setEstado(estadoS);
				ubicacionS.setPais(paisS);
				ubicacionS.setHuso(rs2aux.getByte("huso"));
				}
				aeropuerto_salida.setCodigo(rs2.getString("codigo"));
				aeropuerto_salida.setDireccion(rs2.getString("direccion"));
				aeropuerto_salida.setNombre(rs2.getString("nombre"));
				aeropuerto_salida.setTelefono(rs2.getString("telefono"));
				aeropuerto_salida.setUbicacion(ubicacionS);
				String codigo_aero_llega= rs.getString("codigo_aero_llega");
				String sql3= "SELECT * FROM aeropuertos WHERE codigo='"+codigo_aero_llega+"'";
				Statement stmt3= conexion.createStatement();
				ResultSet rs3= stmt3.executeQuery(sql3);
				rs3.next();
				AeropuertoBean aeropuerto_llega= new AeropuertoBeanImpl();
				String paisD= rs3.getString("pais");
				String estadoD= rs3.getString("estado");
				String ciudadD= rs3.getString("ciudad");
				UbicacionesBean ubicacionD= new UbicacionesBeanImpl();
				String sql3aux= "SELECT huso FROM ubicaciones WHERE pais='"+paisD+"' AND estado='"+estadoD+"' AND ciudad='"+ciudadD+"'";
				Statement stmt3aux= conexion.createStatement();
				ResultSet rs3aux= stmt3aux.executeQuery(sql3aux);
				while(rs3aux.next()) {
				ubicacionD.setCiudad(ciudadD);
				ubicacionD.setEstado(estadoD);
				ubicacionD.setPais(paisD);
				ubicacionD.setHuso(rs3aux.getByte("huso"));
				}
				aeropuerto_llega.setCodigo(rs3.getString("codigo"));
				aeropuerto_llega.setDireccion(rs3.getString("direccion"));
				aeropuerto_llega.setNombre(rs3.getString("nombre"));
				aeropuerto_llega.setTelefono(rs3.getString("telefono"));
				aeropuerto_llega.setUbicacion(ubicacionD);
				
				v.setAeropuertoLlegada(aeropuerto_llega);
				v.setAeropuertoSalida(aeropuerto_salida);
			    v.setDiaSalida(rs.getString("dia_sale"));
				v.setFechaVuelo(rs.getDate("fecha"));
				v.setHoraLlegada(rs.getTime("hora_llega"));
				v.setHoraSalida(rs.getTime("hora_sale"));
				v.setModelo(rs.getString("modelo"));
				v.setNroVuelo(vuelo);
				v.setTiempoEstimado(rs.getTime("tiempo_estimado"));
				
				c.setAsientosDisponibles(rs.getInt("asientos_disponibles"));
				c.setClase(clase);
				c.setPrecio(rs.getFloat("precio"));
				c.setVuelo(v);
				
				stmt2.close();
				rs2.close();
				stmt3.close();
				rs3.close();
				stmt2aux.close();
				rs2aux.close();
				stmt3aux.close();
				rs3aux.close();
			}
			vc.setClase(c);
			vc.setVuelo(v);
			vcList.add(vc);
			stmt.close();
			rs.close();
		}
		stmt0.close();
		rs0.close();
		return vcList;
	}

}
