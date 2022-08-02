function ChildGUO = getchildguoindex(T, ChildGUO);

% function ChildGUO = getchildguoindex(T, ChildGUO);
% 
% Returns the GUO number of "ChildGUO", which may be a Tag name or already the child GUO number.
%
% Copyright (c) SINUS Messtechnik GmbH 2002-2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

[n, nChildGUOs] = nchildren(T);
if ischar(ChildGUO)
   ChildTag = ChildGUO;
   ChildGUO = 0;
   for k = 1:nChildGUOs
      [T, CT] = guoeval(T, k, 'get(''Tag'')');
      if strcmpi(CT, ChildTag)
         ChildGUO = k;
         break;
      end
   end
end
