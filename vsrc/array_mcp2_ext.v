
module array_mcp2_ext(
  input RW0_clk,
  input [8:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [511:0] RW0_wdata,
  output [511:0] RW0_rdata
);

  reg reg_RW0_ren;
  reg [8:0] reg_RW0_addr;
  wire RW0_addr_diff;
  wire RW0_rdata_valid;
  reg [8:0] reg_RW0_addr_2;
  reg [511:0] ram [511:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 512; initvar = initvar+1)
        ram[initvar] = {16 {$random}};
      reg_RW0_addr = {1 {$random}};
      reg_RW0_addr_2 = {1 {$random}};
    end
  `endif
  integer i;
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_rdata_valid)
    reg_RW0_addr_2 <= reg_RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      for (i=0;i<1;i=i+1) begin
        ram[RW0_addr][i*512 +: 512] <= RW0_wdata[i*512 +: 512];
      end
    end
  assign RW0_addr_diff = (RW0_addr != reg_RW0_addr);
  assign RW0_rdata_valid = reg_RW0_ren && (RW0_addr_diff || !(RW0_en && !RW0_wmode));
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [511:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
  assign RW0_rdata = RW0_rdata_valid ? ram[reg_RW0_addr_2] : RW0_random[511:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr_2];
  `endif

endmodule