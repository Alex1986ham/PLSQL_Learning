Das Skript befasst sich mit der Erstellung und Verwendung von Unterprogrammen (Prozeduren und Funktionen) in PL/SQL-Anonymen Blöcken, mit Fokus auf lokale Unterprogramme und deren korrekte Nutzung. Es behandelt verschiedene Szenarien zur Organisation von Unterprogrammen und die Bedeutung des Gültigkeitsbereichs (Scope) von Variablen und Unterprogrammen. Hier die detaillierte Erklärung:

1. Erstellung der Tabelle emps_high_paid
create table emps_high_paid as select * from employees where 1=2;
/
Zweck: Erstellt eine Tabelle emps_high_paid mit derselben Struktur wie die Tabelle employees, jedoch ohne Daten (weil 1=2 immer falsch ist).
Diese Tabelle wird verwendet, um später Mitarbeiter mit einem Gehalt über 15.000 zu speichern.

  
  
  2. Verwendung von Unterprogrammen in einem Anonymen Block – Falsche Nutzung
Code:

declare
  procedure insert_high_paid_emp(emp_id employees.employee_id%type) is 
    emp employees%rowtype;
    begin
      emp := get_emp(emp_id);
      insert into emps_high_paid values emp;
    end;
  function get_emp(emp_num employees.employee_id%type) return employees%rowtype is
    emp employees%rowtype;
    begin
      select * into emp from employees where employee_id = emp_num;
      return emp;
    end;
begin
  for r_emp in (select * from employees) loop
    if r_emp.salary > 15000 then
      insert_high_paid_emp(r_emp.employee_id);
    end if;
  end loop;
end;
Erklärung:

Zweck: Dieser Anonyme Block kopiert Mitarbeiter mit einem Gehalt über 15.000 in die Tabelle emps_high_paid.
Unterprogramme:
Funktion get_emp: Ruft die Details eines Mitarbeiters basierend auf der employee_id aus der Tabelle employees ab und gibt einen Datensatz (rowtype) zurück.
Prozedur insert_high_paid_emp:
Ruft die Funktion get_emp auf, um die Mitarbeiterdaten zu erhalten.
Fügt den erhaltenen Datensatz in die Tabelle emps_high_paid ein.
Fehlerhafte Organisation:
Die Funktion get_emp wird nach der Prozedur insert_high_paid_emp definiert. Das ist ein Problem, weil PL/SQL innerhalb eines Anonymen Blocks keine Vorwärtsdeklaration unterstützt.
Dadurch schlägt die Kompilierung fehl.

  
  
  3. Verwendung von Unterprogrammen in einem Anonymen Block – Korrekte Nutzung
Code:

declare
  function get_emp(emp_num employees.employee_id%type) return employees%rowtype is
    emp employees%rowtype;
    begin
      select * into emp from employees where employee_id = emp_num;
      return emp;
    end;
  procedure insert_high_paid_emp(emp_id employees.employee_id%type) is 
    emp employees%rowtype;
    begin
      emp := get_emp(emp_id);
      insert into emps_high_paid values emp;
    end;
begin
  for r_emp in (select * from employees) loop
    if r_emp.salary > 15000 then
      insert_high_paid_emp(r_emp.employee_id);
    end if;
  end loop;
end;
Erklärung:

Korrektur:
Die Funktion get_emp wird vor der Prozedur insert_high_paid_emp definiert. Dadurch ist sie sichtbar und kann in der Prozedur verwendet werden.
Ablauf:
Die Schleife (FOR-Loop) iteriert durch alle Mitarbeiter in employees.
Wenn das Gehalt eines Mitarbeiters (r_emp.salary) größer als 15.000 ist, ruft der Block die Prozedur insert_high_paid_emp auf.
Die Prozedur verwendet get_emp, um den Datensatz des Mitarbeiters abzurufen, und fügt diesen Datensatz in die Tabelle emps_high_paid ein.

  
  
  4. Gültigkeitsbereich (Scope) von Variablen und Unterprogrammen
Code:

declare
  procedure insert_high_paid_emp(emp_id employees.employee_id%type) is 
    emp employees%rowtype;
    e_id number;
    function get_emp(emp_num employees.employee_id%type) return employees%rowtype is
      begin
        select * into emp from employees where employee_id = emp_num;
        return emp;
      end;
    begin
      emp := get_emp(emp_id);
      insert into emps_high_paid values emp;
    end;
begin
  for r_emp in (select * from employees) loop
    if r_emp.salary > 15000 then
      insert_high_paid_emp(r_emp.employee_id);
    end if;
  end loop;
end;
Erklärung:

Veränderung:
Die Funktion get_emp ist jetzt innerhalb der Prozedur insert_high_paid_emp definiert.
Dadurch ist die Funktion nur innerhalb der Prozedur sichtbar und kann außerhalb nicht verwendet werden.
Ablauf:
Der Ablauf bleibt derselbe wie zuvor.
Der Unterschied liegt im Gültigkeitsbereich (Scope):
Die Funktion get_emp hat einen lokalen Gültigkeitsbereich innerhalb der Prozedur.
Die Variable emp, die in der Funktion verwendet wird, ist dieselbe wie die in der Prozedur deklarierte Variable (emp).
Zusammenfassung
Anonyme Blöcke und Unterprogramme:
Lokale Unterprogramme können innerhalb eines Anonymen Blocks definiert und verwendet werden.
Die Reihenfolge der Definitionen ist entscheidend. Funktionen oder Prozeduren müssen vor ihrer Verwendung definiert werden.
Verschachtelte Unterprogramme:
Unterprogramme können in anderen Unterprogrammen definiert werden, was ihren Gültigkeitsbereich einschränkt und ihre Wiederverwendung außerhalb des spezifischen Kontexts verhindert.
Best Practices:
Halte Unterprogramme nahe beieinander und beachte die Reihenfolge der Deklarationen.
Verwende verschachtelte Unterprogramme nur, wenn sie außerhalb des spezifischen Kontextes nicht benötigt werden.
