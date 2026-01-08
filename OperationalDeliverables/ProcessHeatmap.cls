VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ProcessHeatmap"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
' Triggered when the worksheet is activated
' Refreshes the Power query datasources
Private Sub Worksheet_Activate()
    ThisWorkbook.Queries("ProcessCapabilityQuery").Refresh
    ThisWorkbook.Queries("ProcessBUQuery").Refresh
End Sub


