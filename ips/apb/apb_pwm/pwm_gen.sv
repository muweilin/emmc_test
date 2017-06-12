
// define four registers per pwm_gen - load, cmp, control(prescaler + enable) and timer
`define REG_LOAD                  2'b00
`define REG_CMP                   2'b01
`define REG_PWM_CTRL              2'b10
`define REG_TIMER                 2'b11

`define PRESCALER_STARTBIT        'd3
`define PRESCALER_STOPBIT         'd5
`define ENABLE_BIT                'd0

module pwm_gen
#(
    parameter APB_ADDR_WIDTH = 12  //APB slaves are 4KB by default
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

    output logic                      pwm_o
);

    // APB register interface
    logic [1:0]  register_adr;
    assign register_adr = PADDR[3 : 2];
    // APB logic: we are always ready to capture the data into our regs
    // not supporting transfare failure
    assign PREADY  = 1'b1;
    assign PSLVERR = 1'b0;
    // registers
    logic [0:3] [31:0]  regs_q, regs_n;
    logic [31:0] cycle_counter_n, cycle_counter_q;
    logic        pwm_out_r;

    logic [2:0] prescaler_int;
    logic [5:0] prescaler_val;

    assign pwm_o = regs_q[`REG_PWM_CTRL][`ENABLE_BIT] & pwm_out_r;

    assign prescaler_int = regs_q[`REG_PWM_CTRL][`PRESCALER_STOPBIT:`PRESCALER_STARTBIT];
    assign prescaler_val = (prescaler_int == 0)? 3'b0 : (prescaler_int << 3) - 1;

    // register write logic
    always_comb
    begin
        regs_n = regs_q;

        if((regs_q[`REG_PWM_CTRL][`ENABLE_BIT]==1'b0) && prescaler_int != 'b0)
            cycle_counter_n = prescaler_val; 
        else if ((regs_q[`REG_PWM_CTRL][`ENABLE_BIT]==1'b0) && prescaler_int == 'b0)
            cycle_counter_n = 32'b0;
         else if ((regs_q[`REG_PWM_CTRL][`ENABLE_BIT]==1'b1) && (prescaler_int != 'b0) && (cycle_counter_q == prescaler_val))
            cycle_counter_n = 32'b0;
         else if ((regs_q[`REG_PWM_CTRL][`ENABLE_BIT]==1'b1) && (prescaler_int != 'b0))  //ly
            cycle_counter_n = cycle_counter_q + 1;
              else cycle_counter_n = cycle_counter_q ;
	
        // reset timer after reaching pwm load value
        if ((regs_q[`REG_TIMER] == regs_q[`REG_LOAD] - 1) && (prescaler_int != 'b0) && (cycle_counter_q== prescaler_val))    //ly
            regs_n[`REG_TIMER] = 1'b0;
        else if ((regs_q[`REG_TIMER] == regs_q[`REG_LOAD] - 1) && prescaler_int == 'b0)
            regs_n[`REG_TIMER] = 1'b0;
        else if(regs_q[`REG_PWM_CTRL][`ENABLE_BIT] && (prescaler_int != 'b0) && (cycle_counter_q==prescaler_val)) // prescaler     
        begin
            regs_n[`REG_TIMER] = regs_q[`REG_TIMER] + 1; //prescaler mode
        end
        else if (regs_q[`REG_PWM_CTRL][`ENABLE_BIT] && (prescaler_int == 'b0)) // normal count mode
            regs_n[`REG_TIMER] = regs_q[`REG_TIMER] + 1;


        // written from APB bus - gets priority
        if (PSEL && PENABLE && PWRITE)
            begin
                case (register_adr)
                    `REG_LOAD:
                     begin
                        regs_n[`REG_LOAD] = PWDATA;
                        regs_n[`REG_TIMER] = 32'b0;    //为防止load由很大值改为很小值，而timer的计数值已大于修改后的小值，脉冲起不来的情况
                     end

                    `REG_PWM_CTRL:
                     begin
                        regs_n[`REG_PWM_CTRL] = PWDATA;
                        regs_n[`REG_TIMER] = 32'b0;      //防止了由标准模式转prescale，等待过久的情况，但是start或stop时都会置timer为0，使第一个脉冲的高电平多1T，即5ns
                     end   
                    `REG_CMP:
                    begin
                        regs_n[`REG_CMP] = PWDATA;
                     //   regs_n[`REG_TIMER] = 32'b0; // reset timer if compare register is written
                    end

                    `REG_TIMER:
                        regs_n[`REG_TIMER] = PWDATA;
                endcase
            end
    end

    // APB register read logic
    always_comb
    begin
        PRDATA = 'b0;

        if (PSEL && PENABLE && !PWRITE)
        begin

            case (register_adr)
                `REG_LOAD:
                    PRDATA = regs_q[`REG_LOAD];

                `REG_PWM_CTRL:
                    PRDATA = regs_q[`REG_PWM_CTRL];

                `REG_CMP:
                    PRDATA = regs_q[`REG_CMP];

                `REG_TIMER:
                    PRDATA = regs_q[`REG_TIMER];
            endcase

        end
    end
    // synchronouse part
    always_ff @(posedge HCLK, negedge HRESETn)
    begin
        if(~HRESETn)
        begin
            regs_q          <= '{default: 32'b0};
            cycle_counter_q <= 32'b0;
        end
        else
        begin
            regs_q          <= regs_n;
            cycle_counter_q <= cycle_counter_n;
        end
    end


    always_ff @(posedge HCLK, negedge HRESETn)
    begin
        if(~HRESETn)
            pwm_out_r <= 1'b0;
        else
        begin
        	if (prescaler_int == 'b0) 
                begin
                    case(regs_q[`REG_TIMER])
                    0:                  pwm_out_r <= 1'b1;
                    regs_q[`REG_CMP]:   pwm_out_r <= 1'b0;
                    default:            pwm_out_r <= pwm_out_r;
                    endcase
                end
                else if (cycle_counter_q == prescaler_val) 
                    begin
                        case(regs_q[`REG_TIMER])
                        0:                  pwm_out_r <= 1'b1;
                        regs_q[`REG_CMP]:   pwm_out_r <= 1'b0;
                        default:            pwm_out_r <= pwm_out_r;
                        endcase
                    end
                else 
                   pwm_out_r <= pwm_out_r;

        end
    end

endmodule
