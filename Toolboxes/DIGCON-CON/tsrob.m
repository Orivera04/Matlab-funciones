%TSROB	Script to simulate a reduced-order-based digital tracking system.
%	Such systems can be be designed using the functions DTS and ROO.
%
% INPUTS:
%
% phi,gamma,c   ZOH equivalent plant model.
% phia,gammaa   State-space model for the additional dynamics.
% Cm            Measurement matrix for the reduced-order observer.
% f             feedthrough from disturbance to plant output.
% fm            feedthrough from disturbance to measurements.
% e             Input vector (matrix for multivariable) for disturbances.
% g             Feedforward gain (matrix for multivariable).  Can only be
%               used if number of inputs equals number of outputs.
% x0            Initial state of the plant.
% T             Sampling interval.
% L1,L2         Partition of feedback gains calculated for the design system.
% F,G,H,K,P     Reduced-order observer matrices.
% ftime         Simulate from 0 to ftime seconds.
% ref,dist      Matrices containing reference inputs and disturbances.
%               These  signals can be generated using the SIGGEN function.
%
% OUTPUTS: 
%
% y         Matrix of plant outputs. 
% x         Matrix of state vectors, column 1 is x0.
% u         Matrix of inputs to the plant.
% t1        Time axis vector for plotting.  Use TSOBP to plot results.
%
% If any of the following variables do not exist in the workspace, this script
% sets them equal to zero: e, f, fm, g, dist
%
%	R.J. Vaccaro 10/93,11/98

[j_,inp_]=size(gamma);
M_=length(c(:,1));
[MM_,NN_]=size(Cm);
if exist('e')~=1,e=zeros(j_,inp_);end
if exist('f')~=1,f=zeros(M_,inp_);end
if exist('g')~=1,g=zeros(inp_,inp_);end
if exist('fm')~=1,fm=zeros(MM_,inp_);end
if exist('dist')~=1,dist=0*ref;end
N_=length(x0);
kf_=ceil(ftime/T);
t1=T*[0:kf_-1];
m_=N_-length(F(:,1));
Lb_=L1/P;
clear xa x u  z x2hat ym y xhat;
x(:,1)=x0;
xa(:,1)=zeros(max(size(gammaa)),1);
ym(:,1)=Cm*x0+fm*dist(:,1);
y(:,1)=c*x0+f*dist(:,1);
z(:,1)=P(m_+1:N_,:)*(c\y(:,1))-K*ym(:,1);
x2hat(:,1)=z(:,1)+K*ym(:,1);
xhat(:,1)=P\[ym(:,1);x2hat(:,1)];
u(:,1)=-L1*xhat(:,1)+L2*xa(:,1);
if inp_==M_
  u(:,1)=u(:,1)+g*ref(:,1);
end
for k_=1:kf_-1
   x(:,k_+1)=phi*x(:,k_)+gamma*u(:,k_)+e*dist(:,k_);
   z(:,k_+1)=F*z(:,k_)+G*ym(:,k_)+H*u(:,k_);	
   xa(:,k_+1)=phia*xa(:,k_)+gammaa*(ref(:,k_)-y(:,k_));
   ym(:,k_+1)=Cm*x(:,k_+1)+fm*dist(:,k_+1);
   y(:,k_+1)=c*x(:,k_+1)+f*dist(:,k_+1);
   x2hat(:,k_+1)=z(:,k_+1)+K*ym(:,k_+1);
   xhat(:,k_+1)=P\[ym(:,k_+1);x2hat(:,k_+1)];
   u(:,k_+1)=-L1*xhat(:,k_+1)+L2*xa(:,k_+1);
if inp_ ==M_
   u(:,k_+1)=u(:,k_+1)+g*ref(:,k_);
end
end
fprintf('TSROB simulation completed.  Use TSOBP to plot the results.\n')

clear j_ inp_ kkk_ Lb_ M_ n_ N_ k_ kf_ MM_ NN_

%___________________________ END OF TSROB.M _______________________________
