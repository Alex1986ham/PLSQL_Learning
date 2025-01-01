Prozedur mit IN-Parametern
  
create or replace procedure increase_salaries (
  v_salary_increase in number, 
  v_department_id pls_integer
) as
    cursor c_emps is select * from employees_copy where department_id = v_department_id for update;
    v_old_salary number;
begin
    for r_emp in c_emps loop
      v_old_salary := r_emp.salary;
      r_emp.salary := r_emp.salary * v_salary_increase + r_emp.salary * nvl(r_emp.commission_pct, 0);
      update employees_copy set row = r_emp where current of c_emps;
      dbms_output.put_line('The salary of : ' || r_emp.employee_id || 
                           ' is increased from ' || v_old_salary || ' to ' || r_emp.salary);
    end loop;
    dbms_output.put_line('Procedure finished executing!');
end;
Erklärung:

IN-Parameter:
v_salary_increase: Der Faktor, um den das Gehalt erhöht wird.
v_department_id: Die ID der Abteilung, deren Mitarbeiter ein Gehaltsupdate erhalten.
Cursor:
Lädt alle Mitarbeiter aus employees_copy, deren department_id mit dem übergebenen Parameter übereinstimmt.
Gehaltsberechnung:
Das Gehalt wird um den Faktor v_salary_increase erhöht. Falls commission_pct nicht NULL ist, wird dieser Wert zusätzlich berücksichtigt.
Ausgabe:
Für jeden betroffenen Mitarbeiter wird das alte und neue Gehalt ausgegeben.


  
Prozedur mit OUT-Parametern
  
create or replace procedure increase_salaries (
  v_salary_increase in out number, 
  v_department_id pls_integer, 
  v_affected_employee_count out number
) as
    cursor c_emps is select * from employees_copy where department_id = v_department_id for update;
    v_old_salary number;
    v_sal_inc number := 0;
begin
    v_affected_employee_count := 0; -- Zählt die betroffenen Mitarbeiter
    for r_emp in c_emps loop
      v_old_salary := r_emp.salary;
      r_emp.salary := r_emp.salary * v_salary_increase + r_emp.salary * nvl(r_emp.commission_pct, 0);
      update employees_copy set row = r_emp where current of c_emps;
      dbms_output.put_line('The salary of : ' || r_emp.employee_id || 
                           ' is increased from ' || v_old_salary || ' to ' || r_emp.salary);
      v_affected_employee_count := v_affected_employee_count + 1; -- Zähler erhöhen
      v_sal_inc := v_sal_inc + v_salary_increase + nvl(r_emp.commission_pct, 0); -- Summe der Erhöhungen
    end loop;
    v_salary_increase := v_sal_inc / v_affected_employee_count; -- Durchschnitt berechnen
    dbms_output.put_line('Procedure finished executing!');
end;


Erklärung:

IN OUT-Parameter:
v_salary_increase: Der Faktor für die Gehaltserhöhung wird als Eingabe verwendet und am Ende auf den durchschnittlichen Erhöhungsfaktor gesetzt.
OUT-Parameter:
v_affected_employee_count: Gibt die Anzahl der betroffenen Mitarbeiter zurück.
Zusätzliche Logik:
Die Gesamtanzahl der betroffenen Mitarbeiter wird gezählt.
Die durchschnittliche Gehaltserhöhung wird berechnet und zurückgegeben.
Einfache Prozedur mit IN-Parameter
CREATE OR REPLACE PROCEDURE PRINT(TEXT IN VARCHAR2) IS
BEGIN
  DBMS_OUTPUT.PUT_LINE(TEXT);
END;
Erklärung:

Diese Prozedur gibt einfach den übergebenen Text aus.
Verwendung der Prozeduren
Prozedur mit IN-Parametern

begin
  PRINT('SALARY INCREASE STARTED!..');
  INCREASE_SALARIES(1.15, 90); -- Erhöht die Gehälter in Abteilung 90 um 15 %
  PRINT('SALARY INCREASE FINISHED!..');
end;
Erklärung:

Die Nachricht "SALARY INCREASE STARTED!.." wird ausgegeben.
Die Prozedur INCREASE_SALARIES wird mit einem Erhöhungsfaktor von 1.15 und der Abteilungs-ID 90 aufgerufen.
Nach Abschluss wird "SALARY INCREASE FINISHED!.." ausgegeben.
Prozedur mit OUT-Parametern

declare
  v_sal_inc number := 1.2;
  v_aff_emp_count number;
begin
  PRINT('SALARY INCREASE STARTED!..');
  INCREASE_SALARIES(v_sal_inc, 80, v_aff_emp_count); -- Berechnet die Gehaltserhöhung in Abteilung 80
  PRINT('The affected employee count is : ' || v_aff_emp_count);
  PRINT('The average salary increase is : ' || v_sal_inc || ' percent!..');
  PRINT('SALARY INCREASE FINISHED!..');
end;
Erklärung:

v_sal_inc wird als Anfangswert für den Erhöhungsfaktor gesetzt.
v_aff_emp_count zählt die betroffenen Mitarbeiter.
Die Prozedur INCREASE_SALARIES berechnet:
Die Gehaltserhöhung für Abteilung 80.
Die Anzahl betroffener Mitarbeiter.
Den durchschnittlichen Erhöhungsfaktor.
Die Ergebnisse werden ausgegeben:
Die Anzahl der betroffenen Mitarbeiter.
Der durchschnittliche Erhöhungsfaktor.
Abschließend wird eine Nachricht ausgegeben, dass die Gehaltserhöhung abgeschlossen ist.
Zusammenfassung
Prozeduren mit IN-Parametern eignen sich für einfache Eingaben wie Gehaltsfaktoren oder Abteilungs-IDs.
Prozeduren mit OUT- und IN OUT-Parametern ermöglichen komplexere Rückgaben wie betroffene Mitarbeiteranzahlen oder berechnete Durchschnittswerte.
Durch die Kombination von Logik und dynamischen Parametern lassen sich wiederverwendbare und flexible Lösungen erstellen.
