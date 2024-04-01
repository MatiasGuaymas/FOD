{16. Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con información
de las motos que posee a la venta. De cada moto se registra: código, nombre, descripción,
modelo, marca y stock actual. Mensualmente se reciben 10 archivos detalles con
información de las ventas de cada uno de los 10 empleados que trabajan. De cada archivo
detalle se dispone de la siguiente información: código de moto, precio y fecha de la venta.
Se debe realizar un proceso que actualice el stock del archivo maestro desde los archivos
detalles. Además se debe informar cuál fue la moto más vendida.
NOTA: Todos los archivos están ordenados por código de la moto y el archivo maestro debe
ser recorrido sólo una vez y en forma simultánea con los detalles.}

program ejercicio16;
const
    valoralto = 9999;
    DF = 3;
    //DF = 10;
type
    subrango = 1..DF;
    infoMaestro = record
        codigo: integer;
        nombre: string;
        descripcion: string;
        modelo: string;
        marca: string;
        stock: integer;
    end;
    infoDetalle = record
        codigo: integer;
        precio: real;
        fecha: string;
    end;
    maestro = file of infoMaestro;
    detalle = file of infoDetalle;
    vecDetalles = array[subrango] of detalle;
    vecRegistros = array[subrango] of infoDetalle;
procedure informarMaestro(var mae: maestro);
var
    infoMae: infoMaestro;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, infoMae);
            writeln('Codigo=', infoMae.codigo, ' Stock=', infoMae.stock);
        end;
    close(mae);
end;
procedure crearMaestro(var mae: maestro);
var
    txt: text;
    infoMae: infoMaestro;
    nombre: string;
begin
    assign(txt, 'motos.txt');
    reset(txt);
    writeln('Ingrese un nombre para el archivo maestro');
    readln(nombre);
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(txt)) do
        begin
            with infoMae do
                begin
                    readln(txt, codigo, stock, nombre);
                    readln(txt, modelo);
                    readln(txt, marca);
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
                    readln(carga, codigo, precio, fecha);
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
        infoDet.codigo:= valoralto;
end;
procedure minimo(var vecDet: vecDetalles; var vecReg: vecRegistros; var min: infoDetalle);
var
    i, pos: subrango;
begin
    min.codigo:= valoralto;
    for i:= 1 to DF do
        if(vecReg[i].codigo < min.codigo) then
            begin
                min:= vecReg[i];
                pos:= i;
            end;
    if(min.codigo <> valoralto) then
        leer(vecDet[pos], vecReg[pos]);
end;
procedure actualizarMaestro(var mae: maestro; var vecDet: vecDetalles);
var
    vecReg: vecRegistros;
    infoMae: infoMaestro;
    min: infoDetalle;
    i: subrango;
    max, codMax, ventas: integer;
begin
    reset(mae);
    codMax:= 0;
    max:= -1;
    for i:= 1 to DF do
        begin
            reset(vecDet[i]);
            leer(vecDet[i], vecReg[i]);
        end;
    minimo(vecDet, vecReg, min);
    read(mae, infoMae);
    while(min.codigo <> valoralto) do
        begin
            while(min.codigo <> infoMae.codigo) do
                read(mae, infoMae);
            ventas:= 0;
            while(min.codigo = infoMae.codigo) do
                begin
                    ventas:= ventas + 1;
                    minimo(vecDet, vecReg, min);
                end;
            infoMae.stock := infoMae.stock - ventas;
            if(ventas > max) then
                begin
                    codMax:= infoMae.codigo;
                    max:= ventas;
                end;
            seek(mae, filepos(mae)-1);
            write(mae, infoMae);
        end;
    writeln('La moto mas vendida fue la moto con codigo: ', codMax);
    close(mae);
    for i:= 1 to DF do
        close(vecDet[i]);
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