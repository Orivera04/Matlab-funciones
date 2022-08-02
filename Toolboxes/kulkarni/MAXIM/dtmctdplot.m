function y = dtmctdplot(a,P,NN,j)
%y = dtmctdplot(a,P,NN,j)
%Plots P(X_n=j) for $0 \le n \le NN$, for a DTMC with transition probability matrix
%P and initial distribution a.
[mP nP]=size(P);
if (j - fix(j) ~= 0) | j <= 0 | j > nP
   msgbox('invalid entry for j'); y='error'; return;
elseif (NN < 0) | NN - fix(NN) ~= 0
   msgbox('invalid entry for NN'); y='error'; return;
else
   y=checkaP(a,P);
if y(1,1) ~= 'error'
y=[a(j)];
for n=1:NN
a=a*P;
y=[y a(j)];
end;
plot([0:NN], y)
end;
end;
 
