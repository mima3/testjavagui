# 64bit�O��
$dllPath = Split-Path $MyInvocation.MyCommand.Path
Set-Item Env:Path "$Env:Path;$dllPath"
Add-Type -Path "$dllPath\JabApi.dll"
[JabApiLib.JavaAccessBridge.JabHelpers]::init()
$vmID = 0
$javaTree = [JabApiLib.JavaAccessBridge.JabHelpers]::GetComponentTreeByTitle("ToDo���X�g",[ref]$vmID)
$txt = $javaTree.children[0].children[1].children[0].children[0].children[1]
[JabApiLib.JavaAccessBridge.JabApi]::setTextContents($vmID, $txt.acPtr, "��낷��낷")

# �N���b�N
$button = $javaTree.children[0].children[1].children[0].children[0].children[2].children[0]
[JabApiLib.JavaAccessBridge.JabHelpers]::DoAccessibleActions($vmID, $button.acPtr, "�N���b�N")

#
[JabApiLib.JavaAccessBridge.JabApi]::setTextContents($vmID, $txt.acPtr, "����������")
[JabApiLib.JavaAccessBridge.JabHelpers]::DoAccessibleActions($vmID, $button.acPtr, "�N���b�N")

#
[JabApiLib.JavaAccessBridge.JabApi]::setTextContents($vmID, $txt.acPtr, "����������")
[JabApiLib.JavaAccessBridge.JabHelpers]::DoAccessibleActions($vmID, $button.acPtr, "�N���b�N") 

# �X�V�̊m�F
$javaTree = [JabApiLib.JavaAccessBridge.JabHelpers]::GetComponentTreeByTitle("ToDo���X�g",[ref]$vmID)
$list = $javaTree.children[0].children[1].children[0].children[0].children[0].children[0].children[0]
foreach($item in $list.children) {
  Write-Host $item.name
}
[JabApiLib.JavaAccessBridge.JabHelpers]::DoAccessibleActions($vmID, $list.children[1].acPtr, "�N���b�N") 
