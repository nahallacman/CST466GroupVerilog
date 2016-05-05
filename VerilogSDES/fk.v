module fk (in, k, out);
input [0:7] in;
input [0:7] k;
output [0:7] out;

wire[0:7] EP_out;
wire[0:7] xor_1_out;
wire[0:1] S0_out;
wire[0:1] S1_out;

EP fk_EP(
.in(in[4:7]),
.out(EP_out)
);

assign xor_1_out = EP_out ^ k;

S0 fk_S0(
.in(xor_1_out[0:3]),
.out(S0_out)
);

S1 fk_S1(
.in(xor_1_out[4:7]),
.out(S1_out)
);

P4 fk_P4(
.in({S0_out, S1_out}),
.out(out)
);

endmodule