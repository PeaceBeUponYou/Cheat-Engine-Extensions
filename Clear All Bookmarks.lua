------------######  Author--------------PeaceBeUponYou
------------######  Community-----------Cheat The Game
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------######	Website:  https://cheatthegame.net
------------######	Facebook: https://facebook.com/groups/CheatTheGame?_rdc=1&_rdr
------------###### 	MY GitHub: https://github.com/PeaceBeUponYou/Cheat-Engine-Extensions
-------------------------------------------------------

local mf = getMemoryViewForm().DisassemblerView.PopupMenu
local capMf = 'Set/Unset bookmark'
local NewFormCap = 'Clear All Bookmarks'

local ctNew = createMenuItem(mf.Items)
ctNew.Caption = NewFormCap
mf.Items.add(ctNew)
ctNew.OnClick = function()
	function getBMsavePoint(gMenu,mName)
		for i=0,gMenu.Items.Count-1 do
			if gMenu.Items.Item[i].Caption == mName then
				return gMenu.Items.Item[i]
			end
		end
	end
	local getResult = getBMsavePoint(mf,capMf)
	local getPromp = messageDialog("Do you really want to clear all bookmarks?",mtConformation,mbYes,mbNo)
	if getPromp == mrYes then
		for j=0,getResult.Count-1 do
			local getNew = getResult.Item[j]
			local checkOne = getNew.Caption:match('Bookmark %d: (.+)')
			while checkOne and getNew.Caption:find(':') do
				keyDown(VK_CONTROL)
				getNew.doClick()
				keyUp(VK_CONTROL)
				sleep(10)
			end
		end
	end
end
