function vars=mmvarnames(FName)
%MMVARNAMES M-File Variable Names. (MM)
% MMVARNAMES FName displays the variable names created in the M-file
% FName. S=MMVARNAMES('FName') returns all known variable names in the
% M-file FName in the cell array S.
% Fname can be a file anywhere on the MATLAB path, a MATLAB partial
% path with a file name, or a full path to any M-file.
%
% Variables created within EVAL and ASSIGNIN statements are not found.
% If multiple statements appear on one line without semicolon statement
% termination, this function may return extraneous names.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 4/8/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

% variable names appear in function declaration lines,
% global declaration lines, persistent declaration lines, and
% on the left hand side of assignment statements.

if nargin==0 | ~ischar(FName)
   error('String M-file Name Required.')
end
if length(FName)>1 & ~strcmpi(FName(end-1:end),'.m') % add .m if needed
   FName=[FName(:).' '.m'];
end
fid=fopen(FName,'rt');
if fid==-1 % opening failed
   error(['Can''t Find File: ' FName])
end
vars=cell(0);
dlims=char(0:127);
dlims=dlims(~local_isvarchar(dlims));
while 1 % look at each line in the file
   line=fgetl(fid);  % get next line
   if ~ischar(line)  % done with file if line=-1
      break
   elseif ~isempty(line) % parse line for valid variables
      
      line=local_clearstrcom(line); % dump embedded strings and comments
      % if continuations exist add them to the current line
      while length(line)>3 & strcmp(line(end-2:end),'...')
         lnew=fgetl(fid);
         if ischar(lnew)
            line=[line(1:end-3) local_clearstrcom(lnew)];
         end
      end
      % Now have a complete line
      % handle special lines: function,global,persistent
      [line,vars]=local_getspecial(line,vars,dlims);  % handle special lines
      
      % now look for assignment statements
      line=strrep(line,'~=',''); % eliminate logical statements
      line=strrep(line,'>=',''); % containing '='
      line=strrep(line,'<=','');
      line=strrep(line,'==','');
      
      while ~isempty(line)             %  look for variables on l.h.s of =
         [token,line]=strtok(line,'=');
         if ~isempty(line)
            vars=local_getvars(token,vars,dlims);
         end
      end
   end   
end
fclose(fid);
rwords={'for','end','if','while','function','return','elseif','case','continue',...
      'otherwise','else','switch','try','catch','global','persistent','break'};
vars=setdiff(vars,rwords);   % clear reserved words, sort unique names
if nargout==0
   fprintf('The Variables Created in the M-file %s are:\n',upper(FName(1:end-2)))
   disp(vars)
   clear vars
end

%----------------------------------------------------------------------------
function s=local_clearstrcom(s)
% clear strings and comments from line
if isempty(s),return,end
quote='''';
dquote=repmat(quote,1,2);
idx=find(s==quote);  % indices of all quotes
if ~isempty(idx)     % remove all double quotes between end quotes
   s=[s(1:idx(1)) local_strrep(s(idx(1)+1:idx(end)-1),dquote,' ') s(idx(end):end)];
end
mask=logical(ones(size(s)));  % mask of characters to keep
False=logical(0);
idx=find(s==quote);  % indices of all single quotes
if ~isempty(idx)     % find and eliminate quoted strings
   i=1;
   ss=sprintf('{([,;:=\t ^&*-+\\|/~');
   while i<length(idx)
      if idx(i)==1 | ~isempty(findstr(s(idx(i)-1),ss))
         % strings start at the beginning of a line or after the
         % characters { ( [ , ; : = tabs, spaces or operators
         mask(idx(i):idx(i+1))=False; % mark string to delete
         i=i+2; % skip to next possible string
      else % not a string
         i=i+1;
      end
   end
   s=s(mask);
end
i=find(s=='%'); % throw out comments, '%' in strings are gone
if ~isempty(i)
   s(i(1):end)=[];
end
i=find(~isspace(s)); % throw out white space at end of line
if ~isempty(i)
   s(i(end)+1:end)=[];
end
%----------------------------------------------------------------------------
function [line,vars]=local_getspecial(line,vars,dlims)
% test to see if this a special line, if so get variables found there
flag=logical(0);
ltest=[line blanks(11)];
idx=findstr(ltest,'function ');
if ~isempty(idx)  % function statement
   line=line(idx(1)+8:end);
   idx=findstr(line,'=');  % find equal sign if there
   if ~isempty(idx)
      idx2=[findstr(line,'(') length(line)]; % find input args if there
      idx2=idx2(idx2>idx(1));
      if ~isempty(idx2)
         line(idx(1):idx2(1))=' ';  % delete function declaration
      end
   end
   flag=1;
end
idx=findstr(ltest,'global ');
if ~isempty(idx)  % global statement
   line=line(idx(1)+6:end);
   flag=1;
end
idx=findstr(ltest,'persistent ');
if ~isempty(idx)  % persistent statement
   line=line(idx(1)+10:end);
   flag=1;
end
if flag  % get variables on this line
   while ~isempty(line)
      [token,line]=strtok(line,dlims);
      if local_isvalidvar(token)
         vars{end+1,1}=token;
      end
   end
   line=''; % return empty line so no more processing is done
end
%----------------------------------------------------------------------------
function vars=local_getvars(line,vars,dlims)
% get variables from line string
% variable names appear on left hand side of equal signs
% y=fun(x) is simplest form
% [a,b,c]=fun(...) a little more work
% rat(2:3).fname=fun(...) look out for structures
% [drs{1:length(d)},b]=fun(d) look out for 'length'
% s(strncmp(s,'.',1))=[]; look out for 'strncmp'
% t(1:c:26)=fun(df); 'c' is a previously defined variable
% if length(x)<4, ind=1; end
% if isempty(b), b=1; end
if isempty(line)
   return
end
idx=findstr(line,';');  % statement terminator
if ~isempty(idx)  % throw away r.h.s. of preceding statement
   line(1:idx(end))=[];
else
   idx=findstr(line,', '); % assume that its a comma followed by a space
   if ~isempty(idx)
      line(1:idx(end))=[];
   end
end
idl=findstr(line,'(');
idr=findstr(line,')');
if ~isempty(idl)&~isempty(idr)   % throw out items in parentheses
   line(idl(1):idr(end))=[];
end
idl=findstr(line,'{');
idr=findstr(line,'}');
if ~isempty(idl)&~isempty(idr)   % throw out items in cell brackets
   line(idl(1):idr(end))=[];
end
while ~isempty(line)
   [token,line]=strtok(line,dlims);
   if local_isvalidvar(token)       % must be a valid name
      idx=findstr(token,'.');
      if isempty(idx)   % regular variable
         vars{end+1,1}=token;
      else              % structure, so get base name only
         vars{end+1,1}=token(1:idx(1)-1);
      end
   end
end
%----------------------------------------------------------------------------
function tf=local_isvalidvar(s)
% True if string is a valid variable name
if isempty(s)
   tf=logical(0);
else
   tf=isletter(s(1)) & s(end)~='.' & all(local_isvarchar(s));
end
%----------------------------------------------------------------------------
function y=local_isvarchar(s)
% True for characters in valid variable names
y=isletter(s) | s=='_' | s=='.' | (s>='0' & s<='9');
%----------------------------------------------------------------------------
function s=local_strrep(s1,s2,s3)
% replace occurances of s2 in s1 with s3
% string replacement without overlap
s1=s1(:)'; s1len=length(s1);
s2=s2(:)'; s2len=length(s2);
s3=s3(:)'; s3len=length(s3);
if s2len>s1len
   s=s1;
elseif isequal(s1,s2)
   s=s3;
else
   s=s1;
   k=findstr(s1,s2);
   while ~isempty(k)
      s=cat(2,s(1:k(1)-1),s3,s(k(1)+s2len:end));
      k=findstr(s,s2);
   end
end
