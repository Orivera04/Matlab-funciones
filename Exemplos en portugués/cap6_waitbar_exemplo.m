% cap6_waitbar_exemplo
function cap6_waitbar_exemplo ()
h=waitbar(0,'Em execucao, aguarde...');
for i=1:50
    waitbar(i/50,h);
    z=rand(10);
    contour(z)
end
close(h)
