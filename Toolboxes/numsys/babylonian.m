function o=babylonian(s)
%BABYLONIAN  Babylonian numerals converter.
%   BABYLONIAN(S), converts a string S containing numerals
%   from or to babylonian numerals. If S contains arabic numerals,
%   it will convert S to babylonian numerals. If S contains babylonian
%   numerals, it will convert S to arabic numerals.
%   Output argument will be numerals in either arabic or babylonian format.
%
%   S can be either a cell array of strings (cellstr)
%   or just a string. If input is cellstr then output is cellstr,
%   otherwise, output will be a string. The function does not
%   accept numerical values as input.
%
%   The babylonian numeral system has 60 as a counting base
%   ie it is sexagesimal. The positioning of numerals is performed
%   horizontally with lowest significance to the right. The convention
%   for this function is that each of the numerals has to be separated
%   by a colum of spaces. The original form of the babylonian numeral
%   system didn't have any form of zero, thus 61, 1 and 1/60 etc.. [2]
%   were represented the same way. However at about 400 BC [1], they
%   began to use two wedges to indicate where there was a emptyness or
%   zero for a certain power of 60. This function uses the quote '"'
%   character to denote this. Note that this function doesn't deal with
%   rationals as the babylonian system did. Later versions will have
%   this feature.
%
%   Either one can arrange each numeral according to the table below,
%   or one can write the characters as a sequence in a string,
%   eg: '<<YY YYYYYYY', which means 22*60+7. Below is a table
%   showing the numerals used:
%
%      0 :  " 
%
%          00    10     20      30      40      50
%        +-------------------------------------------+
%      1 | Y    <Y    <<Y    <<<Y    <<<Y    <<<Y    |
%        |                             <      <<     |
%        |                                           |
%      2 | YY   <YY   <<YY   <<<YY   <<<YY   <<<YY   |
%        |                             <      <<     |
%        |                                           |
%      3 | YYY  <YYY  <<YYY  <<<YYY  <<<YYY  <<<YYY  |
%        |                             <      <<     |
%        |                                           |
%      4 | YYY  <YYY  <<YYY  <<<YYY  <<<YYY  <<<YYY  |
%        | Y     Y      Y       Y      <Y     <<Y    |
%        |                                           |
%      5 | YYY  <YYY  <<YYY  <<<YYY  <<<YYY  <<<YYY  |
%        | YY    YY     YY      YY     <YY    <<YY   |
%        |                                           |
%      6 | YYY  <YYY  <<YYY  <<<YYY  <<<YYY  <<<YYY  |
%        | YYY   YYY    YYY     YYY    <YYY   <<YYY  |
%        |                                           |
%      7 | YYY  <YYY  <<YYY  <<<YYY  <<<YYY  <<<YYY  |
%        | YYY   YYY    YYY     YYY    <YYY   <<YYY  |
%        | Y     Y      Y       Y       Y       Y    |
%        |                                           |
%      8 | YYY  <YYY  <<YYY  <<<YYY  <<<YYY  <<<YYY  |
%        | YYY   YYY    YYY     YYY    <YYY   <<YYY  |
%        | YY    YY     YY      YY      YY      YY   |
%        |                                           |
%      9 | YYY  <YYY  <<YYY  <<<YYY  <<<YYY  <<<YYY  |
%        | YYY   YYY    YYY     YYY    <YYY   <<YYY  |
%        | YYY   YYY    YYY     YYY     YYY     YYY  |
%        +-------------------------------------------+
%
%   The vertical wedges 'Y' can be lower case as well, it can also
%   be represented by any of the following characters:
%      'T','V','I','|','!','/','\'
%   in either upper or lower case. The horizontal wedge is only
%   represented by the '>' since it is the only character that most
%   resembles a horizontal wedge.
%
%   Examples:
%      babylonian 21609           %147^2, notice the gap
%      babylonian('VVV <<VVVVVV') %same as 3*60+26 = 206
%      babylonian('YYY <<YYYYYY') %returns '206'
%      babylonian(roman('XLIV'))  %returns babylonian for '44'
%
%   See also ROMAN, MAYAN, IONIC, CHB.

% Referenses : [1] http://www-gap.dcs.st-and.ac.uk/~history/HistTopics/Zero.html
%              [2] http://www-gap.dcs.st-and.ac.uk/~history/HistTopics/Babylonian_numerals.html
%              [3] http://www.wikipedia.org/wiki/Numeral_system
%              [4] http://www.phys.virginia.edu/classes/109N/lectures/babylon.html

wedgenum=char(ones(3,6,60)*' ');    %59 digits of size 3x6
for i=1:59
   for j=1:mod(i,10)        %number of Y:s (1)
      wedgenum(ceil(j/3),4+mod(j-1,3),i)='Y';
   end
   for j=1:floor(i/10)      %number of <:s (10)
      if j
         wedgenum(ceil(j/3),3-mod(j-1,3),i)='<';
      end
   end
end
wedgenum(1,5,60)='"';       %zero symbol (not until 400BC, see [1])

error(nargchk(1,1,nargin))
if ~iscell(s), s={s};end
for k=1:length(s)
   x=upper(s{k});
   isarabic=size(x,1)==1 & all(ismember(x,'0123456789'));
   iswedge=all(ismember(x,' <"YTVI|!/\'));
   if ~ischar(x) | (~isarabic & ~iswedge)
      error('Input(s) must be a string of either babylonian or arabic numerals.')
   end
   
   if iswedge                 %BABYLONIAN -> ARABIC
      if isempty(deblank(x)), x='"';end
      x=[x blanks(size(x,1))'];
      yy=[];
      y=[];
      %scanning for tokens
      for i=1:size(x,2)
         xx=strrep(x(:,i)',' ','')';
         if ~isempty(xx)
            xx=strrep(xx','"','')';     %remove zero marker
            xx=[xx;' '];
            if isempty(yy), yy=0;end
            switch(xx(1))
            case {'Y','T','V','I','|','!','/','\'}
               yy=yy + 1*length(find(xx~=' '));
            case {'<'}
               yy=yy + 10*length(find(xx~=' '));
            otherwise
               yy=0;
            end
         else    %add token
            y=[y yy];
            yy=[];
         end
      end
      %convert list of positional values to decimal (arabic)
      y=int2str(y*60.^(length(y)-1:-1:0)');
   elseif isarabic            %ARABIC     -> BABYLONIAN
      x=str2num(x);
      y='';
      while x
         idx=mod(x,60);
         if ~idx, idx=60;end
         yy=wedgenum(:,:,idx);
         yy=delmat(yy,find(all(yy==' ',1)),2);
         yy=[yy blanks(3)'];
         y=[yy y];
         x=floor(x/60);
      end
      y=y(:,1:end-1);
   end
   o{k}=y;
end
if length(o)==1, o=o{1};end