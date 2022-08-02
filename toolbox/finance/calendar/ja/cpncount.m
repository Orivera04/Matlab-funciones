% CPNCOUNT   �������܂ł̃N�[�|���̎x�����̉�
%
% ���̊֐��́ANBONDS�̊m�藘�t�ɂ��āA�������܂łɎc���ꂽ�N�[�|��
% �x�����̉񐔂��o�͂��܂��B
% 
%  NumCouponsRemaining = cpncount(Settle, Maturity)
%
%  NumCouponsRemaining = cpncount(Settle, Maturity, Period, Basis, ...
%         EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate, ...
%         StartDate)
%
% ����: [�K�{]�Ǝw�肳��Ă���S�Ă̈����́ANBONDS�s1��A�܂��́A1�s
%   NBONDS��̃x�N�g���܂��̓X�J�������ł��B�I�v�V�����̈����́A��s��
%   �ɂ���ďȗ����邱�Ƃ��ł��܂��B����ɓ���(�I�v�V����)�̒��ŁA����
%   ���X�g�̖����Ɉʒu������͂͊������邱�Ƃ��ł��܂��B����(�I�v�V����)
%   �̒l���f�t�H���g�l�ɐݒ肷��ɂ́ANaN�l����͒l�Ƃ��Đݒ肵�Ă���
%   �����B���t�����́A�V���A�����t�ԍ��܂��͓��t������ł��BSIA�m��
%   ���t�̈����Ɋւ���ڍׂɂ��ẮA'help ftb' �ƃ^�C�v���Ă��������B
%   �������̈����Ɋւ���ڍׁA���Ƃ���Settle�Ɋւ���w���v�́A
%   "help ftbSettle" �ƃ^�C�v����ΎQ�Ƃł��܂��B 
% 
%  Settle (�K�{)  - ���ϓ�
%  Maturity (�K�{)- ������
%
% ����(�I�v�V����)�F
%  Period          - 1�N�ł̃N�[�|���x����; �f�t�H���g��2(���N����)
%  Basis           - �����̃J�E���g�; �f�t�H���g�� 0 (actual/actual)
%  EndMonthRule    - �����K��; �f�t�H���g��1(�����K���͗L��)
%  IssueDate       - ���̔��s��
%  FirstCouponDate - ���ۂ̑�1��N�[�|���x����
%  LastCouponDate  - ���ۂ̍ŏI�N�[�|���x���� 
%  StartDate       - �����X�^�[�g������(�������p���邽�߂̈���)
%
% �o��: 
% NumCouponsRemaining - ���ϓ�����Ɏx������N�[�|���̉񐔂����� 
%                       NBONDS�s�P��̃x�N�g���ł��B���ϓ��Ɏx������
%                       �N�[�|���y�ь��ϓ����O�Ɏx����ꂽ�N�[�|����
%                       ���Ă̓J�E���g����܂���B�A���A�������Ɏx����
%                       ���N�[�|���ɂ��Ă͏�ɃJ�E���g����܂��B
%
% �Q�l : CPNCDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, 
%        CPNDAYSP, CPNPERSZ, CFDATES, CFAMOUTNS, ACCRFRAC, CFTIMES.


%Author(s): C. Bassignani, 10-17-97, 07-31-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
