% PRMAT   �������������̗L���،��̉��i���o��
%
% [P,AI] = PRMAT(SD,MD,ID,RV,CPN,YLD,BASIS) �́A�������������̗L���،���
% ���i P �ƌo�ߗ��q AI ���o�͂��܂��BSD �͌��ϓ��AMD �͖������AID�͔��s���A
% RV �͊z�ʉ��i�ACPN �̓N�[�|�����[�g�AYLD �͗����ABASIS �́A
% 0 =actual/actual(�f�t�H���g),1= 30/360, 2 = actual/360, 3 = actual/365
% �ł��B���t�́A�V���A�����t�ԍ��A�܂��́A���t������œ��͂��Ă��������B
% ���̊֐��́ACPN = 0�Ƃ��邱�Ƃɂ��A�[���N�[�|���ɂ��������L���،�
% �ɂ��K�p����܂��B
%
% ���F���̃f�[�^���g�p����ƁA
% 
%              SD = '02/07/1992'
%              MD = '04/13/1992'
%              id = '10/11/1991'
%              RV = 100
%              CPN = 0.0608
%              YLD = 0.0608
%              BASIS = 1
%       
%              [p,ai] = prmat(sd,md,id,rv,cpn,yld,basis)
%       
% ���̌��ʁAp = 99.98 �� ai = 1.96 ���o�͂���܂��B
% 
% �Q�l : YLDMAT, PRBOND, PRDISC.
%
% �Q�l����: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formula 4. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
