#use List::Util qw[min max];

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
#for(my $i = 1; $i <= length($seq1); $i++) {$f[$i][0] = $M[$i][o] + $X[$i][0] + $Y[$i][0];}
#for(my $j = 1; $j <= length($seq2); $j++) {$f[0][$j] = $M[0][$j] + $X[0][$j] + $Y[0][$j];}

for(my $i = 1; $i <= length($seq1); $i++){
        for(my $j = 1; $j <= length($seq2); $j++){
                $ch1 = substr($seq1, $i-1, 1);
                $ch2 = substr($seq2, $j-1, 1);
		$f[$i][0] = $ch1;
		$f[0][$j] = $ch2;
                if($ch1 eq $ch2){$p = $pm;}
                else {$p = $pmm;}
		$m = $p * $MM * $M[$i-1][$j-1];
                $x = $p * $XM * $X[$i-1][$j-1];
                $y = $p * $YM * $Y[$i-1][$j-1];
                $b = $p * $BM * $B[$i-1][$j-1];
		$M[$i][$j] = $m + $x + $y + $b;
		
		$X[$i][$j] = $pgap * ($MX*$M[$i-1][$j] + $XX*$X[$i-1][$j] + $BX*$B[$i-1][$j]);
		$Y[$i][$j] = $pgap * ($MY*$M[$i][$j-1] + $YY*$Y[$i][$j-1] + $BY*$B[$i][$j-1]);
		
		$f[$i][$j] = $M[$i][$j] + $X[$i][$j] + $Y[$i][$j];

		print "Forward Values:\n";
		print "i = $i; j = $j; M = $M[$i][$j]; X = $X[$i][$j]; Y = $Y[$i][$j]; f = $f[$i][$j]\n"; 
	}
}
print "\n";
	
#Backward probability
@Bb = ();
@Xb = ();
@Yb = ();
@Mb = ();
@Tb = ();
@b = ();

$x = length($seq1);
$y = length($seq2);

#Initialization		
$BM = 1 - 2*$delta - $tau; $BX = $BY = $delta; 
$MB = 1 - 2*$delta - $tau; $XB = $YB = $delta;
$MM = 1 - 2*$delta - $tai; $MX = $MY = $delta;
$XX = $eta; $XM = 1 - $eta - $tau; $XY = 0;
$YY = $eta; $YM = 1 - $eta - $tau; $YX = 0;

$Bb[$x][$y] = 1; $Bb[$x][$y-1] = 0; $Bb[$x-1][$y] = 0;
for(my $i = $x-1; $i >=0; $i--){
        for(my $j = $y-1; $j>=0;$j--){
        $Bb[$i][$j] = 0;
        }
}

$Mb[$x][$y] = 0;
for(my $i = $x-1; $i >= 0; $i--){ $Mb[$i][$y] = $b[$i][$y] = 0;}
for(my $j = $y-1; $j >= 0; $j--){ $Mb[$x][$j] = $b[$x][$j] = 0;}

$Xb[$x][$y] = 0;
$Xb[$x-1][$y] = $pgap * $BX * $Bb[$x][$y];
for(my $i = $x-2; $i >= 0; $i--){ $Xb[$i][$y]= $pgap * $XX * $Xb[$i+1][$j];}
for(my $j = $y-1; $j >= 0; $j--){ $Xb[$x][$j]= 0;}

$Yb[$x][$y] = 0;
$Yb[$x][$y-1] = $pgap * $BY * $Bb[$x][$y];
for(my $i = $x-1; $i >= 0; $i--){ $Yb[$i][$y]= 0;}
for(my $j = $y-2; $j >= 0; $j--){ $Yb[$x][$j]= $pgap * $YY * $Yb[$x][$j+1];}

for(my $i=$x; $i >= 0; $i--){$Tb[$i][$y] = 'u';}
for(my $j=$y; $j >= 0; $j--){$Tb[$x][$j] = 'l';}

$b[$x][$y] = 0;

#Recurrence
for(my $i = $x-1; $i >= 0; $i--){
	for(my $j = $y-1; $j >= 0; $j--){
		$ch1 = substr($seq1, $i, 1);
		$ch2 = substr($seq2, $j, 1);
		$b[$i][$y] = $ch1;
		$b[$x][$j] = $ch2;
		if($ch1 eq $ch2) { $p = $pm;}
		else { $p = $pmm;}

		$Mb[$i][$j] = $p * ($MM * $Mb[$i+1][$j+1] + $MX * $Xb[$i+1][$j+1] 
				+ $MY * $Yb[$i+1][$j+1] + $MB * $Bb [$i+1][$j+1]);
		$Xb[$i][$j] = $pgap * ($XM * $Mb[$i+1][$j] + $XX * $Xb[$i+1][$j] + $XB * $Bb[$i+1][$j]);  
		$Yb[$i][$j] = $pgap * ($YM * $Mb[$i][$j+1] + $YY * $Yb[$i][$j+1] + $YB * $Bb[$i][$j+1]);  
		
		$b[$i][$j] = $Mb[$i][$j] + $Xb[$i][$j] + $Yb[$i][$j];

		print "Backward Values:\n";
		print "i = $i; j = $j; Mb = $Mb[$i][$j]; Xb = $Xb[$i][$j]; Yb = $Yb[$i][$j]; b = $b[$i][$j]\n"; 
	}
}


#Posterior probability
@p = ();
for(my $i = 1; $i <= length($seq1); $i++){
	for(my $j =1; $j <= length($seq2); $j++){
		$p[$i][$j] = $f[$i][$j] * $b[$i-1][$j-1] / $f[$x][$y];
	print "p = $p[$i][$j]\n";
	}
}


print "Matrix f is: \n";

for(my $i=0; $i<=length($seq1); $i++){
	for(my $j=0; $j<=length($seq2); $j++){
		print "$f[$i][$j]  ";
	}
	print "\n";
}
print "\n";

print "Matrix b is: \n";

for(my $i=$x; $i>=0; $i--){
	for(my $j=$y; $j>=0; $j--){
		print "$b[$i][$j]  ";
	}
	print "\n";
}
print "\n";

print "Matrix p is: \n";
for(my $i=1; $i<=length($seq1); $i++){
	for(my $j=1; $j<=length($seq2); $j++){
		print "$p[$i][$j]  ";
	}
}
print "\n";


