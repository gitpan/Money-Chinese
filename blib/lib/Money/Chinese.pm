#
# Copyright (c) 2008-2009 Pan Yu (xiaocong@vip.163.com). 
# All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#

package Money::Chinese;

use 5.004;
use strict;
use vars qw($VERSION);

$VERSION = '1.04';

use Carp;
use Data::Dumper;

my @Chinese = qw( Áã Ò¼ ·¡ Èþ ËÁ Îé Â½ Æâ °Æ ¾Á );

sub new {
	my $class = shift;
	my $type = ref($class) || $class;
	my $arg_ref = { @_ };
	
	my $self = bless {}, $type;
	$self;
}

sub convert {
	my $self = shift;
	my $money = shift;
	
	# replace comma and space
	$money =~ s/[,(?:\s)+]//g;
	
	croak "An Arabic numeral with the format of 'xxxx.xx' is expected"
		unless ($money =~ /^(?:\d)+(?:\.(?:\d)+)?$/);
	croak "A non zero Arabic numeral is expected" if ($money == 0);
	
	$self->{integer} = undef;
	$self->{decimal} = undef;
	$self->{Chinese_integer} = undef;
	$self->{Chinese_decimal} = undef;
	
	($self->{integer}, $self->{decimal}) = split /\./, $money;
	
	$self->_integer if ($self->{integer} != 0);
	$self->_decimal if (defined $self->{decimal} && $self->{decimal} != 0);
	$self->_print;
}

sub _print {
	my $self = shift;
	my $result;
	
	$result = $self->{Chinese_integer} if ($self->{integer} != 0);
	if (defined $self->{decimal} && $self->{decimal} != 0) {
		$result .= $self->{Chinese_decimal};
	}else{
		$result .= 'Õû';
	}
	return $result;
}

sub _decimal {
	my $self = shift;
	my ($cent, @cent);
	
	$cent[0] = substr( $self->{decimal}, 0 , 1 );
	$cent[1] = substr( $self->{decimal}, 1 , 1 ) if (length($self->{decimal}) != 1);
	$cent = ($cent[0] == 0)? $Chinese[0]:$Chinese[$cent[0]] . '½Ç';
	$cent .= $Chinese[$cent[1]] . '·Ö' if ($cent[1]);
	
	$self->{Chinese_decimal} = $cent;
}

sub _integer {
	my $self = shift;
	my (@digit, @result, $result);
	my $money = $self->{integer};
	
	for (my $i = 0; length($money) > 0; $i++) {
		$digit[$i] = substr( $money, -4 , 4 );
		substr( $money, -4 , 4 ) = '';
		$digit[$i] = '0'x(4 - length($digit[$i])) . $digit[$i] if (length($digit[$i]) != 4);
	}
	
	my $i = 0;
	foreach (@digit) {
		$i++;
		next if ($_ eq '0000');
		m/(\d)(\d)(\d)(\d)/;
		my $cn;
		my $tail = '';
		$cn = ($1 == 0)? $Chinese[0]:$Chinese[$1] . "Çª";
		$cn .= ($2 == 0)? $Chinese[0]:$Chinese[$2] . "°Û";
		$cn .= ($3 == 0)? $Chinese[0]:$Chinese[$3] . "Ê°";
		$cn .= ($4 == 0)? '':$Chinese[$4];
		if ($i%2 == 0) {
			$tail = 'Íò';
			$tail .= 'Áã' if ($4 == 0);
		}
		if($i > 2) {
			$tail .= 'ÒÚ';
			$tail .= 'Áã' if ($4 == 0);
			$tail =~ s/ÁãÒÚ/ÒÚ/;
		}
		$cn =~ s/(?:Áã)+$//;
		unshift (@result, "$cn$tail");
	}
	$result = join '',@result;
	$result =~ s/(?:Áã){2,}/Áã/g;
	$result =~ s/^(?:Áã)+//;
	
	$result =~ s/(?:Áã)+$//;
	$result .= 'Ôª';
	
	$self->{Chinese_integer} = $result;
}


1;

__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Money::Chinese - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Money::Chinese;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Money::Chinese, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

A. U. Thor, E<lt>a.u.thor@a.galaxy.far.far.awayE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by A. U. Thor

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
