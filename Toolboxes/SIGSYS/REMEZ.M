function [h,ha] = remez(nfilt, ff, aa, wtx, ftype)
%REMEZ	Parks-McClellan optimal equiripple FIR filter design.
%	B=REMEZ(N,F,M) returns a length N+1 linear phase (real, symmetric
%	coefficients) FIR filter which has the best approximation to the 
%	desired frequency response described by F and M in the minimax
%	sense. F is a vector of frequency band edges in pairs, in ascending 
%	order between 0 and 1. 1 corresponds to the Nyquist frequency or half
%	the sampling frequency. M is a real vector the same size as F 
%	which specifies the desired magnitude of the frequency response of the
%	resultant filter B. The desired response is the line connecting the
%	points (F(k),M(k)) and (F(k+1),M(k+1)) for odd k; REMEZ treats the 
%	bands between F(k+1) and F(k+2) for odd k as "transition bands" or 
%	"don't care" regions. Thus the desired magnitude is piecewise linear
%	with transition bands. The maximum error is minimized.
%
%	B=REMEZ(N,F,M,W) uses the weights in W to weight the error. W has one
%	entry per band (so it is half the length of F and M) which tells
%	REMEZ how much emphasis to put on minimizing the error in each band 
%	relative to the other bands.
%	
%	B=REMEZ(N,F,M,'Hilbert') and B=REMEZ(N,F,M,W,'Hilbert') design filters
%	that have odd symmetry, that is, B(k) = -B(N+2-k) for k = 1, ..., N+1. 
%	A special case is a Hilbert transformer which has an approx. magnitude
%	of 1 across the entire band, e.g. B=REMEZ(30,[.1 .9],[1 1],'Hilbert'). 
%
%	B=REMEZ(N,F,M,'differentiator') and B=REMEZ(N,F,M,W,'differentiator')
%	also design filters with odd symmetry, but with a special weighting
%	scheme for non-zero magnitude bands. The weight is assumed to be equal 
%	to the inverse of frequency times the weight W. Thus the filter has a 
%	much better fit at low frequency than at high frequency. This designs
%	FIR differentiators.
%
%	See also FIRLS, FIR1, FIR2, BUTTER, CHEBY1, CHEBY2, ELLIP, FREQZ and 
%	FILTER.

% Old help:
%
%REMEZ	Parks-McClellan optimal equiripple FIR filter design.
%       B = REMEZ(N,F,M) designs an N'th order FIR digital filter,
%	with the frequency response specified by vectors F and M, 
%	and returns the	filter coefficients in length N+1 vector B.
%	Vectors F and M specify the frequency and magnitude
%	breakpoints for the filter such that PLOT(F,M) would show a
%	plot of the desired frequency response. The elements of M must
%	appear in equal-valued pairs.  The frequencies in F must be
%	between 0.0 < F < 1.0, with 1.0 corresponding to half the
%	sample rate. They must be in increasing order, start with 0.0,
%	and end with 1.0.
%       B = REMEZ(N,F,M,W) uses vector W to specify weighting in each
%	of the pass or stop bands in vectors F and M.
%	B = REMEZ(N,F,M,FTYPE) or B = REMEZ(N,F,M,W,FTYPE), where FTYPE
%	is the string 'Hilbert' or 'differentiator', designs Hilbert
%	transformers or differentiators, respectively.  For the Hilbert
%	case, the lowest frequency should not be 0.
%	
%	See also FIR1, FIR2, BUTTER, CHEBY1, CHEBY2, YULEWALK, FREQZ
%	and FILTER.

%	Author(s): L. Shure, 3-27-87
%		   L. Shure, 6-8-88, revised
%		   T. Krauss, 3-17-93, fixed hilbert bug in m-file version
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.14 $  $Date: 1994/01/25 17:59:43 $


