//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com)

`include "interface_de_transacciones.sv"
`include "Generador.sv"
`include "Agente.sv"
`include "Driver.sv"
`include "Checker.sv"
`include "Monitor.sv"

class Ambiente #(parameter pckg_sz,ROWS,COLUMS,FIFO_D);
  
  Generador #(pckg_sz, ROWS, COLUMS) generador_instancia;
  Agente #(pckg_sz,ROWS,COLUMS) agente_instancia;
  driver #(pckg_sz, FIFO_D, ROWS, COLUMS) driver_instancia;
  Checker #(pckg_sz, ROWS,COLUMS, FIFO_D) checker_instancia;
  monitor #(.pckg_sz(pckg_sz), .FIFO_depth(FIFO_D), .ROWS(ROWS), .COLUMS(COLUMS)) monitor_instancia;
  mailbox agente_mbx;
  mailbox driver_mbx;
  mailbox checker_mbx;
  mailbox monitor_mbx;
  mailbox test_mbx;
  comando_test_generador_mbx test_generador_mbx;
  comando_test_checker_mbx test_checker_mbx;
  
  event monitor_listo;
  event generador_listo;
  event agente_listo; 
  event monitor_listo;
  event driver_listo;
  virtual mesh_if #(pckg_sz,ROWS,COLUMS) interface_virtual;
  
  
  function new();
    // Construccion de las instancias del ambiente de la mesa de trabajo
    generador_instancia = new;
    agente_instancia = new;
    driver_instancia = new;
    checker_instancia = new;
    monitor_instancia = new;
    //construccion de los mailbox
    checker_mbx = new();
    agente_mbx = new();
    driver_mbx = new();
    monitor_mbx = new();
    test_mbx = new();
    test_generador_mbx = new();
    test_checker_mbx = new();
    
    //conexion de los mailboxes con las instancias de las clases
    generador_instancia.test_generador_mbx = test_generador_mbx;
    checker_instancia.test_checker_mbx = test_checker_mbx;
    monitor_instancia.monitor_mbx=monitor_mbx;
    checker_instancia.monitor_mbx=monitor_mbx;
    generador_instancia.agente_mbx=agente_mbx;
    agente_instancia.agente_mbx=agente_mbx;
    agente_instancia.checker_mbx=checker_mbx;
    checker_instancia.checker_mbx=checker_mbx;
    driver_instancia.driver_mbx=driver_mbx;
    agente_instancia.driver_mbx=driver_mbx;
    
    
    //Conexion de los eventos del ambiente de pruebas
    checker_instancia.agente_listo=agente_listo;
    checker_instancia.monitor_listo=monitor_listo;
    monitor_instancia.monitor_listo=monitor_listo;
    generador_instancia.generador_listo=generador_listo;
     agente_instancia.generador_listo=generador_listo;
    agente_instancia.agente_listo=agente_listo;
    driver_instancia.agente_listo=agente_listo;
  endfunction
  
  virtual task run();
    driver_instancia.interface_virtual=interface_virtual;
    monitor_instancia.interface_virtual=interface_virtual;
    fork
    generador_instancia.run();
    agente_instancia.run();
      driver_instancia.run();
      driver_instancia.FIFO_DUT();
      checker_instancia.run();
      monitor_instancia.check();
      checker_instancia.check();
      checker_instancia.delay_terminal_prom();
    join
    //#600000 
    disable fork;
  endtask
endclass