function varargout = imview(command, varargin)
%IMVIEW Display an image.
%
%   IMVIEW FILE or IMVIEW('FILE') displays the image file FILE.
%
%   IMVIEW(I) displays the intensity image I.
%
%   IMVIEW(BW) displays the binary image BW.
%
%   IMVIEW(X, MAP) displays the indexed image X with the colormap MAP.
%
%   IMVIEW(RGB) displays the truecolor image RGB.
%
%   IMVIEW(R, G, B) displays the "old-style" truecolor image represented by the
%   three matrices R, G and B.
%
%   Class Support
%   -------------
%   The input image can be of class uint8, uint16, or double.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-10-13 13:28:26 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   if nargin == 0
      % no input argument, so bring up any existing viewer or create a new viewer if
      % no viewer exists
      h = findobj(0, 'type', 'figure', 'tag', 'Image Viewer');
      if isempty(h)
         command = 'Imview::Initialize';
      else
         figure(h(1));
         return
      end
   else
      % viewer is called with a numeric argument, i.e., image data
      if isnumeric(command) | islogical(command)
         imview('Imview::SetData', command, varargin{:});
         return;
      % viewer is called with a file name argument
      elseif ischar(command) & ~strncmp(command, 'Imview::', 8)
         file = command;
         [X, map] = imread(file);
         imview('Imview::SetData', X, map);
         name = get(gcf, 'Name');
         k = findstr(name, ' - ');
         if ~isempty(k)
            name = name(1 : k(1)-1);
         end
         set(gcf, 'Name', [name ' - ' file]);
         return;
      end
   end

   switch command

      case 'Imview::Initialize'

