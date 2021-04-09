------------######  Author--------------PeaceBeUponYou
------------######  Community-----------Cheat The Game
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------######	Website:  https://cheatthegame.net
------------######	Facebook: https://facebook.com/groups/CheatTheGame?_rdc=1&_rdr
-------------------------------------------------------

local currentExtCap = "Sig-Maker"----------NOTE: Edit Here!
--
local MR = getMemoryViewForm().DisassemblerView
local _MR = MR.PopupMenu.Items
--

local CNewMen = createMenuItem(_MR)
CNewMen.Caption = currentExtCap
_MR.Insert(3,CNewMen)
CNewMen.OnClick = function()
memV = getMemoryViewForm().DisassemblerView
store = ''
function selAddresses(frm)
	sel1 = memV.SelectedAddress
	sel2 = memV.SelectedAddress2
	if sel1 > sel2 then
	 return getAddress(sel2),getAddress(sel1)
	 else
	 return getAddress(sel1),getAddress(sel2)
	end
end


firstAdrs,lastAdrs = selAddresses(memV)
for i=0, (lastAdrs-firstAdrs) do
  if not ddis then ddis = getDefaultDisassembler() end
  if not firstAdrs then firstAdrs,lastAdrs = selAddresses(memV) end
   ddata = ddis.disassemble(firstAdrs)
   lastdata = ddis.getLastDisassembleData(ddata)
   theBytes = lastdata.bytes
  num = #theBytes
  firstAdrs = firstAdrs + num
  oneless = nil
  for j=1, num do
  if oneless == 1 and j ==num then break end
   if j==1 then
     str = ('%02X '):format(theBytes[1])
    if theBytes[1] >= 0x41 and theBytes[1] <= 0x4F then str = ('%s%02X '):format(str,theBytes[2]); oneless = 1 end --if its x64 upgraded instruction
   else
    str = str..'pp' --string..wildcard
  end
  end
  store = store..' '..str
  print(getNameFromAddress(lastdata.address),#theBytes,' ',str) --optional--to print each address with its wildcard
  if firstAdrs > lastAdrs then
   break
  end
end
 writeToClipboard(store)
 print(store)
end
