
alias _config source '.\SBC555.cfg'

echo Downloading 
debug -r +D:\Applications\SingleStep\sds762\registers\mpc555.rdf -p LPT1=1 SBC555\demo.elf

