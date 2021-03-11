package util;

import java.sql.Connection;
import java.sql.DriverManager;


public class DatabaseUtil {
	
	public static Connection getConnection() {
		try {
			String dbURL = "jdbc:mysql://localhost:3307/LectureEvaluation?serverTimezone=UTC";
			String dbID= "root";
            String dbPassword = "tkavkf93";
            Class.forName("com.mysql.jdbc.Driver");
            return DriverManager.getConnection(dbURL,dbID,dbPassword);
		}	catch(Exception e) {
			
			e.printStackTrace();
		}
		return null;//데이터베이스 오류
	}

}
