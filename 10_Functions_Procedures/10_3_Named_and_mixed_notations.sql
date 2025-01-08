
1. Prozedur PRINT mit einem Standardwert
create or replace PROCEDURE PRINT(TEXT IN VARCHAR2 := 'This is the print function!.') IS
BEGIN
  DBMS_OUTPUT.PUT_LINE(TEXT);
END;
Definition: Diese Prozedur gibt einen Text aus, der über den Parameter TEXT übergeben wird. Wenn kein Wert übergeben wird, wird der Standardwert 'This is the print function!.' verwendet.
DBMS_OUTPUT.PUT_LINE: Gibt eine Ausgabe auf der Konsole aus.

  

  2. Prozedur ohne Parameter ausführen
exec print();
Erklärung: Hier wird die Prozedur PRINT ohne Argument aufgerufen. Da ein Standardwert für TEXT definiert ist, wird der Standardwert verwendet: 'This is the print function!.'.

  
  3. Prozedur mit NULL als Parameter ausführen
exec print(null);
Erklärung: Wenn NULL explizit als Wert übergeben wird, wird der Standardwert nicht verwendet. Stattdessen wird NULL ausgegeben.

  
  4. Prozedur ADD_JOB mit Standardwerten
create or replace procedure add_job(job_id pls_integer, job_title varchar2, 
                                    min_salary number default 1000, max_salary number default null) is
begin
  insert into jobs values (job_id, job_title, min_salary, max_salary);
  print('The job : '|| job_title || ' is inserted!..');
end;
Definition: Diese Prozedur fügt einen Datensatz in die Tabelle jobs ein und verwendet Standardwerte für die Parameter min_salary und max_salary, falls diese nicht übergeben werden.
job_id: ID des Jobs (Pflicht).
job_title: Titel des Jobs (Pflicht).
min_salary: Mindestgehalt (optional, Standardwert: 1000).
max_salary: Maximalgehalt (optional, Standardwert: NULL).
Zusätzliche Aktion: Nach dem Einfügen wird eine Nachricht über die Prozedur PRINT ausgegeben.

  
  5. Standardausführung der Prozedur
exec ADD_JOB('IT_DIR', 'IT Director', 5000, 20000); 
Erklärung: Die Prozedur wird mit allen Parametern aufgerufen. Es wird ein neuer Job mit den folgenden Werten eingefügt:
job_id: 'IT_DIR'
job_title: 'IT Director'
min_salary: 5000
max_salary: 20000

  
  6. Ausführung der Prozedur mit Standardwerten
exec ADD_JOB('IT_DIR2', 'IT Director', 5000); 
Erklärung: Hier wird der Parameter max_salary weggelassen. Der Standardwert (NULL) wird verwendet.

  
  7. Ausführung mit benannter Notation
exec ADD_JOB('IT_DIR5', 'IT Director', max_salary => 10000);
Erklärung: Mithilfe der benannten Notation (max_salary => 10000) kann ein spezifischer Parameter gesetzt werden, unabhängig von der Reihenfolge der Parameter in der Prozedurdefinition. Hier wird:
job_id: 'IT_DIR5'
job_title: 'IT Director'
min_salary: Standardwert 1000
max_salary: 10000

  
  8. Weitere benannte Notation
exec ADD_JOB(job_title => 'IT Director', job_id => 'IT_DIR7', max_salary => 10000, min_salary => 500);
Erklärung: Die benannte Notation erlaubt es, die Reihenfolge der Parameter vollständig zu ignorieren. Die Werte werden den Parametern wie folgt zugewiesen:
job_id: 'IT_DIR7'
job_title: 'IT Director'
min_salary: 500
max_salary: 10000
Zusammenfassung
Dieses Skript demonstriert die Flexibilität von Prozeduren in PL/SQL:

Standardwerte ermöglichen es, Prozeduren flexibler und benutzerfreundlicher zu gestalten.
Benannte Notation bietet mehr Kontrolle und Klarheit beim Aufruf von Prozeduren.
Prozeduren können sowohl Datenmanipulation (z. B. Einfügen von Werten) als auch andere Operationen (z. B. Ausgeben von Text) kombinieren.
