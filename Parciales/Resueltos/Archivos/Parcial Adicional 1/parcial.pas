program parcial;
const
    valoralto = 9999;
    //DF = 5;
    DF =2;
type
    subRango = 1..DF;
    infoArchivo = record
        dni: integer;
        apellido: string;
        km: real;
        ganadas: integer;
    end;
    archivo = file of infoArchivo;
    vecDetalles = array[subRango] of archivo;
    vecRegistros = array[subRango] of infoArchivo;
procedure leer(var det: archivo; var info: infoArchivo);
begin
    if(not eof(det)) then
        read(det, info)
    else
        info.dni:= valoralto;
end;
procedure minimo(var vecDet: vecDetalles; var vecReg: vecRegistros; var min: infoArchivo);
var
    i, pos: subRango;
begin
    min.dni:= valoralto;
    for i:= 1 to DF do
        if(vecReg[i].dni < min.dni) then
            begin
                min:= vecReg[i];
                pos:= i;
            end;
    if(min.dni <> valoralto) then
        leer(vecDet[pos], vecReg[pos]);
end;
procedure merge(var mae: archivo; var vecDet: vecDetalles);
var
    vecReg: vecRegistros;
    infoMae, min: infoArchivo;
    i: subRango;
begin
    assign(mae, 'ArchivoMaestro');
    rewrite(mae);
    for i:= 1 to DF do
        begin
            reset(vecDet[i]);
            leer(vecDet[i], vecReg[i]);
        end;
    minimo(vecDet, vecReg, min);
    while(min.dni <> valoralto) do
        begin
            infoMae.dni:= min.dni;
            infoMae.apellido:= min.apellido;
            infoMae.km:= 0;
            infoMae.ganadas:= 0;
            while(infoMae.dni = min.dni) do
                begin
                    infoMae.km:= infoMae.km + min.km;
                    if(min.ganadas = 1) then
                        infoMae.ganadas:= infoMae.ganadas + 1;
                    minimo(vecDet, vecReg, min);
                end;
            write(mae, infoMae);
        end;
    close(mae);
    for i:= 1 to DF do
        close(vecDet[i]);
end;
procedure imprimirMaestro(var mae: archivo);
var
    i: infoArchivo;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, i);
            writeln('DNI=', i.dni, ' APELLIDO=', i.apellido, ' KMTOTALES=', i.km:0:2, ' GANADAS=', i.ganadas);
        end;
    close(mae);
end;
procedure crearUnDetalle(var det: archivo);
var
    txt: text;
    i: infoArchivo;
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
            readln(txt, i.dni, i.km, i.ganadas, i.apellido);
            write(det, i);
        end;
    close(txt);
    close(det);
end;
procedure crearDetalles(var vecDet: vecDetalles);
var
    i: subRango;
begin
    for i:= 1 to DF do
        crearUnDetalle(vecDet[i]);
end;
var
    vecDet: vecDetalles;
    mae: archivo;
begin
    crearDetalles(vecDet);
    merge(mae, vecDet);
    imprimirMaestro(mae);
end.