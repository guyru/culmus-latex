#!/usr/bin/perl

# Copyright 2004 Itai Levi.
# This program is distributed under the terms of 
# the GNU General Public License.

@points = (
	   "sheva",
	   "hatafsegol",
	   "hatafpatah",
	   "hatafqamats",
	   "hiriq",
	   "tsere",
	   "segol",
	   "patah",
	   "qamats",
	   "holam",
	   "qubuts",
	   "dagesh",
	   "meteg",
	   "rafe",
	   "shindot",
	   "sindot"
	   );


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

%culmusLettersWithPoints = (
			    "afii57664", "alef",
			    "afii57665", "bet",
			    "afii57666", "gimel",
			    "afii57667", "dalet",
			    "afii57668", "he",
			    "afii57669", "vav",
			    "afii57670", "zayin",
			    "afii57671", "het",
			    "afii57672", "tet",
			    "afii57673", "yod",
			    "afii57674", "kaf final",
			    "afii57675", "kaf",
			    "afii57676", "lamed",
			    "afii57677", "mem final",
			    "afii57678", "mem",
			    "afii57679", "nun final",
			    "afii57680", "nun",
			    "afii57681", "samekh",
			    "afii57682", "ayin",
			    "uniFB20", "alternative ayin",
			    "afii57683", "pe final",
			    "afii57684", "pe",
			    "afii57685", "tsadi fial",
			    "afii57686", "tsadi",
			    "afii57687", "kof",
			    "afii57688", "resh",
			    "afii57689", "shin",
			    "afii57690", "tav",
			    "uniFB30", "alef with dagesh",
			    "uniFB31", "bet with dagesh",
			    "uniFB32", "gimel with dagesh",
			    "uniFB33", "dalet with dagesh",
			    "uniFB34", "he with dagesh",
			    "afii57723", "vav with dagesh",
			    "uniFB36", "zayin with dagesh",
			    "uniFB38", "tet with dagesh",
			    "uniFB39", "yod with dagesh",
			    "uniFB3A", "kaf final with dagesh",
			    "uniFB3B", "kaf with dagesh",
			    "uniFB3C", "lamed with dagesh",
			    "uniFB3E", "mem with dagesh",
			    "uniFB40", "nun with dagesh",
			    "uniFB41", "samekh with dagesh",
			    "uniFB43", "pe final with dagesh",
			    "uniFB44", "pe with dagesh",
			    "uniFB46", "tsadi with dagesh",
			    "uniFB47", "kof with dagesh",
			    "uniFB48", "resh with dagesh",
			    "uniFB49", "shin with dagesh",
			    "uniFB4A", "tav with dagesh",
			    );

%sameAs = (
	   "uniFB30", "afii57664",
	   "uniFB31", "afii57665",
	   "uniFB32", "afii57666",
	   "uniFB33", "afii57667",
	   "uniFB34", "afii57668",
	   "afii57723", "afii57669",
	   "uniFB36", "afii57670",
	   "uniFB38", "afii57672",
	   "uniFB39", "afii57673",
	   "uniFB3A", "afii57674",
	   "uniFB3B", "afii57675",
	   "uniFB3C", "afii57676",
	   "uniFB3E", "afii57678",
	   "uniFB40", "afii57680",
	   "uniFB41", "afii57681",
	   "uniFB43", "afii57683",
	   "uniFB44", "afii57684",
	   "uniFB46", "afii57686",
	   "uniFB47", "afii57687",
	   "uniFB48", "afii57688",
	   "uniFB49", "afii57689",
	   "uniFB4A", "afii57690",
	   );

sub processArgs {
    while ($arg = shift @ARGV) {
	if ($arg =~ /-s/) {
	    $specialCasesFile = shift @ARGV;
	} elsif ($arg =~ /-o/) {
	    $outputFile = shift @ARGV;
	} else {
	    $inputAfmFile = $arg;
	}
    }
}

