VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ImportData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True

'========================================================================================
' ImportData class provides methods to import tabular data from the clipboard
' into named ranges in the workbook. Supports both macOS and Windows clipboard access.
'========================================================================================

' Imports units data from the clipboard into the named cell "ImportData_BUStart_Cell".
Public Sub ImportUnits()
    Call PasteClipboardIntoNamedCell("ImportData_BUStart_Cell")
End Sub

' Imports capabilities data from the clipboard into the named cell "ImportData_CapabilityStart_Cell".
Public Sub ImportCapabilities()
    Call PasteClipboardIntoNamedCell("ImportData_CapabilityStart_Cell")
End Sub

'----------------------------------------------------------------------------------------
' Pastes clipboard text into the specified named cell, parsing rows and columns.
' Handles auto-detection of column delimiters (tab, comma, semicolon).
' startCellName: The name of the named range where data import should begin.
'----------------------------------------------------------------------------------------
Private Sub PasteClipboardIntoNamedCell(ByVal startCellName As String)

    Dim startCell As Range         ' Target cell to start pasting data
    Dim txt As String              ' Clipboard text
    Dim rowsArr() As String        ' Array of rows
    Dim colsArr() As String        ' Array of columns for each row
    Dim r As Long, c As Long       ' Row and column counters
    Dim delimCol As String         ' Detected column delimiter

    On Error GoTo ErrHandler

    ' Get the range object for the named cell
    Set startCell = ThisWorkbook.Names(startCellName).RefersToRange

    ' 1) Read clipboard text (cross-platform)
    txt = GetClipboardText()
    If Len(txt) = 0 Then
        MsgBox "Clipboard is empty or not text.", vbExclamation
        Exit Sub
    End If

    ' Normalize line endings to LF
    txt = Replace(txt, vbCrLf, vbLf)
    txt = Replace(txt, vbCr, vbLf)

    ' 2) Split text into rows
    rowsArr = Split(txt, vbLf)

    Application.ScreenUpdating = False

    ' 3) For each row, split into columns using detected delimiter
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
            ' Split row into columns and paste each value
            colsArr = Split(line, delimCol)
            For c = LBound(colsArr) To UBound(colsArr)
                startCell.Offset(r, c).Value = Trim$(colsArr(c))
            Next c
        Else
            ' Single value: write to the first column
            startCell.Offset(r, 0).Value = line
        End If

NextRow:
    Next r

    Application.ScreenUpdating = True
    Exit Sub

ErrHandler:
    MsgBox "Paste failed: " & Err.Description, vbCritical
End Sub

'========================================================================================
' GetClipboardText (cross-platform)
' Returns the current clipboard text using platform-specific helper functions.
'========================================================================================
Public Function GetClipboardText() As String
#If Mac Then
    GetClipboardText = MacGetClipboardText()
#Else
    GetClipboardText = GetTextFromClipboard
#End If
End Function
