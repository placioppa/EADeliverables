Imports System.Net.Mime.MediaTypeNames

VERSION 1.0 CLASS
BEGIN
MultiUse = -1  'True
End
Attribute VB_Name = "AppBuMatrix"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
' Triggered when the worksheet is activated
' Refreshes the Power query datasources and Pivot table
Private Sub Worksheet_Activate()
    ThisWorkbook.Queries("ApplicationCatalogQuery").Refresh

    'Optional delay to ensure query completes
    Application.CalculateUntilAsyncQueriesDone

    Me.PivotTables("AppBUPivotTable").RefreshTable
End Sub