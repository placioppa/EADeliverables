Imports System.Net.Mime.MediaTypeNames

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ProcessCatalog"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
' ========================================================================================
' ProcessCatalog class manages multiple selection in dropdown cells within a specified
' range, storing selections in a dictionary and handling worksheet activation and changes.
' ========================================================================================

' Stores cell values for multiple selections in dropdowns
Dim capCellValues As Scripting.Dictionary
Dim busCellValues As Scripting.Dictionary
' Range containing the cells with dropdowns for relationships
Dim capRange As Range
Dim buRange As Range

Private Sub Worksheet_Activate()
    Dim wb As Workbook
    Set wb = ActiveWorkbook
    Call DefineRanges(wb)
End Sub

' Handles changes in worksheet cells.
' Manages multiple selections in dropdown cells and updates cellValues accordingly.
Private Sub Worksheet_Change(ByVal target As Range)
    On Error GoTo ErrorHandler

    Dim wb As Workbook
    Set wb = ActiveWorkbook
    
    
    ' Ensure cellValues dictionary is initialized
    If capCellValues Is Nothing Then
        Set capCellValues = New Scripting.Dictionary
    End If

    If busCellValues Is Nothing Then
        Set busCellValues = New Scripting.Dictionary
    End If

    ' Check if the changed cell is within the relationship range
    If Not Intersect(target, capRange) Is Nothing Then
        ProcessRange target, capCellValues
    End If

    If Not Intersect(target, buRange) Is Nothing Then
        ProcessRange target, busCellValues
    End If

CleanExit:
    Application.EnableEvents = True
    Exit Sub

ErrorHandler:
    MsgBox "Error " & Err.Number & ": " & Err.Description, vbCritical, "Worksheet_Change Error"
    Resume CleanExit

End Sub

Function ProcessRange(ByVal target As Range, ByVal cellValues As Scripting.Dictionary)
    Dim newVal As String
    Dim oldVal As String
    Dim separator As String
    Dim exists As Boolean

    separator = ", " ' Separator between selections
    exists = False

    Application.EnableEvents = False

    If target.text <> "" Then
        newVal = target.Value
        key = "R" & CStr(target.Row) & "C" & CStr(target.Column)

        ' Retrieve previous value if exists
        If cellValues.exists(key) Then
            oldVal = cellValues(key)
            exists = True
        End If

        ' Append new selection if not a duplicate
        If target.Offset(0, 0).Value <> "" Then
            ' Avoid duplicates
            If oldVal <> "" And InStr(1, oldVal, newVal) = 0 Then
                target.Value = oldVal & separator & newVal
            End If
        End If

        ' Update or add the value in the dictionary
        If exists Then
            cellValues(key) = target.Value
        Else
            cellValues.Add key, target.Value
        End If
    Else
        cellValues.RemoveAll
    End If

    Application.EnableEvents = True
End Function


' DefineRanges function
' - Sets the variables using the named ranges from the workbook
Function DefineRanges(ByVal wb As Workbook)
    Set buRange = Range("ProcessCatalog_BUOwner_Column")
    Set capRange = Range("ProcessCatalog_Capability_Column")
End Function



