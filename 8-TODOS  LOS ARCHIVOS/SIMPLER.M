function [r,h] = simpler(how,s,r,h,p,x)
%SIMPLER Used by SIMPLE to shorten expressions.
%	SIMPLE(HOW,S,R,H,P,X) applies method HOW with optional parameter X
%	to expression S, prints the result if P is nonzero, compares the
%	length of the result with expression R, which was obtained with
%	method H, and returns the shortest string and corresponding method.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.6 $  $Date: 1994/01/24 22:37:10 $

if s(1) ~= '['
   if nargin < 6
      [t,err] = maple(how,s);
   else
      [t,err] = maple(how,s,x);
   end
else
   if nargin < 6
      [t,err] = maple('map',how,s);
   else
      [t,err] = maple('map',how,s,x);
   end
end

if err, return, end

if nargin == 6
   how = [how '(' x ')'];
end

if p & ~strcmp(s,t) & ~strcmp(r,t)
   disp(' ')
   disp([how ':'])
   disp(' ')
   disp(t)
end

if length(t) < length(r)
   r = t;
   h = how;
end
