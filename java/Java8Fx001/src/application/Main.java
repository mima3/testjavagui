package application;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;


public class Main extends Application {
	@Override
	public void start(Stage primaryStage) {
		try {
            // FXMLのレイアウトをロード
            Parent root = FXMLLoader.load(
                    getClass().getResource(getClass().getSimpleName() + ".fxml"));

            // タイトルセット
            primaryStage.setTitle("TODOリスト");
            // シーン生成
            Scene scene = new Scene(root);

            scene.getStylesheets().add(getClass().getResource("application.css").toExternalForm());
                primaryStage.setScene(scene);
                primaryStage.show();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) {
		launch(args);
	}
}
