
open(IN, shift);
@dogF = <IN>;
chomp(@dogF);
$dogFull = join '',@dogF;

open(IN, shift);
@ratF = <IN>;
chomp(@ratF);
$ratFull = join '',@ratF;
#print "$dogFull\n";
#exit;
#my @dogA = @dogFull[1 .. 5000];
#my @ratA = @ratFull[1 .. 7000];
###Section out dog and rat

=pod
for (my $i=1; $i<scalar(@dogFull); $i++){
  $dog = $dog . $dogFull[$i];
  #print "$dog";
  if ($i%100 == 0){
    print "$i";
    if ($i > 30000){
      exit;
    }
  }
}

$rat ="";
for (my $i=1; $i<scalar(@ratA); $i++){
  $rat = $rat . $ratA[$i];
  if ($i%100 == 0){
    print "rat: $i";
  }
  #print "$rat";
}

@data = <IN>;
chomp(@data);

$dog = shift;
$rat = shift;
=cut
%d;
%r;

$seed = '111111111111';
$ls = length($seed);
#$ldog = length($dogFull);
#$lrat = length($ratFull);

###Dog hash
$count = 0;
for(my $i = 12; $i < (length($dogFull) - $ls + 1); $i++){
  if(substr($dogFull,$i, 1) ne "\n"){
  $key = "";
  for(my $j = 0; $j < $ls; $j++){
    if(substr($dogFull, $i+$j, 1) ne "\n") {
    $ch = substr($dogFull, $i+$j, 1);
    $s = substr($seed, $j, 1);
      if($ch eq uc $ch && $s eq '1'){
        $key = $key . $ch;}

    else{

    }
  }
  }
  if ($key eq '' || exists $d{$key}){}
  else{$d{$key} = $i;#print "$key\n";
      print "$key   $i\n";
    $count++;
      #if($i%10000==){print "$i";exit;}
}
}
}

###Rat Hash
$count2 = 0;
for(my $i = 12; $i < (length($ratFull) - $ls + 1); $i++){
  if(substr($ratFull,$i, 1) ne "\n"){
  $key2 = "";
  for(my $j = 0; $j < $ls; $j++){
    if(substr($ratFull, $i+$j, 1) ne "\n") {
    $ch2 = substr($ratFull, $i+$j, 1);
    $s2 = substr($seed, $j, 1);
      if($ch2 eq uc $ch2 && $s2 eq '1'){
        $key2 = $key2 . $ch;}

    else{

    }
  }
  }
  if ($key2 eq '' || exists $d{$key2}){}
  else{$d{$key2} = $i;#print "$key2\n";
     print "$key   $i\n";
    $count2++;
      #if($i%10000==2){print "rat $i";exit;}
}
}
}


=pod
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
=cut
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
