//********************************************************************************//
//**********            (C) Copyright 2011 SMIC Inc.                    **********//
//**********                SMIC Verilog Models                         **********//
//********************************************************************************//
//       FileName   : SP55NLLD2RP_OV3_V0p2a.v                                      //
//       Function   : Verilog Models (zero timing)                                //
//       Version    : 0.2                                                         //
//       Author     : Shawn_Zhou                                                  //
//       CreateDate : Nov-16-2011                                                 //
//********************************************************************************//
////////////////////////////////////////////////////////////////////////////////////
//DISCLAIMER                                                                      //
//                                                                                //
//   SMIC hereby provides the quality information to you but makes no claims,     //
// promises or guarantees about the accuracy, completeness, or adequacy of the    //
// information herein. The information contained herein is provided on an "AS IS" //
// basis without any warranty, and SMIC assumes no obligation to provide support  //
// of any kind or otherwise maintain the information.                             //
//   SMIC disclaims any representation that the information does not infringe any //
// intellectual property rights or proprietary rights of any third parties.SMIC   //
// makes no other warranty, whether express, implied or statutory as to any       //
// matter whatsoever,including but not limited to the accuracy or sufficiency of  //
// any information or the merchantability and fitness for a particular purpose.   //
// Neither SMIC nor any of its representatives shall be liable for any cause of   //
// action incurred to connect to this service.                                    //
//                                                                                //
// STATEMENT OF USE AND CONFIDENTIALITY                                           //
//                                                                                //
//   The following/attached material contains confidential and proprietary        //
// information of SMIC. This material is based upon information which SMIC        //
// considers reliable, but SMIC neither represents nor warrants that such         //
// information is accurate or complete, and it must not be relied upon as such.   //
// This information was prepared for informational purposes and is for the use    //
// by SMIC's customer only. SMIC reserves the right to make changes in the        //
// information at any time without notice.                                        //
//   No part of this information may be reproduced, transmitted, transcribed,     //
// stored in a retrieval system, or translated into any human or computer         //
// language, in any form or by any means, electronic, mechanical, magnetic,       //
// optical, chemical, manual, or otherwise, without the prior written consent of  //
// SMIC. Any unauthorized use or disclosure of this material is strictly          //
// prohibited and may be unlawful. By accepting this material, the receiving      //
// party shall be deemed to have acknowledged, accepted, and agreed to be bound   //
// by the foregoing limitations and restrictions. Thank you.                      //
////////////////////////////////////////////////////////////////////////////////////

// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbcd2r.v
// Description          : 3-state Output Pad with Input and Controllable Pull-down, 2X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBCD2R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults



// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbcd4r.v
// Description          : 3-state Output Pad with Input and Controllable Pull-down, 4X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBCD4R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbcd8r.v
// Description          : 3-state Output Pad with Input and Controllable Pull-down, 8X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBCD8R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end


`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbcd12r.v
// Description          : 3-state Output Pad with Input and Controllable Pull-down, 12X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBCD12R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end


`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults

// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbcd16r.v
// Description          : 3-state Output Pad with Input and Controllable Pull-down, 16X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBCD16R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end


`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults

// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbcd24r.v
// Description          : 3-state Output Pad with Input and Controllable Pull-down, 24X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBCD24R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end


`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults

// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbcdl8r.v
// Description          : 3-state Output Pad with Input,Limited Slew Rate and Controllable Pull-down, 8X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBCDL8R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end


`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbcdl12r.v
// Description          : 3-state Output Pad with Input,Limited Slew Rate and Controllable Pull-down, 12X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBCDL12R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end


`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbcdl16r.v
// Description          : 3-state Output Pad with Input,Limited Slew Rate and Controllable Pull-down, 16X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBCDL16R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end


