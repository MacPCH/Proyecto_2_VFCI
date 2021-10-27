//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com)

`include "test.sv"
module tb();
  reg clk;
  reg reset;
  //Declaraciond e los parametros de la prueba 
  parameter pckg_sz = 40;
  parameter ROWS = 4;
  parameter COLUMS = 4;
  int profundidad_fifo = 4;
  test #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS),.FIFO_D(4)) test_instancia; //instanciacion del test
  
  mesh_if #(pckg_sz,ROWS,COLUMS)_if  (clk,reset); //inteface del DUT 
  mesh_gnrtr #(ROWS, COLUMS,pckg_sz, 4, {8{1'b1}}) mesh( //conexion del DUT con la interfaz virtual
    .pndng(_if.pndng),
    .data_out(_if.data_out),
    .popin(_if.popin),
    .pop(_if.pop),
    .data_out_i_in(_if.data_out_i_in),
    .pndng_i_in(_if.pndng_i_in),
    .clk(clk),
    .reset(_if.reset)
);
  always #10 clk =~ clk; //reloj para la prueba
  initial begin //inicializacion del test 
    for (int i=0; i<16;i++) // se limpia el DUT de cualquier dato anterior
      _if.pop[i]=0;
    test_instancia = new; //cOnstruccion de la instancia del test
     test_instancia.ambiente_instancia.interface_virtual = _if; //asignacion la interfaz  
    {clk,reset} <= 1; // estado del reset inicialmente en  1 o activado
    #5
    {reset}=0; //Una ves se reinicie, se deja en 0 de nuevo
   #5
    
    test_instancia.run(); //inicializacion del conjunto de pruebas dentro del test
    #1000000; //Tiempo de espera para terminar el test
    
    $finish;
  end

  initial begin
    $dumpvars(0,mesh_gnrtr);
  $dumpfile ("dump.vcd");
end
endmodule 
