function photoIndex(scale,quality,showMe,htmlFile,verbose)
% photoIndex  HTML index of JPEG photos in a directory
%
% Synopsis:  photoIndex
%            photoIndex(scale)
%            photoIndex(scale,quality)
%            photoIndex(scale,quality,showMe)
%            photoIndex(scale,quality,showMe,htmlFile,)
%            photoIndex(scale,quality,showMe,htmlFile,verbose)
%
% Input:   scale = (optional) scale factor (0 < scale <= 1) used to
%                  create smaller images from the original JPEG files.
%                  The number of pixels in the x and y directions is
%                  reduced by scale.  Default:  scale = 0.2
%         quality = (optional) amount of original image information retained
%                   by JPEG compression used to create the lower resolution
%                   image.  Default:  quality = 92, i.e. 92% of original
%                   information *after* scaling is stored in new file
%         showMe = (optional) flag to control whether images are displayed
%                  showMe = 1 causes both the original and the scaled
%                  image to be displayed;  showMe = 0 causes neither image to
%                  be displayed.  showMe can also be a vector of length two
%                  such that showMe(1) controls display of the original image
%                  and showMe(2) controls display of the scaled image
%          htmlFile = (optional, string) name of HTML file to create.
%                     Default:  NMMfiles.html
%          verbose  = (optional) flag to turn off/on printing of directory
%                     contents.  Default:  verbose=1, print directory contents
%
% Output:  HTML file named 'htmlFile'.html.

if nargin<1,  scale = 0.20;  end
if nargin<2,  quality = 92;  end
if nargin<3,  showMe = [1; 1];  end
if nargin<4,  htmlFile = 'photoIndex.html';   end
if prod(size(showMe))==1,  showMe = showMe*[1; 1];  end

if nargin<2,  verbose=1;   end

fhtml = fopen(htmlFile,'w');

beginHTML(fhtml);

d = dir;
p = pwd;
dfiles = {d.name}';              %  cell array with file names on each row
dnames = char(dfiles(3:end,:));  %  Convert to string, discard first two rows
                                 %  because Windows and Unix include "." and ".."

dnames = selectJPEGfiles(dnames);

[m,n] = size(dnames);
fprintf('Batch processing image files\n')
%  tableOfContents(fhtml,dnames);   %  Write table of contents structure to HTML file

showMe = [0; 1; 0];
for i=1:m
    fileName = deblank(dnames(i,:));
    fprintf('\t  %d of %d:   %s,',i,m,fileName)
    thumbName = [getBaseName(fileName),'thumb.jpg'];
    if showMe(3)
      [I,Ismall,fsmall] = loadAndScale(fileName,scale,[0; 1; 0]);
      set(fsmall,'Name',thumbName);   %  rename figure window
    else
      [I,Ismall] = loadAndScale(fileName,scale,[0; 1; 0]);
      set(gcf,'Name',thumbName);   %  rename figure window
    end
    drawnow
    imwrite(Ismall,thumbName,'JPG','Quality',quality);
    fprintf('\tscaled image in %s\n',thumbName);
    addThisImage(fhtml,fileName,thumbName);   %  add to HTML index
end

endHTML(fhtml);
fclose(fhtml);


% ==============================
function addThisImage(fhtml,fileName,thumbName)
% addThisImage  Add label, thumbnail, and link to full scale image to html file
%
% Synopsis:  addThisImage(fhtml,fileName,thumbName)
%
% Input:  fhtml = file handle for output
%         fileName = name of JPEG file containing the full size image
%         thumbName = name of JPEG file containing the thumbnail image

fprintf(fhtml,'\n\n<br>\n<hr>\n<br><br>\n');
anchorSpec = sprintf('href="%s"',fileName);
fprintf(fhtml,'%s\n<br>\n',IMGanchor(thumbName,thumbName));
fprintf(fhtml,'Full size image stored as <a href="%s">%s</a><br>',fileName,fileName);


