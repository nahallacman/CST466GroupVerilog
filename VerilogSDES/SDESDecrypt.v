module SDESDecrypt (cyphertext, k1, k2, plaintext);
input [0:7] cyphertext;
input [0:7] k1;
input [0:7] k2;
output [0:7] plaintext;


wire[0:7] IPdec_out;
wire[0:7] fk1_out;
wire[0:7] fk2_out;
wire[0:7] sw_out;

IP dec_IP(
.in(cyphertext),
.out(IPdec_out)
);

fk dec_fk_1(
.in(IPdec_out),
.k(k2),
.out(fk1_out)
);

SW dec_SW(
.in(fk1_out),
.out(sw_out)
);

fk dec_fk_2(
.in(sw_out),
.k(k1),
.out(fk2_out)
);

IPinv dec_IPinv(
.in(fk2_out),
.out(plaintext)
);

//assign plaintext = ( cyphertext - k1 - k2 ) % 26;
endmodule
