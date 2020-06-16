let lnum = search("package .\\+;")
let line = getline(lnum)
let packagename = split(line, "\[ ;\]")[1]
let fname = expand('%:t:r')
let bin = packagename . "." . fname
let cmd = "AsyncRun -mode=term -rows=12 java -classpath bin " . bin
