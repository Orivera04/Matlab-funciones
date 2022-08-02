function out=subsref(hnd,s)
%TABLE/SUBSREF
%   Provides dot and index referencing interface for table object.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:33:52 $


% Bail if we've not been given a fordtable
if ~isa(hnd,'xregtable')
   error('Cannot get properties: not a table')
end

% concatenate types together to look at subs structure.
str=[s(:).type];

% filter out cell index calls
pos=findstr(str,'{}');
if ~isempty(pos)
   error('Cell indexing not supported!');
end

% look for a numeric index
pos=findstr(str,'()');

% First trap as an error if the brackets weren't at beginning or end
if ~isempty(pos) & pos ~=1 & pos~=length(str)-1
   error('Invalid subscipting');
end

count=length(pos);
fud=get(hnd.frame.handle,'UserData');
set(hnd.frame.handle,'UserData',[]);
switch count
case 0
   % set selection to entire array of handles
   fud.cells.rowselection=[fud.zeroindex(1) fud.rows.number];
   fud.cells.colselection=[fud.zeroindex(2) fud.cols.number];
case 1
   % determine whether index is 1D or 2D form
   switch length(s(pos).subs)
   case 1
      % convert to 2D subscript
      if ischar(s(pos).subs{1})
         % must be a :
         fud.cells.rowselection=[fud.zeroindex(1)  fud.rows.number];
         fud.cells.colselection=[fud.zeroindex(2)  fud.cols.number];
      elseif islogical(s(pos).subs{1})
         % make sure logical array is 2D
         % Only supports array the same size as table(1:end,1:end)
         s(pos).subs{1}=reshape(s(pos).subs{1},fud.rows.number-fud.zeroindex(1)+1,...
            fud.cols.number-fud.zeroindex(2)+1);
         [x y]=findblocks(s(pos).subs{1});
         fud.cells.rowselection=x+fud.zeroindex(1)-1;
         fud.cells.colselection=y+fud.zeroindex(2)-1;
      else
         % Construct logical matrix from indices
         % Note that this includes rows and cols before zeroindexing
         ref=false(fud.rows.number,fud.cols.number);
         % Add on zeroindex
         inds=s(pos).subs{1};
         inds=inds+fud.zeroindex(1)-1+(fud.rows.number*(fud.zeroindex(2)-1));
         ref(inds)=true;
         
         % Now do standard block find
         [x y]=findblocks(ref);
         fud.cells.rowselection=x;
         fud.cells.colselection=y;
      end
   case 2
      % Construct logical matrix from indices
      % Note that this includes rows and cols before zeroindexing
      ref=false(fud.rows.number,fud.cols.number);
      if ischar(s(pos).subs{1})
         xinds=[fud.zeroindex(1):fud.rows.number];
      else
         xinds=s(pos).subs{1}+fud.zeroindex(1)-1;
      end
      if ischar(s(pos).subs{2})
         yinds=[fud.zeroindex(2):fud.cols.number];
      else
         yinds=s(pos).subs{2}+fud.zeroindex(2)-1;
      end
      ref(xinds,yinds)=true;
      
      % Now do standard block find
      [x y]=findblocks(ref);
      fud.cells.rowselection=x;
      fud.cells.colselection=y;
   otherwise
      error('Invalid subscipt: use 1D or 2D subscripts for a table!');
   end
   
   % For this case we assume the user wants to index the cell properties
   % ie a(n,m).blah will index a(n,m).cells.blah
   ins.type='.';
   ins.subs='cells';
   
   if length(s)==1
      % Assume .number property is required if there are no other subs
      s(2).type='.';
      s(2).subs='number';
   end
   if pos==1
      % Need to insert .cells at s(2)
      s=[s(1) ins s(2:end)];
   else
      % Need to insert .cells at s(1)
      s=[ins s(1:end)];
   end
otherwise
   error('Multiple numeric subscripts not allowed!');   
end

% Now parse the rest of the types together into one call for get

% Put all the subs together in a string
str=[];
if ~isempty(pos)
   for n=((pos==1)+1):(length(s)-(pos~=1))
      if isempty(findstr(str,s(n).subs))
         str=[str s(n).subs '.'];
      end
   end
else
   for n=(1:(length(s)))
      if isempty(findstr(str,s(n).subs))
         str=[str s(n).subs '.'];
      end
   end
end

% Chop final dot
str=str(1:end-1);

% Post new frame ud
set(hnd.frame.handle,'UserData',fud);

% Call get
out=get(hnd,str);

%Need to repackage out according to original indexing
if length(fud.cells.rowselection(:))>2 & count==1
   switch length(s(pos).subs)
   case 1
      % 1D index/logical index
      % matrix must have right number of rows for indexing
      out(end+1:fud.rows.number,:)=0;
      if islogical (s(pos).subs{1})
         % need to have the right number of cols too
         out(:,end+1:fud.cols.number)=0;
      end
      out=out(s(pos).subs{1});
   case 2
      % 2D index
      out=out(s(pos).subs{1},s(pos).subs{2});     
   end
end

return
