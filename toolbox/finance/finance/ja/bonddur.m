% BONDDUR   Macaulay�f�����[�V�����y�яC���f�����[�V����
%
% [D,M] =  BONDDUR(SD,MD,RV,CPN,YLD,PER,BASIS) �́A����I�������̗L���،�
% �ɑ΂��āAMacaulay �f�����[�V���� D �ƏC���f�����[�V���� M ��N���ŋ�
% �߂܂��BSD �͌��ϓ��AMD �͖������ARV �͊z�ʉ��i�ACPN �̓N�[�|�����[�g
% YLD �͗����APER �͔N�Ԃ̊��Ԑ�(�f�t�H���g��2)�ABASIS �͓����J�E���g
% ���: 0 =actual/actual (�f�t�H���g)�A1 = 30/360�A2 = actual/360�A
% 3 = actual/365�̂����ꂩ��ݒ肵�܂��B���t�́A�V���A�����t�ԍ��A�܂��́A
% ���t������œ��͂��Ă��������B
%       
% ���F���̃f�[�^���^�����Ă���Ƃ�
%       
%       ���ϓ��@�@        01-Dec-1994
%       ������ �@       �@01-Jan-2001
%       �z�ʉ��i �@       $100.00
%       �N�[�|�����[�g �@ 5%
%       ����� �@         4.34%
%       ���ԁ@�@          ���N
%       �����J�E���g�  actual/actual
%       
%       [d,m] = bonddur('12/1/1994','1/1/2000',100,0.05,0.0434,2,0)
%       
% �́A Macaulay �f�����[�V���� d = 4.4720 �N�ƏC���f�����[�V����
% m = 4.3770 �N���o�͂��܂��B
% 
% �Q�l : BONDCONV, CFDUR, CFCONV, BNDDURY.


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
