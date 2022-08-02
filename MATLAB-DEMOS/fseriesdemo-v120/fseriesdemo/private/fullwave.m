function out = fullwave(t, T, signal)
% FULLWAVE creates a full-wave rectified Sine/Cosine wave
  
% Mustayeen Nayeem, August, 2002
% Rajbabu, Dec-24-2003 - Added option for sine/cosine
  
%yy = zeros(1,length(t));
switch signal
 case 'sine'
  yy = sin(2*pi/T*t);
 case 'cosine'
  yy = cos(2*pi/T*t);
 otherwise
  error('Unknown signal type');
end

yy = abs(yy);
        
out = yy;

%endfunction fullwave

%eof: fullwave.m
