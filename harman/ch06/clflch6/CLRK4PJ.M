function [T,X,Last]=clrk4pj(f,t0,m,h,x0)
% CALL: [T,X,Last]=clrk4pj(f,t0,m,h,x0) Solve Xdot=f(T,X)
% INPUTS: function f; m points; h step size; t0,x0 initial values
% Output: T abscissa, X solution of differential equation system
%  Last is index of last nonzero value of X(:,2) 
T=zeros(m,1);           % T array m rows (mx1)
X=zeros(m,length(x0));  % X array m rows, 4 columns (mx4)
T(1)=t0;
X(1,:)=x0;
%There are m-1 steps and m points maximum
for I=1:m-1;	
  tI=T(I);
  xI=X(I,:);
  k1=h*feval(f,tI,xI)
  k2=h*feval(f,tI+h/2,xI+k1/2);
  k3=h*feval(f,tI+h/2,xI+k2/2);  	
  k4=h*feval(f,tI+h,xI+k3);
  X(I+1,:)=xI+(k1+2*k2+2*k3+k4)/6;
  T(I+1)=t0 + h*I;
 if (X(I+1,2) < 0), 
 break;  % Quit upon impact
 end
end
Last=(I+1)	% Index of last nonzero value
