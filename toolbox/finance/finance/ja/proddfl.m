% PRODDFL   �ŏ��ƍŌ�̊��Ԃ��[���ōŏ��̊��ԂɌ��ς���L���،��̉��i��
%           �o��
%
% [P,AI] = PRODDFL(SD,MD,ID,FD,LCD,RV,CPN,YLD,PER,BASIS) �́A�ŏ��ƍŌ��
% ���Ԃ��[���ōŏ��̊��ԂɌ��ϓ�������L���،��̉��i P �ƌo�ߗ��q AI ��
% �o�͂��܂��BSD �͌��ϓ��AMD �͖������AID �͔��s���AFD �͍ŏ��̃N�[�|��
% �x�����ALCD �͍Ō�̃N�[�|���x�����ARV �͊z�ʉ��i�ACPN �̓N�[�|��
% ���[�g�AYLD �͗����APER �͔N�Ԃ̗��������Ԑ�(�f�t�H���g��2)�ABASIS 
% �́A0 =actual/actual (�f�t�H���g),1= 30/360, 2 = actual/360, 
% 3 = actual/365 �ł��B���t�́A�V���A�����t�ԍ��A�܂��́A���t������œ���
% ���Ă��������B
% 
% ���F
% ���̃f�[�^���g�p����ƁA
%   
%              SD = '03/15/1993'
%              MD = '03/01/2020'
%              ID = '03/01/1993'
%              FD = '07/01/1993'
%              LCD = '01/01/2020'
%              RV = 100
%              CPN = 0.04
%              YLD = 0.0427
%              PER = 2
%              BASIS = 1
%       
%              [p,ai] = proddfl(sd,md,id,fd,lcd,rv,cpn,yld,per,basis)
%       
% ���̌��ʁAp = 95.71 ��ai = 0.16���o�͂��܂��B
% 
% �Q�l : PRODDF, PRODDL, PRBOND, YLDBOND.
%
% �Q�l����: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formulas 16, 17, 18, 19. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
