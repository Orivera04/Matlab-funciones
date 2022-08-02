function C=dblin_c(p,N)                            
% Max range DouBLe INTegrator plant using NLP;  11/94, 9/97, 4/3/98
% 
v=[0 p(1:N-1) 0]; x(1)=0;  dt=1/N;
a=(v(2:N+1)-v(1:N))/dt; vb=(v(2:N+1)+v(1:N))/2;
for i=1:N,
  x(i+1)=x(i)+dt*vb(i); C(:,i)=[a(i)-1; -a(i)-1]   ;
end
		      