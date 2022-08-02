function c = Get_Key_Value
% 
% c = Get_Key_Value
% Inputs
%        
% Output
%       c - character that was type on the keyboard
%
% Date - 8 Jan 2003
% Author by Maj Thomas Rathbun

% get the key from the currentcharacter property
[c] = get(gcf,'CurrentCharacter');
