function [m, centerdes, press]=centerdelete(m, x, y, centerdes,initpress,p,DO_DESIGNTYPE)
%DES_LINEARMOD/PDELETE   PRESS-optimal deletion used to select centers
% in rbf objects. 
%   [m, centerdes,PRESS]=PDELETE(M, x, y, centerdes, INITPRESS,P) deletes P lines from the design D
%   using PRESS-optimality.  A new design object and the new
%   PRESS value are returned. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:25 $

% Created 27/4/2001
% Tanya Morton, The MathWorks Limited

if nargin<7
   DO_DESIGNTYPE=0;
end
if DO_DESIGNTYPE
   [TP,INFO]=DesignType(centerdes);
end



pressnew=initpress;
for j=1:p      
  
   % perform stepwise to calculate the NextPress if each center was removed
   [m,OK,Stats,B]=stepwise(m);
   
   NextPress= B(:,end);

   TermsOut  = ~Terms(m);
   
   % don't want to put out terms back in again
   NextPress(TermsOut) = Inf;
   
   % find the worst center in the model
   [pressnew,i]=min(NextPress);
  
   % remove it from the design 
   centerdes=delete(centerdes,'indexed',i- sum(TermsOut(1:i-1)),'changeable');
   
   % remove it from the model (using qrdelete)
   [m,OK]=stepwise(m, i);
   
   
end

% remove it from the centers
set(m, 'centers', factorsettings(centerdes));

% decrease the size of the linearmod
m = update(m, zeros(size(m.centers,1),1));

% reinitialise the model with the new centers
[m, OK ]  = leastsq(m,x,y);

if DO_DESIGNTYPE
   % update design type
   centerdes=DesignType(centerdes,TP,INFO);         % reset object to initial setting
end

press=pressnew;
return





