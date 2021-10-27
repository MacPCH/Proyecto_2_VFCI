//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com)

class retraso_terminal;
  int num_transactions = 0;
  int retraso = 0;
  int retraso_prom;
  int identifier; 
endclass

class Checker #(parameter pckg_sz,  ROWS,  COLUMS,  FIFO_depth);

    string mensaje, dispo_entrada, dispo_salida, tiempo_llegada, tsend, receive_retraso,ID;
    string outputTXT_line, comma = ",";
    bit timeout = 1'b0;
  	int sal=0;
  	int tiempo_salvado;
  	int tiempo_salvado2 = 0;
  	time tiempo_salvado3 = 0;
    int retraso_total=0; 
    int retraso_prom;
    real BW;
    real ab[$];
    string fifo_dp,receive_retraso,ID,ab_min,ab_max;
  	int contador4=1;
  	int contador22=1;
    int num_transacciones = 0;
    event agente_listo;
    event monitor_listo;
  	event checker_listo;
    bit [pckg_sz-9:0] data_in;
    time retrasos [$];
    int time_retraso;
  	int contador = 1;
    bit error;
  	int profundidad_fifo;
  	int numero_reporte;
  	
    retraso_terminal retraso_list [$];
  	la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) paquete;
    mailbox checker_mbx;
    mailbox monitor_mbx;
  	mailbox test_mbx;
  	comando_test_checker_mbx test_checker_mbx;
    tipos_de_reportes tipo_reporte = new();
  	
    int j=0; 

  la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) scb[$];

    task retraso_terminal_prom(); 
      
      for (int i =0 ; i<=ROWS*COLUMS ; i++) begin
            retraso_terminal  retraso_new = new();
            retraso_new.identifier=i; 
            retraso_new.num_transactions=0; 
            retraso_new.retraso=0; 
            retraso_new.retraso_prom=0; 
            retraso_list.insert(i, retraso_new); 
      end
    endtask

    task run(); 
      $display ("El checker fue inicializado");
      $system("echo Dispositivo,Tiempo_Envio ns,Terminal_Procedencia,Dato,Tiempo_Recibido[ns],Terminal_Llegada,Retraso[ns] > salida.txt");
      $system("echo Profundidad_FIFO, retraso ns > retrasoprom.csv");
      $system("echo Dispositivo,Tiempo_Envio ns,Terminal_Procedencia,Dato,Tiempo_Recibido[ns],Terminal_Llegada,Retraso[ns] > ab_prom.csv");
      $system("echo Dispositivo, profundidad_FIFO, retraso ns > retrasoterminal.csv");
        forever begin
          //always @(posedge (interface_virtual.clk)) $display("Tiempo actual = %0d", $time);
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
                tiempo_salvado3 = $time;
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
   	   #50000@(checker_listo)begin
         if (num_transacciones >= contador) begin 
           $display("Hubo perdida de comprobacion de datos por overflow");
         end
           
       case(numero_reporte)
         1: begin
           $display("Checker: HOLA! SOY EL CASO DE REPORTE 1");
           get_retraso();
           min_max_ab();

         end
         2: begin
           $display("Checker: HOLA! SOY EL CASO DE REPORTE 2");
           get_retraso();
           min_max_ab();
         end
         3: begin
           $display("Checker: HOLA! SOY EL CASO DE REPORTE 3");
           get_retraso_terminal();
           min_max_ab();
         end
         4: begin
           $display("Checker: HOLA! SOY EL CASO DE REPORTE 4");
           get_retraso();
           get_retraso_terminal();
           min_max_ab();
         end
         5: begin
           $display("Checker: HOLA! SOY EL CASO DE REPORTE 5");
           get_retraso();
           min_max_ab();
         end
         6: begin
           $display("Checker: HOLA! SOY EL CASO DE REPORTE 6");
           get_retraso();
           get_retraso_terminal();
           min_max_ab();
         end
         7: begin
           $display("Checker: HOLA! SOY EL CASO DE REPORTE 7");
           get_retraso();
           get_retraso_terminal();
           min_max_ab();
         end
       endcase
       contador = 1;
       //tiempo_salvado = 0;
       tiempo_salvado2 = $time;
     end
        end
    endtask
  	
  
  	
   task check(); 
   forever begin
     tiempo_salvado = $time;
     $display("Tiempo actual = %0d", $time);
     
     
     @(monitor_listo)
        begin
          $display("CNumero de veces que el contador estuvo listo: %0d", contador4);
          contador4++;
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
            sal = $time-tiempo_salvado3;
            //$display("Tiempo actual = %0d", $time);
            /*if(sal > 1688) begin
              $display("Cambio de prueba! tiempo cal = %0d, tiempo salvado = %0d, tiempo actual = %0d", sal, tiempo_salvado3, $time); 
              timeout = 1'b1;
          end*/
            
            for (int i=0; i<scb.size(); i++) 
                begin
                  
                  tiempo_salvado = $realtime;
                  //$display("Tiempo salvado = %0d", tiempo_salvado);
                    error=0; 
                    if (paquete_monitor.data==scb[i].empaquetado[pckg_sz-9:0]) 
                        begin
                          if (paquete_monitor.dispo_entrada==scb[i].dispo_entrada) 
                            begin
                            error=1; 
                            time_retraso= paquete_monitor.tiempo_llegada-(scb[i].tiempo_envio);
                            retrasos.insert(j,time_retraso);
                              tiempo_salvado = $time - tiempo_salvado2;
                              $display("t = %0d: Checker: Dispositivo que llega del DUT: %d, dispositivo esperado: %d", $time, paquete_monitor.dispo_entrada, scb[i].dispo_entrada);
                              $display("t = %0d: Checker: Dato que llega del DUT: %d, dato esperado: %d", $time, paquete_monitor.data, scb[i].empaquetado[pckg_sz-9:0]);
                              $display("t = %0d: Checker: Todo bien, todo correcto y yo que me alegro, transaccion = ", $time, contador);
                              
                              $display("Diracion del checkeo = %0d", tiempo_salvado2-tiempo_salvado);
                              tiempo_salvado2 = $time;
                              contador++;
                              for (int k=0; k<16; k++) 
                              begin
                                if (k==scb[i].dispo_entrada)
                                  begin
                                    retraso_list[k].retraso=retraso_list[k].retraso+time_retraso; 
                                    retraso_list[k].num_transactions= retraso_list[k].num_transactions+1; 
                                  end
                                
                              end
                            mensaje.itoa(paquete_monitor.data);
                            dispo_entrada.itoa(paquete_monitor.dispo_entrada);
                            dispo_salida.itoa(scb[i].dispo_salida);
                            tiempo_llegada.itoa(paquete_monitor.tiempo_llegada);
                            tsend.itoa(scb[i].tiempo_envio);
                            receive_retraso.itoa(time_retraso);
                            ID.itoa(j);
                            
                            outputTXT_line = {ID,comma,tsend,comma,dispo_salida,comma,mensaje,comma,tiempo_llegada,comma,dispo_entrada,comma,receive_retraso};
                              $system($sformatf("echo %0s >> salida.txt",outputTXT_line));
                            break; 
                            error = 1;
                            end
                    else $fatal("EL DISPOSITIVO DE LLEGADA Y EL DESTINO DEL MENSAJE NO CONCUERDAN");
                    
                end
                  tiempo_salvado2 = $time;
                  
                end
            j=j+1;
          	contador22++;
            
          end
        end
     
     if (!error) begin $fatal("ERROR, EL DATO RECIBIDO POR EL DRIVER NO CORRESPONDE A NINGÚN DATO ENVIADO"); end
     
    end
    
     
  endtask
  
 task get_retraso();
    for (int i=0; i< retrasos.size(); i++)begin
      retraso_total= (retraso_total+retrasos[i]); 
      end
    	retraso_prom=(retraso_total/retrasos.size()); 
      $display("El retraso promedio es de %0d",retraso_prom, " ns para una profundidad de Fifo de %0d",profundidad_fifo);
    	BW= (1000000000/retraso_prom); 
      $display("El ancho de banda promedio es de %0d", BW, " bps para una profundidad de Fifo de %0d",profundidad_fifo);
      receive_retraso.itoa(retraso_prom);
      fifo_dp.itoa(profundidad_fifo);
      outputTXT_line = {fifo_dp,",",receive_retraso};
      $system($sformatf("echo %0s >> retrasoprom.csv",outputTXT_line));
  endtask
  
  
  task get_retraso_terminal();
    for (int i=0; i<16; i++)
      begin
        retraso_list[i].retraso_prom= retraso_list[i].retraso/ (retraso_list[i].num_transactions);
          $display ("La terminal %0d", i, " tiene retraso de %0d", retraso_list[i].retraso_prom ," ns con una profundidad de Fifo de %0d",profundidad_fifo);
          BW= (1000000000/retraso_list[i].retraso_prom);
          ab={BW,ab};
          receive_retraso.itoa(retraso_list[i].retraso_prom);
          fifo_dp.itoa(profundidad_fifo);
          ID.itoa(i);
          outputTXT_line = {ID,",",fifo_dp,",",receive_retraso};
          $system($sformatf("echo %0s >> retrasoterminal.csv",outputTXT_line));
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
