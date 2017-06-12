
`ifdef CARD_TYPE
   `undef CARD_TYPE
`endif
`ifdef NUM_CARDS
   `undef NUM_CARDS
`endif
`ifdef NUM_CARD_BUS
   `undef NUM_CARD_BUS
`endif
`ifdef H_BUS_TYPE
   `undef H_BUS_TYPE
`endif
`ifdef H_DATA_WIDTH
   `undef H_DATA_WIDTH
`endif
`ifdef H_ADDR_WIDTH
   `undef H_ADDR_WIDTH
`endif
`ifdef INTERNAL_DMAC
   `undef INTERNAL_DMAC
`endif
`ifdef DMA_INTERFACE
   `undef DMA_INTERFACE
`endif
`ifdef GE_DMA_DATA_WIDTH
   `undef GE_DMA_DATA_WIDTH
`endif
`ifdef FIFO_DEPTH
   `undef FIFO_DEPTH
`endif
`ifdef R_ADDR_WIDTH
   `undef R_ADDR_WIDTH
`endif
`ifdef FIFO_RAM_INSIDE
   `undef FIFO_RAM_INSIDE
`endif
`ifdef NUM_CLK_DIVIDERS
   `undef NUM_CLK_DIVIDERS
`endif
`ifdef M_ADDR_WIDTH
   `undef M_ADDR_WIDTH
`endif
`ifdef UID_REG
   `undef UID_REG
`endif
`ifdef SET_CLK_FALSE_PATH
   `undef SET_CLK_FALSE_PATH
`endif
`ifdef AREA_OPTIMIZED
   `undef AREA_OPTIMIZED
`endif
`ifdef IMPLEMENT_SCAN_MUX
   `undef IMPLEMENT_SCAN_MUX
`endif
`ifdef IMPLEMENT_HOLD_REG
   `undef IMPLEMENT_HOLD_REG
`endif
`ifdef HCLK_PERIOD
   `undef HCLK_PERIOD
`endif
`ifdef CCLKIN_PERIOD
   `undef CCLKIN_PERIOD
`endif
`ifdef CCLK_IN_DELAY
   `undef CCLK_IN_DELAY
`endif
`ifdef GTECH_default_delay
   `undef GTECH_default_delay
`endif
`ifdef ENABLE_LONG_REGRESSION
   `undef ENABLE_LONG_REGRESSION
`endif
`ifdef ENABLE_ASSERTIONS
   `undef ENABLE_ASSERTIONS
`endif
`ifdef BUS_TYPE_AHB
   `undef BUS_TYPE_AHB
`endif
`ifdef INTERNAL_DMAC_YES
   `undef INTERNAL_DMAC_YES
`endif
`ifdef DW_DMA
   `undef DW_DMA
`endif
`ifdef NO_GENERIC_DMA
   `undef NO_GENERIC_DMA
`endif
`ifdef NO_NON_DW_DMA
   `undef NO_NON_DW_DMA
`endif
`ifdef RAM_DEPTH
   `undef RAM_DEPTH
`endif
`ifdef F_COUNT_WIDTH
   `undef F_COUNT_WIDTH
`endif
`ifdef FIFO_RAM_INSIDE_CORE
   `undef FIFO_RAM_INSIDE_CORE
`endif
`ifdef CLK_DIV_1
   `undef CLK_DIV_1
`endif
`ifdef NO_AREA_OPTIMIZATION
   `undef NO_AREA_OPTIMIZATION
`endif
`ifdef HOLD_REGISTER
   `undef HOLD_REGISTER
`endif
`ifdef SD_MODE
   `undef SD_MODE
`endif
`ifdef DMA_BUS_BYTES
   `undef DMA_BUS_BYTES
`endif
`ifdef F_DATA_WIDTH_32
   `undef F_DATA_WIDTH_32
`endif
`ifdef F_DATA_WIDTH
   `undef F_DATA_WIDTH
`endif
`ifdef F_BYTE_WIDTH
   `undef F_BYTE_WIDTH
`endif
`ifdef H_DATA_WIDTH_32
   `undef H_DATA_WIDTH_32
`endif
`ifdef M_ADDR_WIDTH_32
   `undef M_ADDR_WIDTH_32
`endif
`ifdef SD_VERSION_ID
   `undef SD_VERSION_ID
`endif
`ifdef AS_IDLE
   `undef AS_IDLE
`endif
`ifdef AS_WAITCHKBYTE
   `undef AS_WAITCHKBYTE
`endif
`ifdef AS_WAITBYTEZERO
   `undef AS_WAITBYTEZERO
`endif
`ifdef AS_WAITSTOPLD
   `undef AS_WAITSTOPLD
`endif
`ifdef AS_WAITSREQ_STBIT
   `undef AS_WAITSREQ_STBIT
`endif
`ifdef WRFIFO_IDLE
   `undef WRFIFO_IDLE
`endif
`ifdef WRFIFO_WAIT
   `undef WRFIFO_WAIT
