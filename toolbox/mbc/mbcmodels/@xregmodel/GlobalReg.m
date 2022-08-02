function varargout= GlobalReg(m,action,varargin)
% This sets up the neural network problem.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:07 $
switch lower(action)
case 'create'
   varargout{1}=i_create(varargin{:},m);
case 'update'
   i_updatemodel;
case 'view'
   i_View(varargin{:});
case 'show'
   varargout{1}= i_show(varargin{:});
case 'hide'
   i_hide(varargin{:});
case 'subfigure'
   varargout{1}= i_SubFigure(varargin{:});
case 'globalmenus'
   % model dpt menus
   varargout{1}= [];
end


% -----------------------------------------
% function i_create
% -----------------------------------------
function View= i_create(fParent,TabObj,View,m);

return


% -----------------------------------------
% function i_show
% -----------------------------------------
function View= i_show(hFig,View,p);


% -----------------------------------------
% function i_View
% -----------------------------------------
function i_View(hFig,View,p);


% -----------------------------------------
% function i_hide
% -----------------------------------------
function i_hide(hFig,View,p);
%hide(View.UniTab);

% -----------------------------------------------
% function i_SUBFIGURE
% -----------------------------------------------
% open subfigures
function chH= i_SubFigure(Action,hFig,p);

if nargin<2
   hFig=gcbf;
   p= get(MBrowser,'currentNode');
end

chH=[];
switch lower(Action)
case 'transform'
   msgbox(sprintf('Y-Trans not available for %s models.',class(p.model)),...
      'Y-Transform');
   return
case 'fitmodel'
   p.fitmodel;
   ViewNode(MBrowser);
case 'fitopts'
   [m,ok]=gui_globalmodsetup(p.model);
   if ok
      p.model(m);
   end
end
