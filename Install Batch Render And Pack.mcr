macroScript BRAP_GC
Buttontext: "Batch Render And Pack"
category:"[3DGROUND]"
toolTip:"Batch Render And Pack"
Icon:#("UVWUnwrapView", 15)
(
	on execute do
	(
		szScript =  @"S:\00_Scripts\Batch Render And Pack.ms"
		try(fileIn(szScript)) catch(messageBox "Script not found! Download Batch Render And Pack again! (Check if disc S is mapped!)" title: "Warning!")
	)
)

fn addQuadMenuButton macro cat txt remove: false =
(
	quadMenu = menuMan.getViewportRightClickMenu #nonePressed
	theMenu = quadMenu.getMenu 1

	fn findMenuItem theMenu menuName =
	(
		for i in 1 to theMenu.numItems() where (theMenu.getItem i).getTitle() == menuName do return i
		return 0
	)

	fn unregisterMenuItem theMenu menuName =
	(	
		try
		(
			for i in 1 to theMenu.numItems() do
			(
				if((theMenu.getItem i).getTitle() == menuName) do
				(
					theMenu.removeItemByPosition i 	

					if((theMenu.getItem (i - 1)).getIsSeparator()) do theMenu.removeItemByPosition (i - 1)
				)
			)
		)catch()
	)

	item = try(findMenuItem theMenu "Select &Similar")catch(6)

	unregisterMenuItem theMenu txt
	
	if(not remove) do
	(
		quadItem = menuMan.createActionItem macro (cat)
		
		theMenu.addItem quadItem (item += 1)
	)
		
	menuMan.updateMenuBar()
)

addQuadMenuButton "BRAP_GC" "[3DGROUND]" "Batch Render And Pack" remove: true
addQuadMenuButton "BRAP_GC" "[3DGROUND]" "Batch Render And Pack" remove: false

szScript =  @"S:\00_Scripts\Batch Render And Pack.ms"
try(fileIn(szScript)) catch()