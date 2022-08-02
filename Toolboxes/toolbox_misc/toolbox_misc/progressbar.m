function progressbar(s,n,str_add,str_delim,str_empty)

global prev_s;

if nargin==0
    prev_s = -1;
    return;
end

if isempty(prev_s) | prev_s>1
    prev_s = -1;
end

if nargin<2
    n = 50  ;    
end
if nargin<3
    str_add = '*';
end
if nargin<4
    str_delim = '|';
end
if nargin<4
    str_empty = ' ';
end

% erase line
if prev_s>=0
for i=1:n+3
    fprintf('\b'); 
end
    fprintf('A');    
end

fprintf(str_delim);

if prev_s>0
for k=ceil(n*prev_s):floor(n*s)
    fprintf(str_add);
end
end


for k=ceil(n*s):n 
    fprintf(str_empty);   
end
fprintf(str_delim);   

if prev_s<1 & s>=1
    prev_s = -1;
else
    prev_s = s;
end