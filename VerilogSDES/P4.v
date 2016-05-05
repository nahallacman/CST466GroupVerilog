module P4 (in, out);
input [0:3] in;
output [0:3] out;

assign out = {in[2-1], in[4-1], in[3-1], in[1-1]}; 
endmodule