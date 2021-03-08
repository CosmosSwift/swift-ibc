# swift-ibc

The start of porting ibc to Swift



# Tools

`for i in $( ls *.go ); do sed '1 s/^/\/\*\n/' $i > ${i}do; echo \*\/ >> ${i}do; mv -- "$i" "${i%.go}.swift"; done;`
`for i in $( ls *.godo ); do mv -- "$i" "${i%.godo}.swift"; done`