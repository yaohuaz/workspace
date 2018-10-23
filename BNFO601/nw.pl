
$input = shift;
open(IN, $input);

@data = <IN>;
chomp(@data);
$g = shift;
#$e= shift;

$m = 5;
$mm = -4;
sub max{
	my $mx = $_[0];

	for my $e(@_){
		$mx = $e if ($e>$mx);
	}
	return $mx;
}

$seq1 = $data[1]; $seq2 = $data[3];

@V = ();
@T = ();


#initialzation
$V[0][0] = 0;
$T[0][0] = 0;
for(my $i=1; $i < length($seq1)+1; $i++){
  $V[$i][0] = $g * $i;
  $T[$i][0] = 'u';
   }

for(my $i=1; $i < length($seq2)+1; $i++){
  $V[0][$i] = $g * $i;
  $T[0][$i] = 'l';
}


#Recurrence

for(my $i=1; $i <=length($seq1); $i++){
	for(my $j=1; $j <=length($seq2); $j++){
		$ch1 = substr($seq1, $i-1,1);
		$ch2 = substr($seq2, $j-1,1);
		if ($ch1 eq $ch2){
			$d =$V[$i-1][$j-1]+ $m;
		}
		else{$d =$V[$i-1][$j-1]+ $mm;}
    $u = $V[$i-1][$j] + $g;
    $l = $V[$i][$j-1] + $g;

    if ($u >= $d && $u >= $l){
      $V[$i][$j] = $u; $T[$i][$j] = 'u';
    }
    elsif ($l >=$u && $l >=$d){
      $V[$i][$j] = $l; $T[$i][$j] = 'l';
    }
    else{
      $V[$i][$j] = $d; $T[$i][$j] = 'd';
    }
  }
}

#Traceback
$i = length($seq1);
$j = length($seq2);
$aligned_seq1 = "";
$alighed_seq2 = "";
while(!($i == 0 && $j == 0)){
  if ($T[$i][$j] eq 'd'){
    $ch1 = substr($seq1, $i-1, 1);
    $ch2 = substr($seq2, $j-1, 1);
    $i--; $j--;
   }
   elsif($T[$i][$j] eq 'u'){
     $ch1 = substr($seq1, $i-1, 1);
     $ch2 = '-';
     $i--;
   }
   else
   {
     $ch2 = substr($seq2, $j-1, 1);
     $ch1 = '-';
     $j--;
   }
  $aligned_seq1 = $ch1 . $aligned_seq1;
  $aligned_seq2 = $ch2 . $aligned_seq2;
}

print "$data[0]\n";
print "$aligned_seq1\n";
print "$data[2]\n";
print "$aligned_seq2\n";
