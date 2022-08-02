function h=GAtext(v,s,c)
%h=GAtext(v,s,c): draw string s at tip of vector v in color c (optional).
%  h is the text handle.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
if nargin==2
	h=text(v.m(2),v.m(3),v.m(4),s);
else
	h=text(v.m(2),v.m(3),v.m(4),s,'Color',c);
end
