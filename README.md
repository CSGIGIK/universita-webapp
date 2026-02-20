# universita-webapp
# Documentazione Tecnica – Applicazione Web “universita”

---

## 1) Panoramica del sistema

L’applicazione è una **web application Java** basata su **Servlet** e **JSP**, pensata per la gestione di:

- Autenticazione di studenti e professori
- Visualizzazione dei corsi e degli appelli
- Prenotazione agli appelli da parte degli studenti
- Visualizzazione degli studenti prenotati da parte dei professori

Caratteristiche generali:

- Application server: **Apache Tomcat** (esecuzione locale tramite plugin **SmartTomcat**).
- Persistenza: accesso diretto a database **MySQL** (schema `universita`) tramite **JDBC**.
- Architettura logica: pattern **MVC semplificato** (Servlet come Controller, JSP come View, DB relazionale come Model).

Struttura rilevante del progetto:

- **Controller (Servlet)** – package `mypackage`:
  - `mypackage.login` (`/login`)
  - `mypackage.Prenotazione` (`/Prenotazione`)
  - `mypackage.Prenota` (`/Prenota`)
  - `mypackage.StampaStudenti` (`/StampaStudenti`)
- **Modello infrastrutturale**:
  - `mypackage.Connessione` (gestione connessione JDBC a MySQL).
- **View (JSP)**:
  - `index.jsp` (home, UTF‑8)
  - `login.jsp` (form login, UTF‑8)
  - `studente.jsp` (area studente, ISO‑8859‑1)
  - `professore.jsp` (area professore, ISO‑8859‑1)
  - `logout.jsp` (logout, ISO‑8859‑1)
- **Configurazione server (SmartTomcat)**:
  - `.smarttomcat/universita/conf/web.xml`  
    Questo è il `web.xml` di **Tomcat**, non dell’applicazione.  
    L’applicazione utilizza le **annotation** `@WebServlet` per definire i mapping delle Servlet (modello Servlet 3.0+ annotation-driven).

---

## 2) Stack tecnologico e standard di riferimento

- **Linguaggio**: Java (Servlet API).
- **Java Servlet API**:
  - Uso di `@WebServlet` per definire i mapping (`/login`, `/Prenotazione`, `/Prenota`, `/StampaStudenti`).
  - Servlet che estendono `HttpServlet` e implementano i metodi `doGet` e `doPost`.
- **JSP (JavaServer Pages)**:
  - Utilizzo di **scriptlet** (`<% ... %>`) per l’accesso a `ResultSet` e sessione.
  - Non sono presenti JSTL né Expression Language (EL).
- **JDBC con MySQL**:
  - Driver utilizzato: `com.mysql.jdbc.Driver` (legacy; standard attuale: `com.mysql.cj.jdbc.Driver`).
  - Gestione connessione tramite `DriverManager.getConnection(...)` in una `Connection` statica.
  - Query sia tramite `PreparedStatement` (per input utente) sia tramite `Statement` (per ID derivati dal DB).
- **Application Server**: Apache Tomcat (configurato con SmartTomcat).
- **Codifica caratteri**:
  - `index.jsp`, `login.jsp`: UTF‑8.
  - `studente.jsp`, `professore.jsp`, `logout.jsp`: ISO‑8859‑1.
  - Best practice: allineare l’intera applicazione a UTF‑8 (JSP, DB, connettore JDBC).

---

## 3) Architettura logica: pattern MVC semplificato

L’applicazione segue un pattern **Model–View–Controller (MVC)** in forma didattica:

- **Model**:
  - Database relazionale MySQL (schema `universita`).
  - Query JDBC definite direttamente all’interno delle Servlet.
  - Classe infrastrutturale `Connessione` che fornisce una `Connection` condivisa.
  - In un’architettura più avanzata, questo livello sarebbe incapsulato in DAO/Repository.

- **View**:
  - Pagine JSP (`index.jsp`, `login.jsp`, `studente.jsp`, `professore.jsp`, `logout.jsp`).
  - Le JSP leggono dati da:
    - `HttpServletRequest` (attributi impostati dai Controller).
    - `HttpSession` (es. `matricola`, `nome`, `cognome`, `materia`).
  - Rendering in HTML con scriptlet che consumano `ResultSet`.

- **Controller (Servlet)**:
  - `login`, `Prenotazione`, `Prenota`, `StampaStudenti`.
  - Ricevono richieste HTTP (`doGet` / `doPost`).
  - Validano i parametri di input.
  - Interagiscono con il database tramite JDBC.
  - Preparano dati e li passano alle View tramite `request.setAttribute(...)` e `HttpSession`.
  - Effettuano `RequestDispatcher.forward(request, response)` verso la JSP appropriata.

Nel modello MVC:

1. L’utente interagisce con la **View** (JSP/form HTML).
2. La View invia una richiesta HTTP verso il **Controller** (Servlet).
3. Il Controller usa il **Model** (DB via JDBC), arricchisce la request con dati (attributi), e fa forward alla View.
4. La View renderizza i dati senza includere logica di business complessa (in questo progetto restano scriptlet per semplicità didattica).

---

## 4) Mappatura componenti e routing

### 4.1 Servlet (Controller) e relativi endpoint

- `mypackage.login`
  - Mapping: `@WebServlet("/login")`
  - `GET /login`:
    - Forward a `login.jsp` (visualizzazione form di login).
  - `POST /login`:
    - Autenticazione studente/professore.
    - Gestione delle due aree (studente, professore).

- `mypackage.Prenotazione`
  - Mapping: `@WebServlet("/Prenotazione")`
  - `POST /Prenotazione`:
    - Riceve l’`idcorso` (parametro `materia`).
    - Recupera il nome del corso e l’elenco degli appelli collegati.
    - Forward a `studente.jsp`.

- `mypackage.Prenota`
  - Mapping: `@WebServlet("/Prenota")`
  - `POST /Prenota`:
    - Riceve `idAppello` dalla form in `studente.jsp`.
    - Legge `matricola` dalla sessione.
    - Inserisce prenotazione, verifica duplicati, prepara dati di conferma.
    - Forward a `studente.jsp`.

- `mypackage.StampaStudenti`
  - Mapping: `@WebServlet("/StampaStudenti")`
  - `POST /StampaStudenti`:
    - Riceve `ID_appello` da `professore.jsp`.
    - Valida l’input (intero).
    - Recupera info appello + elenco studenti prenotati.
    - Forward a `professore.jsp`.

