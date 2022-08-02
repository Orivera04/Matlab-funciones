% Script f09_12.m; max range for double integ. plant w. bound 
% on acceleration, using LINPROG; uses v as key state variable
% with v=[0; p; 0]; A*p<b, J=f'*p; a<=1;         9/96, 9/16/02
%
% Bounds on a:
tic; N=50; A1=zeros(N,N-1); for i=1:N-1, A1(i,i)=1; end; 
for i=2:N, A1(i,i-1)=-1; end; A=[A1; -A1]; dt=1/N; 
b=dt*ones(2*N,1); 
%
% Performance index J=f'*v:
f=-ones(N-1,1)*dt; 
%
% Call LINPROG:
p=linprog(f,A,b);
%
% Calculate a and y histories with optimal p:
v=[0; p; 0]; y(1)=0; a=(v(2:N+1)-v(1:N))/dt;
vb=(v(2:N+1)+v(1:N))/2; for i=1:N, y(i+1)=y(i)+dt*vb(i); end
t=[0:1/N:1]; t1=[1/(2*N):1/N:1-1/(2*N)];
%
figure(1); clf; subplot(211), plot(t,4*y,t1,a,t,2*v); grid
axis([0 1 -1.1 1.1]); hold on; plot([1 1]',[1 -1]');
plot(t,4*y,'.',t1,a,'.',t,2*v,'.'); hold off 
text(.53,-.15,'a'); text(.85,.05,'2*v'); text(.85,.82,'4*y') 
xlabel('Time'); subplot(212), plot(y,v,y,v,'.'); grid 
xlabel('y'); ylabel('v'); axis([0 .25 0 .5])
%
figure(2); clf; subplot(211), plot(t,y,t,y,'.'); grid
axis([0 1 0 .25]); ylabel('y'); xlabel('t')
subplot(212), plot(t,v,t,v,'.'); grid; axis([0 1 0 .5])
xlabel('t'); ylabel('v'); toc
       
