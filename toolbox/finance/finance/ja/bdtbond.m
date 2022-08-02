% BDTBOND   Black-Derman-Toy���f���ɂ��I�v�V�������g�ݍ��܂ꂽ����
%           ���i
%  
% �R�[���A�܂��́A�v�b�g�I�v�V�������g�ݍ��܂ꂽ���̉��i�y�ъ����x��
% �v�Z���܂��B���̕]���́ABlack-Derman-Toy���f���Ɋ�Â��čs���܂��B
% ���̃��f���́A���������Ȑ�(���邢�͐M�p�i��)�ƃ{���e�B���e�B�Ȑ�
% ��������I�v�V�����̉��i������s�����߂̃��f���ł��B
%
%  [Price, Sensitivities, DiscTree, PriceTree] = ....
%               bdtbond(OptBond, ZeroCurve, VolatilityCurve,...
%               Accuracy, CreditCurve, ComputeSensitivity)
%
% Accuracy �ȊO�̈����́A�\���̂ƂȂ��Ă��܂��B�����ϐ��̖��̂�u��������
% ���Ƃ͂ł��܂����A�t�B�[���h���͌����ɓ������̂�p���Ȃ���΂Ȃ�܂���B
% �ϐ��y�уt�B�[���h�͈ȉ��̕ϐ��A�t�B�[���h�������̏��ԂŃ��X�g�A�b�v
% ����Ă��܂��B�I�v�V�����t�B�[���h�A�܂��́A�ϐ��ɂ��ẮA��s�� [] 
% �ɐݒ肷��ƁA�f�t�H���g�l���Ăяo����܂��B�Ȃ��A�\���̂̃I�v�V������
% �t�B�[���h�ɂ��ẮA���ݒ�̂܂܂ł��\���܂���B
%
% ����:
% OptBond : (�K�{)�\�ȃR�[���A�v�b�g�I�v�V���������Ώۍ��B
%           �t�B�[���h�́A�X�J���A�܂��́A���t������ł��B
%
%     �Ώۏ،��ɑ΂��ďڍאݒ���s���t�B�[���h�ł��B���p�����[�^��
%     �ւ���ڍׂɂ��ẮA���Y�p�����[�^���{FTB�ɂ���ČĂяo�����
%     �w���v���Q�Ƃ��Ă��������B
%
%    - OptBond.Settle          :  (�K�{)���ϓ�
%    - OptBond.Maturity        :  (�K�{)������
%    - OptBond.Period          :  (�K�{)�N�[�|���x�����̕p�x�B
%                                  �f�t�H���g��2
%    - OptBond.Basis           :  (�I�v�V����)�s����t�J�E���g��B
%                                  �f�t�H���g��0 (actual/actual)
%    - OptBond.EndMonthRule    :  (�I�v�V����)�����K���B�f�t�H���g��1
%                                  (�L��)
%    - OptBond.FirstCouponDate :  (�I�v�V����)�ŏ��̃N�[�|�����Ԃ��s���
%                                  �̏ꍇ�Ɏx������ŏ��̃N�[�|���x��
%    - OptBond.LastCouponDate  :  (�I�v�V����)�Ō�̃N�[�|�����Ԃ��s���
%                                  �̏ꍇ�Ɏx������Ō�̃N�[�|���x��
%    - OptBond.IssueDate       :  (�I�v�V����)�ŏ��̃N�[�|�����Ԃ��s���
%                                  �̏ꍇ�̍��̔��s��
%    - OptBond.StartDate       :  (�I�v�V����)���ϑO�łȂ��ꍇ�̍��̐�
%                                  �X�^�[�g��
%    - OptBond.CouponRate      :  (�I�v�V����)�N�[�|�����[�g(���D����)
%    - OptBond.Face            :  (�I�v�V����)���̖������x�����B
%                                  �f�t�H���g��100
% 
%      �I�v�V�����ƂȂ���̏ڍ׎w��t�B�[���h�F
%      �R�[���A�܂��́A�v�b�g�Ɋւ���t�B�[���h�̐ݒ���s�����Ƃ��ł�
%      �܂��B�R�[���́A���̔��s�҂ɂ���čs����Ƒz�肳��A�v�b�g��
%      ���̏��L�҂ɂ���čs����Ƒz�肳��܂��B���̂��߁A�R�[����
%      �����L�҂ɑ΂�����̉��l���߂邱�ƂɂȂ���܂����A�v�b�g��
%      ���̉��l�����߂邱�ƂɂȂ�܂��B
%
%    - OptBond.CallStrike     : (�K�{)�R�[���I�v�V���������s�g���i
%    - OptBond.CallType       : (�I�v�V����)�t���O1(�č�)�A�܂��́A0 
%                                (���B)�B�f�t�H���g�͉��B�I�v�V���� 
%                                (CallType = 1)�ł��B
%    - OptBond.CallExpiryDate : (�I�v�V����)�č��I�v�V�����̌����s�g��
%                                �ŏI�������B�܂��́A���B�I�v�V�����̏ꍇ
%                                �����s�g���\�ƂȂ�B��̓��t�B�f�t�H
%                                ���g�́A���̖������ƂȂ��Ă��܂��B
%    - OptBond.CallStartDate  : (�I�v�V����)�č��I�v�V�����̌����s�g��
%                                �ŏ��ɉ\�ƂȂ���t�B�f�t�H���g�ł́A
%                                ���̌��ϓ��ƂȂ��Ă��܂��B
%    - OptBond.PutStrike      : (�K�{)�v�b�g�I�v�V���������s�g���i
%    - OptBond.PutType        : (�I�v�V����)�t���O1(�č�)�A�܂��́A0 
%                                (���B)�B�f�t�H���g�ł͕č��I�v�V������
%                                �Ȃ��Ă��܂�(PutType = 1)�B
%    - OptBond.PutExpiryDate  : (�I�v�V����)�č��I�v�V�����̌����s�g��
%                                �ŏI�������B�܂��́A���B�I�v�V�����̏ꍇ
%                                �����s�g���\�ƂȂ�B��̓��t�B�f�t�H
%                                ���g�ł͍��̖������ƂȂ��Ă��܂��B
%    - OptBond.PutStartDate   : (�I�v�V����)�č��I�v�V�����̌����s�g��
%                                �ŏ��ɉ\�ƂȂ���t�B�f�t�H���g�ł͍�
%                                �̌��ϓ��ƂȂ��Ă��܂��B
%  
%  ZeroCurve : (�K�{)1�g�� NCURVE(date, decimal rate)�Ŏ�����闘���Ȑ�
%              �����̎��ԓI�X�p�����J�o�[���邽�߂ɓ��}����܂��B�ŏ���
%              �Ȑ��̓��t���O�̎��Ԃł́A�ŏ��̃��[�g���g�p����A�Ō��
%              �Ȑ��̓��t����̎��Ԃł́A�Ō�̃��[�g���g�p����܂��B 
%    - ZeroCurve.CurveDates : (�K�{)[NCURVE �s1��̍s��] �������̃x�N�g��
%                             ���t�͓��t������A�܂��́A�V���A�����t�ԍ�
%                             �ł��B
%    - ZeroCurve.ZeroRates  : (�K�{)[NCURVE �s1��̍s��] ���[�g�̃x�N�g��
%
%  VolatilityCurve : (�K�{)�Z�����[�g�̏u�ԃ{���e�B���e�B�Ȑ��B���̋Ȑ�
%                    �́A1�g�� NCURVE2(date, decimal rate)�ō\������A
%                    ���̎��ԓI�X�p�����J�o�[���邽�߂ɓ��}����܂��B  
%    - VolatilityCurve.CurveDates      : (�K�{)[NCURVE2 �s1��̍s��]���t
%                                         �̃x�N�g��
%    - VolatilityCurve.VolatilityRates : (�K�{)[NCURVE2 �s1��̍s��] 
%                                         10�i�@�\�L�̔N�ԃ{���e�B���e�B��
%                                         �x�N�g��
%
%  Accuracy    : (�K�{)���̈����́A�\���̂ł͂���܂���B�X�J���l Accuracy
%                �́A���N�����̃N�[�|�����Ԃ��ƂɃc���[�̃X�e�b�v��������
%                �i�ނ����w�肷������ł��B���傫�Ȓl�����蓖�Ă�قǁA
%                �o�͂������́A��萳�m�Ȃ��̂ƂȂ�܂����A���̈����
%                ���Ԃƃ���������葽���g�����ƂɂȂ�܂��B
%
%  CreditCurve : (�I�v�V����)�f�t�H���g�̃��X�N���琶����[�����X�v���b�h
%                �Ȑ��B���̋Ȑ���1�g�� NCURVE3(date, basis point)�ō\��
%                ����A���̎��ԓI�X�p�����J�o�[���邽�߂ɓ��}����܂��B
%    - CreditCurve.CurveDates  : (�K�{)[NCURVE3 �s1��̍s��] �V���A��
%                                ���t�ԍ��A�܂��́A���t������̃x�N�g��
%    - CreditCurve.CreditRates : (�K�{)[NCURVE3 �s1��̍s��] �x�[�V�X
%                                �|�C���g�ɂ�����M�p�i���̒l(10�i����
%                                ���[�g�ł͂���܂���)�������x�N�g���B
%                                �[�����ւ̕ύX�������I�ɍs�����@�́A
%                                CreditRates/10000�ł��B
%
%  ComputeSensitivity : (�I�v�V����) (�I�v�V�����t���y�уI�v�V�����Ȃ�)
%                       ���̊����x���x�̌v�Z���s�����ǂ������w�肵�܂��B
%                       �t�B�[���h��1�̒l����͂���΁A�����x���x�͌v�Z
%                       ����A0�̒l����͂���΁A���x�͌v�Z����܂���B
%                       �����x�́A�L���̍����v�Z�ɂ���ĎZ�o����܂��B
%                       �f�t�H���g�ł͊����x�͌v�Z���ꂸ�A���i�݂̂��o��
%                       ����܂��B
%    - ComputeSensitivity.Duration : (�K�{)�X�J�� 1�A�܂��́A0
%    - ComputeSensitivity.Convexity: (�K�{)�X�J�� 1�A�܂��́A0
%    - ComputeSensitivity.Vega     : (�K�{)�X�J�� 1�A�܂��́A0
%
%  �o��:
%  ���i : �I�v�V�����t�����y�уI�v�V�����Ȃ����̉��l
%    - Price.OptionFreePrice  : ����̃I�v�V�������t�����Ă��Ȃ�����
%                               ���i(�X�J��)
%    - Price.OptionEmbedPrice : �I�v�V�����t�����̃X�J���l�Ŏ����ꂽ
%                               ���i(���ۗ̕L�҂ɂƂ��Ẳ��l)
%    - Price.OptionValue      : �I�v�V�����̍����L�҂ɂƂ��Ẳ��l
%                               (�X�J��)
%     
%  �����x
%    - Sensitivities.Duration     : �����Ȑ��̕��s�ړ��ɑ΂���I�v�V����
%                                   �t���[���̊����x   
%    - Sensitivities.EffDuration  : �����Ȑ��̃V�t�g�ɑ΂���I�v�V����
%                                   �g�ݍ��݉��i�̊����x
%    - Sensitivities.Convexity    : �����Ȑ��̃V�t�g�ɑ΂���f�����[
%                                   �V�����̊����x
%    - Sensitivities.EffConvexity : �����Ȑ��̃V�t�g�ɑ΂��� Eff �f��
%                                   ���[�V�����̊����x
%    - Sensitivities.Vega         : �{���e�B���e�B�Ȑ��̕��s�ړ��ɑ΂���
%                                   �I�v�V�����g�ݍ��݉��i�̊����x
%
% �����c���[ : �����\���̓񍀃c���[���Č����B���̃c���[�́A���ς��疞��
% �܂ł̎��� NPERIODS ���J�o�[���A�e�N�[�|�����Ԗ��ɁAAccuracy �Ŏw��
% ���ꂽ�X�e�b�v�������i�݂܂��B���ώ��_�y�ь��ςƍŏ��̎x�����Ԃ̒Z��
% ���[�g�́A���炩���ߌ��肳��Ă��܂��B
%  
%    - DiscTree.Values   : �Z�������t�@�N�^�� [NSTATES�sNPERIODS��]��
%                          �s��ł��BNPERIODS��́A�A�����鎞�ԂɑΉ���
%                          �Ă��܂��B����ANSTATES �s�́A�����v���Z�X��
%                          ��ԂɑΉ����Ă��܂��B�l�����͂���Ă��Ȃ�
%                          ��Ԃ́ANaN �l�Ń}�X�N����Ă��܂��B
%  
% ���_ Dates(i) �ɂ����錻���̊z�Ɗ��� Values(j,i)�Ƃ��|�����킹�邱�Ƃ�
% ���A�c���[�̃G�b�W (j,i)�ƌ���������� Dates(i-1)�ɂ����鉿�i�����߂�
% ���Ƃ��ł��܂��B�c���[�̃m�[�h (j,i)�ɂ�����Z�����[�g R(j,i)�́A����
% ���𖞂����܂��B
% 
%      (1+ R(j,i)/Frequency)^(-(Times(j)-Times(j-1)))= Values(j,i)
% 
%    - DiscTree.Times     : [1 �s NPERIODS ��]�N�[�|�����ԒP�ʂł̃c���[
%                           �m�[�h�^�C���̃x�N�g��(ftbTFactors �Q��)
%    - DiscTree.Dates     : [1 �s NPERIODS ��]�V���A�����t�ԍ��Ŏ����ꂽ
%                           �c���[�m�[�h�^�C���̃x�N�g��
%    - DiscTree.Type      : �Z������
%    - DiscTree.Frequency : �������̕����p�x(compounding frequency)
%    - DiscTree.ErrorFlag : (0�A�܂��́A1)�A1�ɐݒ肷��ƒZ�����[�g��
%                           ���ƂȂ�܂��B
%
%  PriceTree : �c���[�m�[�h�ł̌������z��\���񍀃c���[���Č����B���i
%  �c���[�́A���L���b�V���t���[�y�уI�v�V�����y�C�I�t����v�Z����܂��B
%  ���̃N���[�����i�́APrice Tree Value ����N�[�|���x�����y�ьo�ߗ��q
%  �������������Ƃɂ���Čv�Z�ł��܂��B
%    - PriceTree.Values [NSTATES �s NPERIODS ��] ���i��Ԃ������s��
%    - PriceTree.Times   : [1�sNPERIODS��] �N�[�|�����ԒP�ʂł̃c���[
%                          �m�[�h�^�C���̃x�N�g��(ftbTFactors �Q��)
%    - PriceTree.Dates   : [1�sNPERIODS��] �V���A�����t�ԍ��ŕ\�����ꂽ
%                          �c���[�m�[�h�^�C���̃x�N�g��
%    - PriceTree.AccrInt : [1�sNPERIODS��] �e���_�Ŏx������ׂ��o��
%                          ���q�̃x�N�g��
%    - PriceTree.Coupons : [1�sNPERIODS��] �e���_�ɂ�����N�[�|���x����
%                          �̃x�N�g��
%    - DiscTree.Type     : 'Price'
%
% �Q�l : BDTTRANS.


%   Author: C. Bassignani, 04-18-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
