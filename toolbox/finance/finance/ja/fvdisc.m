% FVDISC   �����L���،��̏������l
%
% RV = FVDISC(SD,MD,PRICE,DISC,BASIS) �́A���ϓ� SD�A������ MD�A���݉��l 
% PRICE �A������ DISC�A�����J�E���g� BASIS ���^����ꂽ���A�S�z�����L��
% �،��̖������󂯎��z�����߂܂��BBASIS��0 =actual/actual (�f�t�H���g)�A
% 1 = 30/360�A2 = actual/360�A3 = actual/365�̂����ꂩ��ݒ肵�܂��B
% ���t�́A�V���A�����t�ԍ��A���邢�́A���t������œ��͂��܂��B
% 
% ���F�ȉ��̃f�[�^���g�p����ƁA
% 
%       SD = '02/15/1991' 
%       MD = '05/15/1991' 
%       PRICE = 100 
%       DISC = .0575 
%       BASIS = 2 
% 
% �L���،��̖��������z�Ƃ���$101.44���o�͂���܂��B
% 
% �Q�l : ACRUDISC, PRDISC, YLDDISC.
%
% �Q�l����: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
