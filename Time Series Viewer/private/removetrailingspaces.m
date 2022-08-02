function nameout=removetrailingspaces(namein);
%REMOVETRAILINGSPACES   remove trail spaces from a single line character array
%
% nameout=removetrailingspaces(namein);
%
% Scott Hirsch
% 5/99

blk=' ';
nameout=namein;

while strcmp(blk,nameout(end))
   nameout=nameout(1:end-1);
end;
