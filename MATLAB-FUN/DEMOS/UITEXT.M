function Aout = uitext(hndl,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10)
%UITEXT Display text in an 'edit' uicontrol, with automatic line breaking.
%	Each string argument corresponds to a new paragraph.

%	Mark W. Reichelt, 8-17-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% pix is the pixel width of the 95 characters from ASCII 32 (space) to
% ASCII 126 (tilde).

c = computer;
if strcmp(c(1:2),'PC')
  % on PC with 8514
  pix = [ ...
       4     4     6     8     8    11     9     4     4     4     6     8 ...
       4     4     4     4     8     8     8     8     8     8     8     8 ...
       8     8     4     4     8     8     8     8    14     8    10     9 ...
      10     9     8    10    10     4     7     9     8    12    10    10 ...
       9    10    10     9     8    10     8    14     9    10     9     4 ...
       4     4     5     8     5     8     8     7     8     8     4     8 ...
       8     4     4     7     4    12     8     8     8     8     5     8 ...
       4     8     8    10     8     8     8     5     4     5     5 ...
  ];
elseif strcmp(c(1:3),'MAC')
  % on MAC
  pix = [ ...
       4     3     5     9     7     9     9     3     5     5     8     7 ...
       4     7     3     7     8     8     8     8     8     8     8     8 ...
       8     8     3     4     6     7     6     8    10     9     8     8 ...
       8     7     7     8     8     5     7     8     7     9     8     8 ...
       8     8     8     8     8     8     9    11     7     7     7     4 ...
       7     4     4     8     4     7     7     7     7     7     6     7 ...
       7     5     6     7     5    11     7     7     7     7     6     7 ...
       6     7     7    11     7     7     7     5     3     5     8 ...
  ];
else
  % on Sparc10
  pix = [ ...
       4     4     5     8     8    12    10     3     5     5     7     9 ...
       3     9     3     4     8     8     8     8     8     8     8     8 ...
       8     8     3     4     8     9     8     8    13    11     9    10 ...
      10     9     9    11    10     5     8    10     8    13    10    11 ...
       9    11     9     9     9    10    11    15    10     9     9     4 ...
       4     4     7     8     3     8     8     8     8     8     3     8 ...
       8     3     3     7     3    11     8     8     8     8     5     8 ...
       4     8     8     9     7     7     7     5     3     5     8 ...
  ];
end

units = get(hndl,'Units');
set(hndl,'Units','pixels');
pos = get(hndl,'Position');
set(hndl,'Units',units);

A = '';

for i = 1:nargin-1
  cmd = ['s = s' num2str(i) ';'];
  eval(cmd);

  s = deblank(s);	% remove any trailing blanks
  if isempty(s)
    A= str2mat(A,' ');

  else
    while ~isempty(s)
      widths = pix(abs(s) - 31);
      c = 3*pix(1) + cumsum(widths);	% spaces at beginning, end, plus one
      i = max(find(c <= pos(3)));	% find last position less than width
      if i < length(s)
        j = max(find(abs(s(1:i+1)) == 32));	% find white space
        if ~isempty(j)
          i = j - 1;
          % null out blank spaces at and after j (they're replaced by new line)
          while abs(s(j)) == 32		% note that s has been deblanked
            s(j) = '';			% so that j < length(s)
          end
        end
      end
      A = str2mat(A,[' ' s(1:i)]);	% add a space at beginning
      s = s(i+1:length(s));
    end

  end
end

A = A(2:size(A,1),:);

set(hndl,'String',A);

if nargout > 0
  Aout = A;
end
  
