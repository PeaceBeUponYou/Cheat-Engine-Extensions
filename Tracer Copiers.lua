------------######  Author--------------PeaceBeUponYou
------------######  Patreon-------------https://www.patreon.com/peaceCheats
------------######  Community-----------Cheat The Game
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------######	Facebook: https://facebook.com/groups/CheatTheGame?_rdc=1&_rdr
-------------------------------------------------------


local caps = {'USUAL BT','MAIN BT','FINISH BT','Symbol Refresh: Selected','Symbol Refresh: All'}
function addEntry(form)
	if not form then print('Cannot access form in  newEntry!'); return end
	-- adding new popup entry:
	local menItem = createMenuItem(form.MainMenu1)
    form.MainMenu1.Items.add(menItem)
    menItem.Caption = "Rename Tracer"
    menItem.OnClick = function()
       local newName = InputQuery("New Name","Enter new name: ",form.Caption)
	   if newName == nil then newName = form.Caption end
       form.Caption = newName
    end
	local pop = form.lvTracer.PopupMenu
	local menu = {}
	for i=1,5 do
		menu[i] =  createMenuItem(pop.Items)
		menu[i].Caption = caps[i]
		pop.Items.Insert(i,menu[i])
	end
	menu[1].OnClick = function()
		getUsual(form)
	end
	menu[2].OnClick = function() 
		getMain(form)
	end
	menu[3].OnClick = function() 
		getFinish(form)
	end
	menu[4].OnClick = function()
		selRefersh(form)
	end
	menu[5].OnClick = function()
		allRefersh(form)
	end
end

function getUsual(thefrm)
	local adr,opc,reg = mainFunc(thefrm)
	writeToClipboard('}'..opc..' ---> '..adr..' //'..(reg or ''))
end
function getMain(frm)
	local adr,opc,reg = mainFunc(frm)
	writeToClipboard('MAIN:: '..adr..'- '..opc..' //'..(reg or ''))
end
function getFinish(frm)
	local adr,opc,reg = mainFunc(frm)
	writeToClipboard('FINISH:: '..adr..'- '..opc..' //'..(reg or ''))
end

function registerForms(form)
  if form.ClassName =="TfrmTracer" then
  --_currForm = form
  local timer=createTimer()
  timer.Interval=100
  timer.OnTimer = function (t)
	if (form.Menu==nil) then return end
	timer.destroy()
	addEntry(form)
  end
  else
   return
  end
end
registerFormAddNotification(registerForms)



function mainFunc(form)
---Global Variables----------------------
local labels = {'EAXLabel',
'EBXlabel',
'ECXlabel',
'EDXlabel',
'ESIlabel',
'EDIlabel',
'EBPlabel',
'ESPlabel',
'EIPlabel'}

local getLabel,valueOfReg,address,opcode,t_regs = nil
------------------------------------------
       -- local trc = _currForm.lvTracer  
        local trc = form.lvTracer
        --h.Visible = not(h.Visible)
       local text = trc.Selected
	   if not text then print('Nothing Selected'); return end
	   text = text.Text
	   if not text then print('No Text'); return end
       local address = text:sub(1,text:find(' - ')) --address
       local opcode = text:sub(text:find(' - ')+3,-1) --opcode
       local t_regs = targetIs64Bit() and {'rax','rbx','rcx','rdx','rsi','rdi','rbp','rsp','r8','r9','r10','r11','r12','r13','r14','r15'} or
       {'eax','ebx','ecx','edx','esi','edi','ebp','esp'}
       local getReg = string.match(opcode,'%[(.-)%]')
       if getReg then
       for j=1, #t_regs do
        local found = string.match(getReg,t_regs[j])
        ---[[
        if found then
         found = string.upper(found)
		 local s,f
         for c=1,#labels do
			  s = labels[c]
             if targetIs64Bit() then s = string.gsub(labels[c],'E','R') end
              f = string.find(s,found)
             if f then getLabel = labels[c]  end
         end
        end--]]
       end
       --print(getLabel)
       for j=0, form.getComponentCount()-1 do --_currForm
       --print(a.getComponent(j).Name, a.getComponent(j).Caption)
         if form.getComponent(j).Name == getLabel then
             local lbl = form.getComponent(j).Caption
             valueOfReg = string.sub(lbl,5) --value of register
         end
       end
    end
       --print(string.match(opcode,'%[(.-)%]'))
	return address,opcode,valueOfReg
