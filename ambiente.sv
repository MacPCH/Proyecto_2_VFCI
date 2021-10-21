`include "interface_de_transacciones.sv"
`include "generador.sv"
`include "agente.sv"
`include "driver.sv"
`include "checker.sv"
`include "monitor.sv"

class Ambiente #(parameter pckg_sz,num_trans,ROWS,COLUMS,FIFO_D);
  
  Generador #(pckg_sz, num_trans,ROWS,COLUMS) generador_instancia;
  Agente #(pckg_sz,ROWS,COLUMS) agente_instancia;
  driver #(pckg_sz, FIFO_D, ROWS, COLUMS) driver_instancia;
  Checker #(pckg_sz, ROWS,COLUMS, FIFO_D) checker_instancia;
  monitor #(.pckg_sz(pckg_sz), .FIFO_depth(FIFO_D), .ROWS(ROWS), .COLUMS(COLUMS)) monitor_instancia;
  mailbox agente_mbx;
  mailbox driver_mbx;
  mailbox checker_mbx;
  mailbox monitor_mbx;
  comando_test_generador_mbx test_generador_mbx;
  
  event monitor_listo;
  event generador_listo;
  event agente_listo; 
  event monitor_listo;
  virtual mesh_if #(pckg_sz,ROWS,COLUMS) interface_virtual;
  
  
  function new();
    generador_instancia=new;
    agente_instancia=new;
    driver_instancia=new;
    checker_instancia=new;
    monitor_instancia=new;
    checker_mbx=new();
     agente_mbx=new();
    driver_mbx=new();
    monitor_mbx=new();
    test_generador_mbx = new();
    generador_instancia.test_generador_mbx = test_generador_mbx;
    monitor_instancia.monitor_mbx=monitor_mbx;
    checker_instancia.monitor_mbx=monitor_mbx;
    generador_instancia.agente_mbx=agente_mbx;
    agente_instancia.agente_mbx=agente_mbx;
     agente_instancia.checker_mbx=checker_mbx;
    checker_instancia.checker_mbx=checker_mbx;
    driver_instancia.driver_mbx=driver_mbx;
    agente_instancia.driver_mbx=driver_mbx;
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
      //driver_instancia.FIFO_creation();
      driver_instancia.run();
      driver_instancia.parallel_fifo_sample();
      checker_instancia.run();
      monitor_instancia.check();
      checker_instancia.check();
      checker_instancia.delay_terminal_prom();
    join_any
    #600000 
    disable fork;
  endtask
endclass
