"Name: fwk Notes 
"Version: 0.5
"Autor: Vakulenko Sergiy
"Description: plugin to work with tabs (open, close).


"---------------------------------------------------------------------------------
"fwk main control functions
"---------------------------------------------------------------------------------
func FWK_CloseBufferSafe(buffer_Number, ... )
    let shouldWeCloseBuffer = 0
    let l:numb_of_buffer_copies_opened = 0
    for i in range(tabpagenr('$'))
        "let l:tablistVar =  []
        "call extend(l:tablistVar, tabpagebuflist(i + 1))
        for j in tabpagebuflist(i+1)
            if j == a:buffer_Number
                let l:numb_of_buffer_copies_opened += 1
                if l:numb_of_buffer_copies_opened == 2
                    let shouldWeCloseBuffer = 1 "not close tab, but only buffer
                    break
                endif
            endif
        endfor
    endfor
    if shouldWeCloseBuffer
        exe 'close'
    elseif a:0 == 0
        exe 'bw'
    else "if more then one argument argument"
        exe 'bw!'
    endif
    "JUST UNCOMMENT AND IT WILL BE WORK
    "close tab if on tab page only one empty buffer
    "let current_tab_id = tabpagenr()
    "let wins_count = tabpagewinnr(current_tab_id, '$')
    "let current_buf_name = bufname("%")
    "if current_buf_name == '' && wins_count == 1 
        "exe 'close'
    "endif
endfunc


func FWK_openWindow( file_path )

    let curr_tab   = tabpagenr()
    let wins_list  = tabpagebuflist(curr_tab)
    let wins_count =  len (wins_list)
    if wins_count == 1 && IsNoNameBuffer( wins_list[0] ) "is tab is without windows
        exe 'e '     . a:file_path
    else
        exe 'split ' . a:file_path
    endif
endfunc
"---------------------------------------------------------------------------------
"OPEN FILE IN TAB, if TAB exist, go to this TAB
"thanks to MRU plugin function! s:MRU_Window_Edit_File(win_opt)
"---------------------------------------------------------------------------------
"
"---------------------------------------------------------------------------------
"function! s:TabAranger_FindPosition_Of_Tab(bufferName)


"endfunction
"---------------------------------------------------------------------------------
function OpenTabSilentFunctionByType(fileName,int_mode)
    if     a:int_mode == 0
        call s:OpenTabSilentFunction(a:fileName, 'split_only_if_two')  "OpenWindowSilent
    elseif a:int_mode == 1
        call s:OpenTabSilentFunction(a:fileName, 'tab')                "OpenTabsSilent
    elseif a:int_mode == 2
        call s:OpenTabSilentFunction(a:fileName, 'split_h')            "SplitTabsSilent
    else
        exe ':e ' . a:fileName
    endif 

endfunc
"---------------------------------------------------------------------------------
function! s:OpenTabSilentFunction(fileName, mode)

    "call Decho("filename is = " . a:fileName) 
    let fname = a:fileName
    if bufwinnr('^' . fname . '$') == -1 "if this buffer not was opened before
        let tabnum = -1
        let i = 1
        let bnum = bufnr('^' . fname . '$') "get buffer index
        while i <= tabpagenr('$')
            if index(tabpagebuflist(i), bnum) != -1 "buffer index is not in tabList ?
            let tabnum = i
            break

            "added for NoName buffer
            elseif bufname(bnum) == "" && a:fileName == ""
            let tabnum = i
            break

            endif
            let i += 1
        endwhile

        if tabnum != -1
            " Goto the tab containing the file
            exe 'tabnext ' . i
            "call Decho("tabnext message") 
        else
            " Open a new tab as the last tab page
            if a:mode == 'tab'
                exe '999tabnew ' . fname
            elseif a:mode == 'split_h'
                exe 'split ' . fname
            elseif a:mode == 'split_only_if_two' "if window contain only one 'noname' buffer -> use ':e '
                call FWK_openWindow( fname )
                "exe 'split ' . fname
            else
                echo "OpenTabSilentFunction: wrong mode"
                return
            endif

            "call Decho("999tabnew message") 
        endif
    endif

    " Jump to the window containing the file
    let winnum = bufwinnr('^' . fname . '$')
    if winnum != winnr()
    exe winnum . 'wincmd w'
    endif

