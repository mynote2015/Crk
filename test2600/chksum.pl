#!/usr/bin/perl
sub checksum {
  my $file = $_[0];
  open(F, "< $file") or die "Unable to open $file ";
  print "\n[!] Calculating the checksum for file $file\n\n";
  binmode(F);
  my $len = (stat($file))[7];
  my $words = $len / 4;
  print "[*] Bytes: \t$len\n";
  print "[*] Words: \t$words\n";
  printf "[*] Hex: \t0x%08lx\n",$len;
  my $cs = 0;
  my ($rsize, $buff, @wordbuf);
  for(;$words; $words -= $rsize) {
    $rsize = $words < 16384 ? $words : 16384;
    read F, $buff, 4*$rsize or die "Can't read file $file : $!\n";
    @wordbuf = unpack "N*",$buff;
    foreach (@wordbuf) {
    $cs += $_;
    $cs = ($cs + 1) % (0x10000 * 0x10000) if $cs > 0xffffffff;
    }
  }
  printf "[*] Checksum: \t0x%lx\n\n",$cs;
  return (sprintf("%lx", $cs));
  close(F);
}

if ($#ARGV + 1 != 1) {
  print "\nUsage: ./chksum.pl <file>\n\n";
  exit;
}
checksum($ARGV[0]);