function [a,b,c,d] = feedback(a1,b1,c1,d1,a2,b2,c2,d2,e,f)
%FEEDBACK Feedback connection of two systems. 
%              u-->O-->[System1]---+--->y
%                  |               |
%                  +---[System2]<--+
%	[A,B,C,D] = FEEDBACK(A1,B1,C1,D1,A2,B2,C2,D2,SIGN) produces an 
%       aggregate state-space system consisting of the feedback connection
%	of the two systems 1 and 2.  Typically, system 1 is a plant and 
%	system 2 is a compensator.   If SIGN=1 then positive feedback is
%	used. If SIGN=-1 then negative feedback is used.  In all cases, 
%	the resulting system has the same inputs and outputs as system 1.
%
%	[A,B,C,D] = FEEDBACK(A1,B1,C1,D1,A2,B2,C2,D2,INPUTS1,OUTPUTS1) 
%	produces the feedback system formed by feeding all the outputs of
%	system 2 into the inputs of system 1 specified by INPUTS1 and by 
%	feeding the outputs of system 1 specified by OUTPUTS1 into all the
%	inputs of system 2.  Positive feedback is assumed.  To connect 
%	with negative feedback, use negative values in the vector INPUTS1.
%
%	[NUM,DEN] = FEEDBACK(NUM1,DEN1,NUM2,DEN2,SIGN) produces the SISO
%	closed loop system in transfer function form obtained by 
%	connecting the two SISO transfer function systems in feedback 
%	with the sign SIGN.  
%	See also: CLOOP, SERIES.

%	Clay M. Thompson 6-26-90
%	Copyright (c) 1986-93 by the MathWorks, Inc.

error(nargchk(4,10,nargin));

% --- Determine which syntax is being used ---
if (nargin == 4)  % T.F. w/o sign -- Assume negative feedback
  [num1,den1] = tfchk(a1,b1); [num2,den2] = tfchk(c1,d1); sgn = -1;
end
if (nargin == 5)  % Transfer function form with sign
  [num1,den1] = tfchk(a1,b1); [num2,den2] = tfchk(c1,d1); sgn = sign(a2);
end

% --- Form Feedback connection of T.F. system ---
if (nargin==4)|(nargin==5)
    a = conv(num1,den2);
    b = conv(den1,den2) - sgn*conv(num1,num2);

elseif (nargin==6) | (nargin==7)
  error('Wrong number of input arguments.');

elseif (nargin >= 8)  % State space systems
  error(abcdchk(a1,b1,c1,d1));
  error(abcdchk(a2,b2,c2,d2));
  [ny1,nu1] = size(d1);
  [ny2,nu2] = size(d2);
  if (nargin == 8) % systems w/o sign -- assume negative feedback
    inputs1 = -[1:nu1];     outputs1 = [1:ny1];
    inputs2 =  [1:nu2]+nu1; outputs2 = [1:ny2]+ny1; 
  end
  if (nargin == 9) % State space systems with sign
    inputs1 = [1:nu1]*sign(e); outputs1 = [1:ny1];
    inputs2 = [1:nu2]+nu1;     outputs2 = [1:ny2]+ny1;
  end
  if (nargin == 10) % State space systems w/selection vectors
    inputs1 = e;           outputs1 = f;
    inputs2 = [1:nu2]+nu1; outputs2 = [1:ny2]+ny1;
  end

  % Check sizes
  if (length(outputs1)~=length(inputs2)) | (length(outputs2)~=length(inputs1))
    error('Feedback connection sizes don''t match.'); end

  % --- Form Closed-Loop Feedback System ---
  [a,b,c,d] = append(a1,b1,c1,d1,a2,b2,c2,d2);
  [a,b,c,d] = cloop(a,b,c,d,[outputs1,outputs2],[inputs2,inputs1]); % close loops
  [a,b,c,d] = ssselect(a,b,c,d,[1:nu1],[1:ny1]);
end
