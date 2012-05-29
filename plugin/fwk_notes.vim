"Name: fwk Notes; notes agenda
"Version: 0.5
"Autor: Vakulenko Sergiy

if exists('g:fwk_notes_disable') || v:version < 701 
  finish 
endif 

let s:relative_path = $HOME
if  has('win32') | let s:relative_path = $VIM | endif

if !exists('g:fwk_notes_notes_directory')
    let g:fwk_notes_notes_directory = s:relative_path . '/' . 'notes' 
endif

if !exists('g:fwk_notes_open_node_mode')
    let g:fwk_notes_open_node_mode = 0 "window mode
endif


"MAPS
"--------------------------------------------------------------------

"Default map for Daily notes
map \nd :FwkNoteDaily<CR>

func s:FWK_Note_NotesMaps()
    "SPECIAL Maps for .notes extention"
    nnoremap <buffer> <silent> \cd             :FwkNoteSetColorMark Done<CR>
    vmap     <buffer> <silent> \cd             :FwkNoteSetColorMark Done<CR>

    nnoremap <buffer> <silent> \cp             :FwkNoteSetColorMark Skip<CR>
    vmap     <buffer> <silent> \cp             :FwkNoteSetColorMark Skip<CR>

    nnoremap <buffer> <silent> \ci             :FwkNoteSetColorMark Important<CR>
    vmap     <buffer> <silent> \ci             :FwkNoteSetColorMark Important<CR>

    nnoremap <buffer> <silent> \c1             :FwkNoteSetColorMark Group1<CR>
    vmap     <buffer> <silent> \c1             :FwkNoteSetColorMark Group1<CR>

    nnoremap <buffer> <silent> \c2             :FwkNoteSetColorMark Group2<CR>
    vmap     <buffer> <silent> \c2             :FwkNoteSetColorMark Group2<CR>

    "not work it now
    nnoremap <buffer> <silent> \ce             :FwkNoteSetColorMark Event<CR>
    vmap     <buffer> <silent> \ce             :FwkNoteSetColorMark Event<CR>



    "new task    (numbers)
    nnoremap <buffer> <silent> <A-d>           :call FWK_Note_Mark_Regex_w_new('\d')<CR>
    imap     <buffer> <silent> <A-d>      <Esc>:call FWK_Note_Mark_Regex_w_new('\d')<CR>

    "new subtask (alphabet)
    nnoremap <buffer> <silent> <A-a>           :call FWK_Note_Mark_Regex_w_new('\a')<CR>
    imap     <buffer> <silent> <A-a>      <Esc>:call FWK_Note_Mark_Regex_w_new('\a')<CR>

    "new subsubtask: -) 
    map      <buffer> <silent> <A-b>       :call FWK_Note_Mark_Regex_Char('-')<CR>
    imap     <buffer> <silent> <A-b>  <Esc>:call FWK_Note_Mark_Regex_Char('-')<CR>


    "map      <buffer> <silent> <A-Space>       :call FWK_Note_Mark_Regex_Char('-')<CR>
    "imap     <buffer> <silent> <A-Space>  <Esc>:call FWK_Note_Mark_Regex_Char('-')<CR>

    "select the lines, and then add bulet symbol to each of line
    vmap     <buffer> <silent> <A-r>           :call FWK_Note_addWildcardBeforeText(' • ')<CR>

    "map      <buffer> <silent> <A-t> :call s:FWK_Note_Mark_Regex_comment_new()<CR>A
    "imap     <buffer> <silent> <A-t> <Esc>:call s:FWK_Note_Mark_Regex_comment_new()<CR>A


    "block maps if you will do autocmd BufRead,BufNewFile *.<someType>	notes maps
    if &ft == 'notes'

        map      <buffer> <silent> <C-UP>      :FwkNoteUp<CR>
        map      <buffer> <silent> <C-DOWN>    :FwkNoteDown<CR>

        map      <buffer> <silent> <A-UP>      :call FWK_Note_MoveToTags(1) <CR>
        map      <buffer> <silent> <A-DOWN>    :call FWK_Note_MoveToTags(-1)<CR>
    endif

endfunc


