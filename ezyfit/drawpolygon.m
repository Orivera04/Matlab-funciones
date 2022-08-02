function [xv,yv,hp]=drawpolygon(nmax,tolerance)
%DRAWPOLYGON  Draw a polygon
%   [XV,YV,H] = DRAWPOLYGON asks the user to draw a closed polygon on the
%   current figure. Double-click or right-click to quickly close the
%   polygon and exit. [XV,YV] are the vertices of the polygon, and H a
%   handle to the polygon.
%
%   [XV,YV,H] = DRAWPOLYGON(N) selects at most N points.
%
%   [XV,YV,H] = DRAWPOLYGON(N,DX) specifies the tolerance DX for closing
%   the polygon, i.e. the number of pixels DX in the neighborhoud of the
%   first vertex required to close the polygon. By default, DX=4.
%
%   See also SELECTDATA.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.20,  Date: 2006/01/25
%   This function is part of the EzyFit Toolbox

% History:
% 2005/11/03: v1.00, first version.
% 2005/12/03: v1.10, interactive properties of the figure suspended during
%                    the drawing.
% 2005/12/13: v1.11, bug fixed with right mouseclick (waitfor suppressed)
% 2006/01/25: v1.20, uses 'SelectionType' instead of 'WindowButtonDownFcn',
%                    which caused frequent bugs. Option DX added.

error(nargchk(0,2,nargin));

if nargin==0, nmax=inf; end;
if nargin<2, tolerance = 4; end; % number of pixels in the neighborhood
% of the first point to accept to close the polygon

hp=[];

% initial settings:
fig=gcf;
initial_pointer=get(fig,'Pointer');
uistate=uisuspend(fig);
axis manual;

[xv,yv,but]=myginput(1,'crosshair');

set(fig,'Pointer','crosshair');

if ((but==1) && (nmax>1)),

    % get the coord of the first vertex of the polygon:
    spt0 = get(0, 'PointerLocation'); % pointer coordinates in pixel, from the screen corner
    wls=get(fig,'Position'); % position of the window in the screen, in pixels
    x0norm=(spt0(1)-wls(1))/wls(3); % normalized coordinates of the 1st point
    y0norm=(spt0(2)-wls(2))/wls(4);
    xprevnorm=x0norm;
    yprevnorm=y0norm;

    hold on;
    plot(xv,yv,'ks:','Markersize',5,'UserData','polygonfirstpoint');

    endofpolygon=0;
    n=1;
    set(fig,'SelectionType','extend');
    while ~endofpolygon,
        
        buttonpressed=get(fig,'SelectionType'); % last button pressed ('normal','alt' or 'extend'(=nothing))
        set(fig,'Pointer','crosshair');
        
        switch buttonpressed, 

            case 'extend', % if no button press
                if get(0,'PointerWindow')==fig, % if the pointer is in the window
                    wls=get(fig,'Position'); % position of the window in the screen, in pixels
                    sptcur = get(0, 'PointerLocation'); % current position of the pointer
                    xcurnorm=(sptcur(1)-wls(1))/wls(3);  % normalized coordinates of the current point
                    ycurnorm=(sptcur(2)-wls(2))/wls(4);
                    hl=findall(fig,'UserData','drawpolygondashedline');
                    if length(hl),
                        set(hl,'X',[xprevnorm xcurnorm]);
                        set(hl,'Y',[yprevnorm ycurnorm]);
                    else
                        annotation('line',[xprevnorm xcurnorm],[yprevnorm ycurnorm],...
                            'LineStyle',':','UserData','drawpolygondashedline');
                    end;
                    %drawnow;
                end;
                
            otherwise, % a button is pressed
                
                n = n+1;
                cp=get(gca,'CurrentPoint');
                sptnew = get(0, 'PointerLocation');
                if ((abs(sptnew(1)-spt0(1))<=tolerance) && (abs(sptnew(2)-spt0(2))<=tolerance)),
                    xv(n)=xv(1); yv(n)=yv(1); % close the polygon
                    endofpolygon=1;
                else
                    xv(n)=cp(1,1); yv(n)=cp(1,2);
                    if  (strcmp(buttonpressed,'alt')) || (strcmp(buttonpressed,'open')) || (n>=nmax),
                        n=n+1;
                        xv(n)=xv(1); yv(n)=yv(1); % close the polygon
                        endofpolygon=1;
                    end;
                end;
          
                hp=findobj(fig,'UserData','polygonside');
                if length(hp),
                    set(hp,'XData',xv);
                    set(hp,'YData',yv);
                else
                    hp=plot(xv,yv,'k-','UserData','polygonside');
                end;
                %drawnow;

                xprevnorm=xcurnorm;  yprevnorm=ycurnorm;
                hl=findall(fig,'UserData','drawpolygondashedline');
                delete(hl);
                    
                set(fig,'SelectionType','extend');    % set back to 'extend'(=nothing)
        end;

    end; % while ~endofpolygon

    hold off;
end; % if ((but==1)&(nmax>1))

% restores all:
set(fig,'Pointer',initial_pointer);
set(findobj(fig,'UserData','polygonside'),'UserData','polygon');
delete(findall(fig,'UserData','drawpolygondashedline'));
delete(findobj(fig,'UserData','polygonfirstpoint'));
uirestore(uistate);

if nargout==0,
    xv
    yv
    clear xv yv hp;
end;
