open(IN, shift);
@dogFull = <IN>;
chomp(@dogFull);

open(IN, shift);
@ratFull = <IN>;
chomp(@ratFull);

my @dogA = @dogFull[1 .. 5000];
my @ratA = @ratFull[1 .. 7000];
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
    $subchar = substr($sub, $j, 1);
    if (substr($seed, $j, 1) eq '1' && $subchar eq uc $subchar){
      $key = $key . $subchar;
    }
  }
#      print "$key\n";
    if ($key eq '' || exists $d{$key}){}
    else{$d{$key} = $i;print "$key\n";
#      print "$key   $i\n";
      $count++;
  }
}

###Rat hash
$count2 = 0;
for (my $i = 0; $i < ($lrat - $ls + 1); $i++){
  $key2 = "";
  for (my $j = 0; $j < $ls; $j++){
    $sub2 = substr($rat, $i, $ls);
    $subchar2 = substr($sub2, $j, 1);
    if (substr($seed, $j, 1) eq '1' && $subchar2 eq uc $subchar2){
      $key2 = $key2 . $subchar2;
    }
  }
  if ($key2 eq '' || exists $r{$key2}){}
  else{$r{$key2} = $i; print "$key2\n";
    $count2++;
  }
}
#print "rat length: $lrat\n";
#print "rat key count: $count2\n";

###hit check
$hit = 0;
#open(my $line, $line2, '>', 'dog-rat.maf');
print "##maf version = 1\n\na score = 0.00000\n";
foreach $k (keys %r){
  if (exists $d{$k}){
    $strdog = substr($dog, $d{$k}, $ls);
    #$strrat = substr($rat, $r{$k}, $ls);
    $lk = length($k);
    $line = "s simDog.chrA $d{$k} $lk + $ldog $strdog \n";
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
    $lk = length($lk);
    $line2 = "s simRat.chrQ $r{$k} $lk + $lrat $strrat \n";
    print "$line2";
  }
}
print "hit count: $hit\n";
