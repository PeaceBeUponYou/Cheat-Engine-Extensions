------------######  Author--------------PeaceBeUponYou
------------######  Community-----------Cheat The Game
------------######			<--Join US-->
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------######	Website:  https://cheatthegame.net
------------######	Facebook: https://facebook.com/groups/CheatTheGame?_rdc=1&_rdr
------------######	Version-------------1.5
------------###### 	MY GitHub: https://github.com/PeaceBeUponYou/Cheat-Engine-Extensions
-------------------------------------------------------
-------------------------------------------------------


local mf = getMainForm()
local gpnl = mf.Panel9

if not gpnl.btnClone then
  crt = createButton(gpnl)
  crt.Caption = "Clone Scan Tab"
  crt.setPosition(70,200)
  crt.AutoSize = true
  crt.Name = 'btnClone'
  crt.Anchor = "[akRight,akBottom]"
end

crt.OnClick = function()
--Check if process is selected [Process must be available to prevent errors]
if getOpenedProcessID() == 0 then
 messageDialog("No process Open! Please Open a process First!",mtError,mbOK)
 error()
end

--If any process is attached to Cheat-Engine, proceed:
local memScn = getCurrentMemscan()

--Getting data of current Scan Tab which is to be cloned
function firstScan(jest0)
  fS1 = jest0.ScanresultFolder
  stoText = mf.scanvalue.Text
  stoType = mf.vartype.Text
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
  mf.vartype.Text = stoType
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
