
`timescale 1ns / 1ps

module simpcalculator(input logic [7:0]a,
              input logic [7:0] b,
              input logic [4:0] button,
              input clk, 
              output [6:0]seg, logic dp,
              output [3:0] an, output logic [7:0]al, output logic[7:0]bl);
 logic [3:0] bin0;  
 logic [3:0] bin1;
 logic [3:0] bin2;
 logic [3:0] bin3;         
 logic [14:0] result;
 logic [7:0]anew;
 logic [7:0]bnew;
 
 typedef enum logic [2:0] {init,add,mult,div,mod} statetype;
     statetype state, nextstate; 
               


            //Register Logic
            always_ff@(posedge clk)
            begin
            if(button[0]) state <= init;
            else state <= nextstate;
            end


  always_comb
      begin
      al <= a;
      bl <= b;
      anew <= ~a + 1'b1;
      bnew <= ~b + 1'b1;
        case(state)
          init:
            begin
             bin0 = 4'b0000;
             bin1 = 4'b0000;
             bin2 = 4'b0000;
             bin3 = 4'b0000;
             if (button[1])
             nextstate = add;
             else if(button[2])
             nextstate = mult;
             else if(button[3])
             nextstate = div;
             else if (button[4])
             nextstate = mod;
             else
             nextstate = init;
            end
             
          add:
          begin
            if(a[7] && b[7])
                begin
                result <= anew + bnew;
                bin3 = 4'b1111;
                end
            else if (a[7])
               begin 
                if(anew > b)
                    begin
                    result <= anew - b; 
                    bin3 = 4'b1111;
                    end
                else
                    begin
                    result <= b - anew;
                    bin3 = 4'b0000;
                    end
               end
                else if (b[7])
                  begin 
                  if(bnew > a)
                  begin
                  result <= bnew - a; 
                  bin3 = 4'b1111;
                  end
                else
                 begin
                  result <= a - bnew;
                  bin3 = 4'b0000;
                  end
                end               
           else
            begin
            result <= a + b;
            bin3 = 4'b0000;
            end
            bin0 = result % 10;
            bin1 = ((result % 100) - (result % 10)) / 10;
            bin2 = ((result % 1000) - (result % 100)) / 100;
             if (button[0])
             nextstate = init;
             else if(button[2])
             nextstate = mult;
             else if(button[4])   
             nextstate = mod;
             else if (button[3])
             nextstate = div;            
             else
             nextstate = add;
            end
             
          mult:
          begin
          if(a[7] == b[7])
          begin
              if(a[7] && b[7])        
               result <= anew * bnew;
              else  
               result <= a * b;
               if (((((result % 100000) - (result % 10000)) / 10000)) > 0)
               begin
               bin0 = ((result % 100) - (result % 10)) / 10;
               bin1 = ((result % 1000) - (result % 100)) / 100;
               bin2 = ((result % 10000) - (result % 1000)) / 1000;
               bin3 = ((result % 100000) - (result % 10000)) / 10000;
               end
               else
               begin
               bin0 = result % 10;
               bin1 = ((result % 100) - (result % 10)) / 10;
               bin2 = ((result % 1000) - (result % 100)) / 100;
               bin3 = ((result % 10000) - (result % 1000)) / 1000;
               end
          end
          else
            begin
              if(a[7])
              result <= anew * b;
              else
              result <= a * bnew;
              bin3 = 4'b1111;
              if (((((result % 100000) - (result % 10000)) / 10000)) > 0)
              begin
              bin0 = ((result % 1000) - (result % 100)) / 100;
              bin1 = ((result % 10000) - (result % 1000)) / 1000;
              bin2 = ((result % 100000) - (result % 10000)) / 10000;
              end
              else if (((((result % 10000) - (result % 1000)) / 1000)) > 0)
              begin
              bin0 = ((result % 100) - (result % 10)) / 10;
              bin1 = ((result % 1000) - (result % 100)) / 100;
              bin2 = ((result % 10000) - (result % 1000)) / 1000;
              end
              else
              begin
              bin0 = result % 10;
              bin1 = ((result % 100) - (result % 10)) / 10;
              bin2 = ((result % 1000) - (result % 100)) / 100;
              end
            end
            if (button[0])
            nextstate = init;
            else if(button[1])
            nextstate = add; 
            else if(button[4])   
             nextstate = mod;
            else if (button[3])
            nextstate = div; 
            else 
            nextstate = mult;           
          end
          
        div:
          begin
           if (b == 8'b0)
            begin
            bin0 = 4'b1111;
            bin1 = 4'b1111;
            bin2 = 4'b1111;
            bin3 = 4'b1111;
            end
           else
           begin
           if(a[7] && b[7])
            begin        
            result <= anew / bnew;
            bin3 = ((result % 10000) - (result % 1000)) / 1000;
            end
           else if(a[7])
            begin
            result <= anew / b;
            bin3 = 4'b1111; 
            end
           else if(b[7])
            begin
            result <= a / bnew;
            bin3 = 4'b1111; 
            end
           else
            begin
            result <= a / b;
            bin3 = ((result % 10000) - (result % 1000)) / 1000;
            end         
            bin0 = result % 10;
            bin1 = ((result % 100) - (result % 10)) / 10;
            bin2 = ((result % 1000) - (result % 100)) / 100;
           end
            if (button[0])
            nextstate = init;
            else if(button[1])
            nextstate = add; 
            else if(button[2])
            nextstate = mult; 
            else if(button[4])   
             nextstate = mod;
            else nextstate = div;      
          end
 
                mod:
                    begin
                     if (b == 8'b0)
                     begin
                     bin0 = 4'b1111;
                     bin1 = 4'b1111;
                     bin2 = 4'b1111;
                     bin3 = 4'b1111;
                     end
                     else
                      begin
                      if(a[7] && b[7])
                      begin
                      result <= anew % bnew;
                      if(result != 0)
                      bin3 = 4'b1111;
                      else
                      bin3 = 4'b0000;  
                      end          
                      else if(a[7])
                      begin
                      if (anew > ((anew/b) * b))
                      begin
                      result <= anew - ((anew/b) * b);
                      bin3 = 4'b0000;
                      end
                      else
                      begin
                      result <= ((anew/b) * b) - anew;
                      bin3 = 4'b1111;
                      end
                      end
                      else if(b[7])
                      begin
                      if(a > ((a/bnew) * bnew))
                      begin
                      result <= a - ((a/bnew) * bnew);
                      bin3 = 4'b0000;
                      end
                      else
                      begin
                      result <= ((a/bnew) * bnew) - a;
                      bin3 = 4'b1111;
                      end  
                      end                   
                      else
                      begin
                      result <= a % b;
                      bin3 = ((result % 10000) - (result % 1000)) / 1000; 
                      end       
                      bin0 = result % 10;
                      bin1 = ((result % 100) - (result % 10)) / 10;
                      bin2 = ((result % 1000) - (result % 100)) / 100;
                     end           
                        if (button[0])
                        nextstate = init;
                        else if(button[1])
                        nextstate = add; 
                        else if(button[2])
                        nextstate = mult; 
                        else if(button[3])   
                        nextstate = div;
                        else nextstate = mod;        
                      end                           
            
          default:
             nextstate = init;
         endcase
     end
     
     logic display;
     localparam Ms = 50000000;
     logic [27:0] count;
     initial count = 0;
     
     always@(posedge clk)
     begin
         if (count < Ms)
         begin
         display <= 1;
         count <= count + 1;
         end
         else if((count >= Ms) && (count < (Ms * 4)))
         begin 
         display <= 0;
         count <= count + 1;
         end
         else if(count == (Ms * 4))
         begin
         count <= 0;
         end
     end     
     
    
  sevenSegments dut(clk,display, bin0, bin1, bin2, bin3, seg, dp, an);           
              
endmodule