%	References:
%	  [1] "Programs for Digital Signal Processing", IEEE Press
%	       John Wiley & Sons, 1979, pg. 5.1-1.
%	  [2] "Selected Papers in Digital Signal Processing, II",
%	       IEEE Press, 1976, pg. 97.

%	Note: Frequency transitions much faster than 0.1 can cause large
%	amounts of ripple in the response. 

lgrid = 16;	% Grid density (should be at least 16)
nfilt = nfilt + 1;

if (nargin < 3 | nargin > 5)
	error('Incorrect number of input arguments.')
end
if nfilt < 4
	error('Filter order must be 3 or more.')
end
if nargin == 4
	if isstr(wtx)
		ftype = wtx; 
		wtx = ones(fix((1+max(size(aa)))/2),1);
	else
		ftype = 'f';
	end
end
if nargin < 4
	ftype = 'f';
	wtx = ones(fix((1+max(size(aa)))/2),1);
end
if rem(length(ff),2)
	error('Frequencies must be specified in bands.');
end
if any((ff < 0) | (ff > 1))
	error('Frequencies must lie between 0 and 1.')
end
daa = diff(aa);
%if abs(any(daa(1:2:length(daa)))) > eps
%	error('Bands must be specified with constant magnitudes.')
	%nomex=1;   % can't call mex-file version
%	nomex=0;
%else
%	nomex=0;
%end

clear daa;
		
if length(ftype)==0, ftype = 'f'; end

if ftype(1)=='m'
	nomex=1;  if length(ftype)==1, ftype = 'f'; else ftype(1)=[]; end
else
	nomex=0;
end
if ftype(1) == 'h' | ftype(1) == 'H'
	jtype = 3;	% Hilbert transformer
elseif ftype(1) == 'd' | ftype(1) == 'D'
	jtype = 2;	% Differentiator
else
	jtype = 1;	% Regular filter
end
if nargin > 3 & (max(size(wtx)) ~= fix((1+max(size(aa)))/2))
	error('There should be one weight per band.')
end
ha = 1;

ff = ff(:)';
aa = aa(:)';
wtx = wtx(:)';
[mf,nf] = size(ff);
[ma,na] = size(aa);
if na ~= nf
	error('Frequency and amplitude vectors must be the same length.')
end

nbands = nf/2;
jb = 2*nbands;
if jb ~= nf
	error('The number of frequency points must be even.')
end

% The following constraint is not necessary:
% if jtype ~= 3 & (abs(ff(1)) > eps | abs(ff(jb) - 1) > eps)
%	error('The first frequency must be 0 and the last 1.')
% end

% Not necessary: allow filter designer to shoot him/herself in the foot
% if jtype == 3 & ff(1) == 0
%	error('The first frequency for a Hilbert transformer must not be 0.')
% end

% interpolate breakpoints onto large grid
edge = ff;
fx = aa(2:2:jb);

df = diff(ff);
if (any(df < 0))
	error('Frequencies must be non-decreasing.')
end

% Prevent discontinuities in desired function
for k=2:2:jb-2
    if edge(k) == edge(k+1)
        error('Adjacent bands not allowed.')
    end
end

edge = edge/2;
cmptr = computer;
% if (exist('remezf') == 3) & (nfilt < 128) & ~nomex
if (exist('remezf') == 3) & ~nomex
	% Use MEX-file
	% disp('MEX-file version')
	%h = eval('remezf(nfilt,edge,fx,wtx,jtype)');
	h = eval('remezf(nfilt,edge,aa,wtx,jtype)');  % for new remezf - TPK
	h = [h; sign(.5-(jtype ~= 1))*h(max(size(h))-rem(nfilt,2):-1:1)].';
	h = h(max(size(h)):-1:1);
% put in this code since the mex-file sometimes returns nans - in which
% case we want to use the m-code which produces correct answers
	if ~any(isnan(h))
		return
	else
		h = [];
	end
