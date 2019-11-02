USE [M4StockManagementSystemDb]
GO

CREATE PROCEDURE [dbo].[CheckBalanceProcedure]
(
@categoryId int,
@companyId int
)
AS
BEGIN
	TRUNCATE TABLE tblCheckBalance

	IF @companyId<0 AND @categoryId<0
	BEGIN
		INSERT INTO tblCheckBalance(ItemId,TotalStockIn,TotalStockOut,BalanceQuantity)
		SELECT ItemId,0,0,0 FROM tblItem
	END
	ELSE IF @companyId<0 AND @categoryId>0
	BEGIN
		INSERT INTO tblCheckBalance(ItemId,TotalStockIn,TotalStockOut,BalanceQuantity)
		SELECT ItemId,0,0,0 FROM tblItem
		WHERE @categoryId=CategoryId
	END
	ELSE IF @companyId>0 AND @categoryId<0
	BEGIN
		INSERT INTO tblCheckBalance(ItemId,TotalStockIn,TotalStockOut,BalanceQuantity)
		SELECT ItemId,0,0,0 FROM tblItem
		WHERE @companyId=CompanyId
	END
	ELSE IF @companyId>0 AND @categoryId>0
	BEGIN
		INSERT INTO tblCheckBalance(ItemId,TotalStockIn,TotalStockOut,BalanceQuantity)
		SELECT ItemId,0,0,0 FROM tblItem
		WHERE @companyId=CompanyId AND @categoryId=CategoryId
	END

	UPDATE C
	SET C.TotalStockIn = S.Total
	FROM tblCheckBalance AS C
	INNER JOIN (select ItemId,SUM(InQuantity) as Total 
	from tblStockIn
	GROUP BY ItemId) as S
	on C.ItemId = S.ItemId

	UPDATE C
	SET C.TotalStockOut = S.Total
	FROM tblCheckBalance AS C
	INNER JOIN (select ItemId,SUM(OutQuantity) as Total 
	from tblStockOut
	GROUP BY ItemId) as S
	on C.ItemId = S.ItemId

	UPDATE tblCheckBalance
	SET BalanceQuantity=TotalStockIn-TotalStockOut

END

GO


