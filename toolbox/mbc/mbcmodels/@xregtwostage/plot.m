function [varargout]= plot(varargin)
% TWOSTAGE/PLOT
% 
% h= plot(TS,X,Y,PlotOpts,axhand);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 08:00:10 $

ap= nargin;
if ishandle(varargin{ap})
    AxHand= varargin{ap};
    ap= ap-1;
else
    AxHand= gca;
end

PlotOpts= varargin{ap};
% plotopts must be a row vector
if (islogical(PlotOpts) | isnumeric(PlotOpts)) & size(PlotOpts,1)==1 & (numel(PlotOpts)==5 | numel(PlotOpts)==6)
    PlotOpts= num2cell(PlotOpts);
    if numel(PlotOpts)==5
        % CalcPRESS
        PlotOpts{6}= 0;
    end
    ap= ap-1;
else
    PlotOpts   = {0,0,0,1,0,0};
end

[bdflag,Trans,CIFlag,AbsX,ModelRange,CalcPRESS]= deal(PlotOpts{:});
if CalcPRESS
    % turn off CI's
    CIFlag=0;
end

X= varargin{ap-1};
Xs= double(X{1});

XG= X{2};

Ys= varargin{ap};
ap= ap-2;
AllTSModels= varargin(1:ap);

TS= AllTSModels{1};
Xsc= code(TS,Xs,1:nlfactors(TS));


%% set list of styles for validation tool mulitselect
MarkerStyles= get(AxHand,'linestyleorder');
%% if plotting regular twostage at local node, want dots, not ML default '-'
if ~iscell(MarkerStyles)
    MarkerStyles= {'.'};
end

while length(MarkerStyles)<length(AllTSModels);
    MarkerStyles=[MarkerStyles;MarkerStyles];
end

% cell arrays for building plots
fitPlot= cell(3*length(AllTSModels),1);
pointPlot= fitPlot;
CIPlot= fitPlot;

if CIFlag==1
    alpha= 0.975;
else
    alpha= 1-(1-CIFlag/100)/2;
end

% find default degrees of freedom
df1=dferror(AllTSModels{1});
if ~isfinite(df1)
    df1= Inf;
    ni1 = norminv(alpha);
else
    ni1 = tinv(alpha,df1);
end

x2= gcode(AllTSModels{1},double(XG));
Y_Pred= cell(1,length(AllTSModels));
YRF= cell(1,length(AllTSModels));

%% find response name for y-label
ylabstr= ResponseLabel(AllTSModels{1});

