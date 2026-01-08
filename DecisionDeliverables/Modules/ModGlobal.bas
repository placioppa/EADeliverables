Attribute VB_Name = "ModGlobal"
' ========================================================================================
' ModGlobal module provides utility functions for copying text to the clipboard.
' It supports both macOS (using AppleScript) and Windows (using Win32 API).
' The main public function is CopyTextToClipboard, which is implemented per platform.
' ========================================================================================

Option Explicit

#If Mac Then
'-----------------------------
' macOS: Use AppleScript to set clipboard contents
'-----------------------------

' Copies the specified text to the macOS clipboard using AppleScript.
' Returns True if successful, False otherwise.
Public Function CopyTextToClipboard(ByVal txt As String) As Boolean
    On Error GoTo ErrHandler
    ' Prepare AppleScript to set clipboard to the provided text.
    Dim script As String
    script = "set the clipboard to " & appleScriptQuoted(txt)
    ' Register macro description for Excel's Macro dialog (optional).
    Application.MacroOptions Macro:="CopyTextToClipboard", Description:="Copy text to macOS clipboard"
    ' Execute the AppleScript.
    Application.Run "MacScript", script
    CopyTextToClipboard = True
    Exit Function
ErrHandler:
    CopyTextToClipboard = False
End Function

' Escapes and quotes a string for safe use in AppleScript.
Private Function appleScriptQuoted(ByVal s As String) As String
    ' Escape backslashes.
    s = Replace(s, "\", "\\")
    ' Escape double quotes.
    s = Replace(s, """", "\""")
    ' Wrap in double quotes for AppleScript.
    appleScriptQuoted = """" & s & """"
End Function

#Else
'-----------------------------
' Windows: Use Win32 API to set clipboard contents
'-----------------------------

' Win32 API declarations for clipboard and memory management (64-bit safe).
Private Declare PtrSafe Function OpenClipboard Lib "user32" (ByVal hWnd As LongPtr) As Long
Private Declare PtrSafe Function CloseClipboard Lib "user32" () As Long
Private Declare PtrSafe Function EmptyClipboard Lib "user32" () As Long
Private Declare PtrSafe Function SetClipboardData Lib "user32" (ByVal wFormat As Long, ByVal hMem As LongPtr) As LongPtr
Private Declare PtrSafe Function GetClipboardData Lib "user32" (ByVal uFormat As Long) As LongPtr
Private Declare PtrSafe Function GlobalAlloc Lib "kernel32" (ByVal uFlags As Long, ByVal dwBytes As LongPtr) As LongPtr
Private Declare PtrSafe Function GlobalLock Lib "kernel32" (ByVal hMem As LongPtr) As LongPtr
Private Declare PtrSafe Function GlobalUnlock Lib "kernel32" (ByVal hMem As LongPtr) As Long
Private Declare PtrSafe Function lstrcpyW Lib "kernel32" (ByVal lpString1 As LongPtr, ByVal lpString2 As LongPtr) As LongPtr
Private Declare PtrSafe Sub RtlMoveMemory Lib "kernel32" (ByRef dest As Any, ByVal src As LongPtr, ByVal cb As LongPtr)

' Memory allocation and clipboard format constants.
Private Const GMEM_MOVEABLE As Long = &H2
Private Const CF_UNICODETEXT As Long = 13

' Copies the specified text to the Windows clipboard as Unicode text.
' Returns True if successful, False otherwise.
Public Function CopyTextToClipboard(ByVal txt As String) As Boolean
    On Error GoTo ErrHandler

    Dim hGlobal As LongPtr      ' Handle to global memory block
    Dim pGlobal As LongPtr      ' Pointer to locked memory
    Dim bytes As LongPtr        ' Number of bytes to allocate

    ' Calculate bytes needed for UTF-16 string (2 bytes per char + 2 for null terminator).
    bytes = (Len(txt) * 2) + 2

    ' Allocate moveable global memory.
    hGlobal = GlobalAlloc(GMEM_MOVEABLE, bytes)
    If hGlobal = 0 Then GoTo ErrHandler

    ' Lock the memory to get a pointer.
    pGlobal = GlobalLock(hGlobal)
    If pGlobal = 0 Then GoTo ErrHandler

    ' Copy the string to the allocated memory (as UTF-16).
    ' lstrcpyW copies wide (Unicode) strings.
    Call lstrcpyW(pGlobal, StrPtr(txt))

    ' Unlock the memory.
    Call GlobalUnlock(hGlobal)

    ' Open the clipboard for this process.
    If OpenClipboard(0) = 0 Then GoTo ErrHandler
    ' Empty the clipboard.
    Call EmptyClipboard
    ' Set the clipboard data to the memory block.
    If SetClipboardData(CF_UNICODETEXT, hGlobal) = 0 Then
        ' If setting clipboard data fails, close clipboard and handle error.
        Call CloseClipboard
        GoTo ErrHandler
    End If

    ' After SetClipboardData succeeds, clipboard owns the memory.
    Call CloseClipboard

    CopyTextToClipboard = True
    Exit Function

ErrHandler:
    CopyTextToClipboard = False
End Function


Public Function GetTextFromClipboard() As String
    Dim hData As LongPtr, pData As LongPtr
    Dim buf() As Byte
    Dim i As Long, ch As Integer

    On Error GoTo Clean

    If OpenClipboard(0) = 0 Then Exit Function
    hData = GetClipboardData(CF_UNICODETEXT)
    If hData = 0 Then GoTo Clean

    pData = GlobalLock(hData)
    If pData = 0 Then GoTo Clean

    ' Read until null terminator (UTF-16)
    ' We'll read in chunks; grow as needed
    ReDim buf(0 To 4095) ' 4096 bytes to start
    RtlMoveMemory buf(0), pData, 4096

    ' Find terminator
    i = 0
    Do While True
        If i + 1 > UBound(buf) Then
            ' enlarge buffer and read more
            ReDim Preserve buf(0 To UBound(buf) + 4096)
            RtlMoveMemory buf(UBound(buf) - 4095), pData + (UBound(buf) - 4095), 4096
        End If
        If buf(i) = 0 And buf(i + 1) = 0 Then Exit Do
        i = i + 2
    Loop

    ' Convert bytes (UTF-16 LE) to VBA string
    Dim s As String
    Dim j As Long
    s = ""
    j = 0
    Do While j < i
        ' 2 bytes per char -> low + high
        ch = buf(j) + buf(j + 1) * 256
        s = s & ChrW$(ch)
        j = j + 2
    Loop

    GetTextFromClipboard = s

Clean:
    If hData <> 0 And pData <> 0 Then If hData <> 0 And pData <> 0 Then Call GlobalUnlock(hData)
    Call CloseClipboard
End Function

#End If

' Find by CodeName even when wb is not ThisWorkbook
Function GetWorksheetByCodeName(ByVal wb As Workbook, ByVal codeName As String) As Worksheet
    Dim ws As Worksheet
    For Each ws In wb.Worksheets
        If ws.codeName = codeName Then
            Set GetWorksheetByCodeName = ws
            Exit Function
        End If
    Next
End Function

