open(IN, "BLOSUM_62.txt");
@blos= <IN>;
chomp(@blos);

my %H;

@array = split(/\s+/, $blos[0]);

for($i = 1; $i <scalar(@blos); $i++) {
  @row = $data[$i];
  @row = split(/\s+/, $blos[$i]);
  for( $j = 1; $j < scalar(@row); $j++){
    print "$row2[$j]\t\n";
    $H{$row[0]}{$array[$j]} = $row[$j];
  }
}

for my $keypair(
	sort {$H{$b->[0]}{$b->[1]} <=> $H{$a->[0]}{$a->[1]} }
        map { my $intKey=$_; map [$intKey, $_], keys %{$H{$intKey}} } keys %H
    ) {
    printf( "{%s} - {%s} => %d\n", $keypair->[0], $keypair->[1], $H{$keypair->[0]}{$keypair->[1]} );
}

