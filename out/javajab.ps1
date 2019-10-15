# 64bit前提
$dllPath = Split-Path $MyInvocation.MyCommand.Path
Set-Item Env:Path "$Env:Path;$dllPath"
Add-Type -Path "$dllPath\JabApi.dll"
[JabApiLib.JavaAccessBridge.JabHelpers]::init()
$vmID = 0
$javaTree = [JabApiLib.JavaAccessBridge.JabHelpers]::GetComponentTreeByTitle("ToDoリスト",[ref]$vmID)
$txt = $javaTree.children[0].children[1].children[0].children[0].children[1]
[JabApiLib.JavaAccessBridge.JabApi]::setTextContents($vmID, $txt.acPtr, "わろすわろす")

# クリック
$button = $javaTree.children[0].children[1].children[0].children[0].children[2].children[0]
[JabApiLib.JavaAccessBridge.JabHelpers]::DoAccessibleActions($vmID, $button.acPtr, "クリック")

#
[JabApiLib.JavaAccessBridge.JabApi]::setTextContents($vmID, $txt.acPtr, "あああああ")
[JabApiLib.JavaAccessBridge.JabHelpers]::DoAccessibleActions($vmID, $button.acPtr, "クリック")

#
[JabApiLib.JavaAccessBridge.JabApi]::setTextContents($vmID, $txt.acPtr, "いいいいい")
[JabApiLib.JavaAccessBridge.JabHelpers]::DoAccessibleActions($vmID, $button.acPtr, "クリック") 

# 更新の確認
$javaTree = [JabApiLib.JavaAccessBridge.JabHelpers]::GetComponentTreeByTitle("ToDoリスト",[ref]$vmID)
$list = $javaTree.children[0].children[1].children[0].children[0].children[0].children[0].children[0]
foreach($item in $list.children) {
  Write-Host $item.name
}
[JabApiLib.JavaAccessBridge.JabHelpers]::DoAccessibleActions($vmID, $list.children[1].acPtr, "クリック") 
