local function addEntry(tForm)
  local lists = tForm.ListView1
  local popup = tForm.PopupMenu1
  local pre = tForm.PopupMenu1.addToAddressList
  if pre then return end
  
  local newItem = createMenuItem(popup)
  newItem.Name = 'addToAddressList'
  newItem.Caption = 'Add symbol to address list'
  popup.Items.add(newItem)
  newItem.OnClick = function()
                      local adrl = getAddressList().createMemoryRecord()
                      adrl.Address = lists.Selected.Caption
                      adrl.Description = lists.Selected.Caption
                  end
  
  popup.OnPopup = function()
				if not(lists.Selected) then 
					pre = tForm.PopupMenu1.addToAddressList
					if pre then
						pre.Enabled = false
					end
				else
					if pre then
						pre.Enabled = true
					end
				end
			end
  --print(popup.Items.Item[0].Caption)
 end

local function registerForms(form)
  if form.ClassName =="TfrmSymbolhandler" then
  local timer=createTimer()
  timer.Interval=100
  timer.OnTimer = function (t)
	if (form.ListView1==nil) then return end
	timer.destroy()
	addEntry(form)
  end
  else
   return
  end
end
registerFormAddNotification(registerForms)

