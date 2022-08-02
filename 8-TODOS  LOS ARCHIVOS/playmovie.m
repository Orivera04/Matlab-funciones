function playmovie(varargin)
% Plays a matlab movie
%
% USAGE:
%   playmovie(m,fps,n,option)
%
% EXAMPLES:
%   playmovie('C:\MATLAB6p5\work\animation.mat')
%   playmovie(mov,2,1,'slider')
%   playmovie(mov,1,'fullscreen','slider')
%
% DESCRIPTION:
%   Plays the movie frames movieframes
%   n times at frmprsc frames per second
%   The default values for n and frmprsc
%   are 1 and 2 frames per second
%   movieframes can also be a filename of
%   a .mat file containing the
%   movie frames
%   The name of the variable does
%   not matter as long as there
%   is only one variable
%
% NOTES:
%   if option is equal to 'slider'
%   a slider is placed at the bottom
%   of the figure which allows
%   for sections to be played
%   if option is equal to 'fullscreen'
%   the movie frames are displayed in
%   a full screen type mode, otherwise
%   frames are displayed in true size
%   When using the fullscreen mode
%   and the movie ends, press any key
%   to close the figure
%
%   More than one option can be used at
%   the same time
%   
%   
%Copy-Left, Alejandro Sanchez

error(nargchk(1,5,nargin))

%---------- Initialize Values ----------
global movieframes frmprsc hslider himage
frmprsc = [];
n = [];

%----- Get Movie Frames if .mat file specified ------
if ischar(varargin{1})
    try
        load(varargin{1});
    catch
        error(['Unable to open in-file: ',varargin{1}])
    end %try
    if isempty(movieframes)
        a = who;
        ind = strcmp(a,'varargin') + strcmp(a,'frmprsc') ...
            + strcmp(a,'n') + strcmp(a,'hslider') + strcmp(a,'himage');
        ind = find(ind==1);
        a(ind) = [];
        if length(a) > 1
            error([varargin{1},' must only contain one variable'])
        end %if
        eval(['movieframes = ',a{1},';']);
    end %if 
end %if

%----------- Defaults -----------------
sliderposition = [0.25, 0.01, 0.5, 0.03];
buttonposition = [0.8, 0.01, 0.07, 0.03];
slider = 0;
fullscreen = 0;

for k=1:length(varargin)
    if iscell(varargin{k})
        Mt = varargin{k};
        sz = size(varargin{k});
        dim = find(max(sz)==sz);
        n = length(Mt{1});
        movieframes = zeros(n,1);
        for c=1:n
            movieframes(c).cdata = cat(dim,Mt{1}(c).cdata,...
                Mt{2}(c).cdata);
            movieframes(c).colormap = [];
        end
    elseif isstruct(varargin{k})
        movieframes = varargin{k};
    elseif ischar(varargin{k}) && k>1
        if strcmpi(varargin{k}(1:4),'slid')
            slider = 1;
        elseif strcmpi(varargin{k}(1:4),'full')
            fullscreen = 1;
        else
            warning('Invalid Option')
        end %if
    elseif isnumeric(varargin{k}) && isempty(frmprsc)
        frmprsc = varargin{k};        
    elseif isnumeric(varargin{k}) && isempty(n)
        n = varargin{k};
    end %if
end %for

if isempty(frmprsc)
    frmprsc = 2;
end
if isempty(n)
    n = 1;
end

N = length(movieframes);
if N==1 & slider==1
    warning('Cannot display only one image with slider')
    slider = 0;
end

%----- Set Image Processing Toolbox preference ---
iptsetpref('ImshowBorder','tight')
iptsetpref('ImshowTruesize','auto')

if fullscreen
    set(gcf,'Units','Normalized','Position',[0,0.0293,1.0,0.8945]) %adhoc
    set(gca,'Units','Normalized','Position',[0, 0, 1, 1])
else
    iptsetpref('ImviewInitialMagnification',100)
end

if slider
    himage = imshow(movieframes(1).cdata,...
        movieframes(1).colormap);
    set(himage,'EraseMode','None')
    hslider = uicontrol('Style','Slider','Units','Normalized',...
        'Position',sliderposition,'Min',1,'Max',N,'Value',1,...
        'SliderStep',[1/(N-1), 5/(N-1)],'BusyAction','cancel',...
        'TooltipString','Click on slider to move through movie',...
        'Callback',...
        ['global movieframes frmprsc hslider himage,',...
        'ind = fix(get(hslider,''Value''));',...
        'set(himage,''Cdata'',movieframes(ind).cdata),',...
        'clear movieframes hslider frmprsc himage ind']);
    set(gcf,'Toolbar','figure')

    if fullscreen
        b = uicontrol('Style','Pushbutton','Units','Normalized',...
            'Position',buttonposition,'String','Close',...
            'FontUnits','Normalized','FontSize',0.8,...
            'FontName','Times','Callback','close');
    end

else
    for r = 1:n
        himage = imshow(movieframes(1).cdata,...
            movieframes(1).colormap);
        set(himage,'EraseMode','None')
        pause(1/frmprsc)
        for k = 2:N
            set(himage,'Cdata',movieframes(k).cdata)
            pause(1/frmprsc)
        end %for
    end %for
    if fullscreen
        pause
        close
    end
end %if

return

