`timescale 1ns / 1ps


module sevenSegments(input clk,input display,
                     input [3:0] in0,in1,in2,in3,
                     output [6:0]seg, logic dp, // just connect them to FPGA pins (individual LEDs).
                     output [3:0] an);


// divide system clock (100Mhz for Basys3) by 2^N using a counter, which allows us to multiplex at lower speed
localparam N = 18;
logic [N-1:0] count = {N{1'b0}}; //initial value
always@ (posedge clk)
 count <= count + 1;


logic [3:0]digit_val; // 7-bit register to hold the current data on output
logic [3:0]digit_en;  //register for the 4 bit enable

always@ (*)
begin
digit_en = 4'b1111; //default
digit_val = in0; //default

case(count[N-1:N-2]) //using only the 2 MSB's of the counter 
 
2'b00 :  //select first 7Seg.
 begin
  digit_val = in0;
  digit_en = 4'b1110;
 end
 
2'b01:  //select second 7Seg.
 begin
  digit_val = in1;
  digit_en = 4'b1101;
 end
 
2'b10:  //select third 7Seg.
 begin
  digit_val = in2;
  digit_en = 4'b1011;
 end
  
2'b11:  //select forth 7Seg.
 begin
  digit_val = in3;
  digit_en = 4'b0111;
 end
endcase
end


//Convert digit number to LED vector. LEDs are active low.
logic [6:0] sseg_LEDs; 
always @(*)
begin 
    if (display == 1)
    begin
    sseg_LEDs = 7'b1111111; //default
    case(digit_val)
    0 : sseg_LEDs = 7'b1000000; //to display 0
    1 : sseg_LEDs = 7'b1111001; //to display 1
    2 : sseg_LEDs = 7'b0100100; //to display 2
    3 : sseg_LEDs = 7'b0110000; //to display 3
    4 : sseg_LEDs = 7'b0011001; //to display 4
    5 : sseg_LEDs = 7'b0010010; //to display 5
    6 : sseg_LEDs = 7'b0000010; //to display 6
    7 : sseg_LEDs = 7'b1111000; //to display 7
    8 : sseg_LEDs = 7'b0000000; //to display 8
    9 : sseg_LEDs = 7'b0010000; //to display 9   
    default : sseg_LEDs = 7'b0111111; //dash
    endcase
    end
    else 
    begin
    sseg_LEDs = 7'b1111111;
    end
end

assign an = digit_en;
assign seg = sseg_LEDs; 
assign dp = 1'b1; //turn dp off

endmodule