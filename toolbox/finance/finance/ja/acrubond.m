% ACRUBOND   ����I�������̗L���،��̌o�ߗ��q
%
% INT = ACRUBOND(ID,SD,FD,RV,CPN,PER,BASIS)�́A����I�������̗L���،���
% �o�ߗ��q���o�͂��܂��B���̊֐��́A�W���A�Z���A�����̍ŏ��̃N�[�|������
% �����L���،��̌o�ߗ��q���v�Z���܂��BID �͔��s���ASD �͌��ϓ��AFD ��
% �ŏ��̃N�[�|�����ARV �͊z�ʉ��i�ACPN �̓N�[�|�������APER �͔N�Ԃ̊��Ԑ�
% (�f�t�H���g=2)�ABASIS �͓����J�E���g��ŁA 0 = actual/actual
% (�f�t�H���g)�A1=  30/360�A2 = actual/360�A3 = actual/365�̂����ꂩ��
% �ݒ肵�܂��B���t�́A�V���A�����t�ԍ��A�܂��́A���t������œ��͂��܂��B
%       
% ���F
%  
%       int = acrubond('31-jan-1983', '1-mar-1993',...  
%                            '31-jul-1983', 100, 0.1, 2, 0) 
%   
% ���̌��ʁAint = 0.8011 ���o�͂���܂��B
%  
% �Q�l : ACRUDISC, CFAMOUNTS, ACCRFRAC.
%   
% ����: ��1���ԈȌ�̌o�ߗ��q���v�Z���鎞�ɂ́A�֐� cfamounts�A�܂��́A
%       �֐� accrfrac �����s����̂��ǂ��ł��傤�B�Ȃ����͈������`�F�b�N
%       ���Ă��������B


%       Author(s): C.F. Garvin, 2-23-95  
%       Copyright 1995-2002 The MathWorks, Inc.   
