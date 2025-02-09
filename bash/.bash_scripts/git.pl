#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

sub isChanged {
    my ( $index, $workingTree ) = @_;
    return $workingTree eq 'M' || ( $workingTree eq 'D' && $index ne 'D' );
}

sub isStaged {
    my ( $index, $workingTree ) = @_;
    return
         ( $index eq 'A' && $workingTree eq 'A' )
      || ( $index eq 'D' && $workingTree ne 'D' )
      || $index =~ m/[MRC]/;
}

sub isConflict {
    my ( $index, $workingTree ) = @_;
    return
         $index eq 'U'
      || $workingTree eq 'U'
      || ( $index eq 'A' && $workingTree == 'A' )
      || ( $index eq 'D' && $workingTree == 'D' );
}

sub isUntracked { return shift eq '?'; }

my $BRANCH_INFO = <>;

my $changed        = 0;
my $conflict       = 0;
my $staged         = 0;
my $untracked      = 0;
my $undefinedState = 0;

my @lines = <>;
foreach my $line (@lines) {
    my ( $index, $workingTree ) = split //, substr( $line, 0, 2 );

    if ( isUntracked($index) ) {
        $untracked++;
    }
    elsif ( isChanged( $index, $workingTree ) ) {
        $changed++;
    }
    elsif ( isStaged( $index, $workingTree ) ) {
        $staged++;
    }
    elsif ( isConflict( $index, $workingTree ) ) {
        $conflict++;
    }
    else {
        $undefinedState++;
    }
}

my ( $branch, $upstream, undef, $ahead, undef, $behind ) =
  ( $BRANCH_INFO =~
      m/^## (\S+)\.{3}(\S+)?( \[ahead (\d+)\])?( \[behind (\d+)\])?\n?$/g );

my $stringToPrint =
    "$changed $conflict $staged $untracked "
  . ( $ahead  || 0 ) . " "
  . ( $behind || 0 );

print $stringToPrint;
