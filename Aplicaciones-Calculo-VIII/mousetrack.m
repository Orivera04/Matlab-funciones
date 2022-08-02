function outtrack=mousetrack(inmat)

%MOUSETRACK Track the motion of your mouse over an image
%   MOUSETRACK(X) retuns a Mx2 tensor, which containes the x and y position of the
%   mouse cursor during it's motion over the selected image 'inmat'. Images can be real RGB image
%   data, or any MxN matrix. The recording phase is started and stopped by a
%   click on either mousebutton.
%
% Syntax:
%
%        outtrack=mousetrack(inmat)
%
% Example:
%       d=mousetrack(peaks)
%       hold on
%       plot(d(:,1),d(:,2),'r')
%
%Author: Ralph Mettier, Paul Scherrer Institute, Villigen Switzerland
%Date: July 21st 2004

try
    imagefig=figure('units','normalized','position',[0.1 0.1 0.8 0.8]);
    imagesc(inmat)
    set(gca,'ydir','normal');
catch
    close(imagefig)
    disp('Only NxM tensors, or NxMx3 RGB image data can be displayed as images')
end

set(imagefig,'windowbuttondownfcn',{@starttrack});

waitfor(0,'userdata')
outtrack=get(0,'userdata');
% -------------------------------------------------------------------------

function starttrack(imagefig,varargins)

disp('tracking started')
set(gcf,'windowbuttondownfcn',{@stoptrack},'userdata',[]);
set(gcf,'windowbuttonmotionfcn',...
             'set(gcf,''userdata'',[get(gcf,''userdata'');get(0,''pointerlocation'')])');

%--------------------------------------------------------------------------

function stoptrack(imagefig,varargins)

set(gcf,'windowbuttonmotionfcn',[]);

disp('tracking stopped')

units0=get(0,'units');
unitsf=get(gcf,'units');
unitsa=get(gca,'units');
                           
set(0,'units','pixels');
set(gcf,'units','pixels');
set(gca,'units','pixels');

x=get(gca,'xlim');
y=get(gca,'ylim');
axsize=get(gca,'position');
figsize=get(gcf,'position'); 
ratio=diag([diff(x)/axsize(3) diff(y)/axsize(4)]);
shift=figsize(1:2)+axsize(1:2); 

set(0,'units',units0);
set(gcf,'units',unitsf);
set(gca,'units',unitsa);

mousetrail=(get(gcf,'userdata')-repmat(shift,size(get(gcf,'userdata'),1),1))*ratio;

set(gcf,'windowbuttondownfcn',{@starttrack});
set(0,'userdata',mousetrail);
