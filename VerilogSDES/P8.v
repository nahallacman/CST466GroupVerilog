module P8 (in, out);
input [0:9] in;
output [0:7] out;

assign out = {in[6-1], in[3-1], in[7-1], in[4-1], in[8-1], in[5-1], in[10-1], in[9-1]}; 
endmodule
