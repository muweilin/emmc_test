#!/usr/local/bin/perl

use Getopt::Long qw(GetOptions);

GetOptions(
 #'dir|d=s'  => \$strDir,
 'testcase=s' =>\$casename,

);

$strDir = ".";
$count  = 1;
$base_addr = 0x30040000;

open (OUT,">$strDir" . "/../../sw/apps/testANN/testANN_single.h")||die "could not open file!\n";
#open (OUTV,">$strDir" . "/../init_mem.v")||die "could not open file!\n";

open (OUTW0,">$strDir" . "/../../sw/apps/testANN/testANN_single/para_inc/meminit_w00.h")||die "could not open file!\n";
open (OUTW1,">$strDir" . "/../../sw/apps/testANN/testANN_single/para_inc/meminit_w01.h")||die "could not open file!\n";
open (OUTW2,">$strDir" . "/../../sw/apps/testANN/testANN_single/para_inc/meminit_w02.h")||die "could not open file!\n";
open (OUTW3,">$strDir" . "/../../sw/apps/testANN/testANN_single/para_inc/meminit_w03.h")||die "could not open file!\n";
open (OUTW4,">$strDir" . "/../../sw/apps/testANN/testANN_single/para_inc/meminit_w04.h")||die "could not open file!\n";
open (OUTW5,">$strDir" . "/../../sw/apps/testANN/testANN_single/para_inc/meminit_w05.h")||die "could not open file!\n";
open (OUTW6,">$strDir" . "/../../sw/apps/testANN/testANN_single/para_inc/meminit_w06.h")||die "could not open file!\n";
open (OUTW7,">$strDir" . "/../../sw/apps/testANN/testANN_single/para_inc/meminit_w07.h")||die "could not open file!\n";
open (OUTINSN,">$strDir" . "/../../sw/apps/testANN/testANN_single/para_inc/meminit_insn.h")||die "could not open file!\n";
open (OUTSIG,">$strDir" . "/../../sw/apps/testANN/testANN_single/para_inc/sigmoid.h")||die "could not open file!\n";
open (OUTOFF,">$strDir" . "/../../sw/apps/testANN/testANN_single/para_inc/meminit_offset.h")||die "could not open file!\n";
open (OUTDATA,">$strDir" . "/../../sw/apps/testANN/testANN_single/para_inc/meminit_output_vectors.h")||die "could not open file!\n";
open (OUTIDATA,">$strDir" . "/../../sw/apps/testANN/testANN_single/para_inc/meminit_input_vectors.txt")||die "could not open file!\n";
#open (OUTIDATA,">>$strDir" . "/../../sw/build/apps/testANN/testANN_single/slm_files/spi_stim.txt")||die "could not open file!\n";
sub lineCnt{
	my ($file) = @_; 
	my $lineCnt = 0;
	my @dataGroup;
	my $i;
	open (INF,$file)||die "could not open file! $file\n"; 
	while($lineItem = <INF>)
	{
		if(defined($lineItem)){
			  $lineCnt = $lineCnt+1;
			  chomp($lineItem);
			  push(@dataGroup,$lineItem); 
			}			
		}
		close(INF);
		
	for($i=$lineCnt-1; $i>0; $i--){
		
		#$num = ord($dataGroup[$i]);
		#print "$num\n";
		#last;
		if(($dataGroup[$i] ne "00") && ($dataGroup[$i] ne "")  )
		{
			
			last;
		} else {
				  $lineCnt = $lineCnt - 1;
			}
		}
		
		
			print "$lineCnt\n";  
		return $lineCnt;
	}

sub mending4{
	my ($cnt) = @_;   
	while($cnt % 4 > 0)
		{
			 $cnt = $cnt + 1;
			}
		#print "$cnt\n";  
		return $cnt;
	}

opendir(THISDIR, ".") or die "serious dainbramage: $!";

@allfiles = grep { not /^*\.pl\z/ and  not /^\.{1,2}\z/} readdir THISDIR;

closedir THISDIR;

