%ETSOB1	This script is identical to ETSOB except that the model used to
%	simulate the plant is different from that used in the controller.
%
% INPUTS:
%
% phi,gamma,c   ZOH equivalent plant model used to design the controller.
% phip,gammap,cp ZOH equivalent of actual plant
% phia,gammaa   State-space model for the additional dynamics
% f             feedthrough from disturbance to output(s).
% e             Input vector (matrix for multivariable) for disturbances.
% g             Feedforward gain (vector of gains for multivariable plant).
%               Can only be used if number of inputs equals number of outputs.
% x0            Initial state of the Plant.
% T             Sampling interval.
% L1,L2         Partition of feedback gains calculated for the design system.
% K             Observer gains.
% ftime         Simulate from 0 to ftime seconds.
% ref, dist     Matrices which specify reference and disturbance signals.
%               These signals can be generated with the SIGGEN function.
%
% OUTPUTS: 
%
% y         Matrix of plant outputs 
% x         Matrix of state vectors, column 1 is x0.
% xhat      Matrix of estimated state vectors.
% u         Matrix of inputs to the plant.
% t1        Time axis vector for plotting.  Use TSOBP to plot the results.    
%
% If any of the following variables do not exist in the workspace, this script
% sets them equal to zero: e, f, g, dist

%	R.J. Vaccaro 12/98

[j_,inp_]=size(gammap);
if exist('e')~=1,e=zeros(j,1);end
if exist('f')~=1,f=zeros(max(size(c),1));end
if exist('g')~=1,g=zeros(inp,inp);end
if exist('dist')~=1,dist=0*ref;end
M_=length(cp(:,1));
N_=length(x0);
kf_=ceil(ftime/T);
t1=T*[0:kf_-1];
clear xa x u y xhat;
x(:,1)=x0;
xa(:,1)=zeros(max(size(gammaa)),1);
y(:,1)=cp*x0+f*dist(:,1);
xhat(:,1)=c\(y(:,1)-ref(:,1));
u(:,1)=-L1*xhat(:,1)+L2*xa(:,1);
if inp_==M_
  u(:,1)=u(:,1)+g*ref(:,1);
end
for k_=1:kf_-1
   x(:,k_+1)=phip*x(:,k_)+gammap*u(:,k_)+e*dist(:,k_);
   xa(:,k_+1)=phia*xa(:,k_)+gammaa*(ref(:,k_)-y(:,k_));
   y(:,k_+1)=cp*x(:,k_+1)+f*dist(:,k_+1);
   xhat(:,k_+1)=(phi-K*c)*xhat(:,k_)+gamma*u(:,k_)+K*(y(:,k_)-ref(:,k_));
   u(:,k_+1)=-L1*xhat(:,k_+1)+L2*xa(:,k_+1);
if inp_==M_
   u(:,k_+1)=u(:,k_+1)+g*ref(:,k_);
end
end
fprintf('ETSOB1 simulation finished.  Use TSOBP to plot results.\n')
clear j_ inp_ M_ N_ k_ kf_
%___________________________ END OF ETSOB1.M _______________________________

