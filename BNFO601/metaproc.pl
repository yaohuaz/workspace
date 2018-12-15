open(IN, shift);
@dogFull = <IN>;
chomp(@dogFull);

open(IN, shift);
@ratFull = <IN>;
chomp(@ratFull);

$ld = scalar(@dogFull);
$lr = scalar(@ratFull);
#@dogUseful = @dogFull[1 .. scalar(@dogFull)-1];
#@ratUseful = @ratFull[1 .. scalar(@ratFull)-1];
for (my $i = 0; $i < 10; $i++){
    $posD = int($ld/10) * $i;
    $podR = int($lr/10) * $i;
    $posDp = int($ld/10) * ($i+1);
    $podRp = int($lr/10) * ($i+1);
    $posD = scalar(@dogUseful)/10 * $i;
    $podR = scalar(@ratUseful)/10 * $i;
    $posDp = scalar(@dogUseful)/10 * ($i+1);
    $podRp = scalar(@ratUseful)/10 * ($i+1);

    print "$posD, $posDp, $posR, $posRp\n";
=pod
    @dogA = @dogFull[$posD .. $posDp];
    @ratA = @ratFull[$posR .. $posRp];
    #print "@dogA\n";
    #print "@ratA\n";
    ###Section out dog and rat
    $dog ="";
    for (my $i=0; $i<scalar(@dogA); $i++){
      $dog = $dog . $dogA[$i];
      #print "$dog\n";
    }

    $rat ="";
    for (my $i=0; $i<scalar(@ratA); $i++){
      $rat = $rat . $ratA[$i];
      #print "$rat\n";
    }
    #system("perl meta.pl $dog $rat >| $i.maf");
=cut
}
