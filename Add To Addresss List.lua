------------######  Author--------------PeaceBeUponYou
------------######  Community-----------Cheat The Game
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------######	Website:  https://cheatthegame.net
------------######	Facebook: https://facebook.com/groups/CheatTheGame?_rdc=1&_rdr
------------###### 	MY GitHub: https://github.com/PeaceBeUponYou/Cheat-Engine-Extensions
-------------------------------------------------------

registerFormAddNotification(function (form)
	if form.ClassName == 'TfrmAutoInject' then
	t = createTimer()
	t.Interval = 100
		t.OnTimer = function()
			local a = form.getComponentCount()
			for j=0,a-1 do
				local b = form.getComponent(j)
				if b.Caption == 'Execute' then
					seePanel = form.Panel1
					ADD = form.File1
					if not seePanel.BTN1 then
						c = createButton(seePanel)
						c.Caption = 'Add to Code List'
						c.Width = 150
						c.Length = 500
						c.Height = 31
						c.Top = 2
						c.Left = 343
						c.Name = 'BTN1'
						c.OnClick = function()
							for j=0,ADD.Count-1 do
								if ADD.Item[j].Caption == 'Assign to current cheat table' then		
								clickItem = ADD.Item[j]
								clickItem.doClick()
								t.destroy()
								end
							end
						end
					end
				break
				end
			end
		end
	end	
end)
