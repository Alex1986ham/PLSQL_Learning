Dieses Skript demonstriert die Sichtbarkeit von Variablen und Subprogrammen in Packages in PL/SQL, insbesondere, wie Variablen und Funktionen innerhalb eines Packages verwendet werden können und wie sie für andere Subprogramme sichtbar oder privat bleiben können. Das Package EMP_PKG enthält Variablen, Prozeduren und Funktionen, die aufeinander zugreifen und gemeinsam verwendet werden.

1. Paketstruktur und Schlüsselkonzepte
Ein Package besteht aus:

Spezifikation (nicht im Skript angegeben, wird aber implizit benötigt):
Definiert die öffentlich sichtbaren Prozeduren, Funktionen und Variablen des Packages.
Body:
Implementiert die in der Spezifikation deklarierten Elemente.
Kann auch private Variablen und Subprogramme enthalten, die nur im Body verfügbar sind.
Dieses Skript enthält zwei Versionen des Package-Bodys, die zeigen, wie Variablen und Subprogramme interagieren.


  
  2. Erste Version des Package-Bodys
create or replace PACKAGE BODY EMP_PKG AS
  v_sal_inc int := 500;
  v_sal_inc2 int := 500;
  
  procedure print_test is
  begin
    dbms_output.put_line('Test : '|| v_sal_inc);
  end;
  
  procedure increase_salaries AS
  BEGIN
    for r1 in cur_emps loop
      update employees_copy set salary = salary + salary * v_salary_increase_rate
      where employee_id = r1.employee_id;
    end loop;
  END increase_salaries;

  function get_avg_sal(p_dept_id int) return number AS
    v_avg_sal number := 0;
  BEGIN
    print_test;
    select avg(salary) into v_avg_sal from employees_copy 
    where department_id = p_dept_id;
    RETURN v_avg_sal;
  END get_avg_sal;
END EMP_PKG;
Erläuterung

Globale Variablen
v_sal_inc und v_sal_inc2 sind im gesamten Package-Body sichtbar.
Sie können von allen Subprogrammen im Package-Body genutzt werden.
Prozeduren und Funktionen
print_test:
Gibt den Wert der Variablen v_sal_inc aus.
Zeigt, wie globale Variablen innerhalb von Prozeduren zugänglich sind.
increase_salaries:
Aktualisiert die Gehälter der Mitarbeiter in der Tabelle employees_copy.
Verwendet den Cursor cur_emps und die globale Variable v_salary_increase_rate.
get_avg_sal:
Berechnet das durchschnittliche Gehalt für eine bestimmte Abteilung.
Ruft die Prozedur print_test auf, um den Wert von v_sal_inc auszugeben.
Nutzt SQL-Abfragen, um die Gehälter in employees_copy zu analysieren.

  
  
  3. Zweite Version des Package-Bodys
Die zweite Version des Package-Bodys erweitert die Funktionalität durch die Einführung einer zusätzlichen Funktion get_sal.

create or replace PACKAGE BODY EMP_PKG AS
  v_sal_inc int := 500;
  v_sal_inc2 int := 500;

  function get_sal(e_id employees.employee_id%type) return number;
  
  procedure print_test is
  begin
    dbms_output.put_line('Test : '|| v_sal_inc);
    dbms_output.put_line('Test salary : '|| get_sal(102));
  end;

  procedure increase_salaries AS
  BEGIN
    for r1 in cur_emps loop
      update employees_copy set salary = salary + salary * v_salary_increase_rate
      where employee_id = r1.employee_id;
    end loop;
  END increase_salaries;

  function get_avg_sal(p_dept_id int) return number AS
    v_avg_sal number := 0;
  BEGIN
    print_test;
    select avg(salary) into v_avg_sal from employees_copy 
    where department_id = p_dept_id;
    RETURN v_avg_sal;
  END get_avg_sal;
  
  function get_sal(e_id employees.employee_id%type) return number is
    v_sal number := 0;
  begin
    select salary into v_sal from employees where employee_id = e_id;
    RETURN v_sal;
  end;
END EMP_PKG;
Zusätzliche Funktionalität

get_sal:
Eine Funktion, die das Gehalt eines bestimmten Mitarbeiters anhand seiner employee_id zurückgibt.
Wird innerhalb der Prozedur print_test verwendet, um das Gehalt eines Mitarbeiters (z. B. mit ID 102) anzuzeigen.
Implementiert SQL-Abfragen, um Daten aus der Tabelle employees zu holen.
print_test:
Diese Prozedur zeigt jetzt nicht nur den Wert von v_sal_inc an, sondern ruft auch die Funktion get_sal auf, um das Gehalt eines Mitarbeiters abzurufen und anzuzeigen.

  
  
  
  4. Sichtbarkeit und Gültigkeit
Globale Variablen (v_sal_inc, v_sal_inc2)

Sind im gesamten Package-Body sichtbar.
Können von allen Prozeduren und Funktionen innerhalb des Packages verwendet werden.
Ihre Werte sind persistent, solange das Package im Speicher bleibt.
Funktion get_sal

Wird zuerst in der Spezifikation deklariert und dann im Body implementiert.
Kann von anderen Subprogrammen im Package-Body aufgerufen werden (z. B. von print_test).
Interaktion zwischen Subprogrammen

Die Prozedur print_test demonstriert, wie Subprogramme auf globale Variablen und andere Funktionen zugreifen können.
Durch die Nutzung von get_sal innerhalb von print_test wird gezeigt, wie Subprogramme logisch miteinander kombiniert werden können.

  
  
  5. Nutzung des Packages
Nach der Erstellung des Package-Bodys kann das Package wie folgt verwendet werden:

a) Aufruf einer Prozedur

exec EMP_PKG.increase_salaries;
Aktualisiert die Gehälter der Mitarbeiter in der Tabelle employees_copy.
b) Aufruf einer Funktion

begin
  dbms_output.put_line(EMP_PKG.get_avg_sal(10));
end;
Gibt das durchschnittliche Gehalt der Abteilung mit der ID 10 aus.
c) Aufruf der Prozedur print_test

exec EMP_PKG.print_test;
Gibt den Wert von v_sal_inc und das Gehalt des Mitarbeiters mit ID 102 aus.
Zusammenfassung
Komponente	Beschreibung
v_sal_inc	Globale Variable (Gehaltserhöhung von 500), verfügbar für alle Subprogramme.
print_test	Gibt den Wert von v_sal_inc und das Gehalt eines Mitarbeiters aus.
increase_salaries	Erhöht Gehälter in der Tabelle employees_copy.
get_avg_sal	Berechnet das durchschnittliche Gehalt einer Abteilung.
get_sal	Gibt das Gehalt eines bestimmten Mitarbeiters zurück.
Dieses Skript zeigt, wie die Organisation von Variablen und Subprogrammen in einem Package die Modularität und Wiederverwendbarkeit von PL/SQL-Code verbessert.
