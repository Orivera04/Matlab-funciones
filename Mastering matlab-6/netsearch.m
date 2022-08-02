function ulist=netsearch(varargin)
% MATLAB Java Demo function netsearch.m
%
%  Mastering MATLAB Java Example 2:
%    Open a connection to an internet search engine using
%    Java networking toolkit objects and return the URLs
%    found by the search in a cell array.

%   B.R. Littlefield, University of Maine, Orono, ME 04469
%   7/6/00
%   Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

% Import the java.net and java.io toolkits.
% (It won't hurt to import the same package more than once.)

import java.net.* java.io.*

% Do some error checking.

if nargin < 1
  error('Nothing to search for.');
end
if nargout > 1
  error('Too many output arguments.');
end

% Define the url for a search command and a target string
%     for each host to try in order.

s_host = {'http://www.google.com/search?q=',   '<p><A HREF='
          'http://ink.yahoo.com/bin/query?p=', '<li><a href='};

nhosts = size(s_host,1);      % Number of search hosts defined
found = logical(0);           % Not yet found
ulist = {};                   % Cell array to contain results

% Create a search string from the input arguments.

for (idx=1:nargin)
  if ~isstr(varargin{idx})
    error('Search terms must be strings');
  else
    tmp_str = varargin{idx};

    % If this string argument contains spaces, quote the string
    % and replace the spaces with plus sign characters.

    if findstr(tmp_str, ' ')
      tmp_str = ['%22', strrep(tmp_str, ' ', '+'), '%22'];
    end
    
    % Build up the search string.

    if idx == 1
      s_str = tmp_str;
    else
      s_str = [s_str '+' tmp_str]; 
    end
  end
end

% Start with the initial search host.

uidx = 1;
hostidx = 1;
while isempty(ulist) & (hostidx <= nhosts)

  % Construct a complete URL using the search string.

  s_url = [s_host{hostidx,1}, s_str];

  % Create a URL connection to the search engine.

  searchHost = URL(s_url);

  % Open a buffered input stream reader to read one line at a time.

  shBuf = BufferedReader(InputStreamReader(searchHost.openStream));

  % Read the lines of the page returned by the search engine 
  %   and extract any target URLs until the the page ends.

  linebuf = shBuf.readLine;
  while ~isempty(linebuf);
    found = strncmp(linebuf, s_host{hostidx,2}, length(s_host{hostidx,2}));
    if found
      tmp = strtok(linebuf(length(s_host{hostidx,2})+1:end),'>');
      ulist{uidx} = strrep(tmp, '"', '');
      uidx = uidx + 1;
    end
    linebuf = shBuf.readLine;
    if isempty(linebuf)              % Check the next line as well.
      linebuf = shBuf.readLine;
    end
  end

  % We are done with the page so close the connection.

  shBuf.close;

  % If a target URL was not found, try the next host.

  if isempty(ulist)
    hostidx = hostidx + 1;
  end
end

if isempty(ulist)
  ulist = [];
elseif length(ulist) == 1
  ulist = ulist{1};
end
