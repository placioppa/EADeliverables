VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "TechnologyCatalog"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
' ========================================================================================
' TechnologyCatalog class manages multiple selection in dropdown cells within a specified
' range, storing selections in a dictionary and handling worksheet activation and changes.
' ========================================================================================

' Stores cell values for multiple selections in dropdowns
Dim cellValues As Scripting.Dictionary
' Range containing the cells with dropdowns for relationships
Dim relRange As Range


Private Sub Worksheet_Activate()
    Dim wb As Workbook
    Set wb = ActiveWorkbook
    Call DefineRanges(wb)
End Sub



' Handles changes in worksheet cells.
' Manages multiple selections in dropdown cells and updates cellValues accordingly.
Private Sub Worksheet_Change(ByVal target As Range)
    On Error GoTo ErrorHandler
    
    Dim newVal As String
    Dim oldVal As String
    Dim separator As String
    Dim exists As Boolean
    Dim wb As Workbook
    Set wb = ActiveWorkbook
    
    separator = ", " ' Separator between selections
    exists = False
    
    ' Ensure ranges are defined
    If relRange Is Nothing Then
        Call DefineRanges(wb)
    End If
    
    ' Ensure cellValues dictionary is initialized
    If cellValues Is Nothing Then
        Set cellValues = New Scripting.Dictionary
    End If
    
    ' Check if the changed cell is within the relationship range
    If Not Intersect(target, relRange) Is Nothing Then
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
    End If
    
CleanExit:
    Application.EnableEvents = True
    Exit Sub

ErrorHandler:
    MsgBox "Error " & Err.Number & ": " & Err.Description, vbCritical, "Worksheet_Change Error"
    Resume CleanExit

End Sub

' DefineRanges function
' - Sets the relRange using the named range "ApplicationCatalog_Apps_Column" from the workbook
Function DefineRanges(ByVal wb As Workbook)
    Set relRange = Range("TechnologyCatalog_Apps_Column")
End Function
