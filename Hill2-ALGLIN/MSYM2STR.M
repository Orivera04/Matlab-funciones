function Astr=msym2str(A)                  %last updated 9/10/97
%MSYM2STR   Convert a symbolic matrix to a string matrix.
%           Utility for use in MATLAB 5; now we can use the text
%           command to display matrix contents on the graphics screen.
%
%           A is assumed to be a symbolic matrix.
%           Then use in the form:
%                                 ==>  B=msym2str(A)  <==
%
%           B is a matrix with the same rows as A but with entries
%           left justified and separated by a comma.
%
%  By: David R. Hill, Mathematics Dept., Temple Univ.
%      Philadelphia, PA. 19122    Email: hill@math.temple.edu

[m,n]=size(A);
maxlen=0;
for ii=1:m       %determine entry of maximum length
   for jj=1:n
      maxlen=max([maxlen,length(char(char(A(ii,jj))))]);
   end
end
for ii=1:m            %pad the entries on the left with spaces
   for jj=1:n         %to construct rows of equal length
      temp=char(char(A(ii,jj)));
      while length(temp)<maxlen
         temp=[' ' temp];
      end
      
      if jj==1
         temp=['[' temp]; %Prefixs [ on first entry.
         eval(['R' num2str(ii) '= temp;']);
      else
        temp=[',' temp]; %Prefixs a comma as a separator
        if jj==n
           temp=[temp ']']; %Suffixes ] on last entry
        end
        eval(['R' num2str(ii) '=[R' num2str(ii) ', temp];']);
      end
      
   end
end
Astr=R1;
for ii=2:m        %builds the matrix of row strings constructed above
   temp=eval(['R' num2str(ii)]);
   Astr=char(Astr,temp);
end
