------------######  Author--------------PeaceBeUponYou
------------######  Community-----------Cheat The Game
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
------------######	Website:  https://cheatthegame.net
------------######	Facebook: https://facebook.com/groups/CheatTheGame?_rdc=1&_rdr
-------------------------------------------------------

MyTemplates = 'MY TEMPLATES'
t_names = {'Fixed Absolute Jump','AOB and BKPs','Fixed Absolute Jump | with call','MONO - Full Inj With ReadMem'}
registerFormAddNotification(
function(form)
  if form.ClassName =="TfrmAutoInject" then
   currfrm = form
  local timer=createTimer()
  timer.Interval=100
  timer.OnTimer = function (t)
                    if (form.Menu==nil) then return end
                    timer.destroy()
					--currfrm = form
                    newEntry(currfrm)
                  end
  else
   return
  end
	
end
)

function newEntry(form)
	men = form.emplate1
	---parent menu:
	parent = createMenuItem(men)
	parent.Caption = MyTemplates
	men.add(parent)
	---
	---child menu
	itm = {}
	for i=1, 4 do
		itm[i] = createMenuItem(parent)
		itm[i].Caption = t_names[i]
		--itm.Shortcut = 'CTRL+D'
		parent.add(itm[i])
	end
	itm[1].Shortcut = 'CTRL+D'
	itm[1].OnClick = function()
			  funcClick()
			end
	itm[2].Shortcut = 'CTRL+E'
	itm[2].OnClick = function()
			  readmemAOB(currfrm)
			end
	--itm[3].Shortcut = 'CTRL+E'
	itm[3].OnClick = function()
			  funcClickWithCall(frm)
			end
	itm[4].OnClick = function()
			  MonoInj(form)
			end
end
-----------------------------------------------------
------------------BASIC FUNCTIONS:-------------------
-----------------------------------------------------
function getBasicData()
local disAsView = getMemoryViewForm().DisassemblerView
	adr = disAsView.SelectedAddress
	tar = targetIs64Bit()
	nob = tar and 13 or 8
	num = tar and 8 or 4
	return adr,tar,nob,num
end
function disassembleAndGetData(selAdrs)
  local defDis = getDefaultDisassembler()
  local dis = defDis.disassemble(selAdrs)
  p,q,r,s = splitDisassembledString(dis)
  return s
end
function nopsToRepeat(sizeH,sizeL)
	if sizeH-sizeL == 00 then
	  torep = ''
	elseif sizeH-sizeL == 01 then
	  torep = 'nop'
	else
	  torep = string.format('nop %d',instSize-numOfBytes)
	end
	return torep
end

function getInjectionText(address,sizeOfComment)
  local strList = createStringList()
  generateFullInjectionScript(strList,address,sizeOfComment)
  return strList.Text
end
function usereadMem(title,size)
  local opcodeStr = createStringList()
  byteStr = ''
  click = [[  readmem(titl,num)
  jmp return ]]
  if not title then return end
  click = string.gsub(click,'titl',title)
  click = string.gsub(click,'num',size)
  opcodeStr.Text = 'code:\n'..click
  return opcodeStr.Text
end
function regAndUnreg(replaceString,replaceSize,codet)
  local symbol = [[registerSymbol(title name)

newmem:]]
  local unsym = [[[DISABLE]
title:
  readmem(name,size)
unregisterSymbol(title name)
dealloc]]

  local sym = symbol:gsub('name',replaceString)
  sym = sym:gsub('title',codet)
  local uns = unsym:gsub('name',replaceString)
  uns = uns:gsub('size',replaceSize)
  uns = uns:gsub('title',codet)
  return sym,uns
end
function nopsToRepeat(sizeH,sizeL)
  if sizeH-sizeL == 00 then
    torep = ''
  elseif sizeH-sizeL == 01 then
    torep = 'nop'
  else
    torep = string.format('nop %d',instSize-numOfBytes)
  end
  return torep
end
function baseRstrWithNops(tar,nops)
 local basejmp,restorebegin = [[push rax
  mov rax,newmem
  jmp rax
  ]],
[[newmem:
  pop rax
  //Write your code here:]]
  if not tar then --converting x64 registers to x86 registers
    basejmp = string.gsub(basejmp,'r','e',3)
    restorebegin = string.gsub(restorebegin,'r','e',1)
  end
  basejmp = basejmp..nops..'\nreturn:'
  return basejmp,restorebegin
end --]]

