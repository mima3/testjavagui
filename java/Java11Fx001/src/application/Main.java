package application;


import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

// https://stackoverflow.com/questions/32700005/javafx-listview-add-and-edit-element
// 以下より取得
// https://gluonhq.com/products/javafx/
// libのフォルダを参照ライブラリに追加
// 実行時の構成のVMの引数に以下追加
//  --module-path=C:\tool\lib\javafx-sdk-11.0.2\lib\ --add-modules=javafx.controls
// https://stackoverflow.com/questions/52013505/how-do-i-use-javafx-11-in-eclipse
// https://skrb.hatenablog.com/entry/2018/05/29/210000
// https://qiita.com/todu/items/bed6f733ca9df0cbec75
public class Main extends Application {
	@Override
	public void start(Stage primaryStage) {
		try {
            // FXMLのレイアウトをロード
			// getClass().getResource(getClass().getSimpleName() + ".fxml")
			System.out.println(getClass().getResource(getClass().getSimpleName() + ".fxml"));
            Parent root = FXMLLoader.load(getClass().getResource(getClass().getSimpleName() + ".fxml"));
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