end


function selRefersh(thefrm)
	local trc = thefrm.lvTracer  
    local _text = trc.Selected
	local addressString = _text.Text:match('(%g*) - ')
	--New Code:
	local upperPart = _text.Text:match('- (.*)') --get-opcode
	if upperPart == nil or type(upperPart) ~= 'string' then print (itmj.Text); trc.Selected = itmj return end
	local inst = upperPart:match('(.*) ')
	local partsl = (upperPart:match(' (.*)')~='') and upperPart:match(' (.*)') or 'XX'  --remove instruction
    partsl = (partsl:match('ptr (.*)')== nil) and partsl or partsl:match('ptr (.*)')
    --print(inst,d)
    local opco = inst
    if partsl ~= 'XX' then
     local left,right = partsl:match('(.*),') or partsl ,partsl:match(',(.*)') or ''
     local bl = left:match('%[(.*)%]')
	 local _bl1,_bl2 = '',''
	 if bl then _bl1 = '[' ;  _bl2 = ']' end
     local adrsl = getAddressSafe(bl or left)
     adrsl = adrsl and getNameFromAddress(adrsl) or adrsl
     local br = right:match('%[(.*)%]')
	 local _br1,_br2 = '',''
	 if br then _br1 = '[' ;  _br2 = ']' end
     local adrsr = getAddressSafe(br or right)
     adrsr = adrsr and getNameFromAddress(adrsr) or adrsr

     opco = inst..' '..((adrsl and (_bl1..adrsl.._bl2) or nil) or left)..(((adrsr or right)~= '') and ',' or '')..((adrsr and (_br1..adrsr.._br2) or nil) or right)
	end
	--
	local getMatch = getNameFromAddress(addressString)
	--_text.Text = _text.Text:gsub(addressString,getMatch)
	_text.Text = getMatch..' - '..(opco or upperPart)
end
function allRefersh(thefrm)
	local trc = thefrm.lvTracer  
    for j=0, trc.Items.Count-1 do
      local itmj = trc.Items.Item[j]
      local addressString = itmj.Text:match('(%g*) - ')
	  --NewCode:
	  local upperPart = itmj.Text:match('- (.*)') --get-opcode
	  if upperPart == nil or type(upperPart) ~= 'string' then print (itmj.Text); trc.Selected = itmj else
		local inst = upperPart:match('(.*) ')
		local partsl = (upperPart:match(' (.*)')~='') and upperPart:match(' (.*)') or 'XX'  --remove instruction
		partsl = (partsl:match('ptr (.*)')== nil) and partsl or partsl:match('ptr (.*)')
		--print(inst,d)
		local opco = inst
		if partsl ~= 'XX' then
		 local left,right = partsl:match('(.*),') or partsl ,partsl:match(',(.*)') or ''
		 local bl = left:match('%[(.*)%]')
		 local _bl1,_bl2 = '',''
		 if bl then _bl1 = '[' ;  _bl2 = ']' end
		 local adrsl = getAddressSafe(bl or left)
		 adrsl = adrsl and getNameFromAddress(adrsl) or adrsl
		 local br = right:match('%[(.*)%]')
		 local _br1,_br2 = '',''
		 if br then _br1 = '[' ;  _br2 = ']' end
		 local adrsr = getAddressSafe(br or right)
		 adrsr = adrsr and getNameFromAddress(adrsr) or adrsr

		 opco = inst..' '..((adrsl and (_bl1..adrsl.._bl2) or nil) or left)..(((adrsr or right)~= '') and ',' or '')..((adrsr and (_br1..adrsr.._br2) or nil) or right)
		end
		----------
		local getMatch = getNameFromAddress(addressString)
		if addressString and getMatch and opco then
		--itmj.Text = itmj.Text:gsub(addressString,getMatch)
		itmj.Text = getMatch..' - '..opco
		end
	end
  end
end
