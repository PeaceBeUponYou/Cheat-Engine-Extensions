------------######  Author--------------PeaceBeUponYou
------------######  Community-----------Cheat The Game
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------######	Website:  https://cheatthegame.net
------------######	Facebook: https://facebook.com/groups/CheatTheGame?_rdc=1&_rdr
------------###### 	MY GitHub: https://github.com/PeaceBeUponYou/Cheat-Engine-Extensions
-------------------------------------------------------
local authorMenu = true
local checkMenu = nil
local authMenuCap = 'By PeaceBeUponYou'
local currentExtCap = 'Launch Lua Engine'----------NOTE: Edit Here!
--
local MR = getMainForm().Menu
local _MR = MR.Items
--
if authorMenu then
	for i=0,_MR.Count-1 do
		if _MR.Item[i].Caption == authMenuCap then   --If already exists
			checkMenu = _MR.Item[i]
			break
		end
	end
	if not checkMenu then	--If is not present then create
		checkMenu = createMenuItem(MR)
		checkMenu.Caption = authMenuCap
		MR.Items.add(checkMenu)
	end
else
	checkMenu = _MR
end
local CNewMen = createMenuItem(checkMenu)
CNewMen.Caption = currentExtCap
checkMenu.add(CNewMen)

CNewMen.OnClick = function()
	getLuaEngine().show()
end



