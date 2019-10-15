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
        //struct �z��̐錾
        INPUT[] input = new INPUT[2];
        //���{�^�� Down
        input[0].mi.dwFlags = MOUSEEVENTF_LEFTDOWN;
        //���{�^�� Up
        input[1].mi.dwFlags = MOUSEEVENTF_LEFTUP;
        //�C�x���g�̈ꊇ����
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

# 5.0�ȍ~�Ȃ�using�ŋL�ڂ��������y�B
$autoElem = [System.Windows.Automation.AutomationElement]

# �E�B���h�E�ȉ��Ŏw��̏����ɓ��Ă͂܂�R���g���[����S�ė�
function findAllElements($form, $condProp, $condValue) {
    $cond = New-Object -TypeName System.Windows.Automation.PropertyCondition($condProp, $condValue)
	return $form.FindAll([System.Windows.Automation.TreeScope]::Element -bor [System.Windows.Automation.TreeScope]::Descendants, $cond)
}

# �E�B���h�E�ȉ��Ŏw��̏����ɓ��Ă͂܂�R���g���[�����P�擾
function findFirstElement($form, $condProp, $condValue) {
    $cond = New-Object -TypeName System.Windows.Automation.PropertyCondition($condProp, $condValue)
	return $form.FindFirst([System.Windows.Automation.TreeScope]::Element -bor [System.Windows.Automation.TreeScope]::Descendants, $cond)
}

# �v�f��ValuePattern�ɕϊ�
function convertValuePattern($elem) {
	return $elem.GetCurrentPattern([System.Windows.Automation.ValuePattern]::Pattern) -as [System.Windows.Automation.ValuePattern]
}
function convertSelectionItemPattern($elem) {
	return $elem.GetCurrentPattern([System.Windows.Automation.SelectionItemPattern]::Pattern) -as [System.Windows.Automation.SelectionItemPattern]
}

# �v�f�Ƀe�L�X�g�����
# Java8����txtValuePtn.SetValue������ɓ��삵�Ȃ����߂̑��
function sendTextValue($textCtrl, $message) {
    [AutomationHelper]::MouseMove($textCtrl.Current.BoundingRectangle.X + 5, $textCtrl.Current.BoundingRectangle.Y + 5)
    [AutomationHelper]::Click()
    [AutomationHelper]::SendKeys("^(a)")
    [AutomationHelper]::SendKeys("{DEL}")
    [AutomationHelper]::SendKeys($message)
    Start-Sleep 1
}

# ���C������
$mainForm = [AutomationHelper]::GetMainWindowByTitle("TODO���X�g")
if ($mainForm -eq $null) {
    Write-Error "Java Fx�̉�ʂ��N�����Ă�������"
    exit 1
}
$mainForm.SetFocus()
$editType = [System.Windows.Automation.ControlType]::Edit
$textCtrl = findFirstElement $mainForm $autoElem::ControlTypeProperty $editType

# Java8�̏ꍇValuePattern��SetValue�ŃG���[�ƂȂ�
$txtValuePtn = convertValuePattern $textCtrl
$txtGetValue = $txtValuePtn.Current.Value
Write-Host "�ύX�O�F$txtGetValue"
$txtValuePtn.SetValue("��ӂ�");
