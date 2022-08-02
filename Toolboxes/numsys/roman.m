function o=roman(s)
%ROMAN  Roman numerals converter.
%   ROMAN(S), converts a string S containing numerals
%   from or to roman numerals. If S contains arabic numerals,
%   it will convert S to roman numerals. If S contains roman
%   numerals, it will convert S to arabic numerals.
%   Output argument will be numerals in either arabic or roman format.
%
%   S can be either a cell array of strings (cellstr)
%   or just a string. If input is cellstr then output is cellstr,
%   otherwise, output will be a string. The function does not
%   accept numerical values as input.
%
%   Examples:
%       roman 1994              %will be roman 'MCMXCIV'
%       roman DCCCLXXXVIII      %results in arabic '888'
%       roman(roman('2003'))    %yields '2003'
%       str2num(roman('xxiii')) %the number 23
%       roman({'iv','VII','4'}) %results in {'4','7','IV'}
%
%   See also MAYAN, IONIC, BABYLONIAN, CHB.

% Copyright (c) 2003-09-28, B. Rasmus Anthin.
% Revision 2003-09-30, 2003-10-01.

romnum='IVXLCDM';
arabnum=[1 5 10 50 100 500 1000];
tab=char(ones(9,4,4)*' ');
for i=1:4            %create roman pattern tables
   for j=1:9
      if j<=3 | (6<=j & j<=8 & i<4)
         j0=5*(j<5)+10*(j>5);
         tab(j,j0-j:4,i)=romnum(2*i-1);
      end
      if i<4    %nothing is higher than M.
         if j==4
            tab(j,3:4,i)=romnum(2*i-[1 0]);
         end
         if 5<=j & j<=8
            tab(j,9-j,i)=romnum(2*i);
         end
         if j==9
            tab(j,3:4,i)=romnum(2*i+[-1 1]);
         end
      end
   end
end
%tab

error(nargchk(1,1,nargin))
if ~iscell(s), s={s};end
for k=1:length(s)
   x=upper(s{k});
   isarabic=all(ismember(x,'0123456789'));
   isroman=all(ismember(x,romnum));
   if ~ischar(x) | (~isarabic & ~isroman)
      error('Input(s) must be a string of either roman or arabic numerals.')
   end
   if isarabic & (str2num(x)>3999 | str2num(x)<0)
      error('Input(s) out of range.')
   end
   x=fliplr(x);
   
   %%%%% Conversion %%%%%
   if isroman            %ROMAN  -> ARABIC
      for i=1:length(x)
         xx(i)=arabnum(x(i)==romnum);
      end
      tmp=0;
      y=0;
      for i=1:length(x)
         if xx(i)<tmp
            y=y-xx(i);
         else
            y=y+xx(i);
         end
         tmp=xx(i);
      end
      y=int2str(y);
   elseif isarabic       %ARABIC -> ROMAN
      x=x-'0';
      y='';
      for i=1:length(x)
         if x(i)
            y=[tab(x(i),:,i) y];
         end
      end
      y=char(strrep(y,' ',''));
   end
   o{k}=y;
end
if length(o)==1, o=o{1};end