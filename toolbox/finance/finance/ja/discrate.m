% DISCRATE   �L���،��̊��������o��
%
% D = DISCRATE(SD,MD,RV,PRICE,BASIS)�́A���ϓ� SD�A������ MD�A�z�ʉ��i 
% RV�A���i PRICE ���^����ꂽ�Ƃ��ɁA�L���،��̊����������߂܂��BBASIS 
% �͓����J�E���g��ŁA0 = actual/actual (�f�t�H���g)�A1 = 30/360�A
% 2 = actual/360�A3 = actual/365�̂����ꂩ��ݒ肵�܂��B���t�́A�V���A��
% ���t�ԍ����邢�͓��t������œ��͂��܂��B 
% 
% ���F 
%    d = discrate('12-jan-1994', '25-jun-1994', 100, 97.74, 0)
% ���̌��ʁAd = 0.0503 ���Ȃ킿������5.03%���o�͂��܂��B  
% 
% �Q�l : ACRUDISC, FVDISC, PRDISC, YLDDISC.
%
% �Q�l����: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formula 1*. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
