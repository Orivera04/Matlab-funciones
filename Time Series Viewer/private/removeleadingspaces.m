function nameout=removeleadingspaces(namein);
%REMOVELEADINGSPACES    remove leading spaces from a single line character array
%
% nameout=removeleadingspaces(namein);
%
% Scott Hirsch
% 5/99

blks=findstr(' ',namein);
nameout=namein;
if ~isempty(blks) & blks(1)==1		%at least one leading blank
   if length(blks)>1
      diffblks=diff(blks);
      lastleadingblank=min(find(diffblks>1));
   else
      lastleadingblank=1;
   end;
   nameout=namein(lastleadingblank+1:end);
end;


