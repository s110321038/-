module zhuanti(
input [3:0] password_in, 
input [3:0] password_try,
input set,
input unlock,
input reset,
input CLK,
//output [7:0] password_out,
output reg  unlock_out,
output reg  lock_out,
output reg  beep = 0,
//output [2:0]try,
//output four_out,
output reg [1:0] COM,
//input A,B,C,D,E,G,H,I,
output reg [0:6] seg
);
divfreq F0(CLK, CLK_div);
reg [6:0] s1,s2,s3,s4;
reg[3:0]password;
reg check;
//reg[2:0] try_2;
//reg two;
//assign try = try_2;
assign password_out = password;
//assign four_out = four;
//assign A,B,C,D = password_in;
//assign E,G,H,I = password_out;


always @(set,unlock)
begin
if(set)
begin
password = password_in;
lock_out = 1;
unlock_out = 0;
check = 0; 
beep = 0;
end
else if(unlock)
begin	
if(password_try == password && check==0)
begin
lock_out = 0;
unlock_out = 1;
check = 0;     
beep = 0;
end

else if(password_try != password && check==0)
begin
lock_out = 1;
unlock_out = 0;
check = 0;
beep = 1; 
end
end
end

initial
begin
COM[0] = 1'b0;
COM[1] = 1'b1;



end

always @(posedge CLK_div)
begin
if(COM[0]) seg <= s1;
if(COM[1]) seg <= s2;



COM[0] = ~COM[0];
COM[1] = ~COM[1];


end

always @(password_in)
case({password_in})
4'b0000: s1= 7'b0000001;
4'b0001: s1= 7'b1001111;
4'b0010: s1= 7'b0010010;
4'b0011: s1= 7'b0000110;
4'b0100: s1= 7'b1001100;
4'b0101: s1= 7'b0100100;
4'b0110: s1= 7'b0100000;
4'b0111: s1= 7'b0001111;
4'b1000: s1= 7'b0000000;
4'b1001: s1= 7'b0000000;
default: s1= 7'b1111110;
endcase
always @(password_try)
case({password_try})
4'b0000: s2= 7'b0000001;
4'b0001: s2= 7'b1001111;
4'b0010: s2= 7'b0010010;
4'b0011: s2= 7'b0000110;
4'b0100: s2= 7'b1001100;
4'b0101: s2= 7'b0100100;
4'b0110: s2= 7'b0100000;
4'b0111: s2= 7'b0001111;
4'b1000: s2= 7'b0000000;
4'b1001: s2= 7'b0000000;
default: s2= 7'b1111110;
endcase
endmodule

module divfreq(input CLK, output reg CLK_div);
reg [24:0] Count = 25'b0;
always @(posedge CLK)
begin
if(Count > 25000000 /100)
begin
Count <= 25'b0;
CLK_div <= ~CLK_div;
end
else
Count <= Count + 1'b1;
end
endmodule