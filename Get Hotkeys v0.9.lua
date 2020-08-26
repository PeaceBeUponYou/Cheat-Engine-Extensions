------------######  Author--------------PeaceBeUponYou
------------######  Community-----------Cheat The Game
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------######	Website:  https://cheatthegame.net
------------######	Facebook: https://facebook.com/groups/CheatTheGame?_rdc=1&_rdr
------------###### 	MY GitHub: https://github.com/PeaceBeUponYou/Cheat-Engine-Extensions
------------######	Version---------0.9
-------------------------------------------------------
local authorMenu = true
local checkMenu = nil
local authMenuCap = 'By PeaceBeUponYou'
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

local AL = getAddressList()
memR = AL.getMemoryRecord

local CNewMen = createMenuItem(checkMenu)
CNewMen.Caption = 'Get HotKeys Record'
checkMenu.add(CNewMen)

CNewMen.OnClick = function()
	print('Script Name'.."<------------------->"..'Number of Hotkeys'.."<------------------->"..'HotKey(s)')
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
		--print(jest)
		if jest ~= nil then
			print(gett.."<------------------->"..abc.."<------------------->"..jest)
			else
			print(gett.."<------------------->"..abc)
		end
	end
end
