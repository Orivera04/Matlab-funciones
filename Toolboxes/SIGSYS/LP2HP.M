function [at,bt,ct,dt] = lp2hp(a,b,c,d,wo)
%LP2HP	Lowpass to highpass analog filter transformation.
%	[NUMT,DENT] = LP2HP(NUM,DEN,Wo) transforms the lowpass filter
%	prototype NUM(s)/DEN(s) with unity cutoff frequency to a
%	highpass filter with cutoff frequency Wo.
%	[AT,BT,CT,DT] = LP2HP(A,B,C,D,Wo) does the same when the
%	filter is described in state-space form.

%	Author(s): J.N. Little and G.F. Franklin, 8-4-87
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.4 $  $Date: 1994/01/25 17:59:26 $

if nargin == 3		% Transfer function case
	% Transform to state-space
	wo = c;
	[a,b,c,d] = tf2ss(a,b);
end

error(abcdchk(a,b,c,d));
[ma,nb] = size(b);
[mc,ma] = size(c);

% Transform lowpass to highpass
at =  wo*inv(a);
bt = -wo*(a\b);
ct = c/a;
dt = d - c/a*b;

if nargin == 3		% Transfer function case
	% Transform back to transfer function
	b = poly(at);
	at = poly(at-bt*ct)+(dt-1)*b;
	bt = b;
end
