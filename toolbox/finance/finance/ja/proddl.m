% PRODDL   �Ō�̊��Ԃ��[���̗L���،��̉��i���o��
%
% [P,AI] = PRODDL(SD,MD,LCD,RV,CPN,YLD,PER,BASIS) �́A�Ō�̊��Ԃ��[����
% �L���،��̉��i P �ƌo�ߗ��q AI ���o�͂��܂��BSD �͌��ϓ��AMD �͖������A
% LCD �͍Ō�̃N�[�|���x�����ARV �͊z�ʉ��i�ACPN �̓N�[�|�����[�g�AYLD 
% �͗����APER �͔N�Ԃ̗��������Ԑ�(�f�t�H���g��2)�ABASIS �́A
% 0 =actual/actual (�f�t�H���g),1= 30/360, 2 = actual/360, 3 = actual/365
% �ł��B
% 
% ���F
% ���̃f�[�^���g�p����ƁA
% 
%              SD = '02/07/1993'
%              MD = '08/01/1993'
%              LCD = '02/04/1993'
%              RV = 100
%              CPN = 0.0650
%              YLD = 0.0535
%              PER = 2
%              BASIS = 1
%       
%              [p,ai] = proddl(sd,md,lcd,rv,cpn,yld,per,basis)
%       
% ���̌��ʁAp = 100.54 �� ai = 0.05���o�͂��܂��B
% 
% �Q�l : PRODDF, PRODDFL, PRBOND, YLDODDL.
%
% �Q�l����: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formulas 11, 13, 14, 15. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
