package mypackage;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Connessione {
    private static Connection con;

    public static Connection getCon() {
        try {

            Class.forName("com.mysql.jdbc.Driver");

            if (con == null || con.isClosed()) {
                if (con != null) {
                    try {
                        con.close();
                    } catch (SQLException e) {
                        // ignora
                    }
                }

                con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/universita",
                        "root", "Root"
                );
                System.out.println(" Nuova connessione creata");
            }
            return con;
        } catch (Exception e) {
            System.err.println(" Connessione fallita: " + e.getMessage());
            return null;
        }
    }
}