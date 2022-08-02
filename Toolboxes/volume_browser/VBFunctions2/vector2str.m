function string=vector2str(num,sep)
% Convert a numeric vector into a "sep" separated string.
%
% Written by: E. Rietsch: October 20, 2006
% Last updated:
%
%         string=vector2str(num,sep)
% INPUT
% num     constant or vector
% sep     optional string with separator; default: sep=' ';
% OUTPUT
% string  string of the entries of the "num"

if nargin == 1
   sep=' ';
end

nnumbers=numel(num);

if nnumbers == 1
   string=num2str(num);
   
else
   string=blanks(nnumbers*(12+length(sep))); % Reserve room for string
   ia=0;
   for ii=1:nnumbers
      str=[num2str(num(ii)),sep];
      ie=ia+length(str);
      ia=ia+1;
      string(ia:ie)=str;
      ia=ie;
   end
   try
      string=string(1:ie-length(sep));
   catch
      string='';
   end
end
