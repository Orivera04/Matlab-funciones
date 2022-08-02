function [out, rvrt, rsdout]=stop(rsd,tp,varargin)
% DES_RESPSURF/STOP   defines stopping criteria
%   S=STOP(D,CRIT,OLDPSI,NEWPSI) returns S=1 if the stopping criteria
%   defined in D is met and S=0 otherwise.  CRIT indicates the 
%   optimality criterai being used: 'd' or 'v'.
%   [S RVRT]=STOP(D,CRIT,OLDPSI,NEWPSI) also returns a flag indicating
%   whether a previous design should be reverted to, i.e. whether a single
%   psi comparison has failed the test.
%   [S RVRT D]=STOP(D,CRIT,OLDPSI,NEWPSI) returns the design object.
%   If the D output is not included, the workspace copy of D will be
%   updated anyway.  This is necessary to maintain the failure counters.
%
%   D=STOP(D,'reset') reset's the 'q' counter in D which 
%   measures the number of successive stop conditions.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:58 $

if nargin==2
   % reset q
   if strcmp(lower(tp),'reset')
      rsd.qnow=0;
      rsd.iternow=0;
   end
   if ~nargout
      nm=inputname(1);
      assignin('caller',nm,rsd);
   else
      out=rsd;
   end
else   
   DELTA= varargin{2}-varargin{1};
   % rank check the new design
   ROK=rankcheck(rsd);
   
   % do optimal-specific stuff
   switch lower(tp)
   case 'd'
      % increment 'not worth it' counter
      if (DELTA)<=rsd.delta
         rsd.qnow=rsd.qnow+1;
      else
         % reset q counter
         rsd.qnow=0;
      end
      % decide whether to keep new design
      if (DELTA < 1e-12 & ROK)
         r=1;
      else
         r=0;
      end
      
   case {'v','a'}
      % opposite way round from d
      % increment 'not worth it' counter
      if -(DELTA)<=rsd.delta
         rsd.qnow=rsd.qnow+1;
      else
         % reset q counter
         rsd.qnow=0;
      end
      % decide whether to keep new design
      if (-DELTA <1e-12 & ROK)
         r=1;
      else
         r=0;
      end
   end   
   
   % decide stop output
   rsd.iternow=rsd.iternow+1;
   if (rsd.qnow>=rsd.q) | (rsd.iternow>=rsd.maxiter)
      out=1;
   else
      out=0;
   end
   
   % sort out appropriate outputs
   if nargout>1
      rvrt=r;
   end
   if nargout>2
      rsdout=rsd;
   end
   if nargout<3
      % We *must* place smod back in workspace to retain q counter
      nm=inputname(1);
      assignin('caller',nm,rsd);   
   end
end

return
