function toggleterm(t)
%TERM_SELECTOR/TOGGLETERM   Callback function
%   Callback function for the term_selector object.  This
%   callback will not work from the command line.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.3 $  $Date: 2004/02/09 07:44:14 $


% This is the callback activated when a single term is
% toggled in/out of the model

obj=gcbo;
objud=get(obj,'userdata');
ud=get(t.xregtable,'userdata');
m=ud.model;

ind=find(ud.btnrows==objud.row);
val=get(obj,'value');
switch val
case 0
   tgcol=[0 0.85 0];
   stat=3;
   str='in';
case 1
   tgcol=[0.85 0 0];
   stat=2;
   str='out';
end

m=setstatus(m,ud.termsind(ind),stat);
m=SetTerm(m,ud.termsind(ind),(stat>2));

trms=terms2(m);
t.xregtable(objud.row,4).string=str;
t.xregtable(objud.row,4).backgroundcolor=tgcol;
% need to update appropriate checkbox
sect=sum((objud.row>ud.chboxrows));

chtp=sum(trms(ud.termsbrkstart(sect):(ud.termsbrkstart(sect)+ud.termsbreak(sect)-1)));

if chtp==0
   % empty checkbox
   set(t.xregtable,'cells.rowselection',[ud.chboxrows(sect) ud.chboxrows(sect)],...
      'cells.colselection',[1 1],...
      'cells.value',0,...
      'cells.enable','on',...
      'cells.buttondownfcn','');
elseif chtp==ud.termsbreak(sect)
   % full checkbox
   set(t.xregtable,'cells.rowselection',[ud.chboxrows(sect) ud.chboxrows(sect)],...
      'cells.colselection',[1 1],...
      'cells.value',1,...
      'cells.enable','on',...
      'cells.buttondownfcn','');
else
   % grey checkbox
   set(t.xregtable,'cells.rowselection',[ud.chboxrows(sect) ud.chboxrows(sect)],...
      'cells.colselection',[1 1],...
      'cells.value',1,...
      'cells.enable','off',...
      'cells.buttondownfcn',['checkterms(get(' sprintf('%20.15f',t.objecthandle) ',''userdata''));']);
end

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









