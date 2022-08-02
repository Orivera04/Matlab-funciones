function comets(x,y,p,color,linesty,linewid)

% COMETS Multiple comet plot.
%      COMET(Y) displays an animated comet plot of the vector Y.
%      COMET(X,Y) displays an animated comet plot of vector Y vs. X.
%      COMET(X,Y,P) uses a comet of length p*length(Y).
%        Default is p = 0.10.
%      COMETS(X,Y,P,COLOR,LINESTY,LINEWID)
%        Other arguments that can be specified are:
%      COLOR = [CH1 CB1 CT1; CH2 CB2 CT2; ... ; CHN CBN CTN], where
%        CH - color of the head,  CB - body, CT - tail. The full
%        format is Nx3 string matrix if colors are letters (among 
%        'rgbycmwk') or Nx9 number matrix if colors are RGB triplets.
%      LINESTYLE = [LSH1 LSB1 LST1; ... ; LSHN LSBN LSTN],
%        where LSH1 of the size [1 2] is the linestyle of the head,
%        etc. The full size is Nx6 string matrix, each linestyle 
%        represented by [1 2] size  string: 'o ', '- ', '--', etc.
%        For example LINESTYLE = ['x --- '; '* - -'] represents two
%        comets: the first one with the head 'x', the body '--' and
%        the tail '-', the second with the head '*', the body '-' and
%        the tail '-'.    
%      LINEWIDTH = [LWH1 LWB1 LWT1; ... LWHN LWBN LWTN], where LWH1
%        (positive integer) is the linewidth (or markersize) of the
%        head, etc. The full size is Nx3 matrix.
%
%      If all line property arguments (COLOR, LINESTYLE, LINEWIDTH)
%      have only 1 row, then COMETS works in fast "vectorized" regime
%      and all comets have the same colors and linestyles (only 3 line
%      objects will be created). If any of these arguments have more
%      than 1 row the total number of comets will be equal to the
%      number of columns of matrices X and Y, each comet represented
%      by 3 separate line objects (their movement is slower in this
%      case). If the number of rows in the line property arguments is 
%      less than the number of columns in X, Y then colors and
%      linestyles will be cycled through.
%
%      COMETS is the front-end to COMETS0, which can be called by
%      itself but with stricter syntax.
%        
%      COMETS, by itself, is self demonstrating.
%	Example:
%	    t = -pi:pi/200:pi;
%	    comets(t,tan(sin(t))-sin(tan(t)))
%	See also COMETS0, CMTSDEMO, COMET, COMET3.

%       Original: COMET,
%	Charles R. Denham, MathWorks, 1989.
%	Revised 2-9-92, LS and DTP; 8-18-92, 11-30-92 CBM.
%	Copyright (c) 1984-93 by The MathWorks, Inc.
%
%   Modified 7-18-94, Kirill Pankratov, CMPO MIT

 % Defaults ....................................................
pdflt = .1;             % Default for partial body length
colordflt = 'wym';      % Default for colors
linestydflt = 'o -';    % Default for linestyles
linestybodydflt = '-';  % Default for body linestyle
linestytaildflt = '-';  % Default for body linestyle
linewiddflt = [1 1];    % Default for linewidth
mksizedflt = 6;         % Default for markersize

 % Handle input arguments .......................................
nolnw = 0;
if nargin < 6, linewid = linewiddflt; nolnw = 1; end
if nargin < 5, linesty = linestydflt; end
if nargin < 4, color = colordflt; end
if nargin < 3, p = pdflt; end

if nargin == 0,                    % Demo mode 
   x = -pi:pi/200:pi;
   y = tan(sin(x))-sin(tan(x));
   p = 0.1;
else                               % Make x uniform
  if nargin < 2, y = x; x = 1:size(y,1); x = x(:,ones(1,size(y,2))); end
end
if size(x,1) == 1, x = x(:); end   % Transpose if x is a row vector
if size(y,1) == 1, y = y(:); end   % Transpose if y is a row vector
if size(x,2)==1, x = x(:,ones(1,size(y,2))); end %

 % Fill empty with defaults ..................