let s:FWK_Note_Mark_Regex_Increment_SymbolDict =
            \{
            \ 'a':'b'
            \,'b':'c'
            \,'c':'d'
            \,'d':'e'
            \,'e':'f'
            \,'f':'g'
            \,'g':'h'
            \,'h':'i'
            \,'i':'j'
            \,'j':'k'
            \,'k':'l'
            \,'l':'m'
            \,'m':'n'
            \,'n':'o'
            \,'o':'p'
            \,'p':'q'
            \,'q':'r'
            \,'r':'s'
            \,'s':'t'
            \,'t':'u'
            \,'u':'v'
            \,'v':'w'
            \,'w':'x'
            \,'x':'y'
            \,'y':'z'
            \,'z':'a'
            \}

let s:fwk_notes_dict_month =
            \{
            \  1:'Jan'
            \, 2:'Feb'
            \, 3:'Mar'
            \, 4:'Apr'
            \, 5:'May'
            \, 6:'Jun'
            \, 7:'Jul'
            \, 8:'Aug'
            \, 9:'Sep'
            \,10:'Oct'
            \,11:'Nov'
            \,12:'Dec'
            \}

let s:fwk_notes_dict_month_day =
            \{
            \  1:'Mon'
            \, 2:'Tue'
            \, 3:'Wed'
            \, 4:'Thu'
            \, 5:'Fri'
            \, 6:'Sat'
            \, 7:'Sun'
            \}




"Description: add wildcard '-' before selected text
func FWK_Note_addWildcardBeforeText(strToPut)

    if match(getline("."), '\(\s*\)\?' . a:strToPut . '\(\w*\)') != -1
        "echo 'such pattern exist'
        exe 's/\(\s*\)\?\(' . a:strToPut . '\)\(\w*\)/\1\3/'

    else
        exe 's/\(\s*\)\?\(\w*\)/\1' . a:strToPut .  '\2/'
    endif
endfunc
func s:FWK_Note_LoadNotes(...)

    for s in a:000 "massive of var args
        if     s == 'change_static'  | call s:FWK_Note_create_static(s)
        elseif s == 'change_dynamic' | call s:FWK_Note_create_dynamic(s)
        elseif s == 'change_special' | call s:FWK_Note_create_special(s)
        endif
    endfor

endfunc

"//--------------------------------------------------------------------
func s:FWK_Note_create_static(type)
    return s:FWK_Note_create(a:type, 'static')
endfunc
"//--------------------------------------------------------------------
func s:FWK_Note_create_dynamic(type)
    return s:FWK_Note_create(a:type, 'dynamic')
endfunc
"//--------------------------------------------------------------------
func s:FWK_Note_create_special(type)
    return s:FWK_Note_create(a:type, 'special')
endfunc
"//--------------------------------------------------------------------

func s:FWK_Note_create(type, mode)

    let l:fileToOpen = ''
    let l:notes_path = g:fwk_notes_notes_directory
    "let g:fwk_template_path = PLFM_VIM_HOME_PATH . '/vim_extention/templates/'

    let l:anne_dir = l:notes_path . '/' . strftime("%Y")
    if !isdirectory(l:anne_dir)
        call  mkdir(l:anne_dir, "p")
    endif

    let l:mois_dir = l:notes_path . '/' . strftime("%Y") . '/' . strftime("%m_") . s:fwk_notes_dict_month[eval(strftime("%m"))]
    if !isdirectory(l:mois_dir)
        call  mkdir(l:mois_dir, "p")
    endif

    let l:timeString = strftime("%d.") . s:fwk_notes_dict_month[eval(strftime("%m"))] . strftime(".%Y")

    if     (a:mode == 'static')
        let l:fileToOpen = l:notes_path . a:type . '.notes'

    elseif (a:mode == 'dynamic')
        let l:fileToOpen = l:mois_dir . '/' . l:timeString . "_" . a:type . ".notes"

    elseif (a:mode == 'special')
        echo 'what you want to do ? ...'
        "if     a:type == 'ObjectifsPrincipale' 
            "let l:fileToOpen = l:notes_path . a:type . '.notes'
        "endif

    else
        echo 'uknown mode, exit'
        return

    endif

    if filereadable(l:fileToOpen) != 1      

        let l:mDictPatterns = { 'date': l:timeString ,'type':'' }

        "modification des patterns
        if a:type     == 'Daily'
            let l:mDictPatterns['type'] = 'Tasks'
            call FWK_copyTemplate('template_notes_daily.notes', l:fileToOpen, l:mDictPatterns )
        else 
            let l:mDictPatterns['type'] = a:type
            call FWK_copyTemplate('template_notes_common.notes', l:fileToOpen, l:mDictPatterns )
        endif


    endif

    call OpenTabSilentFunctionByType(l:fileToOpen, g:fwk_notes_open_node_mode)

    "des commands qui peuvent s'executer apres
    if a:type == 'Daily'
        call search('To\ Do')
    else
        exe ':5'
    endif

