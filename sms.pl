# Change below to your Perl installation
#!/exlibris/aleph/a21_1/product/bin/perl
print "Content-type:text/html\n\n";
use Net::SMTP;
use strict;
use warnings;
use CGI;
use CGI::Carp qw( fatalsToBrowser );
# SMS gateways -- below for US
# Google for your local SMS gateways
# and replace here and in sms-js
my %providers = (
    'ATT'       => '@txt.att.net',
    'Boost'     => '@myboostmobile.com',
    'Metro'     => '@mymetropcs.com',
    'Nextel'    => '@messaging.nextel.com',
    'Sprint'    => '@messaging.sprintpcs.com',
    'T-Mobile'  => '@tmomail.net',
    'Verizon'   => '@vtext.com',
    'Virgin'    => '@vmobl.com'
);
# return address need not be an actual email address
# (but should be easily identifiable to your users)
my $from    = "refdesk\@your.lib";
my $q       = new CGI;
my $num     = $q->param( 'number' );
# remove all non-digit characters from number:
$num        =~ s/[^\d]//ig;
# concatenate number with SMTP domain from %providers:
my $to      = $num . $providers{ $q->param( 'provider' ) };
# remove all parentheses and dashes:
$to         =~ s/[\(\)\-\s]//ig;
my $title   = $q->param( 'title' );
# remove extraneous whitespaces at beginning & end of line:
$title      =~ s/^\s+|\s+$//g;
my $hold    = $q->param( 'item' );
my $body    = "'$title'\n$hold\n--DO NOT RESPOND";
# replace [mail-server] with your SMTP domain
my $smtp    = Net::SMTP->new( "[mail-server]", Debug => 1 );
$smtp->mail( $from );
$smtp->to( $to );
$smtp->data();
$smtp->datasend( $body );
$smtp->dataend();
$smtp->quit;
print "clearSMS( );";
