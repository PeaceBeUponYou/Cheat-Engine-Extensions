------------######  Author--------------PeaceBeUponYou
------------######  Patreon-------------https://www.patreon.com/peaceCheats
------------######  Community-----------Cheat The Game
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------######	Facebook: https://facebook.com/groups/CheatTheGame?_rdc=1&_rdr
-------------------------------------------------------

local entCaps = {'Highlight Selected','Clear All Highlights','Use Tracer Highlighter','-'}
local container = {}
local clrs = {lred = 8421631, red = 0xFF ,lgr = 65280}
local Mainlist = {}
local ValList = {}
local refresh = false;
local mainSelChange = {}
local checkStat = false
function classicx(Sender, Item, SubItem, State)
	local itemCap,contCap,itemText ;
	for i=1, #Mainlist do
		itemCap = string.match(Item.Caption,'(.*)%(')
		contCap = string.match(Mainlist[i],'(.*)%(')
		itemText = Item.SubItems.Text
		if itemCap == contCap then
			if itemText ~= ValList[i] then
				Sender.Canvas.Brush.Color = clrs.lgr
				Sender.Canvas.Font.Color = clrs.red
				refresh = (#Mainlist == 1) or false;
			else
				Sender.Canvas.Brush.Color = clrs.lred
				refresh = false
			end
		end
	end
	return true
end

function highlightTracer(mini,maxi,tracer)
	if #Mainlist == 1 and refresh == true then
		if type(mini) ~= 'number' or type(maxi) ~= 'number' then return end
		local least,most;
		local reversed = false;
		least = (mini < maxi) and mini or maxi
		most = (mini < maxi) and maxi or mini
		if least == maxi then reversed= true; end
		local lvt = tracer
		local bkpSel = lvt.Selected.AbsoluteIndex
		local itms = lvt.Items
		for i=0, (most-least)-1 do
			itms.Item[least+i].Selected = true
		end
		if reversed then itms.Item[most].Selected = true end
		lvt.Selected = itms.Item[bkpSel]
	end
	mainSelChange= nil
	mainSelChange = {}
end

function timerAndChecker(trcr,stkf,num)
	if num ~= 1 then 
		if newTimer then newTimer.destroy(); newTimer=nil end 
		mainSelChange = nil; mainSelChange = {}
		return 
	end
	local lvt = trcr.lvTracer
	for i=0 ,trcr.getComponentCount()-1 do
		if string.match(trcr.getComponent(i).Name,'lvTracer') == 'lvTracer' then
			lvt = trcr.getComponent(i)
		end
	end
	local tempCounter = 0
	local newTimer = createTimer()
	newTimer.Interval = 50
	newTimer.OnTimer = function() 
		local skItms =  stkf.Items
		if type(stkf) ~= 'userdata' or type(skItms) ~= 'userdata' or skItms==nil then
			newTimer.destroy(); newTimer=nil
			return
		end
		if mainSelChange[2] ~= lvt.Selected then
			mainSelChange[1] = mainSelChange[2]
		end
		mainSelChange[2] = lvt.Selected
		for i=0, skItms.Count-1 do
			local itm = skItms.Item[i]
			if #Mainlist ~= 1 then newTimer.destroy(); newTimer = nil; return end
			if (string.match(itm.Caption,'(.*)%(') == string.match(Mainlist[1],'(.*)%(') ) and (itm.SubItems.Text ~= ValList[1]) then
				itm.makeVisible()
				if checkStat==true then
					if #mainSelChange == 2 and (refresh) then
						highlightTracer(mainSelChange[1].AbsoluteIndex,mainSelChange[2].AbsoluteIndex,lvt)	
					end
				end
			end
		end
	end
end --]]

function itemsHighlighter(frm)
	if frm == nil then print('\"frm.frmStackView\" 2nds not found!') return end
	local stklist = frm.lvStack
	local sele = stklist.Selected
	if sele == nil then return end
	local add = true
	for i=1, #Mainlist do
		if Mainlist[i] == sele.Caption then
			add = false
			break;
		end
	end
	if add == true then
		Mainlist[#Mainlist+1] = sele.Caption
		ValList[#ValList+1] = sele.SubItems.Text
		timerAndChecker(frm.Owner,frm.lvStack, #Mainlist)
	end
	stklist.OnCustomDrawSubItem = classicx
end
function itemsDe_Highlighter(frm)
	Mainlist,ValList = nil,nil
	Mainlist,ValList = {},{}
	frm.lvStack.repaint()
end

function checkUncheckTraceHighlighter(self)
	self.Checked = not (self.Checked)
	checkStat = self.Checked
end

function addToStackList(frm)
	local popm = frm.PopupMenu1
	if popm == nil then print('\"sktf.PopupMenu1\"  not found!') return end
	for i=1, #entCaps do
		container[i] = createMenuItem(popm.Items)
		container[i].Caption = entCaps[i]
		popm.Items.Insert(i-1,container[i])
	end
	container[1].OnClick = function() itemsHighlighter(frm) end
	container[2].OnClick = function() itemsDe_Highlighter(frm) end
	container[3].OnClick = function() checkUncheckTraceHighlighter(container[3]) end

end

function registerFormsH(form)
  if form.ClassName =="TfrmTracer" then
  local ddestroy = form.OnDestroy
  local cclose = form.OnClose
  local timer=createTimer()
  timer.Interval=100
  timer.OnTimer = function (t)
	if form.ClassName ~="TfrmTracer" then timer.Enabled = false; timer.destroy(); timer = nil; return end
	for i=0 ,form.getComponentCount()-1 do
		if form.getComponent(i).ClassName == 'TfrmStackView' then
			local comp = form.getComponent(i)
			timer.destroy()
			addToStackList(comp)
		end
	end
  end
  else
   return
  end
end
 obj = registerFormAddNotification(registerFormsH)