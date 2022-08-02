function o=mayan(s)
%MAYAN  Mayan numerals converter.
%   MAYAN(S), converts a string S containing numerals
%   from or to mayan numerals. If S contains arabic numerals,
%   it will convert S to mayan numerals. If S contains mayan
%   numerals, it will convert S to arabic numerals.
%   Output argument will be numerals in either arabic or mayan format.
%
%   S can be either a cell array of strings (cellstr)
%   or just a string. If input is cellstr then output is cellstr,
%   otherwise, output will be a string. The function does not
%   accept numerical values as input.
%
%   If S is a string of arabic literals then an additional plus
%   character to that string will indicate that the output will
%   be in sparse format (ie fixed height), otherwise the output
%   will be in compact format (one space limiting the characters).
%   Sparse/fixed output enables the user to perform addition of two
%   mayan numerals by simply performing horizontal concatenation.
%
%   The mayan numeral system has 20 as a counting base
%   ie it is vigesimal. The positioning of numerals is performed
%   vertically downwards in descending order (lowest values at
%   the bottom). The convetion for this function is that each of
%   the numerals has to be separated by a line of spaces.
%   Below is the mayan numerals with values from 0 to 20:
%
%      Arabic  Mayan   Arabic  Mayan   Arabic  Mayan   Arabic  Mayan
%           0   <()>        5   ====       10   ====       15   ====
%                                               ====            ====
%                                                               ====
%
%           1      o        6      o       11      o       16      o
%                               ====            ====            ====
%                                               ====            ====
%                                                               ====
%
%           2     oo        7     oo       12     oo       17     oo
%                               ====            ====            ====
%                                               ====            ====
%                                                               ====
%
%           3    ooo       8     ooo       13    ooo       18    ooo
%                               ====            ====            ====
%                                               ====            ====
%                                                               ====
%
%           4   oooo       9    oooo       14   oooo       19   oooo
%                               ====            ====            ====
%                                               ====            ====
%                                                               ====
%
%   The width of a bar '====' is unimportant and can be written with
%   dashes '-' instead. The dots 'o' can be written with periods '.'
%   instead. The mayan zero symbol '<()>' can be written with any
%   combination of its characters or be written with an arabic zero '0'
%   instead. Thus the following form of writing a mayan numeral is valid:
%      char({'...','-',' ','()'})    %which is the same as 8*20+0.
%
%   Examples:
%       mayan 64302                        %mayan: 8*20^3 + 0*20^2 + 15*20 + 2
%       mayan(char({'oo','='}))            %mayan for arabic 7
%       mayan([mayan('45+') mayan('80+')]) %perform mayan addition
%       mayan 1000+                        %fixed size (sparse) format
%
%   See also ROMAN, IONIC, BABYLONIAN, CHB.

% Copyright (c) 2003-10-01, B. Rasmus Anthin
% Revision 2003-10-02, 2003-10-03.

mayanum=char(ones(4,4,20)*' ');       %20 digits of size 4x4
for i=1:20
   if i<20
      for j=1:mod(i,5)
         mayanum(1,5-j,i)='o';
      end
      for j=1:3
         if i>=5*j
            mayanum(j+1,:,i)='====';
         end
      end
   end
end
mayanum(1,:,20)='<()>';         %zero

error(nargchk(1,1,nargin))
if ~iscell(s), s={s};end
for k=1:length(s)
   x=lower(s{k});
   isarabic=size(x,1)==1 & all(ismember(x,'0123456789+'));
   ismayan=all(ismember(x,' <>().o0-_='));
   if isarabic & ismayan, ismayan=0;end
   if ~ischar(x) | (~isarabic & ~ismayan)
      error('Input(s) must be a string of either mayan or arabic numerals.')
   end
   
   %%%%% Conversion %%%%%
   if ismayan                 %MAYAN  -> ARABIC
      x=[x;blanks(size(x,2))];   %ensure that the last token will be added
      yy=[];
      y=[];
      %scanning for tokens
      for i=1:size(x,1)
         xx=strrep(x(i,:),' ','');
         if ~isempty(xx)             %if row isn't blank...
            xx=strrep(xx,'<','');    %remove "zero" characters
            xx=strrep(xx,'(','');
            xx=strrep(xx,')','');
            xx=strrep(xx,'>','');
            xx=strrep(xx,'0','');
            xx=[xx ' '];             %prevent xx from being empty
            if isempty(yy), yy=0;end    %start counting if row isn't blank
            switch(xx(1))
            case {'o','.'}             %dots
               yy=yy + 1*length(find(xx~=' '));   %count dots
            case {'-','_','='}         %bar
               yy=yy + 5;                         %bar = 5
            %case {'<','(','0'}     %"zero"
            otherwise   
               yy=0;
            end
         else    %add token
            y=[y yy];
            yy=[];
         end
      end
      %convert list of positional values to decimal (arabic)
      y=int2str(y*20.^(length(y)-1:-1:0)');
   elseif isarabic            %ARABIC -> MAYAN
      iscomp=~any(x=='+');
      x=strrep(x,'+','');
      x=str2num(x);
      y='';
      while x                 %LSB -> MSB
         idx=mod(x,20);
         if ~idx, idx=20;end
         yy=mayanum(:,:,idx);
         if iscomp
            yy=delmat(yy,find(all(yy==' ',2)));  %remove empty rows
         end
         yy=[yy;blanks(4)];  %separate numeral tokens
         y=[yy;y];
         x=floor(x/20);
      end
      y=y(1:end-1,:);   %remove last separation
      if isempty(y), y=mayanum(1,:,20);end
   end
   o{k}=y;
end
if length(o)==1, o=o{1};end