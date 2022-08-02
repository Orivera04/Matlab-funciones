function [T,Y]=clrk4(f,a,b,m,y0)
% CALL: [T,Y]=clrk4(f,a,b,m,y0) solves Ydot=f(T,Y) on t=[a,b].
% INPUTS: f M-file defining input function; interval a,b; 
%         m points in interval; y0 initial value
% OUTPUTS: T abscissa, Y solution by 4th order Runge-Kutta method
h=(b-a)/(m-1); 	% Step size
T=zeros(m,1);   % Column vector of time points
Y=zeros(m,1);   % Column vector of solution points
T(1)=a;
Y(1)=y0;
for I=1:m-1;      % There are m-1 steps and m points  	
 tI=T(I);         %  - step through m-1 intervals
 yI=Y(I);
 k1=h*feval(f,tI,yI);          % Runge-Kutta coefficients
 k2=h*feval(f,tI+h/2,yI+k1/2);
 k3=h*feval(f,tI+h/2,yI+k2/2);  	
 k4=h*feval(f,tI+h,yI+k3);
 Y(I+1)=yI+(k1+2*k2+2*k3+k4)/6;
 T(I+1)=a + h*I;  % Next time step
end
%
% Version 5 Changed T,Y to column vectors
%

