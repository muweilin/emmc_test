
`define REGS_MAX_ADR             2'd2

module apb_pwm
#(
    parameter APB_ADDR_WIDTH = 12,  //APB slaves are 4KB by default
    parameter PWM_CNT = 4 // how many pwm should be instantiated
)
(
    input  logic                      HCLK,
    input  logic                      HRESETn,
    input  logic [APB_ADDR_WIDTH-1:0] PADDR,
    input  logic               [31:0] PWDATA,
    input  logic                      PWRITE,
    input  logic                      PSEL,
    input  logic                      PENABLE,
    output logic               [31:0] PRDATA,
    output logic                      PREADY,
    output logic                      PSLVERR,

    output logic [PWM_CNT-1 : 0]    pwm_o
);

    logic [PWM_CNT-1:0] psel_int, pready, pslverr;
    logic [$clog2(PWM_CNT) - 1:0] slave_address_int;
    logic [PWM_CNT-1:0] [31:0] prdata;

    assign slave_address_int = PADDR[$clog2(PWM_CNT)+ `REGS_MAX_ADR + 1:`REGS_MAX_ADR + 2];

    always_comb
    begin
        psel_int = '0;
        psel_int[slave_address_int] = PSEL;
    end

    // output mux
    always_comb
    begin

        if (psel_int != '0)
        begin
            PRDATA = prdata[slave_address_int];
            PREADY = pready[slave_address_int];
            PSLVERR = pslverr[slave_address_int];
        end
        else
        begin
            PRDATA = '0;
            PREADY = 1'b1;
            PSLVERR = 1'b0;
        end
    end


    genvar k;

    generate
    for(k = 0; k < PWM_CNT; k++)
    begin : PWM_GEN
      pwm_gen pwm_gen_i
      (
          .HCLK       ( HCLK          ),
          .HRESETn    ( HRESETn       ),

          .PADDR      ( PADDR        ),
          .PWDATA     ( PWDATA       ),
          .PWRITE     ( PWRITE       ),
          .PSEL       ( psel_int[k]  ),
          .PENABLE    ( PENABLE      ),
          .PRDATA     ( prdata[k]    ),
          .PREADY     ( pready[k]    ),
          .PSLVERR    ( pslverr[k]   ),

          .pwm_o      ( pwm_o[k] )
      );
    end
endgenerate
endmodule