### 4.2 View (JSP)

- `GET /index.jsp`:
  - Home page di benvenuto (portale università).
  - Pulsante/Link “Accedi al portale” → `href="login"` (Servlet `login`).

- `login.jsp`:
  - Form di login (`action="login"`, `method="post"`).
  - Mostra eventuale `request.messaggio`.

- `studente.jsp`:
  - Accessibile solo se `session.matricola != null`, altrimenti redirect a `login.jsp`.
  - Consuma:
    - `request.tabella_corso` (`ResultSet` corsi),
    - `request.elenco_appelli` (`ResultSet` appelli),
    - `request.materia` (nome corso),
    - `request.successo`, `request.errore`, `request.data`, `request.materia2`.

- `professore.jsp`:
  - Accessibile solo se `session.nome` e `session.cognome` non sono null, altrimenti redirect a `index.jsp`.
  - Consuma:
    - `session.materia` (materia del corso),
    - `request.appelli` (`ResultSet`),
    - `request.elenco_studenti`, `request.Materia`, `request.Data`.

- `logout.jsp`:
  - Invalida la sessione (`session.invalidate()`).
  - `response.sendRedirect("index.jsp")`.

---

## 5) Flussi di dati principali

### 5.1 Autenticazione (Studente e Professore)

1. L’utente accede a `index.jsp` e clicca su “Accedi al portale”.
2. Il browser invia `GET /login` → Servlet `login.doGet` → forward a `login.jsp`.
3. L’utente invia credenziali con `POST /login` (`username`, `password`).
4. `login.doPost`:
   - **Validazione input**:
     - Se `username` o `password` sono null/vuoti:
       - imposta `request.messaggio = "Username e password sono obbligatori!"`;
       - forward a `login.jsp`.
   - **Autenticazione studente**:
     - Query con `PreparedStatement`:
       ```sql
       SELECT username, password, matricola
       FROM studente
       WHERE username = ? AND password = ?
       ```
     - Se match:
       - `session.matricola = matricola`.
       - Carica tutti i corsi (con docente) tramite `Statement`:
         ```sql
         SELECT idcorso, materia, nome, cognome
         FROM corso
         JOIN professore ON cattedra = idProfessore
         ORDER BY idcorso ASC
         ```
       - `request.tabella_corso = ResultSet` corsi.
       - Forward a `studente.jsp`.
   - **Autenticazione professore** (eseguita se blocco studente non ha avuto successo):
     - Query con `PreparedStatement`:
       ```sql
       SELECT username, password, idProfessore, nome, cognome
       FROM professore
       WHERE username = ? AND password = ?
       ```
     - Se match:
       - `session.idProfessore`, `session.nome`, `session.cognome`.
       - Carica corso/i associato/i al professore:
         ```sql
         SELECT idcorso, materia
         FROM corso
         WHERE cattedra = <idProfessore>
         ```
       - Salva in sessione `idcorso` e `materia`.
       - Carica appelli del corso:
         ```sql
         SELECT idAppello, data
         FROM appello
         WHERE materia = <idcorso>
         ```
       - `request.appelli = ResultSet` appelli.
       - `request.Materia = materia` (nome corso).
       - Forward a `professore.jsp`.
   - **Se nessun match** (né studente né professore):
     - `request.messaggio = "Credenziali errate!"`;
     - forward a `login.jsp`.

### 5.2 Flusso Studente: corsi → appelli → prenotazione

1. **Dopo login studente**, `studente.jsp` mostra:
   - tabella corsi (`request.tabella_corso`),
   - form per selezionare un corso (invia `materia = idcorso` a `/Prenotazione`).

2. Lo studente invia `POST /Prenotazione`:
   - `Prenotazione.doPost`:
     - Legge `idCorsoStr = request.getParameter("materia")`.
     - Converte in int: `int idCorso = Integer.parseInt(idCorsoStr)`.
     - Query 1 – corso:
       ```sql
       SELECT Materia
       FROM corso
       WHERE idcorso = ?
       ```
     - Se corso esiste:
       - Memorizza il nome materia.
       - Query 2 – appelli del corso:
         ```sql
         SELECT idAppello, Data
         FROM appello
         WHERE Materia = ?
         ```
       - `request.materia = nomeMateria`.
       - `request.elenco_appelli = ResultSet` appelli.
       - Forward a `studente.jsp` (sezione tabella appelli).
     - Se corso non esiste:
       - `request.errore = "Corso non trovato!"`;
       - Forward a `studente.jsp`.

3. In `studente.jsp`, lo studente visualizza gli appelli per il corso selezionato e invia `POST /Prenota` con `idAppello`.

4. Lo studente invia `POST /Prenota`:
   - `Prenota.doPost`:
     - Legge `idAppelloStr` da request, `matricola` da sessione.
     - Converte `idAppello` in int.
     - **Verifica duplicati**:
       ```sql
       SELECT COUNT(*)
       FROM prenotazione
       WHERE stud_prenotato = ? AND app_prenotato = ?
       ```
       - Se `COUNT(*) > 0`:
         - `request.errore = "Sei gia prenotato per questo appello"`;
         - forward a `studente.jsp`.
     - **Inserimento prenotazione**:
       ```sql
       INSERT INTO prenotazione(stud_prenotato, app_prenotato)
       VALUES (?, ?)
       ```
     - **Recupero data appello**:
       ```sql
       SELECT Data
       FROM appello
       WHERE idAppello = ?
       ```
       - Se nessun record:
         - `request.errore = "Appello non trovato!"`;
         - forward a `studente.jsp`.
     - **Recupero nome materia (join)**:
       ```sql
       SELECT c.Materia
       FROM appello a
       JOIN corso c ON a.Materia = c.idcorso
       WHERE a.idAppello = ?
       ```
     - Attributi verso `studente.jsp`:
       - `request.successo = "Prenotazione confermata!"`;
       - `request.data = dataScelta`;
       - `request.materia2 = nomeMateria`.

### 5.3 Flusso Professore: appelli → studenti prenotati

1. Dopo login professore, `professore.jsp` visualizza:
   - `session.materia` (materia del corso),
   - `request.appelli` (elenco appelli per quel corso),
   - form con `ID_appello` verso `/StampaStudenti`.

