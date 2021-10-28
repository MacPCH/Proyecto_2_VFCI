//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com)

// clase que sirve como copia de seguridad para hacer gurdar los retrasos de los dispositivos y ser guradados en reportes
class retraso_terminal;
  int numero_trans = 0;
  int retraso = 0;
  int retraso_prom;
  int identi; 
endclass

// clase principal del checker para comprobar y reportar los resultados del test
class Checker #(parameter pckg_sz,  ROWS,  COLUMS,  FIFO_depth);
    //variables varias para hacer las comporbaciones y tambien para guardar los datos en reportes
    string mensaje, dispo_entrada, dispo_salida, tiempo_llegada, tsend, retraso_entrante,ID;
    string concatenado;
    bit timeout = 1'b0;
  	int sal=0;
  	int tiempo_salvado;
  	int tiempo_salvado2 = 0;
  	time tiempo_salvado3 = 0;
    int retraso_total=0; 
    int retraso_prom;
    real calculo_ancho_banda;
    real ancho_banda[$];
    string dispo_fifo;
    string identificador,ancho_banda_min,ancho_banda_max;
  	int contador4=1;
  	int contador22=1;
    int num_transacciones = 0;
    event agente_listo;
    event monitor_listo;
  	event checker_listo;
    bit [pckg_sz-9:0] empaque;
    time retrasos [$];
    int time_retraso;
  	int contador = 1;
    bit error;
  	int profundidad_fifo;
  	int numero_reporte;
    int contador5=0;
    retraso_terminal retraso_list [$]; //instacia para guardar los retrasos

  	la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) paquete; //instancia para guardar lo que venga del agente
    // definicion de los mailboxes
    mailbox checker_mbx;
    mailbox monitor_mbx;
  	mailbox test_mbx;
  	comando_test_checker_mbx test_checker_mbx;
    tipos_de_reportes tipo_reporte = new();

  la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) del_agente_comproba[$];

    task retraso_terminal_prom(); // tarea independiente para el guardado de los retrasos por cada terminal en una pila
      for (int i =0 ; i<=ROWS*COLUMS ; i++) begin
            retraso_terminal  retraso_por_dispo = new();
            retraso_por_dispo.identi=i; 
            retraso_por_dispo.numero_trans=0; 
            retraso_por_dispo.retraso=0; 
            retraso_por_dispo.retraso_prom=0; 
            retraso_list.insert(i, retraso_por_dispo); 
      end
    endtask
    // tarea no independiente del ambiente, se encarga de establecer todo lo necesario para comporoacion, reporte y parada de cada test 
    task run(); 
      $display ("El checker fue inicializado");
      // para el gurdado de los reportes
      $system("echo Dispositivo,Tiempo_Envio ns,Terminal_Procedencia,Dato,Tiempo_Recibido[ns],Terminal_Llegada,Retraso[ns] > salida.txt");
      $system("echo Profundidad_FIFO, retraso ns > retrasoprom.csv");
      $system("echo Profundidad_FIFO, min, max > ancho_banda_promedio.csv");
      $system("echo Dispositivo, profundidad_FIFO, retraso ns > retrasoterminal.csv");
        forever begin
          @(agente_listo)
            begin
              $display("Checker: Agente listo: ");
              forever begin
                if(checker_mbx.num!=0) begin // se obtiene toda la inforamcion para desde el agente para hacer la comprobacion de los datos
                la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) del_agente = new();
                checker_mbx.get(paquete); 
                del_agente.dispo_salida= paquete.dispo_salida;
                del_agente.dispo_entrada=paquete.dispo_entrada;
                del_agente.modo=paquete.modo;
                del_agente.mensaje=paquete.mensaje;
                del_agente.empaquetado=paquete.empaquetado;
                del_agente.tiempo_envio=paquete.tiempo_envio;
                del_agente.tiempo_llegada=paquete.tiempo_llegada;
                del_agente_comproba.push_front(del_agente);
                tiempo_salvado3 = $time;
            end 
                if (test_checker_mbx.num() == 1)begin //se encarga de obtener los reportes desde el test para saber que hacer a la hora de terminar cada test
                  int salva = test_checker_mbx.num();
                  test_checker_mbx.get(tipo_reporte);
                  num_transacciones = tipo_reporte.num_transacciones;
                  numero_reporte = tipo_reporte.num_reportes;
                  profundidad_fifo = tipo_reporte.profundidad_fifo;
     	  		end
                if(checker_mbx.num==0) break;
              end
            end
   	   #50000@(checker_listo)begin //si el ya paso el tiempo establecido desde el test, se recibe la instruccion de que se debe de reportar
         if (num_transacciones >= contador) begin //en el caso de que el tiempo haya pasado y no coincida el numero de transacciones desde el agente con respecto a las encontradas
                                                  // por el checker
           $display("Hubo perdida de comprobacion de datos por overflow");
         end
           
       case(numero_reporte)
         1: begin
           $display("Checker: HOLA! SOY EL CASO DE REPORTE 1");
           guardado_retraso();
           extremos_ancho_banda();

         end
         2: begin
           $display("Checker: HOLA! SOY EL CASO DE REPORTE 2");
           guardado_retraso();
           extremos_ancho_banda();
         end
         3: begin
           $display("Checker: HOLA! SOY EL CASO DE REPORTE 3");
           guardado_retraso_terminal();
           extremos_ancho_banda();
         end
         4: begin
           $display("Checker: HOLA! SOY EL CASO DE REPORTE 4");
           guardado_retraso();
           guardado_retraso_terminal();
           extremos_ancho_banda();
         end
         5: begin
           $display("Checker: HOLA! SOY EL CASO DE REPORTE 5");
           guardado_retraso();
           extremos_ancho_banda();
         end
         6: begin
           $display("Checker: HOLA! SOY EL CASO DE REPORTE 6");
           guardado_retraso();
           guardado_retraso_terminal();
           extremos_ancho_banda();
         end
         7: begin
           $display("Checker: HOLA! SOY EL CASO DE REPORTE 7");
           guardado_retraso();
           guardado_retraso_terminal();
           extremos_ancho_banda();
         end
       endcase
       contador = 1; // se restablece el contador del numero de transacciones contabilizadas
     end
        end
    endtask
  	
  
  	
   task check(); 
   forever begin
     @(monitor_listo) //cada vez que el evento del monitor listo se dispara, se comprueba en la base de datos
        begin
          $display("Checker: Monitor listo: ");
          forever begin
          la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) paquete_monitor=new(); //instancia para gurdar lo que viene del monitor
            monitor_mbx.get(empaque);
            paquete_monitor.data=empaque;
            paquete_monitor.tiempo_llegada=$time;
      case(empaque [pckg_sz-9: pckg_sz-16]) //discimino el valor en decimal del significado en fila columna para saber que dispositivo es al que se refiere el monitor
        1:
          paquete_monitor.dispo_entrada=0;
        2:
          paquete_monitor.dispo_entrada=1;
        3:
          paquete_monitor.dispo_entrada=2;
        4:
         paquete_monitor.dispo_entrada=3;
        16:
          paquete_monitor.dispo_entrada=4;
        32:
         paquete_monitor.dispo_entrada=5;
        48:
          paquete_monitor.dispo_entrada=6;
        64:
         paquete_monitor.dispo_entrada=7;
        81:
          paquete_monitor.dispo_entrada=8;
        82: 
          paquete_monitor.dispo_entrada=9;
        83:
          paquete_monitor.dispo_entrada=10;
        84:
         paquete_monitor.dispo_entrada=11;
        21:
          paquete_monitor.dispo_entrada=12;
        37:
         paquete_monitor.dispo_entrada=13;
        53:
          paquete_monitor.dispo_entrada=14;
        69:
          paquete_monitor.dispo_entrada=15;
 		    default:
          paquete_monitor.dispo_entrada=15;

    endcase
            for (int i=0; i<del_agente_comproba.size(); i++) 
                begin
                    error=0; //centinela en caso de no encontarar relacion entre un dato y su dispositivo
                    if (paquete_monitor.data==del_agente_comproba[i].empaquetado[pckg_sz-9:0]) //si hay igualdad en lo obtenido por el agente y el monitor para el empaquetado
                        begin
                          if (paquete_monitor.dispo_entrada==del_agente_comproba[i].dispo_entrada) //si el dispositivo de entrada coincide fuera de lo del empaquetado
                            begin
                            error=1; //no hubo problema, apartir de aqui solo se indica al usuario que todo esta bien y se genera un reporte generico con todo los datos como si fuera un log
                            time_retraso= paquete_monitor.tiempo_llegada-(del_agente_comproba[i].tiempo_envio); //calculo del retraso para el dispositivo en concreto
                            retrasos.insert(contador5,time_retraso); //se ingresa la info a la pila correspondiente
                            $display("t = %0d: Checker: Dispositivo que llega del DUT: %d, dispositivo esperado: %d", $time, paquete_monitor.dispo_entrada, del_agente_comproba[i].dispo_entrada);
                            $display("t = %0d: Checker: Dato que llega del DUT: %d, dato esperado: %d", $time, paquete_monitor.data, del_agente_comproba[i].empaquetado[pckg_sz-9:0]);
                            $display("t = %0d: Checker: Todo bien, todo correcto y yo que me alegro, transaccion = ", $time, contador);
                            contador++; // se cuenta el numero de transacciones exitosas para luego saber si hubo perdida de datos 
                            tiempo_llegada.itoa(paquete_monitor.tiempo_llegada);
                            tsend.itoa(del_agente_comproba[i].tiempo_envio);
                            mensaje.itoa(paquete_monitor.data);
                            dispo_entrada.itoa(paquete_monitor.dispo_entrada);
                            dispo_salida.itoa(del_agente_comproba[i].dispo_salida);
                            retraso_entrante.itoa(time_retraso);
                            identificador.itoa(contador5);
                            concatenado = {identificador,",",tsend,",",dispo_salida,",",mensaje,",",tiempo_llegada,",",dispo_entrada,",",retraso_entrante};
                            $system($sformatf("echo %0s >> salida.txt",concatenado));
                            for (int h=0; h<16; h++) //se barre en los 16 dispositivos para asignar los retrasos correspondientes para el reporte
                            begin
                              if (h==del_agente_comproba[i].dispo_entrada)
                                begin
                                  retraso_list[h].retraso=retraso_list[h].retraso+time_retraso; 
                                  retraso_list[h].numero_trans= retraso_list[h].numero_trans+1; 
                                end
                            end
                            break; 
                            error = 1;
                            end
                    else $fatal("EL DISPOSITIVO DE LLEGADA Y EL DESTINO DEL MENSAJE NO CONCUERDAN");
                end
                end
            contador5=contador5+1;
          end
        end
     if (!error) begin $fatal("ERROR, EL DATO RECIBIDO POR EL DRIVER NO CORRESPONDE A NINGÚN DATO ENVIADO"); end
     
    end
    
     
  endtask
  
 task guardado_retraso();
    for (int i=0; i< retrasos.size(); i++)begin
      retraso_total= (retraso_total+retrasos[i]); 
      end
    	retraso_prom=(retraso_total/retrasos.size()); 
      $display("El retraso promedio es de %0d",retraso_prom, " ns para una profundidad de Fifo de %0d",profundidad_fifo);
    	calculo_ancho_banda= (1000000000/retraso_prom); 
      $display("El ancho de banda promedio es de %0d", calculo_ancho_banda, " para una profundidad de Fifo de %0d",profundidad_fifo);
      retraso_entrante.itoa(retraso_prom);
      dispo_fifo.itoa(profundidad_fifo);
      concatenado = {dispo_fifo,",",retraso_entrante};
      $system($sformatf("echo %0s >> retrasoprom.csv",concatenado));
  endtask
  
  
  task guardado_retraso_terminal();
    for (int i=0; i<16; i++)
      begin
        retraso_list[i].retraso_prom= retraso_list[i].retraso/ (retraso_list[i].numero_trans);
          $display ("La terminal %0d", i, " tiene retraso de %0d", retraso_list[i].retraso_prom ," ns con una profundidad de Fifo de %0d",profundidad_fifo);
          calculo_ancho_banda= (1000000000/retraso_list[i].retraso_prom);
          ancho_banda={calculo_ancho_banda,ancho_banda};
          retraso_entrante.itoa(retraso_list[i].retraso_prom);
          dispo_fifo.itoa(profundidad_fifo);
          identificador.itoa(i);
          concatenado = {identificador,",",dispo_fifo,",",retraso_entrante};
          $system($sformatf("echo %0s >> retrasoterminal.csv",concatenado));
      end
  endtask

  task extremos_ancho_banda();
    begin
      real minimo[$];
      real maximo[$];
      maximo=ancho_banda.max();
      minimo=ancho_banda.min();
      ancho_banda_min.realtoa(minimo[0]);
      ancho_banda_max.realtoa(maximo[0]);
      dispo_fifo.itoa(profundidad_fifo);
      concatenado = {dispo_fifo,",",ancho_banda_min,",",ancho_banda_max};
      $system($sformatf("echo %0s >> ancho_banda_promedio.csv",concatenado));
      minimo={};
      maximo={};
      ancho_banda={};
    end
      endtask
    
endclass