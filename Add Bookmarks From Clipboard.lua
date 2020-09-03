------------######  Author--------------PeaceBeUponYou
------------######  Community-----------Cheat The Game
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------######	Website:  https://cheatthegame.net
------------######	Facebook: https://facebook.com/groups/CheatTheGame?_rdc=1&_rdr
------------###### 	MY GitHub: https://github.com/PeaceBeUponYou/Cheat-Engine-Extensions
------------######  Ext Name: Assign to bookmarks from Clipboard
------------######  Ext Version: 0.9
-------------------------------------------------------



local mvf = getMemoryViewForm()
local getToPUMenu = mvf.DisassemblerView.PopupMenu

local crtNew = createMenuItem(getToPUMenu.Items)
crtNew.Name = 'cpyTOBMs'
crtNew.Caption = 'Assign Bookmarks from Clipboard'
getToPUMenu.Items.add(crtNew)
crtNew.OnClick = function ()
	local getFromCB = readFromClipboard()
	local nextLines = 0
	local tGetBMRecord = {}

	function isBMksClear()
		local getToSetBM = mvf.MenuItem23
		for i=0,getToSetBM.Count-1 do
			checkBMs = getToSetBM.Item[i].Caption
			findIt = checkBMs:find(':')
			if findIt then
			giveMessage = messageDialog('A saved bookmark found! Please erase it to continue.\n Do you want to erase it?',mtWarning,mbYes,mbNo)
				if giveMessage == mrYes then
				---
					for i= 0,getToPUMenu.Items.Count-1 do
						if getToPUMenu.Items.Item[i].Caption == 'Clear All Bookmarks' then
						   getToPUMenu.Items.Item[i].doClick()
						end
					end
				else
					error()
				end
			end
		end
	end

	isBMksClear()

	for i in getFromCB:gmatch('\n') do
		nextLines = nextLines + 1
	end

	local mindTheCount = 1
	for i = 1, nextLines do
		local trimmedString = getFromCB:sub(mindTheCount,getFromCB:find('\n',mindTheCount))
		mindTheCount = mindTheCount + getFromCB:find('\n')
		tGetBMRecord[1+#tGetBMRecord] = trimmedString:sub(1,#trimmedString-2)
	end

	local BUAddress = mvf.DisassemblerView.SelectedAddress
	local BUTop = mvf.DisassemblerView.TopAddress

	for i = 0, #tGetBMRecord-1 do
	   local cnvtToAddr = getAddress(tGetBMRecord[i+1])
	   mvf.DisassemblerView.SelectedAddress = cnvtToAddr
	   mvf.MenuItem23.Item[i].doClick()
	end

	mvf.DisassemblerView.TopAddress = BUTop
	mvf.DisassemblerView.SelectedAddress = BUAddress
end