endfunc


func FWK_Note_setColorMark(mark_type)

   "let pat_main = '\s\w\+)\s'
   let pat_main = '\s[0-9A-Za-z_-]\+)\s'

   "let pat_supl_time = '\(\s\+\d\d\.\a\a\a\.\d\{4\}\.\d\d\:\d\d\)\?'
   "let pat_supl_time = '\(\d\d\s\a\a\a\s\d\d\d\d\s\d\d\s\d\d\)\?'

   "date/time pattern
   let pat_supl_time_check = '\d\d\.\d\d\.\d\{4\}\.\d\d\:\d\d' 
   let pat_supl_time = '\(' . pat_supl_time_check . '\)\?'
   let lsign = ''
   if     a:mark_type == 'Done'
      let lsign = '!Dn'

   elseif a:mark_type == 'Skip'
      let lsign = '!Sp'

   elseif a:mark_type == 'Important'
      let lsign = '!Im'

   elseif a:mark_type == 'Group1'
      let lsign = '!G1'

   elseif a:mark_type == 'Group2'
      let lsign = '!G2'

   elseif a:mark_type == 'Event'
      let lsign = '!Ev'

   else
      echo 'FWK_Note_setColorMark: unknown sign, exit'
      return

   endif



   if match(getline("."), pat_main) != -1

      if a:mark_type == 'Event'
         let isLineWithTime = match(getline("."), pat_supl_time_check)
         let ltime = '' 
         if isLineWithTime == -1
            let ltime = input("event time: ", strftime("%d.%m.%Y.%H:%M"))
            if ltime == ""
               echo 'FWK_Note_setColorMark: input aborted, exit'
               return
            endif
         else
            let ltime = substitute(getline("."), '\s!\w\+' . '\s\+' . pat_supl_time .'.*','\1','')
         endif

         let mes   = substitute(getline("."), '.*\d)','','')
         "Decho('let ltime#else=' . "'" . ltime . "'")
         "Decho('let mes#else  =' . "'" . mes   . "'")
         call s:FWK_Note_Notifyer_Wrapper(mes, ltime)

         let lsign .= FWK_CSpace(4) . ltime

     elseif a:mark_type == 'Done'
         let isLineWithTime = match(getline("."), pat_supl_time_check)
         let ltime = '' 
         if isLineWithTime == -1
            let ltime = strftime("%d.%m.%Y.%H:%M")
         else
            let ltime = substitute(getline("."), '\s!\w\+' . '\s\+' . pat_supl_time .'.*','\1','')
         endif

         "let mes   = substitute(getline("."), '.*\d)','','')
         ""Decho('let ltime#else=' . "'" . ltime . "'")
         ""Decho('let mes#else  =' . "'" . mes   . "'")
         "call s:FWK_Note_Notifyer_Wrapper(mes, ltime)

         let lsign .= FWK_CSpace(4) . ltime

      endif


      let lsign     = ' ' . lsign
      let lsign_len = len(lsign)
      let lsign     = substitute(lsign,'[\.:]','\\&','g') "add \\ before each . and :, becouse otherwise 's:::' command will not work
      let lsign_alt = ' ' . '!\w\+'
      "Decho('let lsign#final=' . "'" . lsign . "'")

      let pat_local_remove            = '^' . '\(' . lsign     . '\s\{0,\}' . '\)'. pat_supl_time  
      let pat_local_remove_universal  = '^' . '\(' . lsign_alt . '\s\{0,\}' . '\)'. pat_supl_time 
      "Decho('let pat_local_remove          =' . "'" . pat_local_remove . "'")
      "Decho('let pat_local_remove_universal=' . "'" . pat_local_remove_universal . "'")

      if match( getline("."), pat_local_remove) != -1
         let len_prev_sign = len(substitute(getline("."), pat_local_remove . '.*' , '\1\2','')) "len of prev sign
         exe 's:' . pat_local_remove . ':' . FWK_CSpace(len_prev_sign) . ':'
         "Decho('let len_prev_sign#1=' . "'" . len_prev_sign . "'")

      else
         if match( getline("."), pat_local_remove_universal) != -1 "remove previous sign, and put new in one operation
            let len_prev_sign = len(substitute(getline("."), pat_local_remove_universal . '.*', '\1\2','')) "len of prev sign
            exe 's:' . pat_local_remove_universal . ':' . FWK_CSpace(len_prev_sign) . ':'
            "Decho('let len_prev_sign#2=' . "'" . len_prev_sign . "'")

         endif

         exe 's:^' . FWK_CSpace(lsign_len) . ':' . ':'
         exe 's:^:' . lsign . ':'

      endif


      exe 'normal 0'
   else
      echo 'no mark to comment, action skipped'
      return
   endif

