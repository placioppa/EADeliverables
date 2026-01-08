VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ImportData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Public Sub ImportUnits()
    Call PasteClipboardIntoNamedCell("ImportData_BUStart_Cell")
End Sub

Public Sub ImportCapabilities()
    Call PasteClipboardIntoNamedCell("ImportData_CapabilityStart_Cell")
End Sub


Private Sub PasteClipboardIntoNamedCell(ByVal startCellName As String)
   
    Dim startCell As Range
    Dim txt As String
    Dim rowsArr() As String
    Dim colsArr() As String
    Dim r As Long, c As Long
    Dim delimCol As String

    On Error GoTo ErrHandler

    Set startCell = ThisWorkbook.Names(startCellName).RefersToRange

    ' 1) Read clipboard text (use the same cross-platform GetClipboardText helper you already have)
    txt = GetClipboardText()
    If Len(txt) = 0 Then
        MsgBox "Clipboard is empty or not text.", vbExclamation
        Exit Sub
    End If

    ' Normalize line endings (CRLF / CR / LF)
    txt = Replace(txt, vbCrLf, vbLf)
    txt = Replace(txt, vbCr, vbLf)

    ' 2) Split into rows
    rowsArr = Split(txt, vbLf)

    Application.ScreenUpdating = False

    ' 3) For each row, split into columns (auto-detect common delimiters)
    For r = LBound(rowsArr) To UBound(rowsArr)
        Dim line As String
        line = Trim$(rowsArr(r))
        If Len(line) = 0 Then
            ' Skip blank lines
            GoTo NextRow
        End If

        ' Auto-detect column delimiter: tab > comma > semicolon
        If InStr(line, vbTab) > 0 Then
            delimCol = vbTab
        ElseIf InStr(line, ",") > 0 Then
            delimCol = ","
        ElseIf InStr(line, ";") > 0 Then
            delimCol = ";"
        Else
            delimCol = "" ' Single value in the row
        End If

        If delimCol <> "" Then
            colsArr = Split(line, delimCol)
            For c = LBound(colsArr) To UBound(colsArr)
                startCell.Offset(r, c).Value = Trim$(colsArr(c))
            Next c
        Else
            ' Single value ? write to the first column
            startCell.Offset(r, 0).Value = line
        End If

NextRow:
    Next r

    Application.ScreenUpdating = True
    Exit Sub

ErrHandler:
    MsgBox "Paste failed: " & Err.Description, vbCritical
End Sub

'========================
' GetClipboardText (macOS / Windows)
'========================
Public Function GetClipboardText() As String
#If Mac Then
    GetClipboardText = MacGetClipboardText()
#Else
    GetClipboardText = GetTextFromClipboard
#End If
End Function
