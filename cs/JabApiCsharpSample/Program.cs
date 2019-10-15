using JabApiLib.JavaAccessBridge;
using System;
using System.Collections.Generic;
using System.Text;

namespace JabApiCsharpSample
{
    class Program
    {
        static void Main(string[] args)
        {
            //JabApi.Windows_run();
            JabHelpers.Init();
            int vmID = 0;
            JabHelpers.AccessibleTreeItem javaTree = null;
            javaTree = JabHelpers.GetComponentTreeByTitle("ToDoリスト", out vmID);

            // テキスト設定
            JabHelpers.AccessibleTreeItem txt = javaTree.children[0].children[1].children[0].children[0].children[1];
            JabApi.setTextContents(vmID, txt.acPtr, "わろすわろす");

            JabHelpers.AccessibleTreeItem button = javaTree.children[0].children[1].children[0].children[0].children[2].children[0];
            List<string> actionList = JabHelpers.GetAccessibleActionsList(vmID, button.acPtr);
            Console.WriteLine("操作可能なアクション-------------");
            foreach (string a in actionList)
            {
                Console.WriteLine(a);
            }
            // クリック実行
            JabHelpers.DoAccessibleActions(vmID, button.acPtr, "クリック");

            //
            JabApi.setTextContents(vmID, txt.acPtr, "いろはにほへと");
            JabHelpers.DoAccessibleActions(vmID, button.acPtr, "クリック");

            //
            JabApi.setTextContents(vmID, txt.acPtr, "ちりぬるお");
            JabHelpers.DoAccessibleActions(vmID, button.acPtr, "クリック");

            // リストの内容
            Console.WriteLine("リスト一覧-------------");
            javaTree = JabHelpers.GetComponentTreeByTitle("ToDoリスト", out vmID);
            JabHelpers.AccessibleTreeItem list = javaTree.children[0].children[1].children[0].children[0].children[0].children[0].children[0];
            foreach (JabHelpers.AccessibleTreeItem listitem in list.children)
            {
                Console.WriteLine(listitem.name );
            }
            JabHelpers.DoAccessibleActions(vmID, list.children[1].acPtr, "クリック");
            Console.ReadLine();
        }
    }
}