`endif
`ifdef WRFIFO_PUSH
   `undef WRFIFO_PUSH
`endif
`ifdef WRFIFO_STOPCLK
   `undef WRFIFO_STOPCLK
`endif
`ifdef WRFIFO_LASTPUSH
   `undef WRFIFO_LASTPUSH
`endif
`ifdef RDFIFO_IDLE
   `undef RDFIFO_IDLE
`endif
`ifdef RDFIFO_POP
   `undef RDFIFO_POP
`endif
`ifdef RDFIFO_WAIT
   `undef RDFIFO_WAIT
`endif
`ifdef RDFIFO_STOPCLK
   `undef RDFIFO_STOPCLK
`endif
`ifdef INTR_IDLE
   `undef INTR_IDLE
`endif
`ifdef INTR_NOINT
   `undef INTR_NOINT
`endif
`ifdef INTR_RXDTINT
   `undef INTR_RXDTINT
`endif
`ifdef INTR_TXDTINT
   `undef INTR_TXDTINT
`endif
`ifdef INTR_WAITIDLE1
   `undef INTR_WAITIDLE1
`endif
`ifdef INTR_WAITIDLE2
   `undef INTR_WAITIDLE2
`endif
`ifdef INTR_WAITIDLE3
   `undef INTR_WAITIDLE3
`endif
`ifdef BUSY_IDLE
   `undef BUSY_IDLE
`endif
`ifdef BUSY_COUNT
   `undef BUSY_COUNT
`endif
`ifdef BUSY_CHK
   `undef BUSY_CHK
`endif
`ifdef BUSY_WT_CLEAR
   `undef BUSY_WT_CLEAR
`endif
`ifdef BUSY_GEN_INT
   `undef BUSY_GEN_INT
`endif
`ifdef BUSY_WT_COUNT
   `undef BUSY_WT_COUNT
`endif
`ifdef DW_data_s_int
   `undef DW_data_s_int
`endif
`ifdef CP_IDLE
   `undef CP_IDLE
`endif
`ifdef TXCMD_ISEQ
   `undef TXCMD_ISEQ
`endif
`ifdef TXCMD_STBIT
   `undef TXCMD_STBIT
`endif
`ifdef TXCMD_TXBIT
   `undef TXCMD_TXBIT
`endif
`ifdef TXCMD_PAR
   `undef TXCMD_PAR
`endif
`ifdef TXCMD_CRC7
   `undef TXCMD_CRC7
`endif
`ifdef TXCMD_ENDBIT
   `undef TXCMD_ENDBIT
`endif
`ifdef RXRESP_STBIT
   `undef RXRESP_STBIT
`endif
`ifdef RXRESP_IRQRESP
   `undef RXRESP_IRQRESP
`endif
`ifdef RXRESP_TXBIT
   `undef RXRESP_TXBIT
`endif
`ifdef RXRESP_CMDIDX
   `undef RXRESP_CMDIDX
`endif
`ifdef RXRESP_DATA
   `undef RXRESP_DATA
`endif
`ifdef RXRESP_CRC7
   `undef RXRESP_CRC7
`endif
`ifdef RXRESP_ENDBIT
   `undef RXRESP_ENDBIT
`endif
`ifdef CPWAIT_NCC
   `undef CPWAIT_NCC
`endif
`ifdef CPWAIT_CRT
   `undef CPWAIT_CRT
`endif
`ifdef CPWAIT_CCS
   `undef CPWAIT_CCS
`endif
`ifdef CPSEND_CCSD
   `undef CPSEND_CCSD
`endif
`ifdef CP_BOOT
   `undef CP_BOOT
`endif
`ifdef CP_VOLT_SWITCH_1
   `undef CP_VOLT_SWITCH_1
`endif
`ifdef CP_VOLT_SWITCH_2
   `undef CP_VOLT_SWITCH_2
`endif
`ifdef TXDT_IDLE
   `undef TXDT_IDLE
`endif
`ifdef TXDT_WFE
   `undef TXDT_WFE
`endif
`ifdef TXDT_STBIT
   `undef TXDT_STBIT
`endif
`ifdef TXDT_BLKDATA
   `undef TXDT_BLKDATA
`endif
`ifdef TXDT_CRC16
   `undef TXDT_CRC16
`endif
`ifdef TXDT_ENDBIT
   `undef TXDT_ENDBIT
`endif
`ifdef TXDT_RXCRC
   `undef TXDT_RXCRC
`endif
`ifdef TXDT_CHKBUSY
   `undef TXDT_CHKBUSY
`endif
`ifdef TXDT_STRDATA
   `undef TXDT_STRDATA
`endif
`ifdef TXDT_SRACK
   `undef TXDT_SRACK
