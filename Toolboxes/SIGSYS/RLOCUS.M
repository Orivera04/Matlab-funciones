function [rout,k] = rlocus(a,b,c,d,e,f)
%RLOCUS	Evans root locus.
%	RLOCUS(NUM,DEN) calculates and plots the locus of the roots of:
%                              NUM(s)
%               H(s) = 1 + k ----------  =  0
%                              DEN(s)
%	for a set of gains K which are adaptively calculated to produce a 
%	smooth plot. Alternatively the vector K can be specified with an 
%	optional right-hand argument RLOCUS(NUM,DEN,K). Vectors NUM and 
%	DEN must contain the numerator and denominator coefficients in 
%	descending powers of s or z. When invoked with left hand arguments
%		R = RLOCUS(NUM,DEN,K)  or  [R,K] = RLOCUS(NUM,DEN)
%	returns the matrix R with LENGTH(K) rows and (LENGTH(DEN(-1) 
%	columns containing the complex root locations.  Each row of the 
%	matrix corresponds to a gain from vector K.  If a second left hand
%	argument is included, the gains are returned in K.
% 
%	RLOCUS(A,B,C,D), R = RLOCUS(A,B,C,D,K), or [R,K] = RLOCUS(A,B,C,D)
%	finds the root-locus from the equivalent SISO state-space system
%	(A,B,C,D).
%                    dx/dt = Ax + Bu    u = -k*y
%                        y = Cx + Du

% 	J.N. Little 10-11-85
%	Revised A.C.W.Grace 7-8-89, 6-21-92 
%	Copyright (c) 1986-93 by the MathWorks, Inc.

if nargin==0, eval('exresp(''rlocus'');'), return, end

error(nargchk(2,6,nargin));

% The next variable controls how many points are plotted on the graph.
precision = 1; %Set to a higher number (e.g. 2 for more points on the graph).
k=[];

if (nargin==3 | nargin==2 ) 	% Convert to state space
	if nargin==3, k = c; end
	[num,den] = tfchk(a,b);
	[a,b,c,d] = tf2ss(a,b);
end

[ny,nu] = size(d);
if (ny*nu==0)|isempty(a), k=[]; if nargout~=0, rout=[]; end, return, end

%  Multivariable systems
error(abcdchk(a,b,c,d));
if nargin==5,
  k=e; 
elseif nargin==6,
  b=b(:,e); d=d(:,e); k = f;
end

% Trap MIMO case
[ny,nu] = size(d);
if ny*nu~=1,
  if nargout~=0,
    disp('Warning: Root locus with outputs must be SISO.'), 
    return,
  end
  [e,nargin,r]=mulresp('rlocus',a,b,c,d,k,0,0);
  if ~e, if nargout, rout = r; end, return, end
end

sp=sum([1:length(a)].^2);

% Set up graphics and other parameters.

if isempty(k) | nargout==0
% Work out scales and ranges
	kgiven = 0;
	ep=eig(a);
	p=length(ep);
	if nargin>=4
		tz=tzero(a,b,c,d);
		z=length(tz);
		sp2=[1:z].^2;
		den=poly(ep);
		num=poly(tz);
	else
		tz=roots(num);
		z=length(tz);
	end
	den2 = den + 1e-20*(den==0); 
	dcgain=num(length(num))/den2(length(den));
% Normalize for better numerical properties
	if abs(den(1)) > eps & den(1) ~= 1
		den=den/den(1);
		num=num/den(1);
	end
	mep=max([eps;abs([real(ep);real(tz);imag(ep);imag(tz)])]);
	if z==p
% Round up axis to units to the nearest 5
		ax=1.2*mep;        
	else
		% Round graph axis    
		exponent=5*10^(floor(log10(mep))-1);
		ax=2*round(mep/exponent)*exponent;    
	end
	if nargout==0 
% Real and imaginary axis - uncomment these if you don't want them
		axstate = axis('state');
		holdon = ishold;
		newplot;
		if ~holdon
			plot([-ax,ax],[0,0],'w:',[0,0],[-ax,ax],'w:');
			axis([-ax,ax,-ax,ax])
		else
			ax4 = axis;
			ax = sum(abs(ax4))/4;
			plot([ax4(1:2)],[0,0],'w:',[0,0],[ax4(3:4)],'w:');
			axis(ax4)
		end
% If plotting is required then set up axis and titles
		hold on
		plot(real(ep),imag(ep),'x');
		if ~isempty(tz)
			plot(real(tz),imag(tz),'o');
		end
		xlabel('Real Axis')
		ylabel('Imag Axis')
		% Use none as Erasemode for fast plotting
		erasemode = 'none';
		drawnow
	end
end

% Adaptively search for values of gain  if K is not specified

if isempty(k)
% Set up initial gain based on D.C.Gain of open loop and 
% positions of zeros and poles.
% Since closed loop den = num + k*den, sensitivity is related
% to difference between num and denominator coefficients.
	diff=abs(num)./abs(den2(1:length(num)));
	kinit=0.01/(abs(dcgain) + polyval(diff,4))+1e-12;
	bc=b*c;
	k=[0,1e-4*kinit,kinit]; dist=kinit;
	r(:,1)=ep;
	r(:,2)=vsort(ep, eig(a-bc*(k(2)./(1+k(2)*d))), sp);
	if nargout==0, plot( real([ep,r(:,2)])', imag([ep,r(:,2)])','-' ,'Erasemode', erasemode), end
	i=2; ij=sqrt(-1); perr=1;
	terminate=0; 	
	while  ~terminate
		i=i+1;
		ki=k(i)./(1+k(i)*d);
		r1=eig(a-bc*ki);
		mx=max(abs([real(r1).';imag(r1).']));
		% If any line outside box then set erasemode back to normal
		% for clipping
		if any(mx > ax), erasemode = 'normal'; end
% Sort out eigenvalues so that plotting appears continuous. 
		[r(:,i),pind]=vsort(r(:,i-1),r1,sp);
% Adjust values of k based on linearity of the roots:
		% First two points in line
		y1=imag(r(:,i-2)); y2=imag(r(:,i-1));
		x1=real(r(:,i-2)); x2=real(r(:,i-1));
		% Current  points
		y=imag(r(:,i)); x=real(r(:,i));
		% Nearest x-y co-ordinates of new point to line
		[newx,newy]=perpxy(x1,y1,x2,y2,x,y);
		% Error estimation
		err=sqrt((newy-y).^2+(newx-x).^2);
		distm=norm((y-y2)+ij*(x-x2));
		fferr=find(~finite(err));
		err(fferr)=zeros(length(fferr),1);
		perr=precision*max(err(find(finite(err))))/(distm+ax/(1e3*(distm+eps))); 

% If percentage error greater than threshold then go back and 
% re-evaluate more roots:
		pind = any((y==0)~=(y2==0));
		if perr>0.2 | pind
		    % Decrement distance between gains
		    npts=3+5*round(min([5,perr*3]))+17*pind;
		    kval=logspace(log10(k(i-1)),log10(k(i)),npts);
		    dist=(k(i)-k(i-1))/(npts-7*pind);
		    i=i-1;
		    for kcnt=kval(2:npts)
		        i=i+1;
		        k(i)=kcnt;
		        ki=kcnt./(1+kcnt*d);
		        r1=eig(a-bc*ki);
		        r(:,i) = vsort(r(:,i-1),r1,sp);
		        y=imag(r(:,i)); y2=imag(r(:,i-1));
		        x=real(r(:,i)); x2=real(r(:,i-1));
		        ind = 0; 
		        if nargout==0  
% Intersection of rlocus on the  real axis.
		            if pind   
% The inequality abs(y+y2)<ax makes sure that its not one that 
% goes off to inf and then 
% comes back on the real axis. 
		                ind = find((y==0)~=(y2==0) & abs(y+y2)<ax);
		                if ~isempty(ind)
		                    if (imag(r(ind(1),i))==0), cix = 1; else, cix = 0; end
		                    realr = r(:,i-cix);
		                    realr(ind)=real(r(ind,i-cix));
		                    plot( real([realr,r(:,i-1)])', imag([realr,r(:,i-1)])','-','Erasemode',erasemode)
		                    plot( real([r(:,i),realr])', imag([r(:,i),realr])','-' ,'Erasemode',erasemode)
		                else
		                    ind=0;
		                end
		            end
		            if ~ind
% Fix for plot when rlocus goes from -inf to inf or -inf to inf
		                infind = find(abs(x)>ax & sign(x2)~=sign(x));
		                if length(infind)>0
		                    x(infind) = sign(x2(infind))*ax;
		                end 
		                plot([x,x2]',[y,y2]','-','Erasemode',erasemode)
		            end

		        end
		    end
		else
% Fix for plot when rlocus goes comes from -inf to inf or -inf to inf
		    infind = find(abs(x)>ax & sign(x2)~=sign(x) );
		    if length(infind)>0
		        x(infind) = sign(x2(infind))*ax;
		    end 
			% Use none as Erasemode for fast plotting
		    if nargout==0, plot([x,x2]',[y,y2]','-','Erasemode',erasemode), end
		    % Increase/decrease distance to next k based on linearity estimate:
		    dist=dist*(0.3/precision+exp(1-15*perr));
		end
		% Next gain value
		k(i+1)=k(i)+dist;
% Termination criterion
		terminate=1;
		if z==p
		    tz = vsort(r1, tz);
		    terminate=max(abs(tz-r1))<ax/100;
		else 
		    % Make sure all loci tending to infinity are out of graph before terminating
		    % Terminate when all poles have approached their corresponding  zeros
		    % Note: this may not work well if zeros are close together
		    if z > 0
		    	terminate=max(min(abs(r1*ones(1,z)-ones(p,1)*tz.')))<ax/100;
		    end
			mx=max(abs([real(r1).';imag(r1).']));
		    terminate = ( sum(mx>1.2*ax)>=p-z & terminate );
		end
		terminate = terminate | abs(k(i)) > 1e30;
		if nargout == 0
			if rem(i,10) == 0 % Draw graph every ten iterations
				drawnow
			end
		end
	end

else
% When K is given:
	kgiven = 1;
	[ns,nu] = size(b);
	nk = length(k); i=1;
	r  = sqrt(-1) * ones(ns,nk);
	bc = b*c; 
% Find eigenvalues of:  A - B*inv(I+k*D)*k*C:
	k2 = k./(1+k.*d);
	r(:,1)=eig(a-bc*k2(1)); k2(1)=[];
	if nk == 1 & nargout == 0
		% Special case when only one point
		plot(real(r(:,1))', imag(r(:,1)), '+');
	end
	for ki=k2
		i = i + 1;
		r1 = eig(a-bc*ki);
% Sort eigenvalues
		r(:,i)=vsort(r(:,i-1),r1,sp);
		if nargout==0
			% Plot in pairs to get colored crosses
		    plot( real([r(:,i),r(:,i-1)])', imag([r(:,i),r(:,i-1)])','+','Erasemode','none')
		end
	end
end
r = r.';

if nargout==0, 
% Uncomment the next line to obtain grid on plot
	%grid
	% Return graphics to original state
	if ~holdon, hold off, end
	% axis(axstate);
	return % Suppress output
end

rout = r;
% Last element of k is never used
if ~kgiven 
	k(length(k))=[];
	k = k.';
end