2. Il professore invia `POST /StampaStudenti`:
   - `StampaStudenti.doPost`:
     - Legge `idAppelloStr = request.getParameter("ID_appello")`.
     - Valida il formato numerico (`Integer.parseInt` con gestione `NumberFormatException`).
       - In caso di input non valido:
         - `request.error = "ID non valido"`;
         - forward a `professore.jsp`.
     - Query metadati appello + materia:
       ```sql
       SELECT a.Data, a.Materia, c.Cattedra AS nomeMateria
       FROM appello a
       LEFT JOIN corso c ON a.Materia = c.idcorso
       WHERE a.idAppello = ?
       ```
       - Se trovato:
         - `request.Materia = nomeMateria`;
         - `request.Data = Data`.
       - Se non trovato:
         - `request.error = "Appello non trovato"`;
         - forward a `professore.jsp`.
     - Query studenti prenotati:
       ```sql
       SELECT s.nome, s.cognome, s.Matricola
       FROM studente s
       JOIN prenotazione p ON s.Matricola = p.stud_prenotato
       WHERE p.app_prenotato = ?
       ```
       - `request.elenco_studenti = ResultSet` studenti.
     - Forward a `professore.jsp`.

3. `professore.jsp`:
   - Se `elenco_studenti` non è null:
     - Mostra intestazione null-safe:
       ```jsp
       <p>Per esame <strong><%= materia != null ? materia : "N/D" %></strong>
          in data <strong><%= Data != null ? Data : "N/D" %></strong></p>
       ```
     - Stampa tabella studenti prenotati.

---

## 6) Modello dati (dedotto dalle query)

Sulla base del codice e delle query, si deduce una base dati con le seguenti tabelle principali:

- `studente(
    Matricola PK,
    username,
    password,
    nome,
    cognome
  )`

- `professore(
    idProfessore PK,
    username,
    password,
    nome,
    cognome
  )`

- `corso(
    idcorso PK,
    Materia VARCHAR,
    cattedra FK → professore.idProfessore
  )`

- `appello(
    idAppello PK,
    Data DATE,
    Materia FK → corso.idcorso
  )`

- `prenotazione(
    id? PK (non utilizzato nel codice),
    stud_prenotato FK → studente.Matricola,
    app_prenotato FK → appello.idAppello
  )`

Nota: la colonna `appello.Materia` è utilizzata come **FK numerica** verso `corso.idcorso`, nonostante il nome possa suggerire un campo testuale.

---

## 7) Dettaglio dei componenti

### 7.1 `mypackage.Connessione`

- Responsabilità:
  - Inizializzare e mantenere una `java.sql.Connection` **statica** al database MySQL.
- Implementazione:
  ```java
  Class.forName("com.mysql.jdbc.Driver");
  con = DriverManager.getConnection(
      "jdbc:mysql://localhost:3306/universita", "root", "Root");
  ```
  - Metodo statico `getCon()` che restituisce sempre la stessa `Connection`.

**Criticità (rispetto agli standard attuali):**

- `Connection` statica condivisa tra tutte le Servlet → non thread-safe.
- Nessun **connection pool**, nessun `DataSource` JNDI.
- Nessun `try-with-resources` o chiusura sistematica delle risorse JDBC.
- Credenziali DB hardcoded nel codice.

**Best practice (didattica):**

- Utilizzare un **DataSource** configurato in Tomcat (`context.xml`), con pool (es. DBCP, HikariCP).
- Gestire ogni operazione in un blocco `try-with-resources` per chiudere connessioni, statement e resultset.
- Esternalizzare le credenziali e la stringa di connessione (file di configurazione, JNDI).

---

### 7.2 `mypackage.login` (`/login`)

- **Metodi**:
  - `doGet`:
    - Esegue:
      ```java
      request.getRequestDispatcher("login.jsp").forward(request, response);
      ```
    - Presenta il form di login tramite Controller (non accesso diretto alla JSP).
  - `doPost`:
    - Valida input `username` e `password` (null/empty).
    - Esegue **due blocchi logici** distinti:
      1. Autenticazione studente.
      2. (se necessario) Autenticazione professore.

- **Autenticazione studente**:
  - Query parametrizzata con `PreparedStatement`.
  - Allineata agli standard di sicurezza (prevenzione SQL injection).

- **Autenticazione professore**:
  - Query parametrizzata su `professore`.
  - Caricamento corso e appelli con `Statement` (su ID già validati).

- **Sessione**:
  - Studente: `matricola`.
  - Professore: `idProfessore`, `nome`, `cognome`, `idcorso`, `materia`.

- **View**:
  - In caso di successo studente → `studente.jsp`.
  - In caso di successo professore → `professore.jsp`.
  - In caso di errore credenziali → `login.jsp` con messaggio.

---

### 7.3 `mypackage.Prenotazione` (`/Prenotazione`)

- Input:
  - `materia` (che rappresenta l’`idcorso` selezionato in `studente.jsp`).
- Funzione:
  - Recuperare nome del corso e appelli relativi.
- Query:
  - Corso:
    ```sql
    SELECT Materia FROM corso WHERE idcorso = ?
    ```
  - Appelli:
    ```sql
    SELECT idAppello, Data
    FROM appello
    WHERE Materia = ?
    ```
- Output:
  - `request.materia` = nome corso.
  - `request.elenco_appelli` = elenco appelli (ResultSet).
  - Forward a `studente.jsp`.

- Gestione errori:
  - Se corso non trovato: `request.errore = "Corso non trovato!"`, forward a `studente.jsp`.

---

### 7.4 `mypackage.Prenota` (`/Prenota`)

- Input:
  - `idAppello` (da form in `studente.jsp`).
  - `matricola` (da `HttpSession`).
- Funzione:
  - Effettuare la prenotazione studente–appello.
  - Prevenire duplicati.
  - Fornire conferma dettagliata alla View.

