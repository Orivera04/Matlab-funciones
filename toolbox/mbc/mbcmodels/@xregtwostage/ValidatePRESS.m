function [varargout]= ValidatePRESS(X,Ys,DataInd,TS,varargin)
%VALIDATEPRESS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:18 $


disp('Obsolete function may be deleted in future versions. Please use plot.')

XG= X{1};
Xs= double(X{2});

VPlot=0;
if nargin>4
   if ishandle(varargin{end})
      AxHand= varargin{end};
      VPlot=1;
      MarkerStyles= get(AxHand,'LineStyleOrder');
      % Colors= [0 .5 0; colorcube(length(varargin))];
      while length(MarkerStyles)<length(varargin)+1;
         MarkerStyles=[MarkerStyles MarkerStyles];
      end
      if isa(varargin{end-1},'xregtwostage')
         AllTSModels= [{TS},varargin(1:end-1)];
         PlotOpts   = {0,0,1,0};
      else
         AllTSModels= [{TS},varargin(1:end-2)];
         PlotOpts=   varargin{end-1};
      end
      [bdflag,Trans,CIFlag,AbsX,ModelRange]= deal(PlotOpts{:});
      fitPlot= cell(3*length(AllTSModels),1);
      pointPlot= cell(3*length(AllTSModels),1);
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
   
   Yf_Pred{ModNo}= zeros(size(x2,1),length(TS.Global));
   for i= 1:length(TS.Global)
      yf = TS.Global{i}(x2);
      Yf_Pred{ModNo}(:,i)= presspred(TS.Global{i},yf,DataInd);
   end
   Yp= Yf_Pred{ModNo};
   
   if ~DatumType(TS.Local)
      Datum= 0;
   else
      Datum= TS.datum(x2);
      Datum= presspred(TS.datum,Datum,DataInd);
   end
   
   L= datum(TS.Local,Datum);
   [y,p]= reconstruct(L,Yp,Xs-Datum,Datum);
   L= update(L,p,[]);
   Y_Pred{ModNo} =  yinv(L,y); 
   
   if VPlot
      fVals= unique(get(L,'Values'));
      LB= min([fVals+Datum(1);Xs(:,1)]);
      UB= max([fVals+Datum(1);Xs(:,1)]);
      if ModelRange
         Bnds= getcode(L);
         if ~((Bnds(1,1)==-1 | Bnds(1,1)==0)  & Bnds(1,2)==1) 
            LB= Bnds(1,1);
            UB= Bnds(1,2);
         end   
      end
      x= linspace(LB,UB,100)';
      Yd= Ys;
      if nfactors(L)==1
         yline= L(x);
         datval= L(Datum);

      else
         x= Xs(:,1);
         yline= L(Xs);
      end
      
      
      if Trans
         Yd(:,1)= ytrans(L,double(Ys));
         yline= ytrans(L,yline);
         Yp= ytrans(L,Y_Pred{ModNo});
         
         if nfactors(L)==1
            featvals= ytrans(L,L(fVals+Datum));
            datval= ytrans(L,datval);
         end
      else
         Yp= Y_Pred{ModNo};
         if nfactors(L)==1
            featvals= L(fVals+Datum);
         end
      end
      
      
      if ~AbsX
         x= x-Datum;
         Xd= Xs-Datum;
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
   h= plot(pointPlot{:},'parent',AxHand);
   
   set(get(AxHand,'title'),'string',sprintf('Test %3g',testnum(XG)),...
      'FontWeight','Bold','FontSize',8)
   
   varargout{3}= h;
   
end