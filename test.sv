//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com) - Susana Astorga Rodríguez (susana.0297.ar@gmail.com)


`include "ambiente.sv"
class test#(parameter pckg_sz,FIFO_D,ROWS,COLUMS);
  int contador = 1;
  Ambiente #(.pckg_sz(pckg_sz),.esquina(esquina),.ROWS(ROWS),.COLUMS(COLUMS),.FIFO_D(FIFO_D)) ambiente_instancia; //se crea el ambiente
  
  comando_test_generador_mbx test_generador_mbx; //mailbox del test al generador
  tipos_de_transacciones instruccion_especifica;
  comando_test_checker_mbx test_checker_mbx; //mailbox del checker al test
  tipos_de_reportes tipo_reporte;
  event checker_listo;
  
  function new();
    // Instanciación de los mailboxes
    test_generador_mbx = new();
    test_checker_mbx = new();
    // instanciación de los componentes del test
    ambiente_instancia = new;
    // conexión de las interfaces y mailboxes en el test
    ambiente_instancia.test_generador_mbx = test_generador_mbx;
    ambiente_instancia.generador_instancia.test_generador_mbx = test_generador_mbx;
    ambiente_instancia.test_checker_mbx = test_checker_mbx;
    ambiente_instancia.checker_instancia.test_checker_mbx = test_checker_mbx;
    ambiente_instancia.checker_instancia.checker_listo = checker_listo;
    
  endfunction
  
  
  
  task run(); //task donde correrá el test
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
  	instruccion_especifica.tipo = aleatorio; //selección del tipo de transacción
    instruccion_especifica.num_transacciones = 40; //número de transacciones
    $display ("Test: Enviado al generador: ", instruccion_especifica);
    test_generador_mbx.put(instruccion_especifica); //envío la transacccion con la instrucción específica hacia el test generador
    
    //num_reportes: 1=ab, 2=retraso_total, 3=retraso_dispositivo, 4=todos, 5=ab y retraso_total 
    //num_reportes: 6=ab y retraso_dispositivo, 7=retraso_total y retraso_dispositivo
    tipo_reporte = new();
    tipo_reporte.num_transacciones = instruccion_especifica.num_transacciones;
    tipo_reporte.num_reportes = 4; //reporte del tipo ancho de banda
    tipo_reporte.profundidad_fifo = FIFO_D;
    tipo_reporte.fin_prueba = 100000 * contador;
    test_checker_mbx.put(tipo_reporte); //envío el reporte generado hacia el test checker
    $display ("Test: Enviado al checker: ", tipo_reporte);
    
    
    #100000
    ->checker_listo;
    #5
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL ESCENARIO %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    //for (int i=0; i<16;i++) tb._if.pop[i]=1;
    
    
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
    tipo_reporte.num_reportes = 4;
    tipo_reporte.profundidad_fifo = FIFO_D;
    tipo_reporte.fin_prueba = 100000 * contador;
    $display ("Test: Enviado al checker: ", tipo_reporte);
    test_checker_mbx.put(tipo_reporte);
    
    #100000
    ->checker_listo;
    #5
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL ESCENARIO %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    //for (int i=0; i<16;i++) tb._if.pop[i]=1;
    
    //Tercer escenario de pruebas
    contador++;
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" INICIO DEL ESCENARIO %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    instruccion_especifica = new;
  	instruccion_especifica.tipo = overflow;
    instruccion_especifica.num_transacciones = 50;
    $display ("Test: Enviado al generador: ", instruccion_especifica);
    test_generador_mbx.put(instruccion_especifica);
    
    tipo_reporte = new;
    tipo_reporte.num_transacciones = instruccion_especifica.num_transacciones;
    tipo_reporte.num_reportes = 4;
    tipo_reporte.profundidad_fifo = FIFO_D;
    $display ("Test: Enviado al checker: ", tipo_reporte);
    test_checker_mbx.put(tipo_reporte);
    
    #100000
    ->checker_listo; //se activa el evento
    #5
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL ESCENARIO %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    for (int i=0; i<16;i++) tb._if.pop[i]=1;
    
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
    tipo_reporte.fin_prueba = 100000 * contador;
    test_checker_mbx.put(tipo_reporte);
    $display ("Test: Enviado al checker: ", tipo_reporte);
    
    #100000
    ->checker_listo;
    #5
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL TEST %0d DE PRUEBAS", contador-3);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    for (int i=0; i<16;i++) tb._if.pop[i]=1;
    
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
    
    #100000
    ->checker_listo;
    #5
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL TEST %0d DE PRUEBAS", contador-2);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    for (int i=0; i<16;i++) tb._if.pop[i]=1;
    
    //Cuarto escenario de pruebas y tercer test (destino igual al origen)
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" INICIO DEL TEST %0d DE PRUEBAS", contador -1);
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
    
    #100000
    ->checker_listo;
    #5
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL TEST %0d DE PRUEBAS", contador -1);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL ESCENARIO %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    for (int i=0; i<16;i++) tb._if.pop[i]=1;
    
  endtask
  
endclass