- Passi chiave:

  1. **Verifica duplicati**:
     ```sql
     SELECT COUNT(*)
     FROM prenotazione
     WHERE stud_prenotato = ? AND app_prenotato = ?
     ```
     - Se `COUNT(*) > 0` → `request.errore = "Sei gia prenotato per questo appello"`.

  2. **Insert prenotazione**:
     ```sql
     INSERT INTO prenotazione(stud_prenotato, app_prenotato)
     VALUES (?, ?)
     ```

  3. **Recupero data appello**:
     ```sql
     SELECT Data
     FROM appello
     WHERE idAppello = ?
     ```
     - Se nessun record → `request.errore = "Appello non trovato!"`.

  4. **Recupero nome materia (join)**:
     ```sql
     SELECT c.Materia
     FROM appello a
     JOIN corso c ON a.Materia = c.idcorso
     WHERE a.idAppello = ?
     ```

  5. **Attributi verso `studente.jsp`**:
     - `successo = "Prenotazione confermata!"`
     - `data = dataScelta`
     - `materia2 = nomeMateria`

---

### 7.5 `mypackage.StampaStudenti` (`/StampaStudenti`)

- Input:
  - `ID_appello` (form in `professore.jsp`).
- Funzione:
  - Dato un id appello, mostrare materia, data e studenti prenotati.

- Validazione:
  - Parsing di `ID_appello` come intero con gestione `NumberFormatException`.
  - Se non valido → `request.error = "ID non valido"`.

- Query metadati appello + materia (LEFT JOIN):
  ```sql
  SELECT a.Data, a.Materia, c.Cattedra AS nomeMateria
  FROM appello a
  LEFT JOIN corso c ON a.Materia = c.idcorso
  WHERE a.idAppello = ?
  ```

- Query studenti prenotati:
  ```sql
  SELECT s.nome, s.cognome, s.Matricola
  FROM studente s
  JOIN prenotazione p ON s.Matricola = p.stud_prenotato
  WHERE p.app_prenotato = ?
  ```

- Output:
  - `request.Materia` = `nomeMateria`.
  - `request.Data` = data appello.
  - `request.elenco_studenti` = ResultSet studenti.
  - Forward a `professore.jsp`.

- Errori:
  - Appello non trovato → `request.error = "Appello non trovato"`.
  - Errore DB → `request.error = "Errore DB: <dettaglio>"`.

---

### 7.6 View (JSP)

- **`index.jsp`**:
  - Home responsiva in UTF‑8.
  - Link a `login` (Servlet) per accesso al portale.

- **`login.jsp`**:
  - Form login (`POST /login`).
  - Visualizza `request.messaggio` in caso di errore.

- **`studente.jsp`**:
  - Vincolo: `session.matricola` deve essere valorizzata, altrimenti redirect a `login.jsp`.
  - Consuma:
    - `tabella_corso` (ResultSet corsi),
    - `elenco_appelli` (ResultSet appelli),
    - `materia` (nome corso),
    - `successo`, `errore`, `data`, `materia2`.
  - Mostra:
    - Tabella corsi con docenti.
    - Tabella appelli con pulsante “CONFERMA PRENOTAZIONE”.
    - Messaggi di successo/errore sulla prenotazione.

- **`professore.jsp`**:
  - Vincolo: `session.nome` e `session.cognome` devono essere valorizzate.
  - Consuma:
    - `session.materia`,
    - `appelli` (ResultSet),
    - `elenco_studenti` (ResultSet),
    - `Materia`, `Data`.
  - Fix per visualizzazione null-safe:
    ```jsp
    <p>Per esame <strong><%= materia != null ? materia : "N/D" %></strong>
       in data <strong><%= Data != null ? Data : "N/D" %></strong></p>
    ```

- **`logout.jsp`**:
  - `session.invalidate()`.
  - `response.sendRedirect("index.jsp")`.

---

## 8) Gestione della sessione e sicurezza

- **Sessione (`HttpSession`)**:
  - Attributi principali:
    - Studente: `matricola`.
    - Professore: `idProfessore`, `nome`, `cognome`, `idcorso`, `materia`.
  - Invalida tramite `logout.jsp`.

- **Sicurezza applicativa (stato attuale)**:
  - Autenticazione con `PreparedStatement` su credenziali.
  - Password memorizzate in chiaro nel DB.
  - Nessun hashing (es. BCrypt).
  - Nessuna protezione CSRF.
  - Nessuna gestione avanzata di session fixation (non viene rigenerato l’ID sessione al login).
  - `ResultSet` passati direttamente alla View.

---

## 9) Gestione errori e logging

- **Errori JDBC**:
  - Generalmente gestiti con `printStackTrace()` o rilancio di `RuntimeException`.
  - In `StampaStudenti`, gli errori DB sono trasformati in messaggio funzionale (`request.error`).

- **Errori funzionali**:
  - Login:
    - Messaggi `"Username e password sono obbligatori!"` e `"Credenziali errate!"`.
  - Prenotazione:
    - `"Corso non trovato!"`, `"Appello non trovato!"`, `"Sei gia prenotato per questo appello"`.
  - Stampa studenti:
    - `"ID non valido"`, `"Appello non trovato"`, `"Errore DB: ..."`.

- **Logging strutturato**:
  - Non presente (nessun uso di SLF4J/Logback).

---

## 10) Criticità e debito tecnico

- **Persistenza/JDBC**:
  - `Connection` statica in `Connessione`.
  - Mancanza di connection pool.
  - Assenza di `try-with-resources`.
  - Passaggio di `ResultSet` alle JSP.

- **View**:
  - Uso esteso di scriptlet JSP (non in linea con standard moderni che favoriscono JSTL/EL).
  - Encoding non uniforme (UTF‑8 vs ISO‑8859‑1).

- **Sicurezza**:
  - Password in chiaro nel database.
  - Mancanza di protezione CSRF.
  - Nessuna rigenerazione ID sessione dopo login.

---

## 11) Raccomandazioni (allineamento a standard attuali)

- **Driver e connessione**:
  - Migrare da `com.mysql.jdbc.Driver` a `com.mysql.cj.jdbc.Driver`.
  - Configurare un **DataSource JNDI** in Tomcat e utilizzare un **connection pool**.

- **Strato di accesso dati**:
  - Introdurre un livello **DAO/Repository** per entità (Studente, Professore, Corso, Appello, Prenotazione).
  - Mappare i `ResultSet` in DTO/POJO e passare questi oggetti alle JSP, invece dei `ResultSet`.

- **Gestione risorse JDBC**:
  - Usare `try-with-resources` sistematicamente.
  - Evitare la `Connection` statica.