for ModNo= 1:length(AllTSModels);
    % loop 
    
    TS= AllTSModels{ModNo};
    
    df= dferror(TS);
    if df~=df1
        % degrees of freedom changed
        if ~isfinite(df)
            ni = norminv(alpha);
        else
            ni = tinv(alpha,df);
        end
    else
        ni=ni1;
    end	
    
    
    if CalcPRESS
        [yresp,Yrf,Datum,p]= presspred(TS,{Xs,XG},CalcPRESS);
    else
        [yresp,Yrf,Datum,p]= EvalModel(TS,{Xs,XG});
    end
    Y_Pred{ModNo}= yresp;
    YRF{ModNo}= Yrf;
    % form local model
	 L= get(TS,'local');
	 if DatumType(L)
		 L= datum(L,Datum);
	 end
    L= update(L,p,[]);
    
    %% need xlabel
    xlabstr = InputLabels(TS);
    xlabstr = {xlabstr{1:nlfactors(TS)}};
    Yd= Ys;
    Yp= yresp;
	 % make the ylabel reflect the
	 Fy= get(L,'ytrans');
	 Trans= PlotOpts{2} & ~isempty(Fy);
	 
    if Trans;
        Yd(:,1)= ytrans(L,double(Ys));
        Yp= ytrans(L,yresp);

        ydat=yinfo(L);
		  ylabstr= ResponseLabel(L,1);
	  end
    yline= Yp;
    
    isMultiInput = nfactors(L)>1 & all(InputFactorTypes(L)==1);
    if ~isMultiInput
        % calculate bounds for plots from rf values and Xs(:,1)
        fVals= unique(get(L,'Values'));
		  if any(fVals)
			  LB= min([fVals(:,1)+Datum(1);Xs(:,1)]);
			  UB= max([fVals(:,1)+Datum(1);Xs(:,1)]);
		  else
			  LB= min(Xs(:,1));
			  UB= max(Xs(:,1));
		  end
        if ModelRange
            Bnds= getcode(L);
            if ~((Bnds(1,1)==-1 | Bnds(1,1)==0)  & Bnds(1,2)==1) 
                LB= Bnds(1,1);
                UB= Bnds(1,2);
            end   
        end
        if nfactors(L)==1
            % plot solid response line
            x= linspace(LB,UB,100)';
            yline= L(x);
            featvals= L(fVals+Datum);
            datval= L(Datum);
            if Trans
                yline= ytrans(L,yline);
                featvals= ytrans(L,featvals);
                datval= ytrans(L,datval);
            end
        end
    end
    
    
    
    if nfactors(L)==1
        if size(Ys,1)>100
            xci=x;
        else
            xci=Xs(:,1);
        end
    elseif isMultiInput
        % plot pred vs obs
        yline= Yp;  % predicted 
        xci= double(Xs);
        x= double(Ys);
		  if Trans  
			  x= Fy(x);
		  end
        LB= min(x);
        UB= max(x);
        %% sort labels for this case
        xlabstr= [ylabstr];
        ylabstr = ['Predicted ', ylabstr];
    else
        % some IT's == 2 (like dynamic models with time dpt inputs
        x= Xs(:,1);
        xci= Xs;
    end
    
    
    if CIFlag  & pevcheck(TS)
		 XLci= code(TS,xci,1:size(xci,2));
        if Trans
            % use transform
            if isMultiInput
                ts= ni*sqrt(pev(TS,{XLci,x2},0,0));
            else
                ts= ni*sqrt(pevgrid(TS,[num2cell(XLci,1),num2cell(x2)],0,0));
            end
        else
            if isMultiInput
                ts= ni*sqrt(pev(TS,{XLci,x2},0));
            else
                ts= ni*sqrt(pevgrid(TS,[num2cell(XLci,1),num2cell(x2)],0));
            end
        end
        
        xci=xci(:,1);
        % make confidence interval lines
        if size(Ys,1)>=100
            nanM= repmat(NaN,size(Yp));
            dx= (UB-LB)/150;
            yci= Yp(:,ones(3,1))'+[-ts ts nanM]';
            if isMultiInput
                [xci,ind] = sort(x);
                xci= [xci xci nanM]';
                yci= yci(:,ind);
            else
                xc= Xs(:,1);
                xci= [xc xc nanM]';
            end	
            CIPlot{3*ModNo}= '-';

        else
            % bars if less than 100
            nanM= repmat(NaN,size(Yp));
            dx= (UB-LB)/150;
            yci= Yp(:,ones(9,1))'+[-ts ts nanM ts ts nanM -ts -ts nanM]';
            if isMultiInput
                [xci,ind] = sort(x);
                xci= [xci xci nanM xci-dx xci+dx nanM xci-dx xci+dx nanM]';
                yci= yci(:,ind);
            else
                xc= Xs(:,1);
                xci= [xc xc nanM xc-dx xc+dx nanM xc-dx xc+dx nanM]';
            end	
            CIPlot{3*ModNo}= '-';
        end
    else
        CIPlot{3*ModNo}= '-'; 
    end
    
    if nfactors(L)>1 & all(InputFactorTypes(L)==1)
        Xd= x;
        x= [LB UB];
        yline= x;
    elseif ~AbsX
        x= x-Datum;
        Xd= Xs-Datum;
        xci= xci-Datum;
        fpts= fVals;
        dpt= 0;
        xlabstr = [xlabstr{1} ' - DATUM'];
    else
        dpt= Datum;
        fpts= fVals+Datum;
        Xd= Xs;
        xlabstr = xlabstr{1};
    end
    
    fitPlot{3*ModNo-2}=x;
    fitPlot{3*ModNo-1}= yline;
    fitPlot{3*ModNo}= '-';
    
    pointPlot{3*ModNo-2}= Xd(:,1);
    pointPlot{3*ModNo-1}= Yp;
    pointPlot{3*ModNo}= MarkerStyles{ModNo};
    
    if CIFlag  & pevcheck(TS)
        CIPlot{3*ModNo-2}=xci(:);
        CIPlot{3*ModNo-1}= yci(:); 
    else
        CIPlot{3*ModNo-2}= NaN;
        CIPlot{3*ModNo-1}= NaN; 
    end
    
    
    if nfactors(L)==1
        line('XData',fpts(fVals~=0),'YData',featvals(fVals~=0),...
            'Marker','+','color','m','linestyle','none',...
            'tag','twostagefcnval','parent',AxHand)
        if DatumType(L)
            line('XData',dpt,'YData',datval,...
                'Marker','*','color','m','linestyle','none',...
                'tag','twostagedatum','parent',AxHand)
        end
    end
end
%% calls MATLAB plot with fitplot={xdata,ydata,linestyle}
tmp=plot(fitPlot{:},'parent',AxHand);
set(tmp,'tag','twostagefit');

if length(MarkerStyles)==1
    h= plot(pointPlot{:},'parent',AxHand,'MarkerSize',15);
else
    h= plot(pointPlot{:},'parent',AxHand,'MarkerSize',5);
end
set(h,'tag','twostagepoints');

if CIFlag
    tmp=plot(CIPlot{:},'parent',AxHand,'linewidth',1);
    set(tmp,'tag','twostageCI');
end

set(get(AxHand,'title'),'string',sprintf('Test %3g',testnum(X{1})),...
    'FontWeight','Bold','FontSize',8)
set(get(AxHand,'xlabel'),...
    'string',xlabstr,...
    'interpreter','none',...
    'FontSize',8);
set(get(AxHand,'ylabel'),...
      'string',ylabstr,...
      'interpreter','none',...
      'FontSize',8);

if nargout 
    varargout= {h,Y_Pred,YRF};
end
