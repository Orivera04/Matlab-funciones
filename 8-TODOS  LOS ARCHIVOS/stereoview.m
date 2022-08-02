function stereoview
% STEREOVIEW  Stereoscopic plotting function, version 3.0
% 
%   stereoview grabs the current 3D figure and plots it in two
%   stereoscopical images.
%
%   Once launched, you can:
%   1) choose the interocular distance coefficient (idc)
%   that is defined as the ratio between the distance from the Camera
%   Target and the interocular distance; a value of 100 works fine.
% 
%   2) choose the viewing mode: 'parallel' or 'crossed'.
% 
% 	3) rotate the plot. In the Free Rotation mode, use:
%   a, s, d, w to rotate,
%   x to stop.
% 
%   Version 3.0 NEWS
%   - colormap bug fixed;
%   - cross product for the eyes
% ----------------------------------------------------------
% (c) 2004  Iari-Gabriel Marino 
%           <iarigabriel.marino@fis.unipr.it>
%           http://www.geocities.com/iari_marino/    
% ----------------------------------------------------------
%   Example 1
% 
%   [X,Y,Z] = peaks(30);
%   surfc(X,Y,Z)
%   stereoview
%   ------------------------
%   Example 2
% 
% 	daspect([1,1,1])
% 	load wind
% 	xmin = min(x(:));
% 	xmax = max(x(:));
% 	ymin = min(y(:));
% 	ymax = max(y(:));
% 	zmin = min(z(:));
% 	daspect([2,2,1])
% 	xrange = linspace(xmin,xmax,8);
% 	yrange = linspace(ymin,ymax,8);
% 	zrange = 3:4:15;
% 	[cx cy cz] = meshgrid(xrange,yrange,zrange);
% 	hcones = coneplot(x,y,z,u,v,w,cx,cy,cz,5);
% 	set(hcones,'FaceColor','red','EdgeColor','none')
% 	hold on
% 	wind_speed = sqrt(u.^2 + v.^2 + w.^2);
% 	hsurfaces = slice(x,y,z,wind_speed,[xmin,xmax],ymax,zmin);
% 	set(hsurfaces,'FaceColor','interp','EdgeColor','none')
% 	hold off
% 	axis tight; view(30,40); axis off
% 	camproj perspective; camzoom(1.5)
% 	camlight right; lighting phong
% 	set(hsurfaces,'AmbientStrength',.6)
% 	set(hcones,'DiffuseStrength',.8)
%   stereoview
%   ------------------------
%   Example 3
% 
% 	[x y z v] = flow;
% 	h = contourslice(x,y,z,v,[1:9],[],[0],linspace(-8,2,10));
% 	axis([0,10,-3,3,-3,3]); daspect([1,1,1])
% 	camva(24); camproj perspective;
% 	campos([-3,-15,5])
% 	set(gcf,'Color',[.5,.5,.5],'Renderer','zbuffer')
% 	set(gca,'Color','black','XColor','white', ...
%         'YColor','white','ZColor','white')
% 	box on
%   stereoview

St.title = 'Stereoview 3.0 by I.-G. Marino';

origColormap = colormap;
St.idc = 100; %interocularDistanceCoefficient;
St.freeRotating = 0;
St.flying = 0;
St.origFig = gcf; set(St.origFig,'visible','off')
St.origAxis = gca;
St.stereoF = figure(2); set(St.stereoF,'name',St.title,'numbertitle','off','userdata',St,'CloseRequestFcn',{@closeReqFcn,St});
pos = [120 271 780 420]; colormap(origColormap);
set(St.stereoF,'Position',pos,'doublebuffer','on');
St.sxPlot = copyobj(St.origAxis,St.origFig); set(St.sxPlot,'pare',St.stereoF)
set(St.sxPlot,'position',[0.5/10 3/10 4/10 6.5/10]);
axes(St.sxPlot); axis vis3d;
St.sxEye = St.sxPlot;
St.dxPlot = copyobj(St.origAxis,St.origFig); set(St.dxPlot,'pare',St.stereoF)
set(St.dxPlot,'position',[5.5/10 3/10 4/10 6.5/10]);
axes(St.dxPlot); axis vis3d;
St.dxEye = St.dxPlot;

St = PlotStereo(St);
shg
St.stopAnimButton = uicontrol(gcf,'style','togglebutton','string','Stop','value',0,'position',[281 20 38 20]);
St.azLeftButton = uicontrol(gcf,'string','Left','callback',{@changeAz,{St,10}},'position',[81 20 38 20]);
St.azRightButton = uicontrol(gcf,'string','Rigth','callback',{@changeAz,{St,-10}},'position',[121 20 38 20]);
St.azLeftRotButton = uicontrol(gcf,'string','<<','callback',{@rotateAz,{St,10}},'position',[41 20 38 20]);
St.azRightRotButton = uicontrol(gcf,'string','>>','callback',{@rotateAz,{St,-10}},'position',[161 20 38 20]);
St.elUpButton = uicontrol(gcf,'string','Up','callback',{@changeEl,{St,-5}},'position',[201 20 38 20]);
St.elDownButton = uicontrol(gcf,'string','Down','callback',{@changeEl,{St,5}},'position',[241 20 38 20]);
St.idcText = uicontrol(gcf,'style','text','string','IDC','position',[421 30 38 20]);
St.idcEdit = uicontrol(gcf,'style','edit','string','100','callback',{@changeIdc,St},'position',[411 10 58 20]);
St.changeModeList = uicontrol(gcf,'style','listbox','string',{'Parallel';'Crossed'},'callback',{@changeMode,St},'position',[321 10 78 40]);
St.rotButton = uicontrol(gcf,'string','Free Rotation','callback',{@freeRot,St},'position',[481 20 78 20]);
% St.flyButton = uicontrol(gcf,'string','Free Fly','callback',{@fly,St},'position',[571 20 78 20]);
St.resetViewButton = uicontrol(gcf,'string','Reset View','callback',{@resetView,St},'position',[661 20 68 20]);

