
#打开IE窗口
 
 
#
#等待IE加载完毕
#
function Wait-IEReady([int]$TimeoutSeconds=10)
{
    
}
 
#
# 根据ID，Class，Name，Tag获取HTML元素
#
function Get-HtmlElement ($Id,$Name,$Class,$Tag)
{
  if($Id)
  {
    return $IEHost.Document.getElementById($id)
  }
  elseif($Name)
  {
    return $IEHost.Document.getElementsByName($Name)
  }
  elseif($Class)
  {
    $IEHost.Document.all |　where {$_.className -contains $Class}
  }
  elseif($Tag)
  {
    $IEHost.Document.getElementsByTagName($Tag)
  }
    
}
 
#
#关闭IE窗口
#
function Close-IEWindow
{
    $Global:IEHost.quit()
    Remove-Variable IEHost -Force
}
 
#
#设置IE的地址
#
function Navigate-IE($Url)
{
 Set-IE -URL $Url
}
  
#
# 设置IE的地址，或者动作：前进，倒退，刷新
#
function Set-IE
{
 param(
 [ValidateSet('GoBack', 'GoForward','Refresh')]
 [string]$Action,
 [uri]$URL
 )
  
 # 动作
 switch($Action)
 {
  ('GoBack'){ $Global:IEHost.GoBack() }
  ('GoForward'){  $Global:IEHost.GoForward() }
  ('Refresh'){ $Global:IEHost.Refresh() }
 }
  
 # 设置IE地址
 if( $URL) {
 $Global:IEHost.Navigate($URL) }
}
  
#
# 在IE窗口中执行脚本
#
function Invoke-IEScript($Code,$Language='Javascript')
{
 if( -not [string]::IsNullOrWhiteSpace($Code))
 {
  $Global:IEHost.Document.parentWindow.execScript($Code,$Language)
 }
}
#----------------------------------------------------------
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
 
Get-Content .\cookie.txt  | foreach {
#vr 6   .weibo.com  /
$line=$_ -split '/' | select -First 1
$tokens=$_.Split('  ',[System.StringSplitOptions]::RemoveEmptyEntries)
$c=@{
 name=$tokens[0]
 value=$tokens[1]
 domain=$tokens[2]
}
 $cookie = New-Object System.Net.Cookie
 $cookie.Name=$c.name
 $cookie.Value=$c.Value
 $cookie.Domain=$c.domain
 $session.Cookies.Add($cookie) 
}
 
for($i=1;$i -le 214555;$i++){
$r=Invoke-RestMethod "http://weibo.com/aj/v6/comment/big?ajwvr=6&id=4009043251108698&page=$i&__rnd=1471928579930" -WebSession $session -UserAgent 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.106 Safari/537.36'
$page = $i.ToString().PadLeft('7','0')
$r.data.html | Out-File "E:\weibo.data\$page.html"
Write-Host "正在下载 $page 页"
}
$url = "http://web.com/login.html"
$username="username"
$password="password"
$ie = new-object -com "InternetExplorer.ApplicationMedium"
$ie.visible=$false
$ie.navigate("$url")
while($ie.ReadyState -ne 4) {start-sleep -m 100}
$ie.Document.IHTMLDocument3_getElementById("account").value = $username
$ie.Document.IHTMLDocument3_getElementById("acc_pass").value = $password
$ie.Document.IHTMLDocument3_getElementById("account_login_checkbox").checked=$true
$ie.Document.IHTMLDocument3_getElementById("account_login_btn").click()
start-sleep -m 1000
$ie.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)
Remove-Variable ie