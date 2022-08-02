% CFAMOUNTS   �|�[�g�t�H���I�̊e���ɑ΂���L���b�V���t���[�y�ю��Ԏʑ�
%
% ���̊֐��́A�ȉ��̂��̂��o�͂��܂��B
% - �L���b�V���t���[
% - �L���b�V���t���[�̓��t
% - �s�A���Ȕ��N�����̃N�[�|���ɑ΂���K�؂Ȏ���
%   
%   [CFlowAmounts, CFlowDates, TFactors, CFlowFlags] = ...
%       cfamounts(CouponRate, Settle, Maturity)
%
%   [CFlowAmounts, CFlowDates, TFactors, CFlowFlags] = ...
%       cfamounts(CouponRate, Settle, Maturity, Period, ... 
%           Basis, EndMonthRule, IssueDate, ...
%       FirstCouponDate, LastCouponDate, StartDate, Face)
%
% ����: [�X�J���A�܂��� NBONDS x 1 �̑傫���̃x�N�g��]
%
%   CouponRate (�K�{) - 10�i�@�ŕ\�L���ꂽ�N�[�|�������B�[���N�[�|����
%                       �ꍇ��0
%   Settle     (�K�{) - ���ϓ�
%
%   Maturity   (�K�{) - ������
%
% ����(�I�v�V����):
%   Period - �N�[�|���x����; �f�t�H���g�� "2" (���N����)
%
%   Basis - �|�[�g�t�H���I�̊e���ɑ΂�������̃J�E���g�; �\�Ȓl�́A
%           0 - ���ۂ̓���/���ۂ̓��� (�f�t�H���g)
%           1 - 30/360 (SIA����)
%           2 - ���ۂ̓���/360
%           3 - ���ۂ̓���/365
%           4 - 30/360  (PSA����)
%           5 - 30/360  (ISDA����)
%           6 - 30/360  (���[���b�p�^)
%           7 - act/365 (���{�^)
%
%   EndMonthRule    - �����K��; �f�t�H���g�� "1" (�����K���͗L��)
%   IssueDate       - ���̔��s���ŗ��q�̔�����
%   FirstCouponDate - ��1��N�[�|���x����
%   LastCouponDate  - �ŏI�N�[�|���x���� 
%   StartDate       - �����X�^�[�g������(�������p���邽�߂̈���)
%   Face            - �z�ʉ��l�A�f�t�H���g��100
% 
% �o��: �o�͂�NBONDS�sNCFS��̍s��ł��B���ꂼ��̍s�́A���Y���ɑ΂���
%   �L���b�V���t���[�������Ă��܂��B�����Z���s�́ANaN�l�ɂ�錅������
%   �s���܂��B
% 
%  CFlowAmounts - �L���b�V���t���[�̑��z; ���ꂼ��̍s�x�N�g���̍ŏ���
%                 �v�f�͌��ϓ��Ɏx������ׂ�(����)�o�ߗ��q�ł�(�o�ߗ��q
%                 ���x�����Ȃ��ꍇ�́A�ŏ��̗�̓[���ƂȂ�܂�)�B
%  CFlowDates   - �L���b�V���t���[���t�������V���A�����t�ԍ��ł��B���Ȃ�
%                 �Ƃ�2�̗�(���ϓ��A������)�͏�ɑ��݂��Ă��܂��B
%  TFactors     - �[����SIA���N���i�^����芷�Z�ɗp���鎞�ԌW��
%                    �����W��= (1 + Yield/2).^(-TFactor)  
%                 ���ԌW���͔��N�N�[�|�����Ԃ��P�ʂƂȂ��ĎZ�肳��܂��B
%  CFlowFlags   - �������̃^�C�v�������L���b�V���t���[�t���O �ł�( "help
%                 ftbcflowflags" �ƃ^�C�v����ƁA�����̃t���O�Ɋւ���
%                 �ڍׂȐ��������邱�Ƃ��ł��܂�)�B


%   Author(s): Bassignani, 22-Jan-98, Akao 29-Jan-99, Winata 30-Aug-2002
%   Copyright (c) 1995-1999 The MathWorks, Inc. All Rights Reserved.
