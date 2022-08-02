function hFig=view(m,VarName,varargin)
% MODEL/VIEW view model in figure
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:39:45 $

if nargin<2 | ischar(VarName)
   action='figure';
   if nargin>1
      varargin=[{VarName},varargin];
   end
else
   action=varargin{1};
   varargin=varargin(2:end);
end


switch lower(action)
case 'figure'
   hFig=i_createfig(m,varargin{:});
case 'inaxes'
   [hFig(1),hFig(2)]=i_createtext(m,varargin{:});
end





function hFig= i_createfig(m,VarName,tnum,Pooled_RMSE)

oldU= get(0,'units');
set(0,'units','pixel');
Spos= get(0,'ScreenSize');
set(0,'units',oldU);

hFig= mvf('mvModelView');
if isempty(hFig)
	
	fp= [600 min(Spos(4)*.5,500)];
   hFig=xregfigure(...
      'Tag','mvModelView',...
      'Name','Model Viewer',...
		'position',[Spos(3)*.05 Spos(4)*.3 fp],...
      'visible','off',...
      'resize','off');
   hFig= double(hFig);
	
   ah= axes('parent',hFig,...
      'visible','off',...
		'units','pixels',...
      'position',[0 0 fp]);
	ah= double(ah);
else
   delete(get(get(hFig,'CurrentAxes'),'child'))
   ah= double(get(hFig,'CurrentAxes'));
end


if nargin==1
   [H,W]=i_createtext(m,ah);
else
   [H,W]=i_createtext(m,ah,VarName,tnum,Pooled_RMSE);
end

% Resize Figure
FSize= get(hFig,'position');
FSize(4)= min(H+30,Spos(4));
FSize(2)= min(Spos(4)-FSize(4)-60,FSize(2));
FSize(3)= min(W+40,Spos(3));
FSize(1)= min(Spos(3)-FSize(3)-60,FSize(1));


set(hFig,'position',FSize);
set(ah,'position',[10 25 FSize(3:4)-[20 20]]);
figure(hFig)
return


function [H,W]=i_createtext(m,ah,VarName,tnum,Pooled_RMSE)

yi= yinfo(m);
if nargin<3
   VarName= yi.Name;
   tnum= NaN;
   Pooled_RMSE=1;
end
VarName= detex(VarName);

Expr =    str_code(m,1);
fX =      str_func(m,1);
ytrans =  str_yinv(m,1);

% display fitted equation
eqn= char(m);
yvar= detex(yi.Name);
if size(eqn,1)>1
	eqn= [[str2mat([yvar,' = '],repmat(' ',size(eqn,1)-1,length(yi.Name)+3))] eqn];
else
	eqn= [yvar,' = ',eqn];
end      

% should also display covariance model
cov= char(covmodel(m),1,Pooled_RMSE^2);

str= {eqn,cov};
if DatumType(m)
   str= [str, {sprintf('Datum= %.4g',datum(m))}];
end

chModel= cellstr(char(str));


if isfinite(tnum)
   tstr= ['Local Model for ',VarName,sprintf(' : Test %d',tnum)];
else
   tstr= 'Local Model';
end
str=[{tstr};...         % Description
      {'Coding'};...    
      Expr(:);...     % Coding
      {fX};...        % Function Description
      chModel];     % Equation display

bold=[1; 1; zeros(length(Expr),1); 1; zeros(length(chModel),1)];
indent=[0; 0; ones(length(Expr),1); 0; ones(length(chModel),1)];

if ~isempty(ytrans);
   str=[str;...
         {'Y Transformation';...
            [detex(yi.Name),' = ',ytrans]}];
   bold=[bold;1;0];
   indent=[indent;0;1];
end 

[H,W]=xregtextlist(ah,[0 0 0],str,indent,bold,7,15);