if p == [], p = pdflt; end
if color == [], color = colordflt; end
if linesty == [], linesty = linestydflt; end
if linewid == [], linewid = linewiddflt; end

if any(size(x,1)~=size(y,1)) % Check size ....
  fprintf('\n  Error: arguments x and y must be of the same size.\n\n')
  return
end

lcom = size(x,1);       % Length of each comet
ncom = size(x,2);       % Number of comets
lbody = round(p*lcom);  % Length of comet bodies

if size(color,1)==1&size(linesty,1)==1&size(linewid,1)==1  % One line
  flag = 'one';
else                                                       % Many lines
  flag = 'many';
end

 % Colors .........................................................
if size(color,1) == 1, color = color(ones(ncom,1),:); end
[nc,lc] = size(color);
if isstr(color)         % If specified by strings
  num = zeros(1,3); lc = min(lc,3);
  num(1:lc) = ones(1,lc);
  A = cumsum(num);
else                    % If specifyed by RGB numbers
  if lc<3, fprintf('\n  Error: not enough data for color\n\n')
  return, end
  num = zeros(1,3); lc = min(floor(lc/3),3);
  num(1:lc) = ones(1,lc);
  num = cumsum(num);
  A = reshape(1:9,3,3);
  if max(num) == 1, A = (1:3)'*ones(1,3); else, A = A(:,num); end
end
colorhead = color(:,A(:,1));
colorbody = color(:,A(:,2));
colortail = color(:,A(:,3));
A = (1:nc)'; A = A(:,ones(1,ceil(ncom/nc)));
num = A(1:ncom);
colorhead = colorhead(num,:);
colorbody = colorbody(num,:);
colortail = colortail(num,:);

 % Linestyles and markers ...............................
[nc,lc] = size(linesty);
if isstr(linesty)            % OK
  linestyhead = linesty(:,1:min(2,lc));
  if lc<3, linestybody = setstr(ones(nc,1)*linestybodydflt);
  else, linestybody = linesty(:,3:min(4,lc));
  end
  if lc<5, linestytail = setstr(ones(nc,1)*linestybodydflt);
  else, linestytail = linesty(:,5:min(6,lc));
  end
else
  fprintf('\n  Error: linestyles must be a string \n\n')
  return
end
A = (1:nc)'; A = A(:,ones(1,ceil(ncom/nc)));
num = A(1:ncom);
linestyhead = linestyhead(num,:);
linestybody = linestybody(num,:);
linestytail = linestytail(num,:);

 % Linewidth and markersize .............................
if isstr(linewid)
  fprintf('\n  Error: linewidth must be numbers \n\n')
  return
end
[nc,lc] = size(linewid);
if lc<2, linewid(:,2) = 1*ones(nc,1); end
if lc<3, linewid(:,3) = linewid(:,2); end
A = (1:nc)'; A = A(:,ones(1,ceil(ncom/nc)));
num = A(1:ncom);
linewid = linewid(num,:);
A = any((linestyhead(:,ones(1,5))==ones(size(linestyhead),1)*'o*x+.')');
num = find(A');
if nolnw&num~=[], linewid(num,1) = mksizedflt*ones(size(num)); end

 % Set axes limits if not fixed .........................
if ishold==0
  clf
  axlim = [min(x(finite(x))) max(x(finite(x)))];
  axlim = [axlim  min(y(finite(y))) max(y(finite(y)))];
  axis(axlim)
end

 % Create the lines ..............................................
if strcmp(flag,'one')                       % If one line
  lh = ones(3,1);
  lh(1)=line; lh(2)=line; lh(3)=line;
else                                        % If many lines
  lh = ones(3,ncom);
  for jc = 1:ncom
    lh(1,jc) = line; lh(2,jc) = line; lh(3,jc) = line;
  end
end

 % Call the primitive COMETS0 ....................................
comets0(lh,x,y,lbody,colorhead,colorbody,colortail,linestyhead,...
   linestybody,linestytail,linewid)
