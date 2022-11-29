package vuelos.modelo.empleado.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vuelos.modelo.empleado.beans.AeropuertoBean;
import vuelos.modelo.empleado.beans.AeropuertoBeanImpl;
import vuelos.modelo.empleado.beans.DetalleVueloBean;
import vuelos.modelo.empleado.beans.DetalleVueloBeanImpl;
import vuelos.modelo.empleado.beans.InstanciaVueloBean;
import vuelos.modelo.empleado.beans.InstanciaVueloBeanImpl;
import vuelos.modelo.empleado.beans.UbicacionesBean;
import vuelos.utils.Fechas;

public class DAOVuelosImpl implements DAOVuelos {

	private static Logger logger = LoggerFactory.getLogger(DAOVuelosImpl.class);
	
	//conexión para acceder a la Base de Datos
	private Connection conexion;
	
	public DAOVuelosImpl(Connection conexion) {
		this.conexion = conexion;
	}

	@Override
	public ArrayList<InstanciaVueloBean> recuperarVuelosDisponibles(Date fechaVuelo, UbicacionesBean origen, UbicacionesBean destino)  throws Exception {
		/** 
		 * TODO Debe retornar una lista de vuelos disponibles para ese día con origen y destino según los parámetros. 
		 *      Debe propagar una excepción si hay algún error en la consulta.    
		 *      
		 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
		 *      establecida con el servidor de B.D. (inicializada en el constructor DAOVuelosImpl(...)).  
		 */
		try {
		String ciudad_sale= origen.getCiudad();
		String estado_sale= origen.getEstado();
		String pais_sale= origen.getPais();
		String ciudad_llega= destino.getCiudad();
		String estado_llega= destino.getEstado();
		String pais_llega= destino.getPais();
		String fecha= Fechas.convertirDateAStringDB(fechaVuelo);
		String sql= "SELECT DISTINCT nro_vuelo,nombre_aero_sale,hora_sale,hora_llega,nombre_aero_llega,modelo,tiempo_estimado,codigo_aero_sale,codigo_aero_llega,dia_sale,fecha FROM vuelos_disponibles WHERE ciudad_sale='"+ciudad_sale+"' and estado_sale='"+estado_sale+"' and pais_sale='"+pais_sale+"' and ciudad_llega='"+ciudad_llega+"' and estado_llega='"+estado_llega+"' and pais_llega='"+pais_llega+ "' and fecha='"+fecha+"'";
		Statement stmt= conexion.createStatement();
		ResultSet rs= stmt.executeQuery(sql);
		ArrayList<InstanciaVueloBean> resultado = new ArrayList<InstanciaVueloBean>();
		while(rs.next()) {
			String codigo_aero_sale= rs.getString("codigo_aero_sale");
			String sql2= "SELECT * FROM aeropuertos WHERE codigo='"+codigo_aero_sale+"'";
			Statement stmt2= conexion.createStatement();
			ResultSet rs2= stmt2.executeQuery(sql2);
	        rs2.next();
			AeropuertoBean aeropuerto_salida= new AeropuertoBeanImpl();
			aeropuerto_salida.setCodigo(rs2.getString("codigo"));
			aeropuerto_salida.setDireccion(rs2.getString("direccion"));
			aeropuerto_salida.setNombre(rs2.getString("nombre"));
			aeropuerto_salida.setTelefono(rs2.getString("telefono"));
			aeropuerto_salida.setUbicacion(origen);
			String codigo_aero_llega= rs.getString("codigo_aero_llega");
			String sql3= "SELECT * FROM aeropuertos WHERE codigo='"+codigo_aero_llega+"'";
			Statement stmt3= conexion.createStatement();
			ResultSet rs3= stmt3.executeQuery(sql3);
			rs3.next();
			AeropuertoBean aeropuerto_llega= new AeropuertoBeanImpl();
			aeropuerto_llega.setCodigo(rs3.getString("codigo"));
			aeropuerto_llega.setDireccion(rs3.getString("direccion"));
			aeropuerto_llega.setNombre(rs3.getString("nombre"));
			aeropuerto_llega.setTelefono(rs3.getString("telefono"));
			aeropuerto_llega.setUbicacion(destino);
			
			InstanciaVueloBean instanciaVuelo= new InstanciaVueloBeanImpl();
			instanciaVuelo.setAeropuertoLlegada(aeropuerto_llega);
			instanciaVuelo.setAeropuertoSalida(aeropuerto_salida);
			instanciaVuelo.setDiaSalida(rs.getString("dia_sale"));
			instanciaVuelo.setFechaVuelo(rs.getDate("fecha"));
			instanciaVuelo.setHoraLlegada(rs.getTime("hora_llega"));
			instanciaVuelo.setHoraSalida(rs.getTime("hora_sale"));
			instanciaVuelo.setModelo(rs.getString("modelo"));
			instanciaVuelo.setNroVuelo(rs.getString("nro_vuelo"));
			instanciaVuelo.setTiempoEstimado(rs.getTime("tiempo_estimado"));
			resultado.add(instanciaVuelo);
			stmt2.close();
			rs2.close();
			stmt3.close();
			rs3.close();
		}
		stmt.close();
		rs.close();
		return resultado;
		}
		catch (SQLException ex)
		{			
			logger.error("SQLException: " + ex.getMessage());
			logger.error("SQLState: " + ex.getSQLState());
			logger.error("VendorError: " + ex.getErrorCode());
			throw new Exception("Error inesperado al consultar la B.D.");
		}	
	}

	@Override
	public ArrayList<DetalleVueloBean> recuperarDetalleVuelo(InstanciaVueloBean vuelo) throws Exception {
		/** 
		 * TODO Debe retornar una lista de clases, precios y asientos disponibles de dicho vuelo.		   
		 *      Debe propagar una excepción si hay algún error en la consulta.    
		 *      
		 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
		 *      establecida con el servidor de B.D. (inicializada en el constructor DAOVuelosImpl(...)).
		 */
		try {
		String nroVuelo=vuelo.getNroVuelo();
		String fechaVuelo= Fechas.convertirDateAStringDB(vuelo.getFechaVuelo());
		String sql= "SELECT precio,asientos_disponibles,clase FROM vuelos_disponibles WHERE nro_vuelo='"+nroVuelo+"' and fecha='"+fechaVuelo+"'";
		Statement stmt= conexion.createStatement();
		ResultSet rs= stmt.executeQuery(sql);
		ArrayList<DetalleVueloBean> resultado= new ArrayList<DetalleVueloBean>();
		while(rs.next()) {
			DetalleVueloBean detalleVuelo= new DetalleVueloBeanImpl();
			detalleVuelo.setPrecio(rs.getFloat("precio"));
			detalleVuelo.setAsientosDisponibles(rs.getInt("asientos_disponibles"));
			detalleVuelo.setClase(rs.getString("clase"));
			detalleVuelo.setVuelo(vuelo);
			resultado.add(detalleVuelo);
		}
		stmt.close();
		rs.close();
		return resultado;
		}
		catch (SQLException ex)
		{			
			logger.error("SQLException: " + ex.getMessage());
			logger.error("SQLState: " + ex.getSQLState());
			logger.error("VendorError: " + ex.getErrorCode());
			throw new Exception("Error inesperado al consultar la B.D.");
		}	
	}
}
