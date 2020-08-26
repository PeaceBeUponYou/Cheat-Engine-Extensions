------------######  Author--------------PeaceBeUponYou
------------######  Community-----------Cheat The Game
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------######	Website:  https://cheatthegame.net
------------######	Facebook: https://facebook.com/groups/CheatTheGame?_rdc=1&_rdr
------------######  Version------------1.1
-------------------------------------------------------

local authorMenu = true
local checkMenu = nil
local authMenuCap = 'By PeaceBeUponYou'
--
local MR = getMainForm().Menu
local _MR = MR.Items
--
getLuaEngine().mOutput.Font.Assign(getLuaEngine().mScript.Font)
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

local AL = getAddressList()
memR = AL.getMemoryRecord

local CNewMen = createMenuItem(checkMenu)
CNewMen.Caption = 'Get HotKeys Record'
checkMenu.add(CNewMen)

CNewMen.OnClick = function()
function setw(str,max)
  return (' '):rep(math.max(0,max-#str))
end
print('Script Name'..setw('Script Name',45)..'Number of Hotkeys'..setw('Number of Hotkeys',25)..'HotKey(s)')
	for i=0,AL.Count-1 do
		as = memR(i) --which Record
		gett = as.Description
		--print(gett)-- to get description
		abc = as.HotkeyCount
		local jest = nil
		if abc ~= 0 then
			local mrh = memoryrecord_getHotkeyByID(as)
			jest = memoryrecordhotkey_getHotkeyString(mrh)
		end
		--print(gett)
		if jest ~= nil then
			print(gett..setw(gett,45)..abc..setw(tostring(abc),25)..jest)
			else
			print(gett..setw(gett,45)..abc)
		end
	end
end