%         % this section is just a test to see if the p-file is missing or
%         % needs updating
%         fun = mfilename;
%         [pth, nam, ext] = fileparts(which(fun));
%         minfo = dir([pth filesep nam '.m']);
%         pinfo = dir([pth filesep nam '.p']);
%         if strcmp(ext, '.p')
%            if isempty(minfo)
%               fprintf('The M-file "%s" appears to be missing!\n', minfo.name);
%            elseif datenum(minfo.date) > datenum(pinfo.date)
%               fprintf(['The M-file "%s.m" is newer than corresponding ' ...
%                        'P-file.\nExecute "pcode %s -inplace" to update.' ...
%                        '\n'], fun, fun);
%            end
%         elseif isempty(pinfo)
%            fprintf(['Missing P-file.  Execute "pcode %s -inplace" to' ...
%                     ' create.\n'], fun);
%         end

         % see if there already are existing viewers
         h = findobj(0, 'Type', 'figure', 'Tag', 'Image Viewer');

         % let there be a unique name for each viewer
         name = 'Image Viewer';
         if ~isempty(h)
            name = sprintf('%s (%d)', name, max(h) + 1);
         end

         % create a new figure
         h0 = figure('Name',             name, ...
                     'HandleVisibility', 'on', ...
                     'Units',            'normalized', ...
                     'NumberTitle',      'off', ...
                     'MenuBar',          'none', ...
                     'Tag',              'Image Viewer');

         % create menus
         h1 = uimenu(h0, 'Label',     'File');
         h2 = uimenu(h1, 'Label',     'Open...', ...
                         'CallBack',  'imview(''Imview::File::Open'');');
         h2 = uimenu(h1, 'Label',     'New', ...
                         'CallBack',  'imview(''Imview::File::New'');');
         h2 = uimenu(h1, 'Label',     'Exit', ...
                         'CallBack',  'imview(''Imview::File::Exit'');');

         h1 = uimenu(h0, 'Label',     'View');
         h2 = uimenu(h1, 'Label',     'True size', ...
                         'CallBack',  'imview(''Imview::View::TrueSize'');');
         h2 = uimenu(h1, 'Label',     'Fit to frame', ...
                         'CallBack',  'imview(''Imview::View::FitToFrame'');');
         h2 = uimenu(h1, 'Label',     'Equal axes', ...
                         'CallBack',  'imview(''Imview::View::EqualAxes'');');

         h1 = uimenu(h0, 'Label',     'Help');
         h2 = uimenu(h1, 'Label',     'Help', ...
                         'CallBack',  'imview(''Imview::Help::Help'');');
         h2 = uimenu(h1, 'Label',     'About', ...
                         'CallBack',  'imview(''Imview::Help::About'');');

         axes('Position', [0 0 1 1], ...
              'Visible',  'off');

         % return figure handle
         if nargout
            varargout = {h0};
         end

      case 'Imview::SetData'

         h = findobj(0, 'type', 'figure', 'tag', 'Image Viewer');
         if isempty(h)
            h = imview('Imview::Initialize');
         end
         figure(h(1));

         nargsin = length(varargin);

         % IMVIEW(X,MAP)
         if nargsin == 2 & ~isempty(varargin{2})
            data = varargin{1};
            map  = varargin{2};

         % IMVIEW(R,G,B)
         elseif nargsin == 3
            if   ~isequal(class(varargin{1} ), class(varargin{2})) ...
               | ~isequal(class(varargin{1} ), class(varargin{3}))
               error('R, G and B must be of the same class.');
            end
            if   ~isequal(size(varargin{1}), size(varargin{2})) ...
               | ~isequal(size(varargin{1}), size(varargin{3}))
               error('R, G and B must have the same size.');
            end
            data = cat(3, varargin{1:3});
            map  = [];

         % IMVIEW(RGB) or IMVIEW(I)
         else
            data = varargin{1};
            map  = [];
         end

         cls = class(data);
         [rows, cols, chnls] = size(data);
         if isempty(map)
            switch chnls
               case 1
                  if islogical(data)            % IMVIEW(BM)
                     data(data) = 1;
                     data = uint8(data);
                     image(data);
                     colormap(gray(2));
                  else                          % IMVIEW(I)
                     switch cls
                        case 'uint8'
                           image(data);
                           colormap(gray(256));
                        case 'uint16'
                           data = data(:,:,[1 1 1]);
                           image(data);
                           colormap([]);
                        case 'double'
                           uint16(data);
                           data = data(:,:,[1 1 1]);
                           image(data);
                           colormap([]);
                     end
                  end
               case 3                           % IMVIEW(RGB)
                  image(data);
                  colormap([]);
               otherwise
                  error('Invalid number of channels in input image.');
            end

         else                                   % IMVIEW(X,MAP)
            colormap(map);
            image(data);
         end

         axis off image;

      case 'Imview::File::New'

         imview('Imview::Initialize');

      case 'Imview::File::Exit'

         close(gcf);

      case 'Imview::File::Open'

         [file, path] = uigetfile('*.*', 'Open');
         if ~ischar(file)
            return
         end
         chdir(path);
         [X, map] = imread(file);
         imview('Imview::SetData', X, map);
         name = get(gcf, 'Name');
         k = findstr(name, ' - ');
         if ~isempty(k)
            name = name(1 : k(1)-1);
         end
         set(gcf, 'Name', [name ' - ' file]);
         return

      case 'Imview::View::TrueSize'

         axis image;
         set(gcf, 'Units', 'Pixels');
         figpos = get(gcf, 'Position');
         him = get(gca, 'Children');
         imsiz = size(get(him, 'CData'));
         newpos = [figpos(1) figpos(2)+figpos(4)-imsiz(1) imsiz(2) imsiz(1)];
         set(gcf, 'Position', newpos);

      case 'Imview::View::FitToFrame'

         axis normal tight;

      case 'Imview::View::EqualAxes'

         axis equal;

      case 'Imview::Help::Help'

         msgbox('Type "help imview" at the command line.', 'Help');

      case 'Imview::Help::About'

         txt = sprintf('%s\n%s\n%s\n%s', ...
                       'imview - MATLAB Image Viewer', ...
                       'Copyright (c) 2000-2003 Peter J. Acklam', ...
                       'URL: http://home.online.no/~pjacklam', ...
                       'Email: pjacklam@online.no');
         msgbox(txt, 'About...');

      otherwise

         error(['Unrecognized callback string "' command '".']);

   end
