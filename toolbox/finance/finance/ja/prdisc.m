% PRDISC   �����L���،��̉��i���o��
%
% P = PRDISC(SD,MD,RV,DISC,BASIS) �́A���ϓ� SD�A������ MD�A���Ҋz RV�A
% �����J�E���g� BASIS ���^����ꂽ�Ƃ��ɁA�����L���،��̉��i���o�͂�
% �܂��BBASIS �́A0 =actual/actual (�f�t�H���g),1= 30/360, 2 = actual/360,
% 3 = actual/365�ł��B���t�̓V���A�����t�ԍ��A�܂��́A���t������œ��͂�
% �Ă��������B
% 
% ���F�ȉ��̃f�[�^���g�p����ƁA 
%   
%              SD = '10/14/1988'
%              MD = '03/17/1989'
%              RV = 100
%              disc = 0.087
%              basis = 2
%       
%              p = prdisc(sd,md,rv,disc,basis)
%       
% ���̌��ʁAp = 96.28 ���o�͂���܂��B
% 
% �Q�l : PRBOND, PRMAT, YLDDISC.
%
% �Q�l����: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formula 2. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