endfunc




func s:FWK_Note_Mark_getNumbLine ( symbol, pattern )

    let l:numb = 0
    let l:isDigit = 1

    if a:pattern ==  '\a'
        let l:isDigit = 0
    endif

    if a:symbol != '' "let's incrimate

        "Decho('l:isDigit=' . l:isDigit)

        let strToPaste      = ' '

        if l:isDigit == 1
            let l:numb = eval(a:symbol)
            let l:numb += 1
            let l:numb = string(l:numb)

        else
            let l:numb = substitute(a:symbol,'[\ ]','','g')
            let l:numb = s:FWK_Note_Mark_Regex_Increment_SymbolDict[l:numb]

        endif

    else "let's give first characters
        if l:isDigit == 1
            let l:numb = '1'
        else
            let l:numb = 'a'
        endif
    endif

    "Decho('l:numb=' . l:numb)
    let str_to_append = s:FWK_Forme_String_With_Spaces(l:numb, a:pattern)
    "Decho('str_to_append=' . str_to_append )
    return str_to_append
endfunc


func FWK_Note_Mark_Regex_w_new_recours_search(pat, direction)

        let netxIter = a:direction
        "recourse search, to descend to the bottom line in which we can found 'x)' part
        while match( getline(line(".") + netxIter + 1), a:pat)  != -1
            let netxIter += a:direction
        endwhile

        return (netxIter - a:direction)
endfunc

"aller à haut/bas tag 
func FWK_Note_MoveToTags(direction)
    let pat = '^#---------------------------------\s'
    if a:direction == 1      | call search(pat,'b')
    elseif a:direction == -1 | call search(pat)
    else                     | echo 'wrong function value' | return | endif
endfunc

"function de Vocabulaire  pour mettre (f) dans la phrase
"DEPRICATED
"func s:FWK_Note_SetFeminine()
    "if match(getline("."),'[-—]')
        "call search('[-—]')
        "exe 'normal ' . 'hi (f)'
        "exe 'normal ' . '0'
    "endif
"endfunc

" créer/continuer l'arbre alpha) ou digital) 
"
func FWK_Note_Mark_Regex_Char(symbol)
    let currLine                = line(".")
    let line_to_put = s:FWK_Forme_String_With_Spaces( a:symbol, a:symbol )
    call append(currLine, line_to_put)
    call s:FWK_Note_Mark_moveCursOneLine(1)
    startinsert!