function St = closeReqFcn(Handle,action,St)
if strcmp(get(St.stereoF,'Tag'),'flying'),
    disp('Press x before closing.');
    set(St.stereoF,'name','Press x before closing.');
else
    set(St.stereoF,'Tag','2close');
    delete(St.stereoF);
    set(St.origFig,'visible','on');
end

function St = changeMode(ListH,action,St)
choice = get(ListH,'value');
switch choice
case 1, % 'parallel'
    St.sxEye=St.sxPlot; St.dxEye=St.dxPlot;
case 2, % 'crossed'
    St.sxEye=St.dxPlot; St.dxEye=St.sxPlot;
end
St = PlotStereo(St);

function St = changeIdc(EditH,action,St)
St.idc = str2num(get(EditH,'string'));
St = PlotStereo(St);

function St = resetView(ButtonH,action,St)
close(St.stereoF)
stereoview

function St = changeAz(ButtonH,action,data)
St = data{1};
moveAz = data{2};
axes(St.sxEye)
camorbit(moveAz,0);
axes(St.dxEye)
camorbit(moveAz,0);
drawnow

function St = rotateAz(ButtonH,action,data)
St = data{1};
moveAz = data{2};
set(St.stopAnimButton,'value',0);
while get(St.stopAnimButton,'value') == 0,
	axes(St.sxEye)
	camorbit(moveAz,0);
	axes(St.dxEye)
	camorbit(moveAz,0);
	drawnow
end
St.stopNow = 0;
set(St.stopAnimButton,'value',1);

function St = changeEl(ButtonH,action,data)
St = data{1};
moveEl = data{2};
axes(St.sxEye)
camorbit(0,moveEl);
axes(St.dxEye)
camorbit(0,moveEl);
drawnow

function St = freeRot(ButtonH,action,St)
set(St.stereoF,'WindowStyle','modal');
set(ButtonH,'String','x to stop');
set(St.stereoF,'name','Flying - Use: a d w s - x to Exit.');
set(St.stereoF,'Tag','flying');
St.freeRotating = 1;
while St.freeRotating,
    if not(strcmp(get(St.stereoF,'Tag'),'2close')),
        figure(St.stereoF);
        switch get(St.stereoF,'CurrentCharacter')
        case 'a',
            changeAz([],[],{St ; 5});
            set(St.stereoF,'CurrentCharacter','p')
        case 'd',
            changeAz([],[],{St ; -5});
            set(St.stereoF,'CurrentCharacter','p')
        case 'w',
            changeEl([],[],{St ; 5});
            set(St.stereoF,'CurrentCharacter','p')
        case 's',
            changeEl([],[],{St ; -5});
            set(St.stereoF,'CurrentCharacter','p')
        case 'x',
            St.freeRotating = 0;
            set(St.stereoF,'CurrentCharacter','p')
        otherwise,
        end
        drawnow
    else
        St.freeRotating = 0;
        delete(St.stereoF);
    end
end
set(St.stereoF,'Tag','stopped');
set(ButtonH,'String','Free Rotation');
set(St.stereoF,'name',St.title);
set(St.stereoF,'WindowStyle','normal');

function St = PlotStereo(St)
oriAspR = get(St.origAxis,'DataAspectRatio');
St.P0 = campos(St.origAxis)./oriAspR;    % normalizzo X e Y per i valori di DataAspectRatio
St.T0 = camtarget(St.origAxis)./oriAspR; % normalizzo X e Y per i valori di DataAspectRatio
d = sqrt(sum((St.P0-St.T0).^2)); % distanza St.T0-St.P0
L = d/St.idc;
%------------------------------
% Calculations for the position of the two cameras (eyes)
%------------------------------
P1 = St.P0 + L/2 * unitv(cross(St.P0-St.T0,[0 0 1]));
P2 = St.P0 - L/2 * unitv(cross(St.P0-St.T0,[0 0 1]));
%------------------------------
campos(St.sxEye,P1.*oriAspR); % torno ai valori veri di X e Y moltiplicando per [oriAspR(1) oriAspR(2) 1]
camtarget(St.sxEye,St.T0.*oriAspR);
campos(St.dxEye,P2.*oriAspR);
camtarget(St.dxEye,St.T0.*oriAspR);
% u = unitv(v)
% u is the unit vector of v

function u = unitv(v)
u = v/(sqrt(sum(v.^2)));