- **Sicurezza**:
  - Hash delle password (es. BCrypt).
  - Rigenerazione dell’ID sessione al login.
  - Token CSRF per form sensibili.

- **View**:
  - Migrare da scriptlet a JSTL/EL.
  - Uniformare charset a UTF‑8 per tutte le JSP.

---

## 12) Requisiti di deployment e configurazione

- Application Server: Apache Tomcat (versione compatibile con Servlet 3.0+).
- Database: MySQL, accessibile su `localhost:3306`, schema `universita`.
- Driver JDBC MySQL presente in `WEB-INF/lib`.

---

## 13) Metriche di qualità e criteri di accettazione

- **Correttezza funzionale**:
  - Login studente/professore con gestione di credenziali valide/errate.
  - Visualizzazione corsi e appelli coerente con contenuto DB.
  - Prenotazioni inserite correttamente in tabella `prenotazione`.
  - Elenco studenti prenotati corretto per ogni appello.

- **Robustezza**:
  - Validazione parametri numerici (`ID_appello`, `idAppello`, `idcorso`).
  - Gestione dei casi “record non trovato” senza eccezioni non gestite.
  - Prevenzione prenotazioni duplicate (`Prenota`).

---

## 14) Assunzioni e punti aperti

- **Assunzioni**:
  - Schema DB conforme alle tabelle dedotte in §6.
  - Integrità referenziale tra `corso`, `appello`, `prenotazione`.

- **Punti aperti**:
  - Versioni effettive di Java, Tomcat e MySQL.
  - Uniformazione completa a UTF‑8.
  - DDL ufficiale del DB (non presente nel progetto).

---

## 15) Modifiche apportate e problemi risolti

Questa sezione riassume **solo** le modifiche effettivamente introdotte nel codice e i problemi conseguentemente risolti.

### 15.1 Separazione Home/Login e routing iniziale (11/02/2026)

- **Problema**:
  - Il form di login era esposto direttamente come pagina iniziale, senza separazione chiara tra home e login.

- **Soluzione**:
  - Introduzione di `index.jsp` come Home (benvenuto + link ad area autenticata).
  - `login.jsp` diventa view dedicata al form di autenticazione.
  - `login.doGet` effettua il forward a `login.jsp` (entry-point controller-driven).

- **Beneficio**:
  - Flusso più aderente al pattern MVC: richiesta → Controller (`login`) → View (`login.jsp`).

---

### 15.2 Refactoring login: PreparedStatement e validazione input (12/02/2026)

- **Problemi risolti**:
  - Eliminata scansione manuale delle tabelle con confronti in memoria.
  - Ridotto rischio di SQL injection in fase di autenticazione.
  - Introdotta validazione `null/empty` di `username` e `password`.

- **Cambiamenti principali (`mypackage.login`)**:
  - Autenticazione studente:
    ```sql
    SELECT username, password, matricola
    FROM studente
    WHERE username = ? AND password = ?
    ```
  - Autenticazione professore:
    ```sql
    SELECT username, password, idProfessore, nome, cognome
    FROM professore
    WHERE username = ? AND password = ?
    ```

- **Nota didattica**:
  - L’uso di `PreparedStatement` è lo standard per prevenire SQL injection e per separare chiaramente il codice Java dai dati utente.
  - La sessione (`HttpSession`) consente di mantenere lo stato autenticato tra richieste HTTP stateless.

---

### 15.3 Refactoring Prenotazione: rimozione `CAST`, `setInt` e controllo corso non trovato (13/02/2026)

- **Problemi risolti**:
  - Rimozione di `CAST(? AS UNSIGNED INTEGER)` nelle query (`DB-specific` e potenzialmente fragile).
  - Migliore gestione del caso in cui il corso non esista.
  - Tipizzazione forte dei parametri (`setInt` su `PreparedStatement`).

- **Cambiamenti (`mypackage.Prenotazione`)**:
  - Parsing `materia` → `idCorso` come intero.
  - Query:
    ```sql
    SELECT Materia FROM corso WHERE idcorso = ?
    SELECT idAppello, Data FROM appello WHERE Materia = ?
    ```
  - Gestione caso “Corso non trovato!” con attributo `errore` e forward a `studente.jsp`.

---

### 15.4 Fix Prenota: controllo duplicati e join corretta per materia (14/02/2026)

- **Problemi risolti**:
  - Possibilità di prenotazioni duplicate dello stesso studente sullo stesso appello.
  - Errore logico nel recupero del nome materia a partire dall’`idAppello`.

- **Cambiamenti (`mypackage.Prenota`)**:
  - **Verifica duplicati**:
    ```sql
    SELECT COUNT(*)
    FROM prenotazione
    WHERE stud_prenotato = ? AND app_prenotato = ?
    ```
  - **Insert prenotazione**:
    ```sql
    INSERT INTO prenotazione(stud_prenotato, app_prenotato) VALUES (?, ?)
    ```
  - **Recupero data appello**:
    ```sql
    SELECT Data FROM appello WHERE idAppello = ?
    ```
  - **Recupero materia con JOIN**:
    ```sql
    SELECT c.Materia
    FROM appello a
    JOIN corso c ON a.Materia = c.idcorso
    WHERE a.idAppello = ?
    ```

---

### 15.5 Refactoring StampaStudenti: validazione ID e gestione casi negativi (14/02/2026)

- **Problemi risolti**:
  - Input numerico non validato (`ID_appello`).
  - Logica SQL complessa e poco leggibile.
  - Mancata distinzione tra “appello non trovato” ed errori DB generici.

- **Cambiamenti (`mypackage.StampaStudenti`)**:
  - Validazione `ID_appello` con `Integer.parseInt` e gestione `NumberFormatException`.
  - Query più leggibili per metadati appello e elenco studenti.
  - Attributi di errore differenziati:
    - `"ID non valido"`, `"Appello non trovato"`, `"Errore DB: ..."`.
  - Forward sempre verso `professore.jsp` (View centralizzata per il professore).

---

### 15.6 Fix visualizzazione “Per esame null” in `professore.jsp` (14/02/2026)

- **Problema**:
  - In alcuni casi `professore.jsp` mostrava `"Per esame null"` a causa di attributi non valorizzati (`Materia` e/o `Data`).

