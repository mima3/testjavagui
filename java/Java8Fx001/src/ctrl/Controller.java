package ctrl;
import java.net.URL;
import java.util.ResourceBundle;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.ListView;
import javafx.scene.control.TextField;


public class Controller implements Initializable {
    @FXML
    private TextField textBox;

    @FXML
    private Button btnAdd;

    @FXML
    private ListView<String> list;

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		// TODO 自動生成されたメソッド・スタブ
		textBox.setText("値を入力してください。");

	}

    @FXML
    public void onAddButtonClicked(ActionEvent event) {
        // テキストボックスに文字列をセットする
    	list.getItems().add(textBox.getText());
		textBox.setText("");
    }
}
