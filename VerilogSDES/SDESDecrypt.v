module SDESDecrypt (plaintext, k1, k2, cyphertext);
input [0:7] plaintext;
input [0:7] k1;
input [0:7] k2;
output [0:7] cyphertext;

assign cyphertext = ( plaintext - k1 - k2 ) % 26;
endmodule
