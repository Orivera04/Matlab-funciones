function [tb, btns]=xregtoolbar(fH, tps, varargin)
%XREGTOOLBAR  Create an xregGui.uitoolbar
%
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:34:40 $

if ~isa(fH,'xregGui.uitoolbar')
   fH=xregGui.uitoolbar(fH,'visible','off');
end

nB=length(tps);
if nB
   matches=['uipushtool  ';'uitoggletool'];   
   fH.setRedraw(false);
   for n=1:nB
      idx= strmatch(tps{n},matches);
      if idx==1
         btns(n)=xregGui.uipushtool(fH);
         
      else
         btns(n)=xregGui.uitoggletool(fH);
      end
   end
   if length(varargin)
      set(btns,varargin{:});
   end
   fH.setRedraw(true);
   fH.drawToolBar;
end
tb=fH;