my $baseaddr = 0x31000000;
my $init_src_addr= 0;
#intial adder 0x30020000
my $npu_src_addr = 0x30010000;  
my $npu_dst_addr = 0x31000000;
my $outputCnt  = 0;
my $inputCnt   = 0;
my $insnCnt    = 0;
my $biasCnt    = 0;
my $weightCnt  = 0;
my $sigCnt     = 0;
my $testcnt    = 0;
my $cnt_parse  = 0;
#print OUTV "reg [31:0] i;\n";   
#print OUTV "reg [31:0] j;\n";

foreach (@allfiles){

	print "$_\n";
	$testcase = $_;
	if((-d $testcase) && ($testcase =~ m/$casename/)){
			
		
			my $inputdataF     =  "$strDir/$testcase/meminit_input_vectors.mif";
			my $outputdataF    =  "$strDir/$testcase/meminit_output_vectors.mif";
			my $insndataF      =  "$strDir/$testcase/meminit_insn.mif";	
			my $biasdataF      =  "$strDir/$testcase/meminit_offset.mif";
			my $weightdataF    =  "$strDir/$testcase/meminit_w00.mif"; 
			my $weightdataF1    =  "$strDir/$testcase/meminit_w01.mif";
			my $weightdataF2    =  "$strDir/$testcase/meminit_w02.mif";
			my $weightdataF3    =  "$strDir/$testcase/meminit_w03.mif";
			my $weightdataF4    =  "$strDir/$testcase/meminit_w04.mif";
			my $weightdataF5    =  "$strDir/$testcase/meminit_w05.mif";
			my $weightdataF6    =  "$strDir/$testcase/meminit_w06.mif";
			my $weightdataF7    =  "$strDir/$testcase/meminit_w07.mif";
			
			my $weightdataFstr =  "$strDir/$testcase/meminit_w";
			my $sigdataF       =  "$strDir/$testcase/sigmoid.mif";
			
			open (W0FILE,$weightdataF)||die "could not open file! $weightdataF\n";
			open (W1FILE,$weightdataF1)||die "could not open file! $weightdataF\n";
			open (W2FILE,$weightdataF2)||die "could not open file! $weightdataF\n";
			open (W3FILE,$weightdataF3)||die "could not open file! $weightdataF\n";
			open (W4FILE,$weightdataF4)||die "could not open file! $weightdataF\n";
			open (W5FILE,$weightdataF5)||die "could not open file! $weightdataF\n";
			open (W6FILE,$weightdataF6)||die "could not open file! $weightdataF\n";
			open (W7FILE,$weightdataF7)||die "could not open file! $weightdataF\n";
			open (SIGFILE,$sigdataF)||die "could not open file! $sigdataF\n";
			open (OFFFILE,$biasdataF)||die "could not open file! $biasdataF\n";
			open (INSNFILE,$insndataF)||die "could not open file! $insndataF\n";
			open (ODATAFILE,$outputdataF)||die "could not open file! $outputdataF\n"; 
			open (IDATAFILE,$inputdataF)||die "could not open file! $inputdataF\n";
			
			
			 $offset_multi = int($inputCnt*4/0x10000) + 1;
			 print "offset_multi    $offset_multi\n";	
			 $init_src_addr = $npu_src_addr + $offset_multi*0x10000;		
			 $init_src_addr_pr = sprintf "%x",$init_src_addr;
			 
			 $offset_multi = int($outputCnt*4/0x10000) + 1;
			 print "offset_multi    $offset_multi\n";	
			 $npu_dst_addr = $npu_dst_addr + $offset_multi*0x10000;		
			 $npu_dst_addr_pr = sprintf "%x",$npu_dst_addr;
			
			# 
			 
			 $outputCnt  = &lineCnt($outputdataF );
			 $inputCnt   = &lineCnt($inputdataF );
			 $insnCnt    = &lineCnt($insndataF  );
			 $biasCnt    = &lineCnt($biasdataF  );
			 $biasCnt    = &mending4($biasCnt);
			 $weightCnt  = &lineCnt($weightdataF);
			 $weightCnt  = &mending4($weightCnt);
			 $sigCnt     = 512;


			 
			 my $convert_cnt = 0;
			 
			 print OUTW0 "int w00[]={\n";
			 print OUTW1 "int w01[]={\n";
			 print OUTW2 "int w02[]={\n";
			 print OUTW3 "int w03[]={\n";
			 print OUTW4 "int w04[]={\n";
			 print OUTW5 "int w05[]={\n";
			 print OUTW6 "int w06[]={\n";
			 print OUTW7 "int w07[]={\n";
			 
			 while($convert_cnt<$weightCnt)
			 {
			 	 
			 	 
			 	    $strw0 = <W0FILE>;
			 			$strw1 = <W1FILE>;
			 			$strw2 = <W2FILE>;
			 			$strw3 = <W3FILE>;
			 			$strw4 = <W4FILE>;
			 			$strw5 = <W5FILE>;
			 			$strw6 = <W6FILE>;
			 			$strw7 = <W7FILE>; 
			 			
			 			chomp($strw0);
			 			chomp($strw1);
			 			chomp($strw2);
			 			chomp($strw3);
			 			chomp($strw4);
			 			chomp($strw5);
			 			chomp($strw6);
			 			chomp($strw7);
			 			
			 			
			 	 if($convert_cnt<$weightCnt-1)
			 	 {
			 	 	print OUTW0 "0x$strw0,\n";
			  		print OUTW1 "0x$strw1,\n";
			  		print OUTW2 "0x$strw2,\n";
			  		print OUTW3 "0x$strw3,\n";
			  		print OUTW4 "0x$strw4,\n";
			  		print OUTW5 "0x$strw5,\n";
			  		print OUTW6 "0x$strw6,\n";
			  		print OUTW7 "0x$strw7,\n";
			  	} else {
			  		print OUTW0 "0x$strw0\n};\n";
			  		print OUTW1 "0x$strw1\n};\n";
			  		print OUTW2 "0x$strw2\n};\n";
			  		print OUTW3 "0x$strw3\n};\n";
			  		print OUTW4 "0x$strw4\n};\n";
			  		print OUTW5 "0x$strw5\n};\n";
			  		print OUTW6 "0x$strw6\n};\n";
			  		print OUTW7 "0x$strw7\n};\n";
			  		
			  		}
			 	$convert_cnt++;
			 	
			 	}
			 	
			 	close(W0FILE); 			 	
			 	close(W1FILE); 
			 	close(W2FILE);
			 	close(W3FILE);
			 	close(W4FILE);
			 	close(W5FILE);
			 	close(W6FILE);
			 	close(W7FILE); 
			 	
			 	close(OUTW0); 			 	
			 	close(OUTW1); 
			 	close(OUTW2);
			 	close(OUTW3);
			 	close(OUTW4);
			 	close(OUTW5);
			 	close(OUTW6);
			 	close(OUTW7);      
			 	
			 $convert_cnt = 0; 
			 
			 print OUTOFF "int offset[]={\n";   	
			 	
			 while($convert_cnt<$biasCnt)
			 {
			 		$stroff = <OFFFILE>;
			 		chomp($stroff); 
			 		if($convert_cnt<$biasCnt-1){ 
			 			print OUTOFF "0x$stroff,\n";
			 		} else{
			 			print OUTOFF "0x$stroff\n};\n";
			 			}
			 		
			 		$convert_cnt++;   
			 	
			 	}
			  close(OFFFILE); 			 	
			 	close(OUTOFF); 
			 $convert_cnt = 0; 
			 print OUTSIG "int sigmoid[]={\n";
			 
			 while($convert_cnt<$sigCnt)
			 {
			 	  $strsig = <SIGFILE>;
			 	  chomp($strsig);
			 		if($convert_cnt<$sigCnt-1){ 
			 			print OUTSIG "0x$strsig,\n";
			 		} else{
			 			print OUTSIG "0x$strsig\n};\n";
			 			}
			 		
			 		$convert_cnt++; 
			 	
			 	}
			 	
			 	close(SIGFILE); 			 	
			 	close(OUTSIG);
			 $convert_cnt = 0; 
			 print OUTINSN "char *insn[]={\n";
			 while($convert_cnt<$insnCnt)
			 {
			 		$strinsn = <INSNFILE>;
			 		chomp($strinsn);
			 		if($convert_cnt<$insnCnt-1){ 
			 			print OUTINSN "\"$strinsn\",\n";
			 		} else{
			 			print OUTINSN "\"$strinsn\"\n};\n";
			 			}
			 		
			 		$convert_cnt++; 
			 	
			 	}
			  close(OUTINSN); 			 	
			 	close(INSNFILE);	
			 $convert_cnt = 0; 
			 print OUTDATA "int out_data[]={\n";	
			 while($convert_cnt<$outputCnt)
			 {
			 		$strodata = <ODATAFILE>;
			 		chomp($strodata);
			 		if($convert_cnt<$outputCnt-1){ 
			 			print OUTDATA "0x$strodata,\n";
			 		} else{
			 			print OUTDATA "0x$strodata\n};\n";
			 			}
			 		
			 		$convert_cnt++; 
			 	
			 	}
			  close(ODATAFILE); 			 	
			 	close(OUTDATA);
			 	
			 	$convert_cnt = 0; 
			 	
			 $addr_spi= $base_addr;
			 while($convert_cnt<$inputCnt)
			 {
			 		$stridata = <IDATAFILE>;
			 		chomp($stridata);
			 		$addr_hex = sprintf("%x",$addr_spi);
			 		print OUTIDATA "$addr_hex\_$stridata\n";
			 		
			 		
			 		$convert_cnt++; 
			 		$addr_spi = $addr_spi + 4;
			 	
			 	}
			  close(IDATAFILE); 			 	
			 	close(OUTIDATA);
			 	
			 	
			 $offset_multi_npu = int(($insnCnt*4 + $biasCnt + $weightCnt*8 + $sigCnt)/0x10000) + 1;
			 $npu_src_addr = $init_src_addr + $offset_multi_npu*0x10000; 
			 $npu_src_addr_pr =  sprintf "%x",$base_addr;
			 
			my $weight_length = $weightCnt/4;
			my $offset_length = $biasCnt/4; 
			  # $baseaddr = $npu_src_addr;
		  $wrtStr =         " #define  IM_DEPTH$testcnt            $insnCnt\n";
		  $wrtStr = $wrtStr." #define  WEIGTH_DEPTH$testcnt        $weightCnt\n";
		  $wrtStr = $wrtStr." #define  BIAS_DEPTH$testcnt          $biasCnt\n";
		  $wrtStr = $wrtStr." #define  DMA_SRC_ADDR$testcnt        0x$init_src_addr_pr\n";
			$wrtStr = $wrtStr." #define  DMA_BLOCK_INFO$testcnt      1\n\n";
			$wrtStr = $wrtStr." #define  NPU_DATAIN_DEPTH$testcnt    $inputCnt\n";
			$wrtStr = $wrtStr." #define  NPU_DATAOUT_DEPTH$testcnt   $outputCnt\n";  
			$wrtStr = $wrtStr." #define  NPU_DMA_SRC_ADDR$testcnt    0x$npu_src_addr_pr\n";
			$wrtStr = $wrtStr." #define  NPU_DMA_DST_ADDR$testcnt    0x$npu_dst_addr_pr\n";
			$wrtStr = $wrtStr." #define  NPU_DMA_BLOCK_INFO$testcnt  1\n\n\n";
			$wrtStr = $wrtStr." #define  length_array_weight  $weight_length\n";
			$wrtStr = $wrtStr." #define  length_array_offset  $offset_length\n\n\n";
       print OUT $wrtStr;
       
      $wrtStr = "localparam IN_CNT$testcnt                = 32'd$inputCnt;\n";
		  $wrtStr = $wrtStr."localparam IM_RAM_DEPTH$testcnt       = 32'd$insnCnt;\n";
		  $wrtStr = $wrtStr."localparam BIAS_RAM_DEPTH$testcnt     = 32'd$biasCnt;\n";
		  $wrtStr = $wrtStr."localparam WEIGHT_RAM_DEPTH$testcnt   = 32'd$weightCnt;\n";
			$wrtStr = $wrtStr."localparam SIG_LUT_DEPTH$testcnt      = 32'd$sigCnt;\n";
			$wrtStr = $wrtStr."localparam OUT_CNT$testcnt            = 32'd$outputCnt;\n";
			$wrtStr = $wrtStr."localparam INIT_SRC_ADDR$testcnt      = 32'h$init_src_addr_pr;\n";
			$wrtStr = $wrtStr."localparam NPU_SRC_ADDR$testcnt       = 32'h$npu_src_addr_pr;\n";
			 
			#print OUTV $wrtStr;
			#$wrtStr = "parameter SIG_INIT$testcnt          = \"../../../../../tb/all_case_mif/$sigdataF\";\n";
		  #$wrtStr = $wrtStr."parameter INSN_MEM_MIF$testcnt      = \"../../../../../tb/all_case_mif/$insndataF\";\n";
		  #$wrtStr = $wrtStr."parameter WEIGHT_MIF$testcnt        = \"../../../../../tb/all_case_mif/$weightdataFstr\";\n";
		  #$wrtStr = $wrtStr."parameter BIAS_MIF$testcnt          = \"../../../../../tb/all_case_mif/$biasdataF\";\n";
			#$wrtStr = $wrtStr."parameter INPUT_VECTORS$testcnt     = \"../../../../../tb/all_case_mif/$inputdataF\";\n";
			#
			#print OUTV $wrtStr;
			#$wrtStr = "reg [7:0] sig_init$testcnt [SIG_LUT_DEPTH$testcnt-1:0];\n";
			#$wrtStr = $wrtStr."initial begin\n";
			#$wrtStr = $wrtStr."\$readmemh(SIG_INIT$testcnt, sig_init$testcnt, 0, SIG_LUT_DEPTH$testcnt-1);\n";
      #$wrtStr = $wrtStr."end\n";
      #print OUTV $wrtStr;
      #
      #$wrtStr = "\/\/ instruction mem ram init.\n";
			#$wrtStr = $wrtStr."reg [20:0] im_init$testcnt [IM_RAM_DEPTH$testcnt-1:0];\n";
			#$wrtStr = $wrtStr."initial begin\n";
			#$wrtStr = $wrtStr."\$readmemb(INSN_MEM_MIF$testcnt, im_init$testcnt, 0, IM_RAM_DEPTH$testcnt-1);\n";
      #$wrtStr = $wrtStr."end\n";
      #print OUTV $wrtStr;
      #
      #$wrtStr = "\/\/ weight ram init.\n";
			#$wrtStr = $wrtStr."reg [128*8:0] mif_file$testcnt;\n";
			#$wrtStr = $wrtStr."reg [7:0] weight_init$testcnt [WEIGHT_RAM_DEPTH$testcnt*8-1:0];\n";
			#$wrtStr = $wrtStr."reg [4:0] t$testcnt;\n";
			#$wrtStr = $wrtStr."initial begin\n";
			#$wrtStr = $wrtStr."  for (t$testcnt = 0; t$testcnt < 8; t$testcnt = t$testcnt + 1) begin\n";
			#$wrtStr = $wrtStr."     \$sformat(mif_file$testcnt, \"\%s\%02d.mif\", WEIGHT_MIF$testcnt, t$testcnt);\n";
			#$wrtStr = $wrtStr."     \$readmemh(mif_file$testcnt, weight_init$testcnt, WEIGHT_RAM_DEPTH$testcnt*t$testcnt, WEIGHT_RAM_DEPTH$testcnt*(t$testcnt+1)-1);\n";
      #$wrtStr = $wrtStr."  end\n";
      #$wrtStr = $wrtStr."end\n";
      #print OUTV $wrtStr;
      #
      #$wrtStr = "\/\/ bias ram init.\n";
			#$wrtStr = $wrtStr."reg [7:0] bias_init$testcnt [BIAS_RAM_DEPTH$testcnt-1:0];\n";
			#$wrtStr = $wrtStr."initial begin\n";
			#$wrtStr = $wrtStr."  \$readmemh(BIAS_MIF$testcnt, bias_init$testcnt, 0, BIAS_RAM_DEPTH$testcnt-1);\n";
      #$wrtStr = $wrtStr."end\n";
      #print OUTV $wrtStr;
      #
      #$wrtStr = "\/\/input init. \n";
			#$wrtStr = $wrtStr."reg [63:0] input_init$testcnt [IN_CNT$testcnt-1:0];\n";
			#$wrtStr = $wrtStr."initial begin\n";
			#$wrtStr = $wrtStr."  \$readmemh(INPUT_VECTORS$testcnt, input_init$testcnt, 0, IN_CNT$testcnt-1);\n";
      #$wrtStr = $wrtStr."end\n";
      #print OUTV $wrtStr;
			#
			##print OUT "init_mem(32'd$baseaddr);\n";
			#
			#
			#
			#$wrtStr = "initial begin\n";
			#$wrtStr = $wrtStr."i = 0;\n";
			#$wrtStr = $wrtStr."for (j=0;j < IM_RAM_DEPTH$testcnt*4;j=j+32'h4) begin\n";
			#$wrtStr = $wrtStr."  backdoor_write(j+32'h$init_src_addr_pr,{11'b0,im_init".$testcnt."[i][20:0]});\n";
      #$wrtStr = $wrtStr."  i=i+1;\n";
      #$wrtStr = $wrtStr."end\n";
      #print OUTV $wrtStr;
      #
      #$wrtStr = "i = 0;\n";
			#$wrtStr = $wrtStr."for (j=IM_RAM_DEPTH$testcnt*4;j < (IM_RAM_DEPTH$testcnt*4 + WEIGHT_RAM_DEPTH$testcnt*8); j=j+32'h4) begin\n";
			#$wrtStr = $wrtStr."  backdoor_write(j+32'h$init_src_addr_pr,{weight_init".$testcnt."[i+3],weight_init".$testcnt."[i+2],weight_init".$testcnt."[i+1],weight_init".$testcnt."[i]});\n";
      #$wrtStr = $wrtStr."  i=i+4;\n";
      #$wrtStr = $wrtStr."end\n";
      #print OUTV $wrtStr;
      #
      #$wrtStr = "i = 0;\n";
			#$wrtStr = $wrtStr."for (j=IM_RAM_DEPTH$testcnt*4 + WEIGHT_RAM_DEPTH$testcnt*8; j < IM_RAM_DEPTH$testcnt*4 + WEIGHT_RAM_DEPTH$testcnt*8+BIAS_RAM_DEPTH$testcnt; j=j+32'h4) begin\n";
			#$wrtStr = $wrtStr."  backdoor_write(j+32'h$init_src_addr_pr,{ bias_init".$testcnt."[i+3], bias_init".$testcnt."[i+2], bias_init".$testcnt."[i+1], bias_init".$testcnt."[i]});\n";
      #$wrtStr = $wrtStr."  i=i+4;\n";
      #$wrtStr = $wrtStr."end\n";
      #print OUTV $wrtStr;
      #
      #$wrtStr = "i = 0;\n";
			#$wrtStr = $wrtStr."for (j=IM_RAM_DEPTH$testcnt*4 + WEIGHT_RAM_DEPTH$testcnt*8 + BIAS_RAM_DEPTH$testcnt; j < IM_RAM_DEPTH$testcnt*4 + WEIGHT_RAM_DEPTH$testcnt*8 + BIAS_RAM_DEPTH$testcnt + SIG_LUT_DEPTH$testcnt; j=j+32'h4) begin\n";
			#$wrtStr = $wrtStr."  backdoor_write(j+32'h$init_src_addr_pr,{ sig_init".$testcnt."[i+3], sig_init".$testcnt."[i+2], sig_init".$testcnt."[i+1], sig_init".$testcnt."[i]});\n";
      #$wrtStr = $wrtStr."  i=i+4;\n";
      #$wrtStr = $wrtStr."end\n";
      #print OUTV $wrtStr;
      #
      #$wrtStr = "i = 0;\n";
			#$wrtStr = $wrtStr."for (j=0; j < IN_CNT$testcnt*4; j=j+32'h4) begin\n";
			#$wrtStr = $wrtStr."  backdoor_write(j+32'h$npu_src_addr_pr,input_init".$testcnt."[i][31:0]);\n";
      #$wrtStr = $wrtStr."  i=i+1;\n";
      #$wrtStr = $wrtStr."end\n";
      #$wrtStr = $wrtStr."end\n";
      #print OUTV $wrtStr;
	   $baseaddr = ($inputCnt*4 + $insnCnt*4 + $biasCnt + $weightCnt*8 + $sigCnt);
       $testcnt++;
     
       
	}
}

close(OUT);
#close(OUTV);
#print "@allfiles\n";


 
