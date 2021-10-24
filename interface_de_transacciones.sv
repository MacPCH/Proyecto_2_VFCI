//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com) - Susana Astorga Rodríguez (susana.0297.ar@gmail.com)

//**************DEFINICION DE TIPOS DE TRANSACCION**************************
typedef enum {ordenado, esquina, aleatorio, overflow} tipos_trans;//definir los casos de generación del test

//**************DEFINICION DE LOS CASOS DE ESQUINA**************************
typedef enum {fila_primero, columna_primero, error, destino_igual_origen} caso_esquina;//definir los casos de generación del test

interface mesh_if #(parameter pckg_sz,ROWS,COLUMS)(input bit clk, input bit reset); 
    logic pndng[ROWS*2+COLUMS*2];
    logic [pckg_sz-1:0] data_out[ROWS*2+COLUMS*2];
    logic popin[ROWS*2+COLUMS*2];
    logic pop[ROWS*2+COLUMS*2];
  logic [pckg_sz-1:0]data_out_i_in[ROWS*2+COLUMS*2];
    logic pndng_i_in[ROWS*2+COLUMS*2];
endinterface


class la_mama_de_las_transacciones #(parameter pckg_sz, ROWS,  COLUMS);
  	int num_transacciones;
  	bit [pckg_sz-9:0] data;
  	rand bit [3:0] dispo_salida;
  	rand bit [3:0] dispo_entrada;
    bit modo;
    rand bit [pckg_sz-18:0] mensaje;
    rand bit [pckg_sz-1:0] empaquetado;
    rand bit [2:0] delay;
  	int tiempo_envio;
  	int tiempo_llegada;
  
  constraint pay_load {}
  	
endclass


class tipos_de_transacciones ;
  tipos_trans tipo; // valor por default
  int num_transacciones;
  caso_esquina esquina;
endclass

typedef mailbox #(tipos_de_transacciones) comando_test_generador_mbx;
