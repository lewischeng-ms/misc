/*
  BasicExample2.java shows how to use prepared SQL statements
*/

// import the JDBC packages
import java.sql.*;

class Product {
  int productId;
  int productTypeId;
  String name;
  String description;
  double price;
}

public class BasicExample2 {
  public static void main (String args []) {
    try {
      // register the Oracle JDBC drivers
      DriverManager.registerDriver(
        new oracle.jdbc.OracleDriver()
      );

      // EDIT IF NECESSARY
      // create a Connection object, and connect to the database
      // as store using the Oracle JDBC Thin driver
      Connection myConnection = DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:ORCL",
        "store",
        "store_password"
      );

      // disable auto-commit mode
      myConnection.setAutoCommit(false);

      Product [] productArray = new Product[5];
      for (int counter = 0; counter < productArray.length; counter ++) {
        productArray[counter] = new Product();
        productArray[counter].productId = counter + 13;
        productArray[counter].productTypeId = 1;
        productArray[counter].name = "Test product";
        productArray[counter].description = "Test product";
        productArray[counter].price = 19.95;
      } // end of for loop

      // create a PreparedStatement object
      PreparedStatement myPrepStatement = myConnection.prepareStatement(
        "INSERT INTO products " +
        "(product_id, product_type_id, name, description, price) VALUES (" +
        "?, ?, ?, ?, ?" +
        ")"
      );

      // initialize the values for the new rows using the
      // appropriate set methods
      for (int counter = 0; counter < productArray.length; counter ++) {
        myPrepStatement.setInt(1, productArray[counter].productId);
        myPrepStatement.setInt(2, productArray[counter].productTypeId);
        myPrepStatement.setString(3, productArray[counter].name);
        myPrepStatement.setString(4, productArray[counter].description);
        myPrepStatement.setDouble(5, productArray[counter].price);
        myPrepStatement.execute();
      } // end of for loop

      // close the PreparedStatement object
      myPrepStatement.close();

      // retrieve the product_id, product_type_id, name, description, and
      // price columns for these new rows using a ResultSet object
      Statement myStatement = myConnection.createStatement();
      ResultSet productResultSet = myStatement.executeQuery(
        "SELECT product_id, product_type_id, " +
        "  name, description, price " +
        "FROM products " +
        "WHERE product_id > 12"
      );

      // display the column values
      while (productResultSet.next()) {
        System.out.println("product_id = " +
          productResultSet.getInt("product_id"));
        System.out.println("product_type_id = " +
          productResultSet.getInt("product_type_id"));
        System.out.println("name = " +
          productResultSet.getString("name"));
        System.out.println("description = " +
          productResultSet.getString("description"));
        System.out.println("price = " +
          productResultSet.getDouble("price"));
      } // end of while loop

      // close the ResultSet object using the close() method
      productResultSet.close();

      // rollback the changes made to the database
      myConnection.rollback();

      // close the other JDBC objects
      myStatement.close();
      myConnection.close();

    } catch (SQLException e) {
      System.out.println("Error code = " + e.getErrorCode());
      System.out.println("Error message = " + e.getMessage());
      System.out.println("SQL state = " + e.getSQLState());
      e.printStackTrace();
    }
  } // end of main()
}