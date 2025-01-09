Das Skript zeigt, wie Prozeduren und Funktionen in einem PL/SQL-Anonymen Block definiert und verwendet werden. Der Fokus liegt auf der Verwendung von überladenen Funktionen (Funktionen mit demselben Namen, aber unterschiedlichen Parametern), um eine flexible Logik zu implementieren. Hier sind die Details:

1. Beschreibung der Hauptprozedur und -Funktionen

declare
  procedure insert_high_paid_emp(p_emp employees%rowtype) is 
    emp employees%rowtype;
    e_id number;
    function get_emp(emp_num employees.employee_id%type) return employees%rowtype is
      begin
        select * into emp from employees where employee_id = emp_num;
        return emp;
      end;
    function get_emp(emp_email employees.email%type) return employees%rowtype is
      begin
        select * into emp from employees where email = emp_email;
        return emp;
      end;
    begin
      emp := get_emp(p_emp.employee_id);
      insert into emps_high_paid values emp;
    end;
begin
  for r_emp in (select * from employees) loop
    if r_emp.salary > 15000 then
      insert_high_paid_emp(r_emp);
    end if;
  end loop;
end;



Erklärung

  1. Hauptprozedur: insert_high_paid_emp

Parameter: p_emp – ein vollständiger Datensatz (rowtype) aus der Tabelle employees.
Aufgabe: Diese Prozedur fügt Mitarbeiter mit einem Gehalt über 15.000 in die Tabelle emps_high_paid ein.
Innerhalb der Prozedur:
Die Funktion get_emp wird aufgerufen, um den vollständigen Datensatz des Mitarbeiters basierend auf seiner employee_id zu erhalten.
Der Datensatz wird dann in die Tabelle emps_high_paid eingefügt.

  
  
  2. Überladene Funktionen: get_emp

Es gibt zwei überladene Versionen der Funktion get_emp:
Basierend auf employee_id:
Parameter: emp_num vom Typ employees.employee_id%type.
Aufgabe: Holt den Datensatz des Mitarbeiters, dessen employee_id dem Parameter entspricht.
Basierend auf email:
Parameter: emp_email vom Typ employees.email%type.
Aufgabe: Holt den Datensatz des Mitarbeiters, dessen email dem Parameter entspricht.

  
  
  3. Hauptlogik im BEGIN-Block

Eine Schleife (FOR-Loop) iteriert durch alle Datensätze in der Tabelle employees.
Wenn das Gehalt eines Mitarbeiters (r_emp.salary) größer als 15.000 ist:
Die Prozedur insert_high_paid_emp wird mit dem gesamten Datensatz des Mitarbeiters (r_emp) aufgerufen.
Die Prozedur verwendet die Funktion get_emp und fügt den Datensatz in die Tabelle emps_high_paid ein.

  
  
  2. Überladen mit mehreren Verwendungen

declare
  procedure insert_high_paid_emp(p_emp employees%rowtype) is 
    emp employees%rowtype;
    e_id number;
    function get_emp(emp_num employees.employee_id%type) return employees%rowtype is
      begin
        select * into emp from employees where employee_id = emp_num;
        return emp;
      end;
    function get_emp(emp_email employees.email%type) return employees%rowtype is
      begin
        select * into emp from employees where email = emp_email;
        return emp;
      end;
    function get_emp(f_name varchar2, l_name varchar2) return employees%rowtype is
      begin
        select * into emp from employees where first_name = f_name and last_name = l_name;
        return emp;
      end;
    begin
      emp := get_emp(p_emp.employee_id);
      insert into emps_high_paid values emp;
      emp := get_emp(p_emp.email);
      insert into emps_high_paid values emp;
      emp := get_emp(p_emp.first_name,p_emp.last_name);
      insert into emps_high_paid values emp;
    end;
begin
  for r_emp in (select * from employees) loop
    if r_emp.salary > 15000 then
      insert_high_paid_emp(r_emp);
    end if;
  end loop;
end;



Erklärung

  
  
  1. Hauptprozedur: insert_high_paid_emp

Die Prozedur bleibt ähnlich wie in der ersten Version.
Der Unterschied ist, dass nun drei Varianten der Funktion get_emp verwendet werden:
Basierend auf employee_id (wie zuvor).
Basierend auf email (wie zuvor).
Basierend auf first_name und last_name:
Diese Funktion erhält zwei Parameter (f_name und l_name).
Sie holt den Datensatz des Mitarbeiters, dessen Vor- und Nachname den Parametern entsprechen.

  
  2. Erweiterte Logik in der Prozedur

Dreifacher Funktionsaufruf:
get_emp wird mit der employee_id aufgerufen, und der Datensatz wird in emps_high_paid eingefügt.
get_emp wird mit der email aufgerufen, und der Datensatz wird in emps_high_paid eingefügt.
get_emp wird mit first_name und last_name aufgerufen, und der Datensatz wird in emps_high_paid eingefügt.

  
  3. Hauptlogik im BEGIN-Block

Der Ablauf bleibt gleich:
Es wird geprüft, ob das Gehalt des Mitarbeiters über 15.000 liegt.
Die Prozedur insert_high_paid_emp wird aufgerufen und fügt basierend auf den drei Varianten von get_emp drei Datensätze in emps_high_paid ein.
Schlüsselkonzepte


  
  1. Überladung von Funktionen
In PL/SQL können Funktionen (und Prozeduren) überladen werden, indem dieselbe Funktion mit unterschiedlichen Parameterlisten definiert wird.
Der PL/SQL-Compiler entscheidet anhand der übergebenen Parameter, welche Version der Funktion aufgerufen wird.

  
  2. Lokale Unterprogramme
Funktionen und Prozeduren, die innerhalb eines anderen Unterprogramms definiert werden, sind nur in diesem Kontext sichtbar.
Das ermöglicht die Wiederverwendung von Logik, ohne dass andere Teile des Programms davon betroffen sind.

  
  3. Gültigkeitsbereich (Scope)
Die Variable emp in der Funktion get_emp und der Prozedur insert_high_paid_emp ist lokal und existiert nur innerhalb des jeweiligen Kontexts.
Dies schützt die Datenintegrität und verhindert unbeabsichtigte Änderungen.
Zusammenfassung

Flexibilität durch Überladung:
Mehrere Versionen der Funktion get_emp erlauben flexible Methoden, um Datensätze abzurufen.
Mehrfache Datenverarbeitung:
In der zweiten Version wird ein Datensatz auf drei verschiedene Arten verarbeitet (nach employee_id, email und Namen).
Wiederverwendbare Logik:
Die Struktur zeigt, wie Unterprogramme verwendet werden können, um redundante Logik zu minimieren.
Best Practices:
Überladene Funktionen sollten klar und effizient definiert werden, um Missverständnisse oder Performanceprobleme zu vermeiden.
