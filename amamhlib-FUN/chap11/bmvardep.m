function [V,M,Theta,Delta,Reactions]= ...
  bmvardep(NoSegs,BeamLength,Force,ExtRamp, ...
  EndCond,IntSup,EIdata,BeamProp)
% [V,M,Theta,Delta,Reactions]=bmvardep ...
% (NoSegs,BeamLength,Force,ExtRamp,EndCond, ...
% IntSup,EIdata,BeamProp)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes the shear, moment, 
% slope and deflection in a variable depth 
% elastic beam having specified end conditions, 
% intermediate supports with given 
% displacements, and general applied loading 
% allowing concentrated loads and linearly 
% varying ramp loads. 
%
% NoSegs     - number of beam divisions for
%              integration
% BeamLength - beam length
% Force      - matrix containing the magnitudes
%              and locations for concentrated
%              loads
% ExtRamp    - matrix containing the end
%              magnitudes and end locations
%              for ramp loads
% EndCond    - matrix containing the type of
%              end conditions, the magnitudes,
%              and the whether left or right
%              end
% IntSup     - matrix containing the location
%              and delta for interior supports
% EIdata     - either EI or depth values
% BeamProp   - either null or beam widths
%
% V          - vector of shear values
% M          - vector of moment values
% Theta      - vector of slope values
% Delta      - vector of deflection values
% Reactions  - reactions at interior supports
%
% User m functions required: 
%    oneovrei, extload, sngf, trapsum
%----------------------------------------------

if nargin < 8, BeamProp=[]; end
% Evaluate function value coordinates and 1/EI
x=linspace(0,BeamLength,NoSegs)'; 
kk=oneovrei(x,EIdata,BeamProp);

% External load contributions to shear and 
% moment interior to span and at right end
[ve,me]=extload(x,Force,ExtRamp);
[vv,mm]=extload(BeamLength,Force,ExtRamp);

% Deflections and position of interior supports
ns=size(IntSup,1);
if ns > 0 
  ysprt=IntSup(:,1); r=IntSup(:,2); 
  snf=sngf(x,r,1);
else 
  ysprt=[]; r=[]; snf=zeros(NoSegs,0); 
end

% Form matrix governing y''(x)
smat=kk(:,ones(1,ns+3)).* ...
     [x,ones(NoSegs,1),snf,me];

% Integrate twice to get slope and deflection 
% matrices
smat=trapsum(0,BeamLength,smat); 
ymat=trapsum(0,BeamLength,smat);

% External load contributions to 
% slope/deflection at the right end
ss=smat(NoSegs,ns+3); yy=ymat(NoSegs,ns+3);

% Equations to solve for left end conditions 
% and internal reactions
ns4=ns+4; j=1:4; a=zeros(ns4,ns4); 
b=zeros(ns4,1); js=1:ns; js4=js+4;

% Account for four independent boundary 
% conditions.  Usually two conditions will be 
% imposed at each end.
for k=1:4
  val=EndCond(k,1); typ=EndCond(k,2); 
  wchend=EndCond(k,3);
  if wchend==1
    b(k)=val; row=zeros(1,4); row(typ)=1; 
    a(k,j)=row;
  else
    if typ==1     % Shear
      a(k,j)=[1,0,0,0]; b(k)=val-vv;
      if ns>0 
        a(k,js4)=sngf(BeamLength,r,0); 
      end
    elseif typ==2 % Moment
      a(k,j)=[BeamLength,1,0,0]; b(k)=val-mm;
      if ns>0 
        a(k,js4)=sngf(BeamLength,r,1); 
      end
    elseif typ==3 % Slope
      a(k,j)=[smat(NoSegs,1:2),1,0]; 
      b(k)=val-ss;
      if ns>0 
        a(k,js4)=smat(NoSegs,3:ns+2); 
      end
    else          % Deflection
      a(k,j)=[ymat(NoSegs,1:2),BeamLength,1]; 
      b(k)=val-yy;
      if ns>0 
        a(k,js4)=ymat(NoSegs,3:ns+2); 
      end
    end
  end
end

% Interpolate to assess how support deflections 
% are affected by end conditions, external 
% loads, and support reactions.
if ns>0
  a(js4,1)=interp1(x,ymat(:,1),r);
  a(js4,2)=interp1(x,ymat(:,2),r);
  a(js4,3)=r; a(js4,4)=ones(ns,1);
  for j=1:ns-1 
    a(j+5:ns+4,j+4)= ...
      interp1(x,ymat(:,j+2),r(j+1:ns));
  end
end
b(js4)=ysprt-interp1(x,ymat(:,ns+3),r);

% Solve for unknown reactions and end conditions
c=a\b; v0=c(1); m0=c(2); s0=c(3); y0=c(4); 
Reactions=c(5:ns+4);

% Compute the shear, moment, slope, deflection
% for all x
if ns > 0
  V=v0+ve+sngf(x,r,0)*Reactions;
  M=m0+v0*x+me+sngf(x,r,1)*Reactions;
  Theta=s0+smat(:,ns+3)+smat(:,1:ns+2)* ...
        [v0;m0;Reactions];
  Delta=y0+s0*x+ymat(:,ns+3)+ ...
        ymat(:,1:ns+2)*[v0;m0;Reactions];
else
  Reactions=[]; V=v0+ve; M=m0+v0*x+me;
  Theta=s0+smat(:,ns+3)+smat(:,1:2)*[v0;m0];
  Delta=y0+s0*x+ymat(:,ns+3)+ ...
        ymat(:,1:2)*[v0;m0];
end