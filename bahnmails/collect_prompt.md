## Gmail search criteria
- from:
  - bahn.de
  - deutschebahn.com
- subject:
  - Buchungsbestätigung
  - booking confirmation
  - more:
    - Reservation confirmation
    - cancellation
- date:
  - after:2022/01/01
  - before:2025/02/01

from:("bahn.de" OR "deutschebahn.com") subject:("Buchungsbestätigung" OR "booking confirmation") before:2025/02/01 after:2022/01/01

## Collab + GPT4.o
SYSTEM_PROMPT = 
"You are a helpful assistant that collects data from emails."

PROMPT =
Here is a booking confirmation from Deutsche Bahn. Please arrange the following key information in a csv table with the header: date, departure_time, departure_station, arrival_time, arrival_station, price, booking_timestamp, order_number


## Ollama + Deepseek R1 distilled
ollama pull deepseek-r1:1.5b
ollama run deepseek-r1:1.5b

ollama run deepseek-r1:1.5b "Please arrange the key information in a table. The table's header is: date, departure_time, departure_station, arrival_time, arrival_station, price, booking_timestamp, order_number $(cat file.html)"

I will give you a booking confirmation email from Deutsche Bahn. Please arrange the key information in a table. The table's header is: date, departure_time, departure_station, arrival_time, arrival_station, price, booking_timestamp, order_number

### Example:
"""Please make a table of the key information. Use the headers "journey_name" and "duration".  

Berlin, Hamburg, and Munich are three major cities in Germany, each offering a unique experience. The distance from **Berlin to Hamburg** is **289 km**, with a driving time of **2 hours and 50 minutes** via the A24. Traveling from **Berlin to Munich** covers **585 km** and takes **5 hours and 44 minutes** via the A9. The journey from **Hamburg to Munich** spans **775 km**, requiring **7 hours and 18 minutes** via the A7. These routes provide a scenic drive through Germany, connecting its vibrant urban centers."""