- **Soluzione**:
  - Gestione **null-safe** degli attributi in JSP:

  ```jsp
  <p>Per esame <strong><%= materia != null ? materia : "N/D" %></strong>
     in data <strong><%= Data != null ? Data : "N/D" %></strong></p>
  ```

- **Effetto**:
  - L’interfaccia non mostra più valori `null`, ma un placeholder neutro (`"N/D"`), migliorando l’esperienza utente e la robustezza della View nel pattern MVC.

---
### 15.7 Fix Case-Sensitive Login 16/02/2026
- **Problema**:

Collation: utf8mb3_general_ci su username/password
→ "Admin" = "admin" → TRUE (case-insensitive)
- **Soluzione**:
  BINARY operator forza comparazione byte-per-byte:

  - PRIMA (Case-Insensitive)
    WHERE username = ? AND password = ?
    DOPO (Case-Sensitive)
    WHERE BINARY username = ? AND BINARY password = ?
  
  - RISULTATO: "TestUser/Pass123" OK, "testuser/Pass123" ❌
    NO ALTER TABLE, PreparedStatement anti-SQL injection
---
### 15.8 Fix Bottone INDIETRO Condizionale 16/02/2026
- **Problema**:
- INDIETRO visibile anche pagina principale post-login
- - **Soluzione**:
-  `ResultSet != null` = pagina secondaria
 Studente.jsp
