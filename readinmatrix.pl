open(IN, "BLOSUM_62.txt");
@blos= <IN>;
chomp(@blos);
#chomp(@data);
#print "@data\n";

my %M;

@array = split(/\s+/, $blos[0]);

for($i = 1; $i <scalar(@blos); $i++) {
  #@row = $data[$i];
  @row = split(/\s+/, $blos[$i]);
  for( $j = 1; $j < scalar(@row); $j++){
    #print "$row2[$j]\t\n";
    $M{$row[0]}{$array[$j]} = $row[$j];
  }
}

@KEY = keys(%M);

for($i = 0; $i<scalar(@KEY); $i++){
  for($j = 1; $j <23; $j++){
    $val = $M{$KEY[$i]}{$array[$j]};
    print "$val ";
  }
  print "\n";
}

print "here: $M{'S'}{'M'}";
