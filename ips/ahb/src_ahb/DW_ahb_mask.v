/*
------------------------------------------------------------------------
--
--                  (C) COPYRIGHT 2001-2011 SYNOPSYS, INC.
--                             ALL RIGHTS RESERVED
--
--  This software and the associated documentation are confidential and
--  proprietary to Synopsys, Inc.  Your use or disclosure of this
--  software is subject to the terms and conditions of a written
--  license agreement between you, or your company, and Synopsys, Inc.
--
--  The entire notice above must be reproduced on all authorized copies.
--
-- File :                       DW_ahb_mask.v
-- Author:                      Ray Beechinor, Peter Gillen 
-- Date :                       $Date: 2011/09/14 $ 
-- Version      :               $Revision: #3 $ 
-- Abstract     :               
--
-- Generate the hsplits and the masks for masters if a transfer is split
--
*/
`include "DW_amba_constants.v" 
`include "DW_ahb_cc_constants.v"
`include "DW_ahb_constants.v"
module DW_ahb_mask (
  hclk,
  hresetn,
  hresp,
  bus_hsplit,
  hmaster_data,
  maskmaster,
  bus_priority,
  ltip,
  hready,
  csilt,
  est,
  hsplit,
  mask
);

   input                            hclk;
   input                            hresetn;  
   input [`HRESP_WIDTH-1:0]         hresp;
// All hsplits from each master are combined into single bus
   input [`SPLITBUS_WIDTH-1:0]      bus_hsplit;
   input [`HMASTER_WIDTH-1:0]       hmaster_data;
// A locked transfer is currently running on the bus
   input                            ltip;
// Which masters have been masked by priority registers
   input [`NUM_AHB_MASTERS:0]       maskmaster;
// all master priorities are combined into single bus
   input [(4*(`NUM_INT_MASTERS))-1:0] bus_priority;
   input                            hready;
// End of locked split transfer
   input                            est;
   input                            csilt;
// All hsplits are ored into single hsplit bus
   output [`HSPLIT_WIDTH-1:0]       hsplit;
// Mask master control passed to DW_ahb_bcm53
   output [`NUM_AHB_MASTERS:0]      mask;
   reg [`NUM_AHB_MASTERS:0]         mask;
//
// To calculate hsplit, the members of the hsplit bus will be re-ordered
// into the hsplit_reorg bus, so that the LSBs from each slave's hsplit
// bus will be grouped together into the least significant bits of 
// hsplit_reorg. Each hsplit[1] from all of the slaves will be grouped
// together next and so on.
//
    reg [`SPLITBUS_WIDTH-1:0]        hsplit_reorg;
//
// All hsplit busses from the individual slaves are logically 
// ORed together and the result is stored in hsplit 
//
   reg [`HSPLIT_WIDTH-1:0]          hsplit;
//
// This register "records" SPLIT responses received from slaves.
// If a slave issues a SPLIT response on its HRESP output, the bit
// in this register corresponding to the master which was
// conversing with that slave is set to '1' and held at '1'
// until the slave indicates readiness to resume the transaction
// by asserting the appropriate bit on its HSPLIT output
//
   reg  [`NUM_AHB_MASTERS:0]        r_rec_hsplit;
   wire [`NUM_AHB_MASTERS:0]        rec_hsplit;
   reg                              extend_ltip;
   reg  [`NUM_IAHB_SLAVES-1:0]      hsplit_temp;

   reg  [3:0]                       priority_i;
   reg  [3:0]                       priority_master;
   reg  [`NUM_INT_MASTERS-1:0]      r_mask_locked;
   wire [`NUM_INT_MASTERS-1:0]      mask_locked;

   integer                          i;
   integer                          j;
   integer                          m;
   integer                          n;
   integer                          x;
   integer                          k;
   integer                          p;

//
// Regroup the members of bus_hsplit by putting all the
// bit 0 side by side and then NUM_AHB_MASTERS putting all
// the bit 1's etc.
//
  always @ (bus_hsplit)
  begin : hsplit_reog_PROC
    for (m=0;m<=`HSPLIT_WIDTH-1;m=m+1) begin
      for (n=0;n<`NUM_IAHB_SLAVES;n=n+1) begin
        hsplit_reorg[((m*(`NUM_IAHB_SLAVES))+n)] = 
                                   bus_hsplit[(((`HSPLIT_WIDTH)*n)+m)];
      end
    end
  end
 