endfunc
func FWK_Note_Mark_Regex_w_new(pattern)

    "let pat_init_search         = '\s' . a:pattern . '\+)\s'
    let pat_get_last_symb       =  '.*\s\(' . a:pattern .'\+\)).*' 
    let pat_digit_search        =  '.*\s\('  . '\d'      .'\+\)).*' 

    "let pat_init_search         = '\s' . a:pattern . '\?)\s'
    "let pat_get_last_symb       =  '.*\s\(' . a:pattern .'\?\)).*' 
    "let pat_digit_search        =  '.*\s\('  . '\d'      .'\?\)).*' 

    let currLine                = line(".")
    let lineToCheck             = 0
    let last_symbol             = ''
    let canWe_Break_Alpha_Chain = 0

    "Decho('pat_init_search=' . pat_init_search)
    "Decho('pat_get_last_symb=' . pat_get_last_symb)
    "Decho('currLine =' . currLine )

    while lineToCheck <= currLine
        let line_to_check = getline(lineToCheck)

        "Decho('line=' . lineToCheck )
        "Decho('line_to_check=' . line_to_check )

        if match ( line_to_check, pat_get_last_symb) != -1
            let last_symbol  = substitute(line_to_check, pat_get_last_symb,'\1','')
            "Decho ('line=' . line(".") . 'last_symbol=' . last_symbol )
            let canWe_Break_Alpha_Chain = 0
        endif

        if a:pattern == '\a' "we must know, can we break a chain of enumeration of alpha's
			"Decho('ici')
            if match ( line_to_check, pat_digit_search) != -1
                let canWe_Break_Alpha_Chain = 1
            endif
        endif

        let lineToCheck += 1
    endwhile
        
        
        let line_to_put = ''
        
        if canWe_Break_Alpha_Chain "can we break chain of alpha's ?
            let line_to_put = s:FWK_Note_Mark_getNumbLine( '', a:pattern )

        elseif last_symbol != ''
            let line_to_put = s:FWK_Note_Mark_getNumbLine ( last_symbol, a:pattern )

        else
            let line_to_put = s:FWK_Note_Mark_getNumbLine( '', a:pattern )

        endif

        "Decho('line_to_put=' . line_to_put)
        call append(currLine, line_to_put)
        call s:FWK_Note_Mark_moveCursOneLine(1)

    startinsert!

endfunc

func s:FWK_Forme_String_With_Spaces(symbol, pattern)
        "Decho('a:symbol=' . a:symbol)
        let l:tab = '    '
        let first_symbol = l:tab . l:tab . l:tab . l:tab . l:tab . l:tab . l:tab . l:tab
        if a:pattern == '\d'
            let first_symbol .= a:symbol
        let first_symbol .= ') '
        elseif a:pattern == '\a'
            let first_symbol .= l:tab . a:symbol
        let first_symbol .= ') '
        elseif a:pattern == '-'
            let first_symbol .= l:tab . a:symbol
        let first_symbol .= ') '

        else
            "Decho( 's:FWK_Forme_String_With_Spaces: pattern wrong, exit')
            return
        endif
        return first_symbol

endfunc

func s:FWK_Note_Mark_Regex_comment_new()
       exe "normal 0"
       exe "normal " . "i#----------# \<Space>"
endfunc

func s:FWK_Note_Mark_Regex_new_part()
    startinsert! "start insert mode, like A
       exe "normal \<Enter>-"
endfunc


func s:FWK_Note_Day_Navigation_search_in_month(path_bgn, cur_local_day, path_end, action_type)
    let max_day = 31
    let min_day = 1
    let local_day = a:cur_local_day

    if isdirectory(a:path_bgn)
        "Decho('path_bgn = ' . a:path_bgn)
        while local_day >= min_day && local_day <= max_day

            let local_day = s:FWK_Note_Day_Navigation_convert_numb_to_twobyte(local_day)

            let new_note_file = a:path_bgn  . local_day . a:path_end
            "Decho('local day=' . local_day)
            "Decho('new_note_file = ' . new_note_file)

            if filereadable(new_note_file)
                return new_note_file
            endif

            let local_day += a:action_type

        endwhile

    endif

    return ''
endfunc

func FWK_Note_Navigation(type, direct)
    if a:type == 'notes'
        call FWK_Note_Notes_Navigation(a:direct)
    elseif a:type == 'day'
        call FWK_Note_Day_Navigation(a:direct)
    endif

endfunc

func s:FWK_Note_Day_Navigation_convert_numb_to_twobyte(variable)

    if len(string(a:variable)) == 1
        return  '0' . string(a:variable)
    else
        return a:variable
    endif

endfunc
func FWK_Note_Day_Navigation(action_type)

    let notes_path_pat           = '\(.*\)\(\d\{4\}\)\(\\\|\/\)\(\d\{2\}\)\(_\w\+\)'
    let notes_file_name_pat      = '\(\d\+\)\(\.\)\(\u\l\+\)\(\.\)\(\d\{4\}\)\(_\)\(\w*\)\(\.\)\(\l\+\)'

    let notes_file_name          = expand ("%:t")
    let local_day                = substitute(notes_file_name, notes_file_name_pat, '\1','')
    let notes_type               = substitute(notes_file_name, notes_file_name_pat,'\7','')

