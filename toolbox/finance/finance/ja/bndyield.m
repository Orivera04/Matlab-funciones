% BNDYIELD   �m�藘�t���̖����܂ł̗����
%
% �^����ꂽ SIA ���t�p�����[�^�ƃN���[�����i��L���� Numbonds ���̍�
% �ɂ��āA�����������o�͂��܂��B
%         
%   Yield = bndyield(Price, CouponRate, Settle, Maturity)
%
%   Yield = bndyield(Price, CouponRate, Settle, Maturity, Period,....
%   Basis, EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate,...
%   StartDate, Face)
%
% ����: [�K�{]�Ǝw�肳��Ă���S�Ă̈����́ANUMBONDS�s1��A�܂��́A1�s
% NUMBONDS��̃x�N�g���A�܂��́A�X�J�������ł��B�I�v�V�����̈����͑S��
% NUMBONDS�s1��A�܂��́A1�sNUMBONDS��̃x�N�g���A�X�J���A�܂��́A��s��
% �ƂȂ�܂��B����(�I�v�V����)�́A��s��ɂ���ďȗ����邱�Ƃ��ł��܂��B
% ����ɓ���(�I�v�V����)�̒��ŁA�������X�g�̖����Ɉʒu������͂͊�������
% ���Ƃ��ł��܂��B����(�I�v�V����)�̒l���f�t�H���g�l�ɐݒ肷��ɂ́A
% NaN�l����͒l�Ƃ��Đݒ肵�Ă��������B���t�����́A�V���A�����t�ԍ�
% �܂��́A���t������ł��BSIA�m�藘�t�،��̈����Ɋւ���ڍׂɂ��ẮA 
% 'help ftb'�ƃ^�C�v���Ă��������B
% �������̈����Ɋւ���ڍׁA���Ƃ��΁ASettle�́A"help ftbSettle"��
% �^�C�v����ΎQ�Ƃł��܂��B 
%
%  Price(�K�{)        - ���̃N���[�����i
%  CouponRate (�K�{)  - 10�i�@�ŕ\�L���ꂽ�N�[�|������
%  Settle (�K�{)      - ���ϓ�
%  Maturity (�K�{)    - ������
%  Period             - �N������̃N�[�|���x����(�f�t�H���g��2)
%  Basis              - �����J�E���g��B�f�t�H���g��0 (actual/actual)
%  EndMonthRule       - �����K���B�f�t�H���g��1(�����K���͗L��)
%  IssueDate          - ���̔��s��
%  FirstCouponDate    - �s����A�܂��́A�ʏ�̑���N�[�|���x����
%  LastCouponDate     - �s����A�܂��́A�ʏ�̍ŏI�N�[�|���x����
%  StartDate          - �x�����̐�X�^�[�g��
%                      (2.0�ł͂��̈����̓��͖͂�������܂�)
%  Face               - ���̊z�ʉ��l�B�f�t�H���g��100
%
% ����(�I�v�V����):
%  Period             - 1�N�ł̃N�[�|���x����(�f�t�H���g��2)
%  Basis              - �����J�E���g��B�f�t�H���g��0 (actual/actual)
%  EndMonthRule       - �������[���B�f�t�H���g��1(�����K���͗L��)
%  IssueDate          - ���̔��s��
%  FirstCouponDate    - �s����A�܂��́A�ʏ�̑�1��N�[�|���x����
%  LastCouponDate     - �s����A�܂��́A�ʏ�̍ŏI�N�[�|���x����
%  StartDate          - �x�����̐�X�^�[�g��
%                       (2.0�ł͂��̈����̓��͖͂�������܂�)
%  Face               - ���̊z�ʉ��l�B�f�t�H���g��100
%
% �o��: NumBonds�s1��̃x�N�g���łȂ���΂Ȃ�܂���B
%  Yield : ���N�����v�Z�̖��������
%
% ���ӁF
%   ���i�Ɨ������֘A�t���Ă���̂́A���̌����ł��B
%
%   ���i + �o�ߗ��q = sum( �L���b�V���t���[*(1+�����/2)^(-����))
%
%  �����ŁAsum(���a)�́A���̃L���b�V���t���[�y�є��N�����N�[�|������
%  ��P�ʂɂ��đ��肳���L���b�V���t���[�ɑΉ����鎞�Ԃɓn���Čv�Z����
%  �܂��B
%
% �Q�l : BNDPRICE, CFAMOUNTS.


%   Author(s): C. Bassignani, 04-25-98
%   Copyright 1995-2002 The MathWorks, Inc. 
