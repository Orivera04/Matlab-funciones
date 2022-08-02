function p = path(a,b)
%PATH	Control MATLAB's directory search path.
%	PATH, by itself, prettyprints MATLAB's current search path.
%	The search path list originates as the environment variable
%	MATLABPATH in the underlying operating system, or is set by
%	MATLABRC, and is perhaps individualized by STARTUP.
%
%	P = PATH returns a string containing the path in P.
%	PATH(P) changes the path to P.
%	PATH(P1,P2) changes the path to the concatenation of the
%	two path strings P1 and P2.  Thus PATH(PATH,P) appends
%	a new directory to the current path and PATH(P,PATH)
%	prepends a new path.  If P1 or P2 are already on the path,
%	they are not added.
%
%	For example, the following statements add another directory
%	to MATLAB's search path on various operating systems:
%
%	  Unix: path(P,'/home/myfriend/goodstuff')
%	  VMS:  path(P,'DISKS1:[MYFRIEND.GOODSTUFF]')
%	  DOS:  path(P,'TOOLS\GOODSTUFF')
%	  Mac:  path(P,'Tools:GoodStuff')
%
%	See also GETENV, WHAT, CD, DIR.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin == 0	% pretty-print
    if nargout == 0
	matlabpath
    else
	p = matlabpath;
    end
elseif nargin == 1
    if ~isstr(a)
	error('Arguments must be strings.')
    end
    matlabpath(a);
elseif nargin == 2
    if ~isstr(a) | ~isstr(b)
	error('Arguments must be strings.')
    end
    pathsep = ':';
    c = computer;
    if strcmp(c(1:2),'PC') |  strcmp(c(1:2),'MA')
	pathsep = ';';
    elseif strcmp(c(1:2),'VA')
	if strcmp(c(1:7),'VAX_VMS')
            pathsep = ',';
       	end
    end

    % look to see if a is contained in b or vice versa - if so, don't add it
    pp = matlabpath;

    % see if a is truly contained in b , vv, or not
    % i.e., check for case of adding /pname when /pname/qname is already there
    ind = findstr(a,b);
    ab = ~isempty(ind);
    if ab  % a is in b or vv, but is it really...
       aa = a; bb = b; if length(bb) > length(aa), bb = a; aa = b; end
       if length(aa) > length(bb)  % b contained in a
          for j = 1:length(ind)
             if length(aa) > (ind(j)+length(bb)-1)  % look at next char - if not file sep
                if ~strcmp(pathsep,aa(ind(j)+length(bb)))
                   ab = 0;
                else
                   ab = 1;
                end
             else
                ab = 1;
             end
             if ab == 1  % now check for leading character
                if ind(j) > 1
                   if ~strcmp(pathsep,aa(ind(j)-1))
                      ab = 0;
                   else
                      break;
                   end
                else
                   break;
                end
             end
          end
       end
    end
    if ~strcmp(pp,a) & ~strcmp(pp,b) % if neither are the existing path, replace path
       if ~ab
          matlabpath([a pathsep b]);
       else
          if length(a) > length(b)
             matlabpath(a);
          else
             matlabpath(b);
          end
       end
    else  % a or b is already the path
       if ~ab
          matlabpath([a pathsep b]);
       end
    end
end
