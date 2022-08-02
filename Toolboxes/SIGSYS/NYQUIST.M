function [reout,imt,w] = nyquist(a,b,c,d,iu,w)
%NYQUIST Nyquist frequency response for continuous-time linear systems.
%	NYQUIST(A,B,C,D,IU) produces a Nyquist plot from the single input
%	IU to all the outputs of the system:             
%               .                                    -1
%               x = Ax + Bu             G(s) = C(sI-A) B + D  
%               y = Cx + Du      RE(w) = real(G(jw)), IM(w) = imag(G(jw))
%
%	The frequency range and number of points are chosen automatically.
%
%	NYQUIST(NUM,DEN) produces the Nyquist plot for the polynomial 
%	transfer function G(s) = NUM(s)/DEN(s) where NUM and DEN contain
%	the polynomial coefficients in descending powers of s. 
%
%	NYQUIST(A,B,C,D,IU,W) or NYQUIST(NUM,DEN,W) uses the user-supplied
%	freq. vector W which must contain the frequencies, in radians/sec,
%	at which the Nyquist response is to be evaluated.  When invoked 
%	with left hand arguments,
%		[RE,IM,W] = NYQUIST(A,B,C,D,...)
%		[RE,IM,W] = NYQUIST(NUM,DEN,...) 
%	returns the frequency vector W and matrices RE and IM with as many
%       columns as outputs and length(W) rows.  No plot is drawn on the 
%	screen.
%	See also: LOGSPACE, BODE.

% 	J.N. Little 10-11-85
%	Revised ACWG 8-15-89, CMT 7-9-90, ACWG 2-12-91, 6-21-92, 
%               AFP 2-23-93
%	Copyright (c) 1986-93 by the MathWorks, Inc.

if nargin==0, eval('exresp(''nyquist'')'), return, end

% --- Determine which syntax is being used ---
if (nargin==1),
	error('Wrong number of input arguments.');

elseif (nargin==2),	% Transfer function form without frequency vector
	num  = a; den = b; 
	w = freqint2(num,den,30);
	[ny,nn] = size(num); nu = 1;

elseif (nargin==3),	% Transfer function form with frequency vector
	num = a; den = b;
	w = c;
	[ny,nn] = size(num); nu = 1;

elseif (nargin==4),	% State space system, w/o iu or frequency vector
	error(abcdchk(a,b,c,d));
	w = freqint2(a,b,c,d,30);
	[iu,nargin,re,im]=mulresp('nyquist',a,b,c,d,w,nargout,0);
	if ~iu, if nargout, reout = re; end, return, end
	[ny,nu] = size(d);

elseif (nargin==5),	% State space system, with iu but w/o freq. vector
	error(abcdchk(a,b,c,d));
	w = freqint2(a,b,c,d,30);
	[ny,nu] = size(d);

else
	error(abcdchk(a,b,c,d));
	[ny,nu] = size(d);

end

if nu*ny==0, im=[]; w=[]; if nargout~=0, reout=[]; end, return, end

% Compute frequency response
if (nargin==2)|(nargin==3)
	gt = freqresp(num,den,sqrt(-1)*w);
else
	gt = freqresp(a,b,c,d,iu,sqrt(-1)*w);
end
ret=real(gt); 
imt=imag(gt);

% If no left hand arguments then plot graph.
if nargout==0,
   status = ishold;
   plot(ret,imt,'r-',ret,-imt,'g--')
   set(gca, 'YLimMode', 'auto')
   limits = axis;
   % Set axis hold on because next plot command may rescale
   set(gca, 'YLimMode', 'auto')
   set(gca, 'XLimMode', 'manual')
   hold on
   % Make arrows
   for k=1:size(gt,2),
        g = gt(:,k);
        re = ret(:,k);
        im = imt(:,k);
	sx = limits(2) - limits(1);
	[sy,sample]=max(abs(2*im));
	arrow=[-1;0;-1] + 0.75*sqrt(-1)*[1;0;-1];
	sample=sample+(sample==1);
	reim=diag(g(sample,:));
	d=diag(g(sample+1,:)-g(sample-1,:)); 
	% Rotate arrow taking into account scaling factors sx and sy
	d = real(d)*sy + sqrt(-1)*imag(d)*sx;
	rot=d./abs(d);  	% Use this when arrow is not horizontal
	arrow = ones(3,1)*rot'.*arrow;
	scalex = (max(real(arrow)) - min(real(arrow)))*sx/50;
	scaley = (max(imag(arrow)) - min(imag(arrow)))*sy/50;
	arrow = real(arrow)*scalex + sqrt(-1)*imag(arrow)*scaley;
	xy =ones(3,1)*reim' + arrow;
	xy2=ones(3,1)*reim' - arrow;
	[m,n]=size(g); 
	hold on
	plot(real(xy),-imag(xy),'r-',real(xy2),imag(xy2),'g-')
   end
   xlabel('Real Axis'), ylabel('Imag Axis')

   limits = axis;
   % Make cross at s = -1 + j0, i.e the -1 point
   if limits(2) >= -1.5  & limits(1) <= -0.5 % Only plot if -1 point is not far out.
	line1 = (limits(2)-limits(1))/50;
	line2 = (limits(4)-limits(3))/50;
	plot([-1+line1, -1-line1], [0,0], 'w-', [-1, -1], [line2, -line2], 'w-')
   end

   % Axis
   plot([limits(1:2);0,0]',[0,0;limits(3:4)]','w:');

   if ~status, hold off, end	% Return hold to previous status
   return % Suppress output
end
reout = ret; 
