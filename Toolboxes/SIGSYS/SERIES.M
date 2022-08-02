function [a,b,c,d] = series(a1,b1,c1,d1,a2,b2,c2,d2,e,f)
%SERIES Series connection of two systems.  
%
%		u --->[System1]--->[System2]----> y
%
%	[A,B,C,D] = SERIES(A1,B1,C1,D1,A2,B2,C2,D2) produces an aggregate
%	state-space system consisting of the series connection of systems
%	1 and 2 that connects all the outputs of system 1 connected to 
%	all the inputs of system 2, u2 = y1.  The resulting system has 
%	the inputs of system 1 and the outputs of system 2.
%
%	[A,B,C,D] = SERIES(A1,B1,C1,D1,A2,B2,C2,D2,OUTPUTS1,INPUTS2) 
%	connects the two system in series such that the outputs of system
%	1 specified by OUTPUTS1 are connected to the inputs of system 2 
%	specified by INPUTS2.  The vectors OUTPUTS1 and INPUTS2 contain 
%	indexes into the output and inputs of system 1 and system 2 
%	respectively.
% 
%	[NUM,DEN] = SERIES(NUM1,DEN1,NUM2,DEN2) produces the SISO system
%	in transfer function form obtained by connecting the two SISO 
%	transfer function systems in series.
%
%	See also: APPEND, FEEDBACK and CLOOP.

%	Clay M. Thompson 6-29-90
%	Copyright (c) 1986-93 by the MathWorks, Inc.

error(nargchk(4,10,nargin));

% --- Determine which syntax is being used ---
if (nargin == 4)  % Form Series connection of T.F. system ---
  [num1,den1] = tfchk(a1,b1); [num2,den2] = tfchk(c1,d1);
  a = conv(num1,num2);
  b = conv(den1,den2);

elseif ((nargin>=5) & (nargin<=7)) | (nargin==9)
  error('Wrong number of input arguments.');

elseif (nargin==8) | (nargin==10)  % State space systems 
  error(abcdchk(a1,b1,c1,d1));
  error(abcdchk(a2,b2,c2,d2));
 
% Get number of inputs and outputs
  [ny1,nu1] = size(d1);
  if (nu1 == 0), [dum, nu1] = size(b1);  [ny2, dum] = size(c1); end
  [ny2,nu2] = size(d2);
  if (nu2 == 0), [dum, nu2] = size(b2); [ny2, dum] = size(c2); end

  if (nargin == 8) % State space systems w/o selection vectors
    inputs1 = [1:nu1];     outputs1 = [1:ny1];
    inputs2 = [1:nu2]+nu1; outputs2 = [1:ny2]+ny1; 
  end
  if (nargin == 10) % State space systems with selection vectors
    inputs1 = [1:nu1];     outputs1 = e;
    inputs2 = f+nu1;  outputs2 = [1:ny2]+ny1;
  end
  
  % Check sizes
  if (length(outputs1)~=length(inputs2))
    error('Series connection sizes don''t match.'); end

  % --- Series Connection ---
  [a,b,c,d] = append(a1,b1,c1,d1,a2,b2,c2,d2);
  [a,b,c,d] = cloop(a,b,c,d,outputs1,inputs2);
  [a,b,c,d] = ssselect(a,b,c,d,inputs1,outputs2);
end
