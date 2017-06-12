#!/usr/local/bin/perl

#use Getopt::Long qw(GetOptions);
#
#GetOptions(
# 'dir|d=s'  => \$strDir,
# 'c=i' =>\$count,
#
#);

$strDir = ".";
$count  = 3;

open (OUT,">$strDir" . "/../../sw/apps/testANN/testANN_multi/testANN_multi.h")||die "could not open file!\n";
open (OUTV,">$strDir" . "/../init_mem.v")||die "could not open file!\n";



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
		
		
		#	print "$lineCnt\n";  
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

my $baseaddr = 0x22000000;
my $init_src_addr= 0;
my $npu_src_addr = 0x20000000;
my $npu_dst_addr = 0x22000000;
my $outputCnt  = 0;
my $inputCnt   = 0;
my $insnCnt    = 0;
my $biasCnt    = 0;
my $weightCnt  = 0;
my $sigCnt     = 0;
my $testcnt    = 0;
print OUTV "reg [31:0] i;\n";   
print OUTV "reg [31:0] j;\n";

foreach (@allfiles){

	print "$_\n";
	$testcase = $_;
	if(-d $testcase){
			
			
			my $inputdataF     =  "$strDir/$testcase/meminit_input_vectors.mif";
			my $outputdataF    =  "$strDir/$testcase/meminit_output_vectors.mif";
			my $insndataF      =  "$strDir/$testcase/meminit_insn.mif";	
			my $biasdataF      =  "$strDir/$testcase/meminit_offset.mif";
			my $weightdataF    =  "$strDir/$testcase/meminit_w00.mif"; 
			my $weightdataFstr =  "$strDir/$testcase/meminit_w";
			my $sigdataF       =  "$strDir/$testcase/sigmoid.mif";
			
			
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
			 
			 $offset_multi_npu = int(($insnCnt*4 + $biasCnt + $weightCnt*8 + $sigCnt)/0x10000) + 1;
			 $npu_src_addr = $init_src_addr + $offset_multi_npu*0x10000; 
			 $npu_src_addr_pr =  sprintf "%x",$npu_src_addr;
			 
			
			  # $baseaddr = $npu_src_addr;
		  $wrtStr =         " #define  IM_DEPTH$testcnt            $insnCnt\n";
		  $wrtStr = $wrtStr." #define  WEIGTH_DEPTH$testcnt        $weightCnt\n";
		  $wrtStr = $wrtStr." #define  BIAS_DEPTH$testcnt          $biasCnt\n";
		  $wrtStr = $wrtStr." #define  DMA_SRC_ADDR$testcnt        0x$init_src_addr_pr\n";
			$wrtStr = $wrtStr." #define  DMA_BLOCK_INFO$testcnt      8\n\n";
			$wrtStr = $wrtStr." #define  NPU_DATAIN_DEPTH$testcnt    $inputCnt\n";
			$wrtStr = $wrtStr." #define  NPU_DATAOUT_DEPTH$testcnt   $outputCnt\n";  
			$wrtStr = $wrtStr." #define  NPU_DMA_SRC_ADDR$testcnt    0x$npu_src_addr_pr\n";
			$wrtStr = $wrtStr." #define  NPU_DMA_DST_ADDR$testcnt    0x$npu_dst_addr_pr\n";
			$wrtStr = $wrtStr." #define  NPU_DMA_BLOCK_INFO$testcnt  8\n\n\n";
       print OUT $wrtStr;
       
      $wrtStr = "localparam IN_CNT$testcnt                = 32'd$inputCnt;\n";
		  $wrtStr = $wrtStr."localparam IM_RAM_DEPTH$testcnt       = 32'd$insnCnt;\n";
		  $wrtStr = $wrtStr."localparam BIAS_RAM_DEPTH$testcnt     = 32'd$biasCnt;\n";
		  $wrtStr = $wrtStr."localparam WEIGHT_RAM_DEPTH$testcnt   = 32'd$weightCnt;\n";
			$wrtStr = $wrtStr."localparam SIG_LUT_DEPTH$testcnt      = 32'd$sigCnt;\n";
			$wrtStr = $wrtStr."localparam OUT_CNT$testcnt            = 32'd$outputCnt;\n";
			$wrtStr = $wrtStr."localparam INIT_SRC_ADDR$testcnt      = 32'h$init_src_addr_pr;\n";
			$wrtStr = $wrtStr."localparam NPU_SRC_ADDR$testcnt       = 32'h$npu_src_addr_pr;\n";
			
			print OUTV $wrtStr;
			$wrtStr = "parameter SIG_INIT$testcnt          = \"../../../../../tb/all_case_mif/$sigdataF\";\n";
		  $wrtStr = $wrtStr."parameter INSN_MEM_MIF$testcnt      = \"../../../../../tb/all_case_mif/$insndataF\";\n";
		  $wrtStr = $wrtStr."parameter WEIGHT_MIF$testcnt        = \"../../../../../tb/all_case_mif/$weightdataFstr\";\n";
		  $wrtStr = $wrtStr."parameter BIAS_MIF$testcnt          = \"../../../../../tb/all_case_mif/$biasdataF\";\n";
			$wrtStr = $wrtStr."parameter INPUT_VECTORS$testcnt     = \"../../../../../tb/all_case_mif/$inputdataF\";\n";
			
			print OUTV $wrtStr;
			$wrtStr = "reg [7:0] sig_init$testcnt [SIG_LUT_DEPTH$testcnt-1:0];\n";
			$wrtStr = $wrtStr."initial begin\n";
			$wrtStr = $wrtStr."\$readmemh(SIG_INIT$testcnt, sig_init$testcnt, 0, SIG_LUT_DEPTH$testcnt-1);\n";
      $wrtStr = $wrtStr."end\n";
      print OUTV $wrtStr;
      
      $wrtStr = "\/\/ instruction mem ram init.\n";
			$wrtStr = $wrtStr."reg [20:0] im_init$testcnt [IM_RAM_DEPTH$testcnt-1:0];\n";
			$wrtStr = $wrtStr."initial begin\n";
			$wrtStr = $wrtStr."\$readmemb(INSN_MEM_MIF$testcnt, im_init$testcnt, 0, IM_RAM_DEPTH$testcnt-1);\n";
      $wrtStr = $wrtStr."end\n";
      print OUTV $wrtStr;
      
      $wrtStr = "\/\/ weight ram init.\n";
			$wrtStr = $wrtStr."reg [128*8:0] mif_file$testcnt;\n";
			$wrtStr = $wrtStr."reg [7:0] weight_init$testcnt [WEIGHT_RAM_DEPTH$testcnt*8-1:0];\n";
			$wrtStr = $wrtStr."reg [4:0] t$testcnt;\n";
			$wrtStr = $wrtStr."initial begin\n";
			$wrtStr = $wrtStr."  for (t$testcnt = 0; t$testcnt < 8; t$testcnt = t$testcnt + 1) begin\n";
			$wrtStr = $wrtStr."     \$sformat(mif_file$testcnt, \"\%s\%02d.mif\", WEIGHT_MIF$testcnt, t$testcnt);\n";
			$wrtStr = $wrtStr."     \$readmemh(mif_file$testcnt, weight_init$testcnt, WEIGHT_RAM_DEPTH$testcnt*t$testcnt, WEIGHT_RAM_DEPTH$testcnt*(t$testcnt+1)-1);\n";
      $wrtStr = $wrtStr."  end\n";
      $wrtStr = $wrtStr."end\n";
      print OUTV $wrtStr;
      
      $wrtStr = "\/\/ bias ram init.\n";
			$wrtStr = $wrtStr."reg [7:0] bias_init$testcnt [BIAS_RAM_DEPTH$testcnt-1:0];\n";
			$wrtStr = $wrtStr."initial begin\n";
			$wrtStr = $wrtStr."  \$readmemh(BIAS_MIF$testcnt, bias_init$testcnt, 0, BIAS_RAM_DEPTH$testcnt-1);\n";
      $wrtStr = $wrtStr."end\n";
      print OUTV $wrtStr;
      
      $wrtStr = "\/\/input init. \n";
			$wrtStr = $wrtStr."reg [63:0] input_init$testcnt [IN_CNT$testcnt-1:0];\n";
			$wrtStr = $wrtStr."initial begin\n";
			$wrtStr = $wrtStr."  \$readmemh(INPUT_VECTORS$testcnt, input_init$testcnt, 0, IN_CNT$testcnt-1);\n";
      $wrtStr = $wrtStr."end\n";
      print OUTV $wrtStr;
			
			#print OUT "init_mem(32'd$baseaddr);\n";
			
			
			
			$wrtStr = "initial begin\n";
			$wrtStr = $wrtStr."i = 0;\n";
			$wrtStr = $wrtStr."for (j=0;j < IM_RAM_DEPTH$testcnt*4;j=j+32'h4) begin\n";
			$wrtStr = $wrtStr."  backdoor_write(j+32'h$init_src_addr_pr,{11'b0,im_init".$testcnt."[i][20:0]});\n";
      $wrtStr = $wrtStr."  i=i+1;\n";
      $wrtStr = $wrtStr."end\n";
      print OUTV $wrtStr;
      
      $wrtStr = "i = 0;\n";
			$wrtStr = $wrtStr."for (j=IM_RAM_DEPTH$testcnt*4;j < (IM_RAM_DEPTH$testcnt*4 + WEIGHT_RAM_DEPTH$testcnt*8); j=j+32'h4) begin\n";
			$wrtStr = $wrtStr."  backdoor_write(j+32'h$init_src_addr_pr,{weight_init".$testcnt."[i+3],weight_init".$testcnt."[i+2],weight_init".$testcnt."[i+1],weight_init".$testcnt."[i]});\n";
      $wrtStr = $wrtStr."  i=i+4;\n";
      $wrtStr = $wrtStr."end\n";
      print OUTV $wrtStr;
      
      $wrtStr = "i = 0;\n";
			$wrtStr = $wrtStr."for (j=IM_RAM_DEPTH$testcnt*4 + WEIGHT_RAM_DEPTH$testcnt*8; j < IM_RAM_DEPTH$testcnt*4 + WEIGHT_RAM_DEPTH$testcnt*8+BIAS_RAM_DEPTH$testcnt; j=j+32'h4) begin\n";
			$wrtStr = $wrtStr."  backdoor_write(j+32'h$init_src_addr_pr,{ bias_init".$testcnt."[i+3], bias_init".$testcnt."[i+2], bias_init".$testcnt."[i+1], bias_init".$testcnt."[i]});\n";
      $wrtStr = $wrtStr."  i=i+4;\n";
      $wrtStr = $wrtStr."end\n";
      print OUTV $wrtStr;
      
      $wrtStr = "i = 0;\n";
			$wrtStr = $wrtStr."for (j=IM_RAM_DEPTH$testcnt*4 + WEIGHT_RAM_DEPTH$testcnt*8 + BIAS_RAM_DEPTH$testcnt; j < IM_RAM_DEPTH$testcnt*4 + WEIGHT_RAM_DEPTH$testcnt*8 + BIAS_RAM_DEPTH$testcnt + SIG_LUT_DEPTH$testcnt; j=j+32'h4) begin\n";
			$wrtStr = $wrtStr."  backdoor_write(j+32'h$init_src_addr_pr,{ sig_init".$testcnt."[i+3], sig_init".$testcnt."[i+2], sig_init".$testcnt."[i+1], sig_init".$testcnt."[i]});\n";
      $wrtStr = $wrtStr."  i=i+4;\n";
      $wrtStr = $wrtStr."end\n";
      print OUTV $wrtStr;
      
      $wrtStr = "i = 0;\n";
			$wrtStr = $wrtStr."for (j=0; j < IN_CNT$testcnt*4; j=j+32'h4) begin\n";
			$wrtStr = $wrtStr."  backdoor_write(j+32'h$npu_src_addr_pr,input_init".$testcnt."[i][31:0]);\n";
      $wrtStr = $wrtStr."  i=i+1;\n";
      $wrtStr = $wrtStr."end\n";
      $wrtStr = $wrtStr."end\n";
      print OUTV $wrtStr;
	   $baseaddr = ($inputCnt*4 + $insnCnt*4 + $biasCnt + $weightCnt*8 + $sigCnt);
       $testcnt++;
	}
}

close(OUT);
close(OUTV);
#print "@allfiles\n";


 
