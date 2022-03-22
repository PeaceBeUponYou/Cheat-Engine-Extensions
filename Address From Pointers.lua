------------######  Author--------------PeaceBeUponYou
------------######  Community-----------Cheat The Game
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------###### 	MY GitHub: https://github.com/PeaceBeUponYou/Cheat-Engine-Extensions
------------######  Ext Name: Copy Address from A pointer
------------######  Ext Version: 0.1.1
-------------------------------------------------------
--creating item in PopupMenu2
mm = MainForm.PopupMenu2
local crtItem = createMenuItem(mm.Items)
crtItem.Name = "copyAddress1"
crtItem.Caption = "Copy Selected Address"
crtItem.Shortcut = "CTRL+ALT+C"
mm.Items.Insert(1,crtItem)

local crtItem2 = createMenuItem(mm.Items)
crtItem2.Name = "copyAddress2"
crtItem2.Caption = "Add as an Address"
mm.Items.Insert(2,crtItem2)

--copy address to clipboard
adl = getAddressList()
crtItem.OnClick = function()
	sel = adl.SelectedRecord
	if not sel then showMessage("Invalid Address"); return end;
	if not (sel.Address) then showMessage("Invalid Address"); return end;
	if sel.CachedAddress then
		writeToClipboard(('%X'):format(sel.CachedAddress))
	else
		writeToClipboard(('%X'):format(sel.Address))
	end
end

--CopyAddress from Pointer and paste as single address
crtItem2.OnClick = function()
	sel = adl.SelectedRecord
	if not sel then showMessage("Invalid Address"); return end;
	if not (sel.Address) then showMessage("Invalid Address"); return end;
	crtRec = adl.createMemoryRecord()
	crtRec.Address = (sel.CachedAddress) and ('%X'):format(sel.CachedAddress) or ('%X'):format(sel.Address)
	crtRec.Description = "PointedAddress"
end
