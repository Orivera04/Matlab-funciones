function R = ex6ar(l);
%R = ex6ar(l)
%l engine failure rate;
if  l < 0 
msgbox('invalid entry for l');R='error'; return;
else
R=diag([l l l 2*l 2*l 2*l],-3) + diag([l 2*l 0 l 2*l 0 l 2*l],-1);
end;
