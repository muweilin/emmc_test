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
-- File :                       DW_ahb_gctrl.v
-- Authors:                     Ray Beechinor, Peter Gillen
-- Date :                       $Date: 2011/09/23 $ 
-- Version      :               $Revision: #4 $ 
-- Abstract     :               Arbiter Grant Control Logic
--                              Monitors the progress of AHB transfers 
--                              and updates hgrant and hmaster at the 
--                              start of each transfer.
--                      
*/
`include "DW_amba_constants.v" 
`include "DW_ahb_cc_constants.v"
`include "DW_ahb_constants.v"
module DW_ahb_gctrl (
  hclk,
  hresetn,
  ahb_sc_arb,
  hburst,
  hready,
  hresp,
  hsplit,
  htrans,
  bus_hlock,
  def_mst,
  pause,
  grant_2t,
  parked_2t,
  mask,
  set_ebt,
  bus_hbusreq,

  grant_changed,
  ibus_hbusreq,
  ltip,
  csilt,
  bus_hgrant,
  hmastlock,
  hmaster,
  new_tfr,
  est,
  arb_enable // JOE_XX: added port
);
  input                        hclk;
  input                        hresetn;
  input                        ahb_sc_arb;
  input [`HBURST_WIDTH-1:0]    hburst;
  input                        hready;
  input [`HRESP_WIDTH-1:0]     hresp;
  input [`HSPLIT_WIDTH-1:0]    hsplit;
  input [`HTRANS_WIDTH-1:0]    htrans;

//
// All hlocks from each master are combined into this bus to allow the
// hlock from the current selected bus master be used in the generation
// of the locked state machine.
//
  input [`NUM_AHB_MASTERS:0]   bus_hlock;
  input [`NUM_AHB_MASTERS:0]   bus_hbusreq;
//
// Number of Master who is default master, which is granted the bus when
// no masters are requesting the bus, provided the default master is not
// masked by a split transfer
//
  input [`HMASTER_WIDTH-1:0]  def_mst;
//
// Pause the arbitration
//
  input                       pause;
//
// From the DW_ahb_bcm53, inidcator as to who is granted the bus
//
  input [`NUM_AHB_MASTERS:0]   grant_2t;
//
// From the DW_ahb_bcm53, inidcator as to idle bus
//
  input                        parked_2t;
//
// Need to find out if a master is masked, if the default is masked when
// no one is requestiung the bus the dummy master is given the bus 
// rather than the default master
//
  input [`NUM_AHB_MASTERS:0]   mask;
//
// There is a burst on the bus which is to be terminated early
//
  input                        set_ebt;

// JOE_XX: Registered version of a grant cycle. 1 cycle dely of a grant update.
//         Used to enable the fair-amoung-equal arbiter.
  output                       arb_enable;
  
//#
//# Grant changed. Do not remove grant if this is the case
//#
  output                       grant_changed;

  output [`NUM_AHB_MASTERS:0]  ibus_hbusreq;

//
// Indicator that we are in a locked transfer, ### may be ihlock_nxt ###
//
  output                       ltip;
  output                       csilt;
//
// Combined hgrants
//
  output [`NUM_AHB_MASTERS:0]  bus_hgrant;
//
// Master processing locked transfer
//
  output                       hmastlock;
//
// Current owner of bus
//
  output [`HMASTER_WIDTH-1:0]  hmaster;
//
// New Transfer started on bus, could be an idle cycle
//
  output                       new_tfr;
  output                       est;

  parameter       N            = 3'b000;
  parameter       L            = 3'b001;
  parameter       LL           = 3'b010;
  parameter       S            = 3'b011;
  parameter       WFL          = 3'b100;

  reg                          ihmastlock;
  reg  [`NUM_AHB_MASTERS:0]    bus_hgrant;
  reg  [`HMASTER_WIDTH-1:0]    r_hmaster;
  wire [`HMASTER_WIDTH-1:0]    hmaster;
  reg                          new_tfr;
// Full width bus for the request line.
  reg [15:0]                   full_bus_hbusreq;

