% if vin is column vector change it to row vector then return it.
% if vin is row vector then return it as it is.
% if vin is not a vector diplay error message and  returns control to the
% keyboard
function [vout]=getrowvector(vin)

if(~isvector(vin)  )
    error('getrowvector.m => input must be a vector');    
end

vout=vin;
[r c]=size(vin);
if (c==1)      % make row vector if it is column vector
    vout=vin';
end

% % -------------------------------------------------------------------------
% % This program or any other program(s) supplied with it does not provide any
% % warranty direct or implied. This program is free to use/share for
% % non-commercial purpose only, for any other usage contact with author.
% % Kindly reference author.
% % Thanking you.
% % @ Copyright M Khan
% % Email: mak2000sw@yahoo.com
% %        mak2000@GameBox.net 
% % http://www.geocities.com/mak2000sw

