//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com) - Susana Astorga Rodríguez (susana.0297.ar@gmail.com)

// Se incluyen las librerias usadas por el test
`include "interface_de_transacciones.sv"
`include "generador.sv"
`include "agente.sv"
`include "driver.sv"
`include "checker.sv"
`include "monitor.sv"

// Declaracion de la clases para la mesa de trabajo
class Ambiente #(parameter pckg_sz,ROWS,COLUMS,FIFO_D);
  Generador #(.pckg_sz(pckg_sz), .ROWS(ROWS), .COLUMS(COLUMS)) generador_instancia;
  Agente #(.pckg_sz(pckg_sz), .ROWS(ROWS), .COLUMS(COLUMS)) agente_instancia;
  driver #(.pckg_sz(pckg_sz), .FIFO_depth(FIFO_D), .ROWS(ROWS), .COLUMS(COLUMS)) driver_instancia;
  Checker #(.pckg_sz(pckg_sz), .ROWS(ROWS), .COLUMS(COLUMS), .FIFO_depth(FIFO_D)) checker_instancia;
  monitor #(.pckg_sz(pckg_sz), .FIFO_depth(FIFO_D), .ROWS(ROWS), .COLUMS(COLUMS)) monitor_instancia;
  //Declaracion de los mailboxes incluyendo
  mailbox agente_mbx;
  mailbox driver_mbx;
  mailbox checker_mbx;
  mailbox monitor_mbx;
  mailbox test_mbx;
  comando_test_generador_mbx test_generador_mbx;
  comando_test_checker_mbx test_checker_mbx;
  //Declaracion de los eventos 
  event monitor_listo;
  event generador_listo;
  event agente_listo; 
  event monitor_listo;
  event driver_listo;
  event checker_listo;

  virtual mesh_if #(pckg_sz,ROWS,COLUMS) interface_virtual; //Interface virtual para el mesh
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
    //Interconexion del driver y el monitor con la interface virtual que conecta al DUT
    driver_instancia.interface_virtual=interface_virtual;
    monitor_instancia.interface_virtual=interface_virtual;
    fork  //Inician tas las instancias de la prueba incluyendo a algunas extra puestas a propósito para facilitar algunos procesos
    generador_instancia.run();
    agente_instancia.run();
      driver_instancia.run();
      driver_instancia.FIFO_DUT();
      checker_instancia.run();
      monitor_instancia.check();
      checker_instancia.check();
      checker_instancia.retraso_terminal_prom();
    join //Una vez se acabe todo se sale del fork
    disable fork;
  endtask
endclass
