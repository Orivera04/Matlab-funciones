function vec=fridays(start,stop);
%@DEMTSERIES/FRIDAYS generates a vector of fridays from start to stop dates.
%   The dates must be in serial date format NOT string dates.
%
%   Example:
%     fris = fridays(datenum('05/01/98'), datenum('05/15/98'));
%
 
%   Copyright 1995-2002 The MathWorks, Inc. 
%	$Revision: 1.7 $ $Date: 2002/04/14 21:43:50 $ 
%	Author(s): Dave McClay, Cambridge Control, 12/15/97 
%  Editor: P. N. Secakusuma, The MathWorks, Inc., 05/06/98
 
% FRIDAYS Generates a vector of fridays	from start to stop dates.
%
% vec = fridays( '1/4/1997', '31/12/1997' )
%

% Design reference: A042, Cambridge Control Limited
% --------------------------------------------------------
% Version Control
% ---------------
% $Id: fridays.m,v 1.7 2002/04/14 21:43:50 batserve Exp $
% ---------------------------------------------------------

daystr = datestr(start, 8);

switch daystr 
   case 'Sat', start=start+6;
   case 'Sun', start=start+5; 
   case 'Mon', start=start+4;
   case 'Tue', start=start+3; 
   case 'Wed', start=start+2;
   case 'Thu', start=start+1;
end 

vec=[];
j=1; i=start;
while i<=stop
   vec(j,1)=i;
   j=j+1; i=i+7;
end