end
% disp('M-file version')
neg = 1 - (jtype == 1);   % neg == 1 ==> antisymmetric imp resp,
                          % neg == 0 ==> symmetric imp resp
nodd = rem(nfilt,2);      % nodd == 1 ==> filter length is odd
                          % nodd == 0 ==> filter length is even
nfcns = fix(nfilt/2);
if nodd == 1 & neg == 0
	nfcns = nfcns + 1;
end
grid(1) = edge(1);
delf = .5/(lgrid*nfcns);
if neg ~= 0 & edge(1) < delf
	grid(1) = delf;
end
j = 1;
l = 1;
while (l+1)/2 <= nbands
	fup = edge(l+1);
	grid = [grid (grid(j)+delf):delf:(fup+delf)];
	jend = max(size(grid));
	grid(jend-1) = fup;
	sel = j:jend-1;
%	if (jtype==2),   % "differentiator"
%		des(sel) = fx(lband)*((grid(sel)-1)*(jtype == 2) + 1);
%	else
%       		slope=(aa(l+1)-aa(l))/(edge(l+1)-edge(l));
%		des(sel) = polyval([slope aa(l)-slope*edge(l)],grid(sel));
%	end
	% desired magnitude is line connecting aa(l) to aa(l+1)
	if edge(l+1)~=edge(l)   % 
	     slope=(aa(l+1)-aa(l))/(edge(l+1)-edge(l));
	     des(sel) = polyval([slope aa(l)-slope*edge(l)],grid(sel));
        else   % zero bandwidth band 
             des(sel) = (aa(l)+aa(l+1))/2;  
        end
      	wt(sel) = wtx((l+1)/2)./ ...
	       (1 +((jtype == 2) & aa(l+1) >= .0001)*(grid(sel) - 1));
	j = jend;
	l = l + 2;
	if (l+1)/2 <= nbands
		grid(j) = edge(l);
	end
end
ngrid = j - 1;
if neg == nodd & grid(ngrid) > .5-delf
	ngrid = ngrid - 1;
end

%clf reset, plot(grid(1:ngrid),des(1:ngrid),'o',grid(1:ngrid),wt(1:ngrid),'r*'); 

if neg <= 0
	if nodd ~= 1
		des = des(1:ngrid)./cos(pi*grid(1:ngrid));
		wt = wt(1:ngrid).*cos(pi*grid(1:ngrid));
	end
elseif nodd ~= 1
	des = des(1:ngrid)./sin(pi*grid(1:ngrid));
	wt = wt(1:ngrid).*sin(pi*grid(1:ngrid));
else
	des = des(1:ngrid)./sin(2*pi*grid(1:ngrid));
	wt = wt(1:ngrid).*sin(2*pi*grid(1:ngrid));
end
temp = (ngrid-1)/nfcns;
j=1:nfcns;
iext = fix([temp*(j-1)+1 ngrid])';
nm1 = nfcns - 1;
nz = nfcns + 1;

% Remez exchange loop
comp = [];
itrmax = 25;
devl = -1;
nzz = nz + 1;
niter = 0;
jchnge = 1;
jet = fix((nfcns - 1)/15) + 1;
while jchnge > 0
   iext(nzz) = ngrid + 1;
   niter = niter + 1;
   if niter > itrmax
      break;
   end
   l = iext(1:nz)';
   x = cos(2*pi*grid(l));
   for nn = 1:nz
	ad(nn) = remezdd(nn, nz, jet, x);
   end
   add = ones(size(ad));
   add(2:2:nz) = -add(2:2:nz);
   dnum = ad*des(l)';
   dden = add*(ad./wt(l))';
   dev = dnum/dden;
   nu = 1;
   if dev > 0
      nu = -1;
   end
   dev = -nu*dev;
   y = des(l) + nu*dev*add./wt(l);
   if dev <= devl
      disp('-- Failure to Converge --')
      disp('Probable cause is machine rounding error.')
      if niter > 3
