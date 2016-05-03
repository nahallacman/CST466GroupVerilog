module IP (in, out);
input [0:7] in;
output [0:7] out;

assign out = {in[2-1], in[6-1], in[3-1], in[1-1], in[4-1], in[8-1], in[5-1], in[7-1]}; 
endmodule