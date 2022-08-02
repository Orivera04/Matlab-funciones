function y = smpod(P,w)
%y = smpod(P,w)
% computes the occupancy distribution of an SMP with  one step
%probability transition matrix P, and sojourn time (column) vector w.
[mw nw] = size(w);
[mP nP] = size(P);
if mw ~= mP
   msgbox(' w and P are not compatible'); y='error'; return;
elseif nw > 1
   msgbox('w must be a column vector'); y='error'; return;
elseif any(w < 0) | sum(w) == 0
   msgbox('invalid entry for w'); y='error'; return;
else
   pi=dtmcod(P);
   if pi(1,1) ~= 'error'
      y=pi.*w';
      y=y/sum(y);
   end;
end;
    