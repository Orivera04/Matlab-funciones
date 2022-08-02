function sp=lapend(t,s)
% Large Amplitude PENDulum; s=[th thdot]';  2/2/98
%
sp=[s(2) -sin(s(1))]';