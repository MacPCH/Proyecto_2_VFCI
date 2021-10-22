`include "test.sv"
module tb();
  reg clk;
  reg reset;
  
  parameter pckg_sz=40;
  parameter num_trans=10;
  parameter ROWS=4;
  parameter COLUMS=4;
  test #(.pckg_sz(pckg_sz),.num(num_trans),.ROWS(ROWS),.COLUMS(COLUMS),.FIFO_D(4)) t0 ;
  
  mesh_if #(pckg_sz,ROWS,COLUMS)_if  (clk,reset); //inteface
  mesh_gnrtr #(ROWS, COLUMS,pckg_sz, 4,{8{1'b1}}) mesh(
    .pndng(_if.pndng),
    .data_out(_if.data_out),
    .popin(_if.popin),
    .pop(_if.pop),
    .data_out_i_in(_if.data_out_i_in),
    .pndng_i_in(_if.pndng_i_in),
    .clk(clk),
    .reset(_if.reset)
);
  always #10 clk =~ clk;

  
  /*test #(.pckg_sz(pckg_sz),.num(num_trans),.esquina(aleatorio),.ROWS(ROWS),.COLUMS(COLUMS),.FIFO_D(2)) t1 ;
  test #(.pckg_sz(pckg_sz),.num(num_trans),.esquina(aleatorio),.ROWS(ROWS),.COLUMS(COLUMS),.FIFO_D(4)) t2 ;
  test #(.pckg_sz(pckg_sz),.num(num_trans),.esquina(aleatorio),.ROWS(ROWS),.COLUMS(COLUMS),.FIFO_D(6)) t3 ;
  test #(.pckg_sz(pckg_sz),.num(num_trans),.esquina(aleatorio),.ROWS(ROWS),.COLUMS(COLUMS),.FIFO_D(8)) t4 ;
  test #(.pckg_sz(pckg_sz),.num(num_trans),.esquina(aleatorio),.ROWS(ROWS),.COLUMS(COLUMS),.FIFO_D(12)) t5 ;
  test #(.pckg_sz(pckg_sz),.num(num_trans),.esquina(aleatorio),.ROWS(ROWS),.COLUMS(COLUMS),.FIFO_D(15)) t6 ;
  test #(.pckg_sz(pckg_sz),.num(num_trans),.esquina(esquina),.ROWS(ROWS),.COLUMS(COLUMS),.FIFO_D(4)) t7 ;
  test #(.pckg_sz(pckg_sz),.num(num_trans),.esquina(overflow),.ROWS(ROWS),.COLUMS(COLUMS),.FIFO_D(2)) t8 ;
  test #(.pckg_sz(pckg_sz),.num(num_trans),.esquina(overflow),.ROWS(ROWS),.COLUMS(COLUMS),.FIFO_D(4)) t9 ;
  test #(.pckg_sz(pckg_sz),.num(num_trans),.esquina(overflow),.ROWS(ROWS),.COLUMS(COLUMS),.FIFO_D(8)) t10 ;*/

  
  initial begin
    $display("PRIMERO: Cada terminal envía una transacción para ejercitar el DUT");
    for (int i=0; i<16;i++)
      _if.pop[i]=0;
    t0=new;
     t0.ambiente_instancia.interface_virtual = _if; //asigno la interfaz  
    {clk,reset} <= 1;
    #5
    {reset}=0;
   #5
    
    t0.run();
    #t0.tiempo_final;
    
    $finish;
  end
  
  
  initial begin
    $dumpvars(0,mesh_gnrtr);
  $dumpfile ("dump.vcd");
end
endmodule 
