{15. La editorial X, autora de diversos semanarios, posee un archivo maestro con la información
correspondiente a las diferentes emisiones de los mismos. De cada emisión se registra:
fecha, código de semanario, nombre del semanario, descripción, precio, total de ejemplares
y total de ejemplares vendido.
Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
actualización del archivo maestro en función de las ventas registradas. Además deberá
informar fecha y semanario que tuvo más ventas y la misma información del semanario con
menos ventas.
Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
ventas de semanarios si no hay ejemplares para hacerlo}

program ejercicio15;
const
    valoralto = 'ZZZ';
    DF = 3;
    //DF = 100;
type
    subrango = 1..DF;
    infoMaestro = record
        fecha: string;
        codigo: integer;
        nombre: string;
        descripcion: string;
        precio: real;
        total: integer;
        totalVendido: integer;
    end;
    infoDetalle = record    
        fecha: string;
        codigo: integer;
        cantVendido: integer;
    end;
    maestro = file of infoMaestro;
    detalle = file of infoDetalle;
    vecDetalles = array [subRango] of detalle;
    vecRegistros = array [subRango] of infoDetalle;
procedure crearMaestro(var mae: maestro);
var
    txt: text;
    infoMae: infoMaestro;
    nombre: string;
begin
    assign(txt, 'semanarios.txt');
    reset(txt);
    writeln('Ingrese un nombre para el archivo maestro');
    readln(nombre);
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(txt)) do
        begin
            with infoMae do
                begin
                    readln(txt, codigo, precio, total, totalVendido, fecha);
                    readln(txt, nombre);
                    readln(txt, descripcion);
                    write(mae, infoMae);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(txt);
    close(mae);
end;
procedure crearUnSoloDetalle(var det: detalle);
var
    carga: text;
    nombre: string;
    infoDet: infoDetalle;
begin
    writeln('Ingrese la ruta del detalle');
    readln(nombre);
    assign(carga, nombre);
    reset(carga);
    writeln('Ingrese un nombre para el archivo detalle');
    readln(nombre);
    assign(det, nombre);
    rewrite(det);
    while(not eof(carga)) do
        begin
            with infoDet do
                begin
                    readln(carga, codigo, cantVendido, fecha);
                    write(det, infoDet);
                end;
        end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;
procedure crearDetalles(var vec: vecDetalles);
var
    i: subrango;
begin
    for i:= 1 to DF do
        crearUnSoloDetalle(vec[i]);
end;
procedure leer(var det: detalle; var infoDet: infoDetalle);
begin
    if(not eof(det)) then
        read(det, infoDet)
    else
        infoDet.fecha:= valoralto;
end;
procedure minimo(var vecDet: vecDetalles; var vecReg: vecRegistros; var min: infoDetalle);
var
    i, pos: subrango;
begin
    min.fecha:= valoralto;
    for i:= 1 to DF do
        if(vecReg[i].fecha < min.fecha) or ((vecReg[i].fecha = min.fecha) and (vecReg[i].codigo < min.codigo)) then
            begin
                min:= vecReg[i];
                pos:= i;
            end;
    if(min.fecha <> valoralto) then
        leer(vecDet[pos], vecReg[pos]);
end;
procedure actualizarMaestro(var mae: maestro; var vecDet: vecDetalles);
var
    vecReg: vecRegistros;
    minD: infoDetalle;
    infoMae: infoMaestro;
    max, min, codMax, codMin, totalVentas: integer;
    fechaMax, fechaMin: string;
    i: subrango;
begin
    max:= -1;
    codMax:= 0;
    fechaMax:= '';
    min:= 9999;
    codMin:= 0;
    fechaMin:= '';
    reset(mae);
    for i:= 1 to DF do
        begin
            reset(vecDet[i]);
            leer(vecDet[i], vecReg[i]);
        end;
    minimo(vecDet, vecReg, minD);
    read(mae, infoMae);
    while(minD.fecha <> valoralto) do
        begin
            while(minD.fecha <> infoMae.fecha) do
                read(mae, infoMae);
            while(minD.fecha = infoMae.fecha) do
                begin
                    while(minD.codigo <> infoMae.codigo) do
                        read(mae, infoMae);
                    totalVentas:= 0;
                    while(minD.fecha = infoMae.fecha) and (minD.codigo = infoMae.codigo) do
                        begin
                            if(infoMae.total >= minD.cantVendido) then
                                begin
                                    infoMae.totalVendido:= infoMae.totalVendido + minD.cantVendido;
                                    infoMae.total:= infoMae.total - minD.cantVendido;
                                    totalVentas:= totalVentas + minD.cantVendido;
                                end;
                            minimo(vecDet, vecReg, minD);
                        end;
                    if(totalVentas > max) then
                        begin
                            max:= totalVentas;
                            fechaMax:= infoMae.fecha;
                            codMax:= infoMae.codigo;
                        end;
                    if(totalVentas < min) then
                        begin
                            min:= totalVentas;
                            fechaMin:= infoMae.fecha;
                            codMin:= infoMae.codigo;
                        end;
                    seek(mae, filepos(mae)-1);
                    write(mae, infoMae);
                end;    
        end;
    writeln('Semanario con mas ventas: Fecha=', fechaMax, ' Codigo=', codMax);
    writeln('Semanario con menos ventas: Fecha=', fechaMin, ' Codigo=', codMin);
    close(mae);
    for i:= 1 to DF do
        close(vecDet[i]);
end;
procedure informarMaestro(var mae: maestro);
var
    infoMae: infoMaestro;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, infoMae);
            writeln('Fecha=', infoMae.fecha, ' Codigo=', infoMae.codigo, ' Total=', infoMae.total, ' Vendido=', infoMae.totalVendido);
        end;
    close(mae);
end;
var
    vec: vecDetalles;
    mae: maestro;
begin
    crearMaestro(mae);
    crearDetalles(vec);
    actualizarMaestro(mae, vec);
    informarMaestro(mae);
end.