function ulist=netsearch(varargin)
% MATLAB Java Demo function netsearch.m
%
%  Mastering MATLAB 7 Java Example 4:
%    Open a connection to an internet search engine using
%    Java networking toolkit objects and return the URLs
%    found by the search in a cell array.


% Import the java.net and java.io toolkits to save typing.
import java.net.* java.io.*

% Define the url for a search command and a target string
%     for each host to try in order.
s_host = {
           'http://www.google.com/search?q=',   '<p class=g><a href='
           'http://search.yahoo.com/search?p=', 'H=0/*-href='
         };

nhosts = size(s_host,1);      % Number of search hosts defined
ulist = {};                   % Cell array to contain results

% Do some error checking.
if nargin < 1
  error('Nothing to search for.');
end
if nargout > 1
  error('Too many output arguments.');
end

% Create a search string from the input arguments.
for (idx=1:nargin)
  if ~ischar(varargin{idx})
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
  s_con=java.net.URL(s_url);

  % Open an input stream on the connection.
  s_stream = openStream(s_con);

  % Open an input stream reader to read the stream.
  s_rdr = InputStreamReader(s_stream);

  % Open a buffered reader to read one line at a time.
  shBuf = BufferedReader(s_rdr);

  % Read the lines of the page returned by the search engine 
  %   and extract any target URLs until the the page ends.

  linebuf = shBuf.readLine;
  while ~isempty(linebuf)
    linebuf=char(linebuf);
    found = findstr(linebuf, s_host{hostidx,2});
    if ~isempty(found)
      tmp = strtok(linebuf(found(1)+length(s_host{hostidx,2}):end),'>');
      ulist{uidx} = strrep(tmp, '"', '');
      uidx = uidx + 1;
    end
    linebuf = shBuf.readLine;
  end

  % We are done with this page so close the connection.
  shBuf.close;

  % Try the next host.
  hostidx = hostidx + 1;
end

if isempty(ulist)
  ulist = [];
elseif length(ulist) == 1
  ulist = ulist{1};
end
