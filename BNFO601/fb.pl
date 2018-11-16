use List::Util qw[min max];

open(IN, shift); @data = <IN>; close(IN); chomp(@data);

$seq1 = $data[1]; $seq2 = $data[3];

$delta = 0.2; $eta = 0.4; $tau = 0;
$pm = 0.6; $pmm = 0.4; $pgap = 1;

$BM = 1-2*$delta - $tau; $BX = $delta; $BY = $delta;
$MM = 1-2*$delta - $tau; $MX = $delta; $MY = $delta;
$XX = $eta; $XM = 1 -$eta - $tau; $XY = 0;
$YY = $eta; $YM = 1 -$eta - $tau; $YX = 0;

#Forward probability
@f = ();
$f[0][0] = 0;
 
#initialization
@B = ();
@M = ();
@X = ();
@Y = ();
@T = ();

$B[0][0] = 1; $B[1][0] = 0; $B[0][1] = 0;
for(my $i = 1; $i<=length($seq1); $i++){
        for(my $j = 1; $j<=length($seq2);$j++){
        $B[$i][$j] = 0;
        }
}

$M[0][0] = 0;
for(my $i = 1; $i <= length($seq1); $i++){ $M[$i][0] = 0;}
for(my $j = 1; $j <= length($seq2); $j++){ $M[0][$j] = 0;}

$X[0][0] = 0;
$X[1][0] = $pgap * $BX * $B[0][0];
for(my $i = 2; $i <= length($seq1); $i++){ $X[$i][0]= $pgap * $XX * $X[$i-1][0];}
for(my $j = 1; $j <= length($seq2); $j++){ $X[0][$j]= 0;}

$Y[0][0] = 0;
$Y[0][1] = $pgap * $BY * $B[0][0];
for(my $i = 1; $i <= length($seq1); $i++){ $Y[$i][0]= 0;}
for(my $j = 2; $j <= length($seq2); $j++){ $Y[0][$j]= $pgap * $YY * $Y[0][$j-1];}

for(my $i=1; $i<length($seq1); $i++){$T[$i][0] = 'u';}
for(my $j=1; $j<length($seq2); $j++){$T[0][$j] = 'l';}


#Recurrence
for(my $i = 1; $i <= length($seq1); $i++) {$f[$i][0] = $M[$i][o] + $X[$i][0] + $Y[$i][0];}
for(my $j = 1; $j <= length($seq2); $j++) {$f[0][$j] = $M[0][$j] + $X[0][$j] + $Y[0][$j];}

for(my $i = 1; $i <= length($seq1); $i++){
        for(my $j = 1; $j <= length($seq2); $j++){
                $ch1 = substr($seq1, $i-1, 1);
                $ch2 = substr($seq2, $j-1, 1);
                if($ch1 eq $ch2){$p = $pm;}
                else {$p = $pmm;}
		$m = $p * $MM * $M[$i-1][$j-1];
                $x = $p * $XM * $X[$i-1][$j-1];
                $y = $p * $YM * $Y[$i-1][$j-1];
                $b = $p * $BM * $B[$i-1][$j-1];
		$M[$i][$j] = $m + $x + $y + $b;
		
		$X[$i][$j] = $pgap * ($MX*$M[$i-1][$j] + $XX*$X[$i-1][$j] + $BX*$B[$i-1][$j];
		$Y[$i][$j] = $pgap * ($MY*$M[$i][$j-1] + $YY*$Y[$i][$j-1] + $BY*$B[$i][$j-1];
		
		$f[$i][$j] = $M[$i][$j] + $X[$i][$j] + $Y[$i][$j];
	}
}

	
#Backward probability
@Bb = ();
@Xb = ();
@Yb = ();
@Mb = ();

$x = length($seq1);
$y = length($seq2);

		
$Bb[$x][$y] = 1; $B[$x][$y-1] = 0; $B[$x-1][$y] = 0;
for(my $i = $x-1; $i >=0; $i--){
        for(my $j = $y-1; $j>=0;$j--){
        $Bb[$i][$j] = 0;
        }
}

$Mb[$x][$y] = 0;
for(my $i = $x-1; $i >= 0; $i--){ $M[$i][$y] = 0;}
for(my $j = $y-1; $j >= 0; $j--){ $M[$x][$j] = 0;}

$Xb[$x][$y] = 0;
$Xb[$x-1][$y] = $pgap * $BX * $B[$x][$y];
for(my $i = $x-2; $i >= 0; $i--){ $X[$i][$y]= $pgap * $XX * $X[$i+1][$j];}
for(my $j = $y-1; $j >= 0; $j--){ $X[$x][$j]= 0;}

$Y[$x][$y] = 0;
$Y[$x][$y-1] = $pgap * $BY * $B[$x][$y];
for(my $i = $x-1; $i >= 0; $i--){ $Y[$i][$y]= 0;}
for(my $j = $y-2; $j >= 0; $j--){ $Y[$x][$j]= $pgap * $YY * $Y[$x][$j+1];}

for(my $i=$x; $i >= 0; $i--){$T[$i][$y] = 'u';}
for(my $j=$y; $j >= 0; $j--){$T[$x][$j] = 'l';}

