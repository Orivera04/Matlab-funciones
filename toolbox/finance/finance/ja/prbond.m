% PRBOND   ����������̗L���،��̉��i���o��
%
% [P,AI] = PRBOND(SD,MD,RV,CPN,YLD,PER,BASIS) �́A����I�������̗L���،�
% �̉��i P �ƌo�ߗ��q AI ���o�͂��܂��BSD �͌��ϓ��AMD �͖������ARV �͊z
% �ʉ��i�ACPN �̓N�[�|�����[�g�AYLD �͗����APER �͔N�Ԃ̊��Ԑ�(�f�t�H
% ���g��2)�ABASIS �͓����J�E���g���: 0 =actual/actual (�f�t�H���g)�A
% 1 = 30/360�A2 = actual/360�A3 = actual/365�̂����ꂩ��ݒ肵�܂��B���t
% �́A�V���A�����t�ԍ��A�܂��́A���t������œ��͂��Ă��������B���̊֐���
% CPN = 0 �Ƃ��邱�Ƃɂ��A�[���N�[�|���ɂ��������L���،��ɂ��K�p����
% �܂��B
% 
% ���F�ȉ��̃f�[�^���g�p����ƁA
%   
%              SD = '02/01/1960'
%              MD = '01/01/1990'
%              RV = 1000
%              CPN = 0.08
%              YLD = 0.06
%              PER = 2
%              BASIS = 0
%       
%              [p,ai] = prbond(sd,md,rv,cpn,yld,per,basis)
%       
% ���̌��ʁAp = 1276.39 �y�� ai = 6.81���o�͂���܂��B
% 
% �Q�l : YLDBOND, PRMAT, PRDISC.
%
% �Q�l����: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formulas 6, 7. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
