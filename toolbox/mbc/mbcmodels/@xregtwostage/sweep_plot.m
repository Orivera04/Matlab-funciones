function infoStr = sweep_plot(TS,Xs,Ys,AxHand,PlotOpts);
% TWOSTAGE/SWEEP_PLOT
%
% ht= sweep_plot(TS,AxHand,X,Y);
%  Inputs
%     TS       twostage object
%     Xs      X data (sweepset)
%     Ys      Y data (sweepset)
%     AxHand  axes handle(s) for display (1=plot,2=optional info)
%     ht      height variable (for text)
%     PlotOpts {bdflag,Transform,CIFlag,AbsX,ModelRange} 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:00:18 $

%  Output
%     infoStr      information string for tooltip patch

if nargin<5 %% no PlotOpts
   PlotOpts= {1,0,1,0,0};
end
[bdflag,Trans,CIFlag,AbsX,ModelRange]= deal(PlotOpts{:});

nl= nlfactors(TS);

XL= Xs{1};
XG= Xs{2};;

% call model/validate to do fit and draw response
% [Lfpred,Lpred,h]= Validate({XG,XL},Ys,TS,PlotOpts,AxHand(1));

[h,Lpred,Lfpred]= plot(TS,Xs,Ys,[PlotOpts{:}],AxHand(1));
%% h = line handle
%% Lpred is predicted values of Y
%% Lfpred is predicted values of the RFs

L= TS.Local;
% plot data with sweepset/plot
if ~AbsX & DatumType(TS.Local);
   xgc= gcode(TS,double(XG));
   XL{1}= XL{1}-TS.datum(xgc);
   xn= get(XL,'name');
   set(XL,'name',[xn{1},'-Datum']);
end
if Trans
   yname= get(Ys,'name');
   yunits= get(Ys,'units');
   Fy= get(L,'ytrans');
   if  ~isempty(Fy)
      Ys{1}= ytrans(L,Ys{1});
		
      yunits= TransUnits(L);
      set(Ys,'units',yunits)
   end
end

if nfactors(L)==1 | any(InputFactorTypes(L)~=1)
	Xdata= get(h(1),'xdata');
	if bdflag
      %% calls sweepset/plot
		plot(Xdata,Ys,'b.','bd','parent',AxHand(1));
	else
		plot(Xdata,Ys,'b.','parent',AxHand(1));
	end   
end

if nargout
   % calculate info string
   rp=(double(Ys)-Lpred{1});
   rp= rp(isfinite(rp));
   if ~isempty(rp)
      sp = sqrt( sum(rp.^2)/length(rp) );
   else
      sp = NaN;
   end
   
   infoStr= sprintf('%10.3g ',sp);
end
