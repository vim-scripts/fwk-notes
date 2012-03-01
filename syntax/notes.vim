if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

"//--------------------------------------------------------------------
"set NOTES COLORS
"//--------------------------------------------------------------------
hi FWK_Note_comment_Color                   guifg=SkyBlue
hi FWK_Note_important_Color                 guifg=PaleVioletRed1
hi FWK_Note_warning_Color                   guifg=red
hi FWK_Note_Enumeration_Number_Color        guifg=green
hi FWK_Note_Enumeration_Alphabet_Color      guifg=yellow1
hi FWK_Note_Enumeration_Tire_Color          guifg=DarkSlateGray3

hi FWK_Note_Col_Mark_Done                   guifg=green1
hi FWK_Note_Col_Mark_Skip                   guifg=CornflowerBlue
hi FWK_Note_Col_Mark_Important              guifg=IndianRed1
hi FWK_Note_Col_Mark_Group1                 guifg=pink
hi FWK_Note_Col_Mark_Group2                 guifg=SpringGreen
hi FWK_Note_Col_Mark_Event                  guifg=Yellow

hi FWK_Note_LCol_Mark_LatexWord             guifg=PaleGreen3
hi FWK_Note_LCol_Mark_LatexBrackets         guifg=LightSteelBlue3

hi FWK_Note_Col_SpecialWord_All             guifg=tomato2
hi FWK_Note_Col_SpecialWord_Example         guifg=LightSalmon3

hi FWK_Note_Col_SpecialWord_Comment         guifg=SkyBlue
"hi FWK_Note_Section_Color                   guifg=LightSeaGreen

"//--------------------------------------------------------------------
"set SYNTAX 
"//--------------------------------------------------------------------
  "syn match FWK_Note_Section '#//[\-]\+\n.*\n#//[\-]\+'

  syn match FWK_Note_comment                     "^\s*#.*"

  syn match FWK_Note_Enumeration_Number          "\s\d\+) "
  "syn match FWK_Note_Enumeration_Alphabet        "\s\[a-z]\{1\}) "
  syn match FWK_Note_Enumeration_Alphabet        "\s[a-z]\{1})\s"
  syn match FWK_Note_Enumeration_Tire            "\s\-) "

  syn match FWK_Note_important                   "! .*$"
  syn match FWK_Note_warning                     "!\{3\} .*$"
  syn match FWK_Note_HLCol_Mark_Done             "!Dn\s.*$"
  syn match FWK_Note_HLCol_Mark_Skip             "!Sp\s.*$"
  syn match FWK_Note_HLCol_Mark_Important        "!Im\s.*$"
  syn match FWK_Note_HLCol_Mark_Group1           "!G1\s.*$"
  syn match FWK_Note_HLCol_Mark_Group2           "!G2\s.*$"
  syn match FWK_Note_HLCol_Mark_Event            "!Ev\s.*$"

  syn match FWK_Note_HLCol_Mark_LatexWord        "\\\{1\}[a-zA-Z_^]\+"
  syn match FWK_Note_HLCol_Mark_LatexBrackets    "{[a-zA-Z0-9]\+}"

  syn match FWK_Note_Syn_SpecialWord_All          "\(Section\|Sub\ Section\|Note\|Tips\|Definition\|Def\|Question\|Answer\): "
  syn match FWK_Note_Syn_SpecialWord_Example      "\(Example\|Code\|Resource\|HomeWork\):"
  "syn cluster Comment contains=FWK_Note_Syn_SpecialWord_SpecialWords
  syn match FWK_Note_Syn_SpecialWord_Comment     "^#.*$"       contains=FWK_Note_Syn_SpecialWord_All,FWK_Note_Syn_SpecialWord_Example

"//--------------------------------------------------------------------
"LINK SYNTAX TO COLOR
"//--------------------------------------------------------------------
  hi link FWK_Note_comment              FWK_Note_comment_Color
  hi link FWK_Note_Enumeration_Number   FWK_Note_Enumeration_Number_Color
  hi link FWK_Note_Enumeration_Alphabet FWK_Note_Enumeration_Alphabet_Color
  hi link FWK_Note_Enumeration_Tire     FWK_Note_Enumeration_Tire_Color
  hi link FWK_Note_important            FWK_Note_important_Color
  hi link FWK_Note_warning              FWK_Note_warning_Color

  hi link FWK_Note_HLCol_Mark_Done      FWK_Note_Col_Mark_Done
  hi link FWK_Note_HLCol_Mark_Skip      FWK_Note_Col_Mark_Skip
  hi link FWK_Note_HLCol_Mark_Important FWK_Note_Col_Mark_Important
  hi link FWK_Note_HLCol_Mark_Group1    FWK_Note_Col_Mark_Group1
  hi link FWK_Note_HLCol_Mark_Group2    FWK_Note_Col_Mark_Group2
  hi link FWK_Note_HLCol_Mark_Event     FWK_Note_Col_Mark_Event

  hi link FWK_Note_HLCol_Mark_LatexWord     FWK_Note_LCol_Mark_LatexWord
  hi link FWK_Note_HLCol_Mark_LatexBrackets FWK_Note_LCol_Mark_LatexBrackets


  "special words
  hi link FWK_Note_Syn_SpecialWord_Comment            FWK_Note_Col_SpecialWord_Comment
  hi link FWK_Note_Syn_SpecialWord_All                FWK_Note_Col_SpecialWord_All
  hi link FWK_Note_Syn_SpecialWord_Example            FWK_Note_Col_SpecialWord_Example

  "hi link FWK_Note_Section FWK_Note_Section_Color



