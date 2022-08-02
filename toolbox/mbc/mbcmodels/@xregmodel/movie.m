function M= movie(m,x,TVar,hAx,AxesPos,xtrans,cmodel);
%MOVIE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:34 $


hFig= get(hAx,'parent');
set(hFig,'CurrentAxes',hAx);

% Area for Movie GetFrame
if nargin<5
   oldu= get(hAx,'units');
   set(hAx,'units','pixels');
   AxesPos= get(hAx,'pos');
   set(hAx,'units',oldu);
end
if nargin<6
   xtrans=1;
end
if nargin<7
    cmodel=[];
end


Tvalues= x{TVar};
s= get(m,'symbol');
[Y2,X]= GenTable(m,x);

tf=figure('vis','off');
ah= axes('parent',tf);
plot(Y2(:),'parent',ah);
% Range for whole plot
ZRange= get(ah,'YLim');
% Try to find some suitable levels for the contour plot
V= get(ah,'YTick');
% delete Temp Figure

% need to use a subsref call to index time as we don't
% know which dimension it is. The following two lines
% build the necessary structure.
S= struct('subs',':','type','()');
S.subs= repmat({':'},length(x),1);

ratio = 1;
% Try 1st, middle, last plots
for i=[1 max(1,fix(length(Tvalues)/2)) length(Tvalues)]
   S.subs{TVar} = i;
   Y= subsref(Y2,S);
   plot(Y(:))
   V1= get(ah,'YTick');
   ratio=  max(ratio,diff(V(1:2))/diff(V1(1:2)));
end
delete(tf)
% find best ratio
AllRatios= [100 50 20 10 5 2 1];
f=find(ratio>=AllRatios);
r= AllRatios( f(1)   );
% Adjust contour levels 
V= ZRange(1): ((V(2)-V(1))/r) : ZRange(2);

x{TVar}=1;
Types = InputFactorTypes(m);
if prod(Types)>1
   ind = find(Types==1);
   [X{ind}]=ndgrid(x{ind});
else
   [X{:}]=ndgrid(x{:});
end

% Loop through all Time values
for i=1:length(Tvalues)
   
   % Grab Table for CurrentTime
   x{TVar}= Tvalues(i);
   S.subs{TVar}= i;
   Y= subsref(Y2,S);
   
   delete(get(hAx,'children'));
   hs= surface(m,x,hAx,[0,xtrans],cmodel,X,Y,Y);
   Tname= sprintf('%s (%s=%5g)',m.Yinfo.Name,s{TVar},Tvalues(i));
   set(hAx,'zlim',ZRange)

   set(get(hAx,'title'),...
      'string',Tname,...
      'interpreter','none');  
   
   if prod(Types)>1
      ind = find(Types>1);
      for j=1:length(ind)
         Zlim=get(hAx,'Zlim');
         zline = x{ind(j)}; zline(zline>Zlim(2)) = Zlim(2); zline(zline < Zlim(1)) = Zlim(1);
         line(repmat(min(get(hAx,'Xlim')),size(x{1})),x{1},zline,'LineWidth',2);
      end
   end
   
   drawnow
   % Grab frame for movie
   M(i)= getframe(hFig,AxesPos);
end

set(hAx,'userdata',Y2);