// Logically "OR" each NUM_AHB_MASTER bits to produce hsplit
//
  always @ (hsplit_reorg)
  begin : hsplit_PROC
    hsplit = {`HSPLIT_WIDTH{1'b0}};
    for (x=0;x<=`HSPLIT_WIDTH-1;x=x+1) begin
      hsplit_temp = hsplit_reorg >> ((`NUM_IAHB_SLAVES) * x);
      hsplit[x] = |hsplit_temp;
    end
  end
   
// Generate the "mask" output bus to DW_ahb_bcm53

  always @ (hresp or
             rec_hsplit or 
             hsplit or 
             hmaster_data or 
             bus_priority or
             ltip or
             hready or mask_locked or
             maskmaster)
  begin : mask_PROC
    mask = {`NUM_AHB_MASTERS{1'b0}};

    case (hmaster_data)
      4'h1 : k = 4;
      4'h2 : k = 8;
      4'h3 : k = 12;
      4'h4 : k = 16;
      4'h5 : k = 20;
      4'h6 : k = 24;
      4'h7 : k = 28;
      4'h8 : k = 32;
      4'h9 : k = 36;
      4'ha : k = 40;
      4'hb : k = 44;
      4'hc : k = 48;
      4'hd : k = 52;
      4'he : k = 56;
      4'hf : k = 60;
      default : k = 0;
    endcase

    priority_master = bus_priority >> k;

// For each master, i, in the system, mask[i] is asserted if
// (a) maskmaster[i] is asserted, i.e. if the priority registers in
// DW_ahb_arbif show that the master has been disabled by the user
// (b) A SPLIT response is received on hresp AND Master i owns the
//     bus, as shown by hmaster_data
// (c) If Master i has been previously SPLIT, as shown by 
// rec_hsplit[i] equalling '1' AND hsplit[i] = '0'; i.e. 
// if the slave has yet to signal that it can proceed with the 
// Master's transaction
// (d) If a RETRY response is received, then Master i and all 
// masters with priority < Master i are masked, if the 
// transfer isn't locked.
// (e) If a RETRY response is received to a locked transfer,
// all other masters will be masked, so that only the master
// which has received the RETRY will be able to acess the
// bus 
// In the code above "priority_i>priority_master" is used in the
// RETRY because the DW_ahb_bcm53 uses an inverted priority scheme
// (i.e. '0' has higher priority than '7'
//
// For each iteration, identify the four priority bits
// for each master, and assign to priority_i
//
    for (i=0; i<(`NUM_INT_MASTERS); i=i+1) begin
      priority_i = bus_priority >> (4*i);

      mask[i] = ((maskmaster[i] == 1'b1) || (mask_locked[i] == 1'b1)
                 || ((hresp == `SPLIT) &&
                     (hmaster_data == i) &&
                     (hready == 1'b0)) 
                 || ((rec_hsplit[i] == 1'b1) &&
                     (hsplit[i] == 1'b0)) 
                 || ((ltip  == 1'b0) &&
                     (hresp == `RETRY) &&
                     (priority_i >= priority_master) &&
                     (hready == 1'b0))
                 || ((ltip == 1'b1) && 
                     (hresp == `RETRY) &&
                     (hmaster_data != i) &&
                     (hready == 1'b0))); 
    end
  end

//
// rec_hsplit records which masters have received SPLIT responses
//
  always @ (posedge hclk or negedge hresetn)
  begin : rec_hsplit_PROC
    if (hresetn == 1'b0)
      r_rec_hsplit <= {(`NUM_INT_MASTERS){1'b0}};
    else begin
      for (j=0; j<(`NUM_INT_MASTERS);j=j+1) begin
        if ((hresp == `SPLIT) && 
            (hready == 1'b0) &&
            (hmaster_data == j))
          r_rec_hsplit[j] <= 1'b1;
        else begin
          if (hsplit[j] == 1'b1)
            r_rec_hsplit[j] <= 1'b0;
        end
      end
    end
  end
  assign rec_hsplit = {r_rec_hsplit[`NUM_AHB_MASTERS:1], 1'b0};
//#
//# Need to have a locked indication when the lock is removed
//# Need to extend it as the lock is removed before the transfer starts
//#

  always @ (posedge hclk or negedge hresetn)
  begin : extend_ltip_PROC
    if (hresetn == 1'b0)
      extend_ltip <= {1'b0};
    else begin
      if (hready == 1'b1) begin
        extend_ltip <= ltip;
      end
    end
  end

//#
//# For a master which receives a lock, need to mask all
//# other masters until this is serviced, otherwise due to prioirties
//# there could be lock out situation. This circumvents this.
//#

  always @ (posedge hclk or negedge hresetn)
  begin : mask_locked_PROC
    if (hresetn == 1'b0)
      r_mask_locked <= {`NUM_INT_MASTERS{1'b0}};
    else begin
      for (p=0; p<`NUM_INT_MASTERS;p=p+1) begin
        if ((hresp == `SPLIT) && 
            (extend_ltip == 1'b1) &&
            (hready == 1'b0) && (csilt == 1'b0) &&
            (hmaster_data != p))
          r_mask_locked[p] <= 1'b1;
        else begin
          if (est == 1'b1)
            r_mask_locked[p] <= 1'b0;
        end
      end
    end
  end
  assign mask_locked = {r_mask_locked[`NUM_AHB_MASTERS:1],1'b0};

endmodule
                        
