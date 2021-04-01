/*
	HW-04_XML-CRUD
	
	For this assignment you are to process the following XML document using
	the AP database. You should review the first 16 minutes of the video I
	posted in the Week 9 module. This covers selecting text from a node
	as well as from a node's attributes.
	
		DO NOT CREATE A TEMP TABLE.
		DO NOT HAVE A SELECT STATEMENT AFTER EACH SECTION
		DO NOT CHANGE ANY CODE I HAVE CREATED FOR YOU

	AUTHOR: Will Beck

*/

DECLARE @xml AS XML = 
		'
			<AP-CRUD>
				<CREATE>
					<invoice id="150" venId="4" invNum="hw04-C01" invDate="2021-03-20" invTot="353.25" 
										paymentTot="145.26" creditTot="0.00" termsId="3" 
										invDueDate="2021-03-28" paymentDate="2021-03-25" isDeleted="0"  />
					
					<invoice id="151" venId="4" invNum="hw04-C02" invDate="2021-03-20" invTot="500.00" 
										paymentTot="0.00" creditTot="0.00" termsId="3" 
										invDueDate="2021-03-28" isDeleted="0"  />
				</CREATE>

				<READ>
					<vendor id="123">
						<comments>Top vendor!</comments>
						<recommendation>Vendor should get an award</recommendation>
					</vendor>
					<vendor id="1">
						<comments>Inactive vendor</comments>
						<recommendation>Possibly remove from system</recommendation>
					</vendor>
					<vendor id="114">
						<comments>Active vendor</comments>
						<recommendation>Review vendor inventory</recommendation>
					</vendor>
				</READ>

				<UPDATE>
					<term id="1" desc="Net due 10 days." days="10" /> 
					<term id="2" desc="Net due 20 days." days="20" /> 
					<term id="3" desc="Net due 30 days." days="30" /> 
					<term id="4" desc="Net due 60 days." days="60" /> 
					<term id="5" desc="Net due 90 days." days="90" /> 
					<vendor id="1" VendorName="US Postal Service (UPS)" /> 
				</UPDATE>

				<DELETE>
					<invoiceLineItems InvoiceID="12" />
				</DELETE>
			</AP-CRUD>
		'
--------------------------------------------------------------------- Start a Transaction
BEGIN TRAN

BEGIN TRY
--------------------------------------------------------------------- CREATE
	SET IDENTITY_INSERT Invoices ON 
		INSERT INTO Invoices (InvoiceID, VendorID, InvoiceNumber, InvoiceDate, InvoiceTotal, PaymentTotal, CreditTotal, termsId, InvoiceDueDate, paymentDate, isDeleted)
			SELECT id, venId, invNum, invDate, invTot, paymentTot, creditTot, termsId, invDueDate, paymentDate, isDeleted
			FROM (
				SELECT 	[id] 			= child.value('@id', 'int'),
						[venId] 		= child.value('@venId', 'int'),
						[invNum]		= child.value('@invNum', 'varchar(30)'),
						[invDate]		= child.value('@invDate', 'DATETIME'),
						[invTot] 		= child.value('@invTot', 'nvarchar(30)'),
						[paymentTot]	= child.value('@paymentTot', 'nvarchar(30)'),
						[creditTot]		= child.value('@creditTot', 'nvarchar(30)'),
						[termsId]		= child.value('@termsId', 'int'),
						[invDueDate]	= child.value('@invDueDate', 'DATETIME'),
						[paymentDate]	= child.value('@paymentDate', 'DATETIME'),
						[isDeleted]		= child.value('@isDeleted', 'bit')
				FROM @xml.nodes('AP-CRUD/CREATE') Parent(parent)
					CROSS APPLY parent.nodes('invoice') Child(child)
			) tbl
			WHERE NOT EXISTS(SELECT NULL FROM Invoices WHERE InvoiceID = tbl.id)
	SET IDENTITY_INSERT Invoices OFF

--------------------------------------------------------------------- READ
	-- Using the data in the READ section, produce an output that 
	-- combines the XML data with data from the Vendors table.
	-- Expected ouput:
	/*
		id		name							city		state		comments			recommendation
		---		---------------------------		-------		-------		---------------		---------------------------
		1		US Postal Service				Madison		WI			Inactive vendor		Possibly remove from system
		114		Postmaster						Fresno		CA			Active vendor		Review vendor inventory	
		123		Federal Express Corporation		Memphis		TN			Top vendor!			Vendor should get an award
	*/

	-- Note: You DO NOT need a CROSS APPLY but you will need to create a 
	--		 JOIN to the Vendors table. Use an EXPLICIT join

	SELECT	[id]				= v.VendorID,
			[name] 				= v.VendorName,
			[city]				= v.VendorCity,
			[state] 			= v.VendorState,
			[comments]			= CAST ( parent.query('comments/text()') AS VARCHAR(60) ),
			[recommendation]	= CAST ( parent.query('recommendation/text()') AS VARCHAR(80) )
	FROM @xml.nodes('AP-CRUD/READ/vendor') Parent(parent)
		JOIN Vendors v ON parent.value('@id', 'int') = v.VendorID
	ORDER BY v.VendorID
--------------------------------------------------------------------- UPDATE Terms
	UPDATE Terms
	SET 
		TermsDescription	= ISNULL(child.value('@desc', 'varchar(60)'), TermsDescription),
		TermsDueDays		= ISNULL(child.value('@days', 'int'), TermsDueDays)
	FROM @xml.nodes('AP-CRUD/UPDATE/term') Child(child)
	WHERE  TermsID = child.value('@id', 'int')
--------------------------------------------------------------------- UPDATE Vendors
	UPDATE Vendors
	SET 
		VendorName 		= ISNULL(child.value('@VendorName', 'varchar(80)'), VendorName)
	FROM @xml.nodes('AP-CRUD/UPDATE/vendor') Child(child)
	WHERE VendorID = child.value('@id', 'int')
--------------------------------------------------------------------- DELETE
	DELETE FROM InvoiceLineItems
		FROM @xml.nodes('AP-CRUD/DELETE') Child(child)
		WHERE InvoiceID = child.value('@id', 'int')
--=================================================================== Validation Check (DO NOT MODIFY)
	SELECT *	FROM Invoices			WHERE InvoiceID >= 150
	SELECT *	FROM Terms				WHERE TermsDescription LIKE '%.'
	SELECT *	FROM Vendors			WHERE VendorID = 1
	SELECT *	FROM InvoiceLineItems	WHERE InvoiceID = 12

END TRY BEGIN CATCH
	SELECT [ErrorMessage] = ERROR_MESSAGE(), [ErrorLine] = ERROR_LINE()
END CATCH

-- Clean up database
ROLLBACK TRAN