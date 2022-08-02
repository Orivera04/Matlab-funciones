function token=scanner(str)
%SCANNER  Scan string into tokens.
%   TOKEN = SCANNER(STR), where STR is a character string
%   and TOKEN is the resulting token list as a row vector
%   of string (character matrix).
%
%   See also TOKCAT.

% Copyright (c) 2001-08-19, B. Rasmus Anthin.

len=length(str);
token='';
R=[str ' '];
D=char('(',')','+','-','*','/','\','^');
while ~isempty(R)
   j=1;
   while any(R(j)==D) & j<length(R)
      token=strvcat(token,R(j));
      j=j+1;
   end
   [T,R]=strtok(R,D);
   token=strvcat(token,T);
end

%%take care of derivatives
%for i=1:size(token,1)-4
%   if token(i,1)=='d' & deblank(token(i+1,1))=='/' & token(i+2,1)=='d' & length(token(i+2,:))>1
%      token=strvcat(token(1:i-1,:),strrep([token(i,:) token(i+1,:) token(i+2,:)],' ',''),token(i+3:end,:));
%   end
%end
%tmp='';
%for i=1:size(token,1)
%   if strncmp(token(i,:),'d/d',3) & length(token(i,:))>3
%      tmp=strvcat(tmp,token(i,1:3),token(i,4:end));
%   else
%      tmp=strvcat(tmp,token(i,:));
%   end
%end
%token=tmp;
if all(isspace(token(end,:)))
   token=token(1:end-1,:);
end