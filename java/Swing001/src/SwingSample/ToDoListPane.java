package SwingSample;
import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
/**
* ToDoリスト
* 以下参考
* https://www.atmarkit.co.jp/ait/articles/0609/23/news027.html
*/
public class ToDoListPane extends JPanel {
        private JList<String> toDoList;
        private DefaultListModel<String> toDoListModel;
        private JTextField toDoInputField;
        private JButton addButton;
        public ToDoListPane() {
                super(new BorderLayout());
                // 一覧を生成
                toDoListModel = new DefaultListModel<String>();
                toDoList = new JList<String>(toDoListModel);
                JScrollPane listScrollPane = new   JScrollPane(toDoList);
                // ToDo追加用テキストフィールドの生成
                toDoInputField = new JTextField();
                // 各ボタンの生成
                JPanel buttonPanel = new JPanel();
                addButton = new JButton("追加");
                // ボタンにリスナを設定
                addButton.addActionListener(new    AddActionHandler());
                buttonPanel.add(addButton);
                add(listScrollPane, BorderLayout.NORTH);
                add(toDoInputField, BorderLayout.CENTER);
                add(buttonPanel, BorderLayout.SOUTH);
        }
        /**
        * 追加ボタンアクションのハンドラ
        */
        private class AddActionHandler implements ActionListener {
                public void actionPerformed(ActionEvent e) {
                        // テキストフィールドの内容をリストモデルに追加
                        toDoListModel.addElement
                        (toDoInputField.getText());
                }
        }
}