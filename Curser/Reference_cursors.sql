Die Skripte demonstrieren den Umgang mit ref cursors und deren Variationen in PL/SQL. Ref Cursors sind dynamische Cursors, die zur Laufzeit erstellt werden und sich flexibel auf verschiedene Abfragen anwenden lassen. Ich werde die Beispiele Schritt für Schritt erklären.

1. Grundlegendes Beispiel: Ref Cursor
declare
  type t_emps is ref cursor return employees%rowtype;
  rc_emps t_emps;
  r_emps employees%rowtype;
begin
  open rc_emps for select * from employees;
  loop
    fetch rc_emps into r_emps;
    exit when rc_emps%notfound;
    dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name);
  end loop;
  close rc_emps;
end;
Erklärung:
t_emps: Ein stark typisierter Ref Cursor, der Zeilen des Typs employees%rowtype zurückgibt.
open rc_emps for select * from employees;: Der Cursor wird mit einer Abfrage geöffnet.
Schleife mit fetch: Zeilen werden in die Variable r_emps geladen und verarbeitet.
%notfound: Beendet die Schleife, sobald keine weiteren Zeilen mehr abgerufen werden können.
2. Zwei verschiedene Abfragen im selben Ref Cursor
declare
  type t_emps is ref cursor return employees%rowtype;
  rc_emps t_emps;
  r_emps employees%rowtype;
begin
  -- Abfrage 1
  open rc_emps for select * from retired_employees;
  loop
    fetch rc_emps into r_emps;
    exit when rc_emps%notfound;
    dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name);
  end loop;
  close rc_emps;

  dbms_output.put_line('--------------');

  -- Abfrage 2
  open rc_emps for select * from employees where job_id = 'IT_PROG';
  loop
    fetch rc_emps into r_emps;
    exit when rc_emps%notfound;
    dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name);
  end loop;
  close rc_emps;
end;
Erklärung:
Der Ref Cursor kann mit mehreren Abfragen verwendet werden, solange er geschlossen und erneut geöffnet wird.
Dies zeigt die Flexibilität eines Ref Cursors bei der Verarbeitung unterschiedlicher Datensätze.
3. Verwendung von %type für Record-Typen
declare
  r_emps employees%rowtype;
  type t_emps is ref cursor return r_emps%type;
  rc_emps t_emps;
begin
  open rc_emps for select * from retired_employees;
  -- Schleife und Verarbeitung wie oben
end;
Erklärung:
%type erlaubt es, Record-Typen basierend auf der Struktur einer Tabelle zu definieren.
Dadurch werden Typinkonsistenzen vermieden.
4. Manuell definierter Record-Typ
declare
  type ty_emps is record (
    e_id number, 
    first_name employees.first_name%type, 
    last_name employees.last_name%type,
    department_name departments.department_name%type
  );
  r_emps ty_emps;
  type t_emps is ref cursor return ty_emps;
  rc_emps t_emps;
begin
  open rc_emps for select employee_id, first_name, last_name, department_name 
                   from employees join departments using (department_id);
  -- Schleife und Verarbeitung
end;
Erklärung:
Ein benutzerdefinierter Record-Typ (ty_emps) wird erstellt, um spezifische Spalten aus mehreren Tabellen zu kombinieren.
Ideal für Szenarien, in denen nur bestimmte Spalten benötigt werden.
5. Weak Ref Cursor
declare
  type t_emps is ref cursor;
  rc_emps t_emps;
  q varchar2(200);
begin
  q := 'select employee_id, first_name, last_name, department_name 
        from employees join departments using (department_id)';
  open rc_emps for q;
  -- Schleife und Verarbeitung
end;
Erklärung:
Weak Ref Cursor: Nicht typisiert, kann jede Abfrage ausführen.
Flexibler als stark typisierte Ref Cursors, aber weniger sicher.
6. Bind-Variablen in Ref Cursors
declare
  type t_emps is ref cursor;
  rc_emps t_emps;
  q varchar2(200);
begin
  q := 'select employee_id, first_name, last_name, department_name 
        from employees join departments using (department_id) where department_id = :t';
  open rc_emps for q using '50';
  -- Schleife und Verarbeitung
end;
Erklärung:
Die Abfrage enthält Platzhalter (:t), die zur Laufzeit durch Bind-Variablen ersetzt werden.
Nützlich für dynamische Abfragen mit unterschiedlichen Parametern.
7. SYS_REFCURSOR
declare
  rc_emps sys_refcursor;
begin
  open rc_emps for select * from employees where department_id = 50;
  -- Schleife und Verarbeitung
end;
Erklärung:
SYS_REFCURSOR ist ein vordefinierter Ref Cursor-Typ.
Funktioniert ähnlich wie ein Weak Ref Cursor, bietet jedoch Standardisierung.
