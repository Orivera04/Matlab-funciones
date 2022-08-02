function s = isempty(p)
% TERN/CHAR   
% CHAR(p) is the string representation of the term p
p(:).n==[]
p(:).d==[]
pause
if (p(:).n==[])|(p(:).d==[])
    s=1;
else
    s=0;
end