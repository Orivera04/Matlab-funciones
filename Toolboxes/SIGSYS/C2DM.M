function [adout,bd,cd,dd] = c2dm(a,b,c,d,Ts,method,w)
%C2DM	Conversion of continuous LTI systems to discrete-time.
%	[Ad,Bd,Cd,Dd] = C2DM(A,B,C,D,Ts,'method') converts the continuous-
%	time state-space system (A,B,C,D) to discrete time using 'method':
%	  'zoh'	        Convert to discrete time assuming a zero order
%			hold on the inputs.
%	  'foh'	        Convert to discrete time assuming a first order 
%			hold on the inputs.
%	  'tustin'      Convert to discrete time using the bilinear 
%			(Tustin) approximation to the derivative.
%	  'prewarp'     Convert to discrete time using the bilinear 
%			(Tustin) approximation with frequency prewarping.
%			Specify the critical frequency with an additional
%			argument, i.e. C2DM(A,B,C,D,Ts,'prewarp',Wc)
%	  'matched'     Convert the SISO system to discrete time using the
%			matched pole-zero method.
%
%	[NUMd,DENd] = C2DM(NUM,DEN,Ts,'method') converts the continuous-
%	time polynomial transfer function G(s) = NUM(s)/DEN(s) to discrete
%	time, G(z) = NUMd(z)/DENd(z), using 'method'.
%
%	See also: C2D.

%	Clay M. Thompson  7-19-90
%	Copyright (c) 1986-94 by The MathWorks, Inc.
%	$Revision: 1.20 $  $Date: 1994/01/25 17:54:20 $

error(nargchk(3,7,nargin));

tf = 0;
% --- Determine which syntax is being used ---
if (nargin==3),		% Transfer function without method, assume 'zoh'
  [num,den] = tfchk(a,b);
  Ts = c;
  method = 'zoh';
  [a,b,c,d] = tf2ss(num,den);
  tf = 1;

elseif (nargin==4),	% Transfer function with method.
  [num,den] = tfchk(a,b);
  Ts = c;
  method = d;
  [a,b,c,d] = tf2ss(num,den);
  tf = 1;

elseif (nargin==5),
  if isstr(d),		% Transfer function with method and prewarp const.
    [num,den] = tfchk(a,b);
    w = Ts;
    Ts = c;
    method = d;
    [a,b,c,d] = tf2ss(num,den);
    tf = 1;
  else			% State space system without method, assume 'zoh'
    error(abcdchk(a,b,c,d));
    method = 'zoh';
  end

else			% State space system with method.
  error(abcdchk(a,b,c,d));

end
[nx,na] = size(a);
[nb,nu] = size(b);

% --- Determine conversion method ---
if method(1)=='z',	% Zero order hold approximation.
  [ad,bd] = c2d(a,b,Ts);
  cd = c; dd = d;

elseif method(1)=='f',	% First order hold (triangle) approximation.
  [n,n] = size(a);
  [ny,nx] = size(c); cc = zeros(ny,nx);
  [nx,nu] = size(b); bb = zeros(nx,nu);
  aa = [a            b            zeros(nx,nu)
        zeros(nu,nx) zeros(nu,nu) eye(nu,nu)/Ts
        zeros(nu,nx) zeros(nu,nu) zeros(nu,nu)];
  pp = expm(aa*Ts);
  ad = pp(1:n,1:n);
  g1 = pp(1:n,n+[1:nu]);
  g2 = pp(1:n,n+nu+[1:nu]);
  bd = g1 + ad*g2 - g2;
  cd = c;
  dd = d + c*g2;

elseif method(1)=='t',	% Tustin approximation.
  I = eye(nx);
  P = inv(I - a.*Ts/2);
  ad = (I + a.*Ts/2)*P;
  bd = P*b;
  cd = Ts*c*P;
  dd = cd*b/2 + d;

elseif method(1)=='p',	% Tustin approximation with frequency prewarping.
  if ~((nargin==5)|(nargin==7)),
    error('The critical frequency must be specified when using ''prewarp''.');
  end
  T = 2*tan(w*Ts/2)/w;		% Prewarp
  I = eye(nx);
  P = inv(I - a.*T/2);
  ad = (I + a.*T/2)*P;
  bd = P*b;
  cd = T*c*P;
  dd = cd*b/2 + d;
  
elseif method(1)=='m',	% Matched pole-zero approximation.
  [ny,nu] = size(d);
  if (ny>1)|(nu>1),
    error('System must be SISO for matched pole-zero method.');
  end
  if tf & ny & nu,
    z = roots(num); p = roots(den);
  else
    [z,p] = ss2zp(a,b,c,d);
  end
  linf = inf;
  z = [z;linf(ones(length(p)-length(z),1),1)]; % Pad zeros with inf's
  pd = exp(p*Ts);
  zd = zeros(length(z),1);
  if ~isempty(z),
    zd(z~=inf) = exp(z(z~=inf)*Ts);
    zd(z==inf) = -1*ones(length(z(z==inf)),1);
  end
  ndx = find(z==inf);
  if ~isempty(ndx), zd(ndx(1))=inf; end	  % Put one infinite zero at infinity.
  [ad,bd,cd,dd] = zp2ss(zd,pd,1);

  % Match D.C. gain or gain at s=1 for singular systems.
  if any(abs(p)<sqrt(eps)), % Match gain at s = 1.
    if tf & nu & ny
      kc = abs(polyval(num,sqrt(-1)))/abs(polyval(den,sqrt(-1)));
    else
      kc = c/(eye(nx)-a)*b + d;
    end
    kd = abs(cd/(exp(sqrt(-1)*Ts)*eye(nx)-ad)*bd + dd);
  else
    if tf & nu & ny,
      kc = num(length(num))/den(length(den));
    else
      kc = -c/a*b + d;
    end
    kd = cd/(eye(nx)-ad)*bd + dd;
  end
  km = sqrt(abs(kc/kd));
  sm = sign(kc/kd);
  bd = bd.*km;
  cd = cd.*km.*sm;
  dd = dd.*km.*km.*sm;

else
  error('Conversion method is unknown.');

end

if nargout==0 & ~isstudent,	% Compare Bode or Singular value plots
  [ny,nc] = size(c);
  if (ny==1)&(nu==1),	% Plot Bode plots
    [magc,phasec,wc] = bode(a,b,c,d);
    [magd,phased,wd] = feval('dbode',ad,bd,cd,dd,Ts,1);
    semilogx(wc,20*log10(magc),'-',wd,20*log10(magd),'--')
    title('C2DM comparison plot')
    xlabel('Frequency (rad/sec)'), ylabel('Gain dB')
  else
    [svc,wc] = feval('sigma',a,b,c,d);
    [svd,wd] = feval('dsigma',ad,bd,cd,dd,Ts);
    semilogx(wc,20*log10(svc),'-',wd,20*log10(svd),'--');
    title('C2DM comparison plot')
    xlabel('Frequency (rad/sec)'), ylabel('Singular Values dB')
  end
  return
end

if tf,		% Convert to TF form for output
  [ad,bd] = ss2tf(ad,bd,cd,dd,1);
end

adout = ad;
