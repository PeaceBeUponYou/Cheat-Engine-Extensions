------------######  Author--------------PeaceBeUponYou
------------######  Community-----------Cheat The Game
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------######	Facebook: https://facebook.com/groups/CheatTheGame?_rdc=1&_rdr
-------------------------------------------------------


caps = {'USUAL BT','MAIN BT','FINISH BT'}

registerFormAddNotification(
function(form)
  if form.ClassName =="TfrmTracer" then
  _currForm = form
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
)
menu = {}
function addEntry(frm)
	if not frm then print('Cannot access form in  newEntry!'); return end
	-- adding new popup entry:
	pop = frm.lvTracer.PopupMenu
	menu = {}
	for i=1,3 do
		menu[i] =  createMenuItem(pop.Items)
		menu[i].Caption = caps[i]
		pop.Items.Insert(i,menu[i])
	end
	menu[1].OnClick = function(frm) 
		getUsual(frm)
	end
	menu[2].OnClick = function(frm) 
		getMain(frm)
	end
	menu[3].OnClick = function(frm) 
		getFinish(frm)
	end
end

function mainFunc(frm)
---Global Variables----------------------
labels = {'EAXLabel',
'EBXlabel',
'ECXlabel',
'EDXlabel',
'ESIlabel',
'EDIlabel',
'EBPlabel',
'ESPlabel',
'EIPlabel'}

getLabel,valueOfReg,address,opcode,t_regs = nil
------------------------------------------
        trc = _currForm.lvTracer  
        --h.Visible = not(h.Visible)
       text = trc.Selected
	   if not text then print('Nothing Selected'); return end
	   text = text.Text
	   if not text then print('No Text'); return end
       address = text:sub(1,text:find(' - ')) --address
       opcode = text:sub(text:find(' - ')+3,-1) --opcode
       t_regs = targetIs64Bit() and {'rax','rbx','rcx','rdx','rsi','rdi','rbp','rsp','r8','r9','r10','r11','r12','r13','r14','r15'} or
       {'eax','ebx','ecx','edx','esi','edi','ebp','esp'}
       getReg = string.match(opcode,'%[(.-)%]')
       if getReg then
       for j=1, #t_regs do
        found = string.match(getReg,t_regs[j])
        ---[[
        if found then
         found = string.upper(found)
         for c=1,#labels do
			 s = labels[c]
             if targetIs64Bit() then s = string.gsub(labels[c],'E','R') end
             f = string.find(s,found)
             if f then getLabel = labels[c] end
         end
        end--]]
       end
       --print(getLabel)
       for j=0, _currForm.getComponentCount()-1 do
       --print(a.getComponent(j).Name, a.getComponent(j).Caption)
         if _currForm.getComponent(j).Name == getLabel then
             lbl = _currForm.getComponent(j).Caption
             valueOfReg = string.sub(lbl,5) --value of register
         end
       end
    end
       --print(string.match(opcode,'%[(.-)%]'))
	return address,opcode,valueOfReg
end

function getUsual(thefrm)
	adr,opc,reg = mainFunc(thefrm)
	writeToClipboard(opc..' ---> '..adr..' //'..(reg or ''))
end
function getMain()
	adr,opc,reg = mainFunc(thefrm)
	writeToClipboard('MAIN:: '..adr..'- '..opc..' //'..(reg or ''))
end
function getFinish()
	adr,opc,reg = mainFunc(thefrm)
	writeToClipboard('FINISH:: '..adr..'- '..opc..' //'..(reg or ''))
end
