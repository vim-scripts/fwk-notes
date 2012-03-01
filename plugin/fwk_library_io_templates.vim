if v:version < 701 
  finish 
endif 

let s:relative_path = $HOME . '/' . '.vim'
if  has('win32') | let s:relative_path = $VIM . '/' .'vimfiles' | endif

if !exists('g:fwk_templates_directory')
    let g:fwk_templates_directory = s:relative_path . '/' . 'templates'
endif

function FWK_System_readFile(file_to_open)
    if filereadable(a:file_to_open) == 1      
        return readfile( a:file_to_open)  
    else 
        echo "FWK_System_readFile: can't read file " . a:file_to_open . ", because it isn't exist" 
    endif 
endfunction

function FWK_System_writeFile(list_to_save, file_to_save)

        if filereadable(a:file_to_save) == 1 
            let l:answer = input(" file " . a:file_to_save . " is exist" . "replace?(y/n):") 
            if l:answer == 'y' && l:answer == 'Y' 
                return 1 
            endif 
        endif 

        call writefile(a:list_to_save, a:file_to_save) 

endfunction

" modify list with dictionary patterns. Remember, list will iterate only once
" (for time economy), that why it is very important sets all patterns in fil order
function FWK_System_modify_list(list_to_modify, dict_with_patterns)

    let l:list_fresh = a:list_to_modify
    "Decho('FWK_System_modify_list')
    if a:dict_with_patterns != {}

        let l:iter = 0
        let l:iterMax = len(a:list_to_modify)

        while l:iter < l:iterMax
            "Decho('FWK_System_modify_list 2')

            for pattern_key in keys(a:dict_with_patterns)
                if l:list_fresh[l:iter]  =~ pattern_key
                    "Decho('FWK_System_modify_list 4')
                    let a:list_to_modify[l:iter] = a:list_to_modify[l:iter] . ' ' . a:dict_with_patterns[pattern_key]
                endif
            endfor

        let l:iter +=1
        endwhile

    endif

endfunction


function FWK_copyTemplate(loadTemplateFileName, saveFileName, dict_Patterns)  

        let l:template_dir = g:fwk_templates_directory . '/' 
        let l:mList = FWK_System_readFile(l:template_dir . a:loadTemplateFileName)

        if !empty(l:mList)
            call FWK_System_modify_list(l:mList, a:dict_Patterns)
            call FWK_System_writeFile(l:mList, a:saveFileName)
        else
            return 1
        endif

    return 0

endfunction  


