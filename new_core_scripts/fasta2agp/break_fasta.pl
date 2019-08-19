#!/user/bin/env perl
##Breaks a chrom only fasta file into smaller chunks
##Parsing is dependant on the fasta headers and chunk size
use 5.14.0;
use warnings;
use Data::Dumper;

{
    my ($file) = @ARGV;
    if (@ARGV < 1){
        usage();
    }
    my $header;
    my $header_count;
    my $count;

    open IN, "<", $file or die "can't open $file\n";
    while (my $line = <IN>){
        chomp($line);
        
        ##Create a new chunk each time there is a header
        ##This needs to be changed according to the header
        if ($line =~ />(\d\w)/ or $line =~ />(Un)/){
            
            ##Header is <chrom number>_<chunk count>
            $header = ">$1";
            $header_count = 1;
            say $header."_$header_count";
            $count=0;
            next;
        }
        say $line;
        $count++;

        ##Make each chunk 600,000 bases long
        if ($count % 10_000 == 0){
            $header_count++;
            say $header."_$header_count";
        }
    }
}

sub usage {
    say "Usage perl break_fasta.pl [a] [b]";
    exit 0;
}
 
