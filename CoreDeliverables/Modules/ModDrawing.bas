Attribute VB_Name = "ModDrawing"

' ========================================================================================
' ModDrawing module provides utility functions for drawing, managing, and identifying
' shapes on an Excel worksheet, including adding nodes, erasing shapes/groups, and
' generating unique shape IDs.
' ========================================================================================

' Adds a new shape (node) to the specified worksheet.
' Parameters:
'   msoShape - The type of shape to add (MsoAutoShapeType).
'   id       - The unique name/ID for the shape.
'   text     - The text to display inside the shape.
'   width    - The width of the shape.
'   height   - The height of the shape.
'   x, y     - The position (in points) of the shape on the worksheet.
'   bold     - Whether the text should be bold.
'   style    - The style index for the shape.
'   ws       - The worksheet to add the shape to.
' Returns:
'   The created Shape object.

Public Function AddNode(ByVal msoShape As MsoAutoShapeType,
                        ByVal id As String,
                        ByVal text As String,
                        ByVal width As Single,
                        ByVal height As Single,
                        ByVal x As Single,
                        ByVal y As Single,
                        ByVal bold As Boolean,
                        ByVal style As MsoShapeStyleIndex,
                        ByVal ws As Worksheet) As Shape

    Dim node As Shape

    Set node = ws.Shapes.AddShape(msoShape, x, y, width, height)
    
    node.TextFrame.Characters.text = text
    node.TextFrame.HorizontalAlignment = xlHAlignCenter
    node.TextFrame.VerticalAlignment = xlVAlignCenter
    node.TextEffect.FontName = "Segoe UI"
    node.shapeStyle = style

    If bold Then
        node.TextEffect.FontBold = msoTrue
    End If

    node.name = id
    
    Set AddNode = node
End Function

' Removes all auto shapes from the specified worksheet.
' Parameters:
'   ws - The worksheet from which to remove shapes.
Public Sub EraseShapes(ByVal ws As Worksheet)
    ' Remove existing shapes
    Dim shp As Shape
    For Each shp In ws.Shapes
        If shp.Type = msoAutoShape Then
            shp.Delete
        End If
    Next shp
End Sub

' Removes all grouped shapes from the specified worksheet.
' Parameters:
'   ws - The worksheet from which to remove grouped shapes.
Sub EraseShapesGroups(ws As Worksheet)
    Dim shp As Shape
    Dim i As Long

    For i = ws.Shapes.Count To 1 Step -1
        Set shp = ws.Shapes(i)
        If shp.Type = msoGroup Then
            shp.Delete
        End If
    Next i
End Sub

' Generates a unique ID for a shape based on its text.
' Parameters:
'   txt - The text to use for generating the ID.
' Returns:
'   A string combining the first three letters and the length of the text.
Public Function CalculateID(ByVal txt As String) As String
    Dim firstLetter As String
    Dim lengthTxt As Long

    ' Trim leading/trailing spaces
    txt = Trim(txt)

    ' Get first letter
    firstLetter = Left(txt, 3)

    ' Get length
    lengthTxt = Len(txt)

    ' Return combined result
    CalculateID = firstLetter & "_" & lengthTxt
End Function

' Returns a dictionary of valid shapes on the worksheet, keyed by shape name.
' Parameters:
'   ws - The worksheet to scan for shapes.
' Returns:
'   Scripting.Dictionary with shape names as keys and Shape objects as values.
Public Function GetShapeDictionary(ws As Worksheet) As Scripting.Dictionary
    Dim shapeDict As New Scripting.Dictionary
    Dim shp As Shape

    ' Loop through all shapes in the worksheet
    For Each shp In ws.Shapes
        If IsValidShape(shp) Then
            Call AddShapeToDict(shp, shapeDict)
        End If
    Next shp
    
    Set GetShapeDictionary = shapeDict
End Function

' Adds a shape and its group items (if any) to the provided dictionary.
' Parameters:
'   shp  - The shape to add.
'   dict - The dictionary to add the shape to.
Private Sub AddShapeToDict(shp As Shape, ByRef dict As Scripting.Dictionary)
    Dim grpItem As Shape

    ' Add the shape's ID and Name
    If Not dict.exists(shp.name) Then
        dict.Add shp.name, shp
    End If

    ' If the shape is a group, loop through its items recursively
    If shp.Type = msoGroup Then
        For Each grpItem In shp.GroupItems
            Call AddShapeToDict(grpItem, dict)
        Next grpItem
    End If
End Sub

' Checks if a shape is valid (not a ghost shape).
' Parameters:
'   shp - The shape to check.
' Returns:
'   True if the shape is valid, False otherwise.
Private Function IsValidShape(shp As Shape) As Boolean
    On Error Resume Next
    Dim test As Single
    test = shp.Left   ' Ghost shapes cause an error here
    IsValidShape = (Err.Number = 0 And test <> 0)
    Err.Clear
End Function

