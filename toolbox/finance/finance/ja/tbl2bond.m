% TBL2BOND   �����ȏ،��̃p�����[�^������Ɠ����ȍ����Ȓ����̃p�����[�^
%            �ɕϊ�
%
%     [TBondMatrix, Settle] = tbl2bond(TBillMatrix)
%
% �ڍׁF 
% ���̊֐��́A�č������ȏ،��̎s��p�����[�^����͂Ƃ��A���̃p�����[�^
% ��č������Ȓ����̃[���N�[�|���`���ɏ��������܂��B���̊֐��ɂ��A
% �����ȏ،��ƍ����Ȓ����A�����Ƃ̒��ڔ�r���ł���悤�ɂȂ�܂��B
%
% ����:
%         TBillMatrix  - ���̗�x�N�g������Ȃ� N �s 5 ��̍s��ł��B
%                        (�S�ĕK�{)
%         Maturity     - �|�[�g�t�H���I�Ɋ܂܂������ȏ،��̖�������
%                        �V���A�����t�ԍ��`���Ŏ����l����Ȃ� N �s1��
%                        �x�N�g���ł��B
%         DaysMaturity - �|�[�g�t�H���I�Ɋ܂܂��e�����ȏ،��̖�������
%                        �ł̓����𐮐������Ŋ܂� N �s1��̗�x�N�g��
%                        �ł��B�������܂ł̓����́A���X���x�[�X�ŎZ�o��
%                        ��܂��B���Ȃ킿�A���ϓ����疞�����܂ł̎��ۂ�
%                        �����́ADaysMaturity +1�ƂȂ�܂��B
%         Bid          - ������s���������(bid bank discount yield)��
%                        10�i���Ŏ����l����Ȃ� N �s1��̗�x�N�g���ł��B
%                        ������s���������Ƃ́A���i���f�B�[�����w����
%                        ���ۂɊz�ʉ��l���犄�������銄����1�N = 360��
%                        �Ƃ���P���x�[�X�ŔN�����Z�����l�ł��B
%         Asked        - ����Ăы�s���������(asked bank discount 
%                        yield)��10�i���Ŏ����l����Ȃ� N �s1��̗�x�N
%                        �g���ł��B
%         AskYield     - �����Ƃ��،����w�����A����𖞊��܂ŏ��L���邱
%                        �Ƃɂ���Ĕ�����������Z������10�i���Ŏ���
%                        �l����Ȃ� N �s 1 ��̗�x�N�g���ł��B�����Z
%                        �����Ƃ́A���L���Ԏ��v��1�N = 365���Ƃ���P��
%                        �x�[�X�ŔN�����Z�����l�̂��Ƃł��B
%
% �o��:    
%         TBondMatrix  - ���̗�x�N�g������Ȃ� N �s 5 ��̍s��ł��B
%         CouponRate   - �����ȏ،��͒�`��[���N�[�|���ł��邽�߁A�S
%                        �Ă̍����ȏ،��ɑ΂��ă[���ƂȂ铙���ȃN�[�|��
%                        ���[�g����Ȃ� N �s1��̗�x�N�g��(���̈����́A
%                        �s����Ńv���[�X�z���_�[�ƂȂ�x�N�g���ł�)�B
%         Maturity     - �e�����ȏ،��̖��������V���A�����t�ԍ��Ŏ����l
%                        ����Ȃ� N �s1��̗�x�N�g���B
%         Bid          - $100�̊z�ʉ��l�Ɋ��Z�����A�����ȏ،��ɑ΂��锃
%                        ���l��10�i���ŕ\�������l����Ȃ� N �s1��̗�x
%                        �N�g���B
%         Asked        - $100�̊z�ʉ��l�Ɋ��Z�����A�����ȏ،��ɑ΂��锄
%                        �Ēl��10�i���ŕ\�������l����Ȃ� N �s1��̗�x
%                        �N�g���B
%         AskYield     - �����Z���������� N �s1��̃x�N�g���B
%         Settle       - ���������琄�肳��錈�ϓ��Ɩ������܂ł̓�����
%                        ��Ȃ� N �s1��̃x�N�g���ł��B
%
% �Q�l : TR2BONDS.


%	Author(s): C. Bassignani, 11-12-97 
%   Copyright 1995-2002 The MathWorks, Inc. 