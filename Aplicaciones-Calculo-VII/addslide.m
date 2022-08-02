function addslide(filespec,varargin)
%ADDSLIDE Insert variables into a PowerPoint presentation.
%
% ADDSLIDE(filename,var1,var2,...) Insert variables into 
%   new slides at the end of a PowerPoint presentation.
% 
%   An invalid or empty filename or a new filename will 
%   bring up a dialog box to enable the user to select an 
%   existing file or create a new file.
%
%   Inputs can be strings, cell arrays of strings, 2D numeric
%   arrays, and figure handles. Variable sizes should be limited 
%   to avoid overfilling the slides.

% Check for missing arguments and initialize variables
narg=nargin;
if narg < 1, error('Missing input arguments.'); end
nl=char(13);

% Make sure we have a valid file name
if ischar(filespec) & exist(filespec,'file')   % a real file
  fullname=filespec;
else
  if ischar(filespec) & ~isempty(filespec)     % use as default file
    [dname,fname,fext]=fileparts(filespec);
    if isempty(fext), fext='.ppt'; end
    defname=fullfile(dname,[fname fext]);
  else
    defname='*.ppt';                           % use file filter
  end
  [fname,dname]=uiputfile(defname,'Modify or create the file:');
  if isequal(fname,0), return, end
  fullname=fullfile(dname,fname);
end

% Start a session with PowerPoint.
ppapp=actxserver('powerpoint.application');
ppapp.Visible=1;                          % Watch the action...

% Open or create a presentation
if ~exist(fullname,'file')
  ppres=invoke(ppapp.Presentations,'Add');
else
  ppres=invoke(ppapp.Presentations,'Open',fullname);
end

% Process the rest of the arguments
for idx=2:narg
  arg=varargin{idx-1};

  if ishandle(arg) & (floor(arg)==arg)    % figure handle
    ppslide=ppres.Slides.Add(ppres.Slides.Count+1,'ppLayoutBlank'); 
    print('-dmeta',sprintf('-f%d',arg));  % copy plot to clipboard
    ppfig=ppslide.Shapes.Paste;           % paste the clip into the slide
    ppfig.Align(1,-1);                    % center the plot
    ppfig.IncrementTop(200);              % lower the plot
    ppfig.ScaleWidth(1.5,0,1);            % scale width from middle

  elseif isstr(arg)                       % text string
    if length(arg) > 275, warning('possible overfull slide'); end
    ppslide=ppres.Slides.Add(ppres.Slides.Count+1,'ppLayoutTitleOnly'); 
    ppslide.Shapes.Title.TextFrame.AutoSize=1;
    ppslide.Shapes.Title.TextFrame.VerticalAnchor=1;
    ppslide.Shapes.Title.TextFrame.TextRange.Text=arg;

  elseif iscellstr(arg)                   % cell array of strings
    ppslide=ppres.Slides.Add(ppres.Slides.Count+1,'ppLayoutTitleOnly'); 
    str='';
    for idx2=1:length(arg)
      str=[str,arg{idx2},nl];
    end
    if (length(arg) > 5) | (length(str) > 275)
      warning('possible overfull slide'); 
    end
    ppslide.Shapes.Title.TextFrame.AutoSize=1;
    ppslide.Shapes.Title.TextFrame.VerticalAnchor=1;
    ppslide.Shapes.Title.TextFrame.TextRange.Text=str(1:end-1);

  elseif isnumeric(arg) & ~all(ishandle(arg(:))) & (ndims(arg) <= 2)
    ppslide=ppres.Slides.Add(ppres.Slides.Count+1,'ppLayoutTitleOnly'); 
    [r,c]=size(arg);
    if numel(arg) > 20, warning('possible overfull slide'); end
    rs=int2str(r); cs=int2str(c);
    str=[sprintf('Array %s', inputname(idx)),nl,nl];
    for idx2=1:r
        str=[str, sprintf('    %5.5f',arg(idx2,:)), nl];
    end
    ppslide.Shapes.Title.TextFrame.AutoSize=1;
    ppslide.Shapes.Title.TextFrame.VerticalAnchor=1;
    ppslide.Shapes.Title.TextFrame.TextRange.Text=str;
  else
    warning([inputname(idx), ' is not an accepted input and will be ignored.'])
  end %if
end %for   

% Save the file and exit
ppres.SaveAs(fullname,1,0);         % save as presentation
ppres.Close;                        % close the presentation
ppapp.Quit;                         % quit PPT
delete(ppapp);                      % done with the COM server
return