"/home/svakulenko/Notes/dynamic/2012/04_Apr
"C:\programs\gvim\Notes\dynamic\2012\04_Apr
    let notes_path               = expand ("%:p:h")
    let path_bgn                 = substitute(notes_path,notes_path_pat,'\1','')
    let slash                    = substitute(notes_path,notes_path_pat,'\3','')
    let local_year               = substitute(notes_path,notes_path_pat,'\2','')
    let local_month              = substitute(notes_path,notes_path_pat,'\4','')

    let max_month                = 12
    let min_month                = 1
    "Decho("notes_path=" . notes_path)


    if a:action_type == -1 || a:action_type == 1

        while 1

            "Decho("path_bgn=" . path_bgn)
            "Decho("local_year=" . local_year)
            "Decho("local_month=" . local_month)
            "Decho("eval(local_month)=" . eval(local_month))
            let path_coller_bgn = path_bgn . local_year . '/' . local_month . '_' . s:fwk_notes_dict_month[eval(local_month)] . '/'
            let reste_string    = '.' . s:fwk_notes_dict_month[eval(local_month)] . '.' . local_year . '_' . notes_type . '.notes'


                let file_to_open    = s:FWK_Note_Day_Navigation_search_in_month(path_coller_bgn , (local_day+a:action_type), reste_string, a:action_type)

            if file_to_open == ''

                let answer = ''
                let answer_echo = 
                            \'No files found in notes type ' . notes_type .
                            \', in month '                   . s:fwk_notes_dict_month[eval(local_month)] . 
                            \', in year '                    . local_year

                if  (local_month + a:action_type) > max_month 
                            \|| (local_month + a:action_type) < min_month
                    let answer = input(answer_echo . '. Continue search in next year (y/n)?')

                    if  answer == 'y' || answer == 'Y' 
                        let local_year += a:action_type

                        if a:action_type == 1
                            let local_month = 0
                        else
                            let local_month = 13
                        endif

                    endif

                else
                    let answer = input(answer_echo . '. Continue search in next month (y/n)?')
                endif

                if  answer == 'y' || answer == 'Y' 
                    let local_month += a:action_type

                    let local_month = s:FWK_Note_Day_Navigation_convert_numb_to_twobyte(local_month)

                    if a:action_type == 1
                        let local_day = 0
                    else
                        let local_day = 32
                    endif
                else
                    break
                endif

            else
                exe 'e ' . file_to_open
                break

            endif


        endwhile


    else
        echo 'FWK_Note_Day_Navigation: wrong function arguments, skipped'
    endif



endfunc
            
"this is fonction for event notifier. Not works now.
func s:FWK_Note_Notifyer_Wrapper(message, time)
    "call s:FWK_Note_Notifyer_Wrapper("hello From Vim", '22.02.2011.33:33')
    "echo 'time_to_propose"' . time_to_propose .'"'
    "if time_to_propose != ""
        let ex_str ='nc.bat' . ' "-m' . a:message . '" -d' . a:time 
        echo ex_str
        echo system(ex_str)
    "endif


    "return time_to_propose

endfunc

func s:FWK_Note_Mark_moveCursOneLine( pos_direct )
       let curpos = getpos(".")
       let curpos[1] += a:pos_direct
       call setpos(".", curpos)
endfunc


"map \nh :call s:FWK_Note_LoadNotes
            "\(
            "\  'change_static', 'CommonTasks'
            "\, 'change_dynamic', 'Daily', 'Vocabulaire'
            "\)<CR>


command! -n=1 FwkNoteStatic       :call s:FWK_Note_create_static('<args>')
command! -n=1 FwkNoteDynamic      :call s:FWK_Note_create_dynamic('<args>')
command! -n=0 FwkNoteDaily        :call s:FWK_Note_create_dynamic('Daily')
command! -n=1 FwkNoteDynamic      :call s:FWK_Note_create_dynamic('<args>')
command! -n=1 FwkNoteSetColorMark :call   FWK_Note_setColorMark('<args>')
command! -n=0 FwkNoteApplyMaps    :call s:FWK_Note_NotesMaps()
command! -n=0 FwkNoteUp           :call   FWK_Note_Day_Navigation(1)
command! -n=0 FwkNoteDown         :call   FWK_Note_Day_Navigation(-1)


"INIT GLOBAL
autocmd BufRead,BufNewFile *.notes		set filetype=notes
autocmd FileType        notes call s:FWK_Note_NotesMaps() "set maps for notes




