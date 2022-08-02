function [ax,txt]=infoaxes(tp,varargin)
%GRAPH2d/PRIVATE/INFOAXES   Private function
%  INFOAXES returns a set of axes and a text handle, ready for popping
%  up with point information in it.  The handle is retained in
%  persistent memory so the destroy function can operate reliably
%  Available arguments are 'new', 'current' and 'destroy'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:32 $

%  6/10/99
persistent i_ax i_txt

switch lower(tp)
case 'new'
   % destroy current
   if ishandle(i_ax)
      delete(i_ax);
   end
   % create new
   % must be an object in varargin
   gr=varargin{1};
   prnt=get(gr.axes,'parent');
   % place box where mouse is
   pos=get(prnt,'currentpoint');
   
   pos(3)=60;
   pos(4)=30;
   pos(2)=pos(2)-45;
   pos(1)=pos(1)+5;
   
   i_ax=axes('parent',prnt,...
      'visible','off',...
      'units','pixels',...
      'position',pos,...
      'color',[1 1 .85],...
      'box','on',...
      'xlim',[0 1],...
      'ylim',[0 1],...
      'xtick',[],...
      'ytick',[]);
   i_txt=text('parent',i_ax,...
      'clipping','on',...
      'position',[0.04 1],...
      'horizontalalignment','left',...
      'verticalalignment','top',...
      'fontsize',8);

case 'destroy'
   % destroy axes
   if ishandle(i_ax)
      delete(i_ax);
   end
   i_ax=[];
   i_txt=[]; 
end

if nargin
   ax=i_ax;
   if nargin>1
      txt=i_txt;
   end
end

return