package Apache::Dir;

use Apache::Constants qw(DECLINED DIR_MAGIC_TYPE HTTP_MOVED_PERMANENTLY);

$Apache::Dir::VERSION = '0.03';

sub handler {
    my $r = shift;
    return DECLINED unless $r->content_type eq DIR_MAGIC_TYPE
      && $r->uri !~ m{/$};
    my $args = $r->args;
    $r->header_out(Location => $r->uri . '/' . ($args ? "?$args" : ''));
    return HTTP_MOVED_PERMANENTLY;
}

1;
__END__

=head1 NAME

Apache::Dir - Simple Perl Version of mod_dir

=head1 SYNOPSIS

  PerlModule Apache::Dir
  PerlFixupHandler Apache::Dir

=head1 DESCRIPTION

This simple module is designed to be a partial replacement for the standard
Apache C<mod_dir> module. One of the things that module does is to redirect
browsers to a directory URL ending in a slash when they request the directory
without the slash. Since C<mod_dir> seems do its thing during the Apache
response phase, if you use a Perl handler, it won't run. This can be
problematic if the Perl handler doesn't likewise take the directory
redirecting into account.

A good example is HTML::Mason. If you've disabled Mason's C<decline_dirs>
parameter (C<MasonDeclineDirs 0> in F<httpd.conf>), and there's a F<dhandler>
in the directory F</foo>, then for a request for F</foo>, F</foo/dhandler>
will respond. This can wreak havoc if you use relative URLs in the
C<dhandler>. What really should happen is that a request for F</foo> will be
redirected to F</foo/> before Mason ever sees it.

This is the problem that this module is designed to address. Configuration
would then look something like this:

  <Location /foo>
    PerlSetVar       MasonDeclineDirs 0
    PerlModule       Apache::Dir
    PerlModule       HTML::Mason::ApacheHandler
    SetHandler       perl-script
    PerlFixupHandler Apache::Dir
    PerlHandler      HTML::Mason::ApacheHandler
  </Location>

Apache::Dir can also be configured to handle the request during the response
cycle, if you wish. Just specify it before any other Perl handler to have it
execute first:

  <Location /foo>
    PerlSetVar  MasonDeclineDirs 0
    PerlModule  Apache::Dir
    PerlModule  HTML::Mason::ApacheHandler
    SetHandler  perl-script
    PerlHandler Apache::Dir HTML::Mason::ApacheHandler
  </Location>

=head1 AUTHOR

David Wheeler, E<lt>david@kineticode.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2004 by David Wheeler

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut