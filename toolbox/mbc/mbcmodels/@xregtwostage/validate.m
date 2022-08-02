function [varargout]= Validate(X,Ys,TS,varargin)
% TWOSTAGE/VALIDATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:00:20 $


disp('Obsolete function may be deleted in future versions. Please use plot.')

XG= X{1};
Xs= double(X{2});

VPlot=0;
if nargin>3
   if ishandle(varargin{end})
      AxHand= varargin{end};
      
      VPlot=1;
		
      if isa(varargin{end-1},'xregtwostage')
         AllTSModels= [{TS},varargin(1:end-1)];
         PlotOpts   = {0,0,0,1,0};
      else
         AllTSModels= [{TS},varargin(1:end-2)];
         PlotOpts=   varargin{end-1};
      end
		if length(AllTSModels)==1
			MarkerStyles= {'.'};
		else
			lh= line('parent',AxHand);
			MarkerStyles= set(lh,'Marker');;
			MarkerStyles= MarkerStyles(2:end-1);
			delete(lh);
			while length(MarkerStyles)<length(AllTSModels);
				MarkerStyles=[MarkerStyles;MarkerStyles];
			end
		end
      [bdflag,Trans,CIFlag,AbsX,ModelRange]= deal(PlotOpts{:});

      % cell arrays for building plots
      fitPlot= cell(3*length(AllTSModels),1);
      pointPlot= fitPlot;
      CIPlot= fitPlot;
      ni= norminv(0.975);
   else
      AllTSModels= [{TS},varargin];
   end
else
   AllTSModels= {TS};   
end

x2= gcode(TS,double(XG));

Yf_Pred= cell(1,length(AllTSModels));

for ModNo= 1:length(AllTSModels);
   TS= AllTSModels{ModNo};
   
	[Y_Pred{ModNo},Yp,Datum,p]= eval(TS,{Xs,x2});
	Yf_Pred{ModNo}=Yp;
   % form local model
   L= datum(TS.Local,Datum);
   L= update(L,p,[]);
   
   if VPlot
      fVals= unique(get(L,'Values'));
      LB= min([fVals(:,1)+Datum(1);Xs(:,1)]);
      UB= max([fVals(:,1)+Datum(1);Xs(:,1)]);
      if ModelRange
         Bnds= getcode(L);
         if ~((Bnds(1,1)==-1 | Bnds(1,1)==0)  & Bnds(1,2)==1) 
            LB= Bnds(1,1);
            UB= Bnds(1,2);
         end   
      end
      x= linspace(LB,UB,100)';
      Yd= Ys;
		
		IT2= nfactors(L)==1 | ~all(InputFactorTypes(L)==1);
      if nfactors(L)==1
         yline= L(x);
         if size(Ys,1)>20
            xci=x;
         else
            xci=Xs(:,1);
         end
         datval= L(Datum);
		elseif ~IT2
         x= Ys;
         xci= double(Xs);
         yline= L(Xs);
		else
			% some IT's == 2 (like dynamic models with time dpt inputs
         x= Xs(:,1);
         xci= Xs;
         yline= L(Xs);
      end
      
      
      if Trans
         Yd(:,1)= ytrans(L,double(Ys));
         yline= ytrans(L,yline);
         Yp= ytrans(L,Y_Pred{ModNo});
         if CIFlag & pevcheck(TS)
				if IT2
					ts= ni*sqrt(pevgrid(TS,[num2cell(xci,1),num2cell(x2)],0,0));
				else
					ts= ni*sqrt(pev(TS,{xci,x2},0,0));
				end
         end
         
         if nfactors(L)==1
            featvals= ytrans(L,L(fVals+Datum));
            datval= ytrans(L,datval);
         end
      else
         if CIFlag  & pevcheck(TS)
				if IT2
					ts= ni*sqrt(pevgrid(TS,[num2cell(xci,1),num2cell(x2)],0));
				else
					ts= ni*sqrt(pev(TS,{xci,x2},0));
				end
         end
         Yp= Y_Pred{ModNo};
         if nfactors(L)==1
            featvals= L(fVals+Datum);
         end
      end
		
		xci=xci(:,1);
		if CIFlag  & pevcheck(TS)
			if size(Ys,1)>20
				yci= [yline-ts;NaN;yline+ts];
				if nfactors(L)>1 & all(InputFactorTypes(L)==1)
					[xci,ind] = sort(yline);
					yci= [xci-ts(ind);NaN;xci+ts(ind)];
				end
				xci= [xci;NaN;xci];
				CIPlot{3*ModNo}= '--';
			else
				nanM= repmat(NaN,size(Xs));
				dx= (UB-LB)/200;
				yci= Yp(:,ones(9,1))'+[-ts ts nanM ts ts nanM -ts -ts nanM]';
				if nfactors(L)>1 & all(InputFactorTypes(L)==1)
					[xci,ind] = sort(yline);
					xci= [xci xci nanM xci-dx xci+dx nanM xci-dx xci+dx nanM]';
					yci= yci(ind,:);
				else
					xci= [Xs Xs nanM Xs-dx Xs+dx nanM Xs-dx Xs+dx nanM]';
				end	
				CIPlot{3*ModNo}= '-';
			end
		else
			CIPlot{3*ModNo}= '-'; 
		 
      end
		
		if nfactors(L)>1 & all(InputFactorTypes(L)==1)
			Xd= yline;
			x= [min(yline) max(yline)];
			yline = x;
		elseif ~AbsX
			x= x-Datum;
         Xd= Xs-Datum;
         xci= xci-Datum;
         fpts= fVals;
         dpt= 0;
      else
         dpt= Datum;
         fpts= fVals+Datum;
         Xd= Xs;
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
            'Marker','+','color','m','linestyle','none','parent',AxHand)
         if DatumType(L)
            line('XData',dpt,'YData',datval,...
               'Marker','*','color','m','linestyle','none','parent',AxHand)
         end
      end
   end
end

varargout{1} = Yf_Pred;
varargout{2} = Y_Pred;

if VPlot
   plot(fitPlot{:},'parent',AxHand);
	if length(MarkerStyles)==1
		h= plot(pointPlot{:},'parent',AxHand,'MarkerSize',15);
	else
		h= plot(pointPlot{:},'parent',AxHand,'MarkerSize',5);
	end
   if CIFlag
      plot(CIPlot{:},'parent',AxHand,'linewidth',1);
   end
   
   set(get(AxHand,'title'),'string',sprintf('Test %3g',testnum(XG)),...
      'FontWeight','Bold','FontSize',8)
   
   varargout{3}= h;
end