endfunction
"---------------------------------------------------------------------------------
"tag emulation function
"---------------------------------------------------------------------------------
function! s:GfEmulatorForTabs()
    exe "lcd %:p:h"
    let l:localBufferNumber = bufnr("%")

    "let l:tagName = a:word
    let l:tagName = expand('<cword>')
    silent exe "0tag! /^". l:tagName

    if l:localBufferNumber != bufnr("%")
    let l:newBufferNumber = bufnr("%")
    let l:newBufferName = bufname(l:newBufferNumber)
    exe "b ". l:localBufferNumber
    exe "tabnew ". l:newBufferName
    exe "b". l:newBufferNumber
    else
    echo "skip open buffer,tags in the same file"
    endif

endfunc

"---------------------------------------------------------------------------------
func! IsNoNameBuffer(buff_number)
    let name = bufname(a:buff_number)
    if name == '' && getbufvar(a:buff_number, "&buftype") == ''
        return 1 "this is no name buffer
    endif

    return 0
endfunc

"---------------------------------------------------------------------------------
function! GuiTabLabel()
    let label = ''
    let bufnrlist = tabpagebuflist(v:lnum)

    " Add '+' if one of the buffers in the tab page is modified
    for bufnr in bufnrlist
    if getbufvar(bufnr, "&modified")
        let label = '+'
        break
    endif
    endfor

    " Append the tab number
    let label .= tabpagenr().': '

    " Append the buffer name
    let index_of_zero_window = tabpagewinnr(v:lnum) - 1
    let buff_number = bufnrlist[index_of_zero_window]
    let name = bufname(buff_number)
    if name == ''
        " give a name to no-name documents
        if &buftype=='quickfix'
            let name = '[Quickfix List]'
        elseif IsNoNameBuffer( buff_number )
            let name = '[No Name]'
        endif
    else
    " get only the file name
    let name = fnamemodify(name,":t")
    endif
    let label .= name

    " Append the number of windows in the tab page
    let wincount = tabpagewinnr(v:lnum, '$')
    return label
    "return label . '  [' . wincount . ']'

endfunction

"---------------------------------------------------------------------------------
" set up tab tooltips with every buffer name
"---------------------------------------------------------------------------------
function! GuiTabToolTip()
    let tip = ''
    let bufnrlist = tabpagebuflist(v:lnum)

    for bufnr in bufnrlist
    " separate buffer entries
    if tip!=''
        let tip .= ' | '
    endif

    " Add name of buffer
    let name=bufname(bufnr)
    if name == ''
        " give a name to no name documents
        if getbufvar(bufnr,'&buftype')=='quickfix'
        let name = '[Quickfix List]'
        else
        let name = '[No Name]'
        endif
    endif
    let tip.=name

    " add modified/modifiable flags
    if getbufvar(bufnr, "&modified")
        let tip .= ' [+]'
    endif
    if getbufvar(bufnr, "&modifiable")==0
        let tip .= ' [-]'
    endif
    endfor

    return tip
endfunction
"---------------------------------------------------------------------------------
command! -n=? -complete=dir GFforTabs           :call s:GfEmulatorForTabs()
command! -n=? -complete=file OpenTabsSilent     :call s:OpenTabSilentFunction('<args>', 'tab')
command! -n=? -complete=file SplitTabsSilent    :call s:OpenTabSilentFunction('<args>', 'split_h')
command! -n=? -complete=file OpenWindowSilent   :call s:OpenTabSilentFunction('<args>', 'split_only_if_two')
"---------------------------------------------------------------------------------

