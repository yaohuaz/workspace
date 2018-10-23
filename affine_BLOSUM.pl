
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
$e= shift;

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
@E = ();
@F = ();
@M = ();

$V[0][0] = $M [0][0] = 0;
$E[0][0] = $F [0][0] = -inf;


#initialzation
for(my $i=1; $i < length($seq1)+1; $i++){
  $V[$i][0] = $g+($i-1)*$e;
  $T[$i][0] = 'u';
  $M[$i][0] = -inf;
  $E[$i][0] = -inf;
  $F[$i][0] = $g+($i-1)*$e;
   }

for(my $i=1; $i < length($seq2)+1; $i++){
  $V[0][$i] = $g+($i-1)*$e;
  $T[0][$i] = 'l';
  $M[0][$i] = -inf;
  $F[0][$i] = -inf; $E[0][$i] = $g+($i-1)*$e;
}

$V[0][0] = $M [0][0] = $V[0][0] = $M [0][0] = 0;
$E[0][0] = $F [0][0] = -inf;

#Recurrence

for(my $i=1; $i <=length($seq1); $i++){
	for(my $j=1; $j <=length($seq2); $j++){
		$ch1 = substr($seq1, $i-1,1);
		$ch2 = substr($seq2, $j-1,1);
		if ($ch1 eq $ch2){
			$M[$i][$j]=$V[$i-1][$j-1]+$H{$ch1}{$ch2};
		}
		else{$M[$i][$j]=$V[$i-1][$j-1]+$H{$ch1}{$ch2};}
		$F[$i][$j] =max($M[$i-1][$j]+$g,$F[$i-1][$j]+$e);
		$E[$i][$j] =max($M[$i][$j-1]+$g,$E[$i][$j-1]+$e);
		$V[$i][$j] = max($E[$i][$j],$F[$i][$j], $M[$i][$j]);
#Traceback
	if ( $V[$i][$j]==$F[$i][$j]){ $T[$i][$j] ='u';}
		elsif ( $V[$i][$j]==$E[$i][$j]){
			$T[$i][$j] ='l';}
		else {
			$T[$i][$j] ='d';}
	}
}

# print("Output \n\n");

for(my $i=0; $i <= length($seq1);$i++){
    for(my $j=0; $j <= length ($seq2);$j++){
  # print($V[$i][$j] . " ");
  }
 # print("\n");
}

for(my $i=0; $i<=length($seq1);$i++){
    for(my $j=0; $j<=length ($seq2);$j++){
  # print($T[$i][$j] . " ");
  }
 # print("\n");
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
