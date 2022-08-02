function [L,y,ev,evec]=popn(name,y,tol,mxit)
%POPN - Newton-Raphson version of POP.
%[L,y,ev,evec]=popn(name,y,tol,mxit)
% Parameter OPtimization with equality constraints using a Newton-
% raphson algorithm. Outputs: L=optimum performance index, y= 
% optimum parameter vector; (ev,evec)=(eigvals,eigvecs) of Hessian.
% Inputs: 'name' contains data; y=guess of parameter vector;
% stopping criterion is max(fn,Hyn)<tol where fn=norm(f), 
% Hyn=norm(Hy); mxit=max no. iterations              10/91, 6/18/02
%
format compact; it=0; fn=1; Hyn=1; p=length(y);
disp('        it       L        fn        Hyn')
while max([fn Hyn]) > tol
 [L,f,Ly,fy,Lyy,fyy]=feval(name,y); n=length(f); fn=norm(f)/sqrt(n); 
 if it==0, la=-Ly*fy'/(fy*fy'); end
 Hy=Ly+la*fy; Hyn=norm(Hy)/sqrt(p); Hyy=Lyy;
 for i=1:n, Hyy=Hyy+la(i)*fyy([1+p*(i-1):i*p],:); end
 A=[Hyy fy'; fy zeros(n)]; dv=-A\[Hy';f]; y=y+dv([1:p]);
 la=la+dv([p+1:n+p])'; disp([it L fn Hyn])
 if it>mxit, break, end; it=it+1;
end
%
% Finds generalized eigenvalues and eigenvectors of Hessian:
B=diag([ones(1,p) zeros(1,n)]); [X,D]=eig(A,B); ev=diag(D)'; 
ev=ev([1+2*n:n+p]); evec=real(X([1:p],[1+2*n:n+p]));                        

