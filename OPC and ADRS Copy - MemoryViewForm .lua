------------######  Author--------------PeaceBeUponYou
------------######  Community-----------Cheat The Game
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------######	Website:  https://cheatthegame.net
------------######	Facebook: https://facebook.com/groups/CheatTheGame?_rdc=1&_rdr
-------------------------------------------------------

local currentExtCap = {"TRACING-- Usual", "TRACING-- Main","TRACING-- FINISH"}----------NOTE: Edit Here!
string1 = ' --> '
string2 = ' // '
string3 = ' ; '
--
local MR = getMemoryViewForm().DisassemblerView
local _MR = MR.PopupMenu.Items
CNewMen = {}
--
for i=1,#currentExtCap do 
	CNewMen[i] = createMenuItem(_MR)
	CNewMen[i].Caption = currentExtCap[i]
	_MR.Insert(i-1,CNewMen[i])
end
function LOG(opc,pram,str1,adrs,str2,str3)
 writeToClipboard(opc..' '..pram..str1..adrs..str2..str3)
end
function getDis()
local getfrm = getMemoryViewForm().DisassemblerView

adrs = getfrm.SelectedAddress
if not newDisassembler then newDisassembler = getDefaultDisassembler() end
DisassemblingTheAddress = newDisassembler.disassemble(adrs)
return newDisassembler.getLastDisassembleData()
end

CNewMen[1].OnClick = function() --Copy Opcode+Address [TRACING STYLE]

local the = getDis()
 LOG(the.opcode, the.parameters, string1, getNameFromAddress(the.address),string2,string3)

end
CNewMen[2].OnClick = function() --TRACING-- Main

local the = getDis()
 LOG('MAIN:: ',getNameFromAddress(the.address)..' - ',the.opcode..' ',the.parameters..' ','//','')

end
CNewMen[3].OnClick = function() --TRACING-- FINISH

local the = getDis()
 LOG('FINISH:: ',getNameFromAddress(the.address)..' - ',the.opcode..' ',the.parameters..' ','','')

end



