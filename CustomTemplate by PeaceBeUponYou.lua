------------######  Author--------------PeaceBeUponYou
------------######  Community-----------Cheat The Game
------------######	Patreon-------------https://www.patreon.com/peaceCheats
------------######			:Join US:
------------######	Discord:  https://discordapp.com/invite/ndn4pqs
-------------------------------------------------------
templateMain = {}
templateMain.MyTemplates = {'By PeaceBeUponYou','-'}
templateMain.MainCont = {}
templateMain.t_names = {'Lua Framework','Fixed Absolute Jump','Direct Bytes Manipulation (AOB)','Fixed Absolute Jump | with call','-','MONO - ASM Injection With ReadMem','MONO - Lua Injection With ReadMem','MONO - Lua Injection With Opcodes','MONO -CSCompiler'}

function templateMain.AddForm(form)
  if form.ClassName =="TfrmAutoInject" then
   local currfrm = form
  local timer=createTimer()
  timer.Interval=100
  timer.OnTimer = function (t)
                    if (form.Menu==nil) then return end
                    timer.destroy()
                    templateMain.newEntry(form)
                  end
  else
   return
  end
	
end
formx=registerFormAddNotification(templateMain.AddForm)
function templateMain.clickfun(form)
	local temp = [[

[ENABLE]



[DISABLE]


]]
	form.Assemblescreen.Lines.Text = temp
end
function templateMain.newEntry(form)
    ---
	form.CheatTablecompliantcodee1.OnClick = function() templateMain.clickfun(form) end
	---
	local men = form.emplate1
	---parent menu:
	for i=1, #templateMain.MyTemplates do
		templateMain.MainCont[i] = createMenuItem(men)
		templateMain.MainCont[i].Caption = templateMain.MyTemplates[i]
		men.Insert(i-1,templateMain.MainCont[i])
	end
	---
	---child menu
	local itm = {}
	for i=1,#templateMain.t_names do
		itm[i] = createMenuItem(templateMain.MainCont[1])
		itm[i].Caption = templateMain.t_names[i]
		itm[i].Name = 'peaceMenuItm'..i
		templateMain.MainCont[1].add(itm[i])
	end
	itm[1].OnClick = function()
			  templateMain.luaFrame(form)
			end
	itm[2].Shortcut = 'CTRL+D'
	itm[2].OnClick = function()
			  templateMain.funcClick(form)
			end
	itm[3].Shortcut = 'CTRL+E'
	itm[3].OnClick = function(sender)
			  templateMain.readmemAOB(form)
			end
	itm[4].OnClick = function()
			  templateMain.funcClickWithCall(form)
			end
	itm[6].OnClick = function()
			  templateMain.MonoInj(form)
			end
	itm[7].OnClick = function()
			  templateMain.LuaMonoInj(form)
			end
	itm[8].OnClick = function()
			  templateMain.OPCLuaMonoInj(form)
			end
	itm[9].OnClick = function() --MONO CSCompiler
			  templateMain.CSCompiler(form)
			end
end
-----------------------------------------------------
------------------BASIC FUNCTIONS:-------------------
-----------------------------------------------------
function templateMain.luaFrame(form)
	local temp = [[{$lua}
if syntaxcheck then return end

[ENABLE]



[DISABLE]


]]
	form.Assemblescreen.Lines.Text = temp
end

function templateMain.getBasicData()
local disAsView = getMemoryViewForm().DisassemblerView
local adr = disAsView.SelectedAddress
local tar = targetIs64Bit()
local nob = tar and 13 or 8
local num = tar and 8 or 4
	return adr,tar,nob,num
end
function templateMain.disassembleAndGetData(selAdrs)
  local defDis = getDefaultDisassembler()
  local dis = defDis.disassemble(selAdrs)
  p,q,r,s = splitDisassembledString(dis)
  return s
end
function templateMain.nopsToRepeat(sizeH,sizeL)
	local torep
	if sizeH-sizeL == 00 then
	  torep = ''
	elseif sizeH-sizeL == 01 then
	  torep = 'nop'
	else
	  torep = string.format('nop %d',instSize-numOfBytes)
	end
	return torep
end

function templateMain.getInjectionText(address,sizeOfComment)
  local strList = createStringList()
  generateFullInjectionScript(strList,address,10)
  return strList.Text
