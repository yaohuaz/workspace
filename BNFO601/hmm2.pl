use List::Util qw[min max];

open(IN, shift);
@data = <IN>;
close(IN);
chomp(@data);

$seq1= $data[1];
$seq2 = $data[3];
$delta = shift; $eta = shift;

=pod
sub max{
        my $mx = $_[0];
        for my $e(@_){
                $mx = $e if ($e > $mx);
                }
        return $mx;
}
=cut

@B = ();
@M = ();
@X = ();
@Y = ();

#transition probability
$BX = $delta; $BY = $delta; $BM = 1-2*$delta;
$MX = $delta; $MY = $delta; $MM = 1-2*$delta;
$XX = $eta; $XY = 0; $XM = 1-$eta;
$YY = $eta; $YX = 0; $YM = 1-$eta;

#Emission probability
$pgap = 1; $pm = 0.6; $pmm = 0.4;

#Initialize B
$B[0][0] = 1; $B[1][0] = 0; $B[0][1] = 0;
for(my $i = 1; $i<=length($seq1); $i++){
        for(my $j = 1; $j<=length($seq2);$j++){
        $B[$i][$j] = 0;
        }
}

#Initialize M
$M[0][0] = 0;
for(my $i = 1; $i <= length($seq1); $i++){ $M[$i][0] = 0;}
for(my $j = 1; $j <= length($seq2); $j++){ $M[0][$j] = 0;}

#Initialize X
$X[0][0] = 0;
$X[1][0] = $pgap * $BX * $B[0][0];
for(my $i = 2; $i <= length($seq1); $i++){ $X[$i][0]= $pgap * $XX * $X[$i-1][0];}
for(my $j = 1; $j <= length($seq2); $j++){ $X[0][$j]= 0;}

#Initialize Y
$Y[0][0] = 0;
$Y[0][1] = $pgap * $BY * $B[0][0];
for(my $i = 1; $i <= length($seq1); $i++){ $Y[$i][0]= 0;}
for(my $j = 2; $j <= length($seq2); $j++){ $Y[0][$j]= $pgap * $YY * $Y[0][$j-1];}

#Initialize T
for(my $i=1; $i<length($seq1); $i++){$T[$i][0] = 'u';}
for(my $j=1; $j<length($seq2); $j++){$T[0][$j] = 'l';}


#Recurrence

for(my $i = 1; $i <= length($seq1); $i++){
        for(my $j = 1; $j <= length($seq2); $j++){
                $ch1 = substr($seq1, $i-1, 1);
                $ch2 = substr($seq2, $j-1, 1);
                if($ch1 eq $ch2){$p = $pm;}
                else {$p = $pmm;}
                @maxM = ();
                @maxX = ();
                @maxY = ();
                $m = $p * $MM * $M[$i-1][$j-1];
                $x = $p * $XM * $X[$i-1][$j-1];
                $y = $p * $YM * $Y[$i-1][$j-1];
                $b = $p * $BM * $B[$i-1][$j-1];
                @maxM= ($m, $x, $y, $b);
                $M[$i][$j]=max(@maxM);
                @maxY = ($pgap * $MY * $M[$i][$j-1], $pgap * $BY * $B[$i][$j-1], $pgap * $YY * $Y[$i][$j-1]);
                $Y[$i][$j]=max(@maxY);
                @maxX = ($pgap * $MX * $M[$i-1][$j], $pgap * $XX * $X[$i-1][$j], $pgap * $BX * $B[$i-1][$j]);
                $X[$i][$j]=max(@maxX); 

                if( $Y[$i][$j] >= $X[$i][$j] && $Y[$i][$j] >= $M[$i][$j]) {$T[$i][$j] = 'l';}
                elsif($X[$i][$j] >= $M[$i][$j] && $X[$i][$j] >= $Y[$i][$j]) {$T[$i][$j] = 'u';}
                elsif($M[$i][$j] >= $Y[$i][$j] && $M[$i][$j] >= $X[$i][$j]) {$T[$i][$j] = 'd';}

        }
}

#Traceback
$i = length($seq1);
$j = length($seq2);
$aligned_seq1 = "";
$alighed_seq2 = "";
while(!($i == 0 && $j == 0)){
  if ($T[$i][$j] eq 'l'){
     $ch2 = substr($seq2, $j-1, 1);
     $ch1 = '-';
     $j--;
   }
   elsif($T[$i][$j] eq 'u'){
     $ch1 = substr($seq1, $i-1, 1);
     $ch2 = '-';
     $i--;
   }
   else#if($T[$i][$j] eq 'd')
   {
    $ch1 = substr($seq1, $i-1, 1);
    $ch2 = substr($seq2, $j-1, 1);
    $i--; $j--;
   }
  $aligned_seq1 = $ch1 . $aligned_seq1;
  $aligned_seq2 = $ch2 . $aligned_seq2;
}

print "$data[0]\n";
print "$aligned_seq1\n";
print "$data[2]\n";
print "$aligned_seq2\n";
