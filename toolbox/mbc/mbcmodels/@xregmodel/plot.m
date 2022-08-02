function h= plot(m,X,Y,DataOK,Options,ax)
% MODEL/PLOT - PLOT THE PREDICTED VS OBSERVED RESPONSE
%
% h= PLOT(m,X,Y,ax,BDflag,Trans,CI)
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


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:52:53 $

% determine the number of input factors

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
Trans  = Options(2) & ~isempty(m.ytrans);
CI     = Options(3);


numFac= nfactors(m);

% OK data for plot
Xs= double(X(DataOK,:));
Ys= double(Y(DataOK,:));

yhat= EvalModel(m,Xs);

if Trans & ~isempty(m.ytrans)
	
	Ys=   m.ytrans(Ys);
	yhat= m.ytrans(yhat);
else
	Trans=0;
end

xdat   = xinfo(m);
ydat   = yinfo(m);
ylabstr= ResponseLabel(m,Trans);

Types= InputFactorTypes(m);

if length(find(Types==1)) > 1   %% glob model has >1 input factors
	% plot yhat vs Ys
	Xvar=Ys;
	lims=[min(min(Ys,yhat)) max(max(Ys,yhat))];
	loc = line(lims,lims,...
		'tag','localfit',...
		'linewidth',0.5,...
		'color',[0 0 0],...
		'hittest','off','parent',ax);
%	titlestr= sprintf('Predicted %s vs %s',ylabstr,ylabstr);
	xlabstr= ylabstr;
	ylabstr= ['Predicted ',ylabstr];
	Ys= yhat;
else %% one input factor (maybe others but only for dynamic model)
	% plot Y vs X
	Xvar= Xs(:,1);
	[LB,UB]=range(m);
	newx= [linspace(LB,UB,100)]';	
	yline= EvalModel(m,newx);
	if Trans
		yline= m.ytrans(yline);
	end
	loc = line('xdata',newx,'ydata',yline,...
        'tag','localfit',...
        'linewidth',0.5,...
        'color',[0 0 0],...
        'hittest','off','parent',ax);
	xlab =InputLabels(m);
	
	xlabstr= xlab{1};
	titlestr= [ylabstr,' vs ',xlabstr];
end
h= line('xdata',Xvar,'ydata',Ys,...
	'color','b',...
	'marker','o',...
	'linestyle','none',...
	'parent',ax,...
	'buttondownfcn','diagnosticPlots(modeldev,''click'',gcbo)',...
	'tag','main line',...
    'markerfacecolor','b',...
	'markersize',5);

if CI & pevcheck(m);
	if CI==1
		alpha=0.95;
	else
		alpha= CI;
	end
	
	[ci_hi,ci_lo]= cicalc(m,Xs,yhat,alpha,Trans);
	
	if length(Xvar)<100
		nanm= repmat(NaN,size(Ys));
		d= (max(Xvar)-min(Xvar))/150;
		xci= [Xvar,Xvar,nanm,Xvar-d,Xvar+d,nanm,Xvar-d,Xvar+d,nanm]';
		yci= [ci_hi,ci_lo,nanm,ci_lo,ci_lo,nanm,ci_hi,ci_hi,nanm]';
      style= '-';
  else
      nanm= repmat(NaN,size(Ys));
      xci= [Xvar,Xvar,nanm]';
      yci= [ci_hi,ci_lo,nanm]';

      style= '-';
	end
	
	line('xdata',xci(:),'ydata',yci(:),...
        'linestyle',style,....
        'tag','localCI',...
        'parent',ax,'hittest','off');
end

if  BDflag;
	% show outlier points
	
	bdX= double(X(~DataOK,:));
	bdY= double(Y(~DataOK));
	
   if Trans 
      bdY= m.ytrans(bdY);
   end
   if numFac > 1
      bdYvar= EvalModel(m,bdX);
		bdXvar= bdY;
      if Trans 
         bdYvar= m.ytrans(bdYvar);
      end
	else
		bdXvar= bdX;
		bdYvar= bdY;
   end
   
	if ~isreal(bdYvar) | ~isreal(bdXvar)
		% handle imaginary transforms
		bdXvar(abs(imag(bdXvar))>sqrt(eps))= NaN;
		bdXvar= real(bdXvar);
		bdYvar(abs(imag(bdYvar))>sqrt(eps))= NaN;
		bdYvar= real(bdYvar);
	end
	
	ok= all(isfinite(bdXvar),2) & isfinite(bdYvar);
	
	plot(bdXvar(ok),bdYvar(ok),'x',...
		'parent',ax,...
		'linewidth',2,...
		'markersize',8,...
		'tag','BDPts');
end



yname= ydat.Name;
yunits= char(ydat.Units);


set(get(ax,'ylabel'),...
    'string',ylabstr,...
    'fontweight','bold',...
    'interpreter','none',...
    'FontSize',8);


% Title grid etc.
tH=get(ax,'title');
% set(tH,'string',titlestr,...
% 	'interpreter','none',...
% 	'fontweight','bold');
xH=get(ax,'xlabel');   
set(xH,'string',xlabstr,...
	'interpreter','none',...
	'fontweight','bold');

annotate(m,Xs,Ys,ax);
