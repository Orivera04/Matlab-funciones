function out=subsref(hgo,s)
% SUBSREF method for HGOBJECTS
%
% HGO(n).pname allowed

% D.C. Hanselman, University of Maine, Orono, ME  04469-5708
% masteringmatlab@yahoo.com
% 2007-06-22

if ~all(ishandle(hgo.handles))
	error('HGOBJECT:Exist','Graphics Handles No Longer Exist.')
end

nsubs=length(s);
if nsubs==1 && strcmp(s.type,'.')                               % HGO.Pname
   fn=gfn(hgo.pnames,s.subs);
   if isempty(fn)
      error('HGOBJECT:Subsref','PName is Ambiguous or Unknown.')
   else
      out=get(hgo.handles,fn);
   end
   
elseif nsubs==2 ...
       && strcmp(s(1).type,'()') && strcmp(s(2).type,'.')    % HGO(n).Pname

   fn=gfn(hgo.pnames,s(2).subs);
   if isempty(fn)
      error('HGOBJECT:Subsref','PName is Ambiguous or Unknown.')
   elseif length(s(1).subs)==1 && ischar(s(1).subs{1}) % HGO.PName(:)
      out=get(hgo.handles,fn);
   elseif length(s(1).subs)==1
      out=get(hgo.handles(s(1).subs{:}),fn);
   else
      error('HGOBJECT:Subsref','Invalid HGOBJECT Indexing Expression.')
   end
   
else
   error('HGOBJECT:Subsref','Invalid HGOBJECT Indexing Expression.')
end
 
function fn=gfn(S,str)
% get unique field name
% look for exact match first
idx=find(strcmpi(S,str));
if isempty(idx) % no exact match, so look for more general match
   idx=find(strncmpi(S,str,length(str)));
end
if numel(idx)==1 % unique match found
   fn=S{idx};
else             % trouble
   fn='';
end