sub processSpecialCasesFile {
    open(SPECIAL_CASES_FILE,  $specialCasesFile) or die "Can't open $ARGV[0], $!";
    while ( <SPECIAL_CASES_FILE>) {
	if (/^(\w+)\s+(\w+)\s+(C|L)\s+(-?\d+)\s+(-?\d+)/) {
	    $specials[$#specials + 1] = [$1, $2, $3, $4, $5];
	} elsif (/^(\w+)\s+(C|L)\s+(-?\d+)\s+(-?\d+)/) {
	    $specials[$#specials + 1] = [$1, "", $2, $3, $4];
	}
    }
    close(SPECIAL_CASES_FILE);
}

sub calculatePointPlace {
    my $theLetter = @_[0];
    my $thePoint = @_[1];

    #check if the letter is in the .special file
    my $letterIsInSpecialFile = 0;
    foreach (@specials) {
	if ($_->[0] eq $theLetter) {
	    $letterIsInSpecialFile = 1;
	}
    }

    if ($sameAs{$theLetter} ne "" && $letterIsInSpecialFile == 0) {
	$theLetter = $sameAs{$theLetter};
    }
    my $theLetterWidth = $charWidth{$theLetter};
    my $thePointWidth = $charWidth{$thePoint};
    #start with centered glyph
    $yPlacement = 0;
    $xPlacement = ($theLetterWidth - $thePointWidth) / 2000;
    #go over the specials array
    #first, look for letters with no point
    foreach (@specials) {
	if ($_->[0] eq $theLetter && $_->[1] eq "") {
	    $yPlacement = $_->[4] / 1000;
	    $xPlacement = $_->[3] / 1000;
	    if ($_->[2] eq "C") {
		$xPlacement += (($theLetterWidth - $thePointWidth) / 2000);
	    }
	}
    }
    #second, look for point with no letters
    foreach (@specials) {
	if ($_->[0] eq $thePoint && $_->[1] eq "") {
	    $yPlacement = $_->[4] / 1000;
	    $xPlacement = $_->[3] / 1000;
	    if ($_->[2] eq "C") {
		$xPlacement += (($theLetterWidth - $thePointWidth) / 2000);
	    }
	}
    }
    #third, look for letter with point
    foreach (@specials) {
	if ($_->[0] eq $theLetter && $_->[1] eq $thePoint) {
	    $yPlacement = $_->[4] / 1000;
	    $xPlacement = $_->[3] / 1000;
	    if ($_->[2] eq "C") {
		$xPlacement += (($theLetterWidth - $thePointWidth) / 2000);
	    }
	}
    }
}


#begining of program


processArgs();

if ($outputFile ne "") {
    open(OUTPUT_FILE, ">$outputFile") or die "Can't open $ARGV[0], $!";
    select OUTPUT_FILE;
}

if ($specialCasesFile ne "") {
    processSpecialCasesFile();
}


open(AFMFILE,  $inputAfmFile)   or die "Can't open $ARGV[0], $!";

$charIndex = 0;
while (<AFMFILE>) {
    if (/ItalicAngle\s*(.*)/) {
	$italicAngle = $1;
    }
    if (/IsFixedPitch\s*(false|true)/) {
	$isFixedPitch = $1;
    }
    if (/UnderlinePosition\s*(.*)/) {
	$underlinePosition = $1;
    }
    if (/UnderlineThickness\s*(.*)/) {
	$underlineThickness = $1;
    }
    if (/FontName\s*(.*)/) {
	$originalFontName = $1;
	$baseFontName = $1 . "-Menukad";
    }
    if (/C\s*(\d*|-1)\s*;\s*WX\s*(\d*)\s*;\s*N\s*(\w*)/) {
	if ($1 ne -1) {
	    $encoding[$1] = $3;
	}
	$chars[$charIndex] = $3;
	$charIndex++;
	$charWidth{$3} = $2;
    }
}

close AFMFILE;

#start building the t3 file

print "%!PS\n";
print "%\n";
print "% This file was automaticaly generated by culmusafm2t3menukad.pl\n";
print "% Please dot not edit this file!\n";
print "% Instead, edit the relevant .special file.\n";
print "% This file is distributed under the terms of\n"; 
print "% the GNU General Public License.\n";
print "%\n";
print "20 dict begin\n";
print "/FontInfo 7 dict dup begin\n";
print "  /ItalicAngle $italicAngle def\n";
print "  /isFixedPitch $isFixedPitch def\n";
print "  /UnderlinePosition $underlinePosition def\n";
print "  /UnderlineThickness $underlineThickness def\n";
print "  /BaseFontName ($baseFontName) def\n";
print "  end readonly def\n";
print "/FontName /$baseFontName def\n";
print "/FontType 3 def\n";
print "/PaintType 0 def\n";
print "/FontBBox { 0 0 0 0 } readonly def\n";
print "/FontMatrix [ 1 0 0 1 0 0 ] readonly def\n";
print "/StrokeWidth 0 def\n";
print "/Encoding 256 array def\n";
print "0 1 255 {Encoding exch /.notdef put} for\n";

$index = 0;
foreach (@encoding) {
    if ($_ ne "") {
	print "Encoding $index /$_ put\n";
    }
    $index++;
}

print "Encoding 0 /.notdef put\n";

print "/CharStrings 300 dict def\n";
print "CharStrings begin\n";

foreach (@points) {
    print "/$_","_flag false def\n";
}

foreach (@points) {
    print "/draw$_ {moveto dup /$_","_flag get exch dup /$_","_flag false put exch\n";
    print "{dup /$_","_glyph get exec} if} bind def\n";
}

foreach (keys %culmusPoints) {
    print "/$_ { 0 0 setcharwidth /$culmusPoints{$_}_flag true put } bind def\n";
}

print "/.notdef {0 0 setcharwidth} bind def\n";

foreach (@chars) {
    $letter = $_;
    if ($culmusPoints{$_} eq "") {
	$letterWith1000 = $charWidth{$_} / 1000;
	print "/$_ {\n   $letterWith1000 0 setcharwidth\n";
	if ($_ ne "space") {
	    print "   0 0 moveto\n   /$originalFontName findfont 1 scalefont setfont /$_ glyphshow\n";
	}
	if ($culmusLettersWithPoints{$_} ne "") {
	    $letterWidth = $charWidth{$_};
	    $letterName = $culmusLettersWithPoints{$_};
	    print "   % $letterName\n";
	    #need points - go over all culmusPoints hash keys
	    foreach (keys %culmusPoints) {
		$putPoint = 1;
		# don't put dagesh on letters with dagesh:
		if (($_ eq "afii57807") and ($letterName =~ /.*dagesh/)) {
		    $putPoint = 0;
		}
		if ($putPoint == 1) {
		    calculatePointPlace($letter, $_);
		    print "   dup $xPlacement $yPlacement 4 -1 roll /draw$culmusPoints{$_} get exec\n";
		}
	    }
	}
	print "} bind def\n";
    }
}


foreach (keys %culmusPoints) {
    print "/$culmusPoints{$_}_glyph {/$originalFontName findfont 1 scalefont setfont /$_ glyphshow} bind def\n";
}

print "end\n";

print "/BuildGlyph {\n";
print "  mark 3 1 roll\n";
print "  exch /CharStrings get\n";
print "  dup\n";
print "  3 -1 roll\n";
print "  2 copy known not {pop /.notdef} if\n";
print "  get exec\n";
print "  cleartomark\n";
print "} bind def\n";
print "\n";
print "/BuildChar {\n";
print "  1 index /Encoding get exch get\n";
print "  1 index /BuildGlyph get exec\n";
print "} bind def\n";

print "currentdict end\n";
print "/$baseFontName exch definefont pop\n";

close OUTPUT_FILE;
