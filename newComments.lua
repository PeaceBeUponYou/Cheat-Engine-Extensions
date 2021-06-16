------------######  Author--------------PeaceBeUponYou
------------######  Extension-----------CommentsForm
-------------------------------------------------------


for i=0,getFormCount()-1 do
 if getForm(i).Name == 'Comments' then
    frm = getForm(i)
    local fun = frm.OnShow
    frm.OnShow = function(sender)
      fun(sender)
      frm.synE.Lines.Text = frm.Memo1.Lines.Text
    end
 end
end

frm.Caption = 'Comments [by PeaceBeUponYou]'
frm.BorderStyle = 'bsSizeable'
frm.BorderIcons = '[biSystemMenu,biMinimize,biMaximize]'
frm.Position = 'poWorkAreaCenter'


---[[
pnl1 = createSynEdit(frm,1)--1=AutoassemblerFormat
pnl1.Name = 'synE'
pnl1.Width = frm.Width
pnl1.Height = frm.Height
pnl1.Anchors = '[akTop,akLeft,akRight,akBottom]'
pnl1.Beautifier.IndentType = 'sbitSpace'
pnl1.BracketHighlightStyle = 'sbhsBoth'
pnl1.Options = 'eoAutoIndent,eoBracketHighlight,eoGroupUndo,eoPersistentCaret,eoSmartTabs,eoTabIndent,eoTabsToSpaces,eoTrimTrailingSpaces'
pnl1.Options2 = 'eoFoldedCopyPaste,eoOverwriteBlock'
pnl1.Lines.Text = ''--frm.Memo1.Lines.Text
function createPopupAndAddItems(pnl1)
  --create popup
  pnl1.PopupMenu = createPopupMenu(pnl1)
  popup = pnl1.PopupMenu
  popup.TrackButton = 'tbRightButton'
  --add menus
  local cpyLabel = 'Copy'
  local pstLabel = 'Paste'
  local cutLabel = 'Cut'
  local undoLabel = 'Undo'
  local redoLabel = 'Redo'
  local selAllLabel = 'Select All'
  local clrAllLabel = 'Clear All'
  local clrSelLabel = 'Clear Selected'
  local gotoAddressLabel = 'Go To Address'

  cpyItem = createMenuItem(popup)
  pstItem = createMenuItem(popup)
  cutItem = createMenuItem(popup)
  undoItem = createMenuItem(popup)
  redoItem = createMenuItem(popup)
  selAllItem = createMenuItem(popup)
  clrAllItem = createMenuItem(popup)
  clrSelItem = createMenuItem(popup)
  gotoAddressItem = createMenuItem(popup)

  cpyItem.Caption = cpyLabel
  pstItem.Caption = pstLabel
  cutItem.Caption = cutLabel
  undoItem.Caption = undoLabel
  redoItem.Caption = redoLabel
  selAllItem.Caption = selAllLabel
  clrAllItem.Caption = clrAllLabel
  clrSelItem.Caption = clrSelLabel  
  gotoAddressItem.Caption = gotoAddressLabel

  popup.Items.Insert (0, cpyItem)
  popup.Items.Insert (1, pstItem)
  popup.Items.Insert (2, cutItem)
  popup.Items.Insert (3, undoItem)
  popup.Items.Insert (4, redoItem)
  popup.Items.Insert (5, selAllItem)
  popup.Items.Insert (6, clrSelItem)
  popup.Items.Insert (7, clrAllItem)
  popup.Items.Insert (8, gotoAddressItem)
  
  cpyItem.Shortcut = 'CTRL+C'
  pstItem.Shortcut = 'CTRL+V'
  cutItem.Shortcut = 'CTRL+X'
  undoItem.Shortcut = 'CTRL+Z'
  redoItem.Shortcut = 'CTRL+R'
  selAllItem.Shortcut = 'CTRL+A'
  gotoAddressItem.Shortcut = 'CTRL+G'
  --item's functions
  cpyItem.OnClick = function()
        pnl1.CopyToClipboard()
  end
  pstItem.OnClick = function()
        pnl1.PasteFromClipboard()
  end
  cutItem.OnClick = function()
        pnl1.CutToClipboard()
  end
  undoItem.OnClick = function()
        pnl1.Undo()
  end
  redoItem.OnClick = function()
        pnl1.Redo()
  end
  selAllItem.OnClick = function()
        pnl1.SelectAll()
  end
  clrSelItem.OnClick = function()
        pnl1.ClearSelection()
  end
  clrAllItem.OnClick = function()
        pnl1.Lines.Text = ''
  end
  gotoAddressItem.OnClick = function()
	local addressToGo = getAddressSafe(pnl1.SelText)
	if addressToGo ~= nil then getMemoryViewForm().DisassemblerView.SelectedAddress = addressToGo; getMemoryViewForm().show() end
  end
end 
createPopupAndAddItems(pnl1) 
function createMen(frm)
	menu1 = createMainMenu(frm)
	
	readO = createMenuItem(menu1)
	readO.Caption = 'ReadOnly'
	menu1.Items.add(readO)
	highlightMain = createMenuItem(menu1)
	highlightMain.Caption = 'Highlighter'
	menu1.Items.add(highlightMain)
	
	ena = createMenuItem(readO)
	ena.Caption = 'Enabled'
	ena.Checked = false
	menu1.Items.Item[readO].add(ena)

	disa = createMenuItem(readO)
	disa.Caption = 'Disabled'
	disa.Checked = true
	menu1.Items.Item[readO].add(disa)

	ena.OnClick = function()
	  ena.Checked = true
	  disa.Checked = false
	  pnl1.ReadOnly = true
	end
	disa.OnClick = function()
	  disa.Checked = true
	  ena.Checked = false
	  pnl1.ReadOnly = false
	end
	
	
	luaSyn = createMenuItem(highlightMain)
	luaSyn.Caption = 'Lua'
	luaSyn.Checked = false
	menu1.Items.Item[1].add(luaSyn)
	
	asmSyn = createMenuItem(highlightMain)
	asmSyn.Caption = 'ASM'
	asmSyn.Checked = true
	menu1.Items.Item[1].add(asmSyn)
	
	txtSyn = createMenuItem(highlightMain)
	txtSyn.Caption = 'Text'
	txtSyn.Checked = false
	menu1.Items.Item[1].add(txtSyn)
	
	txtSyn.OnClick = function()
	  txtSyn.Checked = true
	  luaSyn.Checked = false
	  asmSyn.Checked = false
	  pnl1.Highlighter = 0
	end
	asmSyn.OnClick = function()
	  asmSyn.Checked = true
	  luaSyn.Checked = false
	  txtSyn.Checked = false
	  pnl1.Highlighter = createSynEdit(tab,1).Highlighter --AsmSyntax
	end
	luaSyn.OnClick = function()
	  luaSyn.Checked = true
	  txtSyn.Checked = false
	  asmSyn.Checked = false
	  pnl1.Highlighter = createSynEdit(tab,0).Highlighter --luaSyntax
	end
end
pnl1.OnChange = function()
  frm.Memo1.Lines.Text = pnl1.Lines.Text
end
frm.OnClose = function ()
  frm.Memo1.Lines.Text = pnl1.Lines.Text
  frm.hide()
end 

createMen(frm)
