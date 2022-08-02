function h= plot(L,Xd,Yd,DataOk,Options,AxHand);
% LOCALMOD/PLOT plot localmod with data
% 
% plot(L,X,Y,bdflag,Transform,AxHand,AbsX)
%  L         localmod object
%  X         sweepset data
%  Y         sweepset data
%  AxHand    axes to plot in
%  optional flags
%      bdflag    logical to show bad data  (1)
%      Transform logical to plot in ytrans (0)
%      CI        plot confidence intervals (1)
%      AbsX      to use X relative to datum (0)
%      ModelRange use bounds from model to determine plotting range

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.5 $  $Date: 2004/04/04 03:29:39 $

if nargin < 4
    % default data indicator
    DataOK= isfinite(double(Y));
end
if nargin < 5
    Options= [1 0 1 1 1];
end
if nargin < 6
    AxHand= gca;
end

if length(Options)==3
    Options(4:5)= [0 0];
end

BDflag    = Options(1) ;

Fy= get(L,'ytrans');
Transform = Options(2) & ~isempty(Fy);
CI        = Options(3);
AbsX      = Options(4);
ModelRange= Options(5);

%% define the color for local fit and conf intervals
%LocCol= [1 0.5 0.25];
LocCol= 'k';

% OK data for plot
X= double(Xd(DataOk,:));
Y= double(Yd(DataOk));


Types= InputFactorTypes(L);

xdat   = xinfo(L);
ydat   = yinfo(L);
ylabstr= ResponseLabel(L,Transform);

% record of lines already on axes
hOld= findobj(AxHand,'type','line');

set(get(AxHand,'parent'),'CurrentAxes',AxHand)
PredvObs= length(find(Types==1)) > 1;
if PredvObs %% when multiple local factors
    % plot Y vs yhat
    yhat= EvalModel(L,X);
    Xvar=Y;
    lims=[min(min(Y,yhat)) max(max(Y,yhat))];
	 xlims=lims;
    if Transform
        Xvar(:,:)= Fy(Xvar);
		  xlims= Fy(lims);
    end
    
	 
    % draw line
    h= line('parent',AxHand,...
        'color','b',...
        'linestyle','none',...
        'Marker','.','MarkerSize',15,...
        'xdata',Xvar,...
        'ydata',yhat);
    % also plot the line y=x
    line(xlims,lims,'marker','none','linestyle','-',...
        'color','k','hittest','off','parent',AxHand);
    xlabstr= ylabstr;
    ylabstr = ['Predicted ', ylabstr];
else
    % plot Y vs X
    [h,Xvar] = i_plotYvX(L,X,Y,AbsX,ModelRange,AxHand);
    xlabstr = InputLabels(L);
    if AbsX
        % 		xlabstr= xdat.Symbols{1};
        xlabstr = xlabstr{1};
    else
        % 		xlabstr= [xdat.Symbols{1} ' - DATUM'];
        xlabstr = [xlabstr{1} ' - DATUM'];
    end
	 
end

annotate(L,X,Y,AxHand);

set(get(AxHand,'xlabel'),...
    'string',xlabstr,...
    'interpreter','none',...
    'FontSize',8);
set(AxHand,'xgrid','on','ygrid','on');
%set(get(AxHand,'title'),'string',sprintf('Test %2g',testnum(Yd)),'FontWeight','bold');

if Transform
    % this transforms all the new data
    hnew= findobj(AxHand,'type','line');
    hnew= setdiff(hnew,hOld);
    for i=1:length(hnew);
        yd= get(hnew(i),'ydata');
        yd= Fy(yd);
        set(hnew(i),'ydata',yd);
    end
end
set(get(AxHand,'ylabel'),...
    'string',ylabstr,...
    'interpreter','none',...
    'FontSize',8);

