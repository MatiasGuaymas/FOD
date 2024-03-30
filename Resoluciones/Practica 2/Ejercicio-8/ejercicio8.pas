{8. Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
por la empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.
Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras. No es necesario que informe tales meses en el reporte.}

program ejercicio8;
const
    valoralto = 999;
type
    venta = record  
        codigo: integer;
        nombre: string;
        apellido: string;
        anio: integer;
        mes: integer;
        dia: integer;
        monto: real;
    end;
    maestro = file of venta;
procedure crearMaestro(var mae: maestro);
var
    txt: text;
    infoMae: venta;
    nombre: string;
begin
    assign(txt, 'ventas.txt');
    reset(txt);
    writeln('Ingrese un nombre para el archivo maestro');
    readln(nombre);
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(txt)) do
        begin
            with infoMae do
                begin
                    readln(txt, codigo, anio, mes, dia, monto, nombre);
                    readln(txt, apellido);
                    write(mae, infoMae);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(txt);
    close(mae);
end;
procedure leer(var mae: maestro; var infoMae: venta);
begin
    if(not eof(mae)) then
        read(mae, infoMae)
    else
        infoMae.codigo:= valoralto;
end;
procedure recorrerMaestro(var mae: maestro);
var
    infoMae: venta;
    montoTotalVentas, montoAnio, montoMes: real;
    codigoActual, anioActual, mesActual: integer;
begin
    reset(mae);
    montoTotalVentas:= 0;
    leer(mae, infoMae);
    while(infoMae.codigo <> valoralto) do
        begin
            writeln();
            writeln('Cliente=', infoMae.codigo, ' Nombre=', infoMae.nombre, ' Apellido=', infoMae.apellido);
            codigoActual:= infoMae.codigo;
            while(codigoActual = infoMae.codigo) do
                begin
                    anioActual:= infoMae.anio;
                    montoAnio:= 0;
                    writeln('Anio=', infoMae.anio);
                    while(codigoActual = infoMae.codigo) and (anioActual = infoMae.anio) do
                        begin
                            mesActual:= infoMae.mes;
                            montoMes:= 0;
                            while(codigoActual = infoMae.codigo) and (anioActual = infoMae.anio) and (mesActual = infoMae.mes) do
                                begin
                                    montoMes:= montoMes + infoMae.monto;
                                    leer(mae, infoMae);
                                end;
                            if(montoMes <> 0) then
                                begin
                                    writeln('Mes=', mesActual, ' Recaudado=', montoMes:0:2);
                                    montoAnio:= montoAnio + montoMes;
                                end;
                        end;
                    writeln('Recaudado en el anio ', anioActual,'=', montoAnio:0:2);
                    if(codigoActual = infoMae.codigo) then
                        writeln();
                    montoTotalVentas:= montoTotalVentas + montoAnio;
                end;
        end;
    writeln('Monto total recaudado de la empresa=', montoTotalVentas:0:2);
    close(mae);
end;
var
    mae: maestro;
begin
    crearMaestro(mae);
    recorrerMaestro(mae);
end.
