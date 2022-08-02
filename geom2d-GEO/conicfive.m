function conicfive
% CONICFIVE - Interactively plot a conic section though five data points,
%             using the mouse to move the data points with real-time
%             animated updates. Requires the symbolic toolbox.
%
% USAGE: conicfive
%
% Notes: (1) Use the mouse to click and drag the red data points within
%            the dotted gray box, and observe the changes in the conic
%            section in real time.
%        (2) This function requires the symbolic toolbox and is tested
%            using Matlab version 7.1.0 (R14) service pack 3.
%        (3) This function illustrates some techniques in GUI manipulation,
%            computation of a conic-sections using the general determinant
%            expression, and the "ezplot" function. Nevertheless, the
%            code is developmental and hasn't been polished or heavily
%            commented.
%        (4) "ezplot" is a really handy function, but it was not designed
%            for speed. Using it repeatedly for animation slows things
%            down enough for older machines to exhibit some lag in the
%            animation.
%        (5) Parabolas require exact point placement. It is highly unlikely
%            that you will get a parabola after the initial startup.
%        (6) Tested but no warranty; use at your own risk.
%        (7) Michael Kleder, November 2006
%
% EXAMPLE:
%
% conicfive % run the interactive GUI

if ~isempty(gcbo)
    while get(gcf,'userdata')
        set(gcbo,'markerfacecolor','g')
        p=get(0,'PointerLocation');
        pf=get(gcf,'pos');
        p(1:2)=p(1:2)-pf(1:2);
        set(gcf,'CurrentPoint',p(1:2))
        p=get(gca,'CurrentPoint');
        p=sign(p).*min(abs(p),1);
        set(gcbo,'xdata',p(1,1));
        set(gcbo,'ydata',p(1,2));
        h=findobj(gca,'color','r');
        qa=get(h,'xdata');
        qb=get(h,'ydata');
        a=[qa{:}];
        b=[qb{:}];
        [d,discrim]=makefit(a,b);
        XL=[-2 2];
        YL=[-2 2];
        delete(findobj(gca,'color','b'))
        tflag=1;
        try
            ezplot(vectorize(d),[XL YL])
        catch
            title('Unable to construct conic section')
            tflag=0;
        end
        xlim(XL)
        ylim(YL)
        if tflag
            if discrim > eps
                title('Hyperbola')
            elseif discrim < -eps
                title('Ellipse')
            else
                title('Parabola')
            end
        end
        uistack(h,'top')
        pause(.01)
    end
    set(gcbo,'markerfacecolor','r','markeredgecolor','r')
    return
else
    % starting points:
    a=-1:.5:1;
    b=a.^2-.5;
    % draw figure:
    figure('Name','Drag the data points to change the conic section.',...
        'NumberTitle','off')
    set(gcf,'userdata',0)
    set(gcf,'WindowButtonDownFcn','set(gcf,''userdata'',1)')
    set(gcf,'WindowButtonUpFcn'  ,'set(gcf,''userdata'',0)')
    hold on
    for n=length(a):-1:1
        h(n)=plot(a(n),b(n),'ro','markersize',8,'markerfacecolor','r');
        set(h(n),'ButtonDownFcn',mfilename);
    end
    axis equal
    xlim([-2 2])
    ylim([-2 2])
    d=makefit(a,b);
    % plot bounding box
    plot([-1 1 1 -1 -1],[1 1 -1 -1 1],'k:','color',[.8 .8 .8])
    % plot the conic:
    XL=[-2 2];
    YL=[-2 2];
    delete(findobj(gca,'color','b'))
    ezplot(d,[XL YL]);
    title('Drag the data points to change the conic section.')
    uistack(h,'top')
    drawnow
end
return

function [d,discrim]=makefit(a,b)
syms x y M;
M = [x^2 x*y y^2 x y 1;...
    a(1)^2 a(1)*b(1) b(1)^2 a(1) b(1) 1;...
    a(2)^2 a(2)*b(2) b(2)^2 a(2) b(2) 1;...
    a(3)^2 a(3)*b(3) b(3)^2 a(3) b(3) 1;...
    a(4)^2 a(4)*b(4) b(4)^2 a(4) b(4) 1;...
    a(5)^2 a(5)*b(5) b(5)^2 a(5) b(5) 1];
d=det(M);
% compute discriminant
x2coef = double(det(M(2:end,2:end)));
y2coef = double(det(M(2:end,[1:2 4:end])));
xycoef = - double(det(M(2:end,[1 3:end])));
discrim = xycoef^2-4*x2coef*y2coef; % "b^2-4*a*c"
return

