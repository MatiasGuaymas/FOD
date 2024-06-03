program parcial;
const
    valoralto = 9999;
type
    infoDetalle = record
        codigo: integer;
        nombre: string;
        cant: integer;
        fecha: string;
    end;
    infoMaestro = record
        codigo: integer;
        nombre: string;
        cant: integer;
    end;
    detalle = file of infoDetalle;
    maestro = file of infoMaestro;
procedure leer(var det: detalle; var info: infoDetalle);
begin
    if(not eof(det)) then
        read(det, info)
    else
        info.codigo:= valoralto;
end;
procedure minimo(var det1, det2, det3: detalle; var info1, info2, info3, min: infoDetalle);
begin
    if((info1.codigo < info2.codigo) and (info1.codigo < info3.codigo)) then
        begin
            min:= info1;
            leer(det1, info1);
        end
    else
        if(info2.codigo < info3.codigo) then
            begin
                min:= info2;
                leer(det2, info2);
            end
        else
            begin
                min:= info3;
                leer(det3, info3);
            end;
end;
procedure merge(var mae: maestro; var det1, det2, det3: detalle);
var
    min, infoDet1, infoDet2, infoDet3: infoDetalle;
    infoMae: infoMaestro;
begin
    reset(det1);
    reset(det2);
    reset(det3);
    assign(mae, 'total_repuestos_vendidos.dat');
    rewrite(mae);
    leer(det1, infoDet1);
    leer(det2, infoDet2);
    leer(det3, infoDet3);
    minimo(det1, det2, det3, infoDet1, infoDet2, infoDet3, min);
    while(min.codigo <> valoralto) do
        begin
            infoMae.codigo:= min.codigo;
            infoMae.nombre:= min.nombre;
            infoMae.cant:= 0;
            while(infoMae.codigo = min.codigo) do
                begin
                    infoMae.cant:= infoMae.cant + min.cant;
                    minimo(det1, det2, det3, infoDet1, infoDet2, infoDet3, min);
                end;
            write(mae, infoMae);
        end;
    close(mae);
    close(det1);
    close(det2);
    close(det3);
end;
procedure imprimirMaestro(var mae: maestro);
var
    i: infoMaestro;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, i);
            writeln('CODIGO=', i.codigo, ' NOMBRE=', i.nombre, ' CANT=', i.cant);
        end;
    close(mae);
end;
procedure crearUnDetalle(var det: detalle);
var
    txt: text;
    i: infoDetalle;
    nombre: string;
begin
    writeln('Ingrese la ruta del detalle');
    readln(nombre);
    assign(txt, nombre);
    reset(txt);
    writeln('Ingrese el nombre del archivo detalle');
    readln(nombre);
    assign(det, nombre);
    rewrite(det);
    while(not eof(txt)) do
        begin
            readln(txt, i.codigo, i.cant, i.nombre);
            write(det, i);
        end;
    close(txt);
    close(det);
end;
var
    det1, det2, det3: detalle;
    mae: maestro;
begin
    crearUnDetalle(det1);
    crearUnDetalle(det2);
    crearUnDetalle(det3);
    merge(mae, det1, det2, det3);
    imprimirMaestro(mae);
end.