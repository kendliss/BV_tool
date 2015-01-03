CREATE TABLE [Commitment_Versions].[CV_2012_Final_Billing_View] (
    [Flight_Plan_Record_ID] INT        NOT NULL,
    [Bill_Date]             DATETIME   NULL,
    [Bill_Amount]           FLOAT (53) NULL
);


GO
DENY ALTER
    ON OBJECT::[Commitment_Versions].[CV_2012_Final_Billing_View] TO [guest]
    AS [JAVELIN\nbrindza];


GO
DENY DELETE
    ON OBJECT::[Commitment_Versions].[CV_2012_Final_Billing_View] TO [guest]
    AS [JAVELIN\nbrindza];


GO
DENY INSERT
    ON OBJECT::[Commitment_Versions].[CV_2012_Final_Billing_View] TO [guest]
    AS [JAVELIN\nbrindza];


GO
DENY UPDATE
    ON OBJECT::[Commitment_Versions].[CV_2012_Final_Billing_View] TO [guest]
    AS [JAVELIN\nbrindza];

