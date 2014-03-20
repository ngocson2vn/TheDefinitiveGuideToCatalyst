package DBAuthTest::View::Web;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

DBAuthTest::View::Web - TT View for DBAuthTest

=head1 DESCRIPTION

TT View for DBAuthTest.

=head1 SEE ALSO

L<DBAuthTest>

=head1 AUTHOR

Son Nguyen

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
