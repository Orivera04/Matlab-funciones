% PRODDF   �ŏ��̊��Ԃ��[���̗L���،��̉��i���o��
%
% [P,AI] = PRODDF(SD,MD,ID,FD,RV,CPN,YLD,PER,BASIS) �́A�ŏ��̊��Ԃ��[��
% �ōŏ��̊��ԂɌ��ϓ�������L���،��̉��i P �ƌo�ߗ��q AI ���o�͂��܂��B
% SD �͌��ϓ��AMD �͖������AID �͔��s���AFD �͍ŏ��̃N�[�|���x�����ARV 
% �͊z�ʉ��i�ACPN �̓N�[�|�����[�g�AYLD �͗����APER �͔N�Ԃ̗���������
% ��(�f�t�H���g��2)�ABASIS �́A0 =actual/actual (�f�t�H���g),1= 30/360, 
% 2 = actual/360, 3 = actual/365�ł��B���t�́A�V���A�����t�ԍ��A�܂��́A
% ���t������œ��͂��Ă��������B
% 
% ���F���̃f�[�^���g�p����ƁA
% 
%              SD = '11/11/1992'
%              MD = '03/01/2005'
%              ID = '10/15/1992'
%              FD = '03/01/1993'
%              RV = 100
%              CPN = 0.0785
%              YLD = 0.0625
%              PER = 2
%              BASIS = 0
%       
%              [p,ai] = proddf(sd,md,id,fd,rv,cpn,yld,per,basis)
%       
% ���̌��ʁAp = 113.60 �� ai = 0.59���o�͂���܂��B
% 
% �Q�l : PRODDFL, PRODDL, PRBOND, YLDODDF.
%
% �Q�l����: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formulas 8, 9. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
