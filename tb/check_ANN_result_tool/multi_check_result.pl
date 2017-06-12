#!/usr/local/bin/perl -w

#use Getopt::Long qw(GetOptions);
#
#GetOptions(
# # 'dir|d=s'  => \$strDir,
# 'c=i' =>\$count,
#
#);  

$count = 2;

$checkFile  =  "../../sw/build/apps/testANN/testANN_multi/meminit_output_vector.txt";
open (CFILE,$checkFile)||die "could not open file! $checkFile\n";
my $err_flag = 0;
my $line_num = 0;

opendir(THISDIR, "../all_case_mif/") or die "serious dainbramage: $!";

@allfiles = grep { not /^*\.pl\z/ and  not /^\.{1,2}\z/} readdir THISDIR;

closedir THISDIR;

for($i = 0; $i < $count ; $i++){
$stdFile    =  "../all_case_mif/$allfiles[$i]/meminit_output_vectors.mif";
print "$stdFile\n";
open (STDFILE,$stdFile)||die "could not open file! $stdFile\n";
	while(defined($rsItem=<STDFILE>))
    {
    	
    	if($rsItem eq "")
    	{
    		next;
    		}  
    		$line_num = $line_num + 1;
    	   if(defined($crsItem = <CFILE>) )  
    	   {
    	   	chomp($crsItem);  
    	   	chomp($rsItem);  
    	    if($rsItem ne $crsItem )
    	    {
    	    	 print "line number $line_num expect $rsItem  result $crsItem\n"; 
    	    	 $err_flag = 1;
    	    	}
    	   } else  {
    	   	
    	   	 print "line number $line_num expect $rsItem\n";
    	   	$err_flag = 1;}
    }   
close(STDFILE);
}

if($err_flag)
{
	  print " fail\n";
	}  else  { print " ok\n";   }


close(CFILE);
 