`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults




// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbcdl24r.v
// Description          : 3-state Output Pad with Input,Limited Slew Rate and Controllable Pull-down, 24X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBCDL24R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end


`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults

 
// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbcu12r.v
// Description  	: 3-state Output Pad with Input and Controllable Pull-up, 12X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBCU12R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 
// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbcu16r.v
// Description  	: 3-state Output Pad with Input and Controllable Pull-up, 16X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBCU16R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 

 
// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbcu2r.v
// Description  	: 3-state Output Pad with Input and Controllable Pull-up, 2X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBCU2R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 

 
// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbcu24r.v
// Description  	: 3-state Output Pad with Input and Controllable Pull-up, 24X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBCU24R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 

 
// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbcu4r.v
// Description  	: 3-state Output Pad with Input and Controllable Pull-up, 4X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBCU4R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 

 
// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbcu8r.v
// Description  	: 3-state Output Pad with Input and Controllable Pull-up, 8X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBCU8R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 

 
// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbcul12r.v
// Description  	: 3-state Output Pad with Input,Limited Slew Rate and Controllable Pull-up, 12X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBCUL12R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 

 
// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbcul16r.v
// Description  	: 3-state Output Pad with Input,Limited Slew Rate and Controllable Pull-up, 16X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBCUL16R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 

 
// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbcul24r.v
// Description  	: 3-state Output Pad with Input,Limited Slew Rate and Controllable Pull-up, 24X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBCUL24R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 

 
// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbcul8r.v
// Description  	: 3-state Output Pad with Input,Limited Slew Rate and Controllable Pull-up, 8X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBCUL8R (PAD,IE,OEN,REN,I,C);

output  C;
input   OEN,I,REN;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 
// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbs12r.v
// Description  	: CMOS 3-state Output Pad with Schmitt Trigger Input 
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBS12R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

and    #0.01 (C,PAD,IE);
bufif0 #0.01 (PAD,I,OEN);

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 
// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbs16r.v
// Description  	: CMOS 3-state Output Pad with Schmitt Trigger Input 
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBS16R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

and    #0.01 (C,PAD,IE);
bufif0 #0.01 (PAD,I,OEN);

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 
// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbs2r.v
// Description  	: CMOS 3-state Output Pad with Schmitt Trigger Input 
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBS2R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

and    #0.01 (C,PAD,IE);
bufif0 #0.01 (PAD,I,OEN);

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 
// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbs24r.v
// Description  	: CMOS 3-state Output Pad with Schmitt Trigger Input 
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBS24R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

and    #0.01 (C,PAD,IE);
bufif0 #0.01 (PAD,I,OEN);

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 
// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbs4r.v
// Description  	: CMOS 3-state Output Pad with Schmitt Trigger Input 
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBS4R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

and    #0.01 (C,PAD,IE);
bufif0 #0.01 (PAD,I,OEN);

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 
// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbs8r.v
// Description  	: CMOS 3-state Output Pad with Schmitt Trigger Input 
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBS8R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

and    #0.01 (C,PAD,IE);
bufif0 #0.01 (PAD,I,OEN);

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbsl12r.v
// Description  	: CMOS 3-state Output Pad with Schmitt Trigger Input and Limited Slew Rate, 12X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBSL12R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

and    #0.01 (C,PAD,IE);
bufif0 #0.01 (PAD,I,OEN);

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 
// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbsl16r.v
// Description  	: CMOS 3-state Output Pad with Schmitt Trigger Input and Limited Slew Rate, 16X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBSL16R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

and    #0.01 (C,PAD,IE);
bufif0 #0.01 (PAD,I,OEN);

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 
// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbsl24r.v
// Description  	: CMOS 3-state Output Pad with Schmitt Trigger Input and Limited Slew Rate, 24X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBSL24R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

and    #0.01 (C,PAD,IE);
bufif0 #0.01 (PAD,I,OEN);

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 
// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
// 
// Model type   	: zero timing
// Filename     	: pbsl8r.v
// Description  	: CMOS 3-state Output Pad with Schmitt Trigger Input and Limited Slew Rate, 8X Drive
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module PBSL8R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

and    #0.01 (C,PAD,IE);
bufif0 #0.01 (PAD,I,OEN);

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
 
// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsd2r.v
// Description          : CMOS 3-state output pad with schmitt trigger input and pulldown
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSD2R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults



// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsd4r.v
// Description          : CMOS 3-state output pad with schmitt trigger input and pulldown
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSD4R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsd8r.v
// Description          : CMOS 3-state output pad with schmitt trigger input and pulldown
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSD8R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsd12r.v
// Description          : CMOS 3-state output pad with schmitt trigger input and pulldown
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSD12R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsd16r.v
// Description          : CMOS 3-state output pad with schmitt trigger input and pulldown
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSD16R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsd24r.v
// Description          : CMOS 3-state output pad with schmitt trigger input and pulldown
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSD24R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsdl8r.v
// Description          : CMOS 3-state output pad with schmitt trigger input,pulldown,and limited slew rate
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSDL8R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsdl12r.v
// Description          : CMOS 3-state output pad with schmitt trigger input,pulldown,and limited slew rate
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSDL12R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsdl16r.v
// Description          : CMOS 3-state output pad with schmitt trigger input,pulldown,and limited slew rate
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSDL16R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsdl24r.v
// Description          : CMOS 3-state output pad with schmitt trigger input,pulldown,and limited slew rate
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSDL24R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my0,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsu2r.v
// Description          : CMOS 3-state output pad with schmitt trigger input and pullup
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSU2R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults

// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsu4r.v
// Description          : CMOS 3-state output pad with schmitt trigger input and pullup
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSU4R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsu8r.v
// Description          : CMOS 3-state output pad with schmitt trigger input and pullup
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSU8R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsu12r.v
// Description          : CMOS 3-state output pad with schmitt trigger input and pullup
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSU12R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsu16r.v
// Description          : CMOS 3-state output pad with schmitt trigger input and pullup
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSU16R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsu24r.v
// Description          : CMOS 3-state output pad with schmitt trigger input and pullup
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSU24R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsul8r.v
// Description          : CMOS 3-state output pad with schmitt trigger input,pullup,and limited slew rate
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSUL8R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsul12r.v
// Description          : CMOS 3-state output pad with schmitt trigger input,pullup,and limited slew rate
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSUL12R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsul16r.v
// Description          : CMOS 3-state output pad with schmitt trigger input,pullup,and limited slew rate
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSUL16R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults

// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pbsul24r.v
// Description          : CMOS 3-state output pad with schmitt trigger input,pullup,and limited  slew rate
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PBSUL24R (PAD,IE,OEN,I,C);

output  C;
input   OEN,I;
inout   PAD;
input   IE;

  supply1 my1;
  supply0 my0;
  bufif0  (C_buf, I, OEN);
  pmos    (PAD,C_buf,my0);
  and        (C,PAD,IE);
  rpmos   #0.01 (C_buf,my1,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0,
 i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,
oen_hl_pad_zl);
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC  Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : picdr.v
// Description          : Input Pad with Controllable Pull-down
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PICDR (PAD,IE,REN,C);

output  C;
input   PAD,IE,REN;

  supply0 my0;
  and        (C,PAD,IE);
  rpmos   #0.01 (PAD,my0,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0;
// Delays
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults



// ****** (C) Copyright 2011 SMIC  Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : picur.v
// Description          : Input Pad with Controllable Pull-up
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PICUR (PAD,IE,REN,C);

output  C;
input   PAD,IE,REN;

  supply1 my1;
  and        (C,PAD,IE);
  rpmos   #0.01 (PAD,my1,REN);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0;
// Delays
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pisr.v
// Description          : Schmitt Trigger Input Pad
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PISR (PAD,IE,C);

output  C;
input   PAD,IE;

and    #0.01 (C,PAD,IE);

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0;
// Delays
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults

// ****** (C) Copyright 2011 SMIC  Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pisdr.v
// Description          : schmitt trigger input pad with pulldown
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PISDR (PAD,IE,C);

output  C;
input   PAD,IE;

  supply0 my0;
  and        (C,PAD,IE);
  rpmos   #0.01 (PAD,my0,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0;
// Delays
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults

