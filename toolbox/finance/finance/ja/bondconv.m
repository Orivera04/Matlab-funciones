% BONDCONV   �R���x�N�V�e�B
%
% [PC,YC] = BONDCONV(SD,MD,RV,CPN,YLD,PER,BASIS) �́A���� PC �ƔN�� YC 
% �ɂ�����L���،��̃R���x�N�V�e�B���o�͂��܂��BSD �͌��ϓ��AMD �͖������A
% RV �͊z�ʉ��i�ACPN �̓N�[�|�����[�g�AYLD �͗����APER �͔N�Ԃ̊��Ԑ�
% (�f�t�H���g��2)�ABASIS �͓����J�E���g���: 0 =actual/actual (�f�t�H
% ���g)�A1 = 30/360�A2 = actual/360�A3 = actual/365�̂����ꂩ��ݒ肵��
% ���B���t�̓V���A�����t�ԍ��A�܂��́A���t������œ��͂��Ă��������B
%       
% ���F
% ���̃f�[�^���^�����Ă���Ƃ�
%       
%       ���ϓ��@�@        01-Dec-1994
%       ������ �@�@       01-Jan-2001
%       �z�ʉ��i �@       $100.00
%       �N�[�|�����[�g �@ 5%
%       ����� �@         4.34%
%       ���ԁ@�@          ���N
%       �����J�E���g�  actual/actual
%       
%       [pc,yc] = bondconv('12/1/1994','1/1/2000',100,0.05,0.0434,2,0)
%       
% �́A pc = 92.13 ���Ԃ� yc = 23.03 �N���o�͂��܂��B
%
% �Q�l : BONDDUR, CFCONV, CFDUR, BNDCONVY.


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