% =======================
function a = IMGanchor(anchorText,imageFile)
% IMGanchor  Build an anchor string of the form  <a "IMG=imageFile"> anchorText </a>
%
% Input:  anchorText = text to be highlighted in link
%         anchorSpec = (optional) specification of anchor type,
%                      Example:  anchorSpec = 'href="dir/subdir/mfile.m"'
%
% Output: a = string containing html link (anchor)

a = sprintf('<img src="%s"><br>Thumbnail stored as %s\n',imageFile,imageFile);

% ==============================
function jnames = selectJPEGfiles(fnames)
% selectJPEGfiles  Scan list of file names and select those with .jpg extension
%
% Synopsis:  jnames = selectJPEGfiles(fnames)
%
% Input:  fnames = (string) matrix of file and directory names, one per row
%
% Output: jnames = (string) matrix of file names with .jpg extension, one per row
jnames = fnames;
[m,n] = size(fnames);
kdelete = [];
ndel = 0;
for i=1:m
  theString = deblank(jnames(i,:));
  if exist(theString)~=2   %  crude filter to eliminate directories
      ndel = ndel+1;
      kdelete(ndel) = i;
  elseif ~strcmp(lower(getExtensionName(theString)),'jpg')
      ndel = ndel+1;
      kdelete(ndel) = i;
  end
end
kdelete = kdelete(:);     %  indices of names to delete
jnames(kdelete,:) = [];

% ==============================
function [I,Is,fsout] = loadAndScale(fname,scale,showMe)
% loadAndScale  Load a JPEG image and create a scaled image
%
% Synopis:  [I,Is] = loadAndScale(fname)
%           [I,Is] = loadAndScale(fname,scale)
%           [I,Is] = loadAndScale(fname,scale,showMe)
%           [I,Is,fs] = loadAndScale(fname)
%           [I,Is,fs] = loadAndScale(fname,scale)
%           [I,Is,fs] = loadAndScale(fname,scale,showMe)
%
% Input:  fname = (string) name of image file, must have JPG or 'jpg' extension
%         scale = (optional) scale factor, 0 < scale <= 1, used to scale
%                 the image.  e.g., scale = 0.25 creates a new image that has
%                 25 percent as many pixels as the original.  Scaling is achieved
%                 with the imresize function from the image processing toolbox
%         showMe = (optional) flag used to control whether images are displayed
%                  showMe can be a scalar, or a a three-element vector.
%                  If showMe = 1, the small and large images are shown in their
%                  own figure windows.  If showMe = 0, no images are displayed
%                  If showMe is a three-element vector, showMe(1) controls the
%                  display of the original image (showMe(1) = 1, shows the image,
%                  showMe(1) = 0, does not).  Similarly showMe(2) controls the
%                  display of the scaled image.  showMe(3) determines whether
%                  the original and scaled images are shown in *new* figure
%                  windows (showMe(3)=1), instead of reusing the current figure
%                  window (showMe(3)=0)
%
% Output: I = MATLAB image object for the original image
%         Is = image object for the scaled image
%         fs = (optional) figure handle for the scaled image

if nargin<2,  scale = 0.25;      end
if nargin<3,  showMe=[1; 1; 0];  end
if prod(size(showMe))==1;  showMe = showMe*[1; 1; 1];  end

I = imread(fname,'JPG');
if showMe(1)
  if showMe(3), f = figure('Name',fname);   end
  image(I);                    %  display image
end        

Is = imresize(I,scale,'bicubic');   %  reduce image size 
if showMe(2)        
  if showMe(3), fs = figure;   end
  image(Is);       %  display scaled image
end

% --- Free the memory used for images if they are not to be shown
%  If memory is freed, then null matrices are returned to 
%  calling routine, thereby reducing memory usage of calling routine
if ~showMe(1),  I = [];    end   %  free memory used for image
if ~showMe(2),  Is = [];   end  
if nargout>2, fsout = fs;  end         %  copy figure handle to output variable

% =======================================================
function bname = getBaseName(fname)
% --- Logic to extract file name from path, and base name from file name

kpath = findstr(filesep,fname);  %  Look for directory separator strings
if isempty(kpath)
  filename = fname;              %  no path info, filename is complete in fname
else
  filename = fname(1+kpath(end):end);  %  extract filename from end of path
