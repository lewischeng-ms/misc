/*
  BasicExample1.java shows how to:
  - import the JDBC packages
  - load the Oracle JDBC drivers
  - connect to a database
  - perform DML statements
  - control transactions
  - use ResultSet objects to retrieve rows
  - use the get methods
  - perform DDL statements
*/

// import the JDBC packages
import java.sql.*;

public class BasicExample1 {
  public static void main (String args []) {

    // declare Connection and Statement objects
    Connection myConnection = null;
    Statement myStatement = null;

    try {

      // register the Oracle JDBC drivers
      DriverManager.registerDriver(
        new oracle.jdbc.OracleDriver()
      );

      // EDIT IF NECESSARY
      // create a Connection object, and connect to the database
      // as store using the Oracle JDBC Thin driver
      myConnection = DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:ORCL",
        "store",
        "store_password"
      );

      // disable auto-commit mode
      myConnection.setAutoCommit(false);

      // create a Statement object
      myStatement = myConnection.createStatement();

      // create variables and objects used to represent
      // column values
      int customerId = 6;
      String firstName = "Jason";
      String lastName = "Red";
      java.sql.Date dob = java.sql.Date.valueOf("1969-02-22");
      java.sql.Time dobTime;
      java.sql.Timestamp dobTimestamp;
      String phone = "800-555-1216";

      // perform SQL INSERT statement to add a new row to the
      // customers table using the values set in the previous
      // step - the executeUpdate() method of the Statement
      // object is used to perform the INSERT
      myStatement.executeUpdate(
        "INSERT INTO customers " +
        "(customer_id, first_name, last_name, dob, phone) VALUES (" +
          customerId + ", '" + firstName + "', '" + lastName + "', " +
        "TO_DATE('" + dob + "', 'YYYY, MM, DD'), '" + phone + "')"
      );
      System.out.println("Added row to customers table");

      // perform SQL UPDATE statement to modify the first_name
      // column of customer #1
      firstName = "Jean";
      myStatement.executeUpdate(
        "UPDATE customers " +
        "SET first_name = '" + firstName + "' " +
        "WHERE customer_id = 1"
      );
      System.out.println("Updated row in customers table");

      // perform SQL DELETE statement to remove customer #5
      myStatement.executeUpdate(
        "DELETE FROM customers " +
        "WHERE customer_id = 5"
      );
      System.out.println("Deleted row from customers table");

      // create a ResultSet object, and populate it with the
      // result of a SELECT statement that retrieves the
      // customer_id, first_name, last_name, dob, and phone columns
      // for all the rows from the customers table  - the
      // executeQuery() method of the Statement object is used
      // to perform the SELECT
      ResultSet customerResultSet = myStatement.executeQuery(
        "SELECT customer_id, first_name, last_name, dob, phone " +
        "FROM customers"
      );
      System.out.println("Retrieved rows from customers table");

      // loop through the rows in the ResultSet object using the
      // next() method, and use the get methods to read the values
      // retrieved from the database columns
      while (customerResultSet.next()) {
        customerId = customerResultSet.getInt("customer_id");
        firstName = customerResultSet.getString("first_name");
        lastName = customerResultSet.getString("last_name");
        dob = customerResultSet.getDate("dob");
        dobTime = customerResultSet.getTime("dob");
        dobTimestamp = customerResultSet.getTimestamp("dob");
        phone = customerResultSet.getString("phone");

        System.out.println("customerId = " + customerId);
        System.out.println("firstName = " + firstName);
        System.out.println("lastName = " + lastName);
        System.out.println("dob = " + dob);
        System.out.println("dobTime = " + dobTime);
        System.out.println("dobTimestamp = " + dobTimestamp);
        System.out.println("phone = " + phone);
      } // end of while loop

      // close the ResultSet object using the close() method
      customerResultSet.close();

      // rollback the changes made to the database
      myConnection.rollback();

      // create numeric variables to store the product_id and price columns
      short productIdShort;
      int productIdInt;
      long productIdLong;
      float priceFloat;
      double priceDouble;
      java.math.BigDecimal priceBigDec;

      // create another ResultSet object and retrieve the
      // product_id, product_type_id, and price columns for product #12
      // (this row has a NULL value in the product_type_id column)
      ResultSet productResultSet = myStatement.executeQuery(
        "SELECT product_id, product_type_id, price " +
        "FROM products " +
        "WHERE product_id = 12"
      );
      System.out.println("Retrieved row from products table");

      while (productResultSet.next()) {
        System.out.println("product_id = " +
          productResultSet.getInt("product_id"));
        System.out.println("product_type_id = " +
          productResultSet.getInt("product_type_id"));

        // check if the value just read by the get method was NULL
        if (productResultSet.wasNull()) {
          System.out.println("Last value read was NULL");
        }

        // use the getObject() method to read the value, and convert it
        // to a wrapper object - this converts a database NULL value to a
        // Java null value
        java.lang.Integer productTypeId =
          (java.lang.Integer) productResultSet.getObject("product_type_id");
        System.out.println("productTypeId = " + productTypeId);

        // retrieve the product_id and price column values into
        // the various numeric variables created earlier
        productIdShort = productResultSet.getShort("product_id");
        productIdInt = productResultSet.getInt("product_id");
        productIdLong = productResultSet.getLong("product_id");
        priceFloat = productResultSet.getFloat("price");
        priceDouble = productResultSet.getDouble("price");
        priceBigDec = productResultSet.getBigDecimal("price");
        System.out.println("productIdShort = " + productIdShort);
        System.out.println("productIdInt = " + productIdInt);
        System.out.println("productIdLong = " + productIdLong);
        System.out.println("priceFloat = " + priceFloat);
        System.out.println("priceDouble = " + priceDouble);
        System.out.println("priceBigDec = " + priceBigDec);
      } // end of while loop

      // close the ResultSet object
      productResultSet.close();

      // perform a SQL DDL CREATE TABLE statement to create a new table
      // that may be used to store customer addresses
      myStatement.execute(
        "CREATE TABLE addresses (" +
        "  address_id INTEGER CONSTRAINT addresses_pk PRIMARY KEY," +
        "  customer_id INTEGER CONSTRAINT addresses_fk_customers " +
        "    REFERENCES customers(customer_id)," +
        "  street VARCHAR2(20) NOT NULL," +
        "  city VARCHAR2(20) NOT NULL," +
        "  state CHAR(2) NOT NULL" +
        ")"
      );
      System.out.println("Created addresses table");

      // drop this table using the SQL DDL DROP TABLE statement
      myStatement.execute("DROP TABLE addresses");
      System.out.println("Dropped addresses table");

    } catch (SQLException e) {

      System.out.println("Error code = " + e.getErrorCode());
      System.out.println("Error message = " + e.getMessage());
      System.out.println("SQL state = " + e.getSQLState());
      e.printStackTrace();

    } finally {

      try {

        // close the Statement object using the close() method
        if (myStatement != null) {
          myStatement.close();
        }

        // close the Connection object using the close() method
        if (myConnection != null) {
          myConnection.close();
        }

      } catch (SQLException e) {
        e.printStackTrace();
      }
    }
  } // end of main()
}
