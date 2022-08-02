function [V,M,EITheta,EIDelta]=extload ...
         (x,Force,ExtRamp)
% [V,M,EITheta,EIDelta]=extload ...
%                       (x,Force,ExtRamp)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes the shear, moment, 
% slope and deflection in a uniform depth Euler 
% beam which is loaded by a series of 
% concentrated loads and ramp loads. The values 
% of shear, moment, slope and deflection all 
% equal zero when x=0.
%
% x       - location along beam
% Force   - concentrated force matrix
% ExtRamp - distributed load matrix
%
% V       - shear
% M       - moment
% EITheta - slope
% EIDelta - deflection
%
% User m functions required: sngf
%----------------------------------------------

nf=size(Force,1); nr=size(ExtRamp,1); 
nx=length(x); V=zeros(nx,1); M=V; 
EITheta=V; EIDelta=V;
% Concentrated load contributions
if nf > 0
  F=Force(:,1); f=Force(:,2); V=V+sngf(x,f,0)*F; 
  M=M+sngf(x,f,1)*F;
  if nargout > 2
    EITheta=EITheta+sngf(x,f,2)*(F/2);
    EIDelta=EIDelta+sngf(x,f,3)*(F/6);
  end
end
% Ramp load contributions
if nr > 0
  P=ExtRamp(:,1); Q=ExtRamp(:,2); 
  p=ExtRamp(:,3); q=ExtRamp(:,4);
  S=(Q-P)./(q-p); sp2=sngf(x,p,2); 
  sq2=sngf(x,q,2); sp3=sngf(x,p,3); 
  sq3=sngf(x,q,3); sp4=sngf(x,p,4); 
  sq4=sngf(x,q,4);
  V=V+sngf(x,p,1)*P-sngf(x,q,1)* ... % Shear
    Q+(sp2-sq2)*(S/2); 
  M=M+sp2*(P/2)-sq2*(Q/2)+ ...       % Moment
    (sp3-sq3)*(S/6);
  if nargout > 2
    EITheta=EITheta+sp3*(P/6)- ...  % EI*Theta
            sq3*(Q/6)+(sp4-sq4)*(S/24);
    EIDelta=EIDelta+sp4*(P/24)- ... % EI*Delta
            sq4*(Q/24)+(sngf(x,p,5)- ...
            sngf(x,q,5))*(S/120); 
  end
end