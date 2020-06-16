let s:dir = expand('<sfile>:p:h').'/dispatch'
let s:filelist = system('ls '.s:dir)
for file in split(s:filelist)
    exec 'source '.s:dir.'/'.file
endfor