-----------------------------------------------------
------------------MAIN FUNCTIONS:--------------------
-----------------------------------------------------
function funcClick(frm)
    local form = currfrm
	--[[local disAsView = getMemoryViewForm().DisassemblerView
	selAdrs = disAsView.SelectedAddress
	target = targetIs64Bit()
	numOfBytes = target and 13 or 8--]]
	selAdrs,target,numOfBytes,number = getBasicData()
	
	instSize = getInstructionSize(selAdrs)
	while(instSize < numOfBytes)do
		nextAddress = getAddress(selAdrs)+instSize
		instSize = instSize + getInstructionSize(nextAddress)
	end
	aobTitle = InputQuery('Enter name of AOB Symbol: ','Here: ','myAOB')
	
	opcodeStr = createStringList()
	click = '  //readmem(aobTitle,num)'
	if not aobTitle then return end
	click = string.gsub(click,'aobTitle',aobTitle)
	click = string.gsub(click,'num',instSize)
	opcodeStr.Text = 'code:\n'..click
	
	def = getDefaultDisassembler()
	byteStr = ''
	n,totalInstructions = 0,0
	nextAddress=selAdrs
	while n<instSize do
		dis = def.disassemble(nextAddress)
		p,q,r,s = splitDisassembledString(dis)
		opcodeStr.addText('  '..q)
		byteStr = byteStr..string.gsub(r,' ','')
		n = n + getInstructionSize(nextAddress)
		nextAddress = getAddress(selAdrs)+ n
		totalInstructions = totalInstructions+1
	end
	opcodeStr.addText('  jmp return')
	new = '' --bytes for disable
	for i=1,#byteStr,2 do
	  new = new..string.sub(byteStr,i,i+1)..' '
	end

	--[[if instSize-numOfBytes == 00 then
	  torep = ''
	else
	  torep = string.format('nop %d',instSize-numOfBytes)
	end]]
	torep = nopsToRepeat(instSize,numOfBytes)
	
	name = getNameFromAddress(selAdrs)
	mainTemplet = createStringList()
	t = generateAOBInjectionScript(mainTemplet,aobTitle,name,totalInstructions-1)
	--print(mainTemplet.Text)
	base,restore = [[push rax
  mov rax,newmem
  jmp rax
  ]],
  [[newmem:
  pop rax
  //Write your code here:]]
	if not target then --converting x64 registers to x86 registers
	 base = string.gsub(base,'r','e',3)
	 restore = string.gsub(restore,'r','e',1)
	end
    Author = [[[ENABLE]
  //Template Author = PeaceBeUponYou]]
	str = mainTemplet.Text

	fin = string.gsub(str,'nop%s*%d*', '' )
	fin = string.gsub(fin,'newmem:',restore)
	fin = string.gsub(fin,'%gENABLE%g',Author)
	fin = string.gsub(fin,'jmp newmem',base..torep)
	fin = string.gsub(fin,'db%s(.-)\n','db '..new..'\n')
	final = string.gsub(fin,'code:(.-)jmp return',opcodeStr.Text)
	--print(final)
	form.Assemblescreen.Lines.Text = final
end

function readmemAOB(currfrm)
local form = currfrm
local disAsView = getMemoryViewForm().DisassemblerView
	selAdrs = disAsView.SelectedAddress
	aobTitle = InputQuery('Enter name of AOB Symbol: ','Here: ','myAOB')
    numOfReadmemBytes = InputQuery('Enter the number of readmem Bytes: ','Here: ','32')
    name = getNameFromAddress(selAdrs)
	if not aobTitle then return end
	if not numOfReadmemBytes then return end
	mainTemplet = createStringList()
	t = generateAOBInjectionScript(mainTemplet,aobTitle,name,3)
	--print(mainTemplet.Text)
	allocRestr,disableRes = [[alloc(name_bkpBytes, $100)
registerSymbol(name_bkpBytes)
name_bkpBytes:
  readmem(name,bytes)
//Code Follow:
  ]],[[[DISABLE]
name:
  readmem(name_bkpBytes,bytes)
unregistersymbol(name, name_bkpBytes)
dealloc(name_bkpBytes)
  ]]
	str = mainTemplet.Text
        allocRestr = allocRestr:gsub('name',aobTitle)
        allocRestr = allocRestr:gsub('bytes',numOfReadmemBytes)
        disableRes = disableRes:gsub('name',aobTitle)
        disableRes = disableRes:gsub('bytes',numOfReadmemBytes)
	--fin = string.gsub(str,'nop%s*%d*', '' )
	fin = string.gsub(str,'alloc(.-)jmp return',allocRestr)
	fin = string.gsub(fin,'Follow:(.-)'..aobTitle,'Follow:\n'..aobTitle)
    fin = string.gsub(fin,'%[DISABLE%](.-){',disableRes..'{')
	final = string.gsub(fin,'jmp newmem(.-)return:','')
	form.Assemblescreen.Lines.Text = final
  --print(final)

end

function funcClickWithCall(frm)
    local form = currfrm
	--print(form.ClassName)
	--[[local disAsView = getMemoryViewForm().DisassemblerView
	selAdrs = disAsView.SelectedAddress
	target = targetIs64Bit()
	numOfBytes = target and 13 or 8
	number = target and 8 or 4 --]]
	selAdrs,target,numOfBytes,number = getBasicData()
	
	instSize = getInstructionSize(selAdrs)
	while(instSize < numOfBytes)do
		nextAddress = getAddress(selAdrs)+instSize
		instSize = instSize + getInstructionSize(nextAddress)
	end
	aobTitle = InputQuery('Enter name of AOB Symbol: ','Here: ','myAOB')
	n,totalInstructions = 0,0
	nextAddress=selAdrs
	opcodeStr = createStringList()
	byteStr = ''
	click = '  //readmem(aobTitle,num)'
	if not aobTitle then return end
	click = string.gsub(click,'aobTitle',aobTitle)
	click = string.gsub(click,'num',instSize)
	opcodeStr.Text = 'code:\n'..click
	def = getDefaultDisassembler()

	while n<instSize do
		dis = def.disassemble(nextAddress)
		p,q,r,s = splitDisassembledString(dis)
		opcodeStr.addText('  '..q)
		byteStr = byteStr..string.gsub(r,' ','')
		n = n + getInstructionSize(nextAddress)
		nextAddress = getAddress(selAdrs)+ n
		totalInstructions = totalInstructions+1
	end
	base,restore,last = [[push rax
  mov rax,newmem
  call rax
  ]],
  [[newmem:
  add rsp,num
  pop rax
  //Write your code here:]],[[
  push rax
  mov rax,return
  xchg rax,[rsp]
  ret]]
	if not target then --converting x64 registers to x86 registers
	 base = string.gsub(base,'r','e',3)
	 restore = string.gsub(restore,'r','e',2)
	 last = string.gsub(last,'ra','ea')
	 last = string.gsub(last,'rs','es',1)
	end
	opcodeStr.addText(last)
	new = '' --bytes for disable
	for i=1,#byteStr,2 do
	  new = new..string.sub(byteStr,i,i+1)..' '
	end

	--[[if instSize-numOfBytes == 00 then
	  torep = ''
	else
	  torep = string.format('nop %d',instSize-numOfBytes)
	end--]]
	torep = nopsToRepeat(instSize,numOfBytes)

	name = getNameFromAddress(selAdrs)
	mainTemplet = createStringList()
	t = generateAOBInjectionScript(mainTemplet,aobTitle,name,totalInstructions-1)
	--print(mainTemplet.Text)
	
    Author = [[[ENABLE]
  //Template Author = PeaceBeUponYou]]
	str = mainTemplet.Text
	restore = string.gsub(restore,'num',number)
	fin = string.gsub(str,'nop%s*%d*', '' )
	fin = string.gsub(fin,'newmem:',restore)
	fin = string.gsub(fin,'%gENABLE%g',Author)
	fin = string.gsub(fin,'jmp newmem',base..torep)
	fin = string.gsub(fin,'db%s(.-)\n','db '..new..'\n')
	final = string.gsub(fin,'code:(.-)jmp return',opcodeStr.Text)
	--print(final)
	form.Assemblescreen.Lines.Text = final
end

function MonoInj(currfrm)
local form = currfrm

instCount = 0
selAdrs = nil
selAdrs,target,numOfBytes,number = getBasicData()
addressI = disassembleAndGetData(selAdrs)
stringAddress = getNameFromAddress(addressI)
instSize = getInstructionSize(stringAddress)

while(instSize < numOfBytes)do
  instCount = instCount+1
  nextAddress = getAddress(selAdrs)+instSize
  instSize = instSize + getInstructionSize(nextAddress)
end


aobTitle = InputQuery('Enter name of Injection Symbol: ','Here: ','mySymbol')
codeReplace = aobTitle..'_BkpBytes'
selAdrs,target,numOfBytes,number = getBasicData()
symbol,unsym = regAndUnreg(codeReplace,instSize,aobTitle)
torep = nopsToRepeat(instSize,numOfBytes)

jmpstr,rstrStr = baseRstrWithNops(target,torep)

thereadMemCode = usereadMem(aobTitle,instSize)
if not thereadMemCode then messageDialog('No Title!','Script Name was canceled.',mtError,mbOK); return end
redmem = thereadMemCode:gsub('code',codeReplace)

mono = '//luacall(LaunchMonoDataCollector())\n//Template Author = PeaceBeUponYou'
thestr = getInjectionText(stringAddress,instCount+1)
def = thestr:match('}(.-)%)')..')' --extract the define before enable
--def = def:gsub('%((.-)%,','('..name..',')
stri = thestr:gsub('{(.-)%[','\n[',1) --replace everything before ENABLE
stri = stri:gsub('%[ENABLE%](.-)alloc','[ENABLE]\n'..mono..def..'\nalloc')
stri = stri:gsub(def:match('%((.-)%,'),aobTitle) --find and replace `address` with the name of script
stri = stri:gsub('code:(.-)jmp return',redmem)
stri = stri:gsub('code',codeReplace) --replace all code labels with that
stri = stri:gsub('newmem:',symbol) --register and replace
stri = stri:gsub('%[DISABLE%](.-)dealloc',unsym) --unregister and restore
--stri = stri:gsub('%](.-)define',']\ndefine') --end the \n between [ENABLE] and 'define'
stri = stri:gsub('jmp newmem(.-)return:',jmpstr) --replace it with the long code
stri = stri:gsub('newmem:',rstrStr) --replace it with pop rax as well
form.Assemblescreen.Lines.Text = stri

 end
