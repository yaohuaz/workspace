open(IN, 'dogA.fa.txt');
@dogFull = <IN>;
chomp(@dogFull);

open(IN, 'ratQ.fa.txt');
@ratFull = <IN>;
chomp(@ratFull);

my @dogA = @dogFull[0 .. 5000];
my @ratA = @ratFull[0 .. 7000];
###Section out dog and rat
$dog ="";
for (my $i=0; $i<scalar(@dogA); $i++){
  $dog = $dog . $dogA[$i];
  #print "$dog";
}

$rat ="";
for (my $i=0; $i<scalar(@ratA); $i++){
  $rat = $rat . $ratA[$i];
  #print "$rat";
}

%d;
%r;

$seed = '111111111111111111111111111';
$ls = length($seed);
$ldog = length($dog);
$lrat = length($rat);

###Dog hash
$count = 0;
for (my $i = 0; $i < ($ldog - $ls + 1); $i++){
  $key = "";
  for (my $j = 0; $j < $ls; $j++){
    $sub = substr($dog, $i, $ls);
    #print $sub;
    if (substr($seed, $j, 1) eq '1'){
      $key = $key . substr($sub, $j, 1);
    }
  }
#      print "$key\n";
    if (exists $d{$key}){}
    else{$d{$key} = $i;
#      print "$key   $i\n";
      $count++;
  }
}
#print "dog length: $ldog\n";
#print "dog key count: $count\n";


#my $maf = 'dog-rat.maf';
#open FILE, $maf;
#print "$rat\n";
###Rat hash
$count2 = 0;
for (my $i = 0; $i < ($lrat - $ls + 1); $i++){
  $key2 = "";
  for (my $j = 0; $j < $ls; $j++){
    $sub2 = substr($rat, $i, $ls);
    if (substr($seed, $j, 1) eq '1'){
      $key2 = $key2 . substr($sub2, $j, 1);
    }
  }
  if (exists $r{$key2}){}
  else{$r{$key2} = $i;
    $count2++;
  }
}
#print "rat length: $lrat\n";
#print "rat key count: $count2\n";


=pod
if (exists $d{$key2}){
  $strdog = substr($dog, $d{$key2}, $ls);
  $strrat = substr($rat, $i, $ls);
  #print "$strdog\n";
  #print "$strrat\n";
  $match++;
  $line = "s simDog.chrA  $d{$key2} $ls + $ldog $strdog \n";
  $line2 = "s simRat.chrQ $i $ls + $lrat $strat\n\n";
  print "$line";
  print "$line2";
}
=cut
###hit check
$hit = 0;
#open(my $line, $line2, '>', 'dog-rat.maf');
print "##maf version = 1\n\na score = 0.00000\n";
foreach $k (keys %r){
  if (exists $d{$k}){
    $strdog = substr($dog, $d{$k}, $ls);
    #$strrat = substr($rat, $r{$k}, $ls);
    $line = "s simDog.chrA $d{$k} $ls + $ldog $strdog \n";
    #$line2 = "s simRat.chrQ $r{$k} $ls + $lrat $strrat \n";
    #print "\na score = 0.00000\n";
    print "$line";
    print "$line2";
    $hit++;
  }
}
print "\na score = 0.00000\n";
foreach $k (keys %r){
  if (exists $d{$k}){
    $strrat = substr($rat, $r{$k}, $ls);
    $line2 = "s simRat.chrQ $r{$k} $ls + $lrat $strrat \n";
    print "$line2";
  }
}
#print "hit count: $hit\n";
