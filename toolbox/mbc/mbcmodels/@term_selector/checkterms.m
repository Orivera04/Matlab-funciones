function checkterms(t)
%TERM_SELECTOR/CHECKTERMS   Callback function
%   Callback function for the term_selector object.  This
%   callback will not work from the command line.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.3 $  $Date: 2004/02/09 07:41:44 $


% This is the callback activated when a a section of terms
% is toggled in/out of the model

obj=gcbo;
objud=get(obj,'userdata');
ud=get(t.xregtable,'userdata');
m=ud.model;

% determine state of object
if strcmp(get(obj,'enable'),'on')
   % checkbox was on or off
   if get(obj,'value')
      % was off
      % go to on
      tgcol=[0 0.85 0];
      stat=3;
      str='in';
      val=0;
   else
      % was on
      % go to off
      tgcol=[0.85 0 0];
      stat=2;
      str='out';
      val=1;
   end  
else
   % checkbox was partial (grayed)
   % go to off
   set(obj,'buttondownfcn','','enable','on','value',0);
   tgcol=[0.85 0 0];
   stat=2;
   str='out';
   val=1;
end

% get section
sect=find(objud.row==ud.chboxrows);

% update model
m=setstatus(m,ud.termsind(ud.termsbrkstart(sect):(ud.termsbrkstart(sect)+ud.termsbreak(sect)-1)),stat);
m=SetTerm(m,ud.termsind(ud.termsbrkstart(sect):(ud.termsbrkstart(sect)+ud.termsbreak(sect)-1)),(stat>2));

% update table
t.xregtable(ud.btnrows(ud.termsbrkstart(sect):(ud.termsbrkstart(sect)+ud.termsbreak(sect)-1)),4).backgroundcolor=tgcol;
t.xregtable(ud.btnrows(ud.termsbrkstart(sect):(ud.termsbrkstart(sect)+ud.termsbreak(sect)-1)),4).string=str;
t.xregtable(ud.btnrows(ud.termsbrkstart(sect):(ud.termsbrkstart(sect)+ud.termsbreak(sect)-1)),4).value=val;

ud.model=m;
set(t.xregtable,'userdata',ud);

if ~isempty(ud.updatefunction)
   % parse for %model
   if ~iscell(ud.updateparams)
      ud.updateparams={ud.updateparams};
   end
   
   for m=1:length(ud.updateparams)
      if ischar(ud.updateparams{m})
         if strcmp(ud.updateparams{m},'%MODEL')
            ud.updateparams{m}=ud.model;
         end
      end
   end
   feval(ud.updatefunction,ud.updateparams{:})
end

