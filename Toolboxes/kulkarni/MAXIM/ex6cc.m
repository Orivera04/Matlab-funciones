function R = ex6cc(l,m,M,H);
%R = ex6cc(l,m,M,H)
% Computes the R matrix for the Call Center of Example 
% 6.11.
%M  Number of reservation clerks;
%H Number of calls that can be put on hold;
%l call arrival rate in hours;
%m number of calls served by one server per hour.
if any([l m] < 0)
   msgbox('l and m must be positive'); R='error'; return;
elseif M < 0 | fix(M) - M ~=0
   msgbox('invalid netry for M'); R='error'; return;
elseif H < 0 | fix(H) - H ~= 0
   msgbox('invalid entry for H'); R='error'; return;
else
R = zeros(M+H+1,M+H+1);
for i = 0:M+H-1
R(i+1,i+2) = l;
end;
for i = 1:M
R(i+1,i) = i*m;
end;
for i=M+1:M+H
R(i+1,i) = M*m;
end;
end;

