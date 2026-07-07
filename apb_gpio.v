`timescale 1ns/1ps

module apb_gpio(

    input              PCLK,
    input              PRESETn,

    // APB Interface
    input              PSEL,
    input              PENABLE,
    input              PWRITE,
    input      [7:0]   PADDR,
    input      [31:0]  PWDATA,

    output reg [31:0]  PRDATA,
    output             PREADY,
    output             PSLVERR,

    // GPIO
    input      [7:0]   gpio_in,
    output     [7:0]   gpio_out

);

//--------------------------------------------
// Registers
//--------------------------------------------

reg [7:0] gpio_dir;
reg [7:0] gpio_out_reg;


//--------------------------------------------
// APB Outputs
//--------------------------------------------

assign PREADY  = 1'b1;
assign PSLVERR = 1'b0;


//--------------------------------------------
// GPIO Output Logic
//--------------------------------------------

// Only drive pins configured as outputs.
// Pins configured as inputs appear as 0 on gpio_out.

assign gpio_out = gpio_out_reg & gpio_dir;


//--------------------------------------------
// APB WRITE
//--------------------------------------------

always @(posedge PCLK or negedge PRESETn)
begin

    if(!PRESETn)
    begin

        gpio_dir     <= 8'h00;
        gpio_out_reg <= 8'h00;

    end

    else if(PSEL && PENABLE && PWRITE)
    begin

        case(PADDR)

            8'h04:
                gpio_dir <= PWDATA[7:0];

            8'h08:
                gpio_out_reg <= PWDATA[7:0];

            default:
                ;

        endcase

    end

end


//--------------------------------------------
// APB READ
//--------------------------------------------

always @(posedge PCLK)
begin

    PRDATA = 32'h00000000;

    if(PSEL && PENABLE && !PWRITE)
    begin

        case(PADDR)

            8'h04:
                PRDATA = {24'd0,gpio_dir};

            8'h08:
                PRDATA = {24'd0,gpio_out_reg};

            8'h0C:
                PRDATA = {24'd0,gpio_in};

            default:
                PRDATA = 32'd0;

        endcase

    end

end

endmodule