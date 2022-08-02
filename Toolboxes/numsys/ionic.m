function o=ionic(s)
%IONIC  Greek numerals converter.
%   IONIC(S), converts a string S containing numerals
%   from or to ionic numerals (younger greek numeral system).
%   If S contains ionic numerals, it will convert S to arabic numerals.
%   If S contains arabic numerals, it will convert S to ionic numerals.
%   The output argument will be numerals in either arabic or ionic format.
%
%   S can be either a cell array of strings (cellstr)
%   or just a string. If the input is a cellstr then the output will be a
%   cellstr, otherwise it will be a string. The function does not accept
%   numerical values as input.
%
%   The ionic numerals can only be represented in the range from 0 to 999.
%   The numerals are as follows:
%
%      Arabic  Ionic       Arabic  Ionic        Arabic  Ionic
%           1  \alpha          10  \iota           100  \rho
%           2  \beta           20  \kappa          200  \sigma
%           3  \gamma          30  \lambda         300  \tau
%           4  \delta          40  \mu             400  \uspilon
%           5  \epsilon        50  \nu             500  \phi
%           6  \digamma        60  \xi             600  \chi
%           7  \zeta           70  \omikron        700  \psi
%           8  \eta            80  \pi             800  \omega
%           9  \theta          90  \qoppa          900  \sampi
%
%   Examples:
%      ionic 999             %results in '\sampi\qoppa\theta'
%      ionic \nu\zeta        %same as arabic 57
%      title(ionic('456'))   %displays the result
%
%   See also ROMAN, MAYAN, BABYLONIAN, CHB.

% Copyright (c) 2003-10-02, B. Rasmus Anthin.

ionicnum={'\alpha','\beta','\gamma','\delta','\epsilon','\digamma','\zeta','\eta','\theta',...
      '\iota','\kappa','\lambda','\mu','\nu','\xi','\omikron','\pi','\qoppa',...
      '\rho','\sigma','\tau','\uspilon','\phi','\chi','\psi','\omega','\sampi'};
arabicnum=[1:9 10:10:90 100:100:900];

error(nargchk(1,1,nargin))
if ~iscell(s), s={s};end
for k=1:length(s)
   x=lower(s{k});
   isarabic=all(ismember(x,'0123456789'));
   isionic=~isarabic;   %temporary solution
   if ~ischar(x) | (~isarabic & ~isionic)
      error('Input(s) must be a string of either ionic or arabic numerals.')
   end
   if isarabic & (str2num(x)>999 | str2num(x)<0)
      error('Input(s) out of range.')
   end
   if isionic & length(findstr(x,'\'))>3
      error('Ionic numerals can only consist of at most 3 greek letters.')
   end
   
   %%%%% Conversion %%%%%
   if isionic                 %IONIC  -> ARABIC
      y=0;
      x=strrep(x,' ','');
      while ~isempty(x)
         [t,x]=strtok(x,'\');
         i=strmatch(['\' t],ionicnum);
         if ~isempty(i)
            y=y+arabicnum(i);
         end
      end
   elseif isarabic            %ARABIC -> IONIC
      x=fliplr(x);
      y='';
      for i=1:length(x)
         xx=x(i)-'0';
         y=[ionicnum{xx*10^(i-1)==arabicnum} y];
      end
   end
   o{k}=y;
end
if length(o)==1, o=o{1};end