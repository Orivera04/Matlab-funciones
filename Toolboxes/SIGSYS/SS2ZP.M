function [z,p,k] = ss2zp(a,b,c,d,iu)
%SS2ZP	State-space to zero-pole conversion.
%	[Z,P,K] = SS2ZP(A,B,C,D,IU)  calculates the transfer function in
%	factored form:
%
%			     -1           (s-z1)(s-z2)...(s-zn)
%		H(s) = C(sI-A) B + D =  k ---------------------
%			                  (s-p1)(s-p2)...(s-pn)
%	of the system:
%		.
%		x = Ax + Bu
%		y = Cx + Du
%
%	from the single input IU.  The vector P contains the pole 
%	locations of the denominator of the transfer function.  The 
%	numerator zeros are returned in the columns of matrix Z with as 
%	many columns as there are outputs y.  The gains for each numerator
%	transfer function are returned in column vector K.
%
%	See also: ZP2SS, TZERO, and EIG.

% 	J.N. Little 7-17-85
%	Revised 3-12-87 JNL, 8-10-90 CLT, 1-18-91 ACWG.
%	Copyright (c) 1986-94 by The MathWorks, Inc.
%	$Revision: 1.24 $  $Date: 1994/01/25 17:55:50 $

error(nargchk(4,5,nargin));
error(abcdchk(a,b,c,d));

[nx,ns] = size(a);

if nargin==4,
	if nx>0,
		[nb,nu] = size(b);
	else
		[ny,nu] = size(d);
	end
	if (nu<=1), 
		iu = 1;
	else
		error('IU must be specified for systems with more than one input.');
	end
end

% Remove relevant input:
if ~isempty(b), b = b(:,iu); end
if ~isempty(d), d = d(:,iu); end

% Trap gain-only models
if nx==0&~isempty(d), z = []; p = []; k = d; return, end

% Do poles first, they're easy:
p = eig(a);

k = []; 
% Compute zeros and gains using transmission zero calculation
% Check if Control Toolbox is on path, in which case use the 
% more accurate tzero method. 
if exist('tzreduce')
% New code if new tzero code exists:
	[ny,nu] = size(d);
	z = [];
	k = [];
	for i=1:ny
	  [zi,gi] = eval('tzero(a,b,c(i,:),d(i,:))');
	  [mz,nz] = size(z);
	  nzi = length(zi);
	  if i==1,
	    z = zi;
	  else
		linf = inf;
 	    z = [[z; linf(ones(max(0,nzi-mz),1),ones(max(nz,1),1))], ...
	         [zi;linf(ones(max(0,mz-nzi),1),1)]];
	  end
	  k = [k;gi];
	end

else
% If Control Toolbox not on path then use generalized eigenvalues:

% Now try zeros, they're harder:
	[no,ns] = size(c);
	linf=inf;
	z = linf(ones(ns,1),ones(no,1));  % Set whole Z matrix to infinities
% Loop through outputs, finding zeros
	for i=1:no
		s1 = [a b;c(i,:) d(i)];
		s2 = diag([ones(1,ns) 0]);
		zv = eig(s1,s2);
		% Now put NS valid zeros into Z. There will always be at least one
		% NaN or infinity.
		zv = zv(~isnan(zv) & finite(zv));
		if ~isempty(zv)
		    z(1:length(zv),i) = zv;
		end
	end
end
% Now finish up by finding gains using Markov parameters
if isempty(k)
	k = d;  CAn = c; iter = 0;
	while any(k==0) % do until all k's are finished
		i = find(k==0);
		if iter > ns
		    % Note: iter count is needed because when B is all zeros
		    % it does not otherwise converge.
		    k(i) = zeros(max(size(i)),1);
		    break
		end
		iter = iter + 1;
		markov = CAn*b;
		k(i) = markov(i);
		CAn = CAn*a;
	end
end
