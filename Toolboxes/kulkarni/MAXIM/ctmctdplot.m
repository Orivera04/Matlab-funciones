function y = ctmctdplot(a,R,T,j)
%y = ctmctdplot(a,R,T,j)
%Plots P(X(t)=j) for $0 \le t \le T$, for a CTMC with rate matrix
%R and initial distribution a.
[mR, nR] = size(R)
if T < 0
   msgbox('T must be a positive number'); y='error'; return;
elseif j < 1 | j > nR | j - fix(j) ~= 0
   msgbox('invalid value for j'); y='error'; return;
else
y=checkaR(a,R);
y=[a(j)];
NN=20; %number of points on the plot
B=ctmctm(R,T/NN);
if B(1,1) ~= 'error'
for n=1:NN
a=a*B;
y=[y a(j)];
end;
plot([0:T/NN:T], y)  
end;
end;