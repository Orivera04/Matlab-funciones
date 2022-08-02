function [magout,phase,w] = bode(a,b,c,d,iu,w)
%BODE   Bode frequency response for continuous-time linear systems.
%	BODE(A,B,C,D,IU) produces a Bode plot from the single input IU to
%	all the outputs of the continuous state-space system (A,B,C,D).
%	IU is an index into the inputs of the system and specifies which
%	input to use for the Bode response.  The frequency range and
%	number of points are chosen automatically.
%
%	BODE(NUM,DEN) produces the Bode plot for the polynomial transfer
%	function G(s) = NUM(s)/DEN(s) where NUM and DEN contain the 
%	polynomial coefficients in descending powers of s. 
%
%	BODE(A,B,C,D,IU,W) or BODE(NUM,DEN,W) uses the user-supplied 
%	frequency vector W which must contain the frequencies, in 
%	radians/sec, at which the Bode response is to be evaluated.  See 
%	LOGSPACE to generate logarithmically spaced frequency vectors. 
%	When invoked with left hand arguments,
%		[MAG,PHASE,W] = BODE(A,B,C,D,...)
%		[MAG,PHASE,W] = BODE(NUM,DEN,...) 
%	returns the frequency vector W and matrices MAG and PHASE (in 
%	degrees) with as many columns as outputs and length(W) rows.  No
%	plot is drawn on the screen. 
%
%	See also LOGSPACE, SEMILOGX, and NYQUIST.

% 	J.N. Little 10-11-85
%	Revised A.C.W.Grace 8-15-89, 2-4-91, 6-21-92
%	Revised Clay M. Thompson 7-9-90
%	Copyright (c) 1986-93 by the MathWorks, Inc.

nargs = nargin;
if nargs==0, eval('exresp(''bode'')'), return, end

error(nargchk(2,6,nargs));

% --- Determine which syntax is being used ---
if (nargs==1),
	error('Wrong number of input arguments.');

elseif (nargs==2),	% Transfer function form without frequency vector
	num = a; den = b; 
	w = freqint(num,den,20);
	[ny,nn] = size(num); nu = 1;

elseif (nargs==3),	% Transfer function form with frequency vector
	num = a; den = b;
	w = c;
	[ny,nn] = size(num); nu = 1;

elseif (nargs==4),	% State space system, w/o iu or frequency vector
	error(abcdchk(a,b,c,d));
	w = freqint(a,b,c,d,30);
	[iu,nargs,mag,phase]=mulresp('bode',a,b,c,d,w,nargout,1);
	if ~iu, if nargout, magout = mag; end, return, end
	[ny,nu] = size(d);

elseif (nargs==5),	% State space system, with iu but w/o freq. vector
	error(abcdchk(a,b,c,d));
	w = freqint(a,b,c,d,30);
	[ny,nu] = size(d);

else
	error(abcdchk(a,b,c,d));
	[ny,nu] = size(d);

end

if nu*ny==0, phase=[]; w=[]; if nargout~=0, magout=[]; end, return, end

% --- Evaluate the frequency response ---
if (nargs==2)|(nargs==3),
	g = freqresp(num,den,sqrt(-1)*w);
else
	g = freqresp(a,b,c,d,iu,sqrt(-1)*w);
end
mag = abs(g);
phase = (180./pi)*unwrap(atan2(imag(g),real(g)));

% Uncomment out the following statement if you don't want the phase to  
% be unwrapped.  Note that phase unwrapping will not always work; it is
% only a "guess" as to whether +-360 should be added to the phase 
% to make it more aesthetically pleasing.  (See UNWRAP.M)

%phase = (180./pi)*atan2(imag(g),real(g));

%Try to correct phase anomaly for plants with integrators
%by adding multiples of -360 degrees.
if (nargs == 2 | nargs == 3) 
	nd = length(den);
	f = find(fliplr(den) == zeros(1,nd));
	nintgs = sum(f == 1:length(f));	
	if phase(1) > 0 & nintgs > 0
		phase = phase - 360;
	end
else 
	if abs(det(a)) < eps
		if phase(1) > 0 & nintgs > 0
		    phase = phase - 360;
		end
	end
end

% If no left hand arguments then plot graph.
if nargout==0
	holdon = ishold;
	subplot(211) 
	if holdon
		hold on
	end
	semilogx(w,20*log10(mag),w,zeros(1,length(w)),'w:')
	% If hold is set to on on the current axis then set it on the first axis too.
	% This enables two bode response to be superimposed on each other with
	% the following commands:
	%	bode(num, den); hold on; bode(num2, den2)
	grid on
	xlabel('Frequency (rad/sec)'), ylabel('Gain dB')

	subplot(212), 
	semilogx(w,phase)
	xlabel('Frequency (rad/sec)'), ylabel('Phase deg')

	% Set tick marks up to be in multiples of 30, 90, 180, 360 ... degrees.
	ytick = get(gca, 'ytick');
	ylim = get(gca, 'ylim');
	yrange = ylim(2) - ylim(1);
    no_of_pts = log(yrange/(length(ytick)*90))/log(2);
	n = round(log(yrange/(length(ytick)*90))/log(2));

	set(gca, 'ylimmode', 'manual')

	if no_of_pts >= -1.15
		% 45, 90, 180, 360, ...  degree increments  
		ytick = [-90*2^n:-(90*2^n):ylim(1), 0:(90*2^n):ylim(2)];
		ytick = ytick(find(ytick >= ylim(1) & ytick <= ylim(2)));
		set(gca,'ytick',ytick);
	elseif n >= -2 
		% Special case for 30 degree increments rather than 22.5
		ytick = [-30:-30:ylim(1), 0:30:ylim(2)];
		ytick = ytick(find(ytick >= ylim(1) & ytick <= ylim(2)));
		set(gca,'ytick',ytick);
	end
	grid on
	% Reset the graph: subplot(111)
	subplot(111)
	return % Suppress output 
end

% Uncomment the following line for decibels, but be warned that the
% MARGIN function will not work with decibel data.
% mag = 20*log10(mag);

magout = mag; 
