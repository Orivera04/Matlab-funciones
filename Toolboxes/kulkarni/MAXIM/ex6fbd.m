function R = ex6fbd(l,m)
%R = ex6fbd(l,m)
% l=row vector of birth rates.
% m = row vector of death rates.
if  any(l < 0)
msgbox('invalid entry for l'); R='error'; return;
elseif  any(m < 0) | size(m) ~= size(l)
msgbox('invalid entry for m'); R='error'; return;

else


R=diag(l,1) + diag(m,-1);
end;