disp('The number of iterations exceeds 3 but the design may be correct.')
disp('The design may be verified by looking at the frequency response.')
      end
      break;
   end
   devl = dev;
   jchnge = 0;
   k1 = iext(1);
   knz = iext(nz);
   klow = 0;
   nut = -nu;
   j = 1;
   flag34 = 1;
   while j < nzz
      kup = iext(j+1);
      l = iext(j) + 1;
      nut = -nut;
      if j == 2
         y1 = comp;
      end
      comp = dev;
      flag = 1;
      if l < kup
	% gee
	c = ad./(cos(2*pi*grid(l))-x);  
	err = (c*y'/sum(c) - des(l))*wt(l);
	dtemp = nut*err - comp;
	if dtemp > 0
		comp = nut*err;
		l = l + 1;
            while l < kup
 	       % gee
	       c = ad./(cos(2*pi*grid(l))-x);  
               err = (c*y'/sum(c) - des(l))*wt(l);
               dtemp = nut*err - comp;
               if dtemp > 0
                  comp = nut*err;
                  l = l + 1;
               else
                  break;
               end
            end    
		iext(j) = l - 1;
		j = j + 1;
		klow = l - 1;
		jchnge = jchnge + 1;
		flag = 0;
	end
      end
      if flag
         l = l - 2;
         while l > klow
	    % gee
	    c = ad./(cos(2*pi*grid(l))-x);  
            err = (c*y'/sum(c) - des(l))*wt(l);
            dtemp = nut*err - comp;
            if dtemp > 0 | jchnge > 0
               break;
            end
            l = l - 1;
         end
         if l <= klow
            l = iext(j) + 1;
            if jchnge > 0
               iext(j) = l - 1;
               j = j + 1;
               klow = l - 1;
               jchnge = jchnge + 1;
            else
               l = l + 1;
               while l < kup
	 	  % gee
	 	  c = ad./(cos(2*pi*grid(l))-x);  
         	  err = (c*y'/sum(c) - des(l))*wt(l);
                  dtemp = nut*err - comp;
	          if dtemp > 0
                     break;
                  end
                  l = l + 1;
               end
               if l < kup & dtemp > 0
                  comp = nut*err;
                  l = l + 1;
                  while l < kup
	 	     % gee
	 	     c = ad./(cos(2*pi*grid(l))-x);  
         	     err = (c*y'/sum(c) - des(l))*wt(l);
                     dtemp = nut*err - comp;
                     if dtemp > 0
                        comp = nut*err;
                        l = l + 1;
                     else
                        break;
                     end
                  end    
                  iext(j) = l - 1;
	          j = j + 1;	
                  klow = l - 1;
                  jchnge = jchnge + 1;
               else
                  klow = iext(j);
                  j = j + 1;
               end
            end
         elseif dtemp > 0
            comp = nut*err;
            l = l - 1;
            while l > klow
	       % gee
	       c = ad./(cos(2*pi*grid(l))-x);  
               err = (c*y'/sum(c) - des(l))*wt(l);
               dtemp = nut*err - comp;
               if dtemp > 0
                  comp = nut*err;
                  l = l - 1;
               else
                  break;
               end
            end
            klow = iext(j);
            iext(j) = l + 1;
            j = j + 1;
            jchnge = jchnge + 1;
         else
            klow = iext(j);
            j = j + 1;
         end
      end
   end
   while j == nzz
      ynz = comp;
      k1 = min([k1 iext(1)]);
      knz = max([knz iext(nz)]);
      nut1 = nut;
      nut = -nu;
      l = 0;
      kup = k1;
      comp = ynz*1.00001;
      luck = 1;
      flag = 1;
      l = l + 1;
      while l < kup
	 % gee
	 c = ad./(cos(2*pi*grid(l))-x);  
         err = (c*y'/sum(c) - des(l))*wt(l);
         dtemp = err*nut - comp;
         if dtemp > 0
            comp = nut*err;
            j = nzz;
            l = l + 1;
            while l < kup
	       % gee
	       c = ad./(cos(2*pi*grid(l))-x);  
               err = (c*y'/sum(c) - des(l))*wt(l);
               dtemp = nut*err - comp;
               if dtemp > 0
                  comp = nut*err;
                  l = l + 1;
               else
                  break;
               end
            end    
            iext(j) = l - 1;
            j = j + 1;
            klow = l - 1;
            jchnge = jchnge + 1;
            flag = 0;
            break;
         end
         l = l + 1;
      end
      if flag
         luck = 6;
         l = ngrid + 1;
         klow = knz;
         nut = -nut1;
         comp = y1*1.00001;
         l = l - 1;
         while l > klow
	    % gee
	    c = ad./(cos(2*pi*grid(l))-x);  
            err = (c*y'/sum(c) - des(l))*wt(l);
            dtemp = err*nut - comp;
            if dtemp > 0
               j = nzz;
               comp = nut*err;
               luck = luck + 10;
               l = l - 1;
               while l > klow
	 	  % gee
	 	  c = ad./(cos(2*pi*grid(l))-x);  
         	  err = (c*y'/sum(c) - des(l))*wt(l);
                  dtemp = nut*err - comp;
                  if dtemp > 0
                     comp = nut*err;
                     l = l - 1;
                  else
                     break;
                  end
               end
               klow = iext(j);
               iext(j) = l + 1;
               j = j + 1;
               jchnge = jchnge + 1;
	       flag = 0;
               break;
            end
            l = l - 1;
         end
         if flag
            flag34 = 0;
            if luck ~= 6
               iext = [k1 iext(2:nz-nfcns)' iext(nz-nfcns:nz-1)']';
               jchnge = jchnge + 1;
            end
            break;
         end
      end
   end
   if flag34 & j > nzz 
      if luck > 9
         iext = [iext(2:nfcns+1)' iext(nfcns+1:nz-1)' iext(nzz) iext(nzz)]';
         jchnge = jchnge + 1;
      else
         y1 = max([y1 comp]);
         k1 = iext(nzz);
         l = ngrid + 1;
         klow = knz;
         nut = -nut1;
         comp = y1*1.00001;
         l = l - 1;
         while l > klow
	    % gee
	    c = ad./(cos(2*pi*grid(l))-x);  
            err = (c*y'/sum(c) - des(l))*wt(l);
            dtemp = err*nut - comp;
            if dtemp > 0
               j = nzz;
               comp = nut*err;
               luck = luck + 10;
               l = l - 1;
               while l > klow
	 	  % gee
	 	  c = ad./(cos(2*pi*grid(l))-x);  
         	  err = (c*y'/sum(c) - des(l))*wt(l);
                  dtemp = nut*err - comp;
                  if dtemp > 0
                     comp = nut*err;
                     l = l - 1;
                  else
                     break;
                  end
               end
               klow = iext(j);
               iext(j) = l + 1;
               j = j + 1;
               jchnge = jchnge + 1;
               iext = [iext(2:nfcns+1)' iext(nfcns+1:nz-1)' iext(nzz) iext(nzz)]';
               break;
            end
            l = l - 1;
         end
         if luck ~= 6
            iext = [k1 iext(2:nz-nfcns)' iext(nz-nfcns:nz-1)']';
            jchnge = jchnge + 1;
         end
      end  
   end
end

% Inverse Fourier transformation
nm1 = nfcns - 1;
fsh = 1.0e-6;
gtemp = grid(1);
x(nzz) = -2;
cn = 2*nfcns - 1;
delf = 1/cn;
l = 1;
kkk = 0;
if (edge(1) == 0 & edge(jb) == .5) | nfcns <= 3
   kkk = 1;
end
if kkk ~= 1
   dtemp = cos(2*pi*grid(1));
   dnum = cos(2*pi*grid(ngrid));
   aa = 2/(dtemp - dnum);
   bb = -(dtemp+dnum)/(dtemp - dnum);
end
for j = 1:nfcns
   ft = (j-1)*delf;
   xt = cos(2*pi*ft);
   if kkk ~= 1
      xt = (xt-bb)/aa;
      ft = acos(xt)/(2*pi);
   end
   xe = x(l);
   while xt <= xe & xe-xt >= fsh
      l = l + 1;
      xe = x(l);
   end
   if abs(xt-xe) < fsh
      a(j) = y(l);
   else
      grid(1) = ft;
      % gee
      c = ad./(cos(2*pi*ft)-x(1:nz));  
      a(j) = c*y'/sum(c);
   end
   l = max([1, l-1]);
end
grid(1) = gtemp;
dden = 2*pi/cn;
for j = 1:nfcns
   dnum = (j-1)*dden;
   if nm1 < 1
      alpha(j) = a(1);
   else
      alpha(j) = a(1) + 2*cos(dnum*(1:nm1))*a(2:nfcns)';
   end
end
alpha = [alpha(1) 2*alpha(2:nfcns)]'/cn;
if kkk ~= 1
   p(1) = 2*alpha(nfcns)*bb + alpha(nm1);
   p(2) = 2*aa*alpha(nfcns);
   q(1) = alpha(nfcns-2) - alpha(nfcns);
   for j = 2:nm1
      if j == nm1
         aa = aa/2;
         bb = bb/2;
      end
      p(j+1) = 0;
      sel = 1:j;
      a(sel) = p(sel);
      p(sel) = 2*bb*a(sel);
      p(2) = p(2) + 2*a(1)*aa;
      jm1 = j - 1;
      sel = 1:jm1;
      p(sel) = p(sel) + q(sel) + aa*a(sel+1);
      jp1 = j + 1;
      sel = 3:jp1;
      p(sel) = p(sel) + aa*a(sel-1);
      if j ~= nm1
         sel = 1:j;
         q(sel) = -a(sel);
         q(1) = q(1) + alpha(nfcns - 1 - j);
      end
   end
   alpha(1:nfcns) = p(1:nfcns);
end
if nfcns <= 3
   alpha(nfcns + 1) = 0;
   alpha(nfcns + 2) = 0;
end

alpha=alpha';

% now that's done!

if neg <= 0
   if nodd ~= 0
      h = [.5*alpha(nz-1:-1:nz-nm1) alpha(1)];
   else
      h = .25*[alpha(nfcns) alpha(nz-2:-1:nz-nm1)+alpha(nfcns:-1:nfcns-nm1+2) ...
           2*alpha(1)+alpha(2)];
   end
elseif nodd ~= 0
   h = .25*[alpha(nfcns) alpha(nm1)];
% Fix, 3/17/93  TPK
% old lines:
%   h(nfcns:fix(nfilt/2)+nodd) = %.25*[alpha(nz-3:-1:nz-nm1)-alpha(nfcns:-1:nfcns-nm1+3) 2*alpha(1)-alpha(3) 0];
% new lines:
   h = [h .25*[alpha(nz-3:-1:nz-nm1)-alpha(nfcns:-1:nfcns-nm1+3) ... 
           2*alpha(1)-alpha(3) ] ];
   h = [-h 0 fliplr(h)];
   return;
else
   h = .25*[alpha(nfcns) alpha(nz-2:-1:nz-nm1)-alpha(nfcns:-1:nfcns-nm1+2) ...
        2*alpha(1)-alpha(2)];
end
lenh=max(size(h));
h = [sign(.5-neg)*h(1:lenh-nodd) h(lenh:-1:1)];

% [H,w]=freqz(h,1,1024); hold on, plot(w/2/pi,abs(H),'g'), hold off
% set(gca,'xgrid','on','ygrid','on');
