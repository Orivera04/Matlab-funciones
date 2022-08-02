function y = checkcR(c,R);
% checks if c is a valid cost vector that is compatible with P;
[mP nP] = size(R);
[mc nc] =size(c);
if nc > 1
   msgbox('cost vector must be a column vector'); y = 'error'; return;
elseif mc ~= mP
   msgbox('cost vector not compatible witht he transition matrix')
   y='error'; return;
else
   y = 'no error';
end;

   