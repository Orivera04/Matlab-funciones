function vdb        
% Example: vdb
% ~~~~~~~~~~~~
%
% This program calculates the shear, moment, 
% slope, and deflection of a variable depth 
% indeterminate beam subjected to complex 
% loading and general end conditions. The 
% input data are defined in the program 
% statements below.
%
% User m functions required:
%   bmvardep, extload, lintrp, oneovrei, 
%   sngf, trapsum

clear all; Problem=1;
if Problem == 1
  Title=['Problem from Arbabi and Li'];
  Printout=10;  % Output frequency
  BeamLength=3; % Beam length
  NoSegs=301;   % # of beam divisions for 
                % integration
  % External concentrated loads and location
  ExtForce= [-1]; ExtForceX=[.5];
  % External ramp loads and range
  %        q1  q2  x1  x2
  ExtRamp=[-1  -1   1   2];
  % Interior supports: initial displacement 
  % and location
  IntSupX=    [1; 2]; IntSupDelta=[0; 0];
  % End (left and right) conditions
  EndCondVal= [0; 0; 0; 0];   % magnitude
  % 1=shear,2=moment,3=slope,4=delta
  EndCondFunc=[3; 4; 3; 4];   
  % 1=left end,2=right end
  EndCondEnd= [1; 1; 2; 2];   
  % EI or beam depth specification
  EIorDepth=1;  % 1=EI values specified 
                % 2=depth values specified
  if EIorDepth == 1
    % Discretize the parabolic haunch for the 
    % three spans
    Width=1; E=1; a=0.5^2; Npts=100;
    h1=0.5; k1=1; x1=linspace(0,1,Npts);
    h2=1.5; k2=1; x2=linspace(1,2,Npts);
    h3=2.5; k3=1; x3=linspace(2,3,Npts);
    y1=(x1-h1).^2/a+k1; y2=(x2-h2).^2/a+k2;
    y3=(x3-h3).^2/a+k3;
    EIx=[x1 x2 x3]'; h=[y1 y2 y3]';
    EIvalue=E*Width/12*h.^3;
    mn=min(EIvalue); EIvalue=EIvalue./mn;
  else
    % Beam width and Young's modulus
    BeamWidth=[]; BeamE=[]; Depth=[]; DepthX=[];
  end
elseif Problem == 2
  Title=['From Timoshenko and Young,', ...
         ' p 434, haunch beam'];
  Printout=12; NoSegs=144*4+1; BeamLength=144; 
  ExtForce=[]; ExtForceX=[]; 
  ExtRamp=[-1 -1 0 108];
  IntSupX=[36; 108]; IntSupDelta=[0; 0];
  EndCondVal=[0; 0; 0; 0]; 
  EndCondFunc=[2; 4; 2; 4];
  EndCondEnd= [1; 1; 2; 2]; EIorDepth=2;  
  if EIorDepth == 1
    EIvalue=[]; EIx=[];
  else
    BeamWidth=[1]; BeamE=[1];
    % Discretize the parabolic sections
    a=36^2/5; k=2.5; h1=0; h2=72; h3=144; 
    N1=36; N2=72; N3=36;
    x1=linspace(  0, 36,N1); y1=(x1-h1).^2/a+k;
    x2=linspace( 36,108,N2); y2=(x2-h2).^2/a+k;
    x3=linspace(108,144,N3); y3=(x3-h3).^2/a+k;
    Depth=[y1 y2 y3]'; DepthX=[x1 x2 x3]';
    % Comparison values
    I=BeamWidth*Depth.^3/12; Imin=min(I); L1=36;
    k1=BeamE*Imin/L1; k2=k1/2; k3=k1;
    t0=10.46/k1; t1=15.33/k1; t2=22.24/k1; 
    t3=27.95/k1;
    fprintf('\n\nValues from reference');
    fprintf('\n  Theta (x=  0): %12.4e',t0);
    fprintf('\n  Theta (x= 36): %12.4e',t1);
    fprintf('\n  Theta (x=108): %12.4e',t2);
    fprintf('\n  Theta (x=144): %12.4e\n',t3);
  end
end

% Load input parameters into matrices
Force=[ExtForce,ExtForceX]; 
NoExtForce=length(ExtForce);
[NoExtRamp,ncol]=size(ExtRamp); 
IntSup=[IntSupDelta,IntSupX]; 
NoIntSup=length(IntSupX); 
EndCond=[EndCondVal,EndCondFunc,EndCondEnd];
if EIorDepth == 1
  BeamProp=[]; NoEIorDepths=length(EIx);
  EIdata=[EIvalue EIx];
else
  BeamProp=[BeamWidth BeamE]; 
  NoEIorDepths=length(DepthX);
  EIdata=[Depth DepthX];
end

% more on

% Output input data
label1=['shear     ';'moment    '; ...
        'slope     ';'deflection'];
