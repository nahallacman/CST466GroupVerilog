module SDESEncrypt (plaintext, k1, k2, cyphertext);
input [0:7] plaintext;
input [0:7] k1;
input [0:7] k2;
output [0:7] cyphertext;

wire[0:7] IPenc_out;
wire[0:7] fk1_out;
wire[0:7] fk2_out;
wire[0:7] sw_out;

IP enc_IP(
.in(plaintext),
.out(IPenc_out)
);

fk enc_fk_1(
.in(IPenc_out),
.k(k1),
.out(fk1_out)
);

SW enc_SW(
.in(fk1_out),
.out(sw_out)
);

fk enc_fk_2(
.in(sw_out),
.k(k2),
.out(fk2_out)
);

IPinv enc_IPinv(
.in(fk2_out),
.out(cyphertext)
);

//assign cyphertext = ( plaintext + k1 + k2 ) % 26; // not correct, needs to be updated
endmodule
