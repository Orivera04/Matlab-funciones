function h= plot(L,X,Y,DataOK,Options,AxHand);
%XREGTRANSIENT/PLOT plot xregtransient with data
% 
% h= plot(m,X,Y,ax,BDflag,Trans,CI)
%
% Inputs
%   m        model
%   X        x data
%   Y        observed ydata
%   DataOK   logical array indicating whether data 
%   Options  [ShowBD,Trans,CI]
%   ax       axes handle
% Outputs
%   h        main data line handle

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:00 $


if nargin < 4 | isempty(DataOK);
	DataOK= isfinite(Y);
end
if nargin < 5
	Options= [1 0 1];
end
if nargin < 6
	ax= gca;
end
BDflag = Options(1) & ~all(DataOK);
Trans  = Options(2) & ~isempty(get(L,'ytrans'));
CI     = Options(3);

color= 'b.';


set(get(AxHand,'parent'),'CurrentAxes',AxHand)
% Plot regressed and actuals 

y= EvalModel(L,X);
if Trans
    Y= ytrans(L,Y);
    y= ytrans(L,y);
end
Xs= double(X);

if CI
	if CI==1
		alpha=0.95;
	else
		alpha= CI;
	end
	
	[ci_hi,ci_lo]= cicalc(L,Xs,y,alpha,Trans);   
    ciargs = {Xs(:,1),ci_lo, 'b--',Xs(:,1),ci_hi,'b--'};
else
    ciargs = {};
end
% Plot regressed and actuals.
if BDflag
    % display bad data 
    h=plot(X(:,1),Y,X(:,1),y,'.',ciargs{:},...
        'b-','LineWidth',1,'parent',AxHand,'bd');
else
    % don't display bad data 
    h=plot(X(:,1),Y,'.',X(:,1),y,'b-',ciargs{:},...
        'LineWidth',1,'parent',AxHand);
end
set(h(1),'tag','main line','Marker','.');
set(h(2),'LineStyle','-','Marker','none','hittest','off');
set(h(3:end),'Marker','none','hittest','off');

set(AxHand,'xgrid','on','ygrid','on');
yname= get(Y,'name');
yunits= get(Y,'units');
Fy= get(L,'ytrans');

set(get(AxHand,'ylabel'),...
    'string',ResponseLabel(L),...
    'interpreter','none',...
    'FontSize',8);


