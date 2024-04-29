`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ju Yang
// 
// Create Date: 2024/04/24 21:48:40
// Design Name: 
// Module Name: hdb3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module hdb3(
  input   i_clk ,
  input   i_rst ,
  input   i_data,
  output  o_p   ,
  output  o_n  
);

//plug v
reg [3:0]   r_plug_v        ;//plug_v
reg [3:0]   r_plug_1        ;//in1
reg [2:0]   r_d             ;//3-b shift reg 
//plug b
reg [4:0]   r_plug_b_code_h ;
reg [4:0]   r_plug_b_code_l ;// delay 5 cycles
reg         r_odd_even      ;//0-even 1-odd
//out_code
reg [1:0]   ro_hdb3_code    ;
reg         r_polar         ;//1-p 0-n
reg [7:0]   r_ri            ;
reg         r_vafterb       ;

//plug v
wire [1:0]  w_plug_v;//code plugged v,00-0,01-1,10-v
//plug b
wire [1:0]  w_plug_b;//code plugged b,00-0,01-1,10-v,11-b

assign w_plug_v = {r_plug_v[3],r_plug_1[3]};
assign w_plug_b = {r_plug_b_code_h[4],r_plug_b_code_l[4]};
assign o_p      = ro_hdb3_code[1];
assign o_n      = ro_hdb3_code[0];

always@(posedge i_clk or posedge i_rst)
begin
if(i_rst)
  r_d<=3'b111;
else
  r_d<={r_d[1:0],i_data};
end

//plug_v and 1
always@(posedge i_clk or posedge i_rst)
begin
if(i_rst)
begin
r_plug_v<=4'b0000;
r_plug_1<=4'b0000;
end
else if((!i_data) && (r_d==3'b000) && (r_plug_v[2:0]==3'b000))
begin
r_plug_v<={r_plug_v[2:0],1'b1};
r_plug_1<={r_plug_1[2:0],1'b0};
end
else if(i_data)
begin
r_plug_v<={r_plug_v[2:0],1'b0};
r_plug_1<={r_plug_1[2:0],1'b1};
end
else
begin
r_plug_v<={r_plug_v[2:0],1'b0};
r_plug_1<={r_plug_1[2:0],1'b0};
end
end

always@(posedge i_clk or posedge i_rst)
begin
if(i_rst)
r_odd_even<=1'b0;
else if(w_plug_v==2'b10)//0-even 1-odd
r_odd_even<=1'b0;
else if(w_plug_v==2'b01)
r_odd_even<=~r_odd_even;
else
r_odd_even<=r_odd_even;
end

// code plugged b, 00-0,01-1,10-v,11-b

always@(posedge i_clk or posedge i_rst)
begin
if(i_rst)
begin
r_plug_b_code_h<=5'b0000;
r_plug_b_code_l<=5'b0000;
end
else if((!r_odd_even) && (w_plug_v==2'b10))
begin
r_plug_b_code_h<={r_plug_b_code_h[3],4'b1001};
r_plug_b_code_l<={r_plug_b_code_l[3],4'b1000};
end
else 
begin
r_plug_b_code_h<={r_plug_b_code_h[3:0],w_plug_v[1]};
r_plug_b_code_l<={r_plug_b_code_l[3:0],w_plug_v[0]};
end
end



always@(posedge i_clk or posedge i_rst)
begin
if(i_rst)
r_ri<=8'b0;
else
r_ri<={r_ri[5:0],w_plug_b};
end

always@(posedge i_clk or posedge i_rst)
begin
if(i_rst)
r_vafterb<=6'b0;
else if(w_plug_b==2'b11)
r_vafterb<=r_polar;
else
r_vafterb<=r_vafterb;
end

always@(posedge i_clk or posedge i_rst)
begin
if(i_rst)
r_polar<=1'b1;
else if(w_plug_b==2'b01 || w_plug_b==2'b11)
r_polar<=~r_polar;
else
r_polar<=r_polar;
end

always@(posedge i_clk or posedge i_rst)
begin
if(i_rst)
ro_hdb3_code<=2'b0;
else if(((w_plug_b==2'b01) || (w_plug_b==2'b11)) && r_polar)
ro_hdb3_code<=2'b10;
else if(((w_plug_b==2'b01) || (w_plug_b==2'b11)) && (!r_polar))
ro_hdb3_code<=2'b01;
else if(w_plug_b==2'b10 && (r_ri[5:4]==2'b11) && (r_vafterb))//mantain the polar with B
ro_hdb3_code<=2'b10;
else if(w_plug_b==2'b10 && (r_ri[5:4]==2'b11) && (!r_vafterb))
ro_hdb3_code<=2'b01;
else if(w_plug_b==2'b10 && (r_ri[7:6]==2'b01) && r_polar)//mantain the polar with 1
ro_hdb3_code<=2'b01;
else if(w_plug_b==2'b10 && (r_ri[7:6]==2'b01) && (!r_polar))
ro_hdb3_code<=2'b10;
else if((w_plug_b==2'b10)  && r_polar)
ro_hdb3_code<=2'b10;
else if((w_plug_b==2'b10) && (!r_polar))
ro_hdb3_code<=2'b01;
else if((w_plug_b==2'b10)  && r_polar)
ro_hdb3_code<=2'b10;
else if((w_plug_b==2'b10) && (!r_polar))
ro_hdb3_code<=2'b01;
else 
ro_hdb3_code<=2'b0;
end



endmodule

