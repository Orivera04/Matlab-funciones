% YLDDISC   �����L���،��̗������o��
%
% Y = YLDDISC(SD,MD,RV,PRICE,BASIS) �́A���ϓ� SD�A������ MD�A���Ҋz RV�A
% �������i PRICE�A�����J�E���g� BASIS ���^����ꂽ�Ƃ��ɁA�����L����
% ���̗��������߂܂��BBASIS �́A0 = actual/actual (�f�t�H���g)�A1 = 
% 30/360�A2 = actual/360�A3 = actual/365�̂����ꂩ��ݒ肵�܂��B���t�́A
% �V���A�����t�ԍ��A�܂��́A���t������œ��͂��܂��B
% 
% ���F
% ���̃f�[�^���g�p����ƁA
%   
%              SD    = '10/14/1988'
%              MD    = '03/17/1989'
%              RV    = 100
%              PRICE = 96.28
%              BASIS = 2
%       
%              y = ylddisc(sd,md,rv,price,basis)
%       
% �́Ay = 0.0903 ���Ȃ킿 9.03%���o�͂��܂��B
% 
% �Q�l : PRBOND, YLDBOND, YLDMAT, PRDISC.
%
% �Q�l����: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formula 1. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
