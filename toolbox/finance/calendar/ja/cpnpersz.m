% CPNPERSZ   �N�[�|�����Ԃ̓���
% 
% ���̊֐��́ANUMBONDS �������݂���m�藘�t���ɑ΂��āA���ϓ����܂�
% �N�[�|�����Ԃ̓������o�͂��܂��B
%
%   NumDaysPeriod = cpnpersz(Settle, Maturity)
%
%   NumDaysPeriod = cpnpersz(Settle, Maturity, Period, Basis, ...
%          EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate, ...
%          StartDate)
%
% ����: [�K�{]�Ǝw�肳��Ă���S�Ă̈����́ANUMBONDS�s1��A�܂��́A1�s
%   NUMBONDS��̃x�N�g���A�܂��́A�X�J�������ł��B�I�v�V�����̈�����
%   �S��NUMBONDS�s1��A�܂��́A1�sNUMBONDS��̃x�N�g���A�X�J���A�܂��́A
%   ��s��ƂȂ�܂��B����(�I�v�V����)�́A��s��ɂ���ďȗ����邱�Ƃ�
%   �ł��܂��B����ɓ���(�I�v�V����)�̒��ŁA�������X�g�̖����Ɉʒu����
%   ���͂͊������邱�Ƃ��ł��܂��B����(�I�v�V����)�̒l���f�t�H���g�l��
%   �ݒ肷��ɂ́ANaN�l����͒l�Ƃ��Đݒ肵�Ă��������B���t�����́A�V��
%   �A�����t�ԍ��܂��͓��t������ł��BSIA�m�藘�t���̈����Ɋւ���ڍ�
%   �ɂ��ẮA'help ftb' �ƃ^�C�v���Ă��������B
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
% NumDaysPeriod - 
%      ���ϓ����܂ރN�[�|�����Ԃ̓���������NUMBONDS�s1��̃x�N�g���ł��B
% 
% �Q�l: CPNDAYSN, CPNDAYSP, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, 
%       CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC.


%   Author(s): C. Bassignani, 10-17-97, 07-31-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
