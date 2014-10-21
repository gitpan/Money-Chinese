#########################

use Test::More "no_plan";

#########################

use Money::Chinese;

my $object = Money::Chinese->new;

is($object->convert('10.56'), 'ҼʰԪ���½��', '10.56 is ҼʰԪ���½��');
is($object->convert('10.56789'), 'ҼʰԪ���½��', '10.56789 is ҼʰԪ���½��');
is($object->convert('0.56'), '���½��', '0.56 is ���½��');
is($object->convert('10'), 'ҼʰԪ��', '10 is ҼʰԪ��');
is($object->convert('10.0'), 'ҼʰԪ��', '10.0 is ҼʰԪ��');
is($object->convert('10.00'), 'ҼʰԪ��', '10.00 is ҼʰԪ��');

