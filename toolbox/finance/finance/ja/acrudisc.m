% ACRUDISC   �������Ҋ����L���،��̌o�ߗ��q
%
% INT = ACRUDISC(SD,MD,RV,DISC,PER,BASIS)�́A�������Ҋ����L���،��̌o��
% ���q���o�͂��܂��BSD �͌��ϓ��AMD �͖������ARV �͗L���،��̊z�ʉ��i�A
% DISC �͗L���،��̊������APER �͔N�Ԃ̊��Ԑ�(�f�t�H���g=2)�ABASIS ��
% �����J�E���g��ŁA0 = actual/actual (�f�t�H���g)�A1=  30/360�A
% 2 = actual/360�A3 = actual/365 �̂����ꂩ��ݒ肵�܂��B���t�̓V���A��
% ���t�ԍ��܂��́A���t������œ��͂��܂��B
%   
% ���F 
%   
%       int = acrudisc('05/01/1992','07/15/1992',100, 0.1, 2, 0)  
%   
% ���̌��� int = 2.0604 ���o�͂���܂��B  
%   
% �Q�l : ACRUBOND, YLDDISC, PRDISC, YLDMAT, PRMAT.
%   
% �Q�l�����FSIA Standard Securities Calculation Methods,   
%           Volumes I-II, 3rd Edition.   Formula D


%       Author(s): C.F. Garvin, 2-23-95   
%       Copyright 1995-2002 The MathWorks, Inc.    