<% if(res1 != null && materia != null) { %> <!-- Appelli -->
<% if(elenco != null) { %> <!-- Studenti -->
    <button onclick="history.back()">INDIETRO</button>
Professore.jsp
<% if(appelli != null || elenco != null) { %> <!-- Header -->
<% if(elenco != null) { %> <!-- Sezione studenti -->
    <button onclick="history.back()">INDIETRO</button>
---
### 15.9 Bottoni Appelli Dinamici 16/02/2026 ref (15.5)
Problema:

Input number manuale soggetto a errori digitazione

Utente deve conoscere ID appelli a memoria

UX poco intuitiva

Soluzione:

Sostituito form input → bottoni dinamici da ResultSet appelli

Posizione: Dentro.materia-info dopo <p>Appelli disponibili</p>

Logica: appelli.first() → do-while(appelli.next()) genera form per ogni appello

HTML: <input type="hidden" name="ID_appello"> + class="prenota-btn" (CSS verde)

Risultato: [Appello 2019-12-25] [Appello YYYY-MM-DD] cliccabili → StampaStudenti servlet

Verifica: ID=1 → 6 studenti corretti dal DB (12345,2,1,1,12500,23399) ✅

### 15.10 Implementazione sicurezza

**studente.jsp:**
if(session.getAttribute("tipo_utente") == null || !"s".equals(...))
response.sendRedirect("login.jsp"); return;

**professore.jsp:**
if(session.getAttribute("tipo_utente") == null || !"p".equals(...))
response.sendRedirect("login.jsp"); return;

---
### 15.11 ANALISI CRITICA - Gestione Identità e Collisioni (16/02/2026)
STATO ATTUALE: "First-match-wins"
Il sistema soffre di un'anomalia logica dovuta alla separazione delle tabelle studente e professore. 
Poiché lo username non è univoco a livello globale, credenziali identiche in entrambe le tabelle causano un errore di precedenza: 
il sistema logga l'utente come "studente" per default, rendendo inaccessibile l'account "professore" con le stesse credenziali.

ANOMALIA STRUTTURALE (Violazione 1NF):
Tabella Studente: PK=matricola, username='mrossi'
Tabella Professore: PK=idProfessore, username='mrossi'
Risultato: Collisione delle credenziali e ambiguità del ruolo.

ROADMAP DI MIGLIORAMENTO (In fase di valutazione):
Per risolvere questa ambiguità senza stravolgere il database legacy (evitando di rifare le JOIN e le chiavi esterne), la strategia pianificata è la Separazione dei flussi:
Punto di accesso unico (Future Update): Implementazione di un selettore di ruolo (Radio Button) nel frontend per indirizzare la query sulla tabella corretta ed eliminare le collisioni.
Suffissi di sicurezza: Ipotesi di gestione in fase di registrazione per differenziare gli account (es. user_s per studenti e user_p per professori).
CONCLUSIONE:
Nonostante il limite strutturale del database, il codice attuale garantisce la stabilità del sistema per la quasi totalità dei casi, isolando le logiche di popolamento dei dati per i due ruoli.

### 15.11.1 - Analisi e Risoluzione del Conflitto di Identità (16/02/2026)
SITUAZIONE INIZIALE
In fase di collaudo della logica di autenticazione, è stata confermata una vulnerabilità logica derivante dalla struttura del database legacy. 
La separazione delle tabelle studente e professore non garantiva l'univocità degli username a livello globale.

Impatto: In presenza di credenziali identiche in entrambe le tabelle, il sistema applicava una logica "First-match-wins", 
autenticando l'utente esclusivamente con il ruolo definito nel primo blocco di istruzioni (Studente), rendendo di fatto inaccessibile il profilo Docente.

SOLUZIONE ARCHITETTURALE
Per preservare l'integrità del database esistente e non alterare i vincoli di integrità referenziale (chiavi esterne e JOIN), 
si è optato per l'implementazione di una Logica di Instradamento Deterministica (Deterministically Routed Authentication).

Dettagli Tecnici dell'Implementazione:
Frontend (Input Shifting): Inserimento nel form di login di un selettore di ruolo (Radio Button) che vincola l'utente alla dichiarazione esplicita del proprio ambito di accesso.

Backend (Conditional Branching): La Servlet login.java è stata rifattorizzata per agire come deviatore di flusso. 
Attraverso il parametro ruolo, il sistema indirizza la richiesta esclusivamente alla tabella di competenza, eliminando alla radice ogni possibilità di collisione o ambiguità di identità.
Security & Data Cleaning: Introduzione del metodo trim() per la normalizzazione dei dati in ingresso e utilizzo di equalsIgnoreCase per rendere il processo di validazione 
immune a discrepanze di Case Sensitivity tra il frontend e la logica di controllo.

RISULTATO FINALE
L'architettura è stata messa in sicurezza. Anche in presenza di dati duplicati nel database, l'integrità dell'accesso e la corretta attribuzione dei privilegi sono garantite al 100%. 
Il modulo di login è passato da un'esecuzione sequenziale a una struttura modulare e manutenibile.
---
### 15.12 Predisposizione funzionalita agiuntive (17/02/2026)
professore.jsp
<-- WIP -->
<form action = "AggiungiAppello" method = "post" >
<button type = "submit" class= "logout" > aggiungi appello </button>
</form>
<-- WIP -->
<form action = "CancellaAppello" method = "post" >
<button type = "submit" class= "logout" > cancella appello  </button>
</form>

---
### 15.13 Modifica Schema Database (18/02/2026)
**Problema**
Nessun vincolo di unicità su prenotazioni multiple studente+appello

**Soluzione**

ALTER TABLE prenotazione
ADD CONSTRAINT unique_stud_app
UNIQUE KEY (stud_prenotato, app_prenotato);

**Effetto**
Previene duplicati a livello database
Abilita INSERT IGNORE (Task 15.14)
Garantisce integrità referenziale

Verifica:
SHOW CREATE TABLE prenotazione → UNIQUE constraint visibile
Test race condition → NO errore constraint violation
Status: MODIFICA DB APPLICATA E VERIFICATA

---
### 15.14 Gestione Concorrenza Transazionale (18/02/2026)
**Problema**: Rischio race condition su prenotazioni concorrenti

**Soluzione** 
(mypackage.Prenota):

INSERT IGNORE INTO prenotazione(stud_prenotato,app_prenotato) VALUES (?,?)
Mantiene checkDup pre-esistente per UX

**Risultato**
Browser A: 1 riga inserita
Browser B: 0 righe (duplicato ignorato)
Test 2 browser simultanei: PASSATO
---
### 15.15 Chiusura Risorse JDBC (18/02/2026)
**Problema**: Memory leak critiche (NO close()) in login 
**OLD**: Statement/ResultSet aperti → Tomcat crash

**Soluzione** 
- `rs.close()` PRIMA `pstmt.close()` [PADRE-FIGLIO]
**Risultato**: zero leak

---

### 15.16 Sicurezza Sessioni + Logout (18/02/2026)
**Problema**: Sessioni potenzialmente vulnerabili a XSS + timeout non configurato

**Soluzione** 
(web.xml):
<session-config>
<session-timeout>30</session-timeout>
<cookie-config>
<http-only>true</http-only>
</cookie-config>
</session-config>
**Risultato**:
<session-timeout>30: Sessione scade dopo 30 minuti inattività → auto-logout
<http-only>true: Cookie JSESSIONID non leggibile da JavaScript → anti-XSS

**Verifica**
F12 → Application → Cookies → JSESSIONID → HttpOnly ✓
console.log(document.cookie) → undefined (JSESSIONID nascosto)
35min inattività → Ril login obbligatorio
Risultato: Sessioni protette da furto cookie + auto-logout sicurezza
---
### 15.17  MVC Logout: (18/02/2026)
**Problema**
Logica di logout implementata in logout.jsp (violazione MVC). Utilizzo di link GET (<a href="logout.jsp">) vulnerabile a CSRF. Scriptlet session.invalidate() direttamente nella View.

1. LogoutServlet.java (Controller):
@WebServlet("/Logout")
public class Logout extends HttpServlet {
protected void doPost(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException {
HttpSession session = request.getSession(false);
if (session != null) session.invalidate();
response.sendRedirect("index.jsp");
}
}

2. Sostituzione nei file JSP (View):
<form method="POST" action="Logout" style="display:inline;">
    <button type="submit" class="logout">Logout</button>
</form>

3. Eliminazione file logout.jsp
**Risultato**
Implementazione MVC corretta con separazione Controller (LogoutServlet)-View (form POST). Logout tramite POST (protezione CSRF). Logica centralizzata.
**Verifica**
Accesso Studente → clic Logout → redirect index.jsp (sessione invalidata)
Accesso Professore → clic Logout → redirect index.jsp (sessione invalidata)
/logout.jsp → HTTP 404
Network tab: POST /Logout → 302 Redirect → index.jsp
Risultato: Logout conforme MVC, sicuro (POST-only), centralizzato e manutenibile.
---
### 15.18 Uso di scriptlet nelle JSP invece di JSTL/EL. (18/02/2026)
**problema**
Problema: Scriptlet <% %> ed espressioni <%= %> in JSP (anti-pattern).
**Soluzione wip**
Inserimento Libreria JSTL --wip--
 jstl-1.2.jar → WEB-INF/lib/ + taglib prefix="c".
Verifica: Tomcat 9.0.115 startup pulito (785ms), no taglib errors.
Risultato: <c:out>, <c:if>, <c:forEach> disponibili.

### 15.19  Storage delle password: (18/02/2026)
**problema**
Memorizzazione in chiaro nel database (Plaintext)
**risoluzione (Pianificata/WIP)**
Analisi dell'implementazione di algoritmi di hashing forte (es. BCrypt o Argon2) con l'aggiunta di un salt univoco per utente.
Risultato attuale
Per questa release, il sistema mantiene le password in chiaro per facilitare il debugging e la gestione del database in fase di sviluppo. 
Nota di sicurezza: Nel prodotto finale questa funzionalità sarebbe la priorità assoluta 

### 15.20 Leggera modifica db (19/02/2026)
 **Nota di sviluppo**
  Modifica lunghezza varchar(5) username to varchar(20). 
  a seguito di questa modifica si prega di prestare particolare attenzione al punto 15.18 della doc per evitare violazioni di sistema
  **VERIFICATO:**
  Matricola=PRI (PK) , username=UNI (NON presente)
  ALTER TABLE necessario "ALTER TABLE studente ADD UNIQUE(username)"
  DESC studente 
  Matricola: PRI (PK) 
  username: UNI (UNIQUE constraint)  : AGGIUNTO!
  INSERT IGNORE ora gestisce automaticamente duplicati username pronto per DAO
  


### 15.21 Inizio transazione modello DTO/DAO per scopo Ditattico e crescita personale (19/02/2026)
**IMPLEMENTAZIONE REGISTRAZIONE STUDENTI**
**Problema**
Mancanza funzionalità registrazione utenti nel sistema. 
Necessità di implementare pattern DTO/DAO per gestire registrazione studenti mantenendo separazione responsabilità MVC.
**Soluzione implementata (RegistrazioneDaoImpl + RegistrazioneDTO):**
1. DTO: RegistrazioneDTO
  - Campi: Matricola(Integer), username, password, tipo_utente, nome, cognome
  - Getter/setter allineati schema DB "studente"

2. DAO: RegistrazioneDaoImpl implements RegistrazioneDAOInterface
  - Metodo: public boolean registra(RegistrazioneDTO utente)
  - INSERT IGNORE + UNIQUE constraint (DB verificato)
  - try-with-resources + SQLException handling
**Query principale:**
  - INSERT IGNORE INTO studente (Matricola,username,password,tipo_utente,nome,cognome)
    VALUES (?,?,?,?,?,?)
**TEST** reference file path('WEB-INF/TESTREG.java ) **rimosso**
  Output Main:
- username duplicato → righe=0 → return false
- Matricola duplicata (PK) → righe=0 → return false
- Record nuovo → righe=1 → return true
- Errori DB → catch SQLException → return false
- RegistrazioneDaoImpl + RegistrazioneDTO ✅
  INSERT IGNORE + UNIQUE constraints ✅
  try-with-resources Connection ✅
  SQLException handling ✅



## 16) Sintesi: problemi risolti vs debito tecnico residuo

### 16.1 Problemi risolti (verificati sul codice)

- ✅ Autenticazione con `PreparedStatement` e query `WHERE` per studenti e professori.
- ✅ Validazione di base dei parametri (`username`, `password`, `ID_appello`).
- ✅ Correzione logica in Prenotazione (rimozione `CAST`, tipizzazione corretta).
- ✅ Correzione logica in Prenota (controllo duplicati, join corretta materia–appello).
- ✅ Hardening di StampaStudenti con distinzione dei casi d’errore.
- ✅ Fix di visualizzazione “Per esame null” in `professore.jsp`.
- ✅ Gestione Case-Sensitivity: Implementazione operatore BINARY per distinguere maiuscole/minuscole nel login.
- ✅ Risoluzione Conflitti Identità: Introduzione selettore di ruolo (Radio Button) per gestire username duplicati tra diverse tabelle.
- ✅ Security Check di Sessione: Controllo dei permessi (tipo_utente) per impedire l'accesso diretto alle pagine tramite URL.
- ✅ Ottimizzazione Query: Sostituzione di scansioni manuali con JOIN SQL e COUNT(*) per migliorare le performance del database.
- ✅ Miglioramento UX: Sostituzione input numerici manuali con bottoni dinamici generati dal ResultSet degli appelli.
- ✅ Refactoring Manutenibilità: Bonifica totale del codice legacy con rimozione di variabili non auto-esplicative (ex s1, s2) e commenti obsoleti.
- ✅ Normalizzazione Flusso MVC: Separazione netta tra logica di controllo (Servlet) e visualizzazione (JSP) con gestione corretta del RequestDispatcher.
- ✅ Gestione Concorrenza Transazionale: Risoluzione race condition con INSERT IGNORE su prenotazione(stud_prenotato, app_prenotato) + mantenimento checkDup per UX.
- ✅ Hardening Database: Aggiunta UNIQUE constraint (stud_prenotato, app_prenotato) per garantire integrità referenziale e abilitare atomicità INSERT IGNORE.
- ✅ Chiusura Risorse JDBC: Eliminati memory leak login (rs.close() prima pstmt.close())
- ✅ MVC Logout: Rimozione logout.jsp → implementazione LogoutServlet con session.invalidate() 
- ✅ DTO/DAO Registrazione: INSERT IGNORE testato RegistrazioneDTO.java ✅ RegistrazioneDAOInterface.java ✅ RegistrazioneDaoImpl.java ✅. modulo isolato

### 16.2 Debito tecnico residuo

- ☐ `Connessione` con `Connection` statica e driver JDBC legacy (migrabile a `com.mysql.cj.jdbc.Driver`).
- ☐ Mancanza di connection pooling e utilizzo sistematico di `try-with-resources` su tutte le Servlet (parziale: chiusura risorse introdotta in alcuni punti, da estendere ovunque).
- ☐ Passaggio di `ResultSet` dal Controller alla View (accoppiamento forte: da sostituire con DTO/POJO e JSTL/EL).
- ☐ Uso esteso di scriptlet nelle JSP invece di JSTL/EL (libreria predisposta, migrazione logica ancora da completare).
- ☐ Password memorizzate in chiaro nel DB (hashing con BCrypt/Argon2 da pianificare).

---

## 17) Conclusioni

L’applicazione realizza una **architettura MVC semplificata** basata su:

- **Servlet** come Controller (`login`, `Prenotazione`, `Prenota`, `StampaStudenti`, `Logout`),
- **JSP** come View (`index.jsp`, `login.jsp`, `studente.jsp`, `professore.jsp`),
- **JDBC** per l’accesso diretto al DB MySQL (`Connessione`).

Gli interventi recenti hanno risolto in modo verificato criticità funzionali e di sicurezza di base: 
gestione prenotazioni duplicate (vincolo UNIQUE + INSERT IGNORE), validazioni input robuste, hardening delle query con `PreparedStatement`, 
routing logout conforme al pattern MVC con richiesta POST e invalidazione sicura della sessione, oltre a miglioramenti di UX (bottoni dinamici, messaggi null-safe) 
E di gestione delle identità (selettore di ruolo, case-sensitivity).

Permane un fisiologico 
**debito tecnico didattico** 
legato allo strato di persistenza e alla View (Connection statica senza pool, **scriptlet [JSTL libreria inserita (15.18), conversione in corso]**,
assenza di DAO/DTO e hashing password).

Questi aspetti rappresentano la naturale prossima fase di evoluzione verso uno stack più aderente agli standard attuali 
(DataSource JNDI con pooling, DAO/Repository, DTO, JSTL/EL, sicurezza avanzata).
"JSTL libreria inserita (15.18), conversione scriptlet → <c:out> in corso."










### 25 IO 
illuminazione ieri alle ore 1.35 am studiato per 1 mese gli oggetti potevi arrivarci prima che potevi applicarli nel web.
nota per il futuro, sei un cretino hai avuto quelle 6 lettere davanti gli occhi tutto il tempo hai fatto ricerche su tutto meno che quelle (dto/dao) 
