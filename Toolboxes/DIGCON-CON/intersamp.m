function [t,x]=intersamp(A,b,x_0,T_1,N,u)
%INTERSAMP Intersample response of a  continuous-time system.
%         [t,x] = intersamp(A,b,x_0,T_1,N,u) calculates samples
%         of the state vector of a continuous-time system driven
%         by a given piecewise-constant input.  The samples are 
%         calculated every T_1 seconds, while the input to the plant 
%         is held constant for N T_1 seconds.
%                                                         .
% 	A and b are the state-space model for the plant:  x = Ax + bu with
% 	initial state vector x_0.  T_1 is the time interval at which 
%	state-vector samples are to be calculated. The vector u contains 
%	input samples which are held constant for N T_1 seconds.  The output 
%	vector t is the time axis for the computed state vector samples.

%       R.J. Vaccaro  4/94


[phi,gamma]=zohe(A,b,T_1);  % Calculate ZOH equivalent at sampling interval T_1
k_1=length(u(1,:));
kf= k_1*N;
n=length(b(:,1));
x=zeros(n,kf);
x(:,1)=x_0;
for k=1:k_1
  for j=1:N                        % Hold input constant at u(k) for N samples
    x(:,(k-1)*N+j+1) = phi*x(:,(k-1)*N+j) + gamma*u(:,k);
  end
end
t=[0:kf]*T_1;
return

