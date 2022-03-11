


local function getTrueAddress(str)
   local val,adr = readPointer(tonumber(str)),tonumber(str)
   if not val then val,adr = readPointer(tonumber(str,16)),tonumber(str,16) end
   return (val) and adr or nil
end

local function addEntry(frm)
	local items = {'-','Follow address in disassembler','Follow value in disassembler','Follow address in memory','Follow value in memory'}
	local ppm = frm.PopupMenu1
	local menu = {}
	for i=1,#items do
		menu[i] = createMenuItem(ppm)
		menu[i].Caption = items[i]
		ppm.Items.Add(menu[i])
	end
	menu[2].OnClick = function() --Follow address in disassembler
				local list = frm.Changedlist
				local sel = list.Selected
				if not(sel) then return end
				local adr = getTrueAddress(sel.Caption)
				local val = getTrueAddress(sel.SubItems[0])
				if not adr then return end
				getMemoryViewForm().DisassemblerView.SelectedAddress = adr
			end
	menu[3].OnClick = function() --Follow value in disassembler
				local list = frm.Changedlist
				local sel = list.Selected
				if not(sel) then return end
				local adr = getTrueAddress(sel.Caption)
				local val = getTrueAddress(sel.SubItems[0])
				if not val then return end
				getMemoryViewForm().DisassemblerView.SelectedAddress = val
			end
	menu[4].OnClick = function() --Follow address in memory
				local list = frm.Changedlist
				local sel = list.Selected
				if not(sel) then return end
				local adr = getTrueAddress(sel.Caption)
				local val = getTrueAddress(sel.SubItems[0])
				if not adr then return end
				getMemoryViewForm().HexadecimalView.Address = adr
			end
	menu[5].OnClick = function() --Follow value in memory
				local list = frm.Changedlist
				local sel = list.Selected
				if not(sel) then return end
				local adr = getTrueAddress(sel.Caption)
				local val = getTrueAddress(sel.SubItems[0])
				if not val then return end
				getMemoryViewForm().HexadecimalView.Address = val
			end
end


local function registerForms(form)
  if form.ClassName =="TfrmChangedAddresses" then
  --_currForm = form
  local timer=createTimer()
  timer.Interval=100
  timer.OnTimer = function (t)
	timer.destroy()
	addEntry(form)
  end
  else
   return
  end
end
registerFormAddNotification(registerForms)