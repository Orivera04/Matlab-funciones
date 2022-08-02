function [Fn,Gn]=fsevenodd(Kn,flag)
%FSEVENODD Fourier Series Even/Odd Time Parts. (MM)
% FSEVENODD(Kn,'Even') returns the FS of the even time function
% contained in the FS Kn.
% FSEVENODD(Kn,'Odd') returns the FS of the odd time function
% contained in the FS Kn.
% [En,On]=FSEVENODD(Kn) returns in En the FS of the even time
% function in Kn and returns in On the FS of the odd time function.
%
% See also FSHELP

% Calls: fssize fsresize fsinterp

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 6/5/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[N,msg]=fssize(Kn);
error(msg)
if nargin==2
   if ~ischar(flag) | isempty(flag)
      error('Second Argument Must be a String.')
   end
   switch lower(flag(1))
   case 'e'
      Fn=real(Kn);
   case 'o'
      Fn=complex(0,imag(Kn));
   otherwise
      error('Unknown Second Argument.')
   end
else
   Fn=real(Kn);
   Gn=complex(0,imag(Kn));
end
