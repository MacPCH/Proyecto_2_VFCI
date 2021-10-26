//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com) - Susana Astorga Rodríguez (susana.0297.ar@gmail.com)

`include "test.sv"
module tb();
  reg clk;
  reg reset;
  
  parameter pckg_sz = 40;
  parameter ROWS = 4;
  parameter COLUMS = 4;
  int profundidad_fifo = 4;
  //parameter profundidad_fifo = profundidad_fifo1;
  test #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS),.FIFO_D(4)) t0;
  
  mesh_if #(pckg_sz,ROWS,COLUMS)_if  (clk,reset); //inteface
  mesh_gnrtr #(ROWS, COLUMS,pckg_sz, 4, {8{1'b1}}) mesh(
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

  
  initial begin

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
