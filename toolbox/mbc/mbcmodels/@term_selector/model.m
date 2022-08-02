function [mout]=model(t,m)
%TERM_SELECTOR/MODEL - get/set model in term_selector object
%   
%   MODEL(t,m) gives a model to a term_selector object for it to 
%   display term status in.
%   m=MODEL(t) returns current model in term_selector.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 07:41:46 $

%

ud=get(t.xregtable,'userdata');
if nargin==1
   mout=ud.model;
else
   lbls=labels(m);
   %  must get terms in display order
   trms=terms2(m);
   [tind,trmsorder,strs]=termorder(m);
   % trmsorder gives me the number of terms in each section (linear, 2nd order,etc)
   % make checkbox indices
   chbox=cumsum([0 trmsorder(1:(end-1))]+1);
   btns=[1:(chbox(end)+trmsorder(end))];
   btns(chbox)=[];
   
   fulldraw=0;
   % check to see if model is same as current
   if isempty(ud.model)
      fulldraw=1;
   else
      % check placement of bits
      if (length(ud.chboxrows)~=length(chbox)) | (length(ud.btnrows)~=length(btns))
         fulldraw=1;
      elseif ~(all(ud.chboxrows==chbox) & all(ud.btnrows==btns))
         fulldraw=1;
      end
   end
   
   ud.model=m;
   if fulldraw
      % First make invisible dummy cell
      t.xregtable.redrawmode='basic';
      clear(t.xregtable);
      t.xregtable(btns(end),5).type='uipushbutton';
      t.xregtable(btns(end),5).visible='off';
      t.xregtable.cols.fixed=5;
      %t.xregtable.redraw;
      
      % start with togglebuttons, then do fixed cols, then work backwards
      t.xregtable(btns,4).type='uitogglebutton';
      t.xregtable(btns,4).callback=['toggleterm(get(' sprintf('%20.15f',t.objecthandle) ',''userdata''));'];

      t.xregtable(btns,3).type='text';
      t.xregtable(btns,3).horizontalalignment='right';
      
      t.xregtable(chbox,2).type='text';
      t.xregtable(chbox,2).horizontalalignment='left';
      t.xregtable(chbox,1).type='uicheckbox';
      t.xregtable(chbox,1).backgroundcolor=t.xregtable.frame.color;
      t.xregtable(chbox,1).callback=['checkterms(get(' sprintf('%20.15f',t.objecthandle) ',''userdata''));'];
      t.xregtable(:,:).fontsize=8;
      
     % t.xregtable.redraw;
      %t.xregtable.redrawmode='normal';
   end
   
   %update data
   t.xregtable.redrawmode='basic';
   t.xregtable(btns(~trms),4).backgroundcolor=[.85 0 0];
   t.xregtable(btns(~trms),4).string='out';
   t.xregtable(btns(trms),4).string='in';
   t.xregtable(btns(trms),4).backgroundcolor=[0 .85 0];
   t.xregtable(btns,4).value=~trms;
   
   t.xregtable(btns,3).string=lbls;
   
   t.xregtable(chbox,2).string=strs;
   
   % Decide what each checkbox should look like.
   % need to split terms up into sections
   
   st_ind=1;
   for m=1:length(trmsorder)
      chtp=sum(trms(st_ind:(st_ind+trmsorder(m)-1)));
      if chtp==0
         % empty checkbox
         t.xregtable(chbox(m),1).enable='on';
         t.xregtable(chbox(m),1).value=0;
      elseif chtp==trmsorder(m)
         % full checkbox
         t.xregtable(chbox(m),1).value=1;
         t.xregtable(chbox(m),1).enable='on';
      else
         % grey checkbox
         t.xregtable(chbox(m),1).value=1;
         t.xregtable(chbox(m),1).enable='off';
         t.xregtable(chbox(m),1).buttondownfcn=['checkterms(get(' sprintf('%20.15f',t.objecthandle) ',''userdata''));'];
      end
      st_ind=st_ind+trmsorder(m);
   end
   t.xregtable.redraw;
   t.xregtable.redrawmode='normal';
   % keep some useful stuff in memory
   ud.btnrows=btns;
   ud.chboxrows=chbox;
   ud.termsind=tind;
   ud.termsbreak=trmsorder;
   ud.termsbrkstart=cumsum([1 trmsorder(1:end-1)]);
   
   set(t.xregtable,'userdata',ud);   
end







