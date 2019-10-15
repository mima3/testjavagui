Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes
Add-type -AssemblyName System.Windows.Forms

$source = @"
using System;
using System.Windows.Automation;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Drawing;

public class AutomationHelper
{
    // https://culage.hatenablog.com/entry/20130611/1370876400
    [DllImport("user32.dll")]
    extern static uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

    [StructLayout(LayoutKind.Sequential)]
    struct INPUT
    {
        public int type;
        public MOUSEINPUT mi;
    }

    [StructLayout(LayoutKind.Sequential)]
    struct MOUSEINPUT
    {
        public int dx;
        public int dy;
        public int mouseData;
        public int dwFlags;
        public int time;
        public IntPtr dwExtraInfo;
    }

    const int MOUSEEVENTF_LEFTDOWN = 0x0002;
    const int MOUSEEVENTF_LEFTUP = 0x0004;
    static public void Click()
    {
        //struct 配列の宣言
        INPUT[] input = new INPUT[2];
        //左ボタン Down
        input[0].mi.dwFlags = MOUSEEVENTF_LEFTDOWN;
        //左ボタン Up
        input[1].mi.dwFlags = MOUSEEVENTF_LEFTUP;
        //イベントの一括生成
        SendInput(2, input, Marshal.SizeOf(input[0]));
    }
    static public void MouseMove(int x, int y)
    {
        var pt = new System.Drawing.Point(x, y);
        System.Windows.Forms.Cursor.Position = pt;
    }
    static public void SendKeys(string key) 
    {
        System.Windows.Forms.SendKeys.SendWait(key);
    }
    public static AutomationElement RootElement
    {
        get
        {
            return AutomationElement.RootElement;
        }
    }

    public static AutomationElement GetMainWindowByTitle(string title) {
        PropertyCondition cond = new PropertyCondition(AutomationElement.NameProperty, title);
        return RootElement.FindFirst(TreeScope.Children, cond);
    }
    
    public static AutomationElement ChildWindowByTitle(AutomationElement parent , string title) {
        try {
            PropertyCondition cond = new PropertyCondition(AutomationElement.NameProperty, title);
            return parent.FindFirst(TreeScope.Children, cond);
        } catch {
            return null;
        }
    }

    public static AutomationElement WaitChildWindowByTitle(AutomationElement parent, string title, int timeout = 10) {
        DateTime start = DateTime.Now;
        while (true) {
            AutomationElement ret = ChildWindowByTitle(parent, title);
            if (ret != null) {
                return ret;
            }
            TimeSpan ts = DateTime.Now - start;
            if (ts.TotalSeconds > timeout) {
               return null;
            }
            System.Threading.Thread.Sleep(100);
        }
    }
}
"@
Add-Type -TypeDefinition $source -ReferencedAssemblies("UIAutomationClient", "UIAutomationTypes", "System.Windows.Forms",  "System.Drawing")

# 5.0以降ならusingで記載した方が楽。
$autoElem = [System.Windows.Automation.AutomationElement]

# ウィンドウ以下で指定の条件に当てはまるコントロールを全て列挙
function findAllElements($form, $condProp, $condValue) {
    $cond = New-Object -TypeName System.Windows.Automation.PropertyCondition($condProp, $condValue)
	return $form.FindAll([System.Windows.Automation.TreeScope]::Element -bor [System.Windows.Automation.TreeScope]::Descendants, $cond)
}

# ウィンドウ以下で指定の条件に当てはまるコントロールを１つ取得
function findFirstElement($form, $condProp, $condValue) {
    $cond = New-Object -TypeName System.Windows.Automation.PropertyCondition($condProp, $condValue)
	return $form.FindFirst([System.Windows.Automation.TreeScope]::Element -bor [System.Windows.Automation.TreeScope]::Descendants, $cond)
}

# 要素をValuePatternに変換
function convertValuePattern($elem) {
	return $elem.GetCurrentPattern([System.Windows.Automation.ValuePattern]::Pattern) -as [System.Windows.Automation.ValuePattern]
}
function convertSelectionItemPattern($elem) {
	return $elem.GetCurrentPattern([System.Windows.Automation.SelectionItemPattern]::Pattern) -as [System.Windows.Automation.SelectionItemPattern]
}

# 要素にテキストを入力
# Java8だとtxtValuePtn.SetValueが正常に動作しないための代替
function sendTextValue($textCtrl, $message) {
    [AutomationHelper]::MouseMove($textCtrl.Current.BoundingRectangle.X + 5, $textCtrl.Current.BoundingRectangle.Y + 5)
    [AutomationHelper]::Click()
    [AutomationHelper]::SendKeys("^(a)")
    [AutomationHelper]::SendKeys("{DEL}")
    [AutomationHelper]::SendKeys($message)
    Start-Sleep 1
}

# メイン処理
$mainForm = [AutomationHelper]::GetMainWindowByTitle("TODOリスト")
if ($mainForm -eq $null) {
    Write-Error "Java Fxの画面を起動してください"
    exit 1
}
$mainForm.SetFocus()
$editType = [System.Windows.Automation.ControlType]::Edit
$textCtrl = findFirstElement $mainForm $autoElem::ControlTypeProperty $editType

# Java8の場合ValuePatternのSetValueでエラーとなる
$txtValuePtn = convertValuePattern $textCtrl
$txtGetValue = $txtValuePtn.Current.Value
Write-Host "変更前：$txtGetValue"
$txtValuePtn.SetValue("わふる");
