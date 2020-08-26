------------######  Author--------------PeaceBeUponYou
------------######  Community-----------Cheat The Game
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------######	Website:  https://cheatthegame.net
------------######	Facebook: https://facebook.com/groups/CheatTheGame?_rdc=1&_rdr
------------######	Version-------------1.1
-------------------------------------------------------


local mf = getMainForm()
local gpnl = mf.Panel9

--Start By Creating a Button right below Panel14 in Panel 9!
if not gpnl.btnClone then
  crt = createButton(gpnl)
  crt.Caption = "Clone Scan Tab"
  crt.setPosition(70,200)
  crt.AutoSize = true
  crt.Name = 'btnClone'
  crt.Anchor = "[akRight,akBottom]"
end
--Check if process is selected [Process must be available to prevent errors]
registerFormAddNotification(function (mf)
	t = createTimer()
	t.Interval = 500
	t.OnTimer = function()
		if getOpenedProcessID() == 0 then
			crt.Enabled = false
		else
			crt.Enabled = true
		end
	end
end)

crt.OnClick = function()
local memScn = getCurrentMemscan()

--Getting data of current Scan Tab which is to be cloned
function firstScan(jest0)
  fS1 = jest0.ScanresultFolder
  stoText = mf.scanvalue.Text
  local wait0 = 0
  while wait0 < 2 do
        sleep(250)
        wait0 = wait0 + 1
  end
  return fS1
end

function createTab()
  local cT1 = mf.miAddTab
  cT1.doClick()
  mf.scanvalue.Text='9824516539'
  mf.vartype.itemindex=3
  mf.scantype.itemindex=0
  mf.btnNewScan.doClick()
  local wait0 = 0
  while wait0 < 2 do
        sleep(50)
        wait0 = wait0 + 1
  end
end

--Giving data to Cloned tab
function secScan()
  local wait0 = 0
  while wait0 < 2 do
        sleep(50)
        wait0 = wait0 + 1
  end
  mf.scanvalue.Text = stoText
  jest1 = getCurrentMemscan()
  sS1 = jest1.ScanresultFolder
  return sS1
end
-------------------------------Calling functions one by one
firstScan(memScn)
createTab()
secScan(memScn)
fS1 = fS1:sub(1,#fS1-1)
sS1 = sS1:sub(1,#sS1-1)
--print('\"'..fS1..'\"')
--print('\"'..sS1..'\"')
-------------------------------
function cpyFiles(dir1,dir2)
  local wait0 = 0
  while wait0 < 2 do
        sleep(50)
        wait0 = wait0 + 1
  end
  shellExecute('xcopy','\"'..dir1..'\" \"'..dir2..'\" /y',0,SW_HIDE)
end

cpyFiles(fS1,sS1)

end
