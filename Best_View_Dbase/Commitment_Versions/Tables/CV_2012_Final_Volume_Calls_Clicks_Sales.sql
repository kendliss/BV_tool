﻿CREATE TABLE [Commitment_Versions].[CV_2012_Final_Volume_Calls_Clicks_Sales] (
    [Flight_Plan_Record_FK]       INT        NULL,
    [Media_Week]                  INT        NULL,
    [Volume]                      FLOAT (53) NULL,
    [Calls]                       FLOAT (53) NULL,
    [Clicks]                      FLOAT (53) NULL,
    [IPTV_Call_Sales]             FLOAT (53) NULL,
    [IPTV_Click_Sales]            FLOAT (53) NULL,
    [HSIA_Call_Sales]             FLOAT (53) NULL,
    [HSIA_Click_Sales]            FLOAT (53) NULL,
    [DSLREG_Call_Sales]           FLOAT (53) NULL,
    [DSLREG_Click_Sales]          FLOAT (53) NULL,
    [DSLDRY_Call_Sales]           FLOAT (53) NULL,
    [DSLDRY_Click_Sales]          FLOAT (53) NULL,
    [ACCLNE_Call_Sales]           FLOAT (53) NULL,
    [ACCLNE_Click_Sales]          FLOAT (53) NULL,
    [Wireless_Voice_Call_Sales]   FLOAT (53) NULL,
    [Wireless_Voice_Click_Sales]  FLOAT (53) NULL,
    [Wireless_Family_Call_Sales]  FLOAT (53) NULL,
    [Wireless_Family_Click_Sales] FLOAT (53) NULL,
    [Wireless_Data_Call_Sales]    FLOAT (53) NULL,
    [Wireless_Data_Click_Sales]   FLOAT (53) NULL,
    [VOIP_Call_Sales]             FLOAT (53) NULL,
    [VOIP_Click_Sales]            FLOAT (53) NULL,
    [DISH_Call_Sales]             FLOAT (53) NULL,
    [DISH_Click_Sales]            FLOAT (53) NULL,
    [IPDSL_Call_Sales]            FLOAT (53) NULL,
    [IPDSL_Click_Sales]           FLOAT (53) NULL
);


GO
DENY ALTER
    ON OBJECT::[Commitment_Versions].[CV_2012_Final_Volume_Calls_Clicks_Sales] TO [guest]
    AS [JAVELIN\nbrindza];


GO
DENY DELETE
    ON OBJECT::[Commitment_Versions].[CV_2012_Final_Volume_Calls_Clicks_Sales] TO [guest]
    AS [JAVELIN\nbrindza];


GO
DENY INSERT
    ON OBJECT::[Commitment_Versions].[CV_2012_Final_Volume_Calls_Clicks_Sales] TO [guest]
    AS [JAVELIN\nbrindza];


GO
DENY TAKE OWNERSHIP
    ON OBJECT::[Commitment_Versions].[CV_2012_Final_Volume_Calls_Clicks_Sales] TO [guest]
    AS [JAVELIN\nbrindza];


GO
DENY UPDATE
    ON OBJECT::[Commitment_Versions].[CV_2012_Final_Volume_Calls_Clicks_Sales] TO [guest]
    AS [JAVELIN\nbrindza];