if CI
    
    d=datum(L); 
    Xs= code(L,X);
    ndatum= Xd(DataOk,:);
    ndatum(:,:)= code(L,double(ndatum));
    
    if Transform & ~isempty(Fy)
        % transformed yhat and sigma(yhat)^2
        p   = evalpev(Xs,L);
        yhat= eval(L,Xs);
        if isTBS(L)
            yhat= Fy(yhat);
        end
    else
        % untransformed yhat and sigma(yhat)^2
        [p,yhat] = pev(L,Xs,0);
    end
    
    alpha= 0.95;
    
    % build confidence intervals
    df= length(Y)-size(L,1) ;
    ts= tinv(1-(1-alpha)/2,df)*sqrt(p);
    ci_lo= yhat-ts;
    ci_hi= yhat+ts;
    
    if size(Y,1)<100
        % make plot lines with bars at top and bottom
        nanm= repmat(NaN,size(Y));
        d= (max(Xvar)-min(Xvar))/150;
        xci= [Xvar,Xvar,nanm,Xvar-d,Xvar+d,nanm,Xvar-d,Xvar+d,nanm]';
        yci= [ci_hi,ci_lo,nanm,ci_lo,ci_lo,nanm,ci_hi,ci_hi,nanm]';
        style= '-';
    else
        % plot ci envelope as dashed lines
        nanm= repmat(NaN,size(Y));
        d= (max(Xvar)-min(Xvar))/150;
        xci= [Xvar,Xvar,nanm]';
        yci= [ci_hi,ci_lo,nanm]';
        style= '-';
    end
    % do plot of ci lines
    tmp=plot(xci(:),yci(:),style,'parent',AxHand,'color',LocCol);
    set(tmp,'tag','localCI');
end


if  BDflag;
    % show outlier points
    
    bdX= double(Xd(~DataOk,:));
    bdY= double(Yd(~DataOk));
    if ~isempty(bdY)
        if PredvObs 
            % plot observed on X axis, and predicated on Y axis
            bdXvar = bdY;
            bdY = EvalModel(L,bdX);
            if Transform 
                bdXvar= Fy(bdXvar);
            end
        else
            if AbsX
                bdXvar= bdX;
            else
                bdXvar= code(L,bdX);
            end
        end
        if Transform 
            bdY= Fy(bdY);
        end
        
        if ~isreal(bdY)
            % handle imaginary transforms
            bdY(abs(imag(bdY))>eqrt(eps))= NaN;
            bdY= real(bdY);
        end
        
        plot(bdXvar(:,1), bdY, 'x',...
            'parent',AxHand,...
            'MarkerEdgeColor','b',...
            'linewidth',2,...
            'markersize',8,...
            'tag','BDPts');
    end
end


%------------------------------------------------------
% subfunction i_plotYvX
%------------------------------------------------------
function [h,negdelta] = i_plotYvX(L,X,Y,AbsX,ModelRange,AxHand)

%LocCol= [1 0.5 0.25];
LocCol = 'k';

Datum= datum(L);
if ~(L.DatumType & isfinite(Datum))
    negdelta= X(:,1);
    if ~isfinite(Datum)
        color= 'r.'; % this variable never used?
    end
    Datum=0;
else
    % Setup -MBT array for plotting purposes.
    if AbsX 
        negdelta= X(:,1);
    else
        negdelta= X(:,1)-Datum;
    end
end

% Setup arrays for plotting modelled response.
if any(L.Values~=0)
    fVals= unique(L.Values+Datum);
elseif L.DatumType
    fVals= Datum;
else
    fVals=[];
end

% find some ranges
LB= min([fVals;double(X(:,1))]);
UB= max([fVals;double(X(:,1))]);
if ModelRange
    bnds= getcode(L);
    if ~((bnds(1)==-1 | bnds(1)==0)  & bnds(1,2)==1) 
        LB= bnds(1,1);
        UB= bnds(1,2);
    end
end

x= linspace(LB,UB,101)';

if (AbsX) 
    xd=x;
    d= Datum;
else
    xd = x-Datum;
    d=0;
end

% Predicted values
if nfactors(L)==1
    y= EvalModel(L,x);
else
    xd=X(:,1);
    y= EvalModel(L,X);
end
% draw local fit line (color = LocCol)
line('parent',AxHand,...
    'tag','localfit',...
    'color',LocCol,...
    'xdata',xd,...
    'ydata',y);

% draw blue local data points
h= line('parent',AxHand,...
    'color','b',...
    'Marker','.',...
    'MarkerSize',15,...
    'LineStyle','none',...
    'xdata',negdelta,...
    'ydata',Y);

if any(L.Values~=0)
    % response features at function values
    line('XData',fVals-Datum+d,'YData',EvalModel(L,fVals),...
        'Marker','+',...
        'tag','localfcnvals',...
        'color','r',...
        'LineWidth',1.5,...
        'linestyle','none',...
        'parent',AxHand)
end
if L.DatumType
    % display datum point
    line('XData',d,'YData',EvalModel(L,Datum),...
        'LineWidth',1.5,...
        'tag','localdatum',...
        'Marker','*','color','r',...
        'linestyle','none',...
        'parent',AxHand)
end

