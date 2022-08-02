% cap6_ginput_exemplo
function [x,y]=cap6_ginput_exemplo(n)
plot(rand(1,10))
display(['Entre ' num2str(n) ' pontos.']);
[x,y]=ginput(n);
hold
plot(x,y,'*')
