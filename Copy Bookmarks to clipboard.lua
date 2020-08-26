------------######  Author--------------PeaceBeUponYou
------------######  Community-----------Cheat The Game
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------######	Website:  https://cheatthegame.net
------------######	Facebook: https://facebook.com/groups/CheatTheGame?_rdc=1&_rdr
------------###### 	MY GitHub: https://github.com/PeaceBeUponYou/Cheat-Engine-Extensions
-------------------------------------------------------

local NewFormCap = 'Copy All Bookmarks to the Clipboard'
local abookmark = getMemoryViewForm().DisassemblerView.PopupMenu
local ctNew = createMenuItem(abookmark.Items)
ctNew.Caption = NewFormCap
abookmark.Items.add(ctNew)
ctNew.OnClick = function()
--Getting to Item: "Set/Unset bookmark"
function getTheItems(gMenu,mName)
	for i=0,gMenu.Items.Count-1 do
	  if gMenu.Items.Item[i].Caption == mName then
		 return gMenu.Items.Item[i]
	  end
	end
end


local requiredName = "Set/Unset bookmark"
local gettingTarget = {}
local getResult = getTheItems(abookmark,requiredName)
--Getting Bookmarks
for i=0,getResult.Count-1 do
local readName = getResult.Item[i].Caption:match('Bookmark %d: (.+)')
  if readName then
    gettingTarget[#gettingTarget+1] = readName
  end
end
local str = table.concat(gettingTarget, ('\n'))
writeToClipboard(str)
end

--print(str)
--getTheItems(abookmark,requiredName)

--local addMen = nil
