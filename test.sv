//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com)


`include "Ambiente.sv"
class test#(parameter pckg_sz,FIFO_D,ROWS,COLUMS);
  int tiempo_final=500000;
  /*int delay_total=0; 
  int delay_prom;*/
  int contador = 1;
  /*real BW;
  real ab[$];
  string fifo_dp,receive_delay,ID,ab_min,ab_max;
  string outputTXT_line, coma = ",";*/
  Ambiente #(.pckg_sz(pckg_sz),.esquina(esquina),.ROWS(ROWS),.COLUMS(COLUMS),.FIFO_D(FIFO_D)) ambiente_instancia; //se crea el ambiente
  
  comando_test_generador_mbx test_generador_mbx;
  tipos_de_transacciones instruccion_especifica;
  comando_test_checker_mbx test_checker_mbx;
  tipos_de_reportes tipo_reporte;
  
  function new();
    test_generador_mbx = new();
    test_checker_mbx = new();
    ambiente_instancia = new;
    ambiente_instancia.test_generador_mbx = test_generador_mbx;
    ambiente_instancia.generador_instancia.test_generador_mbx = test_generador_mbx;
    ambiente_instancia.test_checker_mbx = test_checker_mbx;
    ambiente_instancia.checker_instancia.test_checker_mbx = test_checker_mbx;
    
  endfunction
  
  
  
  task run();
    fork
    	ambiente_instancia.run();
    join_none
    //Primer escenario de pruebas
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" INICIO DEL ESCENARIO %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
   
    instruccion_especifica = new;
  	instruccion_especifica.tipo = aleatorio;
    instruccion_especifica.num_transacciones = 4;
    $display ("Test: Enviado al generador: ", instruccion_especifica);
    test_generador_mbx.put(instruccion_especifica);
    
    //num_reportes: 1=ab, 2=retraso_total, 3=retraso_dispositivo, 4=todos, 5=ab y retraso_total 
    //num_reportes: 6=ab y retraso_dispositivo, 7=retraso_total y retraso_dispositivo
    tipo_reporte = new();
    tipo_reporte.num_transacciones = instruccion_especifica.num_transacciones;
    tipo_reporte.num_reportes = 1;
    tipo_reporte.profundidad_fifo = FIFO_D;
    test_checker_mbx.put(tipo_reporte);
    $display ("Test: Enviado al checker: ", tipo_reporte);
    
    
    #10000
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL ESCENARIO %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    
    //Segundo escenario de pruebas
    contador++;
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" INICIO DEL ESCENARIO %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    instruccion_especifica = new;
  	instruccion_especifica.tipo = ordenado;
    instruccion_especifica.num_transacciones = 16;
    $display ("Test: Enviado al generador: ", instruccion_especifica);
    test_generador_mbx.put(instruccion_especifica);
    
    tipo_reporte = new;
    tipo_reporte.num_transacciones = instruccion_especifica.num_transacciones;
    tipo_reporte.num_reportes = 2;
    tipo_reporte.profundidad_fifo = FIFO_D;
    $display ("Test: Enviado al checker: ", tipo_reporte);
    test_checker_mbx.put(tipo_reporte);
    
    #10000
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL ESCENARIO %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    //Tercer escenario de pruebas
    contador++;
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" INICIO DEL ESCENARIO %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    instruccion_especifica = new;
  	instruccion_especifica.tipo = overflow;
    instruccion_especifica.num_transacciones = 6;
    $display ("Test: Enviado al generador: ", instruccion_especifica);
    test_generador_mbx.put(instruccion_especifica);
    
    tipo_reporte = new;
    tipo_reporte.num_transacciones = instruccion_especifica.num_transacciones;
    tipo_reporte.num_reportes = 4;
    tipo_reporte.profundidad_fifo = FIFO_D;
    $display ("Test: Enviado al checker: ", tipo_reporte);
    test_checker_mbx.put(tipo_reporte);
    
    #10000
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL ESCENARIO %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    //Cuarto escenario de pruebas y primer test (fila primero)
    contador++;
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" INICIO DEL ESCENARIO %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" INICIO DEL TEST %0d DE PRUEBAS", contador-3);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    instruccion_especifica = new;
  	instruccion_especifica.tipo = esquina;
    instruccion_especifica.num_transacciones = 5;
    instruccion_especifica.esquina = fila_primero;
    $display ("Test: Enviado al generador: ", instruccion_especifica);
    test_generador_mbx.put(instruccion_especifica);
    
    tipo_reporte = new();
    tipo_reporte.num_transacciones = instruccion_especifica.num_transacciones;
    tipo_reporte.num_reportes = 4;
    tipo_reporte.profundidad_fifo = FIFO_D;
    test_checker_mbx.put(tipo_reporte);
    $display ("Test: Enviado al checker: ", tipo_reporte);
    
    #10000
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL TEST %0d DE PRUEBAS", contador-3);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    //Cuarto escenario de pruebas y segundo test (columna primero)
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" INICIO DEL TEST %0d DE PRUEBAS", contador-1);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    instruccion_especifica = new;
  	instruccion_especifica.tipo = esquina;
    instruccion_especifica.num_transacciones = 3;
    instruccion_especifica.esquina = columna_primero;
    $display ("Test: Enviado al generador: ", instruccion_especifica);
    test_generador_mbx.put(instruccion_especifica);
    
    tipo_reporte = new();
    tipo_reporte.num_transacciones = instruccion_especifica.num_transacciones;
    tipo_reporte.num_reportes = 4;
    tipo_reporte.profundidad_fifo = FIFO_D;
    test_checker_mbx.put(tipo_reporte);
    $display ("Test: Enviado al checker: ", tipo_reporte);
    
    #10000
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL TEST %0d DE PRUEBAS", contador-2);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    //Cuarto escenario de pruebas y segundo test (error)
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" INICIO DEL TEST %0d DE PRUEBAS", contador-1);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    instruccion_especifica = new;
  	instruccion_especifica.tipo = esquina;
    instruccion_especifica.num_transacciones = 3;
    instruccion_especifica.esquina = error;
    $display ("Test: Enviado al generador: ", instruccion_especifica);
    test_generador_mbx.put(instruccion_especifica);
    
    tipo_reporte = new();
    tipo_reporte.num_transacciones = instruccion_especifica.num_transacciones;
    tipo_reporte.num_reportes = 4;
    tipo_reporte.profundidad_fifo = FIFO_D;
    test_checker_mbx.put(tipo_reporte);
    $display ("Test: Enviado al checker: ", tipo_reporte);
    
    #10000
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL TEST %0d DE PRUEBAS", contador-1);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    //Cuarto escenario de pruebas y segundo test (destino igual al origen)
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" INICIO DEL TEST %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    instruccion_especifica = new;
  	instruccion_especifica.tipo = esquina;
    instruccion_especifica.num_transacciones = 3;
    instruccion_especifica.esquina = destino_igual_origen;
    $display ("Test: Enviado al generador: ", instruccion_especifica);
    test_generador_mbx.put(instruccion_especifica);
    
    tipo_reporte = new();
    tipo_reporte.num_transacciones = instruccion_especifica.num_transacciones;
    tipo_reporte.num_reportes = 4;
    tipo_reporte.profundidad_fifo = FIFO_D;
    test_checker_mbx.put(tipo_reporte);
    $display ("Test: Enviado al checker: ", tipo_reporte);
    
    #10000
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL TEST %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL ESCENARIO %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
  endtask
  
endclass