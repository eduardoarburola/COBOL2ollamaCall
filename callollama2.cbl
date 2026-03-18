IDENTIFICATION DIVISION.
       PROGRAM-ID. OllamaCall.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ResponseFile ASSIGN TO "/tmp/ollama_response.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD ResponseFile.
       01 ResponseLine    PIC X(4096).

       WORKING-STORAGE SECTION.
       01 WS-CMD          PIC X(512).
       01 WS-RESPONSE     PIC X(4096) VALUE SPACES.

       PROCEDURE DIVISION.

           MOVE 'curl -s -X POST http://192.168.100.130:11434/api/generate '
             & '-H "Content-Type: application/json" '
             & '-d "{\"model\":\"tinyllama:latest\",\"prompt\":\"Analiza el riesgo de un cliente que quiere un prestamo de 1000 euros a 5% de interes y lo quiere pagar en 12 meses , este cliente gana 2000 euros al mes y gasta 1800 euros cada mes\",\"stream\":false}" '
             & '> /tmp/ollama_response.txt'
             TO WS-CMD

           CALL "SYSTEM" USING WS-CMD

           OPEN INPUT ResponseFile
           READ ResponseFile INTO WS-RESPONSE
               AT END MOVE 'No response received' TO WS-RESPONSE
           END-READ
           CLOSE ResponseFile

           CALL "SYSTEM" USING "rm -f /tmp/ollama_response.txt"

           DISPLAY "=== Respuesta de Ollama ==="
           DISPLAY WS-RESPONSE

           STOP RUN.