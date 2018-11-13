$train_file = shift;
open (IN,$train_file);
@train = <IN>;

@d = (0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5);
@e = (0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6);

my %H;

for(my $i = 0; $i <scalar(@d); $i++) {
  for(my $j = 0; $j < scalar(@e); $j++){
    $H{$d[$i]}{$e[$j]} = 0;
  }
}

$E = 0;
@error = ([(0)*scalar(@e)],[(0)*scalar(@d)]);

for(my $i=0;$i<scalar(@train);  $i++) {
	$unaligned = $train[$i];
	chomp($unaligned);
	$aligned = $unaligned;
	$aligned =~ s/.unaligned//g;
	print "$aligned\n";
	print "Current set: $i\n";

	for (my $j=0;$j<scalar(@d);$j++) #for delta value
	{
		for (my $k=0;$k<scalar(@e);$k++) # for eta value
		{
			$data=$unaligned; #Let data = unaligned data
				$delta=$d[$j]; #Let delta=d[j]
				$eta=$e[$k];
			 	system("perl hmm2.pl $data $delta $eta >| hmm_alignment");

				$err = `perl alignment_accuracy.pl $aligned hmm_alignment` ;#Get error
				$error[$j][$k] += $err;
				$sum = $error[$j][$k];
				$ave = 1 - $sum/scalar(@train);
				#$H{$d[$j]}{$e[$k]} = $ave;
				print "\n$delta, $eta, $ave\n";
		}
	}
}

for(my $i=0; $i<scalar(@d); $i++){
	for(my $j =0; $j<scalar(@e); $j++){
    $avgAccuracy = $error[$i][$j]/scalar(@train);
    $H{$d[$i]}{$e[$j]} = 1 - $avgAccuracy;
    print $H{$d[$i]}{$e[$j]};
  }
}

print "\nErrors are sorted below:\n";

for my $keypair(
        sort {$H{$b->[0]}{$b->[1]} <=> $H{$a->[0]}{$a->[1]} }
        map { my $intKey=$_; map [$intKey, $_], keys %{$H{$intKey}} } keys %H
    ) {
    printf( "delta={%f} - eta={%f} => %g\n", $keypair->[0], $keypair->[1], $H{$keypair->[0]}{$keypair->[1]} );
}

