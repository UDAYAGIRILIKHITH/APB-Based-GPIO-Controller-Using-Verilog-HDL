`timescale 1ns/1ps

module apb_gpio_tb;

//---------------------------------------------------------
// APB Signals
//---------------------------------------------------------

reg         PCLK;
reg         PRESETn;

reg         PSEL;
reg         PENABLE;
reg         PWRITE;

reg  [7:0]  PADDR;
reg  [31:0] PWDATA;

wire [31:0] PRDATA;
wire        PREADY;
wire        PSLVERR;

//---------------------------------------------------------
// GPIO Signals
//---------------------------------------------------------

reg  [7:0] gpio_in;
wire [7:0] gpio_out;

//---------------------------------------------------------
// DUT Instantiation
//---------------------------------------------------------

apb_gpio DUT(

    .PCLK(PCLK),
    .PRESETn(PRESETn),

    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),

    .PADDR(PADDR),
    .PWDATA(PWDATA),

    .PRDATA(PRDATA),
    .PREADY(PREADY),
    .PSLVERR(PSLVERR),

    .gpio_in(gpio_in),
    .gpio_out(gpio_out)

);

//---------------------------------------------------------
// Clock Generation
//---------------------------------------------------------

always #5 PCLK = ~PCLK;


//---------------------------------------------------------
// APB WRITE TASK
//---------------------------------------------------------

task apb_write;

input [7:0] addr;
input [31:0] data;

begin

    @(posedge PCLK);

    PSEL    = 1'b1;
    PENABLE = 1'b0;
    PWRITE  = 1'b1;
    PADDR   = addr;
    PWDATA  = data;

    @(posedge PCLK);

    PENABLE = 1'b1;

    @(posedge PCLK);

    PSEL    = 1'b0;
    PENABLE = 1'b0;
    PWRITE  = 1'b0;

end

endtask


//---------------------------------------------------------
// APB READ TASK
//---------------------------------------------------------

task apb_read;

input [7:0] addr;

begin

    @(posedge PCLK);

    PSEL    = 1'b1;
    PENABLE = 1'b0;
    PWRITE  = 1'b0;
    PADDR   = addr;

    @(posedge PCLK);

    PENABLE = 1'b1;

    @(posedge PCLK);

    $display("----------------------------------------");
    $display("Time         = %0t",$time);
    $display("Read Address = %h",addr);
    $display("Read Data    = %h",PRDATA);
    $display("----------------------------------------");

    PSEL    = 1'b0;
    PENABLE = 1'b0;

end

endtask


//---------------------------------------------------------
// Test Sequence
//---------------------------------------------------------

initial
begin

    //-------------------------------
    // Initialize Signals
    //-------------------------------

    PCLK     = 0;
    PRESETn  = 0;

    PSEL     = 0;
    PENABLE  = 0;
    PWRITE   = 0;

    PADDR    = 8'h00;
    PWDATA   = 32'h00000000;

    gpio_in  = 8'h00;

    //-------------------------------
    // Apply Reset
    //-------------------------------

    #20;
    PRESETn = 1;

    #20;

    //-------------------------------
    // Configure GPIO Direction
    //-------------------------------

    $display("\nWriting GPIO Direction Register");

    apb_write(8'h04,32'h000000FF);

    //-------------------------------
    // Write GPIO Output Register
    //-------------------------------

    $display("\nWriting GPIO Output Register");

    apb_write(8'h08,32'h000000AA);

    //-------------------------------
    // Read Direction Register
    //-------------------------------

    $display("\nReading GPIO Direction Register");

    apb_read(8'h04);

    //-------------------------------
    // Read Output Register
    //-------------------------------

    $display("\nReading GPIO Output Register");

    apb_read(8'h08);

    //-------------------------------
    // Apply External Inputs
    //-------------------------------

    gpio_in = 8'hCC;

    #20;

    $display("\nReading GPIO Input Register");

    apb_read(8'h0C);

    //-------------------------------
    // Change Direction Register
    //-------------------------------

    $display("\nChanging GPIO Direction Register");

    apb_write(8'h04,32'h000000F0);

    //-------------------------------
    // Write New Output
    //-------------------------------

    apb_write(8'h08,32'h000000AA);

    #20;

    $display("----------------------------------------");
    $display("GPIO Direction = F0");
    $display("GPIO Output Reg= AA");
    $display("Actual GPIO_OUT= %b",gpio_out);
    $display("----------------------------------------");

    //-------------------------------
    // Finish Simulation
    //-------------------------------

    #50;

    $finish;

end


//---------------------------------------------------------
// Monitor
//---------------------------------------------------------

initial
begin

$monitor("TIME=%0t  PSEL=%b PENABLE=%b PWRITE=%b PADDR=%h PWDATA=%h PRDATA=%h GPIO_OUT=%b GPIO_IN=%b",
          $time,
          PSEL,
          PENABLE,
          PWRITE,
          PADDR,
          PWDATA,
          PRDATA,
          gpio_out,
          gpio_in);

end


endmodule