------------######  Author--------------PeaceBeUponYou
------------######  Community-----------Cheat The Game
------------######	Patreon-------------https://www.patreon.com/peaceCheats
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------######	Website:  https://cheatthegame.net
------------######	Facebook: https://facebook.com/groups/CheatTheGame?_rdc=1&_rdr
-------------------------------------------------------

local entriesCaptions = {'Restore Symbol Names'}
local advMenCaptions = {'Go To String Address','Restore Symbol Names'}
local entriesMain = {}
--Adding in Advanced Menu

advMenus = {}
function addInAdvancedOptions(popmen, formx)
	 for i=1, #advMenCaptions do
			advMenus[i] = createMenuItem(popmen)
			advMenus[i].Caption = advMenCaptions[i]
			popmen.Items.Insert(i-1,advMenus[i])
	 end
	 if #advMenus > 0 then 
	 advMenus[1].OnClick = function() 
	  local getsel = formx.Selected
	  if getsel == nil then return end
	  adrs = getAddress(formx.Selected.Caption)
	  if adrs == nil then return end
	  getMemoryViewForm().DisassemblerView.TopAddress =  adrs
	  getMemoryViewForm().show()
	 end
	 advMenus[2].OnClick = function() therealFun2(formx) end
	 end
end

for i=0, getFormCount()-1 do
 if getForm(i).Name == 'AdvancedOptions' then
 local frm1 = getForm(i)
 local cdl = frm1.lvCodelist
 local _ = addInAdvancedOptions(cdl.PopupMenu, cdl)
 end
end
function therealFun2(listname)
 for j=0, listname.Items.Count-1 do
	itmh = listname.Items.Item[j]
	str1 = itmh.Caption
	itmh.Caption =  getNameFromAddress(str1)
end
end


--Adding in Debugger Menu
registerFormAddNotification(
function(form)
  if form.ClassName =="TFoundCodeDialog" then
  _currForm = form
  local timer=createTimer()
  timer.Interval=100
  timer.OnTimer = function (t)
	--if (form.Menu==nil) then return end
	timer.destroy()
	addEntryTFCD(form)
  end
  else
   return
  end
end
)
function addEntryTFCD(frm)
	local popmen = frm.pmOptions
	if not popmen then print('Cannot find Popup Menu in CodeDialog') ;return end
	local menup = popmen.Items
	for i=1, #entriesCaptions do
		entriesMain[i] = createMenuItem(menup)
		entriesMain[i].Caption = entriesCaptions[i]
		popmen.Items.Insert(i-1,entriesMain[i])
	end
	local contl =  frm.FoundCodeList
	entriesMain[1].OnClick = function() therealFun(contl) end
	
end

function therealFun(containerList)
	--fcl = frm.FoundCodeList
	local fcl = containerList
	for j=0, fcl.Items.Count-1 do
	itmh = fcl.Items.Item[j]
	str1 = itmh.SubItems[0]
	itmh.SubItems[0] = str1:gsub(str1:match('(%g*) - '), getNameFromAddress(str1:match('(%g*) - ')))
	end
end