label2=['left   ';'right  '];
fprintf('\n\nAnalysis of a Variable Depth ');
fprintf('Elastic Beam');
fprintf('\n--------------------------------');
fprintf('---------');
fprintf('\n\n');
disp(['Title: ' Title]);
fprintf...
  ('\nBeam Length:                    %g', ...
  BeamLength);
fprintf...
  ('\nNumber of integration segments: %g', ...
  NoSegs);
fprintf...
  ('\nPrint frequency for results:    %g', ...
  Printout);
fprintf('\n\nInterior Supports: (%g)', ...
  NoIntSup);
if NoIntSup > 0
  fprintf('\n  |   #   X-location   Deflection');
  fprintf('\n  | --- ------------ ------------');
  for i=1:NoIntSup
    fprintf('\n  |%4.0f %12.4e %12.4e', ...
            i,IntSup(i,2),IntSup(i,1)); 
  end
end
fprintf('\n\nConcentrated Forces: (%g)', ...
  NoExtForce);
if NoExtForce > 0 
  fprintf('\n  |   #   X-location        Force');
  fprintf('\n  | --- ------------ ------------');
  for i=1:NoExtForce
    fprintf('\n  |%4.0f %12.4e %12.4e', ...
            i,Force(i,2),Force(i,1)); 
  end
end
fprintf('\n\nRamp loads: (%g)', NoExtRamp);
if NoExtRamp > 0
  fprintf('\n  |   #      X-start         Load');
  fprintf('        X-end         Load');
  fprintf('\n  | --- ------------ ------------');
  fprintf(' ------------ ------------');
  for i=1:NoExtRamp
    fprintf('\n  |%4.0f %12.4e %12.4e ', ...
            i,ExtRamp(i,3),ExtRamp(i,1));
    fprintf('%12.4e %12.4e', ...
            ExtRamp(i,4),ExtRamp(i,2)); 
  end
end
fprintf('\n\nEnd conditions:');
fprintf('\n  | End    Function           Value');
fprintf('\n  ');
fprintf('| ------ ----------  ------------\n');
for i=1:4
  j=EndCond(i,3); k=EndCond(i,2);
  strg=sprintf('  %12.4e',EndCond(i,1));
  disp(['  | ' label2(j,:) label1(k,:) strg]);
end
if EIorDepth == 1
  fprintf('\nEI values are specified');
  fprintf('\n  |   #      X-start     EI-value') 
  fprintf('\n  | --- ------------ ------------');
  for i=1:NoEIorDepths
    fprintf('\n  |%4.0f %12.4e %12.4e', ...
            i,EIdata(i,2),EIdata(i,1));  
  end
else 
  fprintf('\nDepth values are specified for ');
  fprintf('rectangular cross section');
  fprintf('\n  | Beam width:      %12.4e', ...
          BeamProp(1));
  fprintf('\n  | Young''s modulus: %12.4e', ...
          BeamProp(2));
  fprintf('\n  |');
  fprintf('\n  |   #      X-start        Depth') 
  fprintf('\n  | --- ------------ ------------');
  for i=1:NoEIorDepths
    fprintf('\n  |%4.0f %12.4e %12.4e', ...
            i,EIdata(i,2),EIdata(i,1));  
  end
end
disp(' ');
  
% Begin analysis
x=linspace(0,BeamLength,NoSegs)'; t=clock;
[V,M,Theta,Delta,Reactions]= ...
  bmvardep(NoSegs,BeamLength,Force,ExtRamp, ...
           EndCond,IntSup,EIdata,BeamProp);
t=etime(clock,t); 

% Output results
disp(' ');
disp(['Solution time was ',num2str(t),' secs.']);
if NoIntSup > 0
  fprintf('\nReactions at Internal Supports:');
  fprintf('\n  |   X-location     Reaction');
  fprintf('\n  | ------------ ------------');
  for i=1:NoIntSup
    fprintf('\n  | %12.8g %12.4e', ...
            IntSup(i,2),Reactions(i));
  end
end
fprintf('\n\nTable of Results:');
fprintf('\n  |  X-location        Shear');
fprintf('       Moment');
fprintf('        Theta        Delta');
fprintf('\n  | ----------- ------------ ');
fprintf('------------');
fprintf(' ------------ ------------');
if Printout > 0
  for i=1:Printout:NoSegs
    fprintf('\n  |%12.4g %12.4e %12.4e', ...
            x(i),V(i),M(i));
    fprintf(' %12.4e %12.4e',Theta(i),Delta(i));
  end
  disp(' ');
else
  i=1; j=NoSegs;
  fprintf('\n  |%12.4g %12.4e %12.4e', ...
          x(i),V(i),M(i));
  fprintf(' %12.4e %12.4e',Theta(i),Delta(i));
  fprintf('\n  |%12.8g %12.4e %12.4e', ...
          x(j),V(j),M(j));
  fprintf(' %12.4e %12.4e',Theta(j),Delta(j));
