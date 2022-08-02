%Prims Algorithm
%coded by Vikramaditya V. Kundur
clc
fid = fopen('testfile1.txt', 'r');      % Input file
%Input file should be in the form of a text file.
%5                 %order of matrix
%0 2 3 4 0
%2 0 1 2 5
%3 1 0 1 2
%4 2 1 0 2
%0 5 2 2 0
l = fscanf(fid, '%g %g', [1 1])     % Input matrix size from line 1
h = fscanf(fid, '%g %g', [l l])     % Input the matrix
a=h'
fclose(fid);

fid = fopen('Result.txt','wt');     % Output file
fprintf(fid,'Original matrix\n\n'); % Printing the original matrix in the output file
for i=1:l
    for k=1:l
        fprintf(fid,'%6d',a(i,k));  
    end
    fprintf(fid,' \n');
end

for i=1:l
    for j=1:l
         if a(i,j)==0
               a(i,j)=inf;
           end
    end
end
k=1:l
listV(k)=0;
listV(1)=1;
e=1;
while (e<l)
    min=inf;
     for i=1:l
        if listV(i)==1
            for j=1:l
                if listV(j)==0
                   if min>a(i,j)
                        min=a(i,j);
                        b=a(i,j);
                        s=i;
                        d=j;
                    end
                end
            end
        end
    end
    listV(d)=1;
    distance(e)=b;
    source(e)=s;
    destination(e)=d;
    e=e+1;
end

fprintf(fid,'\n\nDistance modified matrix\n\n');
for i=1:l
    for k=1:l
        if i==k
            fprintf(fid,'%6d',0);
        else
            fprintf(fid,'%6d',a(i,k));
        end        
    end
            fprintf(fid,' \n');
end
fprintf(fid,'\n The nodes and shortest distances are \n');
fprintf(fid,'\nFORMAT: Distance(Source, destination) \n');
for g=1:e-1
fprintf(fid,'%d(%d,%d)\n',distance(g),source(g),destination(g));
end
status = fclose(fid);
clear
