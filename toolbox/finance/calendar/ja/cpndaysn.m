% CPNDAYSN   ����N�[�|�����܂ł̓���
%
% ���̊֐��́ANUMBONDS �������݂���m�藘�t�̃Z�b�g�ɂ��āA���ϓ�
% ���玟�񏀃N�[�|�����܂ł̓������o�͂��܂��B���̊֐��́A�ŏ��ƍŌ��
% �N�[�|�����Ԃ�����łȂ��Ƃ��A�������o�͂��邱�Ƃ��ł��܂��B�[���N�[�|��
% �ɂ��ẮA���̊֐��͌��ϓ����痝�_��̎��񏀃N�[�|����(���Ȃ킿�A
% �����N�[�|���ł���Ɖ��肵���ꍇ�̎���N�[�|����)�܂ł̓������o��
% ���܂��B
%
%     NumDaysNext = cpndaysn(Settle, Maturity)
%
%     NumDaysNext = cpndaysn(Settle, Maturity, Period, Basis, .....
%                   EndMonthRule, IssueDate, FirstCouponDate, .....
%                   LastCouponDate, StartDate)
%
% ����: [�K�{]�Ǝw�肳��Ă���S�Ă̈����́ANUMBONDS�s1��A�܂��́A1�s
% NUMBONDS��̃x�N�g���܂��̓X�J�������ł��B�I�v�V�����̈����́A�S��
% NUMBONDS�s1��A�܂��́A1�sNUMBONDS��̃x�N�g���A�X�J���܂��͋�s���
% �Ȃ�܂��B����(�I�v�V����)�́A��s��ɂ���ďȗ����邱�Ƃ��ł��܂��B
% ����ɓ���(�I�v�V����)�̒��ŁA�������X�g�̖����Ɉʒu������͂͊�������
% ���Ƃ��ł��܂��B����(�I�v�V����)�̒l���f�t�H���g�l�ɐݒ肷��ɂ́A
% NaN�l����͒l�Ƃ��Đݒ肵�Ă��������B���t�����́A�V���A�����t�ԍ��܂���
% ���t������ł��BSIA�m�藘�t�̈����Ɋւ���ڍׂɂ��ẮA'help ftb' 
% �ƃ^�C�v���Ă��������B
% 
% �������̈����Ɋւ���ڍׂɂ��ẮA�R�}���h���C����ŁA
% 'help ftb' + ������(���Ƃ��΁ASettle(���ϓ�)�Ɋւ���w���v�́A
% "help ftbSettle")�ƃ^�C�v����ΎQ�Ƃł��܂��B 
% 
%  Settle (�K�{)  - ���ϓ�
%  Maturity (�K�{)- ������
%
% ����(�I�v�V����)�F
%  Period          - 1�N�ł̃N�[�|���x����; �f�t�H���g��2(���N����)
%  Basis           - �����̃J�E���g�; �f�t�H���g�� 0 (actual/actual)
%  EndMonthRule    - �����K��; �f�t�H���g��1(�����K���͗L��)
%  IssueDate       - ���̔��s��
%  FirstCouponDate - �s����܂��͒ʏ�̑�1��N�[�|���x����
%  LastCouponDate  - �s����܂��͒ʏ�̍ŏI�N�[�|���x���� 
%  StartDate       - �x������O�����ăX�^�[�g��������t(�o�[�W����2.0��
%                    �͖�������܂�)
%
% �o��: 
%  NumDaysNext - ����N�[�|�����܂ł̓���������NUMBONDS�s1��x�N�g���ł��B
%         
% �Q�l : CPNDAYSP, CPNDATEP, CPNDATEPQ, CPNDATEN, CPNDATENQ, CPNPERSZ, 
%        CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.
%   
% Author(s): C. Bassignani, M. Reyes-Kattar 10-17-97, 07-31-98 


%   Author(s): C. Bassignani, M. Reyes-Kattar 10-17-97, 07-31-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
