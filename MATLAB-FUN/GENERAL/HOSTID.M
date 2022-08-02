function id = hostid
%HOSTID MATLAB server host identification number.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

com = computer;
if com(1:2) == 'MA'
   s9 = system_dependent(1009);
elseif strcmp(com(1:2),'PC')
   eval('s9 = siteid;');
else % Unix or VMS
   if isunix
      rt = getenv('LM_LICENSE_FILE');
   else % VMS
      rt = 'LM_LICENSE_FILE:';
   end
   fid = fopen(rt,'r');
   if fid == -1
      error('Can''t find license.dat file.')
   end
% look for first line with SERVER or DEMO
   k = [];
   d = [];
   while isempty(k) & isempty(d)
      s = fgetl(fid); 
      k = findstr('SERVER',s);
      d = findstr('DEMO',s);
   end
   if ~isempty(d)   % DEMO license
      s9 = 'DEMO';
   else
      % get third entity from this string which is the MATLAB ID
      b = find(s == ' ');
      if length(b) < 3
         s = [s ' P'];
         b = [b length(s)-1];
      end
      s9 = s(b(2)+1:b(3)-1);
   end
end
if nargout == 0
   disp(s9)
else
   id = s9;
end

