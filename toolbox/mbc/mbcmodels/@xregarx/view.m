function hFig=view(m,VarName,action,varargin)
%XREGARX/VIEW   View the ARX model in a figure.
%   VIEW(M,...) is a slight extension of XREGMODEL/VIEW to handle dynamic ARX 
%   models. The main difference between XREGARX/VIEW and XREGMODEL/VIEW is that 
%   the former has extra set of coding (for the embedded static model) to 
%   display.
%
%   See also XREGMODEL/VIEW.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:47 $

if nargin<2 | ~isempty(VarName)
    action='figure';
    if nargin>1
        varargin={action};
    end
end

switch lower(action)
case 'figure'
    hFig=i_createfig(m,varargin{:});
case 'inaxes'
    [hFig(1),hFig(2)]=i_createtext(m,varargin{:});
end

%------------------------------------------------------------------------------|
function hFig=i_createfig(m,VarName)
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
        'visible','off',...
        'resize','off',...
        'position',[Spos(3)*.05 Spos(4)*.5 fp]);
    hFig= double(hFig);
    
    ah= axes('parent',hFig,...
        'units','pixels',...
        'visible','off',...
        'position',[0 0 fp]);
    ah= double(ah);
else
    delete(get(get(hFig,'CurrentAxes'),'child'))
    ah= double(get(hFig,'CurrentAxes'));
end

if nargin==1
    [H,W]=i_createtext(m,ah);
else
    [H,W]=i_createtext(m,ah,VarName);
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


%------------------------------------------------------------------------------|
function [H,W]=i_createtext(m,ah,VarName)

Expr =   str_code(m,1); 
SMExpr = str_code(m.StaticModel,1); % get the coding info for the embedded static model
fX =     str_func(m,1);
ytrans = str_yinv(m,1);
chModel = char(m,1);
if nargin<3
    yi = yinfo( m );
    VarName= yi.Name;
end
VarName= detex(VarName);

str=[{['Model for ',VarName]};... % Description
        {'Coding'}; ...
        Expr(:); ...       % Coding
        {fX};...                 % Function description
        cellstr(chModel); ...       % Equation display                  
        {'Coding of Static Model'};...
        SMExpr(:)]  ;            % Static model Coding


bold   = [ 1; 1; zeros(length(Expr),1); 1; zeros(size(chModel,1),1); 1; zeros(length(SMExpr),1) ];
indent = [ 0; 0;  ones(length(Expr),1); 0;  ones(size(chModel,1),1); 0;  ones(length(SMExpr),1) ];

% Transform
if ~isempty(ytrans);
    str=[str;{'Y Transformation';[detex(m.Yinfo.Name),' = ',ytrans]}];
    bold=[bold;1;0];
    indent=[indent;0;1];
end 

[H,W]=xregtextlist(ah,[0 0 0],str,indent,bold,7,15);

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
