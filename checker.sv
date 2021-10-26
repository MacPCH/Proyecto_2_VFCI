//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com)

class Delay_terminal;
  int num_transactions = 0;
  int delay = 0;
  int delay_prom;
  int identifier; 
endclass

class Checker #(parameter pckg_sz,  ROWS,  COLUMS,  FIFO_depth);

    string mensaje, dispo_entrada, dispo_salida, tiempo_llegada, tsend, receive_delay,ID;
    string outputTXT_line, comma = ",";
  	
  	
    int delay_total=0; 
    int delay_prom;
    real BW;
    real ab[$];
    string fifo_dp,receive_delay,ID,ab_min,ab_max;
  
  
    int num_transacciones = 0;
    event agente_listo;
    event monitor_listo;
    bit [pckg_sz-9:0] data_in;
    time delays [$];
    int time_delay;
  	int contador = 1;
    bit error;
  	int profundidad_fifo;
  	int numero_reporte;
  	
    Delay_terminal delay_list [$];
  	la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) paquete;
    mailbox checker_mbx;
    mailbox monitor_mbx;
  	mailbox test_mbx;
  	comando_test_checker_mbx test_checker_mbx;
    tipos_de_reportes tipo_reporte = new();
  	
    int j=0; 

  la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) scb[$];

    task delay_terminal_prom(); 
      for (int i =0 ; i<=ROWS*COLUMS ; i++) begin
            Delay_terminal  delay_new = new();
            delay_new.identifier=i; 
            delay_new.num_transactions=0; 
            delay_new.delay=0; 
            delay_new.delay_prom=0; 
            delay_list.insert(i, delay_new); 
      end
    endtask

    task run(); 
      $display ("El checker fue inicializado");
      $system("echo Dispositivo,Tiempo_Envio[ns],Terminal_Procedencia,Dato,Tiempo_Recibido[ns],Terminal_Llegada,Retraso[ns] > salida.txt");
      $system("echo Profundidad_FIFO, retraso(ns) > delayprom.csv");
      $system("echo Dispositivo,Tiempo_Envio[ns],Terminal_Procedencia,Dato,Tiempo_Recibido[ns],Terminal_Llegada,Retraso[ns] > ab_prom.csv");
      $system("echo Dispositivo, profundidad_FIFO, retraso[ns] > delayterminal.csv");
        forever begin
          @(agente_listo)
            begin
              $display("Checker: Agente listo: ");
              /*@(monitor_listo) 
            begin*/
              forever begin
                if(checker_mbx.num!=0) begin
                la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) del_agente = new();
                checker_mbx.get(paquete); 
                del_agente.dispo_salida= paquete.dispo_salida;
                del_agente.dispo_entrada=paquete.dispo_entrada;
                del_agente.modo=paquete.modo;
                del_agente.mensaje=paquete.mensaje;
                del_agente.empaquetado=paquete.empaquetado;
                del_agente.tiempo_envio=paquete.tiempo_envio;
                del_agente.tiempo_llegada=paquete.tiempo_llegada;
                scb.push_front(del_agente);
                //$display("Checker: Lo que viene del checker ", paquete1);
            end 
                if (test_checker_mbx.num() == 1)begin
                  int salva = test_checker_mbx.num();
                  $display("Numero de solicitudes de reportes en el mailbox = %0d", test_checker_mbx.num());
                  test_checker_mbx.get(tipo_reporte);
                  num_transacciones = tipo_reporte.num_transacciones;
                  numero_reporte = tipo_reporte.num_reportes;
                  profundidad_fifo = tipo_reporte.profundidad_fifo;
     	  		end
                if(checker_mbx.num==0) break;
              end
            end
        end
    endtask
  
   task check(); 
   forever begin
     @(monitor_listo)
        begin
          
          $display("Checker: Monitor listo: ");
          forever begin
          la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) paquete_monitor=new();
            monitor_mbx.get(data_in);
            paquete_monitor.data=data_in;
            paquete_monitor.tiempo_llegada=$time;
      case(data_in [pckg_sz-9: pckg_sz-16])
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
          paquete_monitor.dispo_entrada=16;

    endcase
          //$display("Checker: Lo que viene del monitor: ", paquete_monitor);
            for (int i=0; i<scb.size(); i++) 
                begin
                    error=0; 
                    if (paquete_monitor.data==scb[i].empaquetado[pckg_sz-9:0]) 
                        begin
                          if (paquete_monitor.dispo_entrada==scb[i].dispo_entrada) 
                            begin
                            error=1; 
                            time_delay= paquete_monitor.tiempo_llegada-(scb[i].tiempo_envio);
                            delays.insert(j,time_delay);
                              $display("t = %0d: Checker: Dispositivo que llega del DUT: %d, dispositivo esperado: %d", $time, paquete_monitor.dispo_entrada, scb[i].dispo_entrada);
                              $display("t = %0d: Checker: Dato que llega del DUT: %d, dato esperado: %d", $time, paquete_monitor.data, scb[i].empaquetado[pckg_sz-9:0]);
                              $display("t = %0d: Checker: Todo bien, todo correcto y yo que me alegro, transaccion = ", $time, contador);
                              contador++;
                              if (num_transacciones < contador)begin
                                case(numero_reporte)
                                  	1: begin
                                      $display("HOLAAAAAAAAA SOY EL CASO DE REPORTE 1");
                                      get_delay();
                                      min_max_ab();
                                    end
                                    2: begin
                                      $display("HOLAAAAAAAAA SOY EL CASO DE REPORTE 2");
                                      get_delay();
                                      min_max_ab();
                                    end
                                    3: begin
                                      $display("HOLAAAAAAAAA SOY EL CASO DE REPORTE 3");
                                      get_delay_terminal();
                                      min_max_ab();
                                    end
                                    4: begin
                                      $display("HOLAAAAAAAAA SOY EL CASO DE REPORTE 4");
                                      get_delay();
                                      get_delay_terminal();
                                      min_max_ab();
                                    end
                                  	5: begin
                                      $display("HOLAAAAAAAAA SOY EL CASO DE REPORTE 5");
                                      get_delay();
                                      min_max_ab();
                                    end
                                    6: begin
                                      $display("HOLAAAAAAAAA SOY EL CASO DE REPORTE 6");
                                      get_delay();
                                      get_delay_terminal();
                                      min_max_ab();
                                    end
                                    7: begin
                                      $display("HOLAAAAAAAAA SOY EL CASO DE REPORTE 7");
                                      get_delay();
                                      get_delay_terminal();
                                      min_max_ab();
                                    end
                                endcase
                                contador = 1;
                              end
                              for (int k=0; k<16; k++) 
                              begin
                                if (k==scb[i].dispo_entrada)
                                  begin
                                    delay_list[k].delay=delay_list[k].delay+time_delay; 
                                    delay_list[k].num_transactions= delay_list[k].num_transactions+1; 
                                  end
                                
                              end
                            mensaje.itoa(paquete_monitor.data);
                            dispo_entrada.itoa(paquete_monitor.dispo_entrada);
                            dispo_salida.itoa(scb[i].dispo_salida);
                            tiempo_llegada.itoa(paquete_monitor.tiempo_llegada);
                            tsend.itoa(scb[i].tiempo_envio);
                            receive_delay.itoa(time_delay);
                            ID.itoa(j);
                            
                            outputTXT_line = {ID,comma,tsend,comma,dispo_salida,comma,mensaje,comma,tiempo_llegada,comma,dispo_entrada,comma,receive_delay};
                              $system($sformatf("echo %0s >> salida.txt",outputTXT_line));
                            break; 
                            error = 1;
                            end
                    else $fatal("EL DISPOSITIVO DE LLEGADA Y EL DESTINO DEL MENSAJE NO CONCUERDAN"); 
                end
                  
                end
            j=j+1;
            
          
          end
          
        end
     
     if (!error) $fatal("ERROR, EL DATO RECIBIDO POR EL DRIVER NO CORRESPONDE A NINGÚN DATO ENVIADO");
    end
    
     
  endtask
  
  
  
  //string outputTXT_line, comma = ",";
  	
  	
    /*int delay_total=0; 
    int delay_prom;
    real BW;
    real ab[$];
    string fifo_dp,receive_delay,ID,ab_min,ab_max;*/
  
  
  

 task get_delay();
    for (int i=0; i< delays.size(); i++)begin
      delay_total= (delay_total+delays[i]); 
      end
    	delay_prom=(delay_total/delays.size()); 
      $display("El retraso promedio es de %0d",delay_prom, " ns para una profundidad de Fifo de %0d",profundidad_fifo);
    	BW= (1000000000/delay_prom); 
      $display("El ancho de banda promedio es de %0d", BW, " bps para una profundidad de Fifo de %0d",profundidad_fifo);
      receive_delay.itoa(delay_prom);
      fifo_dp.itoa(profundidad_fifo);
      outputTXT_line = {fifo_dp,",",receive_delay};
      $system($sformatf("echo %0s >> delayprom.csv",outputTXT_line));
  endtask
  
  
  task get_delay_terminal();
    for (int i=0; i<16; i++)
      begin
        delay_list[i].delay_prom= delay_list[i].delay/ (delay_list[i].num_transactions);
          $display ("La terminal %0d", i, " tiene delay de %0d", delay_list[i].delay_prom ," ns con una profundidad de Fifo de %0d",profundidad_fifo);
          BW= (1000000000/delay_list[i].delay_prom);
          ab={BW,ab};
          receive_delay.itoa(delay_list[i].delay_prom);
          fifo_dp.itoa(profundidad_fifo);
          ID.itoa(i);
          outputTXT_line = {ID,",",fifo_dp,",",receive_delay};
          $system($sformatf("echo %0s >> delayterminal.csv",outputTXT_line));
      end
  endtask

  task min_max_ab();
    begin
      real MI[$],MA[$];
      MI=ab.min();
      MA=ab.max();
      ab_min.realtoa(MI[0]);
      ab_max.realtoa(MA[0]);
      fifo_dp.itoa(profundidad_fifo);
      outputTXT_line = {fifo_dp,",",ab_min,",",ab_max};
      $system($sformatf("echo %0s >> ab_prom.csv",outputTXT_line));
      MI={};
      ab={};
      MA={};
    end
      endtask
    
endclass
