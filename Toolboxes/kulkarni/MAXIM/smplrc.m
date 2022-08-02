function y=smplrc(P,w,c,d);
%y=smplrc(P,w,c,d)
%P = transition probability matrix of an irreducible SMP.
%w = sojourn time vector of an SMP.
%c(i) = cost rate in state i. (column vector)
%d(i) = expected cost of visiting state i. (column vector).
%output y = long run cost rate.
[mw nw]=size(w);
[mc nc]=size(c);
[md nd]=size(d);
if max([nw nc nd]) > 1
   msgbox('w, c, d must be column vecotrs'); y='error'; return;
elseif mw ~= mc | mc ~= md
   msgbox('w, c, d must have the same length'); y='error'; return;
else
   y=smpod(P,w);
   if y(1,1) ~= 'error'
      y=y*(c+d./w);
   end;
end;

