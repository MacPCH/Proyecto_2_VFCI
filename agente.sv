class Agente #(pckg_sz,ROWS,COLUMS);  
  mailbox agente_mbx;
  mailbox driver_mbx;
  mailbox gen_mbx;
  mailbox checker_mbx;
  event agente_listo;
  event generador_listo;
  task run();
    
    la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) trans=new; 
    $display ("El agente fue inicializado");
  forever begin
    @(generador_listo) begin
      if (agente_mbx.num() != 0) $display("t = %g: Agente: Recibida una orden desde el generador", $time);
       agente_mbx.get(trans);
      
    case(trans.dispo_entrada)
      0: 
        trans.empaquetado={{8'b0},{4'b0},{4'b0001},trans.modo,trans.mensaje};
      1:
        trans.empaquetado={{8'b0}, {4'b0},{4'b0010},trans.modo,trans.mensaje};
      2:
        trans.empaquetado={{8'b0},{4'b0},{4'b11},trans.modo,trans.mensaje};
      3:
        trans.empaquetado={{8'b0},{4'b0},{4'b100},trans.modo,trans.mensaje};
      4:
        trans.empaquetado={{8'b0},{4'b1},{4'b0},trans.modo,trans.mensaje};
      5:
        trans.empaquetado={{8'b0},{4'b10},{4'b0},trans.modo,trans.mensaje};
      6:
        trans.empaquetado={{8'b0},{4'b11},{4'b0},trans.modo,trans.mensaje};
      7:
        trans.empaquetado={{8'b0},{4'b100},{4'b0},trans.modo,trans.mensaje};
      8:
        trans.empaquetado={{8'b0},{4'b101},{4'b1},trans.modo,trans.mensaje};
      9:
        trans.empaquetado={{8'b0},{4'b101},{4'b10},trans.modo,trans.mensaje};
      10:
        trans.empaquetado={{8'b0},{4'b101},{4'b11},trans.modo,trans.mensaje};
      11:
        trans.empaquetado={{8'b0},{4'b101},{4'b100},trans.modo,trans.mensaje};
      12:
        trans.empaquetado={{8'b0},{4'b1},{4'b101},trans.modo,trans.mensaje};
      13:
        trans.empaquetado={{8'b0},{4'b10},{4'b101},trans.modo,trans.mensaje};
      14:
        trans.empaquetado={{8'b0},{4'b11},{4'b101},trans.modo,trans.mensaje};
      15:
        trans.empaquetado={{8'b0},{4'b100},{4'b101},trans.modo,trans.mensaje};
 		  default:
        trans.empaquetado={{8'b0},{4'b1},{4'b1},{1'b0},trans.mensaje};
      endcase
      trans.tiempo_envio=$time;
      driver_mbx.put(trans);
      $display("t = %g: Agente: Enviada la transaccion a el driver, dato = %0d", $time, trans.mensaje);
      checker_mbx.put(trans);
      $display("t = %g: Agente: Enviada la transaccion a el checker", $time);
      ->agente_listo;
      end
    end
  endtask
 endclass
