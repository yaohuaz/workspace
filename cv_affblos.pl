$train_file = "training.txt";
open (IN,$train_file);
@train = <IN>;

@go= (-16, -14, -12,-10,-8,-6,-4,-2);
@ge = (-1,-2,-.5,-.1);

$E = 0;
my @error = ([(0)*scalar(@ge)],[(0)*scalar(@go)]);

for(my $i=0;$i<scalar(@train);  $i++) {
	$unaligned = $train[$i];
	chomp($unaligned);
	$aligned = $unaligned;
	$aligned =~ s/.unaligned//g;
	print "Current set: $i\n";

	for (my $j=0;$j<scalar(@go);$j++) #for go value
	{
		for (my $k=0;$k<scalar(@ge);$k++) # for ge value
		{
			$data=$unaligned; #Let data = unaligned data
				$g=$go[$j]; #Let g=go[j]
				$e=$ge[$k];
			system("perl affine_BLOSUM.pl $data $g $e >| afblo_alignment"); #call NW(g).pl on
				$err = `perl alignment_accuracy.pl $aligned afblo_alignment` ;#Get error
				$error[$j][$k] += $err;
		}
	}
#print error for different gaps
}


#print "Error: $E\n";

my $maxG = $go[0];
my $maxE = $ge[0];
my $maxAccuracy = 0;

for(my $i=0; $i<scalar(@go); $i++){
	for(my $j =0; $j<scalar(@ge); $j++){
	print "here: $i, $j\n";

		my $avgAccuracy = $error[$i][$j]/scalar(@train);
		if($maxAccuracy < $avgAccuracy)
		{
			$maxAccuracy = $avgAccuracy;
			$maxG = $go[$i];
			$maxE = $ge[$j];
		}
		print "$avgError ";
	}
	$minError = 1 - $maxAccuracy;
	print "\n";
        #$error{$keys[$i]} = $error{$keys [$i]}/scalar(@train);
	#print "@keys[$i] $error{$keys[$i]}\n";

}

print "The minimum error is: $minError, $maxG,  $maxE\n";