`endif
`ifdef TXDT_WAITNWR
   `undef TXDT_WAITNWR
`endif
`ifdef TXDT_WFE1
   `undef TXDT_WFE1
`endif
`ifdef TXDT_WFE2
   `undef TXDT_WFE2
`endif
`ifdef TXDT_WFE3
   `undef TXDT_WFE3
`endif
`ifdef CRC_IDLE
   `undef CRC_IDLE
`endif
`ifdef CRC_START_BIT
   `undef CRC_START_BIT
`endif
`ifdef CRC_BIT_0
   `undef CRC_BIT_0
`endif
`ifdef CRC_BIT_01
   `undef CRC_BIT_01
`endif
`ifdef CRC_BIT_010
   `undef CRC_BIT_010
`endif
`ifdef CRC_END_BIT
   `undef CRC_END_BIT
`endif
`ifdef RXDT_IDLE
   `undef RXDT_IDLE
`endif
`ifdef RXDT_STBIT
   `undef RXDT_STBIT
`endif
`ifdef RXDT_BLKDATA
   `undef RXDT_BLKDATA
`endif
`ifdef RXDT_STRDATA
   `undef RXDT_STRDATA
`endif
`ifdef RXDT_CRC16
   `undef RXDT_CRC16
`endif
`ifdef RXDT_ENDBIT
   `undef RXDT_ENDBIT
`endif
`ifdef RXDT_WAIT2CLK
   `undef RXDT_WAIT2CLK
`endif
`ifdef RXDT_BOOT_ACK
   `undef RXDT_BOOT_ACK
`endif
`ifdef RXDT_STBIT_X
   `undef RXDT_STBIT_X
`endif
`ifdef CP_IDLE_CHK
   `undef CP_IDLE_CHK
`endif
`ifdef TXCMD_ISEQ_CHK
   `undef TXCMD_ISEQ_CHK
`endif
`ifdef CPWAIT_NCC_CHK
   `undef CPWAIT_NCC_CHK
`endif
`ifdef CPWAIT_CRT_CHK
   `undef CPWAIT_CRT_CHK
`endif
`ifdef TXDT_WFE_CHK
   `undef TXDT_WFE_CHK
`endif
`ifdef TXDT_WFE3_CHK
   `undef TXDT_WFE3_CHK
`endif
`ifdef DMAC_IDLE
   `undef DMAC_IDLE
`endif
`ifdef DMA_STOP
   `undef DMA_STOP
`endif
`ifdef DESC_RD
   `undef DESC_RD
`endif
`ifdef DESC_CHK
   `undef DESC_CHK
`endif
`ifdef DMA_RD_REQ_WAIT
   `undef DMA_RD_REQ_WAIT
`endif
`ifdef DMA_WR_REQ_WAIT
   `undef DMA_WR_REQ_WAIT
`endif
`ifdef DMA_RD
   `undef DMA_RD
`endif
`ifdef DMA_WR
   `undef DMA_WR
`endif
`ifdef DESC_CLOSE
   `undef DESC_CLOSE
`endif
`ifdef SINGLE
   `undef SINGLE
`endif
`ifdef INCR
   `undef INCR
`endif
`ifdef WRAP4
   `undef WRAP4
`endif
`ifdef INCR4
   `undef INCR4
`endif
`ifdef WRAP8
   `undef WRAP8
`endif
`ifdef INCR8
   `undef INCR8
`endif
`ifdef WRAP16
   `undef WRAP16
`endif
`ifdef INCR16
   `undef INCR16
`endif
`ifdef IDLE
   `undef IDLE
`endif
`ifdef BUSY
   `undef BUSY
`endif
`ifdef NSEQ
   `undef NSEQ
`endif
`ifdef SEQ
   `undef SEQ
`endif
`ifdef OK
   `undef OK
`endif
`ifdef ERROR
   `undef ERROR
`endif
`ifdef RETRY
   `undef RETRY
`endif
`ifdef SPLIT
   `undef SPLIT
`endif
`ifdef DMA_IDLE
   `undef DMA_IDLE
`endif
`ifdef DMA_START
   `undef DMA_START
`endif
`ifdef DMA_CHK
   `undef DMA_CHK
`endif
`ifdef AHM_IDLE
   `undef AHM_IDLE
`endif
`ifdef AHM_REQ
   `undef AHM_REQ
`endif
`ifdef AHM_START
   `undef AHM_START
`endif
`ifdef AHM_XFER
   `undef AHM_XFER
`endif
`ifdef AHM_DONE
   `undef AHM_DONE
`endif
`ifdef AHM_ERR
   `undef AHM_ERR
`endif
`ifdef AHM_RETRY
   `undef AHM_RETRY
`endif
`ifdef AHM_LOSE_BUS
   `undef AHM_LOSE_BUS
`endif
`define cb_dummy_parameter_definition 1
`undef  cb_dummy_parameter_definition
`ifdef DUMMY
  `undef DUMMY
`endif
