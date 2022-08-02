function rsdout=doptimise(rsd,bindtogui, initfcn, updatefcn, stopfcn);
% DES_RESPSURF/DOPTIMISE   Optimise design using d-optimality.
%   D=DOPTIMISE(D) optimises the design in D using d-optimality.
%   The current settings for the number of iterations etc are used,
%   and the starting point is the current design - use reinit to
%   create a new design first if desired.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.3 $  $Date: 2004/02/09 07:03:31 $


if nargin<2
   bindtogui=0;
end
% check initial design is a valid one.
if ~rankcheck(rsd)
   error('The initial design is rank-deficient.  Please re-initialize it and try again.');
   return
end

% initialise any gui output
if bindtogui
   % gui output section
   xregcallback(initfcn,rsd,[]);  
   count=1;
end
next=1;
% turn off extra waitbars
wbstate=waitbars(rsd);
rsd=waitbars(rsd,0);

% turn off time stamping to save a little time
rsd=stamping(rsd,0);
% continuous loop: broken by a stop call
rsd=stop(rsd,'reset');
brk=0;
p=rsd.p;
if ~allowreps(rsd) & p>ncandleft(rsd)
   p=ncandleft(rsd);
end

qold=[];
% check for full optimal algorithm: switch q to 1 if its on
if strcmp(lower(rsd.augmentmethod), 'optimal') & strcmp(lower(rsd.deletemethod), 'optimal')
   qold=rsd.q;
   rsd.q=1;
end

while ~brk & next   % "next" flag is a gui method for breaking the optimisation
   oldpsi=dcalc(rsd);
   
   % take a copy of design object
   desobj=getdesign(rsd);
   
   % Augment design
   switch lower(rsd.augmentmethod);
   case 'random'
      rsd=augment(rsd,p);
      newpsi=dcalc(rsd,1);
   case 'optimal'
      [rsd,newpsi]=daugment(rsd,p,oldpsi,0);
   end
   
   % Remove lines
   switch lower(rsd.deletemethod);
   case 'random'
      rsd=delete(rsd,'random',p);
      newpsi=dcalc(rsd,1);
   case 'optimal'
      [rsd, newpsi]=ddelete(rsd,newpsi,p,0);
   end
   
   % ask if stop criterion met
   [brk, rvrt,rsd]=stop(rsd,'d',oldpsi,newpsi);
   
   if rvrt
      % push old factor matrix back in
      % need a way of doing this that will preserve design space indices
      rsd=setdesign(rsd,desobj);
      newpsi=oldpsi;
   end
   
   if bindtogui
      evt.newpsi=newpsi;
      evt.iteration=iteration(rsd);
      evt.q=qnow(rsd);
      % gui output section
      if count>=next | brk
         if iscell(updatefcn)
            next=feval(updatefcn{1},rsd,evt,updatefcn{2:end});
            count=1;
         else
            count=feval(updatefcn,rsd,evt);
         end
      else
         count=count+1;
      end
   end
end

if ~isempty(qold)
   rsd.q=qold;
end

% finish any gui output
if bindtogui
   xregcallback(stopfcn,rsd,[]);
end

rsd=optimisetype(rsd,'D-optimal');
rsd=DesignType(rsd,1,'D-optimal');
rsd.optimisedon.cand=candstate(rsd);
rsd.optimisedon.design=designstate(rsd);
rsd.optimisedon.model=modelstate(rsd);

rsd=stamping(rsd,1);
rsd=timestamp(rsd,'stamp');
rsd=waitbars(rsd,wbstate);

[newv,rsd]= vcalc(rsd,1);
[newg,rsd]= gcalc(rsd,1);
[newd,rsd]= dcalc(rsd,1);
[newd,rsd]= acalc(rsd,1);

if ~nargout
   % place des back into caller workspace
   nm=inputname(1);
   assignin('caller',nm,rsd);
else
   rsdout=rsd;
end
