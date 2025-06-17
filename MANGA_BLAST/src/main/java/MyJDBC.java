import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.DriverManager;
import java.sql.SQLException;

public class MyJDBC {
    public static void main(String[] args) throws SQLException {
        Connection connection = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/progettotsw_db",
                "root",
                "password"
        );

        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery("SELECT * FROM utenti");

        while (resultSet.next()){
            System.out.print("email: ");
            System.out.println(resultSet.getString("email"));
            System.out.print("password: ");
            System.out.println(resultSet.getString("password"));
        }
    }
}
