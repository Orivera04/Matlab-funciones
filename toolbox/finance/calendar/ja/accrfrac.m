% ACCRFRAC   ���ϑO�̃N�[�|�����Ԃ̒[��
%
% ���̊֐��́ANBONDS �������݂���m�藘�t�ɑ΂��āA���ϓ��܂łɌo��
% ����N�[�|�����Ԃ̒[�����v�Z���܂��B�����Ōv�Z���ꂽ�[�����w�肳�ꂽ
% �m�藘�t�̒���L���b�V���t���[�̖��ڊz�Ɗ|�����킹�邱�Ƃɂ���āA
% ���Y���Ɏx������o�ߗ��q���Z�o���邱�Ƃ��ł��܂��B���̊֐��́A�ʏ��
% �N�[�|�����Ԃ��������1��ڂ܂��͍ŏI�N�[�|�����Ԃ̒������[���̍�
% �̌o�ߗ��q�ɑ΂��ėL���ł��B
% 
% Fraction = accrfrac(Settle, Maturity) 
%
% Fraction = accrfrac(Settle, Maturity, Period, Basis, EndMonthRule, ...
%        IssueDate, FirstCouponDate, LastCouponDate, StartDate)
%
% ����: [�K�{]�Ƃ���Ă�����͈����́ANBONDS�s1��̃x�N�g���܂��̓X�J��
%   �����ł��B����(�I�v�V����)�́A��s��ɂ���ďȗ����邱�Ƃ��ł��܂��B
%   �܂��A�������X�g�̖����̓���(�I�v�V����)�͊������邱�Ƃ��ł��܂��B
%   ����(�I�v�V����)�̂����ꂩ��NaN�l��ݒ肷��ƁA���̓��͂̓f�t�H���g
%   �l�ɐݒ肳��܂��B
%   ���t�����́A�V���A�����t�ԍ��܂��͓��t������ł��BSIA�m�藘�t��
%   �����̏ڍׂ�����ɂ́A 'help ftb'�ƃ^�C�v���Ă��������B��������
%   �����Ɋւ���ڍׁA���Ƃ��΁ASettle�Ɋւ���w���v�́A"help ftbSettle"
%   �ƃ^�C�v����ΎQ�Ƃł��܂��B
% 
%    Settle (�K�{)   - ���ϓ�
%    Maturity (�K�{) - ������
%
% ����(�I�v�V����)�F
%    Period          - 1�N�ł̃N�[�|���x����; �f�t�H���g��2(���N����)
%    Basis           - �����̃J�E���g�; �f�t�H���g�� 0 (actual/actual)
%    EndMonthRule    - �����K��; �f�t�H���g��1(�����K���͗L��)
%    IssueDate       - ���̔��s���ŗ��q�̔�����
%    FirstCouponDate - ��1��N�[�|���x����
%    LastCouponDate  - �ŏI�N�[�|���x���� 
%    StartDate       - �����X�^�[�g������(�������p���邽�߂̈���)
%
% �o��: 
%    Fraction        - �o�ߗ��q�̒[��������NUMBONDS�s�P��x�N�g��
%
% �Q�l : CFAMOUNTS, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, 
%        CPNDAYSP, CPNPERSZ, CPNCOUNT, CFDATES.


%Author(s): C. Bassignani, 04-04-98, 07-31-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
