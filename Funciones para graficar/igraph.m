function igraph(A)                           %last updated 5/11/95
%IGRAPH  Creates the graph associated with an incidence matrix A.
%        The nodes are labeled and the edges drawn. It is assumed
%        that the graph is not directed (that is, all edges are 
%        two way) and that the number of nodes is 9 or less. The
%        intersection of edges that are not labeled is not 
%        considered a node of the graph. (Warning: the graph 
%        displayed may look different from the one you might 
%        construct by hand.)
%
%        Use in the form   ===>  igraph(A)  <===
%
%   By: David R. Hill, Math. Dept., Temple University
%       Philadelphia, Pa. 19122   Email: hill@math.temple.edu
lim=9; %MAX SIZE of incidence matrix
ptx=[1 2 7 4 7 5 9 10 7]; %NODE Coordinates
pty=[1 6 5 4 2 8 6 3 10];
ptname='123456789';

setwin='figure,set(gcf,''units'',''normal''),';
setwin=[setwin 'set(gcf,''position'',[0 0 1 1])'];
       %setting graphics window to full size

setax='plot([0 10],[0 0],''k-'',[0 0],[0 10],''k-''),';
setax=[setax 'axis(axis),axis(''off''),axis(''square'')'];

color='yymcrgbwymcrgbwymcrgbwymcrgbwymcrgbw'; %colors
line=['style=[''-'' color(i+j)];plot([ptx(i) ptx(j)],[pty(i) pty(j)],style,'];
line=[line '''erasemode'',''none''),drawnow'];

delay=['Q=rand(20);svd(Q);Q=rand(20);svd(Q);'];


[m,n]=size(A);
%check too big
if m>lim | n>lim
   disp('ERROR:  Incidence matrix too large.')
   return
end
%check square
if m~=n
   disp('ERROR:  Input matrix not sqaure.')
   return
end
%check symmetric
s=sum(abs(sum(A-A')));
if s~=0
   disp('ERROR:  Input matrix not symmetric.')
   return
end
%check for matrix of only zeros & ones
for i=1:n
   for j=i:n
      if A(i,j)==1 | A(i,j)==0
      else
         disp('ERROR: Incidence matrix is not all 0 and 1''s.')
         return
      end
   end
end
%check for loops
if trace(abs(A))~=0
   disp('ERROR: Graph contains loops.')
   return
end
%BEGIN display code

eval(setwin)
eval(setax)
hold on
for i=1:m
   plot(ptx(i),pty(i),'o',ptx(i),pty(i),'+','erasemode','none')
   text(ptx(i),pty(i),['P' ptname(i)],'erasemode','none')
   drawnow
end

for i=1:m   %This logic assumes symmetric; uses upper triangular part.
   for j=i:m
      if A(i,j)==1
         eval(line)
         eval(delay)
      end
   end
end
xlabel('Press ENTER to continue.')
hold off


