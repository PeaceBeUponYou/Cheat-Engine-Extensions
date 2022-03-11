------------######  Author--------------PeaceBeUponYou
------------######  Community-----------Cheat The Game
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------######	Website:  https://cheatthegame.net
------------######	Facebook: https://facebook.com/groups/CheatTheGame?_rdc=1&_rdr
-------------------------------------------------------

function regForm(form)
	if form.ClassName == 'TfrmAutoInject' then
		--if not(form.emplate1) or not(form.emplate1.Visible) then return end
		local t = createTimer()
		t.Interval = 100
		t.OnTimer = function()
			if (form.PopupMenu1) then
				local ppm = form.PopupMenu1
				local itm = createMenuItem(ppm)
				ppm.Items.Add(itm)
				itm.Caption = "Sort Record to table"
				itm.OnClick = function()
					local synEDT = form.Assemblescreen
					local txt = synEDT.SelText
					if txt == nil or txt == "" then print('no text selected!') return end
					txt = txt:match('%((.*)%)')
					if txt == nil or txt == "" then print('wrong selection dipshit!') return end
					local symName,mod,aob
					local desc = getAddressList().SelectedRecord.Description
					for w,c,v in txt:gmatch('(.*),(.*),(.*)') do
					 symName = w
					 mod = c
					 aob = v
					end
					aob = (aob) and aob or ""
					mod = (mod) and mod or ""
					symName = (symName) and symName or ""
					desc = (desc) and desc or ""
					getLuaEngine().mOutput.clear()
					local formate = '{aob = \"'..aob..'\",mod = \"'..mod..'\",symName = \"'..symName..'\",memrecDesc = \"'..desc..'\"}'
					print(formate)
					writeToClipboard(formate)
				end
			end
			if (form.Panel1) then
				local seePanel = form.Panel1
				if not (seePanel.BTN1) then
					local btnAdd = createButton(seePanel)
					btnAdd.Caption = 'Add to Code List'
					btnAdd.Width = 150
					btnAdd.Length = 500
					btnAdd.Height = 31
					btnAdd.Top = 2
					btnAdd.Left = 343
					btnAdd.Name = 'BTN1'
					btnAdd.OnClick = function()
						form.Assigntocurrentcheattable1.doClick()
					end
				end
				t.destroy()
			end
		end
	end
end
registerFormAddNotification(regForm)
