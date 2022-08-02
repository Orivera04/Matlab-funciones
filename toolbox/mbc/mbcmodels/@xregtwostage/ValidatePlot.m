function ValidatePlot(E,Xg,X,Y,varargin)
% obsolete function

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:19 $


if ~get(E.Local,'mbtmode')
   ydatum= zeros(size(x2,1),1);
else
   ydatum= E.datum(x2);
end

Yg= zeros(size(x2,1),length(E.Global));
for i= 1:length(E.Global)
   Yg(:,i)= eval(E.Global{i},x2);
end

Y= zeros(size(x2,1),size(x1,1));
LM= E.Local;
for i= 1:size(x2,1)
   LM= datum(LM,datum(i));
   LM= reform(LM,Yg(i,:)');
   Y(:,i)= LM(x1);
end

% Reconstruct curve
Local= E.Local;
Local= datum(Local,ydatum(k));

fVals= unique(get(Local,'Values'));

minX= min([fVals+ydatum;Xs]);
maxX= max([fVals+ydatum;Xs]);

x= linspace(minX-(maxX-minX)/5,maxX+(maxX-minX)/5,50);

% plot results  (Blue points real data , blue line Local regression fit , Green Line 
set(fig,'CurrentAxes',ud.page(i).ax(j))
plot(Xs,Ys,'ob','LineWidth',2)
hold on
[Local,OKE]= reform(Local,yh(k,:));        
if OKE
   plot(Xs,Local(Xs),'o',...
      x,Local(x),'LineWidth',2,'color',[0 .5 0])
   plot(fVals+ydatum(k),Local(fVals+ydatum(k)),'+m',...
      ydatum(k),Local(ydatum(k)),'m*','LineWidth',2)
   Yf_pred(k,:)=evalfeatures(Local);
else
   Yf_pred(k,:)=NaN;
end