end
function templateMain.usereadMem(title,size)
  local opcodeStr = createStringList()
  local click = [[  readmem(titl,num)
  jmp return ]]
  if not title then return end
  click = string.gsub(click,'titl',title)
  click = string.gsub(click,'num',size)
  opcodeStr.Text = 'code:\n'..click
  return opcodeStr.Text
end
function templateMain.regAndUnreg(replaceString,replaceSize,codet)
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

function templateMain.baseRstrWithNops(tar,nops)
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
function templateMain.funcClick(frm)
    local form = frm
	selAdrs,target,numOfBytes,number = templateMain.getBasicData()
	
	instSize = getInstructionSize(selAdrs)
	while(instSize < numOfBytes)do
		nextAddress = getAddress(selAdrs)+instSize
		instSize = instSize + getInstructionSize(nextAddress)
	end
	aobTitle = InputQuery('Enter name of AOB Symbol: ','Here: ','myAOB')
	if not(aobTitle) then return end
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
	torep = templateMain.nopsToRepeat(instSize,numOfBytes)
	
	name = getNameFromAddress(selAdrs)
	mainTemplet = createStringList()
	t = generateAOBInjectionScript(mainTemplet,aobTitle,name,10)
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

function templateMain.readmemAOB(frm)
local form = frm
local disAsView = getMemoryViewForm().DisassemblerView
	selAdrs = disAsView.SelectedAddress
	aobTitle = InputQuery('Enter name of AOB Symbol: ','Here: ','myAOB')
    numOfReadmemBytes = InputQuery('Enter the number of readmem Bytes: ','Here: ','32')
    name = getNameFromAddress(selAdrs)
	if not aobTitle then return end
	if not numOfReadmemBytes then return end
	mainTemplet = createStringList()
	t = generateAOBInjectionScript(mainTemplet,aobTitle,name,13)
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
	fin = string.gsub(str,'alloc(.-)jmp return',allocRestr)
	fin = string.gsub(fin,'Follow:(.-)'..aobTitle,'Follow:\n'..aobTitle)
    fin = string.gsub(fin,'%[DISABLE%](.-){',disableRes..'{')
	final = string.gsub(fin,'jmp newmem(.-)return:','')
	form.Assemblescreen.Lines.Text = final
end

function templateMain.funcClickWithCall(frm)
    local form = frm
	selAdrs,target,numOfBytes,number = templateMain.getBasicData()
	
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
	torep = templateMain.nopsToRepeat(instSize,numOfBytes)

	name = getNameFromAddress(selAdrs)
	mainTemplet = createStringList()
	t = generateAOBInjectionScript(mainTemplet,aobTitle,name,11)
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

function templateMain.MonoInj(frm)
local form = frm

local instCount = 0
local selAdrs = nil
selAdrs,target,numOfBytes,number = templateMain.getBasicData()
addressI = templateMain.disassembleAndGetData(selAdrs)
stringAddress = InputQuery('Enter name of Injection Symbol: ','Here: ',getNameFromAddress(addressI))
instSize = getInstructionSize(stringAddress)

while(instSize < numOfBytes)do
  instCount = instCount+1
  nextAddress = getAddress(selAdrs)+instSize
  instSize = instSize + getInstructionSize(nextAddress)
end


local aobTitle = InputQuery('Enter name of Injection Symbol: ','Here: ','mySymbol')
local codeReplace = aobTitle..'_BkpBytes'
selAdrs,target,numOfBytes,number = templateMain.getBasicData()
symbol,unsym = templateMain.regAndUnreg(codeReplace,instSize,aobTitle)
torep = templateMain.nopsToRepeat(instSize,numOfBytes)

jmpstr,rstrStr = templateMain.baseRstrWithNops(target,torep)

thereadMemCode = templateMain.usereadMem(aobTitle,instSize)
if not thereadMemCode then messageDialog('No Title!','Script Name was canceled.',mtError,mbOK); return end
redmem = thereadMemCode:gsub('code',codeReplace)