end
fprintf('\n\n');
subplot(2,2,1); 
  plot(x,V,'k-'); grid; xlabel('x axis');
  ylabel('Shear'); title('Shear Diagram');
subplot(2,2,2); 
  plot(x,M,'k-'); grid; xlabel('x axis');
  ylabel('Moment'); title('Moment Diagram')
subplot(2,2,3); 
  plot(x,Theta,'k-'); grid; xlabel('x axis');
  ylabel('Slope'); title('Slope Curve');
subplot(2,2,4); 
  plot(x,Delta,'k-'); grid; xlabel('y axis');
  ylabel('Deflection'); 
  title('Deflection Curve'); subplot
drawnow; subplot ; figure(gcf)
%print -deps vdb

% more off

%=============================================

function [V,M,Theta,Delta,Reactions]= ...
  bmvardep(NoSegs,BeamLength,Force,ExtRamp, ...
  EndCond,IntSup,EIdata,BeamProp)
% [V,M,Theta,Delta,Reactions]=bmvardep ...
% (NoSegs,BeamLength,Force,ExtRamp,EndCond, ...
% IntSup,EIdata,BeamProp)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes the shear, moment, 
% slope, and deflection in a variable depth 
% elastic beam having specified end conditions, 
% intermediate supports with given 
% displacements, and general applied loading, 
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
%              and whether values are for the
%              left or right ends
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

%=============================================

function [V,M,EITheta,EIDelta]=extload ...
         (x,Force,ExtRamp)
% [V,M,EITheta,EIDelta]=extload ...
%                       (x,Force,ExtRamp)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes the shear, moment, 
% slope, and deflection in a uniform depth  
% Euler beam which is loaded by a series of 
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

%=============================================

function val=oneovrei(x,EIdata,BeamProp)
% [val]=oneovrei(x,EIdata,BeamProp) 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes 1/EI by piecewise 
% linear interpolation through a set of data 
% values.
%
% x        - location along beam
% EIdata   - EI or depth values
% BeamProp - null or width values
%
% val      - computed value for 1/EI
%
% User m functions required: none
%----------------------------------------------

if size(EIdata,1) < 2  % uniform depth case
  v=EIdata(1,1); 
  EIdata=[v,min(x);v,max(x)]; 
end
if ( nargin > 2 ) & ( sum(size(BeamProp)) > 0)
  % Compute properties assuming the cross 
  % section is rectangular and EIdata(:,1) 
  % contains depth values
  width=BeamProp(1); E=BeamProp(2);
  EIdata(:,1)=E*width/12*EIdata(:,1).^3; 
end
val=1./lintrp(EIdata(:,2),EIdata(:,1),x);

%=============================================

function y=sngf(x,x0,n)
% y=sngf(x,x0,n) 
% ~~~~~~~~~~~~~~
%
% This function computes the singularity
% function defined by 
%    y=<x-x0>^n for n=0,1,2,...
%
% User m functions required: none
%----------------------------------------------

if nargin < 3, n=0; end
x=x(:); nx=length(x); x0=x0(:)'; n0=length(x0); 
x=x(:,ones(1,n0)); x0=x0(ones(nx,1),:); d=x-x0; 
s=(d>=zeros(size(d))); v=d.*s;
if n==0 
  y=s;
else 
  y=v; 
  for j=1:n-1; y=y.*v; end
end

%=============================================

function v=trapsum(a,b,y,n)
%
% v=trapsum(a,b,y,n)
% ~~~~~~~~~~~~~~~~~~
%
% This function evaluates:
%
%   integral(a=>x, y(x)*dx) for a<=x<=b
%
% by the trapezoidal rule (which assumes linear
% function variation between succesive function
% values).
%
% a,b - limits of integration
% y   - integrand that can be a vector-valued
%       function returning a matrix such that
%       function values vary from row to row.
%       It can also be input as a matrix with
%       the row size being the number of
%       function values and the column size
%       being the number of components in the
%       vector function.
% n   - the number of function values used to
%       perform the integration.  When y is a
%       matrix then n is computed as the number
%       of rows in matrix y.
%
% v   - integral value
%
% User m functions called:  none
%----------------------------------------------

if isstr(y)
  % y is an externally defined function
  x=linspace(a,b,n)'; h=x(2)-x(1);
  Y=feval(y,x); % Function values must vary in 
                % row order rather than column 
                % order or computed results 
                % will be wrong.
  m=size(Y,2);
else
  % y is column vector or a matrix
  Y=y; [n,m]=size(Y); h=(b-a)/(n-1);
end
v=[zeros(1,m); ...
  h/2*cumsum(Y(1:n-1,:)+Y(2:n,:))];

%=============================================

% function y=lintrp(xd,yd,x)
% See Appendix B
