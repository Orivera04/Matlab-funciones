clc, clear all
maxval=1000;
mat= round(rand([90000 6])*maxval); % random input data (not sorted)

matwithsum=sortrows([sum(mat,2), mat],1); % sum or rows is first column and sort based on column1
mat=matwithsum(:,2:end);                  % removing first column

disp('rows of input matrix (mat) are sorted based on sum of column values');
str=sprintf('%s %g %s %g','Size of Input Matrix (mat)',size(mat,1),'-by-',size(mat,2)); disp(str);

for k=1:3
    srow=mat(round(rand(1)*size(mat,1)),:); %choosing arbtriary any row from mat
    disp('----------------------------------------------------');
    str=sprintf('%s %s','searching row:',num2str(srow)); disp(str);
    time1=cputime;
    i1=bsearchmatrows(mat,srow,'first');
    time1=cputime-time1;
    str=sprintf('%s %g','bsearchmatrows: found at index',i1); disp(str);
    str=sprintf('%s %g','Time taken by bsearchmatrows method',time1); disp(str);
    
    time2=cputime;
    i2=find(ismember(mat,srow, 'rows')); 
    time2=cputime-time2;
    str=sprintf('%s %g','MATLAB: found at index',i2); disp(str);
    str=sprintf('%s %g','Time taken by MATLAB builtin method',time2); disp(str);
   
end

% % This program or any other program(s) supplied with it does not provide any
% % warranty direct or implied.
% % This program is free to use/share for non-commerical purpose only. 
% % Kindly reference the author.
% % Thanking you.
% % @ Copyright M A Khan
% % Email: khan_goodluck@yahoo.com 
% % http://www.m-a-khan.blinkz.com/