end

kdot=findstr(filename,'.');         %  Find the extension, if there is one.
if isempty(kdot)
  bname = filename;               %  No period found in the file name
else
  bname = filename(1:kdot(1)-1);  %  Period found. Copy chars up to first period
end

% =======================================================
function ename = getExtensionName(fname)
% getExtensionName Extract file file extension from file name

kpath = findstr(filesep,fname);  %  Look for directory separator strings
if isempty(kpath)
  filename = fname;              %  no path info, filename is complete in fname
else
  filename = fname(1+kpath(end):end);  %  extract filename from end of path
end

filename = deblank(filename);     %  strip blanks from end
kdot=findstr(filename,'.');         %  Find the extension, if there is one.
if isempty(kdot)
   fprintf('\n\nIn getExtensionName:  fname = %s\n\n',fname);
   error('no period found in file name:  cannot define extension');
else
  ename = filename(kdot+1:end);  %  Period found. Copy chars from period to end
                                 %  ASSUMES that there is only one period
end

% =============================
function [v,d] = thisVersion
% thisVersion  Returns version number and date for current implementation
v = 0.91;
d = '01 Nov 2000';


% =======================
function beginHTML(fout,docTitle)
% beginHTML  Boilerplate for beginning of the HTML file

if nargin<2, docTitle='Directory Listing';  end

fprintf(fout,'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">\n');
fprintf(fout,'<HTML>\n');
fprintf(fout,'<HEAD>\n\n');
fprintf(fout,'<TITLE>%s</TITLE>\n\n',docTitle);
fprintf(fout,'</HEAD>\n');

fprintf(fout,'<BODY bgcolor="#FFFFFF">\n\n');

fprintf(fout,'<p>\n');
fprintf(fout,'\n\nDirectory Listing from a Digital Camera\n');
fprintf(fout,'<br>\nHTML code automatically generated by photoIndex on %s\n',datestr(now));
[v,d] = thisVersion;
fprintf(fout,'<br>\nphotoIndex version %5.2f last updated on %s',v,d);
fprintf(fout,'\n<p>\n');


% =======================
function endHTML(fout)
% endHTML  Boilerplate for end of the HTML file

fprintf(fout,'</BODY>\n');
fprintf(fout,'</HTML>\n');


% =======================
function h = headingTag(level,headText)
% headingTag  Create a named heading tag corresponding to a directory

lev = fix(level);
if lev>6 | lev<1,  error(sprintf('Heading level %d not allowed in HTML specification',lev));  end

h = sprintf('<h%d>%s</h%d>\n',lev,headText,lev);

% =======================
function tag = JPEGfileNameTag(fname)
% mfileNameTag  Create a one-line link for an m-file.  Link only contains name of mfile
%               This is useful for files (e.g. data files) that do not the H1 line of
%               a typical m-file.
%
% Input:   mfile   = name of the mfile without .m extension
%          itsPath = (string matrix) path to the mfile in the nmm toolbox.  Each directory level
%                    is stored on a separate row.
%                    Examples:  itsPath = 'nmm';  itsPath = ['nmm';'data']
%
% Output:  tag = (string) containing html code for a link to an mfile.  The highlighted text
%                is the name of the mfile.  Auxillary text is the H1 line from the function

anchorSpec = sprintf('href="%s"',fname);   %  pathString contains terminating '/'
tag = sprintf('  %s\n',anchor(fname,anchorSpec));



% =======================
function a = anchor(anchorText,anchorSpec)
% anchorText  Build an anchor string of the form  <a anchorSpec> anchorText </a>
%
% Input:  anchorText = text to be highlighted in link
%         anchorSpec = (optional) specification of anchor type,
%                      Example:  anchorSpec = 'href="dir/subdir/mfile.m"'
%
% Output: a = string containing html link (anchor)

if nargin==1
  a = sprintf('<a>%s</a>',anchorText);
elseif nargin==2
  a = sprintf('<a %s>%s</a>',anchorSpec,anchorText);
else
  error(sprintf('%d arguments supplied to anchor',nargin));
end
