#!/usr/bin/perl

# Copyright 2004 Itai Levi.
# This program is distributed under the terms of 
# the GNU General Public License.

%culmusPoints = (
					  "afii57799", "sheva",
					  "afii57801", "hatafsegol",
					  "afii57800", "hatafpatah",
					  "afii57802", "hatafqamats",
					  "afii57793", "hiriq",
					  "afii57794", "tsere",
					  "afii57795", "segol",
					  "afii57798", "patah",
					  "afii57797", "qamats",
					  "afii57806", "holam",
					  "afii57796", "qubuts",
					  "afii57807", "dagesh",
					  "afii57839", "meteg",
					  "afii57841", "rafe",
					  "afii57804", "shindot",
					  "afii57803", "sindot"
					 );

open(AFMIN,  $ARGV[0]) or die "Can't open $ARGV[0], $!";
open(AFMOUT, ">", $ARGV[1]) or die "Can't open $ARGV[1], $!";

while ( <AFMIN>) {
    if(/^(C.+; WX )([0-9]+)( ; N )(\w+)( ;.+;)/) {
	if($culmusPoints{$4} ne "") {
	    print AFMOUT "$1","0","$3$4$5\n";
	}
	else {
	    print AFMOUT $_;
	}
    }
    else {
	print AFMOUT $_;
    }
}

close AFMIN;
close AFMOUT;