mono = '//luacall(LaunchMonoDataCollector())\n//Template Author = PeaceBeUponYou'
thestr = templateMain.getInjectionText(stringAddress,10)
def = thestr:match('}(.-)%)')..')' --extract the define before enable
--def = def:gsub('%((.-)%,','('..name..',')
stri = thestr:gsub('{(.-)%[','\n[',1) --replace everything before ENABLE
stri = stri:gsub('%[ENABLE%](.-)alloc','[ENABLE]\n'..mono..def..'\nalloc')
stri = stri:gsub(def:match('%((.-)%,'),aobTitle) --find and replace `address` with the name of script
stri = stri:gsub('code:(.-)jmp return',redmem)
stri = stri:gsub('code',codeReplace) --replace all code labels with that
stri = stri:gsub('newmem:',symbol) --register and replace
stri = stri:gsub('%[DISABLE%](.-)dealloc',unsym) --unregister and restore
stri = stri:gsub('jmp newmem(.-)return:',jmpstr) --replace it with the long code
stri = stri:gsub('newmem:',rstrStr) --replace it with pop rax as well
form.Assemblescreen.Lines.Text = stri

 end

function baseTemp()
	local templateMono = [=[{$lua}
--Script Name	: PEACE_Symbol
--Script Author : PeaceBeUponYou
--Script Info	: This script does bla bla
if syntaxcheck then return end
LaunchMonoDataCollector()
--Check Enabled and Disable Script:
PEACE_EXECFUNC


PEACE_Symbol_injAddress = 'PEACE_InjAddressHere'
PEACE_Symbol_enableScript = [[
	//Template Author = PeaceBeUponYou

	define(PEACE_Symbol,PBUY_InjectionAddress)
	alloc(newmem,$1000,PBUY_InjectionAddress)

	label(PEACE_Symbol_BkpBytes)
	label(return)

	registerSymbol(PEACE_Symbol PEACE_Symbol_BkpBytes)

	newmem:
	  pop rax
	  //Write your code here:

	PEACE_Symbol_BkpBytes:
	  PEACE_WHATISHERE 
	  jmp return


	PEACE_Symbol:
	  PBUY_realInjection
	return:
]]
PEACE_Symbol_disableScript = [[
	PEACE_Symbol:
	  PEACE_WHATISHERE
	unregisterSymbol(PEACE_Symbol PEACE_Symbol_BkpBytes)
	dealloc(newmem)
]]


[ENABLE]
PEACE_Symbol_enablePart,PEACE_Symbol_disabePart = createEnableandDisable(PEACE_Symbol_enableScript,PEACE_Symbol_disableScript,PEACE_Symbol_injAddress)
success,PEACE_Symbol_disabledia =  autoAssemble(PEACE_Symbol_enablePart)
if not success then print(PEACE_Symbol_disabledia); error('Could not enable script!') end


[DISABLE]
success = autoAssemble(PEACE_Symbol_disabePart,PEACE_Symbol_disabledia)
if not success then print(PEACE_Symbol_disabledia); error('Could not disable script!')end
]=]
 return templateMono
end

function templateMain.LuaMonoInj(frm) 
	local form = frm
	local disAsView = getMemoryViewForm().DisassemblerView
	local selAdrs = disAsView.SelectedAddress
	local aobTitle = InputQuery('Enter the Address of Injection: ','Here: ',getNameFromAddress(selAdrs))
	local symbolName=inputQuery('Enter name of Injection Symbol: ','Here: ','mySymbol')
	if not(symbolName) then return end
	if aobTitle == '' then return end
	local basicTemplate= baseTemp()
	local execFunc = [=[function createEnableandDisable(enableScriptString, disableString , injAddress)
	local currentSize = 0
	local leastSize = 13 --13 bytes at least
	local instCount = 0
	local generalSizeScript = [[push rax
	mov rax,newmem
	jmp rax
	PBUY_nops
	]]
	--ENABLE PART
	local processedString = enableScriptString
	processedString = processedString:gsub('PBUY_InjectionAddress',injAddress) --Place original injection address
	local size = getInstructionSize(injAddress)
	local readMemStr = 'readmem(PEACE_Symbol,PBUY_readmemBytes)'
	processedString = processedString:gsub('PEACE_WHATISHERE',readMemStr)
	local nextAddress;
	while (size < leastSize) do
	instCount = instCount+1
	nextAddress = getAddress(injAddress) + size
	size = size + getInstructionSize(nextAddress)
	end
	local endsize = size - leastSize
	if endsize > 0 then
	generalSizeScript = generalSizeScript:gsub('PBUY_nops', 'nop '..(endsize== 1 and '' or endsize))
	else
	 generalSizeScript = generalSizeScript:gsub('PBUY_nops', '')
	end
	processedString = processedString:gsub('PBUY_realInjection',generalSizeScript)
	processedString = processedString:gsub('PBUY_readmemBytes',size)
	--DISABLE PART
	local processedStringD = disableString
	processedStringD = processedStringD:gsub('PEACE_WHATISHERE','readmem(PEACE_Symbol_BkpBytes,PBUY_readmemBytes)')
	processedStringD = processedStringD:gsub('PBUY_readmemBytes',size)
	return processedString,processedStringD
end]=]
	basicTemplate = basicTemplate:gsub('PEACE_EXECFUNC',execFunc)
	basicTemplate = basicTemplate:gsub('PEACE_InjAddressHere',aobTitle)
	basicTemplate = basicTemplate:gsub('PEACE_Symbol',symbolName)
	form.Assemblescreen.Lines.Text = basicTemplate
