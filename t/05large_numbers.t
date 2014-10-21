# There is only one part in this test.
# 1. Using $object->convert('xxx.xx')

#########################

use Test::More "no_plan";

#########################

use Money::Chinese;

my $object = Money::Chinese->new;

is($object->convert('111103'), 'ҼʰҼ��ҼǪҼ������Ԫ��', '111103 is ҼʰҼ��ҼǪҼ������Ԫ��');
is($object->convert('100030.46'), 'Ҽʰ������ʰԪ����½��', '100030.46 is Ҽʰ������ʰԪ����½��');
is($object->convert('13030700809'), 'Ҽ����ʰ������Ǫ����ʰ����ư����Ԫ��', '13030700809 is Ҽ����ʰ������Ǫ����ʰ����ư����Ԫ��');
is($object->convert('1200000000000000'), 'ҼǪ��������Ԫ��', '1200000000000000 is ҼǪ��������Ԫ��');
