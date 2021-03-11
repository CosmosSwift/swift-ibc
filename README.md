# swift-ibc

The start of porting ibc to Swift

Applications:
[ ]: Transfer

Core:
[ ]: 02-Client
[ ]: 03-Connection
[ ]: 04-Channel
[ ]: 05-Port
[ ]: 23-Commitment
[x]: 24-Host module
[ ]: Core

Lightclients
[ ]: 06-SoloMachine
[ ]: 07-Tendermint
[ ]: 09-Localhost

# Tools

`for i in $( ls *.go ); do sed '1 s/^/\/\*\n/' $i > ${i}do; echo \*\/ >> ${i}do; mv -- "$i" "${i%.go}.swift"; done;`
`for i in $( ls *.godo ); do mv -- "$i" "${i%.godo}.swift"; done`