end

function templateMain.OPCLuaMonoInj(frm) 
	local form = frm
	local disAsView = getMemoryViewForm().DisassemblerView
	local selAdrs = disAsView.SelectedAddress
	local aobTitle = InputQuery('Enter the Address of Injection: ','Here: ',getNameFromAddress(selAdrs))
	local symbolName=inputQuery('Enter name of Injection Symbol: ','Here: ','mySymbol')
	if not(symbolName) then return end
	if aobTitle == '' then return end
	local basicTemplate= baseTemp()
	local execFunc = [=[function createEnableandDisable(enableScriptString, disableString , injAddress)
	local currentSize = 0
	local leastSize = 13 --13 bytes at least
	local instCount = 0
	local generalSizeScript = [[push rax
	mov rax,newmem
	jmp rax
	PBUY_nops
	]]
	--ENABLE PART
	local processedString = enableScriptString
	processedString = processedString:gsub('PBUY_InjectionAddress',injAddress) --Place original injection address
	local size = getInstructionSize(injAddress)
	
	local ddis = getDefaultDisassembler()
	local disa = ddis.disassemble(injAddress)
	local _,opc,_,_ = splitDisassembledString(disa)
	local strlist = createStringlist()
	strlist.addText(opc)
	
	local nextAddress;
	while (size < leastSize) do
		nextAddress = getAddress(injAddress) + size
		size = size + getInstructionSize(nextAddress)
		disa = ddis.disassemble(nextAddress)
		_,opc,_,_ = splitDisassembledString(disa)
		strlist.addText(opc)
	end
	processedString = processedString:gsub('PEACE_WHATISHERE',strlist.Text)
	local endsize = size - leastSize
	if endsize > 0 then
		generalSizeScript = generalSizeScript:gsub('PBUY_nops', 'nop '..(endsize== 1 and '' or endsize))
	else
		generalSizeScript = generalSizeScript:gsub('PBUY_nops', '')
	end
	processedString = processedString:gsub('PBUY_realInjection',generalSizeScript)
	processedString = processedString:gsub('PBUY_readmemBytes',size)
	--DISABLE PART
	local processedStringD = disableString
	processedStringD = processedStringD:gsub('PEACE_WHATISHERE',strlist.Text)
	processedStringD = processedStringD:gsub('PBUY_readmemBytes',size)
	strlist.destroy()
	return processedString,processedStringD
end]=]
	basicTemplate = basicTemplate:gsub('PEACE_EXECFUNC',execFunc)
	basicTemplate = basicTemplate:gsub('PEACE_InjAddressHere',aobTitle)
	basicTemplate = basicTemplate:gsub('PEACE_Symbol',symbolName)
	form.Assemblescreen.Lines.Text = basicTemplate
end