// current masters hlock which is next hlock register input
  reg                          ihlock_nxt;
// Aligned to data
  reg                          ihlock;
// Current state
  reg [2:0]                    lock_sm;
// Next state
  reg [2:0]                    nxt_lock_sm;
// hmaster for data control
  reg  [`HMASTER_WIDTH-1:0]    r_hmaster_d;
  wire [`HMASTER_WIDTH-1:0]    hmaster_d;
// Next hmaster value, generated from grants
  reg [`HMASTER_WIDTH-1:0]     nxt_hmaster;
// Next burst counter values
  reg [3:0]                    nxt_bc;
  reg [3:0]                    nxt_bbc;
// Burst counter values
  reg [3:0]                    bc;
  reg [3:0]                    bbc;
// Was previously in normal mode.
  reg                          wasinn;
// Registered version of bus_hgrant;
  reg [`NUM_AHB_MASTERS:0]     hgrant_previous;

//
// If a split response is received at the start of a locked
// transfer do not let the split update the grant lines.
//
  reg                          csilt;

  reg [15:0]                   extend_mask;

  reg                          arb_enable; // JOE_XX: register for new output port
  
// Dummy Master Decode
  wire [`NUM_AHB_MASTERS:0]    dec_dummym;
// Next Burst Counter Equals 0
  wire                         nbcez;
// Next Burst Counter Equals 1 and hready active
  wire                         nbce1ah;
// Next State Locked Transfer
  wire                         nslt;    
// End Split Transfer
  wire                         est;     
// Update hgrants
  wire                         uhgrant; 
// nslt and Response or End of Split
  wire                         nsltar;  
// Update Data's Hmaster
  wire                         udhm;    
// Update Burst Counter
  wire                         ubc;
// Remove Grant from whoever has it
  wire                         remove_grant;
// Update hgrant qualifier
  wire                         ugq;
// Grant changed signal
  wire                         grant_changed;
// Cancel update of hgrant when the count is 0 and we are completing
// a burst as the decision is made when the count is 1. Only for
// fixed length bursts.
  wire                         cupdate;
//#
//# Generate an internal pause if configured to do so from either
//# the pause input or else from the delayed pause. This may be
//# an output.
//#
  wire                         dpause;
  wire                         ipause;
// loop variables
  integer                      i;
  integer                      j;
  integer                      l;
  integer                      s;

//
// Need all the lock signals from each of the masters so that they are
// only used when the correct corresponding master is driving the
// address and control lines. Cycle through each of the masters and if
// the lock bit is set and the nxt_hmaster matches the master number, 
// which it will match to only one, many hlocks could be set, then the 
// ihlock is set. Need to know if there is going to be a locked
// transaction on the bus, use this as a guide. The address on the bus
// needs to be qualified with hmastlock directly.
//
  always @(bus_hlock or nxt_hmaster or hready) 
  begin : ihlock_nxt_PROC
    ihlock_nxt = 1'b0;
    for (i=0;i<=`NUM_AHB_MASTERS;i=i+1) begin
      ihlock_nxt = ((bus_hlock[i] == 1'b1) && 
                    (nxt_hmaster == i) && 
                    (hready == 1'b1)) || 
                    ihlock_nxt;
    end
  end

//
// Want to hold onto the fact that there was a lock on the bus so that
// the additonal cycle can be added after the lock when the master
// should be sending out an idle cycle
//
  always @(posedge hclk or negedge hresetn)
  begin : ihlock_PROC
    if (hresetn == 1'b0) begin
      ihlock <= 1'b0;
    end else begin
      if (hready == 1'b1) begin
        ihlock <= ihlock_nxt;
      end 
    end
  end

//
// Need to know what the transfer is and the effect it is going to have
// on updating hgrants, hmaster and also the burst count. When there is
// no activity on the bus one can update the grants. When there are 
// single transfers one can update the grants. During bursts the master
// may or may not deassert its grant request. To prevent this of been 
// a problem, when in a burst whether it is wrapping or incrementing
// one needs to hold onto the grant until the count reaches 1 and then
// when hready is active, change the grants if needed.
//
// When set_ebt is active and hready is active then terminate the burst
// Do not do this if we are to start generating a locked transfer
// or if one is in progress
//
// When one receives a split then we need to allow the grant to be changed
// after the first phase of the two cycle error response. If in the second
// cycle we receive a non idle then we just load up the counter so that it
// will not terminate the burst counter prematurely.
//

  assign remove_grant = ((set_ebt == 1'b1) && (ltip == 1'b0) && (grant_changed == 1'b0));

  always @(hresp or htrans or hburst or bc or remove_grant or hready or ahb_sc_arb)
  begin : nxt_bc_PROC
    if ((remove_grant == 1'b1) ||
        ((hresp  == `SPLIT) && (hready == 1'b0)) || 
        ((hresp  == `RETRY) && (hready == 1'b0)) || 
        ((hresp  == `SPLIT) && (htrans == `IDLE)) || 
        ((hresp  == `RETRY) && (htrans == `IDLE)) ||
        (htrans == `IDLE) || (ahb_sc_arb == 1'b1) ||
        ((hburst == `INCR) && (`AHB_FULL_INCR == 0)) || 
        (hburst == `SINGLE)) begin
       nxt_bc = 4'b0000;
    end else begin
      if (((hburst == `INCR16) || (hburst == `WRAP16)) &&
          (htrans == `NONSEQ)) begin
        nxt_bc = 4'b1111;
      end else begin
        if (((hburst == `INCR8) || (hburst == `WRAP8)) &&
            (htrans == `NONSEQ)) begin
          nxt_bc = 4'b0111;
        end else begin
          if (((hburst == `INCR4) || (hburst == `WRAP4)) &&
              (htrans == `NONSEQ)) begin
            nxt_bc = 4'b0011;
          end else begin
            if ((hburst == `INCR) && (`AHB_FULL_INCR == 1)) begin
              nxt_bc = 4'b1111;
            end else begin
              if (bc == 4'b0000) begin
                nxt_bc = 4'b0000;
              end else begin
                nxt_bc = bc - 4'b0001;
              end
            end
          end
        end
      end
    end
  end

//
// Update burst counter provided the burst is not waited and
// that the current transfer is valid.
//
  assign ubc = ((hready == 1'b1) && 
                      (htrans == `SEQ || htrans == `NONSEQ));

  always @(posedge hclk or negedge hresetn)
  begin : bc_PROC
    if (hresetn == 1'b0) begin
      bc <= 4'b0000;
    end else begin
      if (ubc == 1'b1) begin
        bc <= nxt_bc;
      end
    end
  end

// Register the bus_hgrant signals into hgrant_previous 
// Update every cycle to catch the highest priority
// Allows one to be able to regenerate the previous master

  always @ (posedge hclk or negedge hresetn) begin : hgntprev_PROC
    if (hresetn == 1'b0) begin
      hgrant_previous <= {`NUM_INT_MASTERS{1'b1}};
    end else begin
      hgrant_previous <= bus_hgrant;
    end
  end

//
// status register for the defined
// length burst beat counter.
// Need to update this with hready provided the transfers are SEQ/NONSEQ
//
   always @(posedge hclk or negedge hresetn)
   begin : bbc_PROC
      if (hresetn == 1'b0) begin
        bbc <= 4'b0000;
      end else begin
         if(ubc == 1'b1) begin
            bbc <= nxt_bbc;
        end
      end
   end
  
// produce a 0 over the address phase
// of the last beat of a defined length
// burst, or whenever hburst is not defined
// length.
   always @(hburst or htrans or bbc)
   begin : nxt_bbc_PROC
     if (hburst > `INCR) begin
       case (htrans)
        `NONSEQ : case (hburst[2:1])
                   1       : nxt_bbc = 4'b0011;
                   2       : nxt_bbc = 4'b0111;
                   default : nxt_bbc = 4'b1111;
                  endcase
        `SEQ    : nxt_bbc = bbc - 4'b0001;
        `IDLE   : nxt_bbc = 4'b0000;
        default : nxt_bbc = bbc;
       endcase
     end else begin
       nxt_bbc = 4'b0000;
     end
   end

//
// Overwrites to 1 the bus request signal of
// the current bus owner when nxt_bbc
// is greater than 1.
//
// The hmaster index is restricted from accessing a location that
// is not within range but the formality tools do not like it. So
// the bus that is extracted from is of full width and then the
// relevant bits are extratced from this full bus.
//

   always @(nxt_bbc or bus_hbusreq or hmaster)
   begin : ihbusreq_PROC
     full_bus_hbusreq = bus_hbusreq;
     if(nxt_bbc > 4'b0001) begin
       full_bus_hbusreq[hmaster] = 1'b1;
     end
   end

   assign ibus_hbusreq = full_bus_hbusreq[`NUM_AHB_MASTERS:0];

//
// Assert grant_changed if bus_hgrant not equal to hgrant_previous
// So the master is granted the bus for two cycles.
// Allows burst to complete without being Early Burst Terminated
// Allow calculation of hrants when hready is low.

//#
//# Added in additional control so that if the bus is given to the
//# dummy master that another master will be granted in the next
//# cycle if it starts requesting rather than having to wait for
//# an additional cycle.
//#
  assign grant_changed = (bus_hgrant[0] == 1'b0) && (hgrant_previous != bus_hgrant) && (hready == 1'b1) && (ahb_sc_arb == 1'b0);

//
// There are times when one does not want to update grant signals,
// and times when it is no problem if the grants change. One wants
// to keep the bus running freely so the grants can be allowed change
// in the penultimate cycle of a fixed length burst. If during a
// split locked transfer, the default master is selected and granted
// need to allow for all these cases.

// Cancel the update when count is zero if we are doing a burst.
// Take the decision from count equal 1. Does not start a burst
// and then early terminated it.

//
// Do not allow RETRY and SPLIT change the grant when we have
// locked transfers.
//
// If the first beat of a burst does not receive a OKAY response
// then do not cancel the updating of grants as the grants will
// need to change.

  assign cupdate = ((hburst > `INCR) && (htrans == `SEQ)) &&
                   (hresp == `OKAY);

  assign est     = (nxt_hmaster == hmaster_d) && (lock_sm == S);
  assign nslt    = (nxt_lock_sm != N);
  assign nbcez   = ((nxt_bc == 4'b0000) && (cupdate == 1'b0));
  assign nbce1ah = ((nxt_bc == 4'b0001) && (hready == 1'b1));
//
// Want to ignore busy cycle for incremental transfers only
// will allow them for fixed length bursts not to change 
// the grants unless of course we are on the final beat
// of a burst when it is allowed to lose the grant.
//

  assign nsltar  = (((nslt == 1'b1) && (hresp == `SPLIT) && (lock_sm != N) && (csilt == 1'b0)) || 
                     ((nslt == 1'b0) && ((htrans != `BUSY) || (nbcez == 1'b1))));
  assign ugq     = (((hresp == `RETRY) || (hresp == `SPLIT)) && (nxt_lock_sm == N) && (hready == 1'b0));
//
// Whenever there is a split or a retry then the nxt_bc is changed to
// 1 and the grant needs to be updated.
// Whenever there is an update of the pause need to be able to see it.
//
  assign uhgrant =  ((((nbce1ah == 1'b1) || (nbcez == 1'b1)) && 
                          (nsltar == 1'b1) &&
                          (grant_changed == 1'b0)) || (lock_sm == N && nxt_lock_sm == N && ahb_sc_arb == 1'b1) ||
                       (ugq == 1'b1) || (lock_sm == S)) || (ipause == 1'b1);

  // JOE_XX: Register uhgrant to generate arb_enable
  always @(posedge hclk or negedge hresetn)
  begin : arb_2t_enable_PROC
    if (hresetn == 1'b0)
      arb_enable <= 1'b0;
    else
      arb_enable <= uhgrant;
  end

//
// bus_hgrant is all the hgrants for each of the masters in a bussed
// form. The update of hgrant is controlled by uhgrant, which is high
// when not performing a locked transfer, and during the last two
// transfers of a fixed length burst, when hready is active with the
// count at 1, and during a locked split transfer when the default
// master needs to be selected. The dummy master is selected upon reset.
// 
// If the next state is a locked split transfer and a split response
// is received then the default master is given the bus
//
// If last locked transfer receives a retry or at the end of a split 
// transfer, give the bus to the previous master
//
// If there are no requesting bus masters, parked_2t is active and the 
// default master is given the bus. But if the default master is
// masked then give the bus to the dummy master.
//
// If an burst is to be terminated early then give the bus to the 
// dummy master
//
// If the pause mode is requested then give the bus to the dummy master
//
// If a RETRY occurs then lower priority masters are masked and
// if no one is looking for the bus then we are parked and the
// current grant status is maintained by reloading the previous
// grant status. Hence the retried master is re-granted the bus.
// Using the hmaster_d to calculate who was granted the bus as the
// previous granted could have changed when hready was low.

  assign dec_dummym = {{`NUM_AHB_MASTERS{1'b0}},1'b1};

//
// Need to expand the mask from the NUM_AHB_MASTERS+1 bits wide to
// 16-bits wide so that there is no issue with the def_mst exceeding
// the number of bits. By design it will not but the synthesis
// compiler thinks it will.
//
  always @(mask)
  begin : extend_mask_PROC
    extend_mask = 16'b0;
    extend_mask[`NUM_AHB_MASTERS:0] = mask;
  end

//#
//# Adding in additional optional functionality on pause mode.
//# If one selects default mode with PAUSE then as soon as the
//# pause is received the dummy master is granted.
//# If one selects delayed pause mode with AHB_DELAYED_PAUSE
//# then only when the pause is active, htrans is idle and
//# hready is 1 is the control handed to the dummy master
//#
//# dpause is the delayed pause control.
//# ipause is the resolved pause control.
//#

  assign dpause = (pause == 1'b1) && (htrans == `IDLE);
  assign ipause = (`AHB_DELAYED_PAUSE == 1'b1) ? dpause : pause;

//
// When removing the grant lines because of an arb interrupt we only
// want to do so whenever we are not within a locked sequence of any sort
//
  always @(posedge hclk or negedge hresetn)
  begin : bus_hgrant_PROC
    if (hresetn == 1'b0)
      bus_hgrant <= {{`NUM_AHB_MASTERS{1'b0}},1'b1};
    else
      if (uhgrant == 1'b1) begin
        if (((nslt == 1'b1) && (hresp == `SPLIT) && (hready == 1'b0)) || 
            (remove_grant == 1'b1) || (ipause == 1'b1)) begin
          bus_hgrant <= dec_dummym;
        end else begin
          if (parked_2t == 1'b1) begin
            if ((hresp == `RETRY) && (hready == 1'b0)) begin
              for (j=0;j<=`NUM_AHB_MASTERS;j=j+1) begin
                bus_hgrant[j] <= (hmaster_d == j[3:0]);
              end
            end else begin
              if (extend_mask[def_mst] == 1'b1) begin
                bus_hgrant <= dec_dummym;
              end else begin
                for (j=0;j<=`NUM_AHB_MASTERS;j=j+1) begin
                  bus_hgrant[j] <= (def_mst == j[3:0]);
                end
              end
            end
          end else begin
            bus_hgrant <= grant_2t;
          end
        end
      end else begin
        if (remove_grant == 1'b1) begin
          bus_hgrant <= dec_dummym;
        end
      end 
  end

//
// Need to control and select, the appropriate address and control lines
// for any of the masters within the system. Need to know who is master
// for the system. From the currently granted bus master can derive who
// owns the bus. The hgrants are encoded as 1's hot. The dummy master
// is assigned the bus at all times, and only when a hgrant is active is
// the bus given to another master. Could use grant_index_2t but then
// would have to worry about aligning to the hgrants etc so decided to
// use the hgrants to generate the hmaster.
//
  always @(bus_hgrant or def_mst)
  begin : nxt_hmaster_PROC
    nxt_hmaster = def_mst;
    for (l=0;l<=`NUM_AHB_MASTERS;l=l+1) begin
      if (bus_hgrant[l] == 1'b1) begin
        nxt_hmaster = l[3:0];
      end
    end
  end

  always @(posedge hclk or negedge hresetn)
  begin : hmaster_PROC
    if (hresetn == 1'b0) begin
      r_hmaster <= {`HMASTER_WIDTH{1'b0}};
    end else begin
      if (hready == 1'b1) begin
        r_hmaster <= nxt_hmaster;
      end
    end
  end
//#
//# Do not to create any unnecessary registers. Eliminating unless the number
//# of masters requires the bit to exist. The hmaster stays as 4 bits
//# wide but the upper bits are tied to 0.
//#
  assign hmaster[3] = (`NUM_AHB_MASTERS >= 8) ? r_hmaster[3] : 1'b0;
  assign hmaster[2] = (`NUM_AHB_MASTERS >= 4) ? r_hmaster[2] : 1'b0;
  assign hmaster[1] = (`NUM_AHB_MASTERS >= 2) ? r_hmaster[1] : 1'b0;
  assign hmaster[0] = r_hmaster[0];
//
// Want to have a signal which one cycle later tells me I
// was in normal mode. So that I can update the data master
// with the correct value
//

  always @(posedge hclk or negedge hresetn)
  begin : wasinn_PROC
    if (hresetn == 1'b0) begin
      wasinn <= 1'b0;
    end else begin
      if (hready == 1'b1) begin
        if (lock_sm == N) begin
          wasinn <= 1'b1;
        end else begin
          wasinn <= 1'b0;
        end
      end
    end
  end

//
// hmaster_d is the stored bus master which signifies which master
// currently controls the data bus, and should not change if the
// previous transfer is being waited or if there was a locked
// transfer. If there is going to be a locked transfer then need
// to allow it be updated. Allow the update of the data hmaster 
// when none of the above conditions are valid
//

  assign udhm = (((hready == 1'b1) && (wasinn == 1'b1)) || 
                  (lock_sm == LL));

  always @(posedge hclk or negedge hresetn)
  begin : hmaster_d_PROC
    if (hresetn == 1'b0) begin
      r_hmaster_d <= {`HMASTER_WIDTH{1'b0}};
    end else begin
      if (udhm == 1'b1) begin
        r_hmaster_d <= hmaster;
      end
    end
  end

  assign hmaster_d[3] = (`NUM_AHB_MASTERS >= 8) ? r_hmaster_d[3] : 1'b0;
  assign hmaster_d[2] = (`NUM_AHB_MASTERS >= 4) ? r_hmaster_d[2] : 1'b0;
  assign hmaster_d[1] = (`NUM_AHB_MASTERS >= 2) ? r_hmaster_d[1] : 1'b0;
  assign hmaster_d[0] = r_hmaster_d[0];

//#
//# The arbiter needs to indicate that the current transfer is part of
//# a locked sequence, and is valid during the address phase of locked
//# transfer only. Registering the output to help the DW_ahb_icm.
//#
  always @(posedge hclk or negedge hresetn)
  begin
    if (hresetn == 1'b0)
      ihmastlock <= 1'b0;
    else
      ihmastlock <= (nxt_lock_sm == L);
  end
  assign hmastlock = ihmastlock;

//
// Whenever a new transfer starts on the bus or whenever there is no
// activity on the bus, send an indicator to the early burst
// termination logic that a new transfer has begun on the bus. The
// EBT logic then restarts its counter.
//
// If there is a locked transfer in progress this is the same as a new
// transfer, therefore do not generate an interrupt.
//
  always @ (htrans or ihlock)
  begin : new_tfr_PROC
    if (((htrans == `NONSEQ) || (htrans == `IDLE)) || (ihlock == 1'b1))
      new_tfr = 1'b1;
    else
      new_tfr = 1'b0;
  end

//
// Need to know when a locked transfer starts, maybe the ihlock_nxt
//

// Whenever the state machine is in locked mode
  assign ltip = (nxt_lock_sm != N);

//
// Have a present state next state arrangement on the lock mode
// state machine. Need to know where we are and also where we are
// going to whether there is a pending locked transfer coming or 
// a split transfer during a locked transfer.
//

  always @(posedge hclk or negedge hresetn)
  begin : lock_sm_PROC
    if (hresetn == 1'b0)
      lock_sm <= N;
    else
      lock_sm <= nxt_lock_sm;
  end

  always @(lock_sm or hready or ihlock_nxt or htrans or
           hresp or nxt_hmaster or hmaster_d or csilt or hmaster)
  begin : next_lock_sm_PROC
    case (lock_sm)

//
// During the L-state, grant outputs will not change, and one is now
// currently performing a locked transfer. While locked one is looking
// for splits which mean that other masters will not get onto the bus
// plus also looking for end of locked transfers plus back to back 
// locked, no lock transfers. Do not transfer state when master sending
// out BUSY, as hmastlock is generated from the state decode.
//
// If there is a SPLIT and no change in the bus ownership then
// need to cancel the hmastlock and remove the grant.
//
      L  : if ((hready == 1'b1) && (htrans != `BUSY)) begin
             if (ihlock_nxt == 1'b1)
               nxt_lock_sm = L;
             else
               nxt_lock_sm = LL;
           end else begin
             if ((hresp == `SPLIT) && (csilt == 1'b0))
               nxt_lock_sm = S;
             else begin
               if ((csilt == 1'b1) && (hmaster == hmaster_d) && ((hresp == `RETRY) || (hresp == `SPLIT))) begin
                 nxt_lock_sm = N;
               end else begin
                 nxt_lock_sm = L;
               end
             end
           end
//
// When the currently granted master's hlock is brought low, one needs 
// to add an extra locked transfer cycle. Ensuring that the grant 
// outputs do not change until the data phase of the last valid locked
// transfer has completed
//
      LL : if ((hready == 1'b1) && (htrans != `BUSY)) begin
             if ((ihlock_nxt == 1'b1) || (hresp == `RETRY))
               nxt_lock_sm = L;
             else
               nxt_lock_sm = N;
           end else begin
             if (hresp == `SPLIT)
               nxt_lock_sm = S;
             else
               if (hresp == `RETRY)
                 nxt_lock_sm = WFL;
               else
                 nxt_lock_sm = LL;
           end
//
// Whenever we are in the S state, one has received a split to a locked 
// transfer. With the locked transfer no new masters can be given the
// bus, but as the currently granted master has been split it may not
// have control of the bus back until the slave indicates its split 
// respone which then unmasks the current master and one returns to the 
// locked transfer
//
      S  : if ((hready == 1'b1) && 
               (nxt_hmaster == hmaster_d))
             if (ihlock_nxt)
               nxt_lock_sm = L;
             else
               nxt_lock_sm = WFL;
           else
             nxt_lock_sm = S;

//
// Waiting for the replay of the locked transfer after we got a
// RETRY over the last locked transfer of a sequence.
//
     WFL : begin
             if ((hready == 1'b1) && (ihlock_nxt == 1'b1))
               nxt_lock_sm = L;
             else
               nxt_lock_sm = WFL;
           end
// Cover all options 

//
// During the N-state the arbiter is functioning normally with no
// special locked transfers being performed. And having only the 
// hlock of the current bus master move on to L-state whenever hready
// is active.
//

      default  : if ((hready == 1'b1) &&
                     (ihlock_nxt == 1'b1)) begin
                   nxt_lock_sm = L;
                 end else begin
                   nxt_lock_sm = N;
                 end
    endcase
  end

//
// Cancel split in locked transfer. For first cycle anyway. So that the
// split is not interpeted as part of the locked transfer.
//
  always @(posedge hclk or negedge hresetn)
  begin
    if (hresetn == 1'b0) begin
      csilt <= 1'b0;
    end else begin
      if (((lock_sm == LL) || (lock_sm == N)) && (nxt_lock_sm == L)) begin
        csilt <= 1'b1;
      end else begin
        if (hready == 1'b1) begin
          csilt <= 1'b0;
        end
      end
    end
  end

endmodule
