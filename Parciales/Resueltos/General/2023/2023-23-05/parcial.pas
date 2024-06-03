program parcial;
type
    profesional = record
        dni: integer;
        nombre: string;
        apellido: string;
        sueldo: real;
    end;
    tArchivo = file of profesional;
procedure crear(var arch: tArchivo; var info: text);
var
    p: profesional;
begin
    reset(info);
    rewrite(arch);
    while(not eof(info)) do
        begin
            readln(info, p.dni, p.sueldo, p.nombre);
            readln(info, p.apellido);
            write(arch, p);
        end;
    close(arch);
    close(info);
end;
function ExisteProfesional(var a: tArchivo; dni: integer): boolean;
var
    ok: boolean;
    p: profesional;
begin
    reset(a);
    ok:= false;
    while((not eof(a)) and (not ok)) do
        begin
            read(a, p);
            if(p.dni = dni) then
                ok:= true;
        end;
    close(a);
    ExisteProfesional:= ok;
end;
procedure agregar(var arch: tArchivo; p: profesional);
var
    cabecera: profesional;
begin
    if(not ExisteProfesional(arch, p.dni)) then
        begin
            reset(arch);
            read(arch, cabecera);
            if(cabecera.dni = 0) then
                begin
                    seek(arch, filesize(arch));
                    write(arch, p);
                end
            else
                begin
                    seek(arch, cabecera.dni*-1);
                    read(arch, cabecera);
                    seek(arch, filepos(arch)-1);
                    write(arch, p);
                    seek(arch, 0);
                    write(arch, cabecera);
                end;
            close(arch);
        end;
end;
procedure eliminar(var arch: tArchivo; dni: integer; var bajas: text);
var
    cabecera, p: profesional;
begin
    if(ExisteProfesional(arch, dni)) then
        begin
            reset(arch);
            read(arch, cabecera);
            read(arch, p);
            while(p.dni <> dni) do
                read(arch, p);
            seek(arch, filepos(arch)-1);
            write(arch, cabecera);
            cabecera.dni:= (filepos(arch)-1)*-1;
            seek(arch, 0);
            write(arch, cabecera);
            writeln(bajas, p.dni, ' ', p.sueldo:0:2, p.nombre);
            writeln(bajas, p.apellido);
            close(arch);
        end;
end;
procedure imprimirArchivo(var a: tArchivo);
var
    p: profesional;
begin
    reset(a);
    while(not eof(a)) do
        begin
            read(a, p);
            write(p.dni, ' ~ ');
        end;
    close(a);
end;

var
    a: tArchivo;
    txt, txtBajas: text;
    p: profesional;
begin
    assign(a, 'ArchivoMaestro');
    assign(txt, 'profesionales.txt');
    crear(a, txt);
    assign(txtBajas, 'bajas.txt');
    rewrite(txtBajas);
    p.dni:= 33;
    p.nombre:= 'Matias';
    p.apellido:= 'Guaymas';
    p.sueldo:= 100;
    eliminar(a, 10, txtBajas);
    close(txtBajas);
    imprimirArchivo(a);
    agregar(a, p);
    writeln();
    imprimirArchivo(a);
end.