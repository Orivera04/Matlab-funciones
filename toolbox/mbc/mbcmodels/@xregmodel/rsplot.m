function lh=rsplot(m,x,hAx,lh,ni,color)
% MODEL/RSPLOT response surface plot for models
% 
% lh=rsplot(m,x,hAx,lh,color)
%  plots response and confidence intervals (3sds) for each input

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:53:00 $

if nargin<4
   for i=1:length(hAx)
      lh(i)=line('parent',hAx(i),...
         'color',[0 0.5 0],'linewidth',2,...
         'handlevis','off',...
         'visible','on',...
         'tag','rsselector');
   end
end

if nargin<5
   ni = norminv(0.975);
end
if nargin<6
   color='b';
end


[L,U]= range(m);
nf= length(L);
xc= x;
ITypes= InputFactorTypes(m);

j=1;
for i=1:nf
    xs= xc{i};    
    if ITypes(i)==1
        % work out range for x variable

        xi= linspace(min(L(i),xs),max(U(i),xs),51)';
        xc{i}= xi;
        
        
        if isfinite(ni)   
            % use pevgrid to generate pe and yhat
            [PE,X,xg,yi]= pevgrid(m,xc);
            yi= squeeze(yi);
            p  = squeeze(sqrt(PE));
            % ci's
            yhi= yi+ni*p;
            ylo= yi-ni*p;
        else
            [yi]= GenTable(m,xc);
            yi= squeeze(yi);
            yhi= NaN;
            ylo= NaN;
        end
        set(lh(j),'ydata',[NaN,NaN]);
        h=plot(xi,yi,'-',xi,yhi,'--',xi,ylo,'--',...
            'hittest','off',...
            'color',color,...
            'tag','rslines','parent',hAx(i));
        set(h(1),'linewidth',2);
        % put value back
        xc{i}= xs;
        set(lh(j),'xdata',[xs xs],'ydata',get(hAx(i),'ylim'));
            
        j=j+1;
    else
        if ITypes(1)==1
            h=plot([L(1) L(1) U(1)],[0 x{i} x{i}],'-',...
                'hittest','off',...
                'color',color,...
                'tag','rslines','parent',hAx(i));
            set(h(1),'linewidth',2);
        end
    end
end
   
