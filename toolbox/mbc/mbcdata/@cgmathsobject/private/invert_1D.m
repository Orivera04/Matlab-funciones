function [out,err] = invert_1D(invBP,BP,val,flag)
%INVERT_1D
% Function to carry out the inversion of 1D tables. InvBP are the breakpoints of the Inverse table
% BP and val are the breakpoints and values of the table to be inverted. Flag helps us work out what to 
% do when things aren't invertible

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.3 $  $Date: 2004/02/09 06:50:08 $

% First let's dispense with the easy cases, when things are monotonic.
err = [];

if length(BP) ~= length(val)
   %    error('Please don''t do that again');
   out = [];
   err = 'Breakpoints not the same length as values.';
   return
end

if length(unique(val)) == 1
   err = 'Cannot invert constant functions.';
   out = [];
   return
end

diffval = diff(sign(diff(val)));

if ~any(diffval) % Monotonic
   out = linear1(val,BP,invBP);
   err = [];
   return
end

% If it's not monotonic, let's break it up into monotonic chunks

count = 1;

BPstore{count} = BP([1;2]);
Valstore{count} = val([1;2]);

currentsign = sign(val(2)-val(1)); 
signstore(count) = currentsign;

if length(BP) > 2
   for i = 3:length(BP)
      tempsign = sign(val(i)-val(i-1));
      if tempsign == currentsign
         BPstore{count} = [BPstore{count};BP(i)];
         Valstore{count} = [Valstore{count};val(i)];
      else
         count = count+1;
         currentsign = tempsign;
         signstore(count) = currentsign;
         BPstore{count} = BP([i-1;i]);
         Valstore{count} = val([i-1;i]);
      end
   end
end

% BPstore now contains flat bits, increasing bits and decreasing bits. If there are only two 
% entries, then we will try to use the right monotonic bit as dictated by the selectionflag.

if count == 2
   % We have two bits - if one of them is flat then use the other, if we have inc + dec, then use the
   % one dictated by selectionflag.
   if flag == 3 | flag == 4, flag = 2; end % if only two bits we only want to deal in mins and maxs
   if sum(abs(signstore)) == 1
      I = find(signstore);
      out = linear1(Valstore{I},BPstore{I},invBP);
   else
      out = linear1(Valstore{flag},BPstore{flag},invBP);
   end
   err = [];
   return 
end

% And now for the linear regression method.

y = linspace(BP(1),BP(end),2001);
x = linear1(BP,val,y');
out = values_regression1(x(:),y(:),invBP);

return


% 
% 
% % In a bad case it would seem logical to use the segment that has the greatest value range intersecting with the 
% % requested breakpoints.
% 
% for k = 1:length(BPstore)
%     % Find out the intersection between this segment and the requested BP range.
%     Interval = [];
%     temp = max(min(Valstore{k}(end),invBP(end)) - max(Valstore{k}(1),invBP(1)),0);
%     Interval = [Interval;temp];
% end
% 
% % Interval gives us the overlap between each of the segments and our desired range. If there are many that match up,
% % then we use selectionflag, if none, then we use the longest.
% 
% Index = zeros(length(BPstore),1);
% Index(Interval(:) == invBP(end)-invBP(1)) = 1;
% if sum(Index) > 1 % more than one perfect match, so we pick one according to the flag.
%     I = find(Index);
%     if flag == 1
%         J = I(1);
%     elseif flag == 2;
%         J = I(end);
%     else
%         J = I(round(length(I)+1)/2);
%     end
% elseif sum(Index) == 1
%     J = find(Index);
% else
%     if ~any(Interval)
%         out = [];
%     else
%         [A,J] = max(Interval);
%     end
% end
% out = linear1(Valstore{J},BPstore{J},invBP);    
% 
% return        
