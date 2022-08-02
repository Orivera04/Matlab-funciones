function [at,bt,ct,dt] = lp2bs(a,b,c,d,wo,bw)
%LP2BS	Lowpass to bandstop analog filter transformation.
%	[NUMT,DENT] = LP2BS(NUM,DEN,Wo,Bw) transforms the lowpass filter
%	prototype NUM(s)/DEN(s) with unity cutoff frequency to a
%	bandstop filter with center frequency Wo and bandwidth Bw.
%	[AT,BT,CT,DT] = LP2BS(A,B,C,D,Wo,Bw) does the same when the
%	filter is described in state-space form.

%	Author(s): J.N. Little and G.F. Franklin, 8-4-87
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.4 $  $Date: 1994/01/25 17:59:26 $

if nargin == 4		% Transfer function case
	% Transform to state-space
	wo = c;
	bw = d;
	[a,b,c,d] = tf2ss(a,b);
end

error(abcdchk(a,b,c,d));
[ma,nb] = size(b);
[mc,ma] = size(c);

% Transform lowpass to bandstop
q = wo/bw;
at =  [wo/q*inv(a) wo*eye(ma); -wo*eye(ma) zeros(ma)];
bt = -[wo/q*(a\b); zeros(ma,nb)];
ct = [c/a zeros(mc,ma)];
dt = d - c/a*b;

if nargin == 4		% Transfer function case
	% Transform back to transfer function
	b = poly(at);
	at = poly(at-bt*ct)+(dt-1)*b;
	bt = b;
end
