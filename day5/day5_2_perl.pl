# perl 5

open my $handle, '<', "data.txt";
my @lines = <$handle>;
close $handle;

$maxwidth = 1000;
$maxheight = 1000;

my @map = (0) x ($maxheight*$maxwidth); 
my $count = 0;

foreach (@lines) {
    my ($x1,$y1,$x2,$y2) = /(\d+),(\d+) -> (\d+),(\d+)/;
    if ($x1==$x2) {
        if ($y1>$y2) {
            ($y1,$y2) = ($y2,$y1);
        }
        for (my $y=$y1;$y<=$y2;$y++) {
            $map[($y*$maxwidth)+$x1]++;
            if ($map[($y*$maxwidth)+$x1]==2) {$count++};
        }
            
    } elsif ($y1==$y2) {
        if ($x1>$x2) {
            ($x1,$x2) = ($x2,$x1);
        }
        for (my $x=$x1;$x<=$x2;$x++) {
            $map[($y1*$maxwidth)+$x]++;
            if ($map[($y1*$maxwidth)+$x]==2) {$count++};
        }

    } else {
        if ($x1>$x2) {
            ($x1,$y1,$x2,$y2) = ($x2,$y2,$x1,$y1);
        }
        my ($ystep) = ($y2-$y1)/($x2-$x1);
        for (my $x=$x1;$x<=$x2;$x++) {
            $map[($y1*$maxwidth)+$x]++;
            if ($map[($y1*$maxwidth)+$x]==2) {$count++};
            $y1+=$ystep;
        }
    }
}

print "$count \n";