function templateMain.CSCompiler(form)
	if getCEVersion() < 7.3 then showMessage('Cheat Engine 7.3 or higher is required, you dufus!'); return end
	local injName = inputQuery('Info','Enter the injection name: ','myCSInjection')
	if not(injName) then return end
	local mainScript = [=[{$lua}
if syntaxcheck then return end

[ENABLE]
--Enable Mono:
PEACE_InjectionAddress = 'PEACE_ADDRESS'
if not(getAddressSafe(PEACE_InjectionAddress)) then miMonoActivateClick() end --enable Mono
local PEACE_ref, PEACE_sys = dotnetpatch_getAllReferences()
PEACE_ref[#PEACE_ref+1] = PEACE_sys

PEACE_script = [[
using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

public class PEACE_KLASS : PEACE_PARENTKLASS {
  public  PEACE_newMethod(){
  }

  [MethodImpl(MethodImplOptions.NoInlining)]
  public  PEACE_oldMethod(){
  }
}
]]

local PEACE_asm, PEACE_msg2 = compileCS(PEACE_script,PEACE_ref,'')
if (PEACE_asm) then
  PEACE_result, PEACE_disableinfo, PEACE_disablescript = InjectDotNetDetour(PEACE_asm,PEACE_InjectionAddress,'PEACE_KLASS::PEACE_newMethod','PEACE_KLASS::PEACE_oldMethod')
else
 getLuaEngine().mOutput.clear()
 print(PEACE_msg2)
 error('could not compile CS code!')
end

--Disable Mono:
if (getAddressSafe(PEACE_InjectionAddress)) then miMonoActivateClick() end
[DISABLE]

autoAssemble(PEACE_disablescript)

	]=]

	local newF = createForm()
	newF.Width = 400
	newF.Height = 210
	newF.Caption = 'Data'
	newF.Position = 'poWorkAreaCenter'
	newF.BorderStyle = 'bsSizeable'
	local lbls = {}
	local labelCaps = {'Injection Address:','Parent Class:','Class Name:','New Method Name:','Old Method Name:'}
	local maxWidth=0
	for i=1,#labelCaps do
	  lbls[i] = createLabel(newF)
	  lbls[i].Caption = labelCaps[i]
	  lbls[i].Width = 140
	  lbls[i].Font.Size = 12
	  lbls[i].Top = i>1 and lbls[i-1].Top + lbls[i-1].Height +10 or 29--(100 - 12*#labelCaps)
	  maxWidth = lbls[i].Width > maxWidth and lbls[i].Width or maxWidth
	end

	local edts = {}
	for i=1,#lbls do
	  edts[i] = createEdit(newF)
	  edts[i].Anchors = "[akLeft,akRight,akTop]"
	  edts[i].Text = ''
	  edts[i].Font.Size = 10
	  edts[i].Left = maxWidth+2
	  edts[i].Width = newF.Width - edts[i].Left - lbls[i].Left
	  edts[i].Top = i>1 and edts[i-1].Top + edts[i-1].Height +10 or lbls[i].Top--(100 - 12*#labelCaps)
	end
	if #lbls == #edts then
		for i=1, #edts do
			lbls[i].Top = edts[i].Top
		end
	end
	function okclick()
		adrs = edts[1].Text
		pklss = edts[2].Text
		nklss = edts[3].Text
		newM = edts[4].Text
		oldM = edts[5].Text
		newF.Close()
		local newscript = mainScript:gsub('PEACE_ADDRESS',adrs)
		newscript= newscript:gsub('PEACE_KLASS',nklss)
		newscript= newscript:gsub('PEACE_PARENTKLASS',pklss)
		newscript= newscript:gsub('PEACE_newMethod',newM)
		newscript= newscript:gsub('PEACE_oldMethod',oldM)
		newscript= newscript:gsub('PEACE',injName)
		form.Assemblescreen.Lines.Text = newscript
	end
	function cancelclick()
		newF.Close()
	end
		local btnC = {'Accept','Cancel'}
		local btns = {}
		local btnFuns = {okclick,cancelclick}
	for i=1, #btnC do
		 btns[i] = createButton(newF)
		 btns[i].Caption = btnC[i]
		 btns[i].Top = edts[#edts].Top+edts[#edts].Height+1
		 btns[i].Left = i>1 and newF.Width- (btns[i].Width+10)  or 10
		 btns[i].OnClick = btnFuns[i]
	end
		edts[1].Text = getNameFromAddress(getMemoryViewForm().DisassemblerView.SelectedAddress or '')
		edts[2].Text = ''
	if (monopipe) then
		local txt = edts[1].Text:match('(.*):')
		local thKls = mono_findClass('',txt)
		if thKls~=nil then edts[2].Text = txt end
	end
	edts[3].OnChange = function()
		edts[4].Text = 'new'..edts[3].Text
		edts[5].Text = 'old'..edts[3].Text
		end
	newF.Height = edts[#edts].Top + btns[#btns].Height + 50
end
