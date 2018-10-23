
open(IN, "BLOSUM_62.txt");
@blos= <IN>;
chomp(@blos);

my %H;

@array = split(/\s+/, $blos[0]);

for($i = 1; $i <scalar(@blos); $i++) {
  #@row = $data[$i];
  @row = split(/\s+/, $blos[$i]);
  for( $j = 1; $j < scalar(@row); $j++){
    #print "$row2[$j]\t\n";
    $H{$row[0]}{$array[$j]} = $row[$j];
  }
}

@KEY = keys(%M);


$input = shift;
open(IN, $input);

@data = <IN>;
chomp(@data);
$g = shift;
#$e= shift;

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
  $V[$i][0] = $g *$i;#+($i-1)*$e;
  $T[$i][0] = 'u';

   }

for(my $i=1; $i < length($seq2)+1; $i++){
  $V[0][$i] = $g * $i;#+($i-1)*$e;
  $T[0][$i] = 'l';
}


#Recurrence

for(my $i=1; $i <=length($seq1); $i++){
	for(my $j=1; $j <=length($seq2); $j++){
		$ch1 = substr($seq1, $i-1,1);
		$ch2 = substr($seq2, $j-1,1);
		if ($ch1 eq $ch2){
			$d =$V[$i-1][$j-1]+$H{$ch1}{$ch2};
		}
		else{$d =$V[$i-1][$j-1]+$H{$ch1}{$ch2};}
    $u = $V[$i-1][$j] + $g;
    $l = $V[$i][$j-1] + $g;

    if ($u >=$d && $u >=$l){
      $V[$i][$j] = $u; $T[$i][$j] = 'u';
    }
    elsif ($l >=$d && $l >=$u){
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
   else#if($T[$i][$j] eq '1')
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