// ****** (C) Copyright 2011 SMIC  Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pisur.v
// Description          : schmitt trigger input pad with pullup
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PISUR (PAD,IE,C);

output  C;
input   PAD,IE;

  supply1 my1;
  supply0 my0;
  and        (C,PAD,IE);
  rpmos   #0.01 (PAD,my1,my0);

   always @(PAD) begin
     if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
         $countdrivers(PAD))
        $display("%t --BUS CONFLICT-- : %m", $realtime);
   end

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_c_lh=0,pad_hl_c_hl=0,
 ie_lh_c_lz=0,ie_hl_c_zh=0,ie_lh_c_hz=0,ie_hl_c_zl=0;
// Delays
 (        IE  => C) = (ie_lh_c_lz,ie_lh_c_hz,ie_lh_c_lz,ie_hl_c_zh,ie_lh_c_hz,ie_hl_c_zl);
 (        PAD   +=> C) = (pad_lh_c_lh,pad_hl_c_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults

// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : px1r.v
// Description          : Crystal Oscillator
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PX1R (XIN,XOUT,XC);

output  XC;
input   XIN;
output  XOUT;

  not   (XOUT,XIN);
  buf   (XC  ,XIN);
`ifdef functional
`else
specify
// Parameter declarations
 specparam xin_lh_xout_hl=0,xin_hl_z_hl=0,xin_hl_xout_lh=0,xin_lh_z_lh=0;
// Delays
 (        XIN -=> XOUT) = (xin_hl_xout_lh,xin_lh_xout_hl);
 (        XIN +=> XC   ) = (xin_lh_z_lh,xin_hl_z_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 10ps

// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : px2r.v
// Description          : Crystal Oscillator
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PX2R (XIN,XOUT,XC);

output  XC;
input   XIN;
output  XOUT;

  not   (XOUT,XIN);
  buf   (XC  ,XIN);
`ifdef functional
`else
specify
// Parameter declarations
 specparam xin_lh_xout_hl=0,xin_hl_z_hl=0,xin_hl_xout_lh=0,xin_lh_z_lh=0;
// Delays
 (        XIN -=> XOUT) = (xin_hl_xout_lh,xin_lh_xout_hl);
 (        XIN +=> XC   ) = (xin_lh_z_lh,xin_hl_z_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 10ps

// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : px3r.v
// Description          : Crystal Oscillator
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PX3R (XIN,XOUT,XC);

output  XC;
input   XIN;
output  XOUT;

  not   (XOUT,XIN);
  buf   (XC  ,XIN);
`ifdef functional
`else
specify
// Parameter declarations
 specparam xin_lh_xout_hl=0,xin_hl_z_hl=0,xin_hl_xout_lh=0,xin_lh_z_lh=0;
// Delays
 (        XIN -=> XOUT) = (xin_hl_xout_lh,xin_lh_xout_hl);
 (        XIN +=> XC   ) = (xin_lh_z_lh,xin_hl_z_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 10ps

// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pxwe1r.v
// Description          : Crystal Oscillator Circuit With High Enable
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PXWE1R (XIN,XOUT,XC,E);

output  XC;
input   XIN,E;
output  XOUT;

  nand           G2(XOUT,XIN,E);
  and            G5( XC ,XIN,E);

`ifdef functional
`else
specify
// Parameter declarations
 specparam e_lh_xc_lh_1=0,e_lh_xout_hxc=0,e_hl_xc_hl=0,
 e_hl_xout_xch=0,xin_lh_xout_hl=0,e_lh_xout_lxc=0,
 e_hl_xout_xcl=0,xin_hl_xc_hl=0,xin_hl_xout_lh=0,xin_lh_xc_lh=0;
// Delays
 (        E   => XOUT) = (e_lh_xout_lxc,e_lh_xout_hxc,e_lh_xout_lxc,e_hl_xout_xch,e_lh_xout_hxc,e_hl_xout_xcl);
 (        E  +=> XC   ) = (e_lh_xc_lh_1,e_hl_xc_hl);
 (        XIN -=> XOUT) = (xin_hl_xout_lh,xin_lh_xout_hl);
 (        XIN +=> XC   ) = (xin_lh_xc_lh,xin_hl_xc_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 10ps

// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pxwe2r.v
// Description          : Crystal Oscillator Circuit With High Enable
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PXWE2R (XIN,XOUT,XC,E);

output  XC;
input   XIN,E;
output  XOUT;

  nand           G2(XOUT,XIN,E);
  and            G5( XC ,XIN,E);

`ifdef functional
`else
specify
// Parameter declarations
 specparam e_lh_xc_lh_1=0,e_lh_xout_hxc=0,e_hl_xc_hl=0,
 e_hl_xout_xch=0,xin_lh_xout_hl=0,e_lh_xout_lxc=0,
 e_hl_xout_xcl=0,xin_hl_xc_hl=0,xin_hl_xout_lh=0,xin_lh_xc_lh=0;
// Delays
 (        E   => XOUT) = (e_lh_xout_lxc,e_lh_xout_hxc,e_lh_xout_lxc,e_hl_xout_xch,e_lh_xout_hxc,e_hl_xout_xcl);
 (        E  +=> XC   ) = (e_lh_xc_lh_1,e_hl_xc_hl);
 (        XIN -=> XOUT) = (xin_hl_xout_lh,xin_lh_xout_hl);
 (        XIN +=> XC   ) = (xin_lh_xc_lh,xin_hl_xc_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 10ps

// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pxwe3r.v
// Description          : Crystal Oscillator Circuit With High Enable
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif


module PXWE3R (XIN,XOUT,XC,E);

output  XC;
input   XIN,E;
output  XOUT;

  nand           G2(XOUT,XIN,E);
  and            G5( XC ,XIN,E);

`ifdef functional
`else
specify
// Parameter declarations
 specparam e_lh_xc_lh_1=0,e_lh_xout_hxc=0,e_hl_xc_hl=0,
 e_hl_xout_xch=0,xin_lh_xout_hl=0,e_lh_xout_lxc=0,
 e_hl_xout_xcl=0,xin_hl_xc_hl=0,xin_hl_xout_lh=0,xin_lh_xc_lh=0;
// Delays
 (        E   => XOUT) = (e_lh_xout_lxc,e_lh_xout_hxc,e_lh_xout_lxc,e_hl_xout_xch,e_lh_xout_hxc,e_hl_xout_xcl);
 (        E  +=> XC   ) = (e_lh_xc_lh_1,e_hl_xc_hl);
 (        XIN -=> XOUT) = (xin_hl_xout_lh,xin_lh_xout_hl);
 (        XIN +=> XC   ) = (xin_lh_xc_lh,xin_hl_xc_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 10ps


// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pvdd1r.v
// Description          : VDD Pad
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module PVDD1R (VDD);

   output VDD;
   pullup               G2(VDD);

   parameter ExtLoad = 50.0 ;

`ifdef NOTIMING
`else
   specify
      specparam cell_count    = 0.000000;
      specparam Transistors   = 0 ;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine



// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pvdd1cer.v
// Description          : VDD Pad
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module PVDD1CER (VDD);

   output VDD;
   pullup               G2(VDD);

   parameter ExtLoad = 50.0 ;

`ifdef NOTIMING
`else
   specify
      specparam cell_count    = 0.000000;
      specparam Transistors   = 0 ;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine


// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pvdd2r.v
// Description          : VDD Pad
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module PVDD2R ();


   parameter ExtLoad = 50.0 ;

`ifdef NOTIMING
`else
   specify
      specparam cell_count    = 0.000000;
      specparam Transistors   = 0 ;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine



// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pvss1r.v
// Description          : VSS Pad
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module PVSS1R (VSS);

   output VSS;
   pulldown             G2(VSS);

   parameter ExtLoad = 50.0 ;

`ifdef NOTIMING
`else
   specify
      specparam cell_count    = 0.000000;
      specparam Transistors   = 0 ;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pvss2r.v
// Description          : VSS Pad
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module PVSS2R ();


   parameter ExtLoad = 50.0 ;

`ifdef NOTIMING
`else
   specify
      specparam cell_count    = 0.000000;
      specparam Transistors   = 0 ;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pvss3r.v
// Description          : VSS Pad
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module PVSS3R (VSS);

   output VSS;
   pulldown             G2(VSS);

   parameter ExtLoad = 50.0 ;

`ifdef NOTIMING
`else
   specify
      specparam cell_count    = 0.000000;
      specparam Transistors   = 0 ;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine


// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pvdd1anpr.v
// Description          : Analog power provider for non power-cut cell application
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module PVDD1ANPR (SVDD1ANP);

   output SVDD1ANP;
   pullup               G2(SVDD1ANP);

   parameter ExtLoad = 50.0 ;

`ifdef NOTIMING
`else
   specify
      specparam cell_count    = 0.000000;
      specparam Transistors   = 0 ;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pvss1anpr.v
// Description          : Analog ground provider for non power-cut cell application
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module PVSS1ANPR (SVSS1ANP);

   output SVSS1ANP;
   pulldown             G2(SVSS1ANP);

   parameter ExtLoad = 50.0 ;

`ifdef NOTIMING
`else
   specify
      specparam cell_count    = 0.000000;
      specparam Transistors   = 0 ;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine


// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pvdd1canpr.v
// Description          : Analog power provider for non power-cut cell application
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module PVDD1CANPR (SVDD1CANP);

   output SVDD1CANP;
   pullup               G2(SVDD1CANP);

   parameter ExtLoad = 50.0 ;

`ifdef NOTIMING
`else
   specify
      specparam cell_count    = 0.000000;
      specparam Transistors   = 0 ;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine


// ****** (C) Copyright 2011 SMIC Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pvss1canpr.v
// Description          : Analog ground provider for non power-cut cell application
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module PVSS1CANPR (SVSS1CANP);

   output SVSS1CANP;
   pulldown             G2(SVSS1CANP);

   parameter ExtLoad = 50.0 ;

`ifdef NOTIMING
`else
   specify
      specparam cell_count    = 0.000000;
      specparam Transistors   = 0 ;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine

// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pdioder.v
// Description          : power cut
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module PDIODER (VDD1,VDD2,VSS1,VSS2);

inout VDD1;
inout VDD2;
inout VSS1;
inout VSS2;

   parameter ExtLoad = 50.0 ;

`ifdef NOTIMING
`else
   specify
      specparam cell_count    = 0.000000;
      specparam Transistors   = 0 ;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine

// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : p1dioder.v
// Description          : power cut
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module P1DIODER (VDD1,VDD2,VSS1,VSS2);

inout VDD1;
inout VDD2;
inout VSS1;
inout VSS2;

   parameter ExtLoad = 50.0 ;

`ifdef NOTIMING
`else
   specify
      specparam cell_count    = 0.000000;
      specparam Transistors   = 0 ;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine


// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pdiode8r.v
// Description          : power cut for high voltage
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module PDIODE8R (VSS1,VSS2);

inout VSS1;
inout VSS2;

   parameter ExtLoad = 50.0 ;

`ifdef NOTIMING
`else
   specify
      specparam cell_count    = 0.000000;
      specparam Transistors   = 0 ;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine

// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : p1diode8r.v
// Description          : power cut for high voltage
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module P1DIODE8R (VSS1,VSS2);

inout VSS1;
inout VSS2;

   parameter ExtLoad = 50.0 ;

`ifdef NOTIMING
`else
   specify
      specparam cell_count    = 0.000000;
      specparam Transistors   = 0 ;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine

// ****** (C) Copyright 2011 SMIC   Inc. ********
//  --    SMIC   Verilog Models
// **********************************************
//
// Model type           : zero timing
// Filename             : pdiode8sr.v
// Description          : power cut for high voltage and short ground
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module PDIODE8SR ();

   parameter ExtLoad = 50.0 ;

`ifdef NOTIMING
`else
   specify
      specparam cell_count    = 0.000000;
      specparam Transistors   = 0 ;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine


