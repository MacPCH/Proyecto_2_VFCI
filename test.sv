//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com) - Susana Astorga Rodríguez (susana.0297.ar@gmail.com)

`include "ambiente.sv"
class test#(parameter pckg_sz,FIFO_D,ROWS,COLUMS);
  int tiempo_final=500000;
  int delay_total=0; 
  int delay_prom;
  int contador = 1;
  real BW;
  real ab[$];
  string fifo_dp,receive_delay,ID,ab_min,ab_max;
  string outputTXT_line, coma = ",";
  Ambiente #(.pckg_sz(pckg_sz),.esquina(esquina),.ROWS(ROWS),.COLUMS(COLUMS),.FIFO_D(FIFO_D)) ambiente_instancia; //se crea el ambiente
  
  comando_test_generador_mbx test_generador_mbx;
  tipos_de_transacciones instruccion_especifica;
  
  function new();
    test_generador_mbx = new();
    ambiente_instancia = new;
    ambiente_instancia.test_generador_mbx = test_generador_mbx;
    ambiente_instancia.generador_instancia.test_generador_mbx = test_generador_mbx;
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
    
    #10000
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL ESCENARIO %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    
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
  	instruccion_especifica.tipo = overflow;
    instruccion_especifica.num_transacciones = 3;
    $display ("Test: Enviado al generador: ", instruccion_especifica);
    test_generador_mbx.put(instruccion_especifica);
    
    #10000
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL ESCENARIO %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    //Tercer escenario de pruebas y primer test (fila primero)
    contador++;
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" INICIO DEL ESCENARIO %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" INICIO DEL TEST %0d DE PRUEBAS", contador-2);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    instruccion_especifica = new;
  	instruccion_especifica.tipo = esquina;
    instruccion_especifica.num_transacciones = 3;
    instruccion_especifica.esquina = fila_primero;
    $display ("Test: Enviado al generador: ", instruccion_especifica);
    test_generador_mbx.put(instruccion_especifica);
    
    #10000
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL TEST %0d DE PRUEBAS", contador-2);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    //Tercer escenario de pruebas y segundo test (columna primero)
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
    
    #10000
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL TEST %0d DE PRUEBAS", contador-1);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    //Tercer escenario de pruebas y segundo test (error)
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" INICIO DEL TEST %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    instruccion_especifica = new;
  	instruccion_especifica.tipo = esquina;
    instruccion_especifica.num_transacciones = 3;
    instruccion_especifica.esquina = error;
    $display ("Test: Enviado al generador: ", instruccion_especifica);
    test_generador_mbx.put(instruccion_especifica);
    
    #10000
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL TEST %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    //Tercer escenario de pruebas y segundo test (destino igual al origen)
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" INICIO DEL TEST %0d DE PRUEBAS", contador+1);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
    instruccion_especifica = new;
  	instruccion_especifica.tipo = esquina;
    instruccion_especifica.num_transacciones = 3;
    instruccion_especifica.esquina = destino_igual_origen;
    $display ("Test: Enviado al generador: ", instruccion_especifica);
    test_generador_mbx.put(instruccion_especifica);
    
    #10000
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL TEST %0d DE PRUEBAS", contador+1);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    $display ("-- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\ -- \\");
    $display ("-- / -- / -- / -- / -- / -- / -- / -- /");
    $display (" FIN DEL ESCENARIO %0d DE PRUEBAS", contador);
    $display ("/-- /-- /-- /-- /-- /-- /-- /-- /-- /--");
    $display ("\\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\-- \\--");
    
  endtask
  
  
 
  task get_delay();
    for (int i=0; i< ambiente_instancia.checker_instancia.delays.size(); i++)begin
      delay_total= (delay_total+ambiente_instancia.checker_instancia.delays[i]); 
      end
    delay_prom=(delay_total/ambiente_instancia.checker_instancia.delays.size()); 
    if (esquina==aleatorio)begin
      $display("El retraso promedio es de %0d",delay_prom, " ns para una profundidad de Fifo de %0d",FIFO_D);
    BW= (1000000000/delay_prom); 
      $display("El ancho de banda promedio es de %0d", BW, " bps para una profundidad de Fifo de %0d",FIFO_D);
      receive_delay.itoa(delay_prom);
      fifo_dp.itoa(FIFO_D);
      outputTXT_line = {fifo_dp,coma,receive_delay};
      $system($sformatf("echo %0s >> delayprom.csv",outputTXT_line));
    end
      else begin
    $display("El retraso promedio es de %0d",delay_prom, " ns");
    BW= (1000000000/delay_prom);
    $display("El ancho de banda promedio es de %0d", BW, " bps");
      end
  endtask
  
  task get_delay_terminal();
    for (int i=0; i<16; i++)
      begin
        ambiente_instancia.checker_instancia.delay_list[i].delay_prom= ambiente_instancia.checker_instancia.delay_list[i].delay/ (ambiente_instancia.checker_instancia.delay_list[i].num_transactions);
        if (esquina==aleatorio)begin
          $display ("La terminal %0d", i, " tiene delay de %0d", ambiente_instancia.checker_instancia.delay_list[i].delay_prom ," ns con una profundidad de Fifo de %0d",FIFO_D);
          BW= (1000000000/ambiente_instancia.checker_instancia.delay_list[i].delay_prom);
          ab={BW,ab};
          receive_delay.itoa(ambiente_instancia.checker_instancia.delay_list[i].delay_prom);
      fifo_dp.itoa(FIFO_D);
          ID.itoa(i);
          outputTXT_line = {ID,coma,fifo_dp,coma,receive_delay};
          $system($sformatf("echo %0s >> delayterminal.csv",outputTXT_line));
        end
          else
        $display ("La terminal %0d", i, " tiene delay de %0d", ambiente_instancia.checker_instancia.delay_list[i].delay_prom ," ns");
      end
  endtask
  
  task min_max_ab();
    begin
      real MI[$],MA[$];
      MI=ab.min();
      MA=ab.max();
      ab_min.realtoa(MI[0]);
      ab_max.realtoa(MA[0]);
      fifo_dp.itoa(FIFO_D);
      outputTXT_line = {fifo_dp,coma,ab_min,coma,ab_max};
      $system($sformatf("echo %0s >> ab_prom.csv",outputTXT_line));
      MI={};
      ab={};
      MA={};
    end
      endtask
    
endclass
