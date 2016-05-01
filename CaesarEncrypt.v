module CasesarEncrypt (plaintext, key, cyphertext);
input [0:5] plaintext;
input [0:5] key;
output [0:5] cyphertext;

assign cyphertext = ( plaintext + key ) % 25;
endmodule
