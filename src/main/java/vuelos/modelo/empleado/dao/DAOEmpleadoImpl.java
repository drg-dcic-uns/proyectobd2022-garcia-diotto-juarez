package vuelos.modelo.empleado.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vuelos.modelo.empleado.beans.EmpleadoBean;
import vuelos.modelo.empleado.beans.EmpleadoBeanImpl;

public class DAOEmpleadoImpl implements DAOEmpleado {

	private static Logger logger = LoggerFactory.getLogger(DAOEmpleadoImpl.class);
	
	//conexión para acceder a la Base de Datos
	private Connection conexion;
	
	public DAOEmpleadoImpl(Connection c) {
		this.conexion = c;
	}


	@Override
	public EmpleadoBean recuperarEmpleado(int legajo) throws Exception {
		logger.info("recupera el empleado que corresponde al legajo {}.", legajo);
		
		/**
		 * Debe recuperar de la B.D. los datos del empleado que corresponda al legajo pasado 
		 *      como parámetro y devolver los datos en un objeto EmpleadoBean. Si no existe el legajo 
		 *      deberá retornar null y si ocurre algun error deberá generar y propagar una excepción.	
		 *       
		 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
		 *      establecida con el servidor de B.D. (inicializada en el constructor DAOEmpleadoImpl(...)). 
		 */		
		try {
			String sql = "SELECT * from empleados where legajo='"+legajo+"';";
			java.sql.Statement st = conexion.createStatement();
			java.sql.ResultSet rs = st.executeQuery(sql);
			if(!rs.next())
				return null;
			EmpleadoBean empleado = new EmpleadoBeanImpl();
			empleado.setLegajo(legajo);
			empleado.setPassword(rs.getString("password"));
			empleado.setTipoDocumento(rs.getString("doc_tipo"));
			empleado.setNroDocumento(rs.getInt("doc_nro"));
			empleado.setApellido(rs.getString("apellido"));
			empleado.setNombre(rs.getString("nombre"));
			empleado.setDireccion(rs.getString("direccion"));
			empleado.setTelefono(rs.getString("telefono"));
			return empleado;
		}catch(java.sql.SQLException e) {
			e.printStackTrace();
			throw new Exception("Error al recuperar el empleado"); //Ver si hay que cambiarlo